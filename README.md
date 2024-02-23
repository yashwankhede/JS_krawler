# Bug Hunter

This Bash script is designed to assist bug hunters in identifying potential security vulnerabilities in web applications by utilizing various tools for reconnaissance and scanning.

## Installation

```bash
git clone https://github.com/yashwankhede/JS_krawler.git
```

Before running the script, ensure that you have Bash installed on your system. Additionally, the script requires Go to be installed. If Go is not already installed, the script will attempt to install it along with necessary dependencies.

To install Go on Debian-based systems, the script performs the following steps:

- Removes any existing installations of `golang-go`.
- Downloads the specified version of Go (1.21.3 as per the script) from the official website.
- Extracts the downloaded archive to `/usr/local/bin/go`.
- Installs Go using `apt`.
- Sets up Go environment variables in `~/.bashrc`.

## Tools Installation

The script checks for the presence of the following tools:

- **katana**: A flexible security scanning tool for websites.
- **waybackurls**: A tool to fetch all URLs present in the Wayback Machine for a specified domain.
- **secretfinder**: A tool to discover sensitive data like API keys, tokens, etc., hidden in JavaScript files.

If any of these tools are not installed, the script installs them using Go.

## Usage

Upon execution, the script prompts the user to choose between using **katana** or **waybackurls** for URL enumeration. It then proceeds to fetch URLs and filter out JavaScript files (.js extension) from the provided sources.

- If **katana** is selected, the user can choose to input a single URL or provide a file containing a list of URLs. The script then scans the URLs using katana.
- If **waybackurls** is selected, the user needs to provide a file containing a list of URLs for scanning.

The identified JavaScript files are saved to `output.txt`.

The script then runs **secretfinder** on each URL to detect sensitive information, such as API keys, and saves the output to `secret.txt` in the user's home directory (`$HOME`).

## Usage Example

```bash
./JS_kr@wler.sh
```
