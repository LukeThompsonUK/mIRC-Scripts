; Randomly hugs members of #DF at the given interval.

; On joining #DF
on *:Join:#DF:{
  if ($nick == $me) {
    /DFHuggle on
    echo -a To enable the #DF random hugger use /DFHuggle <on/off> [Interval to hug in seconds]
    echo -a If you don't specify an interval it defaults to 30 minutes (1800 seconds)
    echo -a Example: /DFHuggle on 300 will huggle a random nick every 300 seconds, or 5 minutes.
  }
}

; This iso ur alias to turn the script on/off
alias DFHuggle {
  ; if we want it on
  if ($1 == on) {
    ; if we specify an interval
    if ($2 isnum) {
      ; do the hugs
      timerDFHug 0 $2 /DivineStatusHug
    }
    else {
      ; If we don't supply an interval, default to 1800 seconds, 30 minutes.
      timerDFHug 0 1800 /DivineStatusHug
    }
  }
  elseif ($1 == off) {
    timerDFHug off
  }
  else { 
    echo -a To enable the #DF random hugger use /DFHuggle <on/off> [Interval to hug in seconds]
    echo -a If you don't specify an interval it defaults to 30 minutes (1800 seconds)
    echo -a Example: /DFHuggle on 300 will huggle a random nick every 300 seconds, or 5 minutes.
  }
}

; Alias to huggle a random nick
alias DivineStatusHug {
  describe #DF huggles $nick(#DF,$rand(1,$nick(#DF,0,ohv)))
}
