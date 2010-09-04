alias WhatPulse {
  if ($sock(WhatPulse)) { .sockclose WhatPulse }
  if ($1 == -t) { 
    if ($2 isnum) {
      set %TeamCheck ON
      set %IDToCheck $2
    }
    elseif (%WhatPulseTeamID isnum) {
      set %TeamCheck ON
      set %IDToCheck %WhatPulseTeamID
    }
    else { 
      echo -a You did not specify a Team ID to lookup.
      echo -a Use /PulseID -t TeamIDHere to set your default Team ID or use /WhatPulse -t TeamIDHere to check any Team ID
      halt
    }
  }
  elseif ($1 isnum) { set %IDToCheck $1 }
  elseif (%WhatPulseUserID isnum) {
    set %IDToCheck %WhatPulseUserID
  } 
  else {
    echo -a You did not specify a whatpulse ID to lookup.
    echo -a Use /PulseID YourIDHere to set your default ID or use /WhatPulse IDHERE to check any ID
    halt
  }
  if (%IDToCheck !isnum) { echo -a The ID to check was not a number | halt }
  sockopen WhatPulse www.whatpulse.org 80 
}
Alias PulseID {
  if (($1 == -t) && ($2 isnum)) { set %WhatPulseTeamID $2 | echo -a TeamID set. }
  elseif ($1 == -t) { unset %WhatPulseTeamID | echo -a TeamID unset. }
  elseif ($1 isnum) { set %WhatPulseUserID $1 | echo -a UserID set. }
  else { unset %WhatPulseUserID | echo -a UserID unset. }
}

on *:SockOpen:WhatPulse:{
  if (%TeamCheck) {
    sockwrite -nt $sockname GET $+(/api/team.php?TeamID=,%IDToCheck) HTTP/1.0
  } 
  else {
    sockwrite -nt $sockname GET $+(/api/user.php?UserID=,%IDToCheck) HTTP/1.0
  }
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
  if (%TeamCheck) {
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Team Name: $gettok(%WhatPulseStats,1,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Team Members: $gettok(%WhatPulseStats,3,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Keys: $bytes($gettok(%WhatPulseStats,4,59),b)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Clicks: $bytes($gettok(%WhatPulseStats,5,59),b)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Miles: $gettok(%WhatPulseStats,6,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Team Rank: $bytes($gettok(%WhatPulseStats,7,59),b)
  }
  else {
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Account Name: $gettok(%WhatPulseStats,3,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Date Joined: $gettok(%WhatPulseStats,5,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Keys: $bytes($gettok(%WhatPulseStats,9,59),b)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Clicks: $bytes($gettok(%WhatPulseStats,10,59),b)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Total Miles: $gettok(%WhatPulseStats,11,59)
    $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Rank: $bytes($gettok(%WhatPulseStats,16,59),b)
    ; If token 17 is 0 then they aren't in a team.
    if ($gettok(%WhatPulseStats,17,59) != 0) {
      $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Team: $gettok(%WhatPulseStats,18,59) (ID: $+ $gettok(%WhatPulseStats,17,59) $+ )
      $iif(%WhatPulse_Display,%WhatPulse_Display,echo -a) Rank in Team: $bytes($gettok(%WhatPulseStats,26,59),b) out of $bytes($gettok(%WhatPulseStats,19,59),b)
    }
  }
  .timer 1 1 unset %WhatPulseStats
  unset %TeamCheck
  unset %IDToCheck
  unset %WhatPulseBuffer
}
menu channel {
  WhatPulse
  .Settings
  ..Display: { 
    var %vWPD $?="Do you want this to show as a channel message or echo for only you to see? [Type ECHO or MSG]"
    if ((%vWPD != ECHO) && (%vWPD != MSG)) {
      echo -a It appears you didn't type your answer correctly. Run WhatPulse->Settings->Display again and type either ECHO or MSG in the box.
      halt
    }
    if (%vWPD == ECHO) { set %WhatPulse_Display echo -a }
    elseif (%vWPD == MSG) { set %WhatPulse_Display msg $chan }
  }
  ..Set default UserID: set %WhatPulseUserID $?="Enter the ID"
  ..Set default TeamID: set %WhatPulseTeamID $?="Enter the ID"
  .User
  ..Check default UserID: /WhatPulse $iif(%WhatPulseUserID,%WhatPulseUserID,$?="No default ID set; enter a new ID to check")
  ..Check other UserID: /WhatPulse $?="Enter ID to check"
  .Team
  ..Check default TeamID: /WhatPulse -t $iif(%WhatPulseTeamID,%WhatPulseTeamID,$?="No default ID set; enter a new ID to check")
  ..Check other TeamID: /WhatPulse $?="Enter ID to check"
}
