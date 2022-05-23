import random; random.seed(0)
from Cell import Cell
from Map import Map
from Monster import Monster
from Pos import Pos
from Soldier import Soldier
from Spring import Spring

class SaveTheTribe():
    def __init__(self):
        self.map = Map()
        self.soldier = Soldier()
        self.spring = Spring()
        self.monster = list()
        self.gameEnabled = True

    def initialize(self):
        #rand = random.randint(0,5)*10+30
        for i in range(1,8):
            self.monster.append(Monster(i, random.randint(0,5)*10+30))
        self.monster[0].setPos(4,1)
        self.monster[1].setPos(3,3)
        self.monster[2].setPos(5,3)
        self.monster[3].setPos(5,5)
        self.monster[4].setPos(1,4)
        self.monster[5].setPos(3,5)
        self.monster[6].setPos(4,7)

        self.monster[0].addDropItem(2)
        self.monster[0].addDropItem(3)
        self.monster[1].addDropItem(3)
        self.monster[1].addDropItem(6)
        self.monster[2].addDropItem(4)
        self.monster[4].addDropItem(2)
        self.monster[4].addDropItem(6)
        self.monster[5].addDropItem(4)
        self.monster[5].addDropItem(7)
        self.monster[6].addDropItem(-1)

        self.monster[1].addHint(1)
        self.monster[1].addHint(5)
        self.monster[2].addHint(1)
        self.monster[2].addHint(2)
        self.monster[3].addHint(3)
        self.monster[3].addHint(6)
        self.monster[4].addHint(2)
        self.monster[4].addHint(6)
        self.monster[5].addHint(2)
        self.monster[5].addHint(5)
        self.monster[6].addHint(6)

        for item in self.monster:
            self.map.addObject(item)

        self.soldier.setPos(1,1)
        self.soldier.addKey(1)
        self.soldier.addKey(5)
        self.map.addObject(self.soldier)

        self.spring.setPos(7,4)
        self.map.addObject(self.spring)
        

    def start(self):
        print("=>Welcome to the desert!")
        print("=>Now you have to defeat the monsters and find the artifact to save the tribe")
        while(self.gameEnabled==True):
            self.map.displayMap()
            self.soldier.displayInformation()
            print("")
            x = input("=> What is the next step? (W = Up, S = Down, A = Left, D = Right.) Input: ")

            pos = Pos()
            pos = self.soldier.getPos()

            newRow = pos.getRow()
            oldRow = pos.getRow()
            newColumn = pos.getColumn()
            oldColumn = pos.getColumn()

            if x.casefold() == 'w':
                newRow = oldRow-1
            elif x.casefold() == 's':
                newRow = oldRow +1
            elif x.casefold() == 'a':
                newColumn = oldColumn -1
            elif x.casefold() == 'd':
                newColumn = oldColumn +1
            else:
                print("=>Illegal move!")
                continue

            if self.map.checkMove(newRow, newColumn):
                occupiedObject = self.map.getOccupiedObject(newRow,newColumn)
                if type(occupiedObject) == Monster or type(occupiedObject) ==Spring:
                    occupiedObject.actionOnSoldier(self.soldier)
                elif type(occupiedObject) == type(None):
                    self.soldier.move(newRow, newColumn)
                    self.map.update(self.soldier, oldRow, oldColumn, newRow, newColumn)
                else:
                    print(type(occupiedObject))
                    print("=> Illegal move!")

            if self.soldier.getHealth() <=0 :
                print("=> You died.")
                print("=> Game over.")
                print(" ")
                self.gameEnabled = False

            if -1 in self.soldier.getKeys():
                print("=> You found the artifact.")
                print("=> Game over.")
                self.gameEnabled = False

            
                    
if __name__ == '__main__':
    game  = SaveTheTribe()
    game.initialize()
    game.start()