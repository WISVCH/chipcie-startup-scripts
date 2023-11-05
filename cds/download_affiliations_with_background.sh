#!/bin/bash

_arg_git_repository="WISVCH/icpc-logos"
_arg_size=256

tmp_dir=$(mktemp -d -t affiliations-XXXXXXXXXX)

curl -s https://api.github.com/repos/$_arg_git_repository/releases/latest \
| grep browser_download_url \
| grep background_$_arg_size.zip \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -P $tmp_dir -qi -

unzip -j -o -q $tmp_dir/background_256.zip -d $tmp_dir/background_$_arg_size
mkdir $tmp_dir/organizations

for f in $tmp_dir/background_$_arg_size/*; do
    name=`basename $f .png`
    mkdir $tmp_dir/organizations/$name
    cp $f $tmp_dir/organizations/$name/logo${_arg_size}x${_arg_size}.png
done

for c in cds/contest_*; do
    rsync -a $tmp_dir/organizations/ $c/organizations
done

rm -rf $tmp_dir
