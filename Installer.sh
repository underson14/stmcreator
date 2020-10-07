cd /content/teste
apt update
apt upgrade -y
apt install ffmpeg
apt install gpac
apt install -y jo
apt update
apt autoremove -y
pip3 install spleeter
pip3 install tensorflow-gpu==1.15
unzip "/content/teste/ni-stem/gpac.zip"
chmod -R 755 "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/gpac/"
rm -rf "/content/teste/ni-stem/__MACOSX/"