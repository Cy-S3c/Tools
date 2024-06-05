#!/bin/bash

echo "
 

 ██░ ██ ▓█████  ▄████▄   ██░ ██ ▓█████ 
▓██░ ██▒▓█   ▀ ▒██▀ ▀█  ▓██░ ██▒▓█   ▀ 
▒██▀▀██░▒███   ▒▓█    ▄ ▒██▀▀██░▒███   
░▓█ ░██ ▒▓█  ▄ ▒▓▓▄ ▄██▒░▓█ ░██ ▒▓█  ▄ 
░▓█▒░██▓░▒████▒▒ ▓███▀ ░░▓█▒░██▓░▒████▒ A Header Injection Test Tool v1.0
 ▒ ░░▒░▒░░ ▒░ ░░ ░▒ ▒  ░ ▒ ░░▒░▒░░ ▒░ ░ by v1nd3x  
 ▒ ░▒░ ░ ░ ░  ░  ░  ▒    ▒ ░▒░ ░ ░ ░  ░    
 ░  ░░ ░   ░   ░         ░  ░░ ░   ░   
 ░  ░  ░   ░  ░░ ░       ░  ░  ░   ░  ░
               ░                       

                            

"

usage() {
    echo "Usage:"
    echo "   -u <url>     Perform host header injection test on a single URL"
    echo "   -f <file>    Perform host header injection test on URLs from a file"
    echo
    echo "Examples:"
    echo "   ./script.sh -u http://example.com"
    echo "   ./script.sh -f urls.txt"
    exit 1
}

check_vulnerability() {
    url="$1"

    # Perform checks for Host Header Injection vulnerability using curl command
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: evil.com'" "$url")
    
    if [[ $response =~ ^3[0-9]{2}$ ]]; then
        echo "Potential Host Header Injection vulnerability detected!"
        read -p "Perform cache poison test? (y/n): " choice
        if [[ $choice == "y" ]]; then
            perform_cache_poisoning_tests "$url"
        fi
    else
        echo "No Host Header Injection vulnerability detected."
    fi
}

# Function to perform cache poisoning tests
perform_cache_poisoning_tests() {
    url=$1
    echo "Performing cache poisoning tests..."
    # Run the cache poisoning test script
    ./che.sh "$url"
}

if [[ $# -eq 0 ]]; then
    usage
fi

while getopts "u:f:" opt; do
    case $opt in
        u)
            url="$OPTARG"
            check_vulnerability "$url"
            ;;
        f)
            url_file="$OPTARG"
            if [[ -f $url_file ]]; then
                while IFS= read -r url; do
                    check_vulnerability "$url"
                done < "$url_file"
            else
                echo "Invalid URL file: $url_file"
                usage
                exit 1
            fi
            ;;
        *)
            usage
            ;;
    esac
done
