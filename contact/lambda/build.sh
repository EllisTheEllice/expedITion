export PATH=~/.local/bin:$PATH
cd contact/lambda
zip index.zip index.js
aws lambda update-function-code --function-name contactslambda --zip-file fileb://index.zip
rm index.zip