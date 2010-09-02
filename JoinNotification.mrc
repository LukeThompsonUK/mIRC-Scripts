on *:Voice:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$vnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$vnice,58) } }
on *:Help:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$hnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$hnick,58) } }
on *:OP:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$opnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$opnick,58) } }
on *:Join:#Help:{
  if ($network != SeersIRC) { halt }
  if ($istok(%SeersIRC.Staff,$nick,58)) { halt }
  if ($chan != $active) { echo -ag 4¤ 12User: $+(13,$nick,12) has joined #Help. 4¤ }
  if (!$away) {
    set %join on
    set %jnick $nick
    .whois $nick
    if (*!ssh*@* iswm $address($nick,5)) { echo -g #Help 4[11Nick Info4]12 %jnick could be using SwiftSwitch. }
  }
}
raw 307:*:{ if ((%join == on) && ($5 == registered)) { echo #help 4[11Nick Info4]12 %jnick is identified. } }
raw 319:*:{ if (%join == on) { echo #help 4[11Nick Info4]12 %jnick is on $3- | unset %join | unset %jnick } }