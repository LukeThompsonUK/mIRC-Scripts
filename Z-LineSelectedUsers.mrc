F7 {
  if ($?!="Z-Line selected users?" == $false) { Halt }
  var %Reason == $?="Z-Line Reason:"
  NAMES $chan
  var %x 1
  while (%x <= $snick($chan,0)) {
    zline $snick($chan,%x) 7d $+(:,%Reason)
    inc %x
  }
}