#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if Go is installed, if not, install it
if ! command_exists go; then
  echo "Installing Go lang..."
  sudo apt-get remove golang-go
  sudo apt-get remove --auto-remove golang-go
  sudo rm -rvf /usr/local/go
  wget https://dl.google.com/go/go1.21.3.linux-amd64.tar.gz
  sudo tar -xvf go1.21.3.linux-amd64.tar.gz -C /usr/local/bin/go
  apt install golang-go
  apt install gccgo-go
  rm -rf go1.21.3.linux-amd64.tar.gz

  # Add Go variables entry to ~/.bashrc
  echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
  echo 'export GOPATH=$HOME/go' >> ~/.bashrc
  echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
  source ~/.bashrc
fi

# Check if katana, waybackurls, and secretfinder are installed, if not, install them using Go
if ! command_exists katana || ! command_exists waybackurls || ! command_exists secretfinder; then
  echo "Installing katana, waybackurls, and secretfinder..."
  go install github.com/projectdiscovery/katana/cmd/katana@latest
  go install github.com/tomnomnom/waybackurls@latest
  git clone https://github.com/m4ll0k/SecretFinder.git secretfinder && cd secretfinder && (python -m pip install -r requirements.txt || pip install -r requirements.txt) && sudo mv SecretFinder.py /usr/bin/secretfinder
fi

# Ask user to choose between katana and waybackurls
echo "Choose the tool for bug hunting:"
echo "1. katana"
echo "2. waybackurls"
read -p "Enter your choice (1/2): " tool_choice

# Take user input based on the selected tool
if [[ $tool_choice == 1 ]]; then
  read -p "Do you want to use a URL or a list of URLs file with katana? (url/file): " katana_input_type
  if [[ $katana_input_type == "url" ]]; then
    read -p "Enter the target URL: " user_input_url
    katana -u $user_input_url -jc | grep '.js$' | uniq | sort -n | tee output.txt
  elif [[ $katana_input_type == "file" ]]; then
    read -p "Enter the path to the list of URLs file: " user_input_file
    cat $user_input_file | katana -list -jc | grep '.js$' | uniq | sort -n | tee output.txt
  else
    echo "Invalid input. Please choose 'url' or 'file'."
    exit 1
  fi
elif [[ $tool_choice == 2 ]]; then
  read -p "Enter the path to the list of URLs file for waybackurls: " user_input_file
  cat $user_input_file | waybackurls | grep '.js$' | uniq | sort -n | tee output.txt
else
  echo "Invalid choice. Exiting..."
  exit 1
fi

# Run secretfinder on each URL and save the output to secret.txt
cat output.txt | while read url; do
  secretfinder -i $url -o cli
done | tee $HOME/secret.txt

echo "Output file has been saved in $HOME/secret.txt"
