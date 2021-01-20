cd "/content/drive/MyDrive/Musicas/03.Sleeper_m4a/stems"

for f in *.*; do
   time mediainfo -i "$f"
done
