#/bin/bash
rm /etc/localtime
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#apt install -y ffmpeg
pip3 install spleeter
apt install -y gpac 
cd /content/stmcreator
unzip "/content/stmcreator/ni-stem/gpac.zip"
mv "/content/stmcreator/gpac" "/content/stmcreator/ni-stem/"
chmod -R 755 "/content/stmcreator/ni-stem/"
chmod -R 755 "/content/stmcreator/ni-stem/gpac"
chmod -R 755 "/content/stmcreator/creator"
rm -rf "/content/stmcreator/__MACOSX"
rm -rf "/content/stmcreator/ni-stem/gpac.zip"
apt install -y jo
apt install -y sox
apt install -y zip unzip
rm -rf "/usr/local/lib/python3.10/dist-packages/spleeter/audio/ffmpeg.py"
mv "/content/stmcreator/ni-stem/ffmpeg.py" "/usr/local/lib/python3.10/dist-packages/spleeter/audio/"


apt install -y atomicparsley

apt autoremove
