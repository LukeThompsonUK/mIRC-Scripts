; These shortcut the /*Serv commands to /*s
Ns { NickServ $1- }
Cs { ChanServ $1- }
Bs { BotServ $1- }
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
  NickServ ghost $1 $($+(%,$network,.password),2) 
  .timer 1 5 Nick $1
}

; Shortcut some useful bans
TB { Ban -ku $+ $calc($2 * 60) $chan $1 Time Banned for: $2 Minutes. }
SK { Ban -ku5 $chan $1- }
KB { mode $chan +b $address($1,2) | Kick $chan $1 $2- }

; Muting only works on unrealircd
mute { mode $chan +bb-qoahv ~q: $+ $address($1,2) ~n: $+ $address($1,2) $str($1 $chr(32),5) }
unmute { mode $chan -bb ~q: $+ $address($1,2) ~n: $+ $address($1,2) }

; Displays mirc and system uptime
uptime { echo -a 11[12mIRC Uptime11]12 $uptime(mIRC,2) | echo -a 11[12System Uptime11]12 $uptime(System,2) }

; Displays the text you typed in an md5/sha1 hash
hash {
  var %Show $iif($1 == -m,msg $active,echo -a)
  %Show Original: $iif($1 == -m,$2-,$1)
  %Show md5: $md5($iif($1 == -m,$2-,$1))
  %Show sha1: $sha1($iif($1 == -m,$2-,$1))
}

; A simple calculator
calc { echo -a 12 $+ $1- 11=12 $bytes($calc($remove($1-,$chr(44))),db) }