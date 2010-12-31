/*
* AutoJoinOnConnect.mrc
* Syntax: /Autojoin [-d|-setmodes] [#Channel|ModesToSet]
* /Autojoin #channel will set the channel typed in to the autojoin list, if -d is present it will remove the channel.
* If -setmodes is present it will change the modes to set for that network to whatever modes you put.
* -d and -setmodes can't be used together on the same line.
*/
alias autojoin { 
  if ($regex(AutoJoin,$1-2,/^-\S+\s\S+/)) {
    if ($1 == -d) {
      var %Tok $findtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,1,44)
      writeini AutoJoin.ini $network Channels $deltok($readini(AutoLoginInformation.ini,$network,&Channels),%Tok,44)
      echo -a $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
    }
    elseif ($1 == -setmodes) {
      writeini AutoLoginInformation.ini $network &Modes $2
      echo -a $+([,$network,]) Modes on connect set to: $2
    }
    elseif ($1 == -vhost) {
      writeini AutoLoginInformation.ini $network &Vhost $+($2,:,$3)
      echo -a $+([,$network,]) Vhost set to: $2 - password: $3
    }
    else {
      echo -a * Syntax: /Autojoin [-d|-setmodes] [#Channel|ModesToSet]
      echo -a * /Autojoin #channel will set the channel typed in to the autojoin list, if -d is present it will remove the channel.
      echo -a * If -setmodes is present it will change the modes to set for that network to whatever modes you put.
      echo -a * -d and -setmodes can't be used together on the same line.
    }
  }
  elseif ($regex(AutoJoin,$1,/^#\S+$/)) {
    writeini AutoLoginInformation.ini $network &Channels $addtok($readini(AutoLoginInformation.ini,$network,&Channels),$1,44))
    echo -a $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  else { 
    echo -a * Syntax: /Autojoin [-d|-setmodes] [#Channel|ModesToSet]
    echo -a * /Autojoin #channel will set the channel typed in to the autojoin list, if -d is present it will remove the channel.
    echo -a * If -setmodes is present it will change the modes to set for that network to whatever modes you put.
    echo -a * -d and -setmodes can't be used together on the same line.
  }
}
raw 001:*:{
  set %Connect.raw on
}
raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($ini(AutoLoginInformation.ini,$regml(Raw005Name,1))) {
        if ($ini(AutoLoginInformation.ini,$network,&Vhost)) {
          vhost $replace($readini(AutoLoginInformation.ini,$network,&Vhost),$chr(58),$chr(32)))
        }
        if ($ini(AutoLoginInformation.ini,$network,&Modes)) {
          mode $me $readini(AutoLoginInformation.ini,$network,&Modes)
        }
        if ($ini(AutoLoginInformation.ini,$network,&Channels)) {
          join -n $readini(AutoLoginInformation.ini,$network,&Channels)
        }
      }
      unset %Connect.Raw
    }
  }
}
