#!/bin/sh
# e is for exiting the script automatically if a command fails, u is for exiting if a variable is not set
# x would be for showing the commands before they are executed
set -eu
# Function for setting up git env in the docker container (copied from https://github.com/stefanzweifel/git-auto-commit-action/blob/master/entrypoint.sh)
_git_setup ( ) {
    cat <<- EOF > $HOME/.netrc
      machine github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
      machine api.github.com
      login $GITHUB_ACTOR
      password $GITHUB_TOKEN
EOF
    chmod 600 $HOME/.netrc

    git config --global user.email "actions@github.com"
    git config --global user.name "GitHub Action"
}


while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-i, --input-dir=DIR       specify a directory to take input from"
      echo "-o, --output-dir=DIR      specify a directory to store output in"
      echo "-t, --template=DIR        specify a template for Pandoc to use"
      exit 0
      ;;
    -i)
      shift
      if test $# -gt 0; then
        export INPUT_DIRECTORY=$1
      else
        echo "no input dir specified"
        exit 1
      fi
      shift
      ;;
    --input-dir*)
      export INPUT_DIRECTORY=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -o)
      shift
      if test $# -gt 0; then
        export OUTPUT_DIRECTORY=$1
      else
        echo "no output dir specified"
        exit 1
      fi
      shift
      ;;
    --output-dir*)
      export OUTPUT_DIRECTORY=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -t)
      shift
      if test $# -gt 0; then
        export TEMPLATE_FILE=$1
      fi
      shift
      ;;
    --template*)
      export TEMPLATE_FILE=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

mkdir -p $OUTPUT_DIRECTORY
if ls "$INPUT_DIRECTORY/*.md" ; then
  find $INPUT_DIRECTORY -type f -name '*.md' -print0 | xargs -0 -n1 basename | xargs -P2 -I{} pandoc "$INPUT_DIRECTORY/{}" --template="$TEMPLATE_FILE" -o "$OUTPUT_DIRECTORY/{}.pdf"
  _git_setup
  echo "Committing and pushing changes..."
  git add out
  git commit -m "Compiled PDFs"
  git push origin
  echo "Changes pushed successfully."
else
  echo "No files in input directory."
fi
