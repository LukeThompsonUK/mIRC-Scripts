; Generates a random quote from either Bash.org or qdb.us, strips the bash.org/qdb.us off the end aswell
on *:TEXT:!RandomQuote:#:{
  if ($2 == Bash) { set %Quote BASH }
  elseif ($2 == QDB) { set %Quote QDB }
  else {
    msg $chan 4Syntax: /RandomQuote [BASH|QDB]
    halt
  }
  set %chan $chan
  if ($sock(RandQuote)) { .sockclose RandQuote }
  sockopen RandQuote www.rscript.org 80
}

on *:SockOpen:RandQuote:{
  if (%Quote == BASH) { sockwrite -nt $sockname GET /lookup.php?type=bash }
  if (%Quote == QDB) { sockwrite -nt $sockname GET /lookup.php?type=qdb }
  sockwrite -nt $sockname Host: www.rscript.org
  sockwrite -nt $sockname $crlf
}
on *:SockRead:RandQuote: {
  sockread %RandQuote
  if (Quote: isin %RandQuote) { 
    if ($right(%RandQuote,10) == [Bash.org]) { msg %chan $left(%RandQuote,-10) }
    elseif ($right(%RandQuote,8) == [QDB.US]) { msg %chan $left(%RandQuote,-8) }
    else { msg %chan %RandQuote }
  }
}
