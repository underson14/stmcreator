time youtube-dl --autonumber-start 1 -ci --hls-prefer-native \
--add-metadata --embed-thumbnail \
--external-downloader aria2c --external-downloader-args "-j 16 -x 16 -s 16 -k 1M --file-allocation none" \
-f 'bestvideo[height<=?1080][fps<=?30][vcodec!=?vp9]+bestaudio[ext=m4a]/best' \
-o "${1}/%(title)s.%(ext)s" $2
