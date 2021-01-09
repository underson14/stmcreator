python -m pip install --upgrade pip
pip3 uninstall folium -y
pip3 install folium==0.2.1
pip3 uninstall imgaug -y
pip3 install imgaug==0.2.5
apt install ffmpeg
pip3 install pydub
pip3 uninstall tensorflow==2.4.0 -y
pip3 install tensorflow==2.3.0
pip3 install spleeter-gpu
apt install -y gpac 
cd /content/teste
unzip "/content/teste/ni-stem/gpac.zip"
mv "/content/teste/gpac/" "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/"
chmod -R 755 "/content/teste/ni-stem/gpac/"
chmod -R 755 "/content/teste/creator"
rm -rf "/content/teste/__MACOSX"
rm -rf "/content/teste/ni-stem/gpac.zip"
apt install -y jo
apt install -y mediainfo
