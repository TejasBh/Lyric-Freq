#!/bin/perl

use strict;
use warnings;
use LWP::Simple;

sub get_lyrics {
	my $html = get "http://$_[0]" or die "Couldn't retrieve song lyric page! :(\n";

	# clean lyrics
	$html =~ s/.*start of lyrics//s;
	$html =~ s/end of lyrics.*//s;
	$html =~ s/<[^>]*>/ /g;
	$html =~ s/[,!]//g;
	$html =~ s/\n//g;
	return $html;
}

sub count_words {
	my %wordCount = $_[0];
	my $lyrics = $_[1];

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

    return %wordCount;
=pod
    foreach my $name (keys %wordCount) {
    	#print "$name   $wordCount{$name}\n";
    	printf "%-15s %s\n", $name, $wordCount{$name};
    }
=cut
}

sub scrape_song_links {
	my @links = ();
	my $html = get "http://www.azlyrics.com/b/benjamin.html" or die "Couldn't get artist page\n";
	my $url = "www.azlyrics.com/";
	
	# cleanse
	$html =~ s/.*start of song list//s;
	$html =~ s/var songlist.*//s;

	my @lines = split (/\n/, $html);
	foreach my $songLink (@lines) {
		#print "HA\n";
		if ($songLink =~ m/\.\.\/(lyrics\/[a-z]+\/[a-z]+\.html)/) {
			my $link = "$url" . "$1";
			#print "$link\n";
			push (@links, $link);
		}
	}
	#print $html;
	return @links;
}

sub arist_word_count {
	my %wordCount = ();
	my @songLinks = scrape_song_links();

	foreach my $link (@songLinks) {
		my $html = get_lyrics($link);
		print "$html\n";
		%wordCount = count_words($html, %wordCount);
		last;
	}

	# print the schtuff out
	foreach my $name (keys %wordCount) {
    	#print "$name   $wordCount{$name}\n";
    	printf "%-15s %s\n", $name, $wordCount{$name};
    }
}

arist_word_count();
#scrape_song_links();
#count_words();