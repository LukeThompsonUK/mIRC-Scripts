; Begin the alias
alias LoginDetails {
  ; If the first thing is -d, ex: /LoginDetails -d
  if ($1 == -d) {
    ; If there is a second thing
    if ($2) {
      ; Delete the second thing from the current network in AutoLoginInformation.ini
      remini AutoLoginInformation.ini $network $2
      ; Display the removed
      echo -a Removed $2 from your autologin nicklist on $network
    }
    else {
      ; Since there was no second thing, delete the currently used nick
      remini AutoLoginInformation.ini $network $me
      ; Display the removed
      echo -a Removed $me from your autologin nicklist on $network
    }
  }

  ; Setup auto identifying with the current nick
  writeini AutoLoginInformation.ini $network $me $$?="Enter the password for autoidentifying"

  ; Display the current information
  echo -a -
  echo -a Network: $network
  echo -a Username: $me
  echo -a Password: $readini(AutoLoginInformation.ini,$network,$me)
  echo -a To remove this username/password type /LoginDetails -d $me
  echo -a -
}

; Some awesome popup menu for the script
menu channel,status {
  NickServ autologin information
  ; Setup auto identification for a nick
  .Set a nick for autologin:{
    writeini AutoLoginInformation.ini $network $$?="Enter the nick to identify with" $$?="Enter the password for the nickname"
    echo -a Updated the autologin information for $network
  }
  ; Remove a nick from auto identification
  .Remove a nick from autologin:{
    remini AutoLoginInformation.ini $network $$?="Enter the nick to delete"
    echo -a Updated the autologin information for $network
  }
  ; Print the current network information
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

; Incercept notices to check for nickserv
on *:NOTICE:*:?:{
  ; If nickserv is noticing us
  if ($nick == NickServ) {
    ; If it's requesting we identify
    if ((This nickname is registered isin $1-) || (Please identify via isin $1-)) {
      ; Check to see if we have a password for the current nick
      if ($readini(AutoLoginInformation.ini,$network,$me)) {
        ; Message nickserv the password
        NickServ IDENTIFY $readini(AutoLoginInformation.ini,$network,$me)
      }
      else { 
        ; We didn't have a password setup, so print that information back to us.
        echo -a $+([,$network,:,$me,]) You're not set to autoidentify with this nickname.
      }
    }
  }
}

raw 433:*nickname is already in use.*:{
  ; We use this to stop from an infinate loop. If we have %Ghosting set when we
  ; try to /nick again then we stop and do nothing.
  if (%Ghosting) {
    unset %Ghosting
    .timerGHOST off
  }
  ; This will prevent us trying to ghost nicks we don't have
  ; a password setup for.
  elseif ($readini(AutoLoginInformation.ini,$network,$2)) {
    set %Ghosting $2
    msg nickserv GHOST $2
    .timerGHOST 1 5 nick $2
  }
}
