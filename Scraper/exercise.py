import requests
import re
from bs4 import BeautifulSoup

# URL = "https://web.archive.org/web/20200430060132/nytimes.com/interactive/2020/us/states-reopen-map-coronavirus.html"
URL = "https://web.archive.org/web20200501002608/https://www.nytimes.com/interactive/2020/us/states-reopen-map-coronavirus.html"
page = requests.get(URL)

stateAtts = [[]]
soup = BeautifulSoup(page.content, "html.parser")
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
            stateAtts.insert(-1, [name_element.text.strip(),type_element.text.strip(),sector_element.text.strip(),detail_element.text.strip()])

print(stateAtts)
