# Code to create a better gestfips state code

# Open file
f = open("codes_ugly.txt", "r")

c = f.read()

test = c.split()

length = len(test)

gestfips_dict = {}

# Build a dict such that "state":"number"
for x in range(0,length,2):
    num = test[x]
    state = test[x+1]
    
    gestfips_dict[state] = num

# Retrieve user queries of state and return correct number

print("Here are your gestfips codes")

with open('inputs.txt', 'r') as data:
    temp = data.read().splitlines()
    for line in temp:
        print(gestfips_dict[line])