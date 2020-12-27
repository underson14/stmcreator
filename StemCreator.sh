rename 's/:/,/g' *
rename 's/"//g' *
rename 's/!//g' *
rename "s/'//g" *
rename 's/$//g' *
rename 's/%//g' *

for f in *.*; do
    "/content/teste/creator" -i "$f"
done

rm -rf "./pretrained_models"

zip -r file.zip "/content/drive/MyDrive/Musicas/03.Sleeper_m4a/output"

