#!/usr/bin/perl 
use strict;
# mpdmon-full
# Copyright (C) trapd00r 2010
# This version of mpdmon outputs [time] artist/album/song whenever song
# changes, keeping a history of recently played tracks for reference.
# If you want a realtime alternative, you'll want;
# http://github.com/trapd00r/mpdmon-realtime

use Audio::MPD;
use List::Util qw(shuffle);
my $mpd = Audio::MPD->new;

sub monitor {
  my $np = "";
  my @c;
  for(my $i=0;$i<256;$i++) {
    push(@c, "\033[38;5;$i"."m");
  }
  while(1) {
    my $current = $mpd->current;
    my $output = $mpd->current->file;
    if(!$current) {
      $current = $c[1].'undef'.$c[0];
      $output = $current;
    }
    my $time1 = $mpd->status->time->sofar;
    my $time2 = $mpd->status->time->total;
    my @date  = localtime(time);

    if("$np" ne "$current") {
      $np = $current;
      my @rc = shuffle(@c);
      printf("%02s:%02s:%02s▕ $rc[0]%s$c[0]\n",
              $date[2], $date[0], $date[1], $output);
    }
    sleep 2;
  }
}

&monitor;

