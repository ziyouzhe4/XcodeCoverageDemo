# get_modified_file_list.sh
#!/bin/bash

git pull origin master
headTag=`git describe --tags $(git rev-list --tags --max-count=1)`
echo "current tag $headTag"
latestTag=`date +%s`
echo "curStamp：$latestTag"
git tag ${latestTag}
echo "latestTag: $latestTag"
git push origin --tags
echo "latestTag push remote"
rm -rf ./get_modified_file_list.log
echo "del local log file,rebuild"
git diff --name-only $headTag  $latestTag >> ./get_modified_file_list.log
echo "rebuild success"
open ./
echo "-------------------------------end---------------------------"
