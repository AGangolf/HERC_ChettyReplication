import sys
import re
import requests as rq
from bs4 import BeautifulSoup as bs
from time import sleep
from time import time
from random import randint
from warnings import warn
import json
import pandas as pd
import csv

url = 'http://web.archive.org/cdx/search/cdx?url=nytimes.com/interactive/2020/us/states-reopen-map-coronavirus.html&collapse=digest&from=20200430&to=20200701&output=json'

urls = rq.get(url).text
parse_url = json.loads(urls)

url_list = []
for i in range(1,len(parse_url)):
    orig_url = parse_url[i][2]
    tstamp = parse_url[i][1]
    waylink = tstamp+'/'+orig_url
    url_list.append(waylink)

finalData = [[]]

for url in url_list:
    final_url = 'https://web.archive.org/web/'+url
    req = rq.get(final_url).text
    page = rq.get(final_url)

    stateAtts = [[]]
    soup = bs(page.content, "html.parser")
    results = soup.find(class_="g-asset g-graphic g-graphic-list")
    state_elements = results.find_all("div", class_=re.compile('^g-state '))
    for state_element in state_elements:
        name_element = state_element.find("div", class_="g-name")
        reopened_elements = state_element.find_all("div", class_=re.compile('(?!g-details-wrap-)^g-details-wrap'))
        for reopened_element in reopened_elements:
            type_element = reopened_element.find("div", class_="g-details-subhed")
            reopening_elements = reopened_element.find_all("div", class_="g-cat-details-wrap")
            for reopening_element in reopening_elements:
                sector_element = reopening_element.find("div", class_="g-cat-name")
                detail_element = reopening_element.find("div", class_="g-cat-text")
                stateAtts.insert(-1, [url[0:14], name_element.text.strip(),type_element.text.strip(),sector_element.text.strip(),detail_element.text.strip()])

    for row in stateAtts:
        finalData.insert(-1, row)

finalData.insert(0, ['Timestamp','State','Status','Sector','Details'])

with open("nyt_reopening_data.csv","w+") as my_csv:
    csvWriter = csv.writer(my_csv,delimiter=',')
    csvWriter.writerows(finalData)
