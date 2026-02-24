x = "Hello World"                   #string
x = 'Hello World'                   #string
x = 20                              #int
x = 20.                             #float
x = 1j                              #complex
x = ["apple", "banana", "cherry"]   #list
x = ("apple", "banana", "cherry")   #tuple
x = range(6)                        #range
x = {"name" : "john", "age" : 36}   #dict
x = {"apple", "banana", "cherry"}   #set
x = True                            #bool


x = set()
x = dict()
y = []
y.append(3)
y.append("hallo")
y.append(7.2)
y += [8]
print(y)
y.pop()
y += []
print(y)
y.append([])
print(y)

liste = [1, 2, 3, 4, 5, 6]

for elem in liste:
    print(elem)

animals = ["Hund", "Katze", "Maus", "Elephant"]
for i, animals in enumerate(animals):
    print(f"{i}: {animals}")


