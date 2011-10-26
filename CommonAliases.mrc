; These shortcut the /*Serv commands to /*s
ns { NickServ $1- }
cs { ChanServ $1- }
bs { BotServ $1- }
hs { HostServ $1- }
ms { MemoServ $1- }
os { OperServ $1- }

; These shortcut /mode #chan +ohv to /voice/devoice/etc
voice $iif($1,mode $chan + $+ $str(v,$modespl) $1-,mode $chan +v $me)
devoice $iif($1,mode $chan - $+ $str(v,$modespl) $1-,mode $chan -v $me)
halfop $iif($1,mode $chan + $+ $str(h,$modespl) $1-,mode $chan +h $me)
dehalfop $iif($1,mode $chan - $+ $str(h,$modespl) $1-,mode $chan -h $me)
op $iif($1,mode $chan + $+ $str(o,$modespl) $1-,mode $chan +o $me)

; Ghosts a nickname and then /nicks to it
Ghost { 
  NickServ ghost $1-
  .timer 1 5 Nick $1
}

; /TB <nick> <minutes to ban>
; Timed ban.
TB { Ban -ku $+ $calc($2 * 60) $chan $1 Time Banned for: $2 Minutes. }

; /SK <nick>
; Bans the user for 5 seconds to prevent auto-rejoin scripts from working.
SK { Ban -ku5 $chan $1- }

; /KB <nick> <reason for ban>
; Bans the user until someone removes the ban.
KB { mode $chan +b $address($1,3) | Kick $chan $1 $2- }

; Displays mirc and system uptime
uptime {
  echo -a 11[12mIRC Uptime11]12 $uptime(mIRC,2)
  echo -a 11[12System Uptime11]12 $uptime(System,2)
}

; A simple calculator
calc { echo -a 12 $+ $1- 11=12 $bytes($calc($remove($1-,$chr(44))),db) }

; This opens a @window that can be used as a notepad. Anything you type in the box will
; be stored there. It does not save and reload what you previously had written there however.
; I use it for quick storage of bits and pieces of information I need at the time.
alias notepad {
  if (!$window(@Notepad)) { 
    window -nezg1 @Notepad 
  }
}

on *:INPUT:@Notepad:{ 
  aline -ph @Notepad $1- 
}
