# get_modified_file_list.sh
#!/bin/bash 
# 测试项目 XcodeCoverageDemo 用
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
result=`git diff --name-only $headTag  $latestTag`  #>> ./get_modified_file_list.log
echo ""
for r in ${result[@]}; do
	echo "`pwd`/$r" >> ./get_modified_file_list.log
done
echo "rebuild success"
open ./
echo "-------------------------------end---------------------------"
