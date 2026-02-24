# Finde alle Zahlen von 1-1000 die durch 7 teilbar sind (benutze slicing)

liste = []

liste = list(range(1001))

#print(liste[1:1000:i:f elem(7 == 0)])

print([x for x in range(1, 1001) if x% 7 == 0])

# mit List slicing

pass

# Erzeuge alle Paare (x, y) für x und y aus 0 bis 20 mit x + y ist teilbar durch 2

print([x for x in range(20)])

print([(x, y) for x in range(21) for y in range(21) if (x+y) % 2 == 0])

# Erzeuge alle Spielkarten eines Skatdecks (für  ♠ ♥ ♦ ♣  7-10, J, Q, K, A)

symbol = ['♠','♥ ','♦','♣']
print(symbol)

print([f"{v}{s}" for s in "♠♥♦♣" for v in list(range(7, 11)) + ["J", "Q", "K", "A"]])

# Dictionary Comprehensions (combi von lists)
char_list = [chr(x) for x in range(ord('a'), ord('z') +1)]
index_list = list(range(ord('a'), ord('z') + 1))
map_dict = {key : value for key in char_list for value in index_list}

print(map_dict)

# Ternary

a = 2
b = 'odd' if a % 2 else 'even'
print(b)
