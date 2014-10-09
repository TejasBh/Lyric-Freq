#!/bin/perl

use strict;
use warnings;
use LWP::Simple;

sub get_lyrics {
	my $html = get "http://www.azlyrics.com/lyrics/breakingbenjamin/naturallife.html";

	#clean
	$html =~ s/.*start of lyrics//s;
	$html =~ s/end of lyrics.*//s;
	$html =~ s/<[^>]*>/ /g;
	$html =~ s/[,!]//g;
	$html =~ s/\n//g;
	return $html;
}

sub count_words {
	my %wordCount = ();
	my $lyrics = get_lyrics();

	my @words = split(/\s+/, $lyrics);
	foreach (@words) {
		my $word = $_;
		if (exists $wordCount{$word}) {
			$wordCount{$word}++;
		} else {
			$wordCount{$word} = 1;
		}
    }

    foreach my $name (keys %wordCount) {
    	printf "%-8s %s\n", $name, $wordCount{$name};
    }

}

count_words();