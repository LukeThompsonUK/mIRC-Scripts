; This replaces the standard /away with one that works on every network you're connected to
; /away blahblah to set yourself away
; /away with nothing added to come back.

alias away {
  if ($1) {
    scon -at1 .raw away $1-
    titlebar [AWAY] $1-
    echo 10 -at * Away: $1-
  }
  elseif (!$1) {
    if (!$away) {
      echo 10 -at * Error, not away.
    }
    else {
      echo 10 -at * Away Time: $duration($awaytime)
      scon -at1 .raw away
      titlebar
      echo 10 -at * Back from: $awaymsg
    }
  }
}

menu channel,status,nicklist {
  Away
  .Set yourself as away: /away $?="Enter reason for going away"
  .Come back from away: /away
}
