#/usr/bin/perl

use 5.16.0;
use warnings;

use Data::Dumper;
use Math::Complex;
use POSIX qw(ceil);
use Term::ANSIColor;
use Yote::ForkManager;

my @colors = qw( red green yellow blue magenta cyan white );
@colors = (@colors, map { "bright_$_" } @colors );

sub set {
    my (%args) = @_;

    my $width   = $args{width}   // 200;
    my $height  = $args{height}  // 100;

    my $start_x = $args{start_x} // -3;
    my $end_x   = $args{end_x}   // 3;

    my $start_y = $args{start_y} // -1.5;
    my $end_y   = $args{end_x}   // 1.5;

    my $inc_x   = ($end_x - $start_x) / $width;
    my $inc_y   = ($end_y - $start_y) / $height;

    # Znext = Zprev^2 + c

    my $matrix = [];
    # my $pm = Yote::ForkManager->new(
    #     on_finish => sub {
    #         my $row = shift;
    #         my $y_idx = shift @$row;
    #         $matrix->[$y_idx] = $row;
    #     },
    #     );

    my $y = $start_y;
    for (my $y_idx = 0; $y_idx < $height; $y_idx++) {
#        if ($pm->start) {
#            next;
#        }
        
        my $x = $start_x;
        my $row = [$y_idx];
        for (my $x_idx = 0; $x_idx < $width; $x_idx++) {
            my $c = Math::Complex->make( $x, $y );
            my $explodes = explode_p( $c );
            push @$row, $explodes;
            $x += $inc_x;
        }
#        $pm->finish( 0, $row );
            $y += $inc_y;
    }

#    $pm->wait_all_children;

    for my $row (@$matrix) {
        for my $explodes (@$row) {
            if ($explodes) {
                my $color = $colors[$explodes % @colors];
#                print color( $color );
            } else {
#                print color('black');
            }
#            print "█";
        }
#        print "\n";
    }
#    print color('white');
}

sub explode_p {
    my $c = shift;

    my $z = 0;
    my $count = 0;

    while(1) {
        my $z_next = $z ** 2 + $c;
        if ($z_next == 0) {
            return 0;
        }
        if (abs($z_next) > 1_000) {
            return $count;
        }
        if (++$count > 150) {
            return 0;
        }
        $z = $z_next;
    }
    
}

set(
    start_x => -2,
    end_x   => 1.5,
    start_y => -1,
    end_y =>   1,
);
#say explode_p( Math::Complex->make( 0.1, 10.1 ));

