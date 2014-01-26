from itertools import count, izip
import sqlite3
f = open("trainhead.csv")

head = f.readline().strip().split(",")

types = {}

for i in head:
  types[i] = "INTEGER"

for line in f:
  for (i, index) in izip(line.split(','), count()):
    if '.' in i:
      types[head[index]] = "REAL"

types["id"] = "INTEGER PRIMARY KEY"

tablestr = "(" + ','.join(["%s %s" % (i, types[i]) for i in head]) + ")"

conn = sqlite3.connect('train.db')
c = conn.cursor()

tablecommand = "CREATE TABLE train %s" % tablestr

c.execute(tablecommand)
conn.commit()
conn.close()

