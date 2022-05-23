use strict;
use warnings;
require "./Player.pm";

package Jail;
sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    return $self;
}

sub print {
    print("Jail ");
}

sub stepOn {
    my $self = shift;

    my $answer;
    my $check=0;
    my $curMoney;
    # ...
    #rule of jail

    if($main::cur_player->{num_rounds_in_jail}==0){
        while ($check!=1){
            print"Pay \$1000 to reduce the prison round to 1? [y/n]\n";
            $answer = <STDIN>;
            chomp $answer;
            if($answer eq "y"){
                my $required = 1000*1.01;
                $curMoney = $main::cur_player->{money};
                if($curMoney<$required){
                    print"You do not have enough money to reduce the prison round!\n";
                    next;
                }else{
                    local $Player::prison_rounds = 1;
                    local $Player::due = 1000;
                    local $Player::handling_fee_rate = 0.1;
                    local $Player::income = 0;
                    local $Player::tax_rate = 0;

                    $main::cur_player->payDue();
                    $main::cur_player->putToJail();
                    $check = 1;
                }
            }elsif($answer eq "n"){
                $main::cur_player->putToJail();
                $check =1;
            }else{
                $check = 0;
                print"Invalid input, please try again\n";
            }
        }
    }
    
}

1;
