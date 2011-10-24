/*
This script is used to kick (and/or ban) users based on a regex.
/regexban regex [kdb]
If k is specified users matching will be kicked
If b is specified users will be banned
If d is specified with k, b, or both it will echo the bans set and users kicked without actually doing
anything inside the channel.
*/

alias RegexBan {
  set %RegexBan_HIDEWHO ON

  ; This is to update the internal address list so $address works properly in LARGE channels.
  who $chan

  if (d isincs $2) { var %RegexBan_DebugMode ON }
  if (k isincs $2) { var %RegexBan_Kick ON }
  if (b isincs $2) { var %RegexBan_DoBan ON }

  var %x 1

  while (%x <= $nick($chan,0)) { 
    if ($regex(RegexBan,$nick($chan,%x),$1) == 1) {
      if (%RegexBan_DoBan) { 
        var %AddressToBan $addtok(%AddressToBan,$address($nick($chan,%x),3),32) 
      }

      if (%RegexBan_Kick) { 
        var %NicksToKick $addtok(%NicksToKick,$nick($chan,%x),32) 
      }

      if (%RegexBan_DoBan) { 
        if ($numtok(%AddressToBan,32) == $modespl) {
          if (%RegexBan_DebugMode) {
            echo -a SET: $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
          }
          else {
            mode $chan $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
          }

          var %AddressToBan $deltok(%AddressToBan,1- $modespl,32)

          if (%RegexBan_DebugMode) { 
            echo -a DEL: AddressToBan 
          }
        }
      }
    }

    inc %x
  }

  if (%RegexBan_DoBan) {
    if ($numtok(%AddressToBan,32) > 0) { 
      if (%RegexBan_DebugMode) {
        echo -a SET: $+(+,$str(b,$numtok(%AddressToBan,32))) %AddressToBan
      }
      else {
        mode $chan $+(+,$str(b,$numtok(%AddresstoBan,32))) %AddressToBan 
      }
    }
  }

  ; Now that all the bans are placed we can do all the kicks.
  if (%RegexBan_Kick) {
    var %x 1

    while (%x <= $numtok(%NicksToKick,32)) {
      if (%RegexBan_DebugMode) { 
        echo -a KICK: $gettok(%NicksToKick,%x,32) - Matched ban regex: $1 
      }
      else { 
        kick $chan $gettok(%NicksToKick,%x,32) Matched ban regex: $1 
      }

      inc %x
    }
  }

  echo -at * RegexBan: Finished
}

raw 352:*:{ 
  if (%RegexBan_HIDEWHO) { haltdef } 
}

raw 315:*:{ 
  if (%RegexBan_HIDEWHO) { unset %RegexBan_HIDEWHO |  haltdef } 
}
