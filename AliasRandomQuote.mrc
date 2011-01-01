; Generates a random quote from either Bash.org or qdb.us, strips the bash.org/qdb.us off the end aswell
alias RandomQuote {
  if ($1 == Bash) { set %Quote BASH }
  elseif ($1 == QDB) { set %Quote QDB }
  else {
    echo -a 4Syntax: /RandomQuote [BASH|QDB] [ECHO|SHOW]
    halt
  }
  if ($2 == echo) { set %show echo -a }
  elseif ($2 == show) { set %show msg $active }
  else { 
    echo -a 4Syntax: /RandomQuote [BASH|QDB] [ECHO|SHOW]
    halt
  }
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
  ; Comment out the line below to hide the START message
  if (START isin %RandQuote) { %show - }
  if (Quote: isin %RandQuote) { 
    if ($right(%RandQuote,10) == [Bash.org]) { %show $left(%RandQuote,-10) }
    elseif ($right(%RandQuote,8) == [QDB.US]) { %show $left(%RandQuote,-8) }
    else { %show %RandQuote }
  }
  ; Comment out the line below to hide the END message
  if (END isin %RandQuote) { %show - }
}
