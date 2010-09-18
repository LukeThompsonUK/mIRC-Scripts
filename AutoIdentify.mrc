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
        echo -a You're not set to autoidentify with this nickname.
      }
    }
  }
}
