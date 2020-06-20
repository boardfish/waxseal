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


echo "Hello world"
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
    set -- pandoc "$@"
fi

"$@"

_git_setup
echo "Committing and pushing changes..."
git add out/foo.md.pdf
git commit -m "Compiled PDFs"
git push origin
echo "Changes pushed successfully."
