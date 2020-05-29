#!/bin/bash
#
# An "update" hook which rejects any update containing CRLF.
#
# Author: Gerhard Gappmeier, ascolab GmbH
# Author: Colin Mollenhour
# from:  https://gist.github.com/colinmollenhour/1248871/1df28b5e97c53a8032b575d9084b30a2e34e0be4
#
# This script is based on the update.sample in git/contrib/hooks.
# You are free to use this script for whatever you want.
#

BINARY_REGEX='\.(dat|pdb|dll|exe|png|gif|jpg|jpeg|ico|mkv|mov|mp3|mp4|swf|mwb|7z|zip|tgz|gz|ttf|otf|woff|woff2)'
OVERRIDE_REGEX='Contains CRLF'

refname="$1"
oldrev="$2"
newrev="$3"
[ -z "$refname" -o -z "$oldrev" -o -z "$newrev" ] && \
    { echo "Usage: $0 <ref> <oldrev> <newrev>" >&2; exit 1; }

# skip when commit mesage contains override
MESSAGE=$(git show -s --format=format:"%s" $newrev)
[[ $MESSAGE =~ $OVERRIDE_REGEX ]] && exit 0

ret=0
while read old_mode new_mode old_sha1 new_sha1 status name
do
    # skip lines showing parent commit
    test -z "$new_sha1" && continue

    # skip deletions
    [ "$new_sha1" = "0000000000000000000000000000000000000000" ] && continue

    # don't do a CRLF check for binary files
    [[ $name =~ $BINARY_REGEX ]] && continue

    # check for CRLF
    CR=$(printf "\r")
    if git cat-file blob $new_sha1 | grep -Eq "$CR$"; then
        echo "CRLF DETECTED: [$name]"
        ret=1
    fi
done < <(git diff-tree -r "$oldrev" "$newrev")

if [ "$ret" = "1" ]; then
    echo "###################################################################################################"
    echo "# One or more files contained CRLF (Windows) line endings which are not allowed."
    echo "# Please change the line endings to LF before committing and before trying to push."
    echo "# You will have to amend your existing commits to not contain CRLF."
    echo "Use \"git config [--global] core.autocrlf false\" to disable CRLF conversion."
    echo "###################################################################################################"
fi

exit $ret