#!/usr/bin/env bash
set -e

# Delete the zipped file in case there is an error
trap "rm -f function.zip" ERR

declare this_script="$0"
declare function_name

# Expect the function name as the only argument.
if [[ "$#" -ne 1 ]]; then
    echo "This script requires the name of the lambda function to update as an argument."
    exit 1;
fi

function_name="$1"

echo "Installing npm packages..."
npm install

echo
echo "Bundling source code and dependencies..."
# Exclude this script from the zip file
zip -9 -r function.zip . -x "${this_script}" > /dev/null

echo "Update code for function ${function_name}"
aws lambda update-function-code --function-name "${function_name}" --zip-file fileb://function.zip --no-cli-pager

exit 0;