/*
* Syntax:
* /AutoConnect -join #Channel [Adds a channel to your autojoin list]
* /AutoConnect -del #Channel [Removes a channel from your autojoin list]
* /AutoConnect -setmodes +modes/-modes [Sets/removes modes on connect]
* /AutoConnect -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
* /AutoConnect -nick Nickhere [Sets your nick to the specified nick on connect for that network]
*/
alias autoconnect { 
  if (($1 == -join) && ($regex(autoconnect,$2,/^#\S+$/))) {
    writeini AutoLoginInformation.ini $network &Channels $addtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,44))
    echo -a $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  elseif (($1 == -del) && ($regex(autoconnect,$2,/^#\S+$/))) {
    var %Tok $findtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,1,44)
    writeini AutoLoginInformation.ini $network &Channels $deltok($readini(AutoLoginInformation.ini,$network,&Channels),%Tok,44)
    echo -a $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  elseif (($1 == -setmodes) && ($2)) {
    writeini AutoLoginInformation.ini $network &Modes $2
    echo -a $+([,$network,]) Modes on connect set to: $2
  }
  elseif (($1 == -vhost) && ($3)) {
    writeini AutoLoginInformation.ini $network &Vhost $+($2,:,$3)
    echo -a $+([,$network,]) Vhost set to: $2 - password: $3
  }
  elseif (($1 == -nick) && ($2)) {
    writeini AutoLoginInformation.ini $network &Nick $2
    echo -a $+([,$network,]) Nick set to: $2
  }
  elseif (($1 == -status) && ($2)) {
    echo -a -
    echo -a 10Printing information for: $2
    if (!$ini(AutoLoginInformation.ini,$2,0)) {
      echo -a 10No information found.
    }
    else {
      var %ToCheck $ini(AutoLoginInformation.ini,$2,0)
    }
    while (%ToCheck > 0) {
      echo -a $+(10,$ini(AutoLoginInformation.ini,$2,%ToCheck),:07) $readini(AutoLoginInformation.ini,$2,$ini(AutoLoginInformation.ini,$2,%ToCheck))
      dec %ToCheck
    }
    echo -a [Note] If you're using AutoIdentify some information from that script will be printed here also
    echo -a [Note] &Channels, &Modes, &Vhost, and &Nick are all from AutoIdentify
    echo -a -
  }
  else { 
    echo -a 07Syntax:
    echo -a 10/AutoConnect -join #Channel [Adds a channel to your autojoin list]
    echo -a 10/AutoConnect -del #Channel [Removes a channel from your autojoin list]
    echo -a 10/AutoConnect -setmodes +modes/-modes [Sets/removes modes on connect]
    echo -a 10/AutoConnect -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
    echo -a 10/AutoConnect -nick Nickhere [Sets your nick to the specified nick on connect for that network]
    echo -a 10/AutoConnect -status NetworkHere [Prints status for the given network]
  }
}
raw 001:*:{
  set %Connect.raw on
}
raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($ini(AutoLoginInformation.ini,$regml(Raw005Name,1))) {
        if ($ini(AutoLoginInformation.ini,$network,&Nick)) {
          nick $readini(AutoLoginInformation.ini,$network,&Nick)
        }
        if ($ini(AutoLoginInformation.ini,$network,&Vhost)) {
          vhost $replace($readini(AutoLoginInformation.ini,$network,&Vhost),$chr(58),$chr(32)))
        }
        if ($ini(AutoLoginInformation.ini,$network,&Modes)) {
          mode $me $readini(AutoLoginInformation.ini,$network,&Modes)
        }
        if ($ini(AutoLoginInformation.ini,$network,&Channels)) {
          .timer 1 5 join -n $readini(AutoLoginInformation.ini,$network,&Channels)
        }
      }
      unset %Connect.Raw
    }
  }
}
