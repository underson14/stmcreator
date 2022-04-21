#/bin/bash
rm /etc/localtime
ln -s /usr/share/zoneinfo//America/Sao_Paulo /etc/localtime

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
apt install -y sox
apt install -y zip unzip
rm -rf "/usr/local/lib/python3.7/dist-packages/spleeter/audio/ffmpeg.py"
mv "/content/stmcreator/ni-stem/ffmpeg.py" "/usr/local/lib/python3.7/dist-packages/spleeter/audio/"
pip3 uninstall tensorflow -y
pip3 install tensorflow==2.3.0

pip3 uninstall numpy -y
pip3 install numpy==1.19.0

pip3 uninstall tables -y
pip3 install tables==3.7.0

pip3 uninstall jaxlib -y
pip3 install jaxlib==0.3.2+cuda11.cudnn805

pip3 uninstall jax -y
pip3 install jax==0.3.4
apt autoremove
