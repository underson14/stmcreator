rename 's/:/,/g' *
rename 's/"//g' *
rename 's/!//g' *
rename "s/'//g" *
rename 's/$//g' *
rename 's/%//g' *

for f in *.*; do
   time "/content/teste/creator" -i "$f"
done

rm -rf "./pretrained_models"
