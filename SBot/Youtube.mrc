on $*:TEXT:/(www\.youtube\.com\/watch\?v=(\S+))/Si:*:{
  set %VidToGrab $regml(2)
  set %VidURL $regml(1)
  set %Chan $Chan
  if ($sock(Youtube)) { .sockclose Youtube }
  sockopen Youtube www.rscript.org 80
}
on *:SockOpen:Youtube:{
  sockwrite -nt $sockname GET $+(/lookup.php?type=youtubeinfo&id=,%VidToGrab)
  sockwrite -nt $sockname Host: www.rscript.org
  sockwrite -nt $sockname $crlf
}
on *:SockRead:Youtube: {
  sockread %Youtube
  if (Title isin %Youtube) { set %vTitle $right(%Youtube,-7) }
  if (Views isin %Youtube) { set %vViews $right(%Youtube,-6) }
  if (END isin %Youtube) { 
    msg %chan Title: %vTitle - Views: %vViews
    msg %chan Link: %VidURL
    unset %vTitle
    unset %vViews
    unset %VidToGrab
    unset %VidURL
    .sockclose Youtube
  }
}
