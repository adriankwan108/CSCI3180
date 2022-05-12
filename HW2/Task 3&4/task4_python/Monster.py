from Pos import Pos

class Monster():
    def __init__(self, monsterID, healthCapacity):
        self.monsterID = monsterID
        self.healthCapacity = healthCapacity
        self.health = healthCapacity
        self.pos = Pos()
        self.dropItemList = []
        self.hintList = []

    def addDropItem(self, key):
        self.dropItemList.append(key)

    def addHint(self, monsterID):
        self.hintList.append(monsterID)

    def getPos(self):
        return self.pos

    def setPos(self, row, column):
        self.pos.setPos(row,column)

    def getHealthCapacity(self):
        return self.healthCapacity

    def getHealth(self):
        return self.health

    def loseHealth(self):
        #return boolean
        self.health = self.health - 10
        return (True if self.health<=0 else False)

    def recover(self, healingPower):
        self.health = healingPower

    def requireKey(self, keys):
        #return boolean
        return True if self.monsterID in keys else False

    def talk(self, text):
        print("Monster{}: {}".format(self.monsterID, text))

    def displaySymbol(self):
        print("M",end="")

    def dropItems(self, soldier):
        for item in self.dropItemList:
            soldier.addKey(item)

    def displayHints(self):
        self.talk("Defeat Monster" + ' '.join([str(elem) for elem in self.hintList]) + " first.")
    
    def fight(self, soldier):
        fightEnabled = True
        while(fightEnabled):
            print("       | Monster{} | Soldier |".format(self.monsterID))
            print("Health | %8d | %7d |" % (self.health, soldier.getHealth()))
            x = input("=> What is the next step? (1 = Attack, 2 = Escape, 3 = Use Elixir.) Input: ")
            if x == '1':
                if(self.loseHealth()):
                    print("=> You defeated Monster%d." % (self.monsterID))
                    self.dropItems(soldier)
                    fightEnabled = False
                else:
                    if(soldier.loseHealth()):
                        self.recover(self.healthCapacity)
                        fightEnabled = False
            elif x == '2' :
                self.recover(self.healthCapacity)
                fightEnabled = False
            elif x == '3' :
                if(soldier.getNumElixirs()==0):
                    print("=> You have run out of elixirs.")
                else:
                    soldier.useElixir()
            else:
                print("=> Illegal choice!")

    def actionOnSoldier(self, soldier):
        if(self.health <= 0):
            self.talk("You have defeated me.")

        elif(self.requireKey(soldier.getKeys())):
            self.fight(soldier)
        else:
            self.displayHints()