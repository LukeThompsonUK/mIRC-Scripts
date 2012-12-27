/**
* Script Description
** This script will attempt to auto identify you to NickServ.
*
* Configuration Settings
** /AutoIdentify -nick=NickHere ( Will display the password for the given nick. )
** /AutoIdentify -nick=NickHere -pass=PassHere ( Will set the password for the given nick to the specified one. )
** /AutoIdentify -delete -nick=NickHere ( Will delete the given nickname. )
** /AutoIdentify -listnicks=NetworkHere ( Will list all the nick/pass combinations for the given network. )
** /AutoIdentify ( will print syntax information for the script. )
*
* Settings File
** This script stores all settings in AutoIdentify.ini in the mIRC Directory.
** Type: //run $mIRCDir\AutoIdentify.ini to view.
*/


; AutoIdentify alias
alias AutoIdentify {
  ; List info?
  if ($regex(ListInfo,$1-,/^-listnicks=(\S+)$/Si)) { var %ListNicks $regml(ListInfo,1) }

  ; Delete?
  if ($regex(Delete,$1,/^-d(?:elete)?/Si)) { var %Delete = YES }

  ; Set the nick variable
  if ($regex(Nick,$1-,/-nick=(\S+)/Si)) { var %Nick = $regml(Nick,1) }

  ; Set the pass variable
  if ($regex(Pass,$1-,/-pass=(\S+)/Si)) { var %Pass = $regml(Pass,1) }

  ; If we want to list the information for a network
  if (%ListNicks) {
    var %x = 1
    echo -a -
    echo -a Network: $network
    while (%x <= $ini(AutoIdentify.ini,$network,0)) {
      echo -a Nick: $ini(AutoIdentify.ini,$network,%x) : Pass: $readini(AutoIdentify.ini,n,$network,$ini(AutoIdentify.ini,$network,%x))
      inc %x
    }
    echo -a -

    return
  }

  ; If we want to delete something
  if (%Delete) {
    ; If a nick is given we delete that nick.
    if (%Nick) {
      remini AutoIdentify.ini $network %Nick
      echo -a Removed %Nick from your autologin nicklist on $network

      return
    }

    ; If no nick is given we do nothing.
    echo -a No nick was given to remove.

    return
  }

  ; If a nick is given.
  if (%Nick) {
    ; If there is a pass given, set the password for the given nick to it.
    if (%Pass) {
      writeini AutoIdentify.ini $network %Nick %Pass
    }

    if ($readini(AutoIdentify.ini,n,$network,%Nick)) {
      echo -a The password for %Nick is: $readini(AutoIdentify.ini,n,$network,%Nick)
      return
    }
    else {
      echo -a The given nick $+($chr(40),%Nick,$chr(41)) does not have a stored password.
      return
    }
  }

  echo -a Syntax information:
  echo -a /AutoIdentify -nick=NickHere ( Will display the password for the given nick. )
  echo -a /AutoIdentify -nick=NickHere -pass=PassHere ( Will set the password for the given nick to the specified one. )
  echo -a /AutoIdentify -delete -nick=NickHere ( Will delete the given nickname. )
  echo -a /AutoIdentify -listnicks=NetworkHere ( Will list all the nick/pass combinations for the given network. )
  echo -a /AutoIdentify ( will print this information. )
}

; Popup menu for the script
menu channel,status {
  NickServ autologin information
  ; Setup auto identification for a nick
  .Set a nick for autologin:{
    var %Nick = $$?="Enter the nick to identify with (Or leave blank to do nothing.)"
    var %Pass = $$?="Enter the password for that nick (Or leave blank to do nothing.)"
    AutoIdentify $+(-nick=,%Nick) $+(-pass=,%Pass)
  }

  ; Remove a nick from auto identification
  .Remove a nick from autologin:{
    var %Nick = $$?="Enter the nick to delete. (Or leave blank to do nothing.)
    AutoIdentify -delete $+(-nick=,%Nick)
  }

  ; Print the current network information
  .View information for this network: {
    AutoIdentify $+(-ListNicks=,$network)
  }
}

; Incercept notices to check for nickserv
on *:NOTICE:*:?:{
  ; If nickserv is noticing us
  if ($nick == NickServ) {
    ; If it's requesting we identify
    if ((This nickname is registered isin $1-) || (Please identify via isin $1-)) {
      ; Check to see if we have a password for the current nick
      if ($readini(AutoIdentify.ini,n,$network,$me)) {
        ; Message nickserv the password
        NickServ IDENTIFY $readini(AutoIdentify.ini,n,$network,$me)
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
    if ($readini(AutoIdentify.ini,n,$network,$2)) {
      inc -u15 %Ghosting. [ $+ [ $network ] ]
      .msg nickserv GHOST $2 $readini(AutoIdentify.ini,n,$network,$2)
      .timerGHOST [ $+ [ $network ] ] 1 5 /nick $2
    }
    else {
      echo 07 -at You don't have a password setup for the given nickname.
    }
  }
}


; Accidently unloaded a script and it took me a good 10 minutes to figure out
; which one was unloaded, Adding this to all the scripts to prevent this problem
; happening again in the future.
on *:UNLOAD:{
  if (!$window(@Script_Log)) {
    window -nz @Script_Log
  }
  aline -ph @Script_Log Unloading: $script
}
