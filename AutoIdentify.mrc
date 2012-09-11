/**
* Script Description
** This script will attempt to auto identify you to NickServ.
*
* Configuration Settings
** /LoginDetails [-d [nick]] ( To remove a nick/pass combination, if no nick is given it uses the current nick )
** /LoginDetails -current ( Will prompt you for a password to use with the current nickname. )
** /LoginDetails ( Will print syntax information )
** There is a popup menu in the channel and status windows.
*
* Settings File
** This script stores all settings in AutoIdentify.ini in the mIRC Directory.
** Type: //run $mIRCDir\AutoIdentify.ini to view.
*/


; Begin the alias
alias LoginDetails {
  ; If the first thing is -d, ex: /LoginDetails -d
  if ($1 == -d) {
    ; If there is a second thing
    if ($2) {
      ; Delete the second thing from the current network in AutoIdentify.ini
      remini AutoIdentify.ini $network $2
      ; Display the removed
      echo -a Removed $2 from your autologin nicklist on $network
    }
    else {
      ; Since there was no second thing, delete the currently used nick
      remini AutoIdentify.ini $network $me
      ; Display the removed
      echo -a Removed $me from your autologin nicklist on $network
    }
  }
  ; Added so when you use -d you don't get this part of the script.
  elseif ($1 == -current) {
    ; Setup auto identifying with the current nick
    writeini AutoIdentify.ini $network $me $$?="Enter the password for auto-identifying"
  }

  ; Right click menu
  echo -a To view the information saved for this network use the right click menu.
  echo -a Right click -> NickServ autologin information -> View network information.
}

; Some awesome popup menu for the script
menu channel,status {
  NickServ autologin information
  ; Setup auto identification for a nick
  .Set a nick for autologin:{
    writeini AutoIdentify.ini $network $$?="Enter the nick to identify with" $$?="Enter the password for the nickname"
    echo -a Updated the autologin information for $network
  }
  ; Remove a nick from auto identification
  .Remove a nick from autologin:{
    remini AutoIdentify.ini $network $$?="Enter the nick to delete"
    echo -a Updated the autologin information for $network
  }
  ; Print the current network information
  .View information for this network: {
    var %x 1
    echo -a -
    echo -a Network: $network
    while (%x <= $ini(AutoIdentify.ini,$network,0)) {
      echo -a $ini(AutoIdentify.ini,$network,%x) : $readini(AutoIdentify.ini,$network,$ini(AutoIdentify.ini,$network,%x))
      inc %x
    }
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
      if ($readini(AutoIdentify.ini,$network,$me)) {
        ; Message nickserv the password
        NickServ IDENTIFY $readini(AutoIdentify.ini,$network,$me)
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
  if (%Ghosting. [ $+ [ $network ] ] > 5) {
    .timerGHOST [ $+ [ $network ] ] off
  }
  ; This will prevent us trying to ghost nicks we don't have
  ; a password setup for.
  else {
    if ($readini(AutoIdentify.ini,$network,$2)) {
      inc -u15 %Ghosting. [ $+ [ $network ] ]
      .msg nickserv GHOST $2 $readini(AutoIdentify.ini,$network,$2)
      .timerGHOST [ $+ [ $network ] ] 1 5 /nick $2
    }
    else {
      echo 07 -at You don't have a password setup for the given nickname.
    }
  }
}
