on $^*:Snotice:/Notice\s--\sClient\sconnecting\s(?:on|at).+:\s(\S+)\s\((\S+)\)/Si:{
  if (!$window($($+(@Clients.,$network),2))) { window -nz $($+(@Clients.,$network),2) }
  aline -p $($+(@Clients.,$network),2) 12(7 $+ $time $+ 12) 4Connect:7 $+($regml(1),!,$regml(2))
  haltdef
}
on $^*:Snotice:/Notice\s--\sClient\sexitin(?:g\sat.+:\s(\S+)\s\(.+\)|g:\s(\S+)\s\((\S+)\)\s\[(.+)\])/Si:{
  if (!$window($($+(@Clients.,$network),2))) { window -nz $($+(@Clients.,$network),2) }
  aline -p $($+(@Clients.,$network),2) 12(7 $+ $time $+ 12) 4Disconnect:7 $+($regml(1),!,$regml(2)) 12->7 $regml(3)
  ;haltdef
}
on $^*:Snotice:/Notice\s--\sReceived\sKILL\smessage\sfor\s(\S+)\sfrom\s(\S+)\sPath:\s(\S+)!(\S+)\s\((.+)\)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(7 $+ $time $+ 12) 4KILL:7 $regml(1) 12was killed by7 $+($regml(2),!,$regml(4),@,$regml(3)) 12for7 $regml(5)
  ;haltdef
}
on $^*:Snotice:/(.:Line)\sadded\sfor\s(\S+)\son.+\(from\s(\S+)(?:\sto\sexpire\sat\s(.+))?:\s(.+)\)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(7 $+ $time $+ 12) $+(4,$regml(1),:7) $regml(3) 12set7 $regml(2) 12set to expire on:7 $iif($regml(5),$regml(4),Permanent) 12reason:7 $iif($regml(5),$regml(5),$regml(4))
  haltdef
}
on $^*:Snotice:/Expiring\s(?:Global\s)?(.):Line\s\((\S+)\)\smade\sby\s(\S+)\s\(Reason:\s(.+)\)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -p $($+(@Network-Kills/Bans.,$network),2) 12(7 $+ $time $+ 12) 4Expiring $+($regml(1),:Line:7) $regml(2) 12set by7 $regml(3) 12reason7 $regml(4)
  haltdef
}
on $^*:Snotice:/(\S+)\sremoved\s(?:Global\s)?(\S+)\s(\S+).+\sreason:\s(.+)\)/Si:{
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(7 $+ $time $+ 12) $+(4Removed,$chr(32),$regml(2),:7) $regml(1) 12removed7 $regml(3)
  haltdef
}
on $^*:Snotice:/Notice\s--\s(\S+)\s\((\S+)\)\shas\s(?:been\sforced\sto\s)?change(?:d)?\shis.her\snickname\sto\s(\S+)/Si:{
  if (!$window($($+(@NickChanges.,$network),2))) { window -nz $($+(@NickChanges.,$network),2) }
  aline -p $($+(@NickChanges.,$network),2) 12(7 $+ $time $+ 12) 4NickChange:7 $+($regml(1),!,$regml(2)) 12->7 $regml(3)
  haltdef
}
on $^*:Snotice:/OperOverride\s--\s(\S+)\s\((\S+)\)\s(.+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4OverRide:7 $+($regml(1),!,$regml(2)) 12used Oper-Override for:7 $regml(3)
  haltdef
}
on $^*:Snotice:/(\S+)\s\((\S+)\)\s\[(\S+)\]\sis\snow\s(.+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4Oper:7 $+($regml(1),!,$regml(2)) 12using OperID7 $regml(3) 12is now7 $regml(4)
  haltdef
}
on $^*:Snotice:/Failed\sOPER\sattempt\sby\s(\S+)\s\((\S+)\)\s(?:using\sUID\s(\S+)\s)?\[(.+)\]/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4Failed Oper Attempt:7 $+($regml(1),!,$regml(2)) 12OperID7 $iif($regml(4),$regml(3),Not Valid) 12reason:7 $iif($regml(4),$regml(4),$regml(3))
  haltdef
}
on $^*:Snotice:/Notice\s--\s(\S+)\sused\s(\S+)\sto\smake\s(\S+)\s(\S+)\s(\S+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) $+(4,$regml(2),:7) $regml(1) 12used $regml(2) to make7 $regml(3) $+(12,$regml(4),7) $regml(5)
  haltdef
}
on $^*:Snotice:/(\S+)\sused\sSAMODE\s(\S+)\s\((.+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SAMODE:7 $regml(1) 12used SAMODE on7 $regml(2) 12to set modes7 $regml(3)
}
on $^*:Snotice:/(\S+)\schanged\sthe\svirtual\s(\S+)\sof\s(\S+)\s\((\S+)\)\sto\sbe\s(\S+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) $+(4CHG,$iif($regml(2) == ident,IDENT,HOST),:7) $regml(1) 12changed the virtual $regml(2) of7 $+($regml(3),!,$regml(4)) 12to7 $regml(5)
  haltdef
}
on $^*:Snotice:/(\S+)\schanged\sthe\sGECOS\sof\s(\S+)\s\((\S+)\)\sto\sbe\s(.+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4CHGNAME:7 $regml(1) 12changed the real name of7 $+($regml(2),!,$regml(3)) 12to7 $regml(4)
  haltdef
}
on $^*:Snotice:/Notice\s--\s(\S+)\sclosed\s(\S+)\sunknown\sconnections/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4CLOSE:7 $regml(1) 12used CLOSE to close7 $regml(2) 12unknown connections.
  haltdef
}
on $^*:Snotice:/Stats\s'(\S+)'\srequested\sby\s(\S+)\s\((\S+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4STATS:7 $+($regml(2),!,$regml(3)) 12->7 $regml(1)
  haltdef
}
on $^*:Snotice:/Notice\s--\sTS\sControl\s-\s(\S+)\sset\stime\sto\sbe\s(\S+)\s\(timediff:\s(\S+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4TS Control:7 $regml(1) 12set the IRC time to be7 $regml(2) 12TimeDifference is now7 $regml(3)
  haltdef
}
on $^*:Snotice:/Flood\s--\s(\S+)\s\((\S+)\)\sexceeds\s(\S+)\srecvQ/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4Flood:7 $regml(1) 12exceeded the recvQ limit7 $regml(2) > $regml(3)
  haltdef
}
on $^*:Snotice:/\[Spamfilter\]\s(\S+)\smatches\sfilter\s'(\S+)':\s\[([^\]]+)\](?:\s\[([^\]]+)\])?/Si:{ 
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SpamFilter:7 $regml(1) 12Matched7 $regml(2) 12using7 $regml(3) $iif($regml(4),12reason for filter:7 $regml(4),)
  haltdef
}
on $^*:Snotice:/(\S+)\sremoved\sspamfilter\s'(\S+)'/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SpamFilter:7 $regml(1) 12removed spamfilter7 $regml(2)
  haltdef
}
on $^*:Snotice:/Spamfilter\sAdded:\s\S+\s\[target:\s(\S+)\]\s\[action:\s([^\]]+)\]\s\[reason:\s([^\]]+)\]\son\s.*\(from\s(\S+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SpamFilter:7 $regml(4) 12added7 $4 12targeting:7 $regml(1) 12action:7 $regml(2) 12reason:7 $regml(3)
  haltdef
}
;
; Linking/Delinking
; Currently untested. It's on my list of shit to do. If anyone wants to lend me a testnet that would be great.
/*
on $*^:Snotice:/Received\sSQUIT\s(\S+)\sfrom\s(\S+)\[(\S+)\]\s\((.+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SQUIT:7 $regml(1) 12from7 $regml(2) ( $+ $regml(3) $+ ) 12reason:7 $regml(4)
}
on $^*:Snotice:/Notice\s--\s\(link\)\sLink\s(\S+)\s->\s(\S+)\[@(\S+)\]\sestablished/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4LINK:7 $regml(1) 12linked7 $regml(2) ( $+ $regml(3) $+ )
}
on $^*:Snotice:/Notice\s--\sLink\s(\S+)\s->\s(\S+)\sis\snow\ssynced\s\[secs:\s(\S+)\srecv:\s(\S+)\ssent:\s(\S+)\]/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(7 $+ $time $+ 12) 4SYNC:7 $regml(1) 12->7 $regml(2)
}
*/
on $^*:Snotice:/Lag\sreply\s--\s(\S+)\s(\S+)\s(\d+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(07 $+ $time $+ 12) 4LAG:07 $regml(1) 12<-->07 $regml(2) 12->07 $regml(3) 12(07 $+ $duration($calc($ctime - $regml(3))) $+ 12)
}