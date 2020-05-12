#!/bin/bash
#
# Run from this repo's parent dir
# 
# Command:
#    ./create-repo/create.sh <REPO_NAME> <OWNER1 OWNER2 ...>
#
# Example: 
#    ./create-repo/create.sh functional-identity jandrieu ChristopherA
# 
SCRIPT_HOME=../create-repo

REPO_NAME=$1;shift
OWNERS="@$1";shift
for arg in "$@"
do
    OWNERS="$OWNERS @$arg"
done

echo "Repo name: ${REPO_NAME}"
echo "Owners: ${OWNERS}"

git clone git@github.com:w3c-ccg/$REPO_NAME.git
cd $REPO_NAME

git checkout -b boilerplate

#git rm -rf .
# Add default files
cp $SCRIPT_HOME/CODEOWNERS .
cp $SCRIPT_HOME/CONTRIBUTING.md .
cp $SCRIPT_HOME/LICENSE.md .

if [ ! -f ./README.md ]; then
    cp $SCRIPT_HOME/README.md .
fi

sed -i '' -e "s/THE_OWNERS/${OWNERS}/g" CODEOWNERS
sed -i '' -e "s/REPO_NAME/${REPO_NAME}/g" README.md

git add CODEOWNERS
git add *.md

# Make sure we want to continue
read -r -p "Check for problems, press 'y' when ready to proceed: " PROCEED

echo "Proceed: $PROCEED"

if [ "$PROCEED" != "y" ]
then
   echo "Aborting git commit."
   exit
fi

git commit -a -m "CCG boilerplate files"
git push origin boilerplate
