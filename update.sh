
#!/bin/bash
cat << "EOF"


	  /$$$$$$                                          /$$                 /$$         /$$
	 /$$__  $$                                        |__/                | $$       /$$$$
	| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$
	| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$	
	| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$
	| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$
	|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$
	 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/
	 
	 
	                               /$$             /$$             /$$              
                         	      | $$            | $$            | $$              
	 /$$$$$$$   /$$$$$$   /$$$$$$ | $$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$    /$$$$$$ 
	| $$__  $$ /$$__  $$ /$$__  $$| $$__  $$ /$$__  $$ |____  $$|_  $$_/   /$$__  $$
	| $$  \ $$| $$  \ $$| $$  \ $$| $$  \ $$| $$  | $$  /$$$$$$$  | $$    | $$$$$$$$
	| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$ /$$__  $$  | $$ /$$| $$_____/
	| $$  | $$|  $$$$$$/|  $$$$$$/| $$$$$$$/|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$
	|__/  |__/ \______/  \______/ |_______/  \_______/ \_______/   \___/   \_______/
                                                                                
                                                                                                                                                     
	 
	Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
	This script will update genesis_29-1 to genesis_29-2.
	NOTE: Be ready to enter and remember your NEW strong passwords during the installation process.
	GENESIS L1 is a highly experimental decentralized project, provided AS IS, with NO WARRANTY.
	GENESIS L1 IS A NON COMMERCIAL OPEN DECENRALIZED BLOCKCHAIN PROJECT RELATED TO SCIENCE AND ART
          
  Mainnet EVM chain ID: 29
  Cosmos chain ID: genesis_29-2
  Blockchain utilitarian coin: L1
  Min. coin unit: el1
  1 L1 = 1 000 000 000 000 000 000 el1 	
  Initial supply: 21 000 000 L1
  Mint rate: < 20% annual
  Block target time: ~5s
  Binary name: genesisd
  
EOF
sleep 15s


# SYSTEM UPDATE, INSTALLATION OF THE FOLLOWING PACKAGES: jq git wget make gcc build-essential snapd wget ponysay sl, INSTALLATION OF GO 1.17 via snap

sudo apt-get update -y
sudo apt-get install jq git wget make gcc build-essential snapd cmatrix sl wget -y
snap install --channel=1.17/stable go --classic
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
snap install ponysay

# GLOBAL CHANGE OF OPEN FILE LIMITS
echo "* - nofile 50000" >> /etc/security/limits.conf
echo "root - nofile 50000" >> /etc/security/limits.conf
echo "fs.file-max = 50000" >> /etc/sysctl.conf 
ulimit -n 50000

ponysay "LAST REMINDER: This is an update script to migrate from genesis_29-1 to genesis_29-2 network! If you want new node from scratch, terminate this script with CTRL+C and run the install-genesisd.sh script"

sleep 10s
<< "EOF"

     	    \\
             \\_
          .---(')
        o( )_-\_   
Follow the white rabbit                                                                                                                                                                                
EOF
sleep 5s
cmatrix
sleep 5s
pkill cmatrix
echo Now just updating the software! 
#STOPPING EVMOSD DAEMON AND COSMOVISOR IF IT WAS NOT STOPPED
pkill evmosd
pkill cosmovisor

# BACKUP genesis_29-1 .evmosd
cd
rsync -r --verbose --exclude 'data' ./.evmosd/ ./.evmosd_backup/

# DELETING OF .genesisd FOLDER (PREVIOUS INSTALLATIONS)
cd 
rm -r .genesisd

# BUILDING genesisd BINARIES
cd genesisd
make install

# COPY .evmosd FILES to .genesisd FILES
cd
rsync -r --verbose --exclude 'data' ./.evmosd/ ./.genesisd/

# SETTING UP THE keyring type and chain-id in CONFIG
genesisd config chain-id genesis_29-2

#IMPORTING GENESIS STATE AND VALIDATION
cd 
cd .genesisd/config
rm -r genesis.json
wget https://raw.githubusercontent.com/alpha-omega-labs/noobdate/main/genesis_noobdate_test_state.json
mv genesis_noobdate_test_state.json genesis.json
cd
genesisd validate-genesis

# RESET TO IMPORTED genesis.json
genesisd unsafe-reset-all

# STARTING GENESISL1 NEOLITHIC STAGE NODE
genesisd start --chain-id genesis_29-2 --pruning=nothing --trace --log_level info --minimum-gas-prices=1el1
echo All set, starting your updated node!
sleep 3s
sl
sleep 5s