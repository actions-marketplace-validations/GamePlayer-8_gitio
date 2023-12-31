#!/bin/sh

# A worker is for processing stuff defined by the repo.

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
INSTALLER="$SCRIPT_PATH"/packages/default-fs/usr/share/gitio/scripts/insti.sh

sh "$SCRIPT_PATH"/packages/build.sh
rm -rf "$SCRIPT_PATH"/.gitignore

sh "$INSTALLER" markdown

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat docs/head.html >> index.html

echo '<body>' >> index.html
echo '<div class="content">' >> index.html
markdown README.md >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html

cd "$SCRIPT_PATH"
sh install.sh
