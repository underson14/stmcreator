#/bin/bash
rm /etc/localtime
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#git clone https://github.com/underson14/colab-ffmpeg-cuda.git
#cp -r ./colab-ffmpeg-cuda/bin/. /usr/bin/
apt install ffmpeg
pip3 install spleeter
apt install -y gpac 
cd /content/stmcreator
unzip "/content/stmcreator/ni-stem/gpac.zip"
mv "/content/stmcreator/gpac/" "/content/stmcreator/ni-stem/"
chmod -R 755 "/content/stmcreator/ni-stem/"
chmod -R 755 "/content/stmcreator/ni-stem/gpac"
chmod -R 755 "/content/stmcreator/creator"
rm -rf "/content/stmcreator/__MACOSX"
rm -rf "/content/stmcreator/ni-stem/gpac.zip"
apt install -y jo
apt install -y sox
apt install -y zip unzip
#rm -rf "/usr/local/lib/python3.8/dist-packages/spleeter/audio/ffmpeg.py"
#mv "/content/stmcreator/ni-stem/ffmpeg.py" "/usr/local/lib/python3.8/dist-packages/spleeter/audio/"

sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
apt install -y atomicparsley
apt install aria2 -y
chmod +x "/content/stmcreator/downvideo.sh"
chmod +x "/content/stmcreator/downmp3.sh"
apt autoremove
