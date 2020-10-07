for f in *.*; do
    "/content/teste/stemgen" -i "$f"
done

rm -rf "/content/drive/My Drive/MyStems/originals/pretrained_models"
