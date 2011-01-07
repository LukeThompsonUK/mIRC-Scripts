alias /LoginDetails {
  if ($1 == -d) {
    if ($2) {
      remini AutoLoginInformation.ini $network $2
      echo -a Removed $2 from your autologin nicklist on $network
    }
    else {
      remini AutoLoginInformation.ini $network $me
      echo -a Removed $me from your autologin nicklist on $network
    }
  }
  writeini AutoLoginInformation.ini $network $me $$?="Enter the password for autoidentifying"
  echo -a -
  echo -a Network: $network
  echo -a Username: $me
  echo -a Password: $readini(AutoLoginInformation.ini,$network,$me)
  echo -a To remove this username/password type /LoginDetails -d $me
  echo -a -
}

menu channel,status {
  NickServ autologin information
  .Set a nick for autologin:{
    writeini AutoLoginInformation.ini $network $$?="Enter the nick to identify with" $$?="Enter the password for the nickname"
    echo -a Updated the autologin information for $network
  }
  .Remove a nick from autologin:{
    remini AutoLoginInformation.ini $network $$?="Enter the nick to delete"
    echo -a Updated the autologin information for $network
  }
  .View information for this network: {
    var %x 1
    echo -a -
    echo -a Network: $network
    while (%x <= $ini(AutoLoginInformation.ini,$network,0)) {
      echo -a $ini(AutoLoginInformation.ini,$network,%x) : $readini(AutoLoginInformation.ini,$network,$ini(AutoLoginInformation.ini,$network,%x))
      inc %x
    }
    echo -a [Note] If you're using AutojoinOnConnect some information from that script will be printed here also
    echo -a [Note] &Channels, &Modes, &Vhost, and &Nick are all from AutojoinOnConnect
    echo -a -
  }
}

on *:NOTICE:*:?:{
  if ($nick == NickServ) {
    if ((This nickname is registered isin $1-) || (Please identify via isin $1-)) {
      if ($readini(AutoLoginInformation.ini,$network,$me)) {
        NickServ IDENTIFY $readini(AutoLoginInformation.ini,$network,$me)
      }
      else { 
        echo -a $+([,$network,:,$me,]) You're not set to autoidentify with this nickname.
      }
    }
  }
}

; This alias will work outside of the script also, so you can use /ghost namehere to ghost somebody.
alias Ghost { 
  if (-switch == $1) {
    var %GhostNick $2
    var %Switch on
    if ($3) {
      var %Password $3
    }
    else {
      var %Password $readini(AutoLoginInformation.ini,$network,%GhostNick)
    }
  }
  else {
    var %GhostNick $1
    if ($2) {
      var %Password $2
    }
    else {
      var %Password $readini(AutoLoginInformation.ini,$network,$1)
    }
  }
  if (%Password) {
    NickServ ghost %GhostNick %Password
    if (%Switch) {
      .timer 1 3 nick %GhostNick
    }
  }
  else {
    echo -a -
    echo -a 10Syntax:
    echo -a 10/Ghost [-switch] <nick> [password]
    echo -a 10Password is optional if you have the nick setup for auto identfying.
    echo -a 10If -switch is used you will /nick to the nick after ghosting.
    echo -a -
  }
}

raw 433:*nickname is already in use.*:{ ghost -switch $2 }
