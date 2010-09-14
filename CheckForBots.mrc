/*
Due to the way the WHO is sent this will only work on unrealircd, I plan on updating it for other ircds in the future.
*/
on *:Join:#:{ if ($me == $nick) { .enable #BotCheck | set %ChanCheck $chan | who +cm $chan B } }
#BotCheck off
raw 352:*B*:{
  if ($2 == $me) { halt }
  if (B isincs $7) { inc %Bots }
  if (%Bots = 2) { part %ChanCheck Sorry, I have found 2 people marked with usermode B in this channel. If they are not bots have them remove the bot usermode and invite me again. }
}
raw 315:*End of /WHO list.:{ .disable BotCheck }
#BotCheck end