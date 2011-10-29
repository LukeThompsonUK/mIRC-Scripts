; Due to the way the WHO is sent this will only work on unrealircd, I plan on updating it for other ircds in the future.

on *:Join:#:{ 
  if ($me == $nick) { 
    .enable #BotCheck | set %ChanCheck $chan | who +cm $chan B 
  } 
}


#BotCheck off

raw 352:*B*:{
  if ($2 == $me) { halt }
  if (B isincs $7) { inc %Bots }
}

raw 315:*End of /WHO list.:{ 
  echo -a [BotCount] - %Bots counted
  .disable BotCheck 
}

#BotCheck end
