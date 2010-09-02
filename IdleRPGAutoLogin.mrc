; If you use this on a network that doesn't use any of the following channels, add the channel here.
on *:Join:#Idle-RPG,#IdleRPG,#IRPG:{ 
  if ($nick == $me) {
    if (($network == SeersIRC) && ($me == Shawn)) { msg SeersIdle login Shawn Passwordhere }
	; To add another network just create another elseif with the information you need.
    elseif (($network == example1) && ($me == Shawn)) { msg IdleRPGBotName login Shawn password }
    elseif (($network == example2) && ($me == Shawn)) { msg IdleRPG login Shawn somepasshere }
  }
}