alias status {
  set %Check_START ON
  if (!$1) {
    echo -a Syntax: /Status [-message] User
    echo -a The '-message' switch will cause the script to message the active window.
  }
  if (-message == $1) {
    set %Check_DISPLAY msg $active
    set %Check_UserToCheck $2
  }
  else {
    set %Check_DISPLAY echo -a
    set %Check_UserToCheck $1
  }
  CHECK %Check_UserToCheck
}
raw 304:*CHECK START*:{
  if (%Check_START) {
    echo -a 07Check started for:13 $4
    haltdef
  }
}
raw 304:*CHECK END*:{
  if (%Check_START) {
    unset %Check_*
    echo -a 07Check finished for:13 $4
    haltdef
  }
}
raw 304:*CHECK*:{
  if (%Check_START) {
    if ($3 == nuh) %Check_DISPLAY 07Nick!User@Host:13 $4-
    elseif ($3 == realnuh) %Check_DISPLAY 07Real Nick!User@Host:13 $4-
    elseif ($3 == modes) %Check_DISPLAY 07Modes:13 $4-
    elseif ($3 == snomasks) %Check_DISPLAY 07SNOMasks:13 $4-
    elseif ($3 == server) %Check_DISPLAY 07Server:13 $4-
    elseif ($3 == uid) %Check_DISPLAY 07UID:13 $4-
    elseif ($3 == signon) %Check_DISPLAY 07Connected:13 $4-
    elseif ($3 == nickts) %Check_DISPLAY 07Nick TS:13 $4-
    elseif ($3 == lastmsg) %Check_DISPLAY 07Last Message:13 $4-
    elseif ($3 == opertype) %Check_DISPLAY 07Oper Type:13 $4-
    elseif ($3 == onip) %Check_DISPLAY 07IP:13 $4-
    elseif ($3 == onport) %Check_DISPLAY 07Port:13 $4-
    elseif ($3 == connectclass) %Check_DISPLAY 07Connect Class:13 $4-
    elseif ($3 == onchans) %Check_DISPLAY 07Channels:13 $4-
    haltdef
  }
}
