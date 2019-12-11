#!/bin/bash
#
# Run from this repo's parent dir
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

git clone https://github.com/w3c-ccg/$REPO_NAME.git
cd $REPO_NAME


# Create gh-pages branch
git checkout --orphan gh-pages
#git rm -rf .
# Add default files
cp $SCRIPT_HOME/CODEOWNERS .
cp $SCRIPT_HOME/CONTRIBUTING.md .
cp $SCRIPT_HOME/LICENSE.md .
cp $SCRIPT_HOME/README.md .

sed -i '' -e "s/THE_OWNERS/${OWNERS}/g" CODEOWNERS
sed -i '' -e "s/REPO_NAME/${REPO_NAME}/g" README.md

git add CODEOWNERS
git add *.md

echo "${REPO_NAME}" > index.html
git add index.html

# Make sure we want to continue
read -r -p "Check for problems, press 'y' when ready to proceed: " PROCEED

echo "Proceed: $PROCEED"

if [ "$PROCEED" != "y" ]
then
   echo "Aborting git commit."
   exit
fi

git commit -a -m "First pages commit"
git push --set-upstream origin gh-pages


