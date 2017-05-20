import os
import re
import urllib
import urllib2
import urlparse

"""
opener = urllib2.build_opener()
opener.addheaders = [('User-agent', 'Mozilla/5.0')]
infile = opener.open('http://en.wikipedia.org/w/index.php?title=Albert_Einstein&printable=yes')
page = infile.read()

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

storeDir = 'pythontest/'
savePage('http://en.wikipedia.org/w/index.php?title=Albert_Einstein&printable=yes', page)
#"""

import httplib
conn = httplib.HTTPConnection("www.python.org")
conn.request("GET", "/index.html")
r1 = conn.getresponse()
print r1.status, r1.reason
200 OK
data1 = r1.read()
conn.request("GET", "/parrot.spam")
r2 = conn.getresponse()
print r2.status, r2.reason
404 Not Found
data2 = r2.read()
conn.close()