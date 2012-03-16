#!/usr/bin/perl

package PlRIdentd;

use strict;
use warnings;
use Net::Server::Fork;
use Sys::Syslog;

our @ISA = qw(Net::Server::Fork);

__PACKAGE__->run(pid_file => '/var/run/plridentd.pid',
	log_file => 'Sys::Syslog',
	syslog_logsoc => 'native',
	syslog_ident => 'plridentd',
	port => 113,
	chroot => '/var/lib/plridentd/',
	user => 'nobody',
	group => 'nogroup',
	background => 1,
	setsid => 1,
	max_servers => 10,
	host => "0.0.0.0"
);

### Override subs
sub process_request
{
	my $self = shift;
	eval {
		local $SIG{'ALRM'} = sub { die "Timed out!\n"; };
		my $reply = '';
		$reply .= ((0..9,'a'..'f')[rand(16)]) for 1..8;

		my $timeout = 10;
		my $previous_alarm = alarm($timeout);

		while (<STDIN>) {
			if ($_ =~ m/^\s*([\d]{1,5}\s*,\s*[\d]{1,5})\s*$/aa) {
				print "$1 : USERID : UNIX : $reply\r\n";
				last;
			}
		}
		alarm($previous_alarm);
	}
}
