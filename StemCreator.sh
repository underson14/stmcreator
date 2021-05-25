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

zip -r "stem - ${data}.zip" "stems"

rm -rf "./pretrained_models"

mkdir Flac - ${data}

for f in *.flac; do
   time mv "$f" "Flac-${data}"
done
