#! /usr/bin/perl
use warnings;
use strict;
require "./Bank.pm";
require "./Jail.pm";
require "./Land.pm";
require "./Player.pm";


our @game_board = (
    new Bank(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Jail(),
    new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(),
    new Jail(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Jail(),
    new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(), new Land(),
);
our $game_board_size = @game_board;

our @players = (new Player("A"), new Player("B"));
our $num_players = @players;

our $cur_player_idx = 0;
our $cur_player = $players[$cur_player_idx];
our $cur_round = 0;
our $num_dices = 1;

srand(0); # don't touch

# game board printing utility. Used to show player position.
sub printCellPrefix {
    my $position = shift;
    my @occupying = ();
    foreach my $player (@players) {
        if ($player->{position} == $position && $player->{money} > 0) {
            push(@occupying, ($player->{name}));
        }
    }
    print(" " x ($num_players - scalar @occupying), @occupying);
    if (scalar @occupying) {
        print("|");
    } else {
        print(" ");
    }
}

sub printGameBoard {
    print("-"x (10 * ($num_players + 6)), "\n");
    for (my $i = 0; $i < 10; $i += 1) {
        printCellPrefix($i);
        $game_board[$i]->print();
    }
    print("\n\n");
    for (my $i = 0; $i < 8; $i += 1) {
        printCellPrefix($game_board_size - $i - 1);
        $game_board[-$i-1]->print();
        print(" "x (8 * ($num_players + 6)));
        printCellPrefix($i + 10);
        $game_board[$i+10]->print();
        print("\n\n");
    }
    for (my $i = 0; $i < 10; $i += 1) {
        printCellPrefix(27 - $i);
        $game_board[27-$i]->print();
    }
    print("\n");
    print("-"x (10 * ($num_players + 6)), "\n");
}

sub terminationCheck {
    #general case if there is more than 2 players
    my $i = $num_players;
    foreach my $item (@players){
        if($item->{money} <0){
            $i--;
        }
    }
    if($i == 1){
        return 0;
    }else{
        return 1;
    }
}

sub whoWin {

    foreach my $item (@players){
        if ($item->{money}>0){
            return $item->{name};
        }
    }
    return -1;
}

sub throwDice {
    my $step = 0;
    for (my $i = 0; $i < $num_dices; $i += 1) {
        $step += 1 + int(rand(6));
    }
    return $step;
}

sub main {

    my $answer;
    my $check;
    my $move = 0;
    my $fixed_two_throw_charge = 500*(1.05);
    my $cur_name;
    my $position;
    my $idx;

    while (terminationCheck()){  #each round
        printGameBoard();
        foreach my $player (@players) { 
            $player->printAsset();
        }
        for ($idx = 0; $idx<$num_players;$idx++){
            $cur_name = $cur_player->{name};

            if($cur_player->{num_rounds_in_jail} > 0){
                $cur_player->move();
            }else{
                print"\nPlayer $cur_name\'s turn.\n";
                $check = 0;

                while($check!=1){
                    print"Pay \$500 to throw two dice ? [y/n]\n";
                    $answer = <STDIN>;
                    chomp $answer;
                    if($answer eq "y"){
                        #check enough money
                        if($cur_player->{money}<$fixed_two_throw_charge){
                            print"You do not have enough money to throw two dice!\n";
                            next;
                        }

                        #pay money
                        local $Player::due = 500;
                        local $Player::handling_fee_rate = 0.05;
                        $cur_player->payDue($Player::due,$Player::handling_fee_rate );
                        #throw dice
                        $move = throwDice();
                        $move += throwDice();
                        print"You have paid \$$fixed_two_throw_charge for two throw.\n";
                        $cur_player->printAsset();
                        print"Points of dice: $move\n";
                        $cur_player->move($move);
                        $check = 1;
                    }elsif ($answer eq "n"){
                        #throw dice
                        $move = throwDice();
                        print"Points of dice: $move\n";
                        $cur_player->move($move);
                        $check = 1;
                    }else{
                        print"Invalid answer, please enter again.\n";
                    }
                }
            
                printGameBoard();
                #$player->printAsset();

                #according to where the player steps on, different actions
                $position = $cur_player->{position};
                $game_board[$position]->stepOn();
            }
            $cur_player_idx++;
            $cur_player_idx = $cur_player_idx % $num_players;
            $cur_player = $players[$cur_player_idx];
        }
        $cur_round++;
        foreach my $player (@players) { 
            $player->{money} -= 200;
        }
    }
    my $winner = whoWin();
    print"Game over! winner: [$winner].\n";
}

main();
