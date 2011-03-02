alias CheckPrivilages {
  if (!$2) { 
    echo -a Syntax: /CheckPrivilages <#chan> <nick>[,<nick2>,<nick3>]
    halt
  }

  set %CPrivilages_Nicks $2
  set %CPriv_Check ON
  .msg ChanServ FLAGS $1
}


on $^*:Notice:/^End\sof\s\S+\sFLAGS\slisting\.$/Si:?:{
  if (%CPriv_Check) {
    echo -a Unfound nick(s): $iif(%CPrivilages_Nicks,%CPrivilages_Nicks,None)
    unset %CPrivilages_Nicks
    haltdef
  }
}


on ^*:Notice:*:?:{
  if (($nick == ChanServ) && (%CPriv_Check)) {
    if ($regex(CPrivilages,$1-,/^\d+\s+(\S+)\s+\+([a-zA-Z]+)\s(?:\(.+\)\s)?\[.+\]$/Si)) {
      if ($istok(%CPrivilages_Nicks,$regml(CPrivilages,1),44)) {
        echo -a -
        echo -a Privilaegs for $+($regml(CPrivilages,1),:)

        ; This is going to be the shitty part. This is why mIRC needs a 'switch' function.
        if (v isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ Voice/Devoice commands.
        }

        if (V isincs $regml(CPrivilages,2)) {
          echo -a User is automatically voiced upon joining the channel.
        }

        if (o isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ Op/Deop commands.
        }

        if (O isincs $regml(CPrivilages,2)) {
          echo -a User is automatically opped upon joining the channel.
        }

        if (s isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ SET command.
        }

        if (i isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ INVITE and GETKEY commands.
        }

        if (r isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ KICK, KICKBAN, BAN, and UNBAN commands.
        }

        if (R isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ RECOVER and CLEAR commands.
        }

        if (f isincs $regml(CPrivilages,2)) {
          echo -a User can modify the channel access list.
        }

        if (t isincs $regml(CPrivilages,2)) {
          echo -a User can use the /ChanServ TOPIC and TOPICAPPEND commands.
        }

        if (A isincs $regml(CPrivilages,2)) {
          echo -a User can view the channel access list.
        }

        if (F isincs $regml(CPrivilages,2)) {
          echo -a User is a channel founder.
        }

        if (b isincs $regml(CPrivilages,2)) {
          echo -a User is automatically banned unpon joining.
        }

        set %CPrivilages_Nicks $remtok(%CPrivilages_Nicks,$regml(CPrivilages,1),0,44)
        echo -a -
      }
    }

    haltdef
  }
}
