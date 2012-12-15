alias randompass {
  var %PassGen 1
  while (%PassGen <= $1) {
    var %Rand $rand(1,4)
    if (%Rand == 1) {
      var %Pass %Pass $+ $rand(a,z)
    }
    ; Adds a random number.
    elseif (%Rand == 2) {
      var %Pass %Pass $+ $rand(0,9)
    }
    ; Adds a random uppercase letter.
    elseif (%Rand == 3) { 
      var %Pass %Pass $+ $rand(A,Z)
    }
    ; Adds a random symbol.
    else {
      var %Rand2 $rand(1,14)
      if (%Rand2 == 1) {
        var %Pass %Pass $+ !
      }
      elseif (%Rand2 == 2) {
        var %Pass %Pass $+ @
      }
      elseif (%Rand2 == 3) {
        var %Pass %Pass $+ =
      }
      elseif (%Rand2 == 4) {
        var %Pass %Pass $+ $
      }
      elseif (%Rand2 == 5) {
        var %Pass %Pass $+ %
      }
      elseif (%Rand2 == 6) {
        var %Pass %Pass $+ ^
      }
      elseif (%Rand2 == 7) {
        var %Pass %Pass $+ &
      }
      elseif (%Rand2 == 8) {
        var %Pass %Pass $+ *
      }
      elseif (%Rand2 == 9) {
        var %Pass %Pass $+ _
      }
      elseif (%Rand2 == 10) {
        var %Pass %Pass $+ +
      }
      elseif (%Rand2 == 11) {
        var %Pass %Pass $+ :
      }
      elseif (%Rand2 == 12) {
        var %Pass %Pass $+ .
      }
      elseif (%Rand2 == 13) {
        var %Pass %Pass $+ \
      }
      elseif (%Rand2 == 14) {
        var %Pass %Pass $+ /
      }
    }
    inc %PassGen
  }
  if ($2 == -m) { 
    msg $active Pass: %Pass - md5: $md5(%Pass) - sha1: $sha1(%Pass)
  } 
  else {
    echo -a Pass: %Pass
    echo -a md5: $md5(%pass)
    echo -a sha1: $sha1(%pass)
  }
}


; Accidently unloaded a script and it took me a good 10 minutes to figure out
; which one was unloaded, Adding this to all the scripts to prevent this problem
; happening again in the future.
on *:UNLOAD:{
  if (!$window(@Script_Log)) {
    window -nz @Script_Log
  }
  aline -ph @Script_Log Unloading: $script
}
