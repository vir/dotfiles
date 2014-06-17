#!/usr/bin/perl
use utf8;
use strict;
use warnings;
use DBI;
use warnings FATAL => 'uninitialized';
use CGI qw/:all *table *ul *dl *div/;
use CGI::Carp 'fatalsToBrowser';

binmode(STDOUT, ':utf8');

my $css = << '***';
body { background-color:#EEE; }
***

my $dbh = DBI->connect('dbi:Pg:dbname=somedb host=localhost', 'someuser', 'somepassword', { RaiseError=>1, AutoCommit=>1 });
$dbh->do("SET CLIENT_ENCODING TO UNICODE");
$dbh->{pg_enable_utf8} = 1;

if(param()) {
	warn "Got POST: ".join(' ', param());
	print redirect(url(-absolute=>1,-query=>0));
}

print header(-type=>"text/html; charset=UTF-8");
print start_html(
	-title=>'Хрень',
	-style=>{
		-src=>'style.css',
		-code=>$css,
	},
	-encoding=>'UTF-8',
);
&main();
print end_html."\n";
$dbh->disconnect;


sub main
{
}


