apt install ffmpeg
pip3 install pydub
pip3 install spleeter-gpu
apt install gpac
pip3 install tidal-dl --upgrade
cd /content/teste
unzip "/content/teste/ni-stem/gpac.zip"
mv "/content/teste/gpac/" "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/gpac/"
chmod -R 755 "/content/teste/creator"
rm -rf "/content/teste/__MACOSX"
rm -rf "/content/teste/ni-stem/gpac.zip"
chmod -R 755 "/content/teste/video.sh"
chmod -R 755 "/content/teste/mp3.sh"
chmod -R 755 "/content/drive/MyDrive/Videos"
chmod -R 755 "/content/drive/MyDrive/MP3"
apt install jo
wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
apt-get install -y atomicparsley
