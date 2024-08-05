1. Install nodejs: https://nodejs.org/en/download/
   OR
   > choco install nodejs-lts
   OR
   > brew install npm

2. execute: npm install
 - This will use the content of the package.json file and install any needed dependencies into /node-modules folder

3. To run code locally type: node fe-server.js
 - Can access code on http://localhost:22137
 - 22137 can be changed in /config/config.json property "exposedPort"
 - The backend webservice must also be properly configured in /config/config.json.