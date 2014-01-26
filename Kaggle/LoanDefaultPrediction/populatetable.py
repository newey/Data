from itertools import count, izip
import sqlite3
f = open("train.csv")

head = f.readline().strip().split(",")

types = {}

conn = sqlite3.connect('train.db')

c = conn.cursor()
for index, line in izip(count(), f):
    line = line.replace("NA","NULL")
    insertcommand = "INSERT INTO train VALUES (%s)" % line
    c.execute(insertcommand)
    if (index % 1000 == 0):
        conn.commit()
        print index

conn.commit()
conn.close()

