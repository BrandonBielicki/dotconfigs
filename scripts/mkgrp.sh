#! /bin/sh
cd ../setup/package_lists/.groups
for D in *; do
    if [ -d "${D}" ]; then 
        mkdir $D/$1
        cd $D/$1
        touch $1
        touch pre_$1.sh
        touch post_$1.sh
        chmod +x pre_$1.sh
        chmod +x post_$1.sh
        echo "#! /bin/sh" > pre_$1.sh
        echo "#! /bin/sh" > post_$1.sh
        for PACKAGE in ${@:2}; do
            echo $PACKAGE >> $1
        done
        cd ../..
    fi
done

mkdir ../setup/package_list/.groups
