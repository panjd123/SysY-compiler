# 将所有 lab* 文件夹分别打包成 lab*_student_id.zip 放到 submission 文件夹下
submission_dir="submission"
student_id="2021201626"

if [ ! -d "$submission_dir" ]; then
    mkdir $submission_dir
fi

for dir in lab*
do
    if [ -d "$dir" ]; then
        zip -r "$submission_dir/$dir"_"$student_id".zip $dir
    fi
done