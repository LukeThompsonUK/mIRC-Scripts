alias autojoin { 
  if (($1 == -d) && ($2)) {
    var %Tok $findtok($($+(%,$network,.autojoin),2),$2,1,44)
    set $+(%,$network,.autojoin) $deltok($($+(%,$network,.autojoin),2),%Tok,44)
    echo -a $+([,$network,]) $($+(%,$network,.autojoin),2)
  }
  else {
    set $+(%,$network,.autojoin) $addtok($($+(%,$network,.autojoin),2),$chan,44)
    echo -a $+([,$network,]) $($+(%,$network,.autojoin),2)
  }
}
on *:Connect:{
  if ($($+(%,$network,.autojoin),2)) { join $($+(%,$network,.autojoin),2) }
  else { echo -a You don't have an autojoin setup for this network }
}