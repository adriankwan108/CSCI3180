from Cell import Cell
from Pos import Pos
from Monster import Monster
from Soldier import Soldier
from Spring import Spring

class Map():

    def __init__(self):
        self.cells=[[Cell() for i in range(7)] for j in range(7)]
       
    def addObject(self, objectAdd):
        pos = Pos()
        pos = objectAdd.getPos()
        self.cells[pos.getRow()-1][pos.getColumn()-1].setOccupiedObject(objectAdd)
 

    def displayMap(self):
        print("   | 1 | 2 | 3 | 4 | 5 | 6 | 7 |")
        print("--------------------------------")
        for i in range(7):
            print(" %d |" % (i+1),end="")
            for j in range(7):
                occupiedObject = self.cells[i][j].getOccupiedObject()
                #print(type(occupiedObject))
                if occupiedObject != None:
                    print(" ",end="")
                    occupiedObject.displaySymbol()
                    print(" |",end="") 
                else:
                    print("   |",end="")
            print("")
            print("--------------------------------")
        print("")

    def getOccupiedObject(self, row, column):
        return self.cells[row-1][column-1].getOccupiedObject()
    
    def checkMove(self, row, column):
        #return boolean
        return True if ((row>=1 and row<=7) and (column >=1 and column<=7)) else False

    def update(self, soldier, oldRow, oldColumn, newRow, newColumn):
        self.cells[oldRow-1][oldColumn-1].setOccupiedObject(None)
        self.cells[newRow-1][newColumn-1].setOccupiedObject(soldier)
                        