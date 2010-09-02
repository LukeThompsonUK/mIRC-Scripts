raw 473:*:{ inc -u5 %Invite.join | cs invite $2 }
raw 475:*:{ inc -u5 %GetKeyChan on | cs getkey $2 }
raw 474:*:{ inc -u5 %UnbanChan on | cs unban $2 }
on *:invite:#:{
  if (%Invite.Join) { Join -n $chan }
}
on ^*:Notice:*You have been unbanned from*:?:{
  if (%UnbanChan) {
    if ($nick == ChanServ) { inc -u5 %Timer.Ban.Join
    if (%Timer.Ban.Join < 2) { Join -n $strip($left($6,-1)) } }
  }
}
on ^*:Notice:*Key for channel*:?:{
  if (%GetKeyChan) {
    if ($nick == ChanServ) {
      inc -u5 %Timer.Key.Join
      set %Key [ $+ [ $4 ] ] $strip($left($6,-1))
      if (%timer.key.join < 2) { join -n $4 %Key [ $+ [ $4 ] ] }
      unset %Key [ $+ [ $4 ] ]
    }
    unset %GetKeyChan
  }
}