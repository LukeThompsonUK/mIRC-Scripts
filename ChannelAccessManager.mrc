/*
** This script is still a work-in-progress and is apt to have bugs
** Please report any bugs you happen to find.
** Have fun!
*/

menu channel {
  Channel Management: dialog -ma ACM ACM
}
alias F4 {
  dialog -ma ACM ACM
}
on *:dialog:ACM:init:0:{
  set %ACM_FLAGLIST on
  set %ACM_TMPL on
  msg CHANSERV TEMPLATE $active
  msg CHANSERV FLAGS $active
}
on ^*:NOTICE:*:?:{
  if ($nick == ChanServ) { 
    if ((%ACM_FLAGLIST) || (%ACM_TMPL)) {
      if ($regex($1-,/^\d+\s+(\S+)\s+(\+\S+)/Si)) {
        did -a ACM 2 $regml(1) $regml(2)
      }
      if ($regex($1-,/^(\S+)\s+(\+\S+)/Si)) {
        did -a ACM 9 $regml(1) $regml(2)
      }
      if ($regex($1-,/^end\sof\s\S+\s(\S+)/Si)) {
        if ($regml(1) == FLAGS) { unset %ACM_FLAGLIST }
        elseif ($regml(1) == TEMPLATE) { unset %ACM_TMPL }
      }
      haltdef
    }
  }
}
on *:dialog:ACM:sclick:2:{
  noop $regex(ACM,$did(ACM,2).seltext,/^(\S+)\s\+(\S+)$/Si)
  did -o ACM 3 1 $regml(ACM,1)
  did -o ACM 6 1 $regml(ACM,2)
}
on *:dialog:ACM:sclick:9:{ 
  noop $regex(ACM,$did(ACM,9).seltext,/^\S+\s\+(\S+)$/Si)
  did -o ACM 6 1 $regml(ACM,1)
}
on *:dialog:ACM:sclick:7:{
  if ($did(ACM,3)) {
    msg CHANSERV FLAGS $active $did(ACM,3) $+(-*+,$did(ACM,6))
    if ($didwm(ACM,2,$did(ACM,3) *)) {
      did -o ACM 2 $didwm(ACM,2,$did(ACM,3) *) $did(ACM,3) $+(+,$did(ACM,6))
    }
    else { 
      did -a ACM 2 $did(ACM,3) $+(+,$did(ACM,6))
    }
  }
}
dialog ACM {
  title Channel Access Manager
  size 200 200 250 250
  option dbu

  text "Channel access list", 1, 5 5 50 10
  list 2, 5 15 70 100

  text "Nick/mask: ", 4, 80 14 50 10
  ; This will be the nick/mask
  edit "", 3, 116 13 50 10, autohs
  text "Flags: ", 5, 80 25 50 10
  edit "", 6, 116 24 50 10, autohs
  button "Modify", 7, 80 35 85 10

  text "Channel template list", 8, 5 115 50 10
  list 9, 5 125 70 40
}
