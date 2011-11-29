; This script will autologin to an IdleRPG game on any network you have it set for.
; Syntax for the script is:
; /IRPG -botnick nickforthebothere
; /IRPG -Username nickforyouridlerpglogin
; /IRPG -Password youridlerpgpasswordhere
; If you use IRPG and your command doesn't match any of the methods above
; you will be given syntax for the command.

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


; Intercepts idlerpg notices and sends them to @IdleRPG
on ^*:NOTICE:*:?:{
  ; Checks to see if the incoming notice is from the idlerpg botnick.
  if ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; Creates @IdleRPG if we do not have one already.
    if (!$window(@IdleRPG)) { window -nz @IdleRPG }

    ; Writes to @IdleRPG
    aline -p @IdleRPG $timestamp $+([,$network,]) $nick -> $1-
  }

  ; Halts the notice from showing to us.
  haltdef
}


; We use this alias to check if the idle bot is an op. We can't do this on join for some reason.
; This perevents users from stealing passwords and messaging the idle bot when it's not on the channel.
alias -l DoLogin {
  ; This will increment by 1 every time the alias is called.
  ; It will automatically be unset after 15 seconds.
  inc -u15 %IdleLoginCheck [ $+ [ $network ] ]
  if (%IdleLoginCheck [ $+ [ $network ] ] <= 6) {
    if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName) isop $1) {
      msg $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) LOGIN $readini(IdleRPGAutoLoginDetails.ini,$network,Username) $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
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
  if ($regex($1-2,/-botnick\s\S+$/Si)) {
    writeini IdleRPGAutoLoginDetails.ini $network Botname $2
  }
  elseif ($regex($1-2,/-Username\s\S+$/Si)) {
    writeini IdleRPGAutoLoginDetails.ini $network Username $2
  }
  elseif ($regex($1-2,/-Password\s\S+$/Si)) {
    writeini IdleRPGAutoLoginDetails.ini $network Password $2
  }
  else {
    echo 07 -a [IdleRPG] Syntax for the script is:
    echo 07 -a [IdleRPG] /IRPG -botnick nickforthebothere
    echo 07 -a [IdleRPG] /IRPG -Username nickforyouridlerpglogin
    echo 07 -a [IdleRPG] /IRPG -Password youridlerpgpasswordhere
    var %x 1
  }

  if (!%x) {
    IRPG.show
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
    writeini IdleRPGAutoLoginDetails.ini $network Botname $$?="Enter the bot name to message on this network."
    echo -a Botname for $network changed to: $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)
  }

  ..Set username:{
    writeini IdleRPGAutoLoginDetails.ini $network Username $$?="Enter the username to message on this network."
    echo -a Username for $network changed to: $readini(IdleRPGAutoLoginDetails.ini,$network,Username)
  }

  ..Set password:{
    writeini IdleRPGAutoLoginDetails.ini $network Password $$?="Enter the password to message on this network."
    echo -a Password for $network changed to: $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
  }
}


; Using this to prevent writing out the echos multiple times.
alias -l IRPG.show {
  echo -a -
  echo -a Network: $network
  echo -a BotName: $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)
  echo -a Username: $readini(IdleRPGAutoLoginDetails.ini,$network,Username)
  echo -a Password: $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
  echo -a -
}
