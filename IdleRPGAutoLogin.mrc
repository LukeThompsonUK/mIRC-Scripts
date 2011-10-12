; If the channel you play IdleRPG in isn't listed here make sure it gets added or the script wont work.
on *:Join:#Idle-RPG,#IdleRPG,#IRPG,#Idle:{ 
  ; This simply checks if there is a bot name, if there isn't we haven't got it setup for this network
  if ($readini(IdleRPGAutoLoginDetails.ini,$network,BotName)) {
    ; If the nick joining is you, or the name of the idlerpg bot
    if (($nick == $me) || ($nick == $readini(IdleRPGAutoLoginDetails.ini,$network,BotName))) {
      msg $readini(IdleRPGAutoLoginDetails.ini,$network,BotName) LOGIN $readini(IdleRPGAutoLoginDetails.ini,$network,Username) $readini(IdleRPGAutoLoginDetails.ini,$network,Password)
    }
  }
}


alias IRPG {
  writeini IdleRPGAutoLoginDetails.ini $network Botname $$?="Enter the bot name to message on this network."
  writeini IdleRPGAutoLoginDetails.ini $network Username $$?="Enter the username to autoidentify with."
  writeini IdleRPGAutoLoginDetails.ini $network Password $$?="Enter the password to autoidentify with."

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
