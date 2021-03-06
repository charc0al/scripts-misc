import string
import itertools

charVals = {'A':1, 'B':4, 'C':4,'D':2, 'E':1, 'F':4, 'G':3, 'H':3, 'I':1, 'J':10, 'K':5, 'L':2, 'M':4, 'N':2, 'O':1, 'P':4, 'Q':10, 'R':1, 'S':1, 'T':1, 'U':2, 'V':5, 'W':4, 'row':8, 'col':3, 'Z':10}
board = open("board.txt").readlines()
gameState = open("game1.txt").readlines()
for i in range(0, len(board)):
	board[i] = board[i].replace('\n','').split(' ')
	gameState[i] = gameState[i].replace('\n','').split(' ')
dictionary = open("enable1.txt")
wordslist = dictionary.readlines()
words = set([])

def evalString(word):
	val = 0
	for i in range(0, len(word)):
		val += charVals[word[i]]
	return val
	
def evalWord(word, row, col, direction):
	rowInc = 0
	colInc = 0
	wordVal = 0
	wordMult = 1
	if (direction == 1):
		rowInc = 1
	else:
		colInc = 1
	outStr = ''
	for i in range(0, len(word)):
		tile = board[row+(i*rowInc)][col+(i*colInc)]
		outStr += tile
		charMult = 1
		
		if(gameState[row+(i*rowInc)][col+(i*colInc)] == '0'):
			if	(tile == 'T'):
				wordMult *= 3
			elif(tile == 'D'):
				wordMult *= 2
			elif(tile == 'B'):
				charMult = 2
			elif(tile == 'R'):
				charMult = 3
		
		wordVal += (charVals[word[i]] * charMult)
	print word, '\n', outStr
	return (wordVal * wordMult)

"""	
def evalMove(word, row, col, direction):
	rowInc = 0
	colInc = 0
	if (direction == 1):
		rowInc = 1
	else:
		colInc = 1
	outStr = ''
	for i in range(0, len(word)):
		tile = board[row+(i*rowInc)][(col+(i*colInc))*2]


def getWord(row, col, direction):
	if (direction == 1):
		curCol = col
		startCol = col
		while(gameState[row][curCol] != '0')
			
	else:
#"""		
	
	
print evalWord('JAZZ', 3, 0, 0)

"""
letters = raw_input("Letters available: ")
	

for w in wordslist:
	words.add(string.strip(w))

perms = set([])
for i in range(1,len(letters)+1):
	temp = list(itertools.permutations(letters,i))
	for j in range(0,len(temp)):
		perms.add("".join(temp[j]))
		
perms = sorted(perms, key=lambda item: evalString(item))

for p in perms:
	if p in words:
		print evalString(p),":\t",p
#"""
