/**
* Script Description
** Autologin for an IdleRPG game on any network you have it set for.
** Outputs notices and text from the botnick concerning your IdleRPG account to
** an @Window.
*
* Configuration Settings / Commands:
** /IRPG -botnick=BotNickHere -username=YourUsernameHere -password=YourPasswordHere
** If you use /IRPG and your syntax doesn't match any of the above you will be given the syntax
*
* Settings File
** This script stores all settings in IdleRPGAutoLoginDetails.ini in the mIRC Directory.
** Type: //run $mIRCDir\IdleRPGAutoLoginDetails.ini to view.
*
* Note:
** This script is only designed for the IdleRPG bot from http://idlerpg.net/
** With any other IdleRPG bot it may or may not work, depending on the syntax the bot uses for things.
** If you wish to submit a patch to make it work with other bots, please do.
*/

; If the channel you play IdleRPG in isn't listed here make sure it gets added or the script wont work.
on *:Join:#Idle-RPG,#IdleRPG,#IRPG,#Idle:{ 
  ; This simply checks if there is a bot name, if there isn't we haven't got it setup for this network
  if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; If the nick joining is you, or the name of the idlerpg bot
    if (($nick == $me) || ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName))) {
      .timerIdleRPGLogin [ $+ [ $network ] ] 1 5 //DoLogin $chan
    }
  }
}


; Copies text from the IdleRPG botnick that has our username somewhere in the text.
; Outputs copied text to @IdleRPG
on *:TEXT:*:#:{
  ; Checks to see if the text is from the botnick.
  if ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; Checks to see if our username was said somewhere in the text.
    if ($matchtok($1-,$readini(IdleRPGAutoLoginDetails.ini,$network,Username),0,32)) {
      ; Creates @IdleRPG if we do not have one already.
      if (!$window(@IdleRPG)) { window -nz @IdleRPG }

      ; Writes to @IdleRPG
      aline -p @IdleRPG $timestamp $+([,$network,]) $+([,$nick,/channel]) -> $1-
    }
  }
}


; Intercepts idlerpg notices and sends them to @IdleRPG
on ^*:NOTICE:*:?:{
  ; Checks to see if the incoming notice is from the idlerpg botnick.
  if ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; Creates @IdleRPG if we do not have one already.
    if (!$window(@IdleRPG)) { window -nz @IdleRPG }

    ; Writes to @IdleRPG
    aline -p @IdleRPG $timestamp $+([,$network,]) $+([,$nick,/notice]) -> $1-

    ; Halts the notice from showing to us.
    haltdef
  }
}


; We use this alias to check if the idle bot is an op. We can't do this on join for some reason.
; This perevents users from stealing passwords and messaging the idle bot when it's not on the channel.
alias -l DoLogin {
  ; This will increment by 1 every time the alias is called.
  ; It will automatically be unset after 15 seconds.
  inc -u15 %IdleLoginCheck [ $+ [ $network ] ]
  if (%IdleLoginCheck [ $+ [ $network ] ] <= 6) {
    if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName) isop $1) {
      .msg $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) LOGIN $readini(IdleRPGAutoLoginDetails.ini,$network,Username) $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
    }
    ; If the login doesn't work, try again in 5 seconds. The user might have not had time to op.
    ; It will try 6 times, totaling roughly 30 seconds after the bot joins. If the bot isn't opped by then
    ; it gives up.
    else {
      echo 07 $1 [IdleRPG] The bot doesn't appear to be an op in the idle channel. Trying login again in 5 seconds.
      .timerIdleRPGLogin [ $+ [ $network ] ] 1 5 //DoLogin $1
    }
  }
  ; This else is called when we've tried to login 6+ times on any given network.
  else {
    echo 07 $1 [IdleRPG] Could not login. $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) was not an op on the channel
  }
}


; This alias is used to set your botname, username and password.
alias IRPG {

  if (!$1) {
    echo -a [IdleRPG] Usage:
    echo -a [IdleRPG] /IRPG -botnick=BotNickHere -username=YourUsernameHere -password=YourPasswordHere
    echo -a [IdleRPG] You may specify these arguments in any order.
    echo -a [IdleRPG] /IRPG -details ( Prints information for the network it is typed on. )

    return
  }

  ; Details?
  if ($regex(IRPG_FullDetails,$1,/^-details$/Si)) { var %Details = $network }

  ; If we want to change the botnick.
  if ($regex(IRPG_BotNick,$1-,/-botnick=(\S+)/Si)) { var %Botnick = $regml(IRPG_BotNick,1) }

  ; If we want to change the username.
  if ($regex(IRPG_Nick,$1-,/-username=(\S+)/Si)) { var %Nickname = $regml(IRPG_Nick,1) }

  ; If we want to change the users pass.
  if ($regex(IRPG_Pass,$1-,/-pass=(\S+)/Si)) { var %Password = $regml(IRPG_Pass,1) }

  if (%Details) {
    echo -a -
    echo -a Network: $network
    echo -a BotName: $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)
    echo -a Username: $readini(IdleRPGAutoLoginDetails.ini,$network,Username)
    echo -a Password: $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
    echo -a -

    return
  }

  if (%Botnick) {
    writeini IdleRPGAutoLoginDetails.ini $network BotName %Botnick
    echo -a Botnick changed to: %Botnick
  }

  if (%Nickname) {
    writeini IdleRPGAutoLoginDetails.ini $network Username %Nickname
    echo -a Username changed to: %Nickname
  }

  if (%Password) {
    writeini IdleRPGAutoLoginDetails.ini $network Password %Password
    echo -a Password changed to: %Password
  }
}


; If the bot notices back there isn't an account by that name, register one.
on *:Notice:*No such account*:?:{
  if ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    msg $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) REGISTER $readini(IdleRPGAutoLoginDetails.ini,$network,Username) $readini(IdleRPGAutoLoginDetails.ini,$network,Password) IdleUser
  }
}


; This is a popup menu to display information about your idlerpg.
menu channel,status {
  IdleRPG
  .View current information for this network: {
    IRPG.show
  }

  .Autologin information
  ..Set botname:{
    var %Botnick $$?="Enter the bot name to message on this network."
    IRPG $+(-botnick=,%Botnick)
  }

  ..Set username:{
    var %Username $$?="Enter the username to message on this network."
    IRPG $+(-username=,%Username)
  }

  ..Set password:{
    var %Password $$?="Enter the password to message on this network."
    IRPG $+(-password=,%Password)
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
