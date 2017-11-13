export PATH=$PATH:/home/bitnami/.nvm/versions/node/v8.9.1/bin
cd $WORKSPACE/environment
npm install
cp -r ../contact ./src/pages/
cp -r ../finance ./src/pages/
cp -r ../home ./src/pages/
apiid=$(cat /tmp/apiid)
echo $apiid
ionic build
tar -czf app.tgz ./www/
host=$(cat /tmp/dns)
echo $host
scp -i ~/.ssh/jenkins.pem -o "StrictHostKeyChecking=no" $WORKSPACE/environment/app.tgz ubuntu@$host:/tmp/
ssh -i ~/.ssh/jenkins.pem -o "StrictHostKeyChecking=no" ubuntu@$host "sudo tar -C /var/www/html -xzf /tmp/app.tgz && mv /var/www/html/www/* /var/www/html/"