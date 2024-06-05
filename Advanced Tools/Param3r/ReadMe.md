# Paramer A Link and Parameter Scraper

## Overview

Link and Parameter Scraper is a Python tool that uses the Scrapy framework to crawl a given website, domain, IP, or IP and port, and collects all clickable links and links with parameters. It then saves these links into two separate JSON files.

## Features

- Scrapes clickable links from a website.
- Identifies and collects links with parameters.
- Saves the results into two separate JSON files.
- Allows input of URL, domain, IP, or IP and port.
- Prompts for output file names if not provided.

## Requirements

- Python 3.6+
- Scrapy
- Termcolor

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/link-parameter-scraper.git
    cd link-parameter-scraper
    ```

2. Install the required packages:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

### Running the Script

You can run the script either by providing command-line arguments or by entering them when prompted.

#### Command-Line Arguments

- **URL/Domain/IP/IP and Port**: Provide the URL, domain, IP, or IP and port of the target.
- **Output File Base Name**: Provide the base name for the output files.

```bash
python param3r.py --url http://example.com --output myoutput
