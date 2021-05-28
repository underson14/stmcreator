import codecs
import json
import base64
import mutagen
import mutagen.mp4
import mutagen.id3
import urllib2 as urllib
import os
import platform
import subprocess
import sys

stemDescription  = 'stem-meta'
stemOutExtension = ".mp4"

_windows = platform.system() == "Windows"

_supported_files_no_conversion = [".m4a", ".mp4", ".m4p"]
_supported_files_conversion = [".wav", ".wave", ".aif", ".aiff", ".mp3", ".flac"]
_supported_files = _supported_files_no_conversion + _supported_files_conversion

def _removeFile(path):
    if os.path.lexists(path):
        if os.path.isfile(path):
            os.remove(path)
        else:
            raise RuntimeError("Cannot remove " + path + ": not a file")

def _getProgramPath():
    folderPath = os.path.dirname(os.path.realpath(__file__))
    if os.path.isfile(folderPath):
        # When packaging the script with py2exe, os.path.realpath returns the path to the object file within
        # the .exe, so we have to apply os.path.dirname() one more time
        folderPath = os.path.dirname(folderPath)
    return folderPath


class StemCreator:

    _defaultMetadata = [
        {"name": "Drums" , "color" : "#FF0000"},
        {"name": "Bass"  , "color" : "#00FF00"},
        {"name": "Synths", "color" : "#FFFF00"},
        {"name": "Other" , "color" : "#0000FF"}
    ]

    def __init__(self, mixdownTrack, stemTracks, fileFormat, metadataFile = None, tags = None):
        self._mixdownTrack = mixdownTrack
        self._stemTracks   = stemTracks
        self._format       = fileFormat if fileFormat else "libfdk_aac"
        self._tags         = json.load(open(tags)) if tags else {}

        # Mutagen complains gravely if we do not explicitly convert the tag values to a
        # particular encoding. We chose UTF-8, others would work as well.
        for key, value in self._tags.iteritems(): self._tags[key] = value.encode('utf-8')

        metaData = []
        if metadataFile:
            fileObj = codecs.open(metadataFile, encoding="utf-8")
            try:
                metaData = json.load(fileObj)
            except IOError:
                raise
            except Exception as e:
                raise RuntimeError("Error while reading metadata file")
            finally:
                fileObj.close()

        numStems       = len(stemTracks)
        numMetaEntries = len(metaData["stems"])

        self._metadata = metaData

        # If the input JSON file contains less metadata entries than there are stem tracks, we use the default
        # entries. If even those are not enough, we pad the remaining entries with the following default value:
        # {"name" : "Stem_${TRACK#}", "color" : "#000000"}

        if numStems > numMetaEntries:
            print("faltando metadata para stems " + str(numMetaEntries) + " - " + str(numStems))
            numDefaultEntries = len(self._defaultMetadata)
            self._metadata.extend(self._defaultMetadata["stems"][numMetaEntries:min(numStems, numDefaultEntries)])
            self._metadata["stems"].extend([{"name" :"".join(["Stem_", str(i + numDefaultEntries)]), "color" : "#000000"} \
                for i in range(numStems - numDefaultEntries)])

    def _convertToFormat(self, trackPath, format):
        trackName, fileExtension = os.path.splitext(trackPath)

        if fileExtension in _supported_files_no_conversion:
            return trackPath

        if fileExtension in _supported_files_conversion:
            print("\nconvertendo " + trackPath + " para " + self._format + "...")
            sys.stdout.flush()

            newPath = trackName + ".mp4"
            _removeFile(newPath)

            converter = os.path.join(_getProgramPath(), "avconv_win", "avconv.exe") if _windows else "ffmpeg"
            converterArgs = [converter]

            
            converterArgs.extend(["-i"  , trackPath])
            if self._format == "libfdk_aac":
                converterArgs.extend(["-b:a", "328k"])
            else:
                converterArgs.extend(["-c:a", self._format])
           

            converterArgs.extend([newPath])
            subprocess.check_call(converterArgs)
            return newPath
        else:
            print("formato de arquivo invalido \"" + fileExtension + "\"")
            print("formatos validos sao " + ", ".join(_supported_files_conversion))
            sys.exit()

    def save(self, outputFilePath = None):
        # When using mp4box, in order to get a playable file, the initial file
        # extension has to be .m4a -> this gets renamed at the end of the method.
        if not outputFilePath:
            root, ext = os.path.splitext(self._mixdownTrack)
            root += ".stem"
        else:
            root, ext = os.path.splitext(outputFilePath)

        outputFilePath = "".join([root, stemOutExtension])
        _removeFile(outputFilePath)

        folderName = "GPAC_win"   if _windows else "/content/stmcreator/ni-stem/gpac"
        executable = "mp4box.exe" if _windows else "/usr/bin/MP4Box"
        mp4box     = os.path.join(_getProgramPath(), folderName, executable)
        
        print("\n[Feito 0/6]\n")
        sys.stdout.flush()
        
        callArgs = [mp4box]
        callArgs.extend(["-add", self._convertToFormat(self._mixdownTrack, format) + "#ID=Z", outputFilePath])
        print("\n[Feito 1/6]\n")
        sys.stdout.flush()
        conversionCounter = 1
        for stemTrack in self._stemTracks:
            callArgs.extend(["-add", self._convertToFormat(stemTrack, format) + "#ID=Z:disable"])
            conversionCounter += 1
            print("\n[Feito " + str(conversionCounter) + "/6]\n")
            sys.stdout.flush()
        callArgs.extend(["-udta", "0:type=stem:src=base64," + base64.b64encode(json.dumps(self._metadata))])
        subprocess.check_call(callArgs)
        sys.stdout.flush()

        tags = mutagen.mp4.Open(outputFilePath)
        if ("track" in self._tags) and (len(self._tags["track"]) > 0):
            tags["\xa9nam"] = self._tags["track"]
        if ("artist" in self._tags) and (len(self._tags["artist"]) > 0):
            tags["\xa9ART"] = self._tags["artist"]
        if ("comment" in self._tags) and (len(self._tags["comment"]) > 0):
            tags["\xA9cmt"] = self._tags["comment"]
        if ("album" in self._tags) and (len(self._tags["album"]) > 0):
            tags["\xa9alb"] = self._tags["album"]
        if ("album_artist" in self._tags) and (len(self._tags["album_artist"]) > 0):
            tags["aART"] = self._tags["album_artist"]
        if ("key" in self._tags) and (len(self._tags["key"]) > 0):
            tags["----:com.apple.iTunes:INITIALKEY"] = mutagen.mp4.MP4FreeForm(self._tags["key"])
        if ("copyright" in self._tags) and (len(self._tags["copyright"]) > 0):
            tags["cprt"] = mutagen.mp4.MP4FreeForm(self._tags["copyright"]) 
        if ("copyright" in self._tags) and (len(self._tags["copyright"]) > 0):
            tags["----:com.apple.iTunes:CATALOGNUMBER"] = mutagen.mp4.MP4FreeForm(self._tags["copyright"])    
        if ("mood" in self._tags) and (len(self._tags["mood"]) > 0):
            tags["----:com.apple.iTunes:REMIXER"] = mutagen.mp4.MP4FreeForm(self._tags["mood"])
        if ("mood" in self._tags) and (len(self._tags["mood"]) > 0):
            tags["----:com.apple.iTunes:MOOD"] = mutagen.mp4.MP4FreeForm(self._tags["mood"])        
        if ("lyrics" in self._tags) and (len(self._tags["lyrics"]) > 0):
            tags["\xA9lyr"] = mutagen.mp4.MP4FreeForm(self._tags["lyrics"])
        if ("url" in self._tags) and (len(self._tags["url"]) > 0):
            tags["\xA9url"] = mutagen.mp4.MP4FreeForm(self._tags["url"])      
        if ("label" in self._tags) and (len(self._tags["label"]) > 0):
            tags["----:com.apple.iTunes:LABEL"] = mutagen.mp4.MP4FreeForm(self._tags["label"])
        if ("genre" in self._tags) and (len(self._tags["genre"]) > 0):
            tags["\xa9gen"] = self._tags["genre"]
        if ("date" in self._tags) and (len(self._tags["date"]) > 0):
            tags["\xa9day"] = mutagen.mp4.MP4FreeForm(self._tags["date"])                                          
        if ("releasetime" in self._tags) and (len(self._tags["releasetime"]) > 0):
            tags["----:com.apple.iTunes:RELEASETIME"] = mutagen.mp4.MP4FreeForm(self._tags["releasetime"])
        if ("isrc" in self._tags) and (len(self._tags["isrc"]) > 0):
            tags["TSRC"] = mutagen.id3.TSRC(encoding=None, text=self._tags["isrc"])
            tags["----:com.apple.iTunes:ISRC"] = mutagen.mp4.MP4FreeForm(self._tags["isrc"])
        if ("cover" in self._tags) and (len(self._tags["cover"]) > 0):
            coverPath = self._tags["cover"]
            f = urllib.urlopen(coverPath)
            tags["covr"] = [mutagen.mp4.MP4Cover(f.read(),
              mutagen.mp4.MP4Cover.FORMAT_PNG if coverPath.endswith('png') else
              mutagen.mp4.MP4Cover.FORMAT_JPEG
            )]
            f.close()

        tags["TAUT"] = "STEM"
        tags.save(outputFilePath)
        
        print("\n[Feito 6/6]\n")
        sys.stdout.flush()

        print("A criacao de " + outputFilePath + " foi um sucesso!")


class StemMetadataViewer:

    def __init__(self, stemFile):
        self._metadata = {}

        if stemFile:
            folderName = "GPAC_win"   if _windows else "/content/stmcreator/ni-stem/gpac"
            executable = "mp4box.exe" if _windows else "/usr/bin/MP4Box"
            mp4box     = os.path.join(_getProgramPath(), folderName, executable)

            callArgs = [mp4box]
            callArgs.extend(["-dump-udta", "0:stem", stemFile])
            subprocess.check_call(callArgs)

            root, ext = os.path.splitext(stemFile)
            udtaFile = root + "_stem.udta"
            fileObj = codecs.open(udtaFile, encoding="utf-8")
            fileObj.seek(8)
            self._metadata = json.load(fileObj)
            os.remove(udtaFile)

    def dump(self, metadataFile = None, reportFile = None):
        if metadataFile:
            fileObj = codecs.open(metadataFile, mode="w", encoding="utf-8")
            try:
                fileObj.write(json.dumps(self._metadata))
            except Exception as e:
                raise e
            finally:
                fileObj.close()

        if reportFile:
            fileObj = codecs.open(reportFile, mode="w", encoding="utf-8")
            try:
                for i, value in enumerate(self._metadata["stems"]):
                    line = u"Track {:>3}      name: {:>15}     color: {:>8}\n".format(i + 1, value["name"], value["color"])
                    fileObj.write(line)
            except Exception as e:
                raise e
            finally:
                fileObj.close()
