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
** /ConnectSetup -join #Channel ( Adds a channel to your autojoin list )
** /ConnectSetup -del #Channel ( Removes a channel from your autojoin list )
** /ConnectSetup -setmodes +modes/-modes ( Sets/removes modes on connect )
** /ConnectSetup -vhost VhostName VhostPass ( Adds a vhost for that network (requires a /vhost) )
** /ConnectSetup -nick Nickhere ( Sets your nick to the specified nick on connect for that network )
** /ConnectSetup -Oper OperUser OperPass ( Adds a oper name for that network )
** /ConnectSetup -status NetworkHere ( Prints stored information about the given network )
*
* Settings File
** This script stores all settings in AutoLoginInformation.ini in the mIRC Directory.
** Type: //run $mIRCDir\AutoLoginInformation.ini to view.
*/

; This is the main alias.
alias ConnectSetup { 
  ; This checks which command they want to use.
  ; If they don't use any of these it'll print the syntax.
  if (($1 == -join) && ($regex(ConnectSetup,$2,/^#\S+$/))) {
    writeini AutoLoginInformation.ini $network &Channels $addtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,44)
    echo -a [ConnectSetup] $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  elseif (($1 == -del) && ($regex(ConnectSetup,$2,/^#\S+$/))) {
    var %Tok $findtok($readini(AutoLoginInformation.ini,$network,&Channels),$2,1,44)

    writeini AutoLoginInformation.ini $network &Channels $deltok($readini(AutoLoginInformation.ini,$network,&Channels),%Tok,44)
    echo -a [ConnectSetup] $+([,$network,]) $readini(AutoLoginInformation.ini,$network,&Channels)
  }
  elseif (($1 == -setmodes) && ($2)) {
    writeini AutoLoginInformation.ini $network &Modes $2
    echo -a [ConnectSetup] $+([,$network,]) Modes on connect set to: $2
  }
  elseif (($1 == -vhost) && ($3)) {
    writeini AutoLoginInformation.ini $network &Vhost $+($2,:,$3)
    echo -a [ConnectSetup] $+([,$network,]) Vhost set to: $2 - password: $3
  }
  elseif (($1 == -nick) && ($2)) {
    writeini AutoLoginInformation.ini $network &Nick $2
    echo -a [ConnectSetup] $+([,$network,]) Nick set to: $2
  }
  elseif (($1 == -oper) && ($3)) {
    writeini AutoLoginInformation.ini $network &Oper $+($2,:,$3)
    echo -a [ConnectSetup] $+([,$network,]) Oper set to: $2 - password: $3
  }
  elseif (($1 == -status) && ($2)) {
    echo 10 -a [ConnectSetup] -
    echo 10 -a [ConnectSetup] Printing information for: $+(07,$2)

    if (!$ini(AutoLoginInformation.ini,$2,0)) {
      echo 10 -a [ConnectSetup] 10No information found.
    }
    else {
      var %ToCheck $ini(AutoLoginInformation.ini,$2,0)
    }

    while (%ToCheck > 0) {
      echo 10 -a [ConnectSetup] $+(10,$ini(AutoLoginInformation.ini,$2,%ToCheck),:07) $readini(AutoLoginInformation.ini,$2,$ini(AutoLoginInformation.ini,$2,%ToCheck))

      dec %ToCheck
    }

    echo 10 -a -
  }
  else {
    echo 10 -a -
    echo 10 -a [ConnectSetup] Syntax:
    echo 10 -a [ConnectSetup] /ConnectSetup -join #Channel [Adds a channel to your autojoin list]
    echo 10 -a [ConnectSetup] /ConnectSetup -del #Channel [Removes a channel from your autojoin list]
    echo 10 -a [ConnectSetup] /ConnectSetup -setmodes +modes/-modes [Sets/removes modes on connect]
    echo 10 -a [ConnectSetup] /ConnectSetup -vhost VhostName VhostPass [Adds a vhost for that network (requires a /vhost)]
    echo 10 -a [ConnectSetup] /ConnectSetup -nick Nickhere [Sets your nick to the specified nick on connect for that network]
    echo 10 -a [ConnectSetup] /ConnectSetup -oper Opername OperPass [Sets your oper name for that network]
    echo 10 -a [ConnectSetup] /ConnectSetup -status NetworkHere [Prints status for the given network]
    echo 10 -a -
  }
}

raw 001:*:{
  set %Connect.raw on
}

raw 005:*:{
  if (%Connect.Raw) {
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
            if (!$window([ $ [ $+ [ %x ] ] ])) {
              var %JoinN %JoinN [ $ [ $+ [ %x ] ] ]
            }
            else {
              var %Join %Join [ $ [ $+ [ %x ] ] ]
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
          ;  .timerJOINCHANNELS [ $+ [ $network ] ] 1 15 join $readini(AutoLoginInformation.ini,$network,&Channels)
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
