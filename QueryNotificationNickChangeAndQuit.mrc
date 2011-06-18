/*
* Will print a line in the query window when a user changes their nick.
*/

on *:NICK:{
  if ($query($newnick)) {
    echo 07 -et $nick $nick has changed their nick to: $newnick
  }
}
