on *:BAN:#:{
  if (($me isop $chan) || ($me ishop $chan)) {
    var %x = 2, %i = 0, %BanMask
    if ($modefirst) { 
      while (%x <= $0) {
        if ($($+($,%x),2) iswm $ial($me)) { inc %i | %BanMask = %BanMask $($+($,%x),2) }
        inc %x
      }
      mode $chan - $+ $str(b,%i) %BanMask
    }
  }
}