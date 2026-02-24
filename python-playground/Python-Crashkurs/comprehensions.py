# List Comprehensions

# 1. Finde alle Quadrateyahlen von 0 bis 100

liste = []

for i in range(100):
    liste += [i]

#print(liste)

liste = list(range(101))
#print(liste)

liste = [num * num for num in range(101) if num * num in liste]
#print(liste)

liste = [num ** 2 for num in range(101)]
#print(liste)

print([e for e in range(100) if e ** 0.5 == int(e ** 0.5)])

