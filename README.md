#### HardHat Tutorial
https://hardhat.org/tutorial

#### 1) Installation for remixd command (Only need to do this once)
```
npm install -g @remix-project/remixd
```

#### 2) Run following command before connecting to localhost for remix
```
remixd -s . 
```
https://remix-ide.readthedocs.io/en/latest/remixd.html 

#### Compile
```
npx hardhat compile
```

#### Deploy example
```
npx hardhat run scripts/deploy.js --network arbitrum_rinkeby
```

#### Verify example
```
npx hardhat verify "ADDRESS" --network arbitrum_rinkeby
```