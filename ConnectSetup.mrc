/*
* Syntax:
* /ConnectSetup -join #Channel [Adds a channel to your autojoin list]
* /ConnectSetup -del #Channel [Removes a channel from your autojoin list]
* /ConnectSetup -setmodes +modes/-modes [Sets/removes modes on connect]
* /ConnectSetup -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
* /ConnectSetup -nick Nickhere [Sets your nick to the specified nick on connect for that network]
* /ConnectSetup -Oper OperUser OperPass [Adds a oper name for that network]
*/

on *:LOAD:{
  echo 07 -a To setup this script:
  echo 10 -a /ConnectSetup -join #Channel [Adds a channel to your autojoin list]
  echo 10 -a /ConnectSetup -del #Channel [Removes a channel from your autojoin list]
  echo 10 -a /ConnectSetup -setmodes +modes/-modes [Sets/removes modes on connect]
  echo 10 -a /ConnectSetup -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
  echo 10 -a /ConnectSetup -nick Nickhere [Sets your nick to the specified nick on connect for that network]
  echo 10 -a /ConnectSetup -oper Opername OperPass [Sets your oper name for that network]
  echo 10 -a /ConnectSetup -status NetworkHere [Prints status for the given network]
}

alias ConnectSetup { 
  if (($1 == -join) && ($regex(ConnectSetup,$2,/^#\S+$/))) {
    writeini AutoLoginInformation.ini $network &Channels $addtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,44)
    echo -a $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  elseif (($1 == -del) && ($regex(ConnectSetup,$2,/^#\S+$/))) {
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
  elseif (($1 == -oper) && ($3)) {
    writeini AutoLoginInformation.ini $network &Oper $+($2,:,$3)
    echo -a $+([,$network,]) Oper set to: $2 - password: $3
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

    echo -a -
  }
  else { 
    echo 07 -a Syntax:
    echo 10 -a /ConnectSetup -join #Channel [Adds a channel to your autojoin list]
    echo 10 -a /ConnectSetup -del #Channel [Removes a channel from your autojoin list]
    echo 10 -a /ConnectSetup -setmodes +modes/-modes [Sets/removes modes on connect]
    echo 10 -a /ConnectSetup -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
    echo 10 -a /ConnectSetup -nick Nickhere [Sets your nick to the specified nick on connect for that network]
    echo 10 -a /ConnectSetup -oper Opername OperPass [Sets your oper name for that network]
    echo 10 -a /ConnectSetup -status NetworkHere [Prints status for the given network]
  }
}

raw 001:*:{
  set %Connect.raw on
}

raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($ini(AutoLoginInformation.ini,$regml(Raw005Name,1))) {
        if ($ini(AutoLoginInformation.ini,$network,&Oper)) {
          oper $replace($readini(AutoLoginInformation.ini,$network,&Oper),$chr(58),$chr(32))
        }

        if ($ini(AutoLoginInformation.ini,$network,&Nick)) {
          nick $readini(AutoLoginInformation.ini,$network,&Nick)
        }

        if ($ini(AutoLoginInformation.ini,$network,&Modes)) {
          timerSETMODE [ $+ [ $network ] ] 1 10 //SetModes
        }

        if ($ini(AutoLoginInformation.ini,$network,&Vhost)) {
          vhost $replace($readini(AutoLoginInformation.ini,$network,&Vhost),$chr(58),$chr(32))
        }

        if ($ini(AutoLoginInformation.ini,$network,&Channels)) {
          timerJOINCHANNELS [ $+ [ $network ] ] 1 10 join -n $readini(AutoLoginInformation.ini,$network,&Channels)
        }
      }

      unset %Connect.Raw
    }
  }
}

; We use this alias to setmodes so $me is evaluated at the time the modes are set.
; This prevents us from using /mode on our previous nick.
alias -l SetModes {
  //mode $me $readini(AutoLoginInformation.ini,$network,&Modes)
}
