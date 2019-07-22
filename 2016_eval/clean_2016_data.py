# Script to turn raw chart data into a csv
import re

# Open file
f = open("raw_2016_data.txt", "r")

c = f.read()

text = re.sub("[ ]", ",", c)
text = text.replace("%","")
text = text.replace("▲","-")
text = text.replace("▼","-")
text = text.replace("n/a","-")
text = text.replace("-","0")

print(text)

with open('youth_2016.csv','w') as file:
    for l in text:
        file.write(l)

print("process complete")
