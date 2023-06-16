#!/bin/bash

curl -OL https://golang.org/dl/go1.19.5.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.5.linux-amd64.tar.gz

export PATH=$PATH:/usr/local/go/bin

echo export PATH=$PATH:/usr/local/go/bin >> ~/.bashrc
echo export PATH=$PATH:~/go/bin >> ~/.bashrc
source ~/.bashrc

#SubEnum

GO111MODULE=on go install dw1.io/go-dork@latest

git clone https://github.com/bing0o/SubEnum

chmod +x ./SubEnum/setup.sh

./SubEnum/setup.sh


git clone https://github.com/darkoperator/dnsrecon

git clone https://github.com/MohamedTarekq/GgDorker

python3 -m pip install -r ./GgDorker/requirements.txt



sudo apt install -y libpcap-dev


go install github.com/hakluke/hakrawler@latest

go install github.com/lc/gau/v2/cmd/gau@latest

go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

go install github.com/tomnomnom/httprobe@latest

go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

go install github.com/projectdiscovery/katana/cmd/katana@latest

go install github.com/tomnomnom/assetfinder@latest

go install github.com/tomnomnom/httprobe@latest

git clone https://github.com/fieu/discord.sh

go install github.com/tomnomnom/gf@latest


go install github.com/tomnomnom/waybackurls@latest

git clone https://github.com/1ndianl33t/Gf-Patterns

mkdir ~/.gf

mv ./Gf-Patterns/*.json ~/.gf


sudo python3 -m pip install netaddr pyfiglet

go install github.com/tomnomnom/qsreplace@latest

sudo python3 -m pip install dnspython lxml


git clone https://github.com/anshumanpattnaik/http-request-smuggling


GO111MODULE=on go install -v github.com/xm1k3/cent@latest


cent init 


cent -p cent-nuclei-templates -k


go install github.com/ffuf/ffuf/v2@latest


curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
