use strict;
use warnings;

package Player;
sub new {
    my $class = shift @_;
    my @cards =(); #1D array for one player' s deck
    my $name = shift @_;
    my $object = {
        "name" => $name,
        "cards" => \@cards,
    };
    bless $object, $class;
    return $object;
}

sub getCards {
    #take cards from Game.pm to bottom of my deck
    my $self = shift @_;
    my $card = shift @_;
    push($self->{"cards"}, $card);
    #print"get card = $card\n";
}

sub dealCards {
    #take a card from the top of deck
    my $self = shift @_;
    my $currPlayer = $self->{"name"};

    my $cardShift = shift $self->{"cards"};
    #print
    
    print"$currPlayer ==> card $cardShift\n";
    #deal it to the game
    return $cardShift;
}

sub numCards {
    my $self = shift @_;
    my $cardNum = @{$self->{"cards"}};
    return $cardNum;
}

return 1;