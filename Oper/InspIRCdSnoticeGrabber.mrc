; *** CONNECT: Client connecting on port 6697: Nick!Ident@Host.com [IP.IP.IP.IP] [Test Nick]
on $^*:Snotice:/^\*{3}\sCONNECT:.+port\s(\S+):\s(\S+)\s\[(\S+)\]\s\[(.+)\]/Si:{
  if (!$window(@Clients)) { 
    window -nz @Clients 
  }

  aline -p @Clients 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Connect:7 $+($regml(2),:,$regml(4)) 12on port7 $regml(1)
  haltdef
}

;*** ANNOUNCEMENT: Connecting user 897AAAL5F detected as using CGI:IRC (IP.IP.IP.IP), changing real host to Host.com from IP.IP.IP.IP
; IP.IP.IP.IP is the same IP in both places I replaced. Otherwise I would have used IP2.IP2..etc to denote a difference
; Host.com is the real host of the person connecting, NOT the webserver they are connecting through.
; 897AAAL5F is the UUID of the user.
on $^*:Snotice:/^\*{3}\sANNOUNCEMENT:.+\s(\S+)\sdetected.+CGI:IRC\s\((\S+)\).+to\s(\S+)\sfrom\s\S+$/Si:{
  if (!$window(@Clients)) { 
    window -nz @Clients 
  }

  aline -p @Clients 12(09 $+ $time $+ 12) $+(13[,$network,]) 4WebChat Connect:07 $+($regml(1),!,$regml(3)) 12from07 $regml(2)
  haltdef
}


;*** QUIT: Client exiting: Nick!Ident@Host.com [Quit: Quitting IRC]
; Note that the 'Quit:' prefix will not always be shown, when being server banned, killed, ghosted, or ping timeouting
; It will be different, so when matching you should match from [ to the end of the line for a quit reason
; Sometimes the ending ] will not be shown on long lines as it's cut off from the buffer due to the newline needing to be added
on $^*:Snotice:/^\*{3}\sQUIT:\sClient\sexiting:\s(\S+)\s\[(.+).$/Si:{
  if (!$window(@Clients)) { 
    window -nz @Clients 
  }

  aline -p @Clients 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Disconnect:7 $regml(1) 12->07 $regml(2)
  haltdef
}


;*** NICK: User TestNick changed their nickname to TestNick1
on $^*:Snotice:/^\*{3}\sNICK:\sUser\s(\S+).+to\s(\S+)/Si:{
  if (!$window(@Clients)) { 
    window -nz @Clients 
  }

  aline -p @Clients 12(09 $+ $time $+ 12) $+(13[,$network,]) 8Nick:7 $regml(1) 12->07 $regml(2)
  haltdef
}


;*** KILL: Local Kill by Shawn: Nick!Ident@Host.com (Kill Message Here)
on $^*:Snotice:/^\*{3}\sKill:.+by\s(\S+):\s(\S+)\s\((.+)\)/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans 
  }

  aline $iif($regml(1) == NickServ,-p,-ph) @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4KILL:7 $regml(2) 12was killed by7 $regml(1) 12->07 $regml(3)
  haltdef
}


on $^*:Snotice:/^\*{3}\sXLINE:\s(\S+).+for\s(\S+):\s(.+)/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans
  }

  aline -ph @Network-Kills/Bans) 12(09 $+ $time $+ 12) $+(13[,$network,]) 4PERMANENT XLINE:7 $regml(2) 12added by7 $regml(1) 12for7 $regml(3)
  haltdef
}

; Done on a local server.
;*** XLINE: Shawn added timed G-line for *@IP.IP.IP.IP, expires on Fri Jan 28 14:00:26 2011: Ban Reason Here
on $^*:Snotice:/^\*{3}\sXLINE:\s(\S+).+for\s(\S+),.+on\s(.+):\s(.+)$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 04TIMED XLINE:07 $regml(1) 12->07 $regml(2) 12for07 $regml(4) 12expires07 $regml(3)
  haltdef
}


; Done on a remove server. (Or possibly just Atheme?)
;*** XLINE: Services.CriticalSecurity.net added GLINE on *@IP.IP.IP.IP to expire on Sat Jan 29 14:12:48 2011 (Ban Reason Here).
on $^*:Snotice:/^\*{3}\sXLINE:\s(\S+).+on\s(\S+).+on\s(.+)\s\((.+)\)\.$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans 
  }

  aline -ph @Network-Kills/Bans. 12(09 $+ $time $+ 12) $+(13[,$network,]) 04TIMED XLINE:07 $regml(1) 12->07 $regml(2) 12for07 $regml(4) 12expires07 $regml(3)
  haltdef
}


on $^*:Snotice:/^\*{3}\sXLINE:\s(\S+).+\son\s(\S+)\./Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans 
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4XLINE REMOVAL:07 $regml(1) 12->07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sXLINE:.+\s(\S+)\s\(.+\s(\S+\s\d+.+)\)$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4XLINE EXPIRE:07 $regml(1) 12originally set by07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sXLINE:\sQ-Lined\snickname\s(\S+)\sfrom\s(\S+):\s(.+)$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans 
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4QLINE:07 $regml(2) 12->07 $regml(1) 12reason:07 $regml(3)
  haltdef
}

;*** FLOOD: Excess flood from: Nick!Ident@Host
on $^*:Snotice:/^\*{3}\sFLOOD:.+from:\s(\S+)$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans 
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4FLOOD:07 $regml(1)
  haltdef
}


;*** ANNOUNCEMENT: User NICK RecvQ of 10240 exceeds connect class maximum of 8192
on $^*:Snotice:/^\*{3}\sANNOUNCEMENT:\sUser\s(\S+)\sRecvQ.+\s(\d+).+\s(\d+)$/Si:{
  if (!$window(@Network-Kills/Bans)) { 
    window -nz @Network-Kills/Bans
  }

  aline -ph @Network-Kills/Bans 12(09 $+ $time $+ 12) $+(13[,$network,]) 4FLOOD:07 $regml(1) $+(12[07,$regml(2),12/07,$regml(3),12]03 [total/limit])
  haltdef
}


on $^*:Snotice:/^\*{3}\sOPER:\s(\S+)\s\((\S+)\).+type\s(\S+).+'(\S+)'/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper
  }

  aline -p @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Oper:7 $+($regml(1),!,$regml(2)) 12using OperID07 $regml(4) 12is now a7 $regml(3)
  haltdef
}


on $^*:Snotice:/^\*{3}\sREMOTEOPER:\sFrom\s(\S+):\sUser\s(\S+)\s\((\S+)\).+type\s(\S+)/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -p @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Oper:7 $+($regml(2),!,$regml(3)) 12using OperID07 $regml(4) 12from server:07 $regml(1)
  haltdef
}


on $^*:Snotice:/^\*{3}\sOPER:\sUser\s(\S+)\sde-opered\s\(by\s(\S+)\)/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Oper:7 $regml(1) 12Deopered by7 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sSTATS:\s(?:Remote\sstats|Stats)\s'(.)'.+\s(\S+)\s\((\S+)\)$/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -p @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 4Stats:7 $+($regml(2),!,$regml(3)) 12->7 $regml(1)
  haltdef
}


on $^*:Snotice:/^\*{3}\sOPER:.+by\s(\S+)\susing\slogin\s'(\S+)':.+:(.+)$/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 4FAIL-Oper:7 $regml(1) 12using login7 $regml(2) 12failed fields7 $regml(3)
  haltdef
}


on $^*:Snotice:/^\*{3}\sANNOUNCEMENT:\s(\S+)\sused\s(\S+)\sto\smake\s(\S+)\s(?:join|part)\s(\S+)/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) $+(04,$regml(2),:07) $+($regml(3),12->07,$regml(4))) 12by07 $regml(1)
}


on $^*:Snotice:/^\*{3}\sANNOUNCEMENT:\s(\S+)\sused\sSAMODE:\s(\S+)\s(\S+)/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 04SAMODE:07 $regml(1) 12for07 $regml(2) 12->07 $regml(3)
}


on $^*:Snotice:/^\*{3}\sLINK:\sServer\s(\S+)\sSplit:(.+)$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server. 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04NETSPLIT:07 $regml(1) 12->07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+(\d+).+(\d+)\sservers\.$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04NETSPLIT-LOST:07 $regml(1) 12user(s)
  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04NETSPLIT-LOST:07 $regml(2) 12server(s)

  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+'(\S+)'\sfailed\.$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04NETSPLIT:07 $regml(1) 12failed.
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+'(\S+)'.+for\s(\S+)$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04NETSPLIT:07 $regml(1) 12was online for07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+from\s(\S+)\[(\S+)\]\s\((.+)\)$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04LINK:07 $+($regml(1),@,$regml(2)) 12->07 $regml(3)
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+to\s(\S+)\s\(Authentication:\s(.+)\)\.$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04LINK-BURST:07 $regml(1) 12->07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:\sFinished\sbursting\sto\s(\S+)\.$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04LINK-ENDBURST:07 $regml(1)
  haltdef
}


on $^*:Snotice:/^\*{3}\sLINK:.+from\s(\S+)\s\(burst\stime:\s(.+)\)$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04LINK-SYNC:07 $regml(1) 12->07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\sFILTER:\s(\S+).+'(\S+)',\stype\s'(\S+)',\sflags\s'(\S+)',\sreason:\s(.+)$/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 04FILTER:07 $regml(1) 12->07 $regml(2) 12->07 $regml(5)
  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 04FILTER-TYPE:07 $regml(3)
  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 04FILTER-FLAGS:07 $regml(4)

  haltdef
}


on $^*:Snotice:/^\*{3}\sFILTER:\s(\S+)\sremoved\sfilter\s'(\S+)'$/Si:{
  if (!$window(@Oper)) { 
    window -nz @Oper 
  }

  aline -ph @Oper 12(09 $+ $time $+ 12) $+(13[,$network,]) 04FILTER REMOVAL:07 $regml(1) 12->07 $regml(2)
  haltdef
}


on $^*:Snotice:/^\*{3}\s(\S+)\s\((\S+)\).+\/whois/Si:{
  if (!$window(@Other)) { 
    window -nz @Other 
  }

  aline -ph @Other 12(09 $+ $time $+ 12) $+(13[,$network,]) 04WHOIS:07 $+($regml(1),!,$regml(2))
  haltdef
}


on $^*:WALLOPS:*:{
  if (!$window($($+(@WallOPS.,$network),2))) { 
    window -nezg1 $($+(@WallOPS.,$network),2) 
  }

  aline -ph $($+(@WallOPS.,$network),2) 12(7 $+ $time $+ 12) 4WallOps:7 $nick 12->7 $1-
  haltdef
}
on *:INPUT:@WallOPS.*:{ WallOPS $1- | haltdef }


on $^*:Snotice:/^\*{3}\sGLOBOPS:\sfrom\s(\S+):\s(.+)$/Si:{
  if (!$window($($+(@GlobOPS.,$network),2))) { 
    window -nezg1 $($+(@GlobOPS.,$network),2) 
  }

  aline -ph $($+(@GlobOPS.,$network),2) 12(07 $+ $time $+ 12) 04Global:07 $regml(1) 12->07 $regml(2)
  haltdef
}
on *:INPUT:@GlobOPS.*:{ GlobOPS $1- | haltdef }


on $^*:Snotice:/^\*{3}\sANNOUNCEMENT:\s(\S+).+rehashing.+\s(\S+)\son\s(\S+)$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04Rehash:07 $regml(1) 12->07 $+($regml(3),:,$regml(2))
  haltdef
}
on $^*:Snotice:/^\*{3}\sSuccessfully\srehashed\sserver\.$/Si:{
  if (!$window(@Server)) { 
    window -nz @Server 
  }

  aline -ph @Server 12(09 $+ $time $+ 12) $+(13[,$network,]) 04Rehash:07 Successfully rehashed server.
  haltdef
}
