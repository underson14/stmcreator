#/bin/bash

cd "/content/drive/MyDrive/StemCreator"

rename 's/&/e/g' *
rename 's/:/,/g' *
rename 's/;/, /g' *
rename 's/"//g' *
rename 's/!//g' *
rename "s/'//g" *
rename 's/$//g' *
rename 's/%//g' *

for f in *.*; do
   time "/content/stmcreator/creator" -i "$f"
done

data=`/bin/date +"%d-%m-%Y %H:%M:%S"`

zip -r "stems ${data}.zip" "stems"

rm -rf "./pretrained_models"

mv "./stems" "./stems ${data}"

mkdir "Arquivos Stems"

mv "./stems ${data}" "Arquivos Stems"

for f in *.zip; do
      mkdir "Arquivos ZIP"
      mv "$f" "Arquivos ZIP"
done

