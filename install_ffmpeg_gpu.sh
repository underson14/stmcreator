pip3 uninstall folium -y
pip3 install folium==0.2.1
pip3 uninstall imgaug -y
pip3 install imgaug==0.2.5
git clone https://github.com/underson14/colab-ffmpeg-cuda.git
cp -r ./colab-ffmpeg-cuda/bin/. /usr/bin/
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
apt install zip unzip
cp -f "/usr/local/lib/python3.7/dist-packages/spleeter/audio/ffmpeg.py" "/content/stmcreator/ni-stem/ffmpeg.py"
apt autoremove