use strict;
use warnings;

package Game;
use MannerDeckStudent; 
use Player;

sub new {
    my $class = shift @_;
    my $deck = MannerDeckStudent->new();
    my @players=();
    my @cards = ();
    my $object = {
        "deck" => $deck,
        "players" => \@players,
        "cards" => \@cards,
    };
    bless $object, $class;
    return $object;
}

sub setPlayers {

    my $self = shift @_;
    my $player_name = shift @_;
  
    my $id = 0;
    my @buffer = $self->{"players"};
    for my $names (@$player_name){
        $buffer[$id]=$names;
        $id++;
    }

    my $pLength = @buffer;
    if($pLength == 0){
        print"Error: cards' number 52 can not be divided by players number 0!";
        return 0;
    }elsif($pLength%2 ==1 && $pLength>1){
        print"Error: card's number 52 can not be divided by players number $pLength!\n";
        return 0;
    }else{
        print "There $pLength players in the game:\n";
        print "@buffer\n\n";

        #set players variable
        for (my $j = 0; $j<$pLength; $j++){ 
            push($self->{"players"}, Player->new($buffer[$j]));
        }
    
        return 1;
    }
}

sub getReturn {
    #calculate how many will be returned to the player from the current desktop card stack
    my $self = shift @_;
    my @desktop = @{$self->{"cards"}};
    my $totalNum = $self->Player::numCards();
    
    my $i;
    my $check = $desktop[($totalNum-1)];
    my $counter = 1;
    my $flag = 0;
    #print"check = $check\n";
    if($check eq "J" ){
        #print"totalNum = $totalNum\n";
        if($totalNum==1){  #only "J" left
            return 0; #cannot take back
        }
        else{
            return $totalNum;
        }
    }else{
        for($i=($totalNum-2);$i>=0; $i--){
            $counter++;
            if($check eq $desktop[$i]){
                $flag = 1;
                last;
            }
        }
        if($flag == 1){
            return $counter;
        }else{
            return 0;
        }
    }
}

sub showCards {
	#show the cards on the cards stack
    my $self = shift @_;
    my @card = @{$self->{"cards"}};
    print("@card\n");
}

sub whoWin {
    my $self = shift @_;
    my $playerNum = @{$self->{"players"}};
    my @players = @{$self->{"players"}};

    my $i;
    for($i=0; $i<$playerNum; $i++){
        if($players[$i]->numCards()!=0){
            return $i;
        }
    }
    return -1;
}

sub startGame {
    my $self = shift @_; #get class
    print "Game begin!!!\n\n";
    my $deck = $self->{"deck"};
    #print "$deck";

    #shuffle deck
    $deck->shuffle();
    #my @try = @{$self->{"deck"}->{"cards"}};
    #print "shuffle = @try\n";

    #each  participant get a deckk
    my $playerNum = @{$self->{"players"}};
    my @shuffle = $deck->AveDealCards($playerNum);

    my @players = @{$self->{"players"}};
    my $i;
    for($i=0; $i<($playerNum); $i++){
        $players[$i]->{"cards"}=$shuffle[$i];
    }

    #for(my $j=0; $j<$playerNum; $j++){
    #   my @case = @{$players[$j]->{"cards"}};
    #    print "$j:@case\n";
    #}

    #deal cards and get cards by turn
    my $currPlayer;
    my $currCard;
    my $dealing;
    my $returnNum;
    my $j; #returnNum index
    my $gameCount = 0;
    my $checkWin = $playerNum;

    while ($checkWin !=1){
    #while ($gameCount!=20){    #this while is for checking
        for($i = 0; $i<$playerNum;$i++){
            $currPlayer = $players[$i]->{"name"};
            $currCard = $players[$i]->numCards();
            
            if($currCard==0){
                next;
            }else{
                #Player Info Before
                print"Player $currPlayer has $currCard cards before deal.\n";

                #Game Info Before
                print"=====Before player's deal=======\n";
                $self->showCards();
                print"================================\n";

                #Deal
                $dealing = $players[$i]->dealCards();
                push($self->{"cards"}, $dealing);

                #Check Situation
                #get some or no return
                $returnNum = $self->getReturn();
                if($returnNum != 0){
                    for($j = 0; $j<$returnNum;$j++){
                        $players[$i]->getCards(pop($self->{"cards"}));
                    }
                }

                #Game Info After
                print"=====After player's deal=======\n";
                $self->showCards();
                print"================================\n";

                #update
                $currCard = $players[$i]->numCards();
                #Player Info After
                print"Player $currPlayer has $currCard cards after deal.\n";
                if($currCard ==0){
                    $checkWin--;
                    print"Player $currPlayer has no cards, out!\n";
                }
                if($checkWin == 1){
                    last;
                }
            }
            print"\n";
        }
        $gameCount++;
    }

    #finally, show winner
    my $index = $self->whoWin();
    my $winner = $players[$index]->{"name"};
    print("\nWinner is $winner in game $gameCount\n");

}

return 1;
