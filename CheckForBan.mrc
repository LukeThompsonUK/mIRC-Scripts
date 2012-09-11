;Alias to check bans on the banlist
;Format: /chkban Name!Ident@Host

alias Chkban { 
  if (!$1) { 
    echo -a Use this format. /chkban Nameofuser!Ident@Host | halt 
  }

  set %Ban.Scanning on
  set %Host $1
  mode $chan b
}

;Raw used to check the banlist from /chkban
raw 367:*:{
  if (%Ban.Scanning) {
    if ($3 iswm %Host) { 
      set %ban %ban $3 
    }

    if (($left($3,3) == ~n:) || ($left($3,3) == ~q:) && ($right($3,-3) iswm %host)) { 
      set %ban %ban $3 
    }

    if ($left($3,3) == ~c:) { 
      set %cban %cban $3 
    }
  }
}

;ending numeric from the /chkban where we display the bans + unset vars
raw 368:*:{ 
  if (%ban) { 
    echo -a 4¤ All of these bans effect the mask you specified:
    echo -a 4¤ $+(12,%ban)
  }
  else { 
    if (%Ban.Scanning) { echo -a 4¤ 12No host bans found. }
  }

  if (%cban) {
    echo -a 4¤ There are also some channel bans on the channel, ask the user if they are in any of the following:
    echo -a 4¤ $+(12,%cban)
  }

  unset %ban
  unset %cban
  unset %Ban.Scanning 
  unset %Host 
}
