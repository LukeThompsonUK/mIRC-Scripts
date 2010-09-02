alias Setpass { set $+(%,$network,.,$me,.password) $1 | echo -a Password for $me on $network set to $1 }
on *:Notice:*This nickname is registered and protected.*:?:{
  if (!$($+(%,$network,.,$me,.password),2)) { echo -a 11NickServ noticed you to identify, but you don't seem to have a saved password for this server. | Halt }
  else { ns id $($+(%,$network,.,$me,.password),2) }
}