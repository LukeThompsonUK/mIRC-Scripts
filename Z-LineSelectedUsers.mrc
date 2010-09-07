raw 340:*:{
  if (%ZLineSelectedUsers) {
    if ($regex(UserIP,$1-,/(\S+)\*=(?:\S+)@(\S+)/Si)) {
      echo -a Detected operator $regml(UserIP,1) not setting Z-Line on: $regml(UserIP,2)
    }
    elseif ($regex(UserIP,$1-,/(\S+)=(?:\S+)@(\S+)$/Si)) {
      zline $regml(UserIP,2) 7d $+(:,%ZLineSelectedUsers_Reason)
    }
    dec %ZLineSelectedUsers_TotalUsers
    if (%ZLineSelectedUsers_TotalUsers == 0) { 
      unset %ZLineSelectedUsers
      .timer 1 5 unset %ZLineSelectedUsers_TotalUsers
      .timer 1 5 unset %ZlineSelectedUsers_Reason
    }
  }
}
alias F7 {
  if ($?!="Z-Line selected users?" == $false) { Halt }
  set %ZLineSelectedUsers_Reason $?="Z-Line Reason:"
  var %x 1
  set %ZLineSelectedUsers ON
  set %ZLineSelectedUsers_TotalUsers $snick($chan,0)
  while (%x <= $snick($chan,0)) {
    userip $snick($chan,%x)
    inc %x
  }
}
