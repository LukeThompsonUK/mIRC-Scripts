on $^*:WALLOPS:*:{
  if (!$window($($+(@WallOPS.,$network),2))) { window -nezg1 $($+(@WallOPS.,$network),2) }
  aline -ph $($+(@WallOPS.,$network),2) 12(7 $+ $time $+ 12) 4WallOps:7 $nick 12->7 $1-
  haltdef
}
on $^*:Snotice:/CONNECT:(?:[^\]]+)port\s(\S+):\s(\S+)\s\[(\S+)\]\s\[([^\]]+)\]/Si:{
  if (!$window($($+(@Clients.,$network),2))) { window -nz $($+(@Clients.,$network),2) }
  aline -p $($+(@Clients.,$network),2) 12(09 $+ $time $+ 12) 4Connect:7 $+($regml(2),:,$regml(4)) 12on port7 $regml(1)
  haltdef
}
on $^*:Snotice:/ANNOUNCEMENT:\sConnecting\suser\s(\S+)\s(?:[^\]]+)\((\S+)\),\schanging\sreal\shost\sto\s(\S+)\sfrom\s(\S+)$/Si:{
  if (!$window($($+(@Clients.,$network),2))) { window -nz $($+(@Clients.,$network),2) }
  aline -p $($+(@Clients.,$network),2) 12(09 $+ $time $+ 12) 4WebChat Connect:07 $+($regml(1),!,$regml(3)) 12from07 $regml(2)
  haltdef
}
on $^*:Snotice:/QUIT:\sClient\sexiting:\s(\S+)\s\[(.+)\]$/Si:{
  if (!$window($($+(@Clients.,$network),2))) { window -nz $($+(@Clients.,$network),2) }
  aline -p $($+(@Clients.,$network),2) 12(09 $+ $time $+ 12) 4Disconnect:7 $regml(1) 12->07 $regml(2)
  haltdef
}
on $^*:Snotice:/NICK:\sUser\s(\S+)(?:[^\]]+)to\s(\S+)/Si:{
  if (!$window($($+(@NickChanges.,$network),2))) { window -nz $($+(@NickChanges.,$network),2) }
  aline -p $($+(@NickChanges.,$network),2) 12(09 $+ $time $+ 12) 4NickChange:7 $regml(1) 12->07 $regml(2)
  haltdef
}
on $^*:Snotice:/Kill:(?:[^\]]+)by\s(\S+):\s(\S+)\s\(([^\]]+)\)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 4KILL:7 $regml(2) 12was killed by7 $regml(1) 12->07 $regml(3)
  haltdef
}
on $^*:Snotice:/XLINE:\s(\S+)(?:[^\]]+)for\s(\S+):\s([^\]]+)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 4PERMANENT XLINE:7 $remove($regml(2),$chr(44)) 12added by7 $regml(1) 12for7 $regml(3)
}
on $^*:Snotice:/XLINE:\s(\S+)(?:[^\]]+)for\s(\S+),(?:[^\]]+)on\s([^\]]+):\s([^\]]+)$/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 04TIMED XLINE:07 $regml(1) 12->07 $regml(2) 12for07 $regml(4) 12expires07 $regml(3)
  haltdef
}
on $^*:Snotice:/XLINE:\s(\S+)(?:[^\]]+)\son\s(\S+)\./Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 4XLINE REMOVAL:07 $regml(1) 12->07 $regml(2)
  haltdef
}
on $^*:Snotice:/XLINE:\sRemoving\sExpired\s(?:\S+)\s(\S+)\s\(set\sby\s(\S+)(?:[^\]]+)\)/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 4XLINE EXPIRE:07 $regml(1) 12originally set by07 $regml(2)
  haltdef
}
on $^*:Snotice:/XLINE:\sQ-Lined\snickname\s(\S+)\sfrom\s(\S+):\s([^\]]+)$/Si:{
  if (!$window($($+(@Network-Kills/Bans.,$network),2))) { window -nz $($+(@Network-Kills/Bans.,$network),2) }
  aline -ph $($+(@Network-Kills/Bans.,$network),2) 12(09 $+ $time $+ 12) 4QLINE:07 $regml(2) 12->07 $regml(1)
}
on $^*:Snotice:/OPER:\s(\S+)\s\((\S+)\)(?:[^\]]+)type\s(\S+)(?:[^\]]+)'(\S+)'/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 4Oper:7 $+($regml(1),!,$regml(2)) 12using OperID07 $regml(4) 12is now a7 $regml(3)
  haltdef
}
on $^*:Snotice:/REMOTEOPER:\sFrom\s(\S+):\sUser\s(\S+)\s\((\S+)\)(?:[^\]]+)type\s(\S+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 4Oper:7 $+($regml(2),!,$regml(3)) 12using OperID07 $regml(4) 12from server:07 $regml(1)
  haltdef
}
on $^*:Snotice:/OPER:\sUser\s(\S+)\sde-opered\s\(by\s(\S+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 4Oper:7 $regml(1) 12Deopered by7 $regml(2)
}
on $^*:Snotice:/STATS:\s(?:Remote\sstats|Stats)\s'(.)'\srequested\sby\s(\S+)\s\((\S+)\)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -p $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 4Stats:7 $+($regml(2),!,$regml(3)) 12->7 $regml(1)
  haltdef
}
on $^*:Snotice:/OPER:(?:[^\]]+)by\s(\S+)\susing\slogin\s'(\S+)':(?:[^\]]+):([^\]]+)$/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 4FAIL-Oper:7 $regml(1) 12using login7 $regml(2) 12failed fields7 $regml(3)
  haltdef
}
on $^*:Snotice:/ANNOUNCEMENT:\s(\S+)\sused\s(\S+)\sto\smake\s(\S+)\s(?:join|part)\s(\S+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) $+(04,$regml(2),:07) $+($regml(3),12->07,$regml(4))) 12by07 $regml(1)
}
on $^*:Snotice:/ANNOUNCEMENT:\s(\S+)\sused\sSAMODE:\s(\S+)\s(\S+)/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 04SAMODE:07 $regml(1) 12for07 $regml(2) 12->07 $regml(3)
}
on $^*:Snotice:/LINK:\sServer\s(\S+)\sSplit:([^\]]+)$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04NETSPLIT:07 $regml(1) 12->07 $regml(2)
}
on $^*:Snotice:/LINK:(?:[^\]]+)(\d+)(?:[^\]]+)(\d+)\sservers.$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04NETSPLIT-LOST:07 $regml(1) 12user(s)
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04NETSPLIT-LOST:07 $regml(2) 12server(s)
}
on $^*:Snotice:/LINK:(?:[^\]]+)'(\S+)'\sfailed.$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04NETSPLIT:07 $regml(1) 12failed.
}
on $^*:Snotice:/LINK:(?:[^\]]+)'(\S+)'(?:[^\]]+)for\s(\S+)$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04NETSPLIT:07 $regml(1) 12was online for07 $regml(2)
}
on $^*:Snotice:/LINK:(?:[^\]]+)from\s(\S+)\[(\S+)\]\s\(([^\]]+)\)$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04LINK:07 $+($regml(1),@,$regml(2)) 12->07 $regml(3)
}
on $^*:Snotice:/LINK:(?:[^\]]+)to\s(\S+)\s\(Authentication:\s([^\]]+)\).$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04LINK-BURST:07 $regml(1) 12->07 $regml(2)
}
on $^*:Snotice:/LINK:\sFinished\sbursting\sto\s(\S+).$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04LINK-ENDBURST:07 $regml(1)
}
on $^*:Snotice:/LINK:(?:[^\]]+)from\s(\S+)\s\(burst\stime:\s([^\]]+)\)$/Si:{
  if (!$window($($+(@Server.,$network),2))) { window -nz $($+(@Server.,$network),2) }
  aline -ph $($+(@Server.,$network),2) 12(09 $+ $time $+ 12) 04LINK-SYNC:07 $regml(1) 12->07 $regml(2)
}
on $^*:Snotice:/FILTER:\s(\S+)(?:[^\]]+)'(\S+)',\stype\s'(\S+)',\sflags\s'(\S+)',\sreason:\s([^\]]+)$/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 04FILTER:07 $regml(1) 12->07 $regml(2) 12->07 $regml(5)
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 04FILTER-TYPE:07 $regml(3)
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 04FILTER-FLAGS:07 $regml(4)
  haltdef
}
on $^*:Snotice:/FILTER:\s(\S+)\sremoved\sfilter\s'(\S+)'$/Si:{
  if (!$window($($+(@Oper.,$network),2))) { window -nz $($+(@Oper.,$network),2) }
  aline -ph $($+(@Oper.,$network),2) 12(09 $+ $time $+ 12) 04FILTER REMOVAL:07 $regml(1) 12->07 $regml(2)
  haltdef
}
on $^*:Snotice:/GLOBOPS:\sfrom\s(\S+):\s([^\]]+)$/Si:{
  if (!$window($($+(@GlobOPS.,$network),2))) { window -nezg1 $($+(@GlobOPS.,$network),2) }
  aline -ph $($+(@GlobOPS.,$network),2) 12(07 $+ $time $+ 12) 04Global:07 $regml(1) 12->07 $regml(2)
  haltdef
}

on *:INPUT:@GlobOPS.*:{ GlobOPS $1- | haltdef }
on *:INPUT:@WallOPS.*:{ WallOPS $1- | haltdef }