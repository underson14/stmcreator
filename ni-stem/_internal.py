import codecs
import json
import base64
import mutagen
import mutagen.mp4
import mutagen.id3
import urllib.request as urllib
import os
import platform
import subprocess
import sys
import re

stemDescription  = 'stem-meta'
stemOutExtension = ".mp4"

_windows = platform.system() == "Windows"

_supported_files_no_conversion = [".m4a", ".mp4", ".m4p"]
_supported_files_conversion = [".wav", ".wave", ".aif", ".aiff", ".flac"]

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
        # for key, value in self._tags.iteritems(): self._tags[key] = repr(value).encode('utf-8')

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
            print("missing stem metadata for stems " + str(numMetaEntries) + " - " + str(numStems))
            numDefaultEntries = len(self._defaultMetadata)
            self._metadata.extend(self._defaultMetadata[numMetaEntries:min(numStems, numDefaultEntries)])
            self._metadata.extend([{"name": "".join(["Stem_", str(i + numDefaultEntries)]), "color": "#000000"} for i in range(numStems - numDefaultEntries)])

    def _convertToFormat(self, trackPath, format):
        trackName, fileExtension = os.path.splitext(trackPath)

        if fileExtension in _supported_files_no_conversion:
            return trackPath

        if fileExtension in _supported_files_conversion:
            print("\nconvertendo " + trackPath + " para " + self._format + "...")
            sys.stdout.flush()

            newPath = trackName + ".m4a"
            _removeFile(newPath)

            converter = os.path.join(_getProgramPath(), "avconv_win", "avconv.exe") if _windows else "ffmpeg"
            converterArgs = [converter]

            
            converterArgs.extend(["-i"  , trackPath])
            if self._format == ""libfdk_aac":
                converterArgs.extend(["-b:a", "328k"]) 
            else:
                converterArgs.extend(["-b:a", "328k"])
           

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
        
        print("\n[Done 0/6]\n")
        sys.stdout.flush()
        
        callArgs = [mp4box]
        callArgs.extend(["-add", self._convertToFormat(self._mixdownTrack, format) + "#ID=Z", outputFilePath])
        print("\n[Done 1/6]\n")
        sys.stdout.flush()
        conversionCounter = 1
        for stemTrack in self._stemTracks:
            callArgs.extend(["-add", self._convertToFormat(stemTrack, format) + "#ID=Z:disable"])
            conversionCounter += 1
            print("\n[Done " + str(conversionCounter) + "/6]\n")
            sys.stdout.flush()

        metadata = json.dumps(self._metadata)
        metadata = base64.b64encode(metadata.encode("utf-8"))
        metadata = "0:type=stem:src=base64," + metadata.decode("utf-8")
        callArgs.extend(["-udta", metadata])
        subprocess.check_call(callArgs)
        sys.stdout.flush()

        tags = mutagen.mp4.Open(outputFilePath)

        tags["TAUT"] = "STEM"
        tags.save(outputFilePath)
        
        print("\n[Done 6/6]\n")
        sys.stdout.flush()

        print("creating " + outputFilePath + " was successful!")

