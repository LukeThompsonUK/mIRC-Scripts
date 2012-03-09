/**
* Script Description
** Binds a function key to kick all users from a channel.
*
* Configuration Settings / Commands
** [Function Key]: F5 - Kicks all users from the channel it is used in.
*/

alias F5 {
  if (!$regex(KickAll,$active,/^#\S+$/)) {
    echo -a You're active window isn't a channel, please only use this on channel windows.
    halt
  }

  var %Kick.All.Users 1
  var %Kick.Reason $?="Kick Reason?"

  if (!%Kick.Reason) { 
    Halt 
  }

  mode $chan +mi-Q

  while (%Kick.All.Users <= $nick($chan,0)) {
    if ($nick($chan,%kick.All.Users) == $me) { 
      inc %Kick.All.Users | Continue 
    }

    kick $chan $nick($chan,%Kick.All.Users) %Kick.Reason
    inc %Kick.All.Users
  }
}
