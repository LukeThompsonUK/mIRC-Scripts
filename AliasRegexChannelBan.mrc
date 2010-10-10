alias RegexBan {
  set %RegexBan_HIDEWHO ON
  ; This is to update the internal address list so $address works properly in LARGE channels.
  who $chan
  if ($2 == -d) { var %RegexBan_DebugMode ON }
  var %x 1
  while (%x <= $nick($chan,0)) { 
    if ($regex(RegexBan,$nick($chan,%x),$1) == 1) {
      if (%RegexBan_DebugMode) { echo -a $nick($chan,%x) matches regex $1 }
      var %NicksToBan $addtok(%NicksToBan,$address($nick($chan,%x),3),32)
      if ($numtok(%NicksToBan,32) == $modespl) {
        if (%RegexBan_DebugMode) {
          echo -a SET: $+(+,$str(b,$numtok(%NicksToBan,32))) %NicksToBan
        }
        else {
          mode $chan $+(+,$str(b,$numtok(%NicksToBan,32))) %NicksToBan
        }
        var %NicksToBan $deltok(%NicksToBan,1- $modespl,32)
        if (%RegexBan_DebugMode) { echo -a DEL: NicksToBan }
      }
    }
    inc %x
  }
  if ($numtok(%NicksToBan,32) > 0) { 
    if (%RegexBan_DebugMode) {
      echo -a SET: $+(+,$str(b,$numtok(%NicksToBan,32))) %NicksToBan
    }
    else {
      mode $chan $+(+,$str(b,$numtok(%NickstoBan,32))) %NicksToBan 
    }
  }
}
raw 352:*:{ if (%RegexBan_HIDEWHO) { haltdef } }
raw 315:*:{ if (%RegexBan_HIDEWHO) { unset %RegexBan_HIDEWHO |  haltdef } }
