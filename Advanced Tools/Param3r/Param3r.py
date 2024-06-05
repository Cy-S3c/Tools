import scrapy
from scrapy.crawler import CrawlerProcess
import argparse
from termcolor import colored, cprint
import re

class LinkSpider(scrapy.Spider):
    name = "link_spider"

    def __init__(self, *args, **kwargs):
        super(LinkSpider, self).__init__(*args, **kwargs)
        self.start_urls = [kwargs.get('start_url')]
        self.allowed_domains = [re.sub(r'^https?://', '', kwargs.get('start_url')).split('/')[0]]

    def parse(self, response):
        try:
            # Collect all clickable links
            links = response.css('a::attr(href)').extract()
            for link in links:
                if link.startswith('/'):
                    link = response.urljoin(link)
                yield {
                    'link': link
                }

                # Follow the links to continue crawling
                if link.startswith(('http://', 'https://')) and self.is_allowed(link):
                    yield scrapy.Request(link, callback=self.parse)

            # Collect all parameters in the URL
            urls_with_params = response.css('a[href*="?"]::attr(href)').extract()
            for url in urls_with_params:
                if url.startswith('/'):
                    url = response.urljoin(url)
                yield {
                    'link_with_params': url
                }
        except Exception as e:
            self.log_error(f"Error occurred: {e}")

    def is_allowed(self, url):
        # Ensure the link belongs to the allowed domains
        domain = re.sub(r'^https?://', '', url).split('/')[0]
        return domain in self.allowed_domains

    def log_error(self, message):
        cprint(message, 'red')

def main():
    parser = argparse.ArgumentParser(
        description=colored("Scrapy script to identify all clickable links and parameters in a website.", "yellow")
    )
    parser.add_argument('--url', type=str, help=colored('The start URL, domain, IP, or IP and port for the spider', 'yellow'))
    parser.add_argument('--output', type=str, help=colored('The base name for the output files', 'yellow'))
    parser.add_argument('--version', action='version', version=colored('by v0rt3x version 0.1', 'yellow'))
    args = parser.parse_args()

    # Prompt for URL if not provided
    if not args.url:
        args.url = input("Please enter the start URL, domain, IP, or IP and port: ")

    # Ensure the URL has a scheme
    if not args.url.startswith(('http://', 'https://')):
        args.url = 'http://' + args.url

    # Prompt for output file name if not provided
    if not args.output:
        args.output = input("Please enter the base name for the output files: ")

    links_file = f"{args.output}_Links.json"
    params_file = f"{args.output}_Params.json"

    print(colored(f"Starting spider for URL: {args.url}", "green"))
    print(colored(f"Links will be saved to: {links_file}", "green"))
    print(colored(f"Links with parameters will be saved to: {params_file}", "green"))

    # Set up Scrapy project
    process = CrawlerProcess(settings={
        'FEEDS': {
            links_file: {'format': 'json', 'fields': ['link']},
            params_file: {'format': 'json', 'fields': ['link_with_params']}
        },
        'LOG_LEVEL': 'INFO'
    })

    process.crawl(LinkSpider, start_url=args.url)
    process.start()
    print(colored("Crawling completed.", "green"))

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        cprint(f"An error occurred: {e}", 'red')
