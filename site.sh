#!/bin/bash

### entries are files within subfolders, six digit date as filename.md
### entries sorted by filesystem date, so mind modification, retouch

# append date: d=$(date -r tomorrowperhaps.zip +%D); echo "$d tehn@nnnnnnnn.co" | cmark

### convert root md

echo ">> root .md to .html"

list=$(ls -r ./*.md)
for file in $list ; do
  file=${file:2}
  file=${file%.*}
  echo "$file"
  # convert md to html
  target=${file}.html
  cat start.htm_ > ${target}
  cmark ${file}.md >> ${target}
  cat end.htm_ >> ${target}
done

### build index, gen rss, md-html

echo ">> build log, rss"

list=$(ls -r ./log/*.md)
list2=$(ls -r ./radio/*.md)

log="log"
radio="radio"
cat start.htm_ > ${log}.html
cat start.htm_ > ${radio}.html
cat start_rss.xml_ > rss.xml

n=1

for file in $list ; do
  file=${file:2}
  subfile=${file%.*}
  folder=${subfile%\/*}
  name=${subfile#*\/}
  echo "$folder / $name"

  # convert md to html
  #target=${file%.*}.html
  #cat start.htm_ > ${target}
  #echo "<p>${name}</p>" >> ${target}
  #cmark ${file} >> ${target}
  #cat end.htm_ >> ${target}

for file in $list2 ; do
  file=${file:2}
  subfile=${file%.*}
  folder=${subfile%\/*}
  name=${subfile#*\/}
  echo "$folder / $name"

  # convert md to html
  target=${file%.*}.html
  cat start.htm_ > ${target}
  echo "<p>${name}</p>" >> ${target}
  cmark ${file} >> ${target}
  cat end.htm_ >> ${target}

  # paginate
  if [ $((n % 19)) == 0 ]; then
    echo "--- page ---"
    echo "<br/><p><a href=/${log}n.html>[further]</a></p>" >> ${log}.html
    echo "<br/><p><a href=/${radio}n.html>[further]</a></p>" >> ${radio}.html
    cat end.htm_ >> ${log}.html
    cat end.htm_ >> ${radio}.html
    log=$log"n"
    radio=$radio"n"
    cat start.htm_ > ${log}.html
    cat start.htm_ > ${radio}.html
  fi
  ((n=n+1))

  # append to index
  echo "<p><a href=${target}>${name}</a></p>" >> ${log}.html
  cmark ${file} >> ${log}.html
  echo "<br/>" >> ${log}.html
  echo "<p><a href=${target}>${name}</a></p>" >> ${radio}.html
  cmark ${file} >> ${radio}.html
  echo "<br/>" >> ${radio}.html

  # append to rss
  echo "<item>" >> rss.xml
  echo "<title>${folder} / ${name}</title>" >> rss.xml
  echo "<link>https://pulsewidth.github.io/${folder}/${name}.html</link>" >> rss.xml
  echo "<guid>https://pulsewidth.github.io/${folder}/${name}.html</guid>" >> rss.xml
  echo "<description><![CDATA[" >> rss.xml
  cmark ${file} >> rss.xml
  echo "]]></description>" >> rss.xml
  date=$(date -r $file "+%a, %d %b %Y 11:11:11 EST")
  echo "<pubDate>$date</pubDate>" >> rss.xml
  echo "</item>" >> rss.xml
done


cat end.htm_ >> ${log}.html
cat end.htm_ >> ${radio}.html
cat end_rss.xml_ >> rss.xml

# generate gmi

list=$(ls -r ./log/image/*.jpg)
cat index.gmi_ > index.gmi
for file in $list ; do
  file=${file:2}
  name=${file%.*}
  name=${name#*\/}
  name=${name#*\/}
  #echo "$name"
  echo "=> log/image/$name.jpg" $name >> index.gmi
done
