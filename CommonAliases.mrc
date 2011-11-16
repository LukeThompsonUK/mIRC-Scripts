; These shortcut the /*Serv commands to /*s
alias ns { NickServ $1- }
alias cs { ChanServ $1- }
alias bs { BotServ $1- }
alias hs { HostServ $1- }
alias ms { MemoServ $1- }
alias os { OperServ $1- }

; These shortcut /mode #chan +ohv to /voice/devoice/etc
alias voice $iif($1,mode $chan + $+ $str(v,$modespl) $1-,mode $chan +v $me)
alias devoice $iif($1,mode $chan - $+ $str(v,$modespl) $1-,mode $chan -v $me)
alias halfop $iif($1,mode $chan + $+ $str(h,$modespl) $1-,mode $chan +h $me)
alias dehalfop $iif($1,mode $chan - $+ $str(h,$modespl) $1-,mode $chan -h $me)
alias op $iif($1,mode $chan + $+ $str(o,$modespl) $1-,mode $chan +o $me)

; Ghosts a nickname
Ghost {
  NickServ ghost $1-
}

; /TB <nick> <minutes to ban>
; Timed ban.
alias TB { Ban -ku $+ $calc($2 * 60) $chan $1 Time Banned for: $2 Minutes. }

; /SK <nick>
; Bans the user for 5 seconds to prevent auto-rejoin scripts from working.
alias SK { Ban -ku5 $chan $1- }

; /KB <nick> <reason for ban>
; Bans the user until someone removes the ban.
alias KB { mode $chan +b $address($1,3) | Kick $chan $1 $2- }

; Displays mirc and system uptime
alias uptime {
  echo -a 11[12mIRC Uptime11]12 $uptime(mIRC,2)
  echo -a 11[12System Uptime11]12 $uptime(System,2)
}

; A simple calculator
alias calc { echo -a 12 $+ $1- 11=12 $bytes($calc($remove($1-,$chr(44))),db) }

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
