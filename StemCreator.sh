rename 's/:/,/g' *
rename 's/"//g' *
rename 's/!//g' *
rename "s/'//g" *
rename 's/$//g' *
rename 's/%//g' *

time for f in *.*; do
    "/content/teste/creator" -i "$f"
done

rm -rf "./pretrained_models"
