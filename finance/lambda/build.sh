export LD_LIBRARY_PATH=""
export PATH=/home/tomcat/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
cd finance/lambda
zip index.zip index.js
aws lambda update-function-code --function-name transactionslambda --zip-file fileb://index.zip
rm index.zip