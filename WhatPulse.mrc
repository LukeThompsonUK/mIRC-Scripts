alias WhatPulse {
  if ($sock(WhatPulse)) { .sockclose WhatPulse }
  if ($1) { set %IDToCheck $1 }
  elseif (!%WhatPulseUserID) {
    echo -a You did not specify a whatpulse ID to lookup.
    echo -a Use /PulseID YourIDHere to set your default ID or use /WhatPulse IDHERE to check any ID
    halt
  } 
  else { set %IDToCheck %WhatPulseUserID }
  if (%IDToCheck !isnum) { echo -a The ID to check was not a number | halt }
  sockopen WhatPulse www.whatpulse.org 80 
}
Alias PulseID {
  if ($1) { set %WhatPulseUserID $1 | echo -a UserID set. }
  else { unset %WhatPulseUserID | echo -a UserID unset. }
}

on *:SockOpen:WhatPulse:{
  sockwrite -nt $sockname GET $+(/api/user.php?UserID=,%IDToCheck) HTTP/1.0
  sockwrite -nt $sockname Host: whatpulse.org
  sockwrite -nt $sockname $crlf
}
on *:SockRead:WhatPulse:{
  sockread %WhatPulseBuffer
  if ($regex(WhatPulse,%WhatPulseBuffer,>(.+)<)) { set %WhatPulseStats %WhatPulseStats $replace($regml(WhatPulse,1),$chr(32),$chr(95)) }
  .timerShowPulse 1 1 ShowPulse
}
alias ShowPulse { 
  var %WhatPulseStats $replace(%WhatPulseStats,$chr(32),$chr(59))
  tokenize ; %WhatPulseStats
  echo -a Account Name: $gettok(%WhatPulseStats,3,59)
  echo -a Date Joined: $gettok(%WhatPulseStats,5,59)
  echo -a Total Keys: $gettok(%WhatPulseStats,9,59)
  echo -a Total Clicks: $gettok(%WhatPulseStats,10,59)
  echo -a Total Miles: $gettok(%WhatPulseStats,11,59)
  echo -a Rank: $gettok(%WhatPulseStats,16,59)
  ; If token 17 is 0 then they aren't in a team.
  if ($gettok(%WhatPulseStats,17,59) != 0) {
    echo -a Team: $gettok(%WhatPulseStats,18,59) (ID: $+ $gettok(%WhatPulseStats,17,59) $+ )
    echo -a Rank in Team: $gettok(%WhatPulseStats,26,59) out of $gettok(%WhatPulseStats,19,59)
  }
  .timer 1 1 unset %WhatPulseStats
  unset %IDToCheck
  unset %WhatPulseBuffer
}
