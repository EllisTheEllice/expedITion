export PATH=~/.local/bin:$PATH
cd finance/lambda
zip index.zip index.js
aws lambda update-function-code --function-name transactionslambda --zip-file fileb://index.zip
rm index.zip