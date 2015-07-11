__author__ = 'zweicmu@gmail.com'

import urllib2
import re

GOOGLE_MATERIAL_ICON_CODE_URL = "https://raw.githubusercontent.com/google/material-design-icons/master/iconfont/codepoints"

def read_google_material_icon_raw_code():
  try:
    return urllib2.urlopen(GOOGLE_MATERIAL_ICON_CODE_URL).read()
  except urllib2.URLError as e:
    print "URLError ({0}): {1}".format(e.errno, e.strerror)
    return None

raw_code = read_google_material_icon_raw_code()
if raw_code:
  lines = raw_code.split("\n")
  count = 0
  for line in lines:
    parts = line.split()
    if len(parts) == 2:
    #print 'name : %s , code : %s' % (match.group(1), match.group(2))
      print '"gm-%s": "\u{%s}",' % (parts[0], parts[1])
      count += 1

  print "parsed %s icons" % count
