/**
* Script Description
** Alters the standard away command to work for every network you are connected to.
*
* Configuration Settings / Commands
** /away texthere ( Set yourself as away )
** /away ( Set yourself as back )
*/

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
