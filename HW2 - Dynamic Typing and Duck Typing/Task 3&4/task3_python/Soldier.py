from Pos import Pos
import random; random.seed(0)

class Soldier():
    def __init__(self):
        self.health = 100
        self.numElixirs = 2
        self.pos = Pos()
        self.keys = set()

    def getHealth(self):
        return self.health

    def loseHealth(self):
        self.health = self.health -10
        return True if self.health<=0 else False

    def recover(self, healingPower):
        totalHealth = healingPower + self.health
        self.health = totalHealth
        if self.health >=100:
            self.health = 100

    def getPos(self):
        return self.pos

    def setPos(self, row, column):
        self.pos.setPos(row, column)

    def move(self, row ,column):
        self.pos.setPos(row, column)

    def getKeys(self):
        return self.keys

    def addKey(self,key):
        self.keys.add(key)

    def getNumElixirs(self):
        return self.numElixirs

    def addElixiers(self):
        self.numElixirs = self.numElixirs +1

    def useElixir(self):
        self.recover((random.randrange(6) + 15))
        self.numElixirs = self.numElixirs-1

    def displayInformation(self):
        print("Health: {}.".format(self.health))
        print("Position (row, column): ({}, {}).".format(self.pos.getRow(), self.pos.getColumn()))
        print("Keys:" + ' '.join([str(elem) for elem in self.keys]))
        print("Elixirs:{}.".format(self.numElixirs))

    def displaySymbol(self):
        print("S",end="")