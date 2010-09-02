; Replace 'NAMEHERE' with your name.
on *:TEXT:*:#:{ 
  if ((NAMEHERE isin $1-) && ($active != $chan)) { 
    if (!$window(@Highlight)) { /window -nz @Highlight }
	; These are channels to not highlight on
    if ($istok(#Services:#IdleRPG:#IRPG:#Idle-RPG,$chan,58)) {
      aline -p @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
    }
    else { 
      aline -ph @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
    }
  }
}
on *:ACTION:*:#:{ 
  if ((NAMEHERE isin $1-) && ($active != $chan)) { 
    if (!$window(@Highlight)) { /window -nz @Highlight }
	; These are channels to not highlight on
    if ($istok(#Services:#IdleRPG:#IRPG:#Idle-RPG,$chan,58)) {
      aline -p @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
    }
    else { 
      aline -ph @Highlight $timestamp $($+(12[07,$network,12:07,$chan,12:07,$nick,12]07:),2) $1-
    }
  }
}