#!/usr/bin/perl

####################################################
## Script       : gen_redis_proto.pl 
## Author       : aperdana
## Usage        : ./gen_redis_proto.pl [INPUT] [OUTPUT]
## Description  : Generate Redis protocol file from a series of commands stored in a file.
#                 All commands must be newline-separated. Please note that this script doesn't
#                 validate Redis syntax of your command -- you are responsible for that!
#                 
#                 Example input file:
#                 set key1 value1
#                 set key2 value2
#                 
#                 Example output file:
#                 *3\r\n
#                 $3\r\n
#                 set\r\n
#                 $4\r\n
#                 key1\r\n
#                 $6\r\n
#                 value1
#                 *3\r\n
#                 $3\r\n
#                 set\r\n
#                 $4\r\n
#                 key2\r\n
#                 $6\r\n
#                 value2
####################################################

use strict;

# Constant
my $ENDING = "\r\n";

# Check accessibility of input file
# Exit and throw error if it doesn't exists
die "ERROR: Input file doesn't exists\n" if(not -e $ARGV[0]);

# Read input file and go through it line by line
# On every line, convert Redis command to string representing
# Redis protocol
my $input = $ARGV[0];
my $output = $ARGV[1];
open(IN, "< $input") or die "ERROR: Can't open input file";
open(OUT, "> $output") or die "ERROR: Can't open output file";
while(my $line = <IN>) {
    chomp($line);
    my @tokens = split(/ /, $line);

    # Only convert tokens if the line is not empty
    my $len = scalar @tokens;
    if($len > 0) {
        # Start the protocol
        print OUT "*$len$ENDING";
        foreach my $token (@tokens) {
            my $tokenLength = length($token);
            print OUT "\$$tokenLength$ENDING";  # Print token length
            print OUT "$token$ENDING";          # Print token
        }
    }
}
close IN;
close OUT;
