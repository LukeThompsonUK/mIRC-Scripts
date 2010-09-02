/Ns { /NickServ $1- }
/Cs { /ChanServ $1- }
/Bs { /BotServ $1- }
/hs { /HostServ $1- }
/ms { /MemoServ $1- }
/os { /OperServ $1- }
/voice $iif($1,mode $chan + $+ $str(v,$modespl) $1-,mode $chan +v $me)
/devoice $iif($1,mode $chan - $+ $str(v,$modespl) $1-,mode $chan -v $me)
/halfop $iif($1,mode $chan + $+ $str(h,$modespl) $1-,mode $chan +h $me)
/dehalfop $iif($1,mode $chan - $+ $str(h,$modespl) $1-,mode $chan -h $me)
/op $iif($1,mode $chan + $+ $str(o,$modespl) $1-,mode $chan +o $me)
/Ghost { 
  NickServ ghost $1 $($+(%,$network,.password),2) 
  .timer 1 5 Nick $1
}
/TB { Ban -ku $+ $calc($2 * 60) $chan $1 Time Banned for: $2 Minutes. }
/SK { Ban -ku5 $chan $1- }
/KB { mode $chan +b $address($1,2) | Kick $chan $1 $2- }
/mute { mode $chan +bb-qoahv ~q: $+ $address($1,2) ~n: $+ $address($1,2) $str($1 $chr(32),5) }
/unmute { mode $chan -bb ~q: $+ $address($1,2) ~n: $+ $address($1,2) }