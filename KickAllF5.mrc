F5 {
  Var %Kick.All.Users 1
  var %Kick.Reason $?="Kick Reason?"
  if (!%Kick.Reason) { Halt }
  mode $chan +mi-Q
  while (%Kick.All.Users <= $nick($chan,0)) {
    if ($nick($chan,%kick.All.Users) == $me) { inc %Kick.All.Users | Continue }
    kick $chan $nick($chan,%Kick.All.Users) %Kick.Reason
    inc %Kick.All.Users
  }
}