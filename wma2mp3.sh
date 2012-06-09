#!/bin/bash

# このｓh自体を複数走らせて擬似並列処理

find -name "*.wma" | while read path
do
	# 拡張子を取り除いたパスを取得
	filename=${path%.*}
	lockfile=$filename.lock
	if [ -e "$lockfile" -o ! -e "$path" ];
	then
		# ロックファイルが既にあるか、元ファイルが削除済みだったら他プロセスで作業中or作業済み
		continue
	fi
	touch "$lockfile"
	echo -n "Converting $filename.mp3 ... "
	# avconv(ffmpeg)で変換後(&&指定)、元ファイルとロックファイルを削除。これは末尾に&をつけて並列処理させる
	yes | avconv -i "$path" "$filename.mp3" 2> /dev/null && trash-put "$path" && rm "$lockfile" &
	# ロックファイルが存在し続ける間 ぐるぐる
	until ! [ -e "$lockfile" ]; do for c in \| / - \\; do echo -ne "\b$c"; sleep 0.2; done done
	echo -ne "\b "
	echo "done!"
done

