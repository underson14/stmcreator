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

data=`/bin/date +"%d-%m-%Y %H:%M:%S"`

zip -r "stems ${data}.zip" "stems"

rm -rf "./pretrained_models"

mv "./stems" "./stems ${data}"

for f in *.*; do
      mkdir "${f##*.} ${data}"
      mv "$f" "${f##*.} ${data}"
done
