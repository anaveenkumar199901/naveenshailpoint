#!/bin/bash
echo "Enter Github Owenr name: "
read owenrname
echo "Enter Github Repo name:"
read reponame
echo "GitHub API token: "
read authtoken
echo "Reciver email id: "
read recpname
echo "EMail From:"
read mailfrom

#Open PR
open=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer "$authtoken""\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owenrname/$reponame/pulls?state=open -o open.txt)
#close PR
close=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer  "$authtoken""\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owenrname/$reponame/pulls?state=open -o close.txt)
#draft PR
draft=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer  "$authtoken""\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$owenrname/$reponame/pulls?state=open -o draft.txt)

#Email block
curl --ssl-reqd smtp://smtp.gmail.com:587 --mail-from $mailfrom \
     --mail-rcpt $recpname --data-binary "Subject: The PR Open" --upload-file open.txt \
     --user 'username:passwd'
curl --ssl-reqd smtp://smtp.gmail.com:587 --mail-from $mailfrom \
     --mail-rcpt $recpname --upload-file draft.txt \
     --user 'username:passwd'
curl --ssl-reqd smtp://smtp.gmail.com:587 --mail-from $mailfrom \
     --mail-rcpt $recpname --upload-file close.txt \
     --user 'username:passwd'
