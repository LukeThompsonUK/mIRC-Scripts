/*
* AutoJoinOnConnect.mrc
* Syntax: /Autojoin [-d|-setmodes] [#ChannelToDelete|ModesToSet]
* /Autojoin by itself will set the channel it's typed in to the autojoin list, if -d is present it will remove
* Whatever comes after the -d from the autojoin list
* If -setmodes is present it will change the modes to set for that network to whatever modes you put.
* -d and -setmodes can't be used together on the same line.
*/
alias autojoin { 
  if (($1 == -d) && ($2)) {
    var %Tok $findtok($readini(AutoJoin.ini,$network,Channels),$2,1,44)
    writeini AutoJoin.ini $network Channels $deltok($readini(AutoJoin.ini,$network,Channels),%Tok,44)
    echo -a $+([,$network,]) $readini(AutoJoin.ini,$network,Channels)
  }
  if (($1 == -setmodes) && ($2)) {
    writeini AutoJoin.ini $network Modes $2
    echo -a $+([,$network,]) Modes on connect set to: $2
  }
  else {
    writeini AutoJoin.ini $network Channels $addtok($readini(AutoJoin.ini,$network,Channels),$chan,44))
    echo -a $+([,$network,]) $readini(AutoJoin.ini,$network,Channels)
  }
}
raw 001:*:{
  set %Connect.raw on
}
raw 005:*:{
  if (%Connect.Raw) {
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($ini(AutoJoin.ini,$regml(Raw005Name,1))) {
        if ($ini(AutoJoin.ini,$network,Channels)) {
          join -n $readini(AutoJoin.ini,$network,Channels)
        }
        if ($ini(AutoJoin.ini,$network,Modes)) {
          mode $me $readini(AutoJoin.ini,$network,Modes)
        }
      }
      unset %Connect.Raw
    }
  }
}
