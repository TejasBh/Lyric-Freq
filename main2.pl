#!/bin/perl

use strict;
use warnings;
use LWP::Simple;

sub get_lyrics {
	my $html = get "http://www.azlyrics.com/lyrics/threedaysgrace/thehighroad.html";

	# clean lyrics
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

		# word cleaning
		if (!($word =~ m/[A-Za-z]/)) {
			next;
		}

		# add word to hash table
		if (exists $wordCount{$word}) {
			$wordCount{$word}++;
		} else {
			$wordCount{$word} = 1;
		}
    }

    foreach my $name (keys %wordCount) {
    	#print "$name   $wordCount{$name}\n";
    	printf "%-15s %s\n", $name, $wordCount{$name};
    }

}

sub scrape_song_links {
	my @links = ();
	my $html = get "http://www.azlyrics.com/t/threedays.html";
	
	# cleanse
	$html =~ s/.*start of song list//s;
	$html =~ s/'<script type="text'\/'javascript">'.*//s;
	print $html;
}

scrape_song_links();
#count_words();