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
  ; Chances are this is a swiftsiwtch user. Treat them as a child.
  if (*!ssh*@* iswm $address($nick,5)) { echo -g #Help 4[11Nick Info4]12 $nick could be using SwiftSwitch. }
  set %HelpJoin on
}
on *:NOTICE:*:#Help:{
  ; If the nick is Veridian
  if (($nick == Veridian) && (%HelpJoin)) { 
    if ($3 == not) { var %I no }
    else { var %I Yes }
    if (($6 == not) || ($7 == not)) { var %Channels None }
    else { 
      if (%I == Yes) { var %Channels $7- }
      else { var %Channels $8- }
    }
    else { var %Channels None. }
    echo 07 #Help Nick: $1
    echo 07 #Help Identified: %I
    echo 07 #Help Channels: %Channels
    unset %HelpJoin
  }
}
