use warnings;
use strict;

use JSON::XS;
use Data::Dumper;

my $model = '
{
	"id" : Int,
	"children" : [Int,...],
	"objects" : [
		{String: Int,...},
		...
	],
	"lookup" : {
		String : String
		,...
	},
	"coordinates" : [
		[ Int, Int, {String : String} ],...
	]
}
';

# zdvojeni klice = alternativa
# moznosti parsovani - 1/ must fit at least one alternative


my $strings = {
	0 =>'hello',
	1 =>'world',
	2 =>'abcd',
	3 =>'test',
	4 =>'user1',
	5 =>'perl',
	6 =>'javascript',
	7 =>'prolog',
	8 =>'apple',
	9 =>'linux',
};

sub random_string {
	return $strings->{int(rand(10))};
}

my $DEBUG = 1;

sub getLindent {
	my ($indent) = $_[0] =~ /^(\s*)/;

	print "INDENT($_[0]) = ".length($indent) . "\n" if $DEBUG > 2;
	return length($indent);
}


sub generateSample {
	my ($model) = @_;
	print "\n\n--------------------- Model: -----------------------\n";
	print $model;

	$model =~ s/Int/"Int"/g;
	$model =~ s/String/"String"/g;

	$model =~ s/\n//g;
	$model =~ s/\s*\}/\}/g;
	$model =~ s/\s*\]/\]/g;

	$model =~ s/\.\.\.\}/"Z3dots":"Z3dots_Value"\}/g;
	$model =~ s/\.\.\./"Z3dots"/g;

	my $obj = eval {decode_json($model)};
	die "Bad model: $@" if $@;

	local $Data::Dumper::Purity = 1;
	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Terse = 1;
	local $Data::Dumper::Sortkeys = 1;

	my $dump = Dumper($obj);
	my @lines = split("\n", $dump);

	print("\n\n---- Parsable: ----\n".$dump) if $DEBUG > 1;

	my $i = 0;
	my $result = [];
	
	print "\n\n---- Patterns ----\n" if $DEBUG > 1;

	foreach my $l (@lines) {

		if ($l =~ /^\s*.Z3/) {
			print "-----\n" if $DEBUG > 2;
			my $lindent = getLindent($l);
			my $j = scalar @$result - 1;
			warn 'LINE:'.$result->[$j] if $DEBUG > 1;
			my $nextLindent = getLindent($result->[$j]);

			my $pattern = [];
			print "$nextLindent >= $lindent\n" if $DEBUG > 1;
			while ($nextLindent >= $lindent) {
				push(@$pattern, $result->[$j]);
				last if (($nextLindent == $lindent) and ($result->[$j] !~ /^\s*\}/) and ($result->[$j] !~ /^\s*\]/));
				last if (($nextLindent == $lindent) and ($result->[$j] =~ /^\s*\{/));
				last if (($nextLindent == $lindent) and ($result->[$j] =~ /^\s*\[/));
				$j--;
				$nextLindent = getLindent($result->[$j]);
				warn 'LINE:'.$result->[$j] if $DEBUG > 2;
				print "$nextLindent >= $lindent\n" if $DEBUG > 1;
			}
			print "Pattern:\n".join("\n", reverse @$pattern)."\n\n" if $DEBUG > 1;
			foreach (1..(0+int(rand(2)))) {
				push(@$result, reverse @$pattern);
			}
		} else {

			push(@$result, $l);
		}
		$i++;
	}

	# substitute Basic types
	foreach my $l (@$result) {
		$l =~ s/Int/int(rand(10))/ge;
		$l =~ s/String/random_string(10)/ge;
	}

	print "\n\n--------------------- Sample: -----------------------\n";
	print join("\n", @$result)."\n";



	my $node = 1;
	# iterate through hash
	if ($node eq "3dots_element") {
		# repeat previous element in hash int(rand(10)) times
	} elsif ($node eq "3dots_hashkey") {
		# return  
	}

}



generateSample($model);




