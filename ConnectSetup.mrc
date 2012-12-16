/**
* Script Description
** This script does the following:
** Autojoins channels on connect
** Sets/removes modes on connect
** Can use a /vhost ( assuming you have one setup )
** Changes to a certain nick
** Auto-opers
*
* Configuration Settings / Commands:
** /ConnectSetup -network=<network> -nick=<Nickname> ( Sets your nick to the specified nick on connect for that network )
** /ConnectSetup -network=<network> -join=<#Channel> ( Adds a channel to your autojoin list )
** /ConnectSetup -network=<network> -part=<#Channel> ( Removes a channel from your autojoin list )
** /ConnectSetup -network=<network> -modes=<+modes/-modes> ( Sets/removes modes on connect )
** /ConnectSetup -network=<network> -vhost=<VhostName> -vhostpass=<VhostPass> ( Adds a vhost for that network (requires a /vhost) )
** /ConnectSetup -network=<network> -OperName=<OperUsername> -OperPass=<OperPassword> ( Adds a oper name for that network )
** /ConnectSetup -network=<network> -status ( Prints stored information about the given network )
*** If you do not give a -network=NETWORK then it uses whatever network you typed the command on
*** Note: Please add/remove channels one at a time.
*** Note: vhost and oper related things have bugs if you use : in either the name or the password
*
* Settings File
** This script stores all settings in AutoLoginInformation.ini in the mIRC Directory.
** Type: //run $mIRCDir\AutoLoginInformation.ini to view.
*/

; This is the main alias.
alias ConnectSetup {
  ; Check to make sure there's a network name, if there isn't then
  ; we use the network that the user was typing on.
  if ($regex(NetworkName,$1-,/-network=(\S+)/Si)) {
    var %Network = $regml(NetworkName,1)
  }
  else {
    var  %Network = $network
  }

  ; Check nickname
  if ($regex(Nickname,$1-,/-nick=(\S+)/Si)) {
    var %Set_Nickname = $regml(Nickname,1)
  }

  ; If we have channels to join
  if ($regex(JoinChannels,$1-,/-join=(#\S+)/Si)) {
    var %J_Channel = $regml(JoinChannels,1)
  }

  ; If we have channels to remove
  if ($regex(RemoveChannels,$1-,/-part=(#\S+)/Si)) {
    var %P_Channel = $regml(RemoveChannels,1)
  }

  ; If we have modes to set or remove
  if ($regex(Modes,$1-,/-modes=(\S+)/Si)) {
    var %Set_Modes $regml(Modes,1)
  }

  ; Check for vhost name
  if ($regex(VhostName,$1-,/-vhostname=(\S+)/Si)) {
    var %VhostName = $regml(VhostName,1)

    ; Since we require a VhostName for there to be a VhostPassword
    ; we do that check inside of this if
    if ($regex(VhostPassword,$1-,/-VhostPassword=(\S+)/Si)) {
      var %VhostPassword = $regml(VhostPassword,1)
    }
  }

  ; Check for OperName
  if ($regex(OperName,$1-,/-OperName=(\S+)/Si)) {
    var %OperName = $regml(OperName,1)

    ; Since we require an OperName for there to be an OperPassword
    ; we do that check inside of this if
    if ($regex(OperPassword,$1-,/-OperPassword=(\S+)/Si)) {
      var %OperPassword = $regml(OperPassword,1)
    }
  }

  ; Check for status
  if ($regex(Status,$1-,/-Status/Si)) {
    var %Do_Status = TRUE
  }

  ; Now that we've parsed all the input we can get to editing the files.
  ; If we want to change the default nick
  if (%Set_Nickname) {
    writeini AutoLoginInformation.ini %Network &Nick %Set_Nickname
    echo -a [ConnectSetup] $+([,%Network,]) Nick set to: %Set_Nickname
  }

  ; If there is a channel to add
  if (%J_Channel) {
    writeini AutoLoginInformation.ini %Network &Channels $addtok($readini(AutoLoginInformation.ini,%Network,&Channels),%J_Channel,44)
    echo -a [ConnectSetup] $+([,%Network,]) $readini(AutoLoginInformation.ini,%Network,&Channels)
  }

  ; If there is a channel to remove
  if (%P_Channel) {
    var %Tok $findtok($readini(AutoLoginInformation.ini,%Network,&Channels),%P_Channel,1,44)

    writeini AutoLoginInformation.ini %Network &Channels $deltok($readini(AutoLoginInformation.ini,%Network,&Channels),%Tok,44)
    echo -a [ConnectSetup] $+([,%Network,]) $readini(AutoLoginInformation.ini,%Network,&Channels)
  }

  ; If we want to set or remove modes
  if (%Set_Modes) {
    writeini AutoLoginInformation.ini %Network &Modes %Set_Modes
    echo -a [ConnectSetup] $+([,%Network,]) Modes on connect set to: %Set_Modes
  }

  ; If we want to set a vhost
  ; The reason why we check for a pass instead of a user is because we do the check for a password
  ; inside the check for a user, so if there's a password then there HAS to be a user
  ; This eliminates one check we have to do here. (For the user)
  if (%VhostPassword) {
    writeini AutoLoginInformation.ini %Network &Vhost $+(%VhostName,:,%VhostPassword)
    echo -a [ConnectSetup] $+([,%Network,]) Vhost set to: %VhostName - password: %VhostPassword
  }

  ; Oper
  ; Same reason why we check for pass as above
  if (%OperPassword) {
    writeini AutoLoginInformation.ini %Network &Oper $+(%OperName,:,%OperPassword)
    echo -a [ConnectSetup] $+([,%Network,]) Oper set to: %OperName - password: %OperPassword
  }

  ; Print the whole status report?
  if (%Do_Status) {
    echo 10 -a -
    echo 10 -a [ConnectSetup] Printing information for: $+(07,%Network)

    if (!$ini(AutoLoginInformation.ini,%Network,0)) {
      echo 10 -a [ConnectSetup] 10No information found.
    }
    else {
      var %ToCheck $ini(AutoLoginInformation.ini,%Network,0)
    }

    while (%ToCheck > 0) {
      echo 10 -a [ConnectSetup] $+(10,$ini(AutoLoginInformation.ini,%Network,%ToCheck),:07) $readini(AutoLoginInformation.ini,%Network,$ini(AutoLoginInformation.ini,%Network,%ToCheck))

      dec %ToCheck
    }

    echo 10 -a -
  }
}

; We use this to trigger the beginning of the script.
raw 001:*:{
  set %Connect.raw on
}

raw 005:*:{
  ; If that's on then we do the script, if we didn't have this it would trigger when doing
  ; /version, and that's just annoying.
  if (%Connect.Raw) {

    ; Check for the network name
    if ($regex(Raw005Name,$1-,NETWORK=(\S+)) == 1) {
      if ($ini(AutoLoginInformation.ini,$regml(Raw005Name,1))) {
        if ($ini(AutoLoginInformation.ini,$network,&Oper)) {
          oper $replace($readini(AutoLoginInformation.ini,$network,&Oper),$chr(58),$chr(32))
        }

        if ($ini(AutoLoginInformation.ini,$network,&Nick)) {
          nick $readini(AutoLoginInformation.ini,$network,&Nick)
        }

        ; Fixed this so we nolonger need the alias.
        if ($ini(AutoLoginInformation.ini,$network,&Modes)) {
          .timerSETMODE [ $+ [ $network ] ] 1 15 mode $!me $readini(AutoLoginInformation.ini,$network,&Modes)
        }

        if ($ini(AutoLoginInformation.ini,$network,&Vhost)) {
          vhost $replace($readini(AutoLoginInformation.ini,$network,&Vhost),$chr(58),$chr(32))
        }

        if ($ini(AutoLoginInformation.ini,$network,&Channels)) {
          ; We're going to loop for all the channels and only use join -n on
          ; channels we're not in. This prevents random minimization when we are
          ; disconnected from the network for whatever reason.
          var %x 1
          tokenize 44 $readini(AutoLoginInformation.ini,$network,&Channels)
          while (%x <= $0) {

            ; This checks to see if we already have the window open or not.
            ; How the brackets are evaluated:
            ; [ $ [ $+ [ %x ] ] ]
            ; [ $ [ $+ 1 ] ]
            ; [ $1 ]
            ; #Window
            if (!$window([ $ [ $+ [ %x ] ] ])) {
              if (!%JoinN) {
                var %JoinN [ $ [ $+ [ %x ] ] ]
              }
              else {
                var %JoinN %JoinN $+ , $+ [ $ [ $+ [ %x ] ] ]
              }
            }
            else {
              if (!%Join) {
                var %Join [ $ [ $+ [ %x ] ] ]
              }
              else {
                var %Join %Join $+ , $+ [ $ [ $+ [ %x ] ] ]
              }
            }
            inc %x
          }

          ; If we have channels we need to use join -n for
          if (%JoinN) {
            .timerJOINCHANNELSN [ $+ [ $network ] ] 1 15 join -n %JoinN
          }

          ; If we have channels we need a regular join for
          if (%Join) {
            .timerJOINCHANNELS [ $+ [ $network ] ] 1 15 join %Join
          }
        }

        ; If we have the AutoIdentify script loaded, let's try to auth with our nick
        if ($script(AutoIdentify.mrc) != NULL) {
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

      unset %Connect.Raw
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
