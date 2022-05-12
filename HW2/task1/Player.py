"""
Name: Kwan Ting Fung
Student ID: 1155110979
"""

class Player():
    def __init__(self, id, board):
        self.id = id
        self.symbol = '#' if id == 1 else '@' # Player 1: # Player 2: @
        self.board = board

    def get_id(self):
        return self.id

    def get_symbol(self):
        return self.symbol

    def next_put(self):
        """
        This function takes a single location input for PUT-movement. It keeps checking
        whether it is a legal PUT-movement until the input is a legal PUT-movement. After
        getting the correct input, it then does the movement on the board (by calling
        board.put_piece()).
        """
        return None

    def next_move(self):
        """
        This function takes two location inputs (s, t) for PUT-movement. It keeps checking
        whether it is a legal MOVE-movement until the input is a legal MOVE-movement.
        After getting the correct input, it then does the movement on the board (by calling
        board.move_piece()).
        """
        return None

    def next_remove(self, opponent):
        """
        This function takes a location input for REMOVE-movement. It keeps checking whether
        it is a legal REMOVE-movement until the input is a legal REMOVE-movement. After
        getting the correct input, it then does REMOVE-movement on the board (by calling
        board.remove_piece()).
        """
        pass
