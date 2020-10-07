chmod +x /content/teste/stemgen.x
for f in *.*; do
    "/content/teste/stemgen.x" -i "$f"
done
