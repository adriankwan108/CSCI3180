import random

random.seed(0) # don't touch!

# you are not allowed to modify Player class!
class Player:
    due = 200
    income = 0
    tax_rate = 0.2
    handling_fee_rate = 0
    prison_rounds = 2

    def __init__(self, name):
        self.name = name
        self.money = 100000
        self.position = 0
        self.num_rounds_in_jail = 0

    def updateAsset(self):
        self.money += Player.income

    def payDue(self):
        self.money += Player.income * (1 - Player.tax_rate)
        self.money -= Player.due * (1 + Player.handling_fee_rate)

    def printAsset(self):
        print("Player %s's money: %d" % (self.name, self.money))

    def putToJail(self):
        self.num_rounds_in_jail = Player.prison_rounds

    def move(self, step):
        if self.num_rounds_in_jail > 0:
            #print("in jail:{}".format(self.num_rounds_in_jail))
            self.num_rounds_in_jail -= 1
        else:
            self.position = (self.position + step) % 36


class Bank:
    def __init__(self):
        pass

    def print(self):
        print("Bank ", end='')

    def stepOn(self):

        # ...
        Player.due = 0
        Player.handling_fee_rate = 0
        Player.income = 2000
        Player.tax_rate = 0

        cur_player.payDue()
        print("You received $2000 from the Bank!")

        return

class Jail:
    def __init__(self):
        pass

    def print(self):
        print("Jail ", end='')

    def stepOn(self):
        check = 0
        # ...\
        if (cur_player.num_rounds_in_jail == 0):
            while (check!=1):
                print("Pay $1000 to reduce the prison round to 1? [y/n]")
                answer = input()
                if (answer == "y"):
                    require = 1000 * 1.01
                    if(cur_player.money<require):
                        print("You do not have enough money to reduce the prison round!")
                        continue
                    else:
                        Player.due = 1000
                        Player.handling_fee_rate = 0.1
                        Player.income = 0
                        Player.tax_rate = 0
                        cur_player.payDue()

                        Player.prison_rounds = 1
                        cur_player.putToJail()
                        check = 1
                elif (answer =="n"):
                    Player.prison_rounds = 2
                    cur_player.putToJail()
                    check = 1
                else:
                    check = 0
                    print("Invalid input, please try again")

        cur_player.putToJail()


class Land:
    land_price = 1000
    upgrade_fee = [1000, 2000, 5000]
    toll = [500, 1000, 1500, 3000]
    tax_rate = [0.1, 0.15, 0.2, 0.25]

    def __init__(self):
        self.owner = None
        self.level = 0

    def print(self):
        if self.owner is None:
            print("Land ", end='')
        else:
            print("%s:Lv%d" % (self.owner.name, self.level), end="")
    
    def buyLand(self):
        # ...
        fin_amount  = Land.land_price * 1.1
        if(cur_player.money < fin_amount):
            print("You do not have enough money to buy the land!")
            return 0
        else:
            Player.due = 1000
            Player.handling_fee_rate = 0.1
            Player.income = 0
            Player.tax_rate = 0
            cur_player.payDue()
            print("You have bought the land for {}".format(fin_amount))
            cur_player.printAsset()
            return 1

    
    def upgradeLand(self):
        
        # ...
        fin_amount = Land.upgrade_fee[self.level] * 1.1
        if(cur_player.money < fin_amount):
            print("You do not have enough money to upgrade the land!")
            return 0
        else:
            Player.due = Land.upgrade_fee[self.level]
            Player.handling_fee_rate = 0.1
            Player.income = 0
            Player.tax_rate = 0
            cur_player.payDue()
            print("You have upgraded the land")
            cur_player.printAsset()
            return 1
        
    
    def chargeToll(self):
        
        # ...
        Player.due = Land.toll[self.level]
        print("You need to pay player{} ${}.".format(self.owner.name,Player.due))
        if(Land.toll[self.level]>cur_player.money):
            Player.due = cur_player.money
        
        Player.handling_fee_rate = 0
        Player.income = 0
        Player.tax_rate = 0
        cur_player.payDue()
        cur_player.printAsset()
        # ...
        Player.due = 0
        Player.income = Land.toll[self.level]
        Player.handling_fee_rate = 0
        Player.tax_rate = Land.tax_rate[self.level]
        self.owner.payDue()
        #self.owner.printAsset()


    def stepOn(self):
        # ... 
        if(self.owner is None):
            check = 0
            while (check!=1):
                print("Pay $1000 to buy the land? [y/n]")
                answer = input()
                if (answer == "y"):
                    if(self.buyLand()):
                        self.owner = cur_player
                    check = 1
                elif (answer == "n"):
                    check = 1
                else:
                    print("Invalid answer, please enter again.")
        elif (self.owner == cur_player):
            check = 0
            while (check!=1):
                if(self.level<3):
                    print("Pay ${} to upgrade the land? [y/n]".format(Land.upgrade_fee[self.level]))

                    answer = input()
                    if (answer == "y"):
                        if(self.upgradeLand()):
                            self.level = self.level +1
                        check = 1
                    elif (answer == "n"):
                        check = 1
                    else:
                        print("Invalid answer, please enter again.")
                else:
                    check = 1
        else:
            self.chargeToll()


players = [Player("A"), Player("B")]
cur_player = players[0]
num_players = len(players)
cur_player_idx = 0
cur_player = players[cur_player_idx]
num_dices = 1
cur_round = 0

game_board = [
    Bank(), Land(), Land(), Land(), Land(), Land(), Land(), Land(), Land(), Jail(),
    Land(), Land(), Land(), Land(), Land(), Land(), Land(), Land(),
    Jail(), Land(), Land(), Land(), Land(), Land(), Land(), Land(), Land(), Jail(),
    Land(), Land(), Land(), Land(), Land(), Land(), Land(), Land()
]
game_board_size = len(game_board)


def printCellPrefix(position):
    occupying = []
    for player in players:
        if player.position == position and player.money > 0:
            occupying.append(player.name)
    print(" " * (num_players - len(occupying)) + "".join(occupying), end='')
    if len(occupying) > 0:
        print("|", end='')
    else:
        print(" ", end='')


def printGameBoard():
    print("-" * (10 * (num_players + 6)))
    for i in range(10):
        printCellPrefix(i)
        game_board[i].print()
    print("\n")
    for i in range(8):
        printCellPrefix(game_board_size - i - 1)
        game_board[-i - 1].print()
        print(" " * (8 * (num_players + 6)), end="")
        printCellPrefix(i + 10)
        game_board[i + 10].print()
        print("\n")
    for i in range(10):
        printCellPrefix(27 - i)
        game_board[27 - i].print()
    print("")
    print("-" * (10 * (num_players + 6)))


def terminationCheck():

    # ...
    j = num_players

    for i in range(num_players):
        if (players[i].money < 0):
            j = j-1

    if(j == 1):
        return False
    else:
        return True


def throwDice():
    step = 0
    for i in range(num_dices):
        step += random.randint(1, 6)
    return step

def whoWin():
    for j in range(num_players):
        if (players[j].money>0):
            return players[j].name
    return -1


def main():
    global cur_player
    global num_dices
    global cur_round
    global cur_player_idx

    while terminationCheck():
        printGameBoard()
        for player in players:
            player.printAsset()
        for idx in range(num_players):
            if(cur_player.num_rounds_in_jail>0):
                #print("jail:{}".format(cur_player.num_rounds_in_jail))
                cur_player.move(0)
            else:
                print ("\nPlayer {}'s turn.".format(cur_player.name))
                check = 0
                while(check!=1):
                    print("Pay $500 to throw two dice ? [y/n]")
                    answer = input()
                    if (answer == "y"):
                        if(cur_player.money < (500*1.05)):
                            print("You do not have enough money to throw two dice!\n")
                            continue
                        else:
                            Player.due = 500
                            Player.handling_fee_rate = 0.05
                            cur_player.payDue()

                            step = throwDice()
                            step += throwDice()
                            print("You have paid 525 for two throw.")
                            print("Points of dice: {}".format(step))
                            cur_player.move(step)
                            check = 1
                            cur_player.printAsset()

                    elif(answer == "n"):
                        step = throwDice()
                        print("Points of dice: {}".format(step))
                        cur_player.move(step)
                        check = 1
                    else:
                        print("Invalid answer, please enter again.")
                #end dice
                printGameBoard()
                position = cur_player.position
                game_board[position].stepOn()

            cur_player_idx = cur_player_idx+1
            cur_player_idx = cur_player_idx % num_players
            cur_player = players[cur_player_idx]
        for j in range(num_players):
            players[j].money -= 200

    # ...
    winner = whoWin()
    print("Game over! winner: {}".format(winner))

if __name__ == '__main__':
    main()
