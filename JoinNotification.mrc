; The on voice/help/op is to mark the user as staff so that you never check that user on join again
on *:Voice:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$vnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$vnice,58) } }
on *:Help:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$hnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$hnick,58) } }
on *:OP:#Help:{ if (($network == SeersIRC) && (!$istok(%SeersIRC.Staff,$opnick,58))) { set %SeersIRC.Staff $addtok(%SeersIRC.Staff,$opnick,58) } }
; This will happen each time someone joins #Help
on *:Join:#Help:{
  ; If it's not on SeersIRC, we don't give a fuck.
  if ($network != SeersIRC) { halt }
  ; If their part of the network staff, we don't need to call the rest of the script.
  if ($istok(%SeersIRC.Staff,$nick,58)) { halt }
  ; If #Help is already the active window, no need to spam us saying someone joined.
  if ($chan != $active) { echo -ag 4¤ 12User: $+(13,$nick,12) has joined #Help. 4¤ }
  ; If we're away we don't need to call this crap because we're not here to help.
  if (!$away) {
    set %join on
    set %jnick $nick
    .whois $nick
	; Chances are this is a swiftsiwtch user. Treat them as a child.
    if (*!ssh*@* iswm $address($nick,5)) { echo -g #Help 4[11Nick Info4]12 %jnick could be using SwiftSwitch. }
  }
}
; I believe that Veridian does this now so this probably isn't needed anymore.
raw 307:*:{ if ((%join == on) && ($5 == registered)) { echo #help 4[11Nick Info4]12 %jnick is identified. } }
raw 319:*:{ if (%join == on) { echo #help 4[11Nick Info4]12 %jnick is on $3- | unset %join | unset %jnick } }