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
mv "/content/teste/gpac/" "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/gpac/"
chmod -R 755 "/content/teste/stemgen"
rm -rf "/content/teste/__MACOSX"
