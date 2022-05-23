from Soldier import Soldier

class Task4Soldier(Soldier):
    def __init__(self):
        Soldier.__init__(self)
        self.coins = 0
        self.defence = 0
    
    def getCoins(self):
        return self.coins

    def addCoins(self):
        self.coins = self.coins + 1

    def useCoins(self, price):
        self.coins = self.coins - price

    def addDefence(self):
        self.defence = self.defence +5

    def displayInformation(self):
        super(Task4Soldier,self).displayInformation()
        print("Defence: {}".format(self.defence))
        print("Coins: {}".format(self.coins))

    def loseHealth(self):
        super(Task4Soldier,self).loseHealth()
        if self.defence>10:
            self.health = self.health+10
            self.defence = self.defence-10
        else:
            self.health = self.health + self.defence
            self.defence = 0
        return True if self.health<=0 else False
