use strict;
use warnings;
package Land;

sub new {
    my $class = shift;
    my $self  = {
        owner => undef,
        level => 0,
    };
    bless $self, $class;
    return $self;
}

sub print {
    my $self = shift;
    if (!defined($self->{owner})) {
        print("Land ");
    } else {
        print("$self->{owner}->{name}:Lv$self->{level}");
    }
}

sub buyLand {
    my $self = shift;
    my $fin_amount;
    
    $fin_amount = 1000*1.1;
    if($main::cur_player->{money}<$fin_amount){
        print"You do not have enough money to buy the land!\n";
        return 0;
    }else{
        #pay money
        local $Player::due = 1000;
        local $Player::handling_fee_rate = 0.1;
        local $Player::income = 0;
        local $Player::tax_rate = 0;

        $main::cur_player->payDue();
        #own the land
        print"You have bought the land for $fin_amount\n";
        $main::cur_player->printAsset();
        return 1;      
    }           
}

sub upgradeLand {
    my $self = shift;
    my $fin_amount;

    my $upgrade;
    my $rate = 0.1;

    #upgrrade table
    if($self->{level}==0){
        $upgrade = 1000;
    }elsif($self->{level}==1){
       $upgrade = 2000;
    }elsif($self->{level}==2){
        $upgrade = 5000;
    }
    $fin_amount = $upgrade * (1+$rate);

    if(($main::cur_player->{money})<$fin_amount){
        print"You do not have enough money to upgrade the land!\n";
        return 0;
    }else{
        local $Player::due = $upgrade;
        local $Player::handling_fee_rate = $rate;
        local $Player::income = 0;
        local $Player::tax_rate = 0;

        $main::cur_player->payDue($Player::due,$Player::handling_fee_rate);
        print"You have upgraded the land\n";
        $main::cur_player->printAsset();
        return 1;
    }
}

sub chargeToll {
    my $self = shift;
    my $toll;
    my $rate;
    my $curPlayerMoney = $main::cur_player->{money};

    #toll table
    if($self->{level}==0){
        $toll = 500;
    }elsif($self->{level}==1){
        $toll = 1000;
    }elsif($self->{level}==2){
        $toll = 1500;
    }elsif($self->{level}==3){
        $toll = 3000;
    }

    #tax table
    if($self->{level}==0){
        $rate = 0.1;
    }elsif($self->{level}==1){
        $rate = 0.15;
    }elsif($self->{level}==2){
        $rate = 0.2;
    }elsif($self->{level}==3){
        $rate = 0.25;
    }


    if($toll>$curPlayerMoney){
        $toll = $curPlayerMoney;
    }
    local $Player::due = $toll;
    local $Player::handling_fee_rate = 0;
    local $Player::income = 0;
    local $Player::tax_rate = 0;
    $main::cur_player->payDue();
    $main::cur_player->printAsset();

    $Player::due = 0;
    $Player::handling_fee_rate = 0;
    $Player::income = $toll;
    $Player::tax_rate = $rate;
    $self->{owner}->payDue();
}

sub stepOn {
    my $self = shift;
    my $check = 0;
    my $answer;
    my $fin_amount;

    #print"self = $self\n";
    my $upgrade;
    my $toll;
    my $owner = $self->{owner};
    #upgrrade table
    if($self->{level}==0){
        $upgrade = 1000;
    }elsif($self->{level}==1){
        $upgrade = 2000;
    }elsif($self->{level}==2){
        $upgrade = 5000;
    }

    #toll table
    if($self->{level}==0){
        $toll = 500;
    }elsif($self->{level}==1){
        $toll = 1000;
    }elsif($self->{level}==2){
        $toll = 1500;
    }elsif($self->{level}==3){
        $toll = 3000;
    }

    if (!defined($self->{owner})){
        $check = 0;
        while($check!=1){
            print"Pay \$1000 to buy the land? [y/n]\n";
            $answer = <STDIN>;
            chomp $answer;
            if($answer eq "y"){
                if($self->buyLand()){
                    #the account has been processed
                    #own the land
                    $self->{owner} = $main::cur_player;
                }   
                $check = 1;
            }elsif ($answer eq "n"){
                $check = 1;
            }else{
                print"Invalid answer, please enter again.\n";
            }
        }
    }elsif ($self->{owner} == $main::cur_player){
        $check = 0;
        while($check!=1){
            if($self->{level}<3){
                print"Pay \$$upgrade to upgrade the land? [y/n]\n";
                $answer = <STDIN>;
                chomp $answer;
                if($answer eq "y"){
                    if($self->upgradeLand()){
                        #the account has been processed
                        #upgrade the land
                        $self->{level} = $self->{level} +1;
                    }   
                    $check = 1;
                }elsif ($answer eq "n"){
                    $check = 1;
                }else{
                    print"Invalid input, please enter again.\n";
                }
            }else{
                $check = 1;
            }
        } 
    }else{
        $owner = $owner->{name};
        print"You need to pay player $owner \$$toll.\n";
        $self->chargeToll();
    }
}
1;