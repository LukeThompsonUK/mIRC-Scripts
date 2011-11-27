; This script will autologin to an IdleRPG game on any network you have it set for.
; Syntax for the script is:
; /IRPG -botnick nickforthebothere
; /IRPG -Username nickforyouridlerpglogin
; /IRPG -Password youridlerpgpasswordhere
; If you use IRPG and your command doesn't match any of the methods above
; you will be prompted to set all 3.

; If the channel you play IdleRPG in isn't listed here make sure it gets added or the script wont work.
on *:Join:#Idle-RPG,#IdleRPG,#IRPG,#Idle:{ 
  ; This simply checks if there is a bot name, if there isn't we haven't got it setup for this network
  if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; If the nick joining is you, or the name of the idlerpg bot
    if (($nick == $me) || ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName))) {
      .timer [ $+ [ $network ] ] 1 5 //DoLogin $chan
    }
  }
}


; We use this alias to check if the idle bot is an op. We can't do this on join for some reason.
; This perevents users from stealing passwords and messaging the idle bot when it's not on the channel.
alias -l DoLogin {
  if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName) isop $1) {
    msg $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) LOGIN $readini(IdleRPGAutoLoginDetails.ini,$network,Username) $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
  }
  else {
    echo 07 $1 [IdleRPG] The bot doesn't appear to be an op in the idle channel
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
    writeini IdleRPGAutoLoginDetails.ini $network Botname $$?="Enter the bot name to message on this network."
    writeini IdleRPGAutoLoginDetails.ini $network Username $$?="Enter the username to autoidentify with."
    writeini IdleRPGAutoLoginDetails.ini $network Password $$?="Enter the password to autoidentify with."
  }

  echo -a -
  echo -a Network: $network
  echo -a BotName: $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)
  echo -a Username: $readini(IdleRPGAutoLoginDetails.ini,$network,Username)
  echo -a Password: $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
  echo -a -
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
    echo -a -
    echo -a Network: $network
    echo -a BotName: $readini(IdleRPGAutoLoginDetails.ini,$network,BotName)
    echo -a Username: $readini(IdleRPGAutoLoginDetails.ini,$network,Username)
    echo -a Password: $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
    echo -a -
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
