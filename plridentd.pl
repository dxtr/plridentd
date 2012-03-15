#!/usr/bin/perl

package PlRIdentd;

use strict;
use warnings;
use Net::Server::Fork;

our @ISA = qw(Net::Server::Fork);

__PACKAGE__->run();

### Override subs
sub process_request
{
	my $self = shift;
	eval {
		local $SIG{'ALRM'} = sub { die "Timed out!\n"; };
		my $reply = '';
		$reply .= ((0..9,'a'..'f')[rand(16)]) for 1..8;

		my $timeout = 15;
		my $previous_alarm = alarm($timeout);

		while (<STDIN>) {
			if ($_ =~ m/^\s*([\d]{1,5}, [\d]{1,5})\s*$/aa) {
				print "$1 : USERID : UNIX : $reply\r\n";
			}
		}
		alarm($previous_alarm);
	}
}
