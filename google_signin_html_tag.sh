#!/bin/bash
#example use: ./google_signin_html_tag.sh exposed or ./google_signin_html_tag.sh hidden

#log all echos to a file, append file if it exists
exec > >(tee -a google_signin_html_tag.log)
exec 2>&1
echo "date = $(date)"

#read arguments; must be 1 argument either written as 'exposed' or 'hidden'
if [ $# -eq 0 ]
then
    echo "no arguments, follow .sh with 'exposed' or 'hidden'"
    exit 1
fi

if [ $# -gt 1 ]
then
    echo "too many arguments, follow .sh with only 'exposed' or 'hidden'"
    exit 1
fi

if [ $1 != "exposed" ] && [ $1 != "hidden" ]
then
    echo "invalid argument, follow .sh with only 'exposed' or 'hidden'"
    exit 1
fi
#change directory to the directory of this script
cd "$(dirname "$0")"
file2="web/index.html"
#if exposed, read the first file and use the key and value in the second file
if [ $1 == "exposed" ]
then
    echo "exposed"

    file1="google_signin_html_tag.txt"
    echo "file1 = $file1"
    if [ -s $file1 ]
    then
        meta_tag=$(cat $file1)
    else
        echo "file1 is empty"
        exit 1
    fi
else
    echo "hidden"
    meta_tag="  <meta name='google-signin-client_id' content='YOUR_CLIENT_ID.apps.googleusercontent.com'>"
fi
echo "tag = $meta_tag"
sed -i "s/  <meta name='google-signin-client_id' content=.*/$meta_tag/" $file2
echo "done"
