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

; This alias will work outside of the script also, so you can use /ghost namehere to ghost somebody.
alias Ghost { 
  ; if -switch is the first thing
  if (-switch == $1) {
    var %GhostNick $2
    var %Switch on

    ; If there is a third thing
    if ($3) {
      var %Password $3
    }
    else {
      ; If there isn't, check to see if we have a password for the ghostnick
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
    ; Ghost the ghosted nick
    NickServ ghost %GhostNick %Password

    if (%Switch) {
      ; If -switch was used, switch to the nick
      .timer 1 2 nick %GhostNick
    }
  }
  else {
    ; Print the syntax.
    echo -a -
    echo -a 10Syntax:
    echo -a 10/Ghost [-switch] <nick> [password]
    echo -a 10Password is optional if you have the nick setup for auto identfying.
    echo -a 10If -switch is used you will /nick to the nick after ghosting.
    echo -a -
  }
}

raw 433:*nickname is already in use.*:{ ghost -switch $2 }
