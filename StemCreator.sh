#/bin/bash
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

data=`/bin/date +%d-%m-%Y`

zip -r "stems - ${data}.zip" "stems"

rm -rf "./pretrained_models"

mv "./stems" "./stems - ${data}"

mkdir "Flac - ${data}"

for f in *.flac; do
   mv "$f" "Flac - ${data}"
done
