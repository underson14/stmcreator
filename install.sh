MINICONDA_INSTALLER_SCRIPT=Miniconda3-4.5.4-Linux-x86_64.sh
MINICONDA_PREFIX=/usr/local
wget https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER_SCRIPT
chmod +x $MINICONDA_INSTALLER_SCRIPT
./$MINICONDA_INSTALLER_SCRIPT -b -f -p $MINICONDA_PREFIX

conda install --channel defaults conda python=3.6 --yes
conda update --channel defaults --all --yes

conda config --add channels conda-forge

pip3 uninstall folium -y
pip3 install folium==0.2.1
pip3 uninstall imgaug -y
pip3 install imgaug==0.2.5
pip3 uninstall librosa -y
pip3 install librosa==0.7.2
pip3 uninstall panda -y
pip3 install pandas==0.25.1
pip3 uninstall tensorboard -y
pip3 install tensorboard==1.15.0
pip3 uninstall tensorflow-estimator -y
pip3 install tensorflow-estimator==1.15.1
pip3 uninstall gast -y
pip3 install gast==0.2.2
pip3 uninstall numba -y
pip3 install numba==0.48.0
pip3 install tensorflow-gpu==1.15.2
conda install -c conda-forge spleeter-gpu --yes
pip3 install spleeter
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
apt install -y atomicparsley
