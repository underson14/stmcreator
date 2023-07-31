#/bin/bash

cd "/content/drive/MyDrive/00.Musicas/stems"

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


for f in *.*; do
      mkdir "Arquivos ${f##*.}"
      mkdir "${f##*.} ${data}"
      mv "$f" "${f##*.} ${data}"
      mv "${f##*.} ${data}" "Arquivos ${f##*.}"
done
