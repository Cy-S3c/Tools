#!/bin/bash

echo "   

 ▄████▄   ██░ ██ ▓█████ 
▒██▀ ▀█  ▓██░ ██▒▓█   ▀ 
▒▓█    ▄ ▒██▀▀██░▒███   
▒▓▓▄ ▄██▒░▓█ ░██ ▒▓█  ▄ 
▒ ▓███▀ ░░▓█▒░██▓░▒████▒ A Cache Poison Check Tool v1.0
░ ░▒ ▒  ░ ▒ ░░▒░▒░░ ▒░ ░ By v1nd3x
  ░  ▒    ▒ ░▒░ ░ ░ ░  ░
░         ░  ░░ ░   ░   
░ ░       ░  ░  ░   ░  ░
░                       


"
test_cache_poisoning() {
    local url=$1

    echo "Performing Cache Poisoning Tests for: $url"

    # Add your cache poisoning test scenarios and commands here
    # Example: Test for cache poisoning by injecting malicious headers
    response=$(curl -I -H "X-Poison: <malicious_header>" "$url")
    if [[ $response == *"HTTP/1.1 200 OK"* ]]; then
        echo "Cache Poisoning Successful!"
    else
        echo "Cache Poisoning Failed."
    fi

    # Example: Test for cache poisoning by injecting malicious query parameters
    response=$(curl -I "$url/?param=<malicious_value>")
    if [[ $response == *"HTTP/1.1 200 OK"* ]]; then
        echo "Cache Poisoning Successful!"
    else
        echo "Cache Poisoning Failed."
    fi

    # Example: Test for cache poisoning by injecting malicious cookies
    response=$(curl -I -b "cookie=<malicious_value>" "$url")
    if [[ $response == *"HTTP/1.1 200 OK"* ]]; then
        echo "Cache Poisoning Successful!"
    else
        echo "Cache Poisoning Failed."
    fi

    # Add more cache poisoning tests as needed

    # Display the results or perform further analysis
    echo "Cache Poisoning Tests Completed."
}
