pip3 uninstall folium -y
pip3 install folium==0.2.1
pip3 uninstall imgaug -y
pip3 install imgaug==0.2.5
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
apt autoremove

