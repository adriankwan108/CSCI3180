from Pos import Pos

class Merchant():
    def __init__(self):
        self.elixirPrice = 1
        self.shieldPrice = 2
        self.pos = Pos()

    def talk(self, text):
        print("Merchant$: "+ text)

    def actionOnSoldier(self, soldier):
        fightEnabled = True
        while(fightEnabled):
            self.talk("Do you want to buy something? (1. Elixir, 2. Shield, 3.Leave.) Input: ")
            x = input()
            if x == '1':
                if(soldier.getCoins()>0):
                    print("=>You buy an elixir")
                    soldier.addElixiers()
                    soldier.useCoins(1)
                    fightEnabled = False
                else:
                    self.talk("You don't have enough coins.")
                    fightEnabled = False
            elif x == '2' :
                if(soldier.getCoins()>1):
                    print("=>You buy a shield")
                    soldier.useCoins(2)
                    soldier.addDefence()
                    fightEnabled = False
                else:
                    self.talk("You don't have enough coins.")
                    fightEnabled = False
            elif x == '3' :
                print("=> You leave.")
                fightEnabled = False
            else:
                print("=> Illegal choice!")
        
    def getPos(self):
        return self.pos

    def setPos(self, row, column):
        self.pos.setPos(row,column)
 
    def displaySymbol(self):
        print("$",end="")