from utils import *
from Player import Player
import random

class Computer(Player):
    def __init__(self, id, board):
        super(Computer, self).__init__(id, board)

    def next_put(self):
        """
        This function randomly generates a legal PUT-movement and does the movement on
        the board (by calling board.put_piece()).
        """
        x = random.randint(0, 15)
        while self.board.check_put(x)==False:
            x = random.randint(0, 15)
        
        print('{} [Put] (pos): {}'.format( \
            g('Player 1') if self.id == 1 else b('Player 2'), pos_to_sym(x) ))

        self.board.put_piece(x, self)
        return x

    def next_move(self):
        """
        This function randomly generates a legal MOVE-movement (s,t) and then does the
        movement on the board (by calling board.move_piece()).
        """
        xs, xt = random.randint(0, 15), random.randint(0, 15)
        while self.board.check_move(xs,xt,self)==False:
            xs, xt = random.randint(0, 15), random.randint(0, 15)

        print('{} [Move] (from to): {} {}'.format( \
            g('Player 1') if self.id == 1 else b('Player 2'), pos_to_sym(xs), pos_to_sym(xt) ))
        self.board.move_piece(xs, xt, self)
        return xt

    def next_remove(self, opponent):
        """
        This function randomly generates a legal REMOVE-movement and does REMOVEmovement
        on the board (by calling board.remove_piece()).
        """
        
        ### TODO
        x = random.randint(0,15)
        while self.board.check_remove(x,opponent)==False:
            x = random.randint(0,15)


        print('{} [Remove] (pos): {}'.format( \
            g('Player 1') if self.id == 1 else b('Player 2'), pos_to_sym(x)))
        self.board.remove_piece(x, opponent)
