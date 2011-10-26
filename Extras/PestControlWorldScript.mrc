/*
User Commands (Used in the main channel)
Use !World/!Pcw/!w in the main channel to recieve the world.
Use !Suggest worldhere to suggest a world for PestControl. (Shows in Staff channel, orange world suggestions are from normal users, red are from everyone else)

Staff Commands (Used in the staff channel)
Since the PC update, there are now 3 boats so you could have 3 different Pest Worlds.
Use !Chgworld <BoatLevelPeopleUseOnTheWorld 40/70/100> <Worldhere>
Ex: !chgworld 70 83
Use !Check to see the current worlds up for suggestions
Use !CheckDel worldhere to delete a world from the suggested list
Use !Announce text here To send a message to the main channel from the bot.
*/

; PestControl World Script written by Shawn
on *:Join:#PestControl:{ 
  .notice $nick Welcome to $Chan $+ . If you'd like to recieve voice please help find good worlds and suggest them with the !Suggest command. 
}


on $*:TEXT:/^!(pcw|world|w)$/i:#PestControl:{ 
  .notice $nick 100+ World: $+(,%World.100,) ¤ 70+ World: $+(,%World.70,) ¤ 40+ World: $+(,%World.40,) 
}


on $*:TEXT:/^!suggest ([0-9]+)$/i:#PestControl:{
  if ($nick !isreg $chan) { 
    .msg #PestControl.Staff 4WORLD SUGGESTION: $+(,$nick,) suggested world $+(,$2,)
    writeini PestControl.ini WorldCheck $2 SUGGESTED 
  }
  else { 
    msg #PestControl.Staff 7WORLD SUGGESTION: $+(,$nick,) suggested world $+(,$2,) 
     writeini PestControl.ini WorldCheck $2 SUGGESTED 
  }
}


on $*:TEXT:/^!chgworld (40|70|100) ([0-9]+)$/i:#PestControl.Staff:{ 
  set %World. $+ $2 $3 
  msg #PestControl The level ( $+ $2 $+ ) world has been changed to $+(,$3,) by $+(,$nick,!) 
}


on *:TEXT:!announce *:#PestControl.Staff:{ 
  Msg #PestControl ( $+ Message/ $+ $nick $+ ) - $2- 
}


on $*:TEXT:/^!(Check|Checkdel ([0-9]+))$/i:#PestControl.Staff:{
  if ($1 == !Checkdel) { 
    remini PestControl.ini WorldCheck $2 
    .msg #PestControl.Staff 4World $+(11,$2,4) removed from PestControl.ini,WorldCheck
  }
  else {
    var %Lines $ini(PestControl.ini,WorldCheck,0)

    while (%lines > 0) { 
      var %Check %Check $ini(PestControl.ini,WorldCheck,%Lines) 
      dec %Lines 
    }

    .msg #PestControl.Staff 4Worlds to check: $replace(%Check,$chr(32),$chr(44))
  }
}