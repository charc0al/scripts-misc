#web-crawler.py
#Charlie Mehrer
#EECS 767

import os
import re
import urllib
import urllib2
import urlparse

#urllib.quote_plus()

def savePage(url, data):
	if url[2].endswith('/'):
		#path = storeDir + url[1] + url[2][0:len(url[2])-1] + '.html'
		path = storeDir + url[1] + url[2] + 'index.html'
	elif (not url[2]) or (url[2][url[2].rfind('/'):len(url[2])].find('.') == -1):
		path = storeDir + url[1] + url[2] + '/index.html'
	else:
		path = storeDir + url[1] + re.sub('\?', '(&q&)', url[2])
	path = re.sub('\./', '.(&end&)/', path)
	path = re.sub(':', '(&col&)', path)
	print "writing to ", path
	dir = os.path.dirname(path)
	if not os.path.exists(dir):
		os.makedirs(dir)
	f = open(path, 'w')
	f.write(data)
	f.close()

	
crawlDegree = 3
l = '<a\s*href=[\'|"](.*?)[\'"].*?>'
frontier = set([])
crawled = set([])

f = open('seed.txt', 'r')
storeDir = 'crawler-download/'

while(1):
	temp = f.readline().strip()
	if(temp):
		frontier.add(temp)
	else:
		break
		
#print "Seed URLs:"
#for x in frontier:
#	print x

for cd in range(crawlDegree): #crawl to a maximum depth of crawlDegree
	new_frontier = set([])
	while(len(frontier)): #crawl everything in the current frontier before crawling new frontier
		curPage = frontier.pop()
		print "crawling ", curPage
		crawled.add(curPage)
		try:
			curHTML = urllib2.urlopen(curPage).read()
		except:
			continue
		curURL = urlparse.urlparse(curPage)
		savePage(curURL, curHTML)
		links = re.findall(l, curHTML)
		
		title = re.sub('\A\s+', '', curHTML[curHTML.find('<title>')+7:curHTML.find('</title>')]) #find title tags
		print title, "\n", curPage, " - ", len(links), "links\n"
		
		flag = 0;
		for x in links:
			linkURL = urlparse.urlparse(x)
			if (not linkURL[1]) or (linkURL[1] == curURL[1]): #check if the link is in the same domain		
				if not linkURL[0]:
					if not linkURL[1]: 
						x = curURL[1] + x
					x = curURL[0] + "://" + x
				if x not in crawled:
					new_frontier.add(x)

	frontier = new_frontier
	
print len(crawled), " URLs crawled"
print len(frontier), " URLs in frontier"
#for x in frontier:
#	print x