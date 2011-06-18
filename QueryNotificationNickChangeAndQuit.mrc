/*
* This script does 2 things.
* 1. Will print a line in the query window when a user changes their nick.
* 2. Will print a line in the query window when a user leaves IRC.
*/

on *:NICK:{
  if ($query($newnick)) {
    echo 07 -et $nick $nick has changed their nick to: $newnick
  }
}

on *:QUIT:{
  if ($query($nick)) {
    echo 07 -et $nick $nick has left IRC.
  }
}
