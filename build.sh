export PATH=$PATH:/home/bitnami/.nvm/versions/node/v8.9.1/bin
cd $WORKSPACE/environment
npm install
cp -r ../contact ./src/pages/
cp -r ../finance ./src/pages/
cp -r ../home ./src/pages/
ionic build