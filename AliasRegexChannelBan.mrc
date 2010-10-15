alias RegexBan {
  set %RegexBan_HIDEWHO ON
  ; This is to update the internal address list so $address works properly in LARGE channels.
  who $chan
  if (d isincs $2) { var %RegexBan_DebugMode ON }
  if (k isincs $2) { var %RegexBan_Kick ON }
  var %x 1
  while (%x <= $nick($chan,0)) { 
    if ($regex(RegexBan,$nick($chan,%x),$1) == 1) {
      if (%RegexBan_DebugMode) { echo -a $nick($chan,%x) matches regex $1 }
      var %AddressToBan $addtok(%AddressToBan,$address($nick($chan,%x),3),32)

      if ($numtok(%AddressToBan,32) == $modespl) {
        if (%RegexBan_DebugMode) {
          echo -a SET: $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
        }
        else {
          mode $chan $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
        }
        var %AddressToBan $deltok(%AddressToBan,1- $modespl,32)
        if (%RegexBan_DebugMode) { echo -a DEL: AddressToBan }
      }
    }
    inc %x
  }
  if ($numtok(%AddressToBan,32) > 0) { 
    if (%RegexBan_DebugMode) {
      echo -a SET: $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
    }
    else {
      mode $chan $+(+,$str(b,$numtok(%AddresstoBan,32))) %AddressToBan 
    }
  }
}
raw 352:*:{ if (%RegexBan_HIDEWHO) { haltdef } }
raw 315:*:{ if (%RegexBan_HIDEWHO) { unset %RegexBan_HIDEWHO |  haltdef } }
