; If the channel you play IdleRPG in isn't listed here make sure it gets added or the script wont work.
on *:Join:#Idle-RPG,#IdleRPG,#IRPG:{ 
  if ($nick == $me) {
    if ($+(%,[INFO]IdleRPG.,$network,.BotName)) {
      msg $($+(%,[INFO]IdleRPG.,$network,.BotName),2) LOGIN $($+(%,[INFO]IdleRPG.,$network,.UserID),2) $($+(%,[INFO]IdleRPG.,$network,.Password),2)
    }
  }
}
alias IRPG {
  set $+(%,[INFO]IdleRPG.,$network,.BotName) $?="Enter the bot name to message on this network."
  set $+(%,[INFO]IdleRPG.,$network,.UserID) $?="Enter the username to autoidentify with."
  set $+(%,[INFO]IdleRPG.,$network,.Password) $?="Enter the password to autoidentify with."
  echo -a -
  echo -a Network: $network
  echo -a BotName: $($+(%,[INFO]IdleRPG.,$network,.BotName),2)
  echo -a Username: $($+(%,[INFO]IdleRPG.,$network,.UserID),2)
  echo -a Password: $($+(%,[INFO]IdleRPG.,$network,.Password),2)
  echo -a -
}
menu channel {
  IdleRPG
  .View current information for this network: {
    echo -a -
    echo -a Network: $network
    echo -a BotName: $($+(%,[INFO]IdleRPG.,$network,.BotName),2)
    echo -a Username: $($+(%,[INFO]IdleRPG.,$network,.UserID),2)
    echo -a Password: $($+(%,[INFO]IdleRPG.,$network,.Password),2)
    echo -a -
  }
  .Autologin information
  ..Set botname: set $+(%,[INFO]IdleRPG.,$network,.BotName) $?="Enter the bot name to message on this network."
  ..Set username: set $+(%,[INFO]IdleRPG.,$network,.UserID) $?="Enter the username to autoidentify with."
  ..Set password: set $+(%,[INFO]IdleRPG.,$network,.Password) $?="Enter the password to autoidentify with."
}
