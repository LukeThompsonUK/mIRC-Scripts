alias autojoin { 
  if (($1 == -d) && ($2)) {
    var %Tok $findtok($readini(AutoJoin.ini,$network,Channels),$2,1,44)
    writeini AutoJoin.ini $network Channels $deltok($readini(AutoJoin.ini,$network,Channels),%Tok,44)
    echo -a $+([,$network,]) $readini(AutoJoin.ini,$network,Channels)
  }
  else {
    writeini AutoJoin.ini $network Channels $addtok($readini(AutoJoin.ini,$network,Channels),$chan,44))
    echo -a $+([,$network,]) $readini(AutoJoin.ini,$network,Channels)
  }
}
alias setconnectmodes {
  writeini AutoJoin.ini $network Modes $1
  echo -a $+([,$network,]) Modes on connect set to: $1
}
raw 001:*:{
  set %Connect.raw on
}
raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($readini(NetworkAutoJoin.ini,$regml(Raw005Name,1))) {
        if ($readini(AutoJoin.ini,$network,Channels)) {
          join -n $readini(AutoJoin.ini,$network,Channels)
        }
        if ($readini(AutoJoin.ini,$network,Modes)) {
          mode $me $readini(AutoJoin.ini,$network,Modes)
        }
      }
      unset %Connect.Raw
    }
  }
}
