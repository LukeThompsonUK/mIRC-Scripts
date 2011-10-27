alias WhatPulse {
  if ($sock(WhatPulse)) { 
    .sockclose WhatPulse 
  }

  if ($1 == -t) { 
    if ($2 isnum) {
      set %TeamCheck ON
      set %IDToCheck $2
    }
    elseif (%WhatPulseTeamID isnum) {
      set %TeamCheck ON
      set %IDToCheck $readini(WhatPulseSettings.ini,PulseID,TeamID)
    }
    else { 
      echo -a You did not specify a Team ID to lookup.
      echo -a Use /PulseID -t TeamIDHere to set your default Team ID or use /WhatPulse -t TeamIDHere to check any Team ID

      halt
    }
  }
  elseif ($1 isnum) { 
    set %IDToCheck $1 
  }
  elseif (%WhatPulseUserID isnum) {
    set %IDToCheck $readini(WhatPulseSettings.ini,PulseID,UserID)
  } 
  else {
    echo -a You did not specify a whatpulse ID to lookup.
    echo -a Use /PulseID YourIDHere to set your default ID or use /WhatPulse IDHERE to check any ID

    halt
  }

  if (%IDToCheck !isnum) { 
    echo -a The ID to check was not a number 
    halt 
  }

  sockopen WhatPulse www.whatpulse.org 80 
}


alias PulseID {
  if (($1 == -t) && ($2 isnum)) { 
    writeini WhatPulseSettings.ini PulseID TeamID $2
    echo -a TeamID set. 
  }
  elseif ($1 == -t) { 
    remini WhatPulseSettings.ini PulseID TeamID
    echo -a TeamID unset. 
  }
  elseif ($1 isnum) { 
    writeini WhatPulseSettings.ini PulseID UserID $1
    echo -a UserID set. 
  }
  else { 
    remini WhatPulseSettings.ini PulseID UserID
    echo -a UserID unset. 
  }
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
  if (%TeamCheck) {
    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamName>(.+)<\/TeamName>)) { 
      set %WhatPulseStats.TeamName $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamMembers>(.+)<\/TeamMembers>)) { 
      set %WhatPulseStats.TeamMembers $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamKeys>(.+)<\/TeamKeys>)) { 
      set %WhatPulseStats.TeamKeys $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamClicks>(.+)<\/TeamClicks>)) { 
      set %WhatPulseStats.TeamClicks $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamMiles>(.+)<\/TeamMiles>)) { 
      set %WhatPulseStats.TeamMiles $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamRank>(.+)<\/TeamRank>)) { 
      set %WhatPulseStats.TeamRank $regml(WhatPulse,1) 
    }
  }
  else {
    if ($regex(WhatPulse,%WhatPulseBuffer,<AccountName>(.+)<\/AccountName>)) { 
      set %WhatPulseStats.AccountName $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<DateJoined>(.+)<\/DateJoined>)) { 
      set %WhatPulseStats.DateJoined $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TotalKeyCount>(.+)<\/TotalKeyCount>)) { 
      set %WhatPulseStats.TotalKeyCount $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TotalMouseClicks>(.+)<\/TotalMouseClicks>)) { 
      set %WhatPulseStats.TotalMouseClicks $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TotalMiles>(.+)<\/TotalMiles>)) { 
      set %WhatPulseStats.TotalMiles $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<Rank>(.+)<\/Rank>)) { 
      set %WhatPulseStats.Rank $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamName>(.+)<\/TeamName>)) { 
      set %WhatPulseStats.TeamName $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamID>(.+)<\/TeamID>)) { 
      set %WhatPulseStats.TeamID $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<RankInTeam>(.+)<\/RankInTeam>)) { 
      set %WhatPulseStats.RankInTeam $regml(WhatPulse,1) 
    }

    if ($regex(WhatPulse,%WhatPulseBuffer,<TeamMembers>(.+)<\/TeamMembers>)) { 
      set %WhatPulseStats.TeamMembers $regml(WhatPulse,1) 
    }
  }

  .timerShowPulse 1 1 ShowPulse
}


alias -l ShowPulse { 
  echo -a -
  var %WhatPulse_Display $iif($readini(WhatPulseSettings.ini,Display,ShowMethod),$readini(WhatPulseSettings.ini, Display, ShowMethod), echo -a)
  if (%TeamCheck) {
    if ($readini(WhatPulseSettings.ini,Display,ShortDisplay) == on) {
      %WhatPulse_Display WhatPulse for $+(%WhatPulseStats.TeamName,:) $+([TeamKeys:,$bytes(%WhatPulseStats.TeamKeys,b), / TeamClicks:,$bytes(%WhatPulseStats.TeamClicks,b), / TeamMiles:,%WhatPulseStats.TeamMiles,]) / Rank: %WhatPulseStats.TeamRank
    }
    else {
      %WhatPulse_Display Team Name: %WhatPulseStats.TeamName
      %WhatPulse_Display Team Members: $bytes(%WhatPulseStats.TeamMembers,b)
      %WhatPulse_Display Total Keys: $bytes(%WhatPulseStats.TeamKeys,b)
      %WhatPulse_Display Total Clicks: $bytes(%WhatPulseStats.TeamClicks,b)
      %WhatPulse_Display Total Miles: %WhatPulseStats.TeamMiles
      %WhatPulse_Display Team Rank: $bytes(%WhatPulseStats.TeamRank,b)
    }
  }
  else {
    if ($readini(WhatPulseSettings.ini,Display,ShortDisplay) == on) {
      %WhatPulse_Display WhatPulse for $+(%WhatPulseStats.AccountName,:) $+([Keys:,$bytes(%WhatPulseStats.TotalKeyCount,b), / Clicks:,$bytes(%WhatPulseStats.TotalMouseClicks,b), / Miles:,%WhatPulseStats.TotalMiles,]) / Team: $+($iif(%WhatPulseStats.TeamID == 0,None,%WhatPulseStats.TeamName),[,%WhatPulseStats.TeamID,]) / Overall Rank: $bytes(%WhatPulseStats.Rank,b) / Rank in Team: $bytes(%WhatPulseStats.RankInTeam,b)
    }
    else {
      %WhatPulse_Display Account Name: %WhatPulseStats.AccountName
      %WhatPulse_Display Date Joined: %WhatPulseStats.DateJoined
      %WhatPulse_Display Total Keys: $bytes(%WhatPulseStats.TotalKeyCount,b)
      %WhatPulse_Display Total Clicks: $bytes(%WhatPulseStats.TotalMouseClicks,b)
      %WhatPulse_Display Total Miles: %WhatPulseStats.TotalMiles
      %WhatPulse_Display Rank: $bytes(%WhatPulseStats.Rank,b)

      ; If %WhatPulseStats.TeamID is 0 then they aren't in a team.
      if (%WhatPulseStats.TeamID != 0) {
        %WhatPulse_Display Team: %WhatPulseStats.TeamName (ID: $+ %WhatPulseStats.TeamID $+ )
        %WhatPulse_Display Rank in Team: $bytes(%WhatPulseStats.RankInTeam,b) out of $bytes(%WhatPulseStats.TeamMembers,b)
      }
    }
  }

  echo -a -

  .timer 1 1 unset %WhatPulseStats.*

  unset %TeamCheck
  unset %IDToCheck
  unset %WhatPulseBuffer
}


menu channel,status {
  WhatPulse
  .Settings
  ..Display [Echo/Active window]: { 
    var %vWPD $?="Do you want this to show as a channel message or echo for only you to see? [Type ECHO or MSG]"

    if ((%vWPD != ECHO) && (%vWPD != MSG)) {
      echo -a It appears you didn't type your answer correctly. Run WhatPulse->Settings->Display again and type either ECHO or MSG in the box.
      halt
    }

    if (%vWPD == ECHO) { 
      writeini WhatPulseSettings.ini Display ShowMethod echo -a
    }
    elseif (%vWPD == MSG) { 

      writeini WhatPulseSettings.ini Display ShowMethod msg $eval($active,0)
    }
  }

  ..Toggle short display [One line display or many]:{
    var %sWPD $?="Do you want this on one line or multi? [Type ONE or MULTI]"

    if ((%sWPD != ONE) && (%sWPD != MULTI)) {
      echo -a It appears you didn't type your answer correctly, run WhatPulse->Settings->Toggle short display again and type either ONE or MULTI in the box.

      remini WhatPulse.ini Display ShortDisplay
      halt
    }

    if (%sWPD == ONE) { 
      writeini WhatPulseSettings.ini Display ShortDisplay ON
    }
    elseif (%sWPD == MULTI) { 
      remini WhatPulseSettings.ini Display ShortDisplay
    }
  }

  ..Set default UserID: set %WhatPulseUserID $?="Enter the ID"
  ..Set default TeamID: set %WhatPulseTeamID $?="Enter the ID"
  .User
  ..Check default UserID: /WhatPulse $iif($readini(WhatPulseSettings.ini,PulseID,UserID),$readini(WhatPulseSettings.ini,PulseID,UserID),$?="No default ID set; enter a new ID to check")
  ..Check other UserID: /WhatPulse $?="Enter ID to check"
  .Team
  ..Check default TeamID: /WhatPulse -t $iif($readini(WhatPulseSettings.ini,PulseID,TeamID),$readini(WhatPulseSettings.ini,PulseID,TeamID),$?="No default ID set; enter a new ID to check")
  ..Check other TeamID: /WhatPulse $?="Enter ID to check"
  .Help: {
    echo -a -
    echo -a WhatPulse stats script by Shawn Smith
    echo -a Commands:
    echo -a /WhatPulse [-t] [User/TeamID]
    echo -a If the -t switch is used you will look up a TeamID instead of UserID, the User/TeamID is optional
    echo -a If you used either the menu or /PulseID [-t] to set your default IDs prior to using /WhatPulse
    echo -a /PulseID [-t] User/TeamID
    echo -a If the -t switch is used you will specify a TeamID instead of a UserID, if you do not fill in a User/TeamID your current one will be unset.
    echo -a Settings:
    echo -a All settings are done via the channel menu, Right click a channel->WhatPulse->Settings
    echo -a You can also use this menu to change your default IDs
    echo -a If you have never used WhatPulse->Settings->Display before you will automatically echo the results of the lookup in the active window
    echo -a You can change this to a channel message if you wish.
    echo -a -
  }
}
