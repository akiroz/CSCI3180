#!/usr/bin/env perl

# CSCI3180 Principles of Programming Languages
#
# --- Declaration ---
# I declare that the assignment here submitted is original except for source material explicitly
# acknowledged. I also acknowledge that I am aware of University policy and regulations on
# honesty in academic work, and of the disciplinary guidelines and procedures applicable to
# breaches of such policy and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/
#
# Assignment 3
# Name:
# Student ID:
# Email Addr:

use warnings;
use strict;

package Reversi;
use List::Util qw(sum all any);
use Data::Dumper;
sub new {
    my @b; for(my $i=8; $i--;) {$b[$i] = [('.')x8];}
    $b[3][3] = $b[4][4] = 'O';
    $b[3][4] = $b[4][3] = 'X';
    bless {
        black => createPlayer('X', \@b),
        white => createPlayer('O', \@b),
        board => \@b, turn => 'X'
    };
}
sub vnew {
    bless {
        board => $_[1],
        turn => $_[2]
    };
}
sub createPlayer {
    my $o = ($_[0] eq 'X')? 'First': 'Second';
    print "$o player is (1) Computer or (2) Human? ";
    chomp(my $i = <>);
    my $p = ($i == 1)? 'Computer': 'Human';
    print "Player $_[0] is $p\n";
    $p->new($_[0], $_[1]);
}
sub printBoard {
    my $b = $_[0]->{board};
    print '  ' . join(' ', (0..7)) . "\n";
    print map {"$_ " . join(' ', @{$b->[$_]}) . "\n";} (0..7);
    my $x = sum map {($_ eq 'X')? 1 : 0} map {@$_} @$b;
    my $o = sum map {($_ eq 'O')? 1 : 0} map {@$_} @$b;
    print "Player X: $x\n";
    print "Player O: $o\n";
    $x-$o;
}
sub startGame {
    my $self = $_[0];
    my ($moves, $passes, $score) = (0,0,0);
    my %color = ('X'=>'black', 'O'=>'white');
    $self->printBoard;
    while($moves < 8*8-4 && $passes < 2) {
        my $vm = $self->getValid;
        my $m = $self->{$color{$self->{turn}}}->nextMove($vm);
        if(any {join(',',@$_) eq join(',',@$m)} @$vm) {
            print "Player $self->{turn} places to row $m->[0], col $m->[1]\n";
            $passes = 0;
            my @dirs = (
                sub {[$_[0]+0,$_[1]+1]}, sub {[$_[0]+0,$_[1]-1]},
                sub {[$_[0]+1,$_[1]+0]}, sub {[$_[0]-1,$_[1]+0]},
                sub {[$_[0]+1,$_[1]+1]}, sub {[$_[0]-1,$_[1]-1]},
                sub {[$_[0]-1,$_[1]+1]}, sub {[$_[0]+1,$_[1]-1]}
            );
            $self->{board}[$m->[0]][$m->[1]] = $self->{turn};
            foreach(@dirs) {$self->flip($_, $m, 1);}
            $moves++;
        } else {
            print "Row $m->[0], col $m->[1] is invalid! Player $self->{turn} passed!\n";
            $passes++;
        }
        $score = $self->printBoard;
        $self->{turn} =~ tr/XO/OX/;
    }
    if($score > 0) {print "Player X wins!\n";}
    if($score < 0) {print "Player O wins!\n";}
    if($score == 0) {print "Draw game!\n";}
}
sub getValid {
    my $self = $_[0];
    my @dirs = (
        sub {[$_[0]+0,$_[1]+1]}, sub {[$_[0]+0,$_[1]-1]},
        sub {[$_[0]+1,$_[1]+0]}, sub {[$_[0]-1,$_[1]+0]},
        sub {[$_[0]+1,$_[1]+1]}, sub {[$_[0]-1,$_[1]-1]},
        sub {[$_[0]-1,$_[1]+1]}, sub {[$_[0]+1,$_[1]-1]}
    );
    my @moves;
    for(my $i=0; $i<8; $i++) {
        for(my $j=0; $j<8; $j++) {
            if(!($self->{board}[$i][$j] eq '.')) {next;}
            if(any {$_ > 1} map {$self->flip($_, [$i,$j], 0)} @dirs) {
                push @moves, [$i,$j];
            }
        }
    }
    return \@moves;
}
sub flip {
    my ($self, $mv, $m, $f) = @_;
    $m = $mv->(@$m);
    if(!all {0 <= $_ && $_ <= 7} @$m) {return 0;}
    if($self->{board}[$m->[0]][$m->[1]] eq '.') {return 0;}
    if($self->{board}[$m->[0]][$m->[1]] eq $self->{turn}) {return 1;}
    if(my $r = $self->flip($mv, $m, $f)) {
        if($f) {$self->{board}[$m->[0]][$m->[1]] = $self->{turn};}
        return $r+1;
    } 
    return 0;
}

# start game
my $game = Reversi->new;
$game->startGame;

package Player;
sub new {
    bless {
        symbol => $_[1],
        board => $_[2]
    }, $_[0];
}
sub nextMove {}

package Human;
use parent -norequire, 'Player';
sub nextMove {
    print "Player $_[0]->{symbol}, make a move (row col): ";
    chomp(my $i = <>);
    [split(/ /, $i)];
}

package Computer;
use parent -norequire, 'Player';
use Storable qw(dclone);
use Data::Dumper;
sub nextMove {
    my ($self, $vm) = @_;
    if(scalar(@$vm) == 0) {return [-1,-1];}
    my @dirs = (
        sub {[$_[0]+0,$_[1]+1]}, sub {[$_[0]+0,$_[1]-1]},
        sub {[$_[0]+1,$_[1]+0]}, sub {[$_[0]-1,$_[1]+0]},
        sub {[$_[0]+1,$_[1]+1]}, sub {[$_[0]-1,$_[1]-1]},
        sub {[$_[0]-1,$_[1]+1]}, sub {[$_[0]+1,$_[1]-1]}
    );
    my @mobi = map {
        my $m = $_;
        my $g = Reversi->vnew(dclone($self->{board}), $self->{symbol});
        $g->{board}[$m->[0]][$m->[1]] = $g->{turn};
        foreach(@dirs) {$g->flip($_, $m, 1);}
        $g->{turn} =~ tr/XO/OX/;
        scalar @{$g->getValid};
    } @$vm;
    my $best = 0;
    $mobi[$best] > $mobi[$_] or $best = $_ for 1 .. $#mobi;
    $vm->[$best];
}


