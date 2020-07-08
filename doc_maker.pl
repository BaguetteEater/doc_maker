#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
$Data::Dumper::Indent   = 1;

# author : Ulysse Brehon
# contact : ulysse.brehon@gmail.com
# Twitter : @UlysseBrehon
# Feel free to share and use this code but please, credit me.

sub extract_function_description_pythonfile {
	(my $filepath) = @_;

	my $fichier;
	open($fichier, '<', $filepath)
		or die "Could not open file '$filepath'\n";

	my @lines = qw{};
	my %lines_per_signature;
	while(my $line = <$fichier>) {

		chomp $line;

		if ($line =~ /^(?:# |#)(.*)/) { # We capture every comment line

			my $inserted_comment = $line;
			
			$inserted_comment =~ s/(# |#)//; # we get rid of spaces and hash key
			push(@lines, $inserted_comment);
		}

		elsif ($line =~ /^(?:def|\t*def) .*\(.*\)/) { # if we get to the signature

			my $inserted_signature = $line;
			$inserted_signature =~ s/:\s*$//; # We remove the ':' character at the end of the signature

			push @{$lines_per_signature{$inserted_signature}}, @lines; # we add the couple signature / comment lines to the dict

			@lines = qw{}; # we empty the lines array
		}	
	}

	close $fichier;

	return %lines_per_signature;
}

sub make_doc {
	(my $filepath, my %lines_per_signature) = @_;

	my $path = $filepath;
	my $filename = $filepath;

	$path =~ s/[\w\s_\\\d\.]*$//g; # we extract the path to the file's folder by capturing the filename and replace it by nothing
	$filename =~ s/(.*\/)//g; # the same but with the filename
	
	my $fichier;
	open($fichier, '>', $path . "/README.md")
		or die "Could not create file '$path" . "/README.md'\n";


	print $fichier "# " . $filename . "\n\n";
	foreach my $signature (keys %lines_per_signature) {

		my $function_name = $signature;
		$function_name =~ s/(\t*def\s)//g;
		$function_name =~ s/(\(.*\))//g;

		print $fichier "## " . $function_name . "\n";
		print $fichier "`" . $signature . "`\n\n";

		foreach my $line_desc (@{$lines_per_signature{$signature}}) {print $fichier $line_desc . "\n\n";}
		print $fichier "\n\n"
	}
	close $fichier;

	return 0;
}

unless (@ARGV) {
	print "Error : Please indicate the filepath as an argument\n" ;
	exit 1;
}

my $filepath = $ARGV[0];
unless( -e $filepath && -f $filepath ) {
	print "Error : $filepath is invalid\n Please indicate a valid file or filepath\n";
	exit 1;
}

unless( -r $filepath ) {
	print "Error : can't access $filepath in read mode : don't have the rights";
	exit 1;
}

my %hashtable = extract_function_description_pythonfile($filepath);
make_doc($filepath, %hashtable)