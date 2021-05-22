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

zip -r "stem.zip" "stems"

rm -rf "./pretrained_models"

makedir "Flac/"

for f in *.flac; do
   time mv "$f" "Flac/"
done
