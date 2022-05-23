from Monster import Monster

class Task4Monster(Monster):
    def __init__(self, monsterID, healthCapacity):
        Monster.__init__(self, monsterID, healthCapacity)

    def dropItems(self, soldier):
        super(Task4Monster,self).dropItems(soldier)
        soldier.addCoins()
    