/**
* Script Description
** Binds a function key to ban selected users in the nick-list.
*
* Configuration Settings / Commands
** [Function Key]: F7 - Z-lines users selected in the nicklist.
*/

; This is the /userip numeric
raw 340:*:{
  ; This checks to see if we used F7. If so then we do the rest.
  if (%ZLineSelectedUsers) {
    ; This checks for oper.
    if ($regex(UserIP,$1-,/(\S+)\*=(?:\S+)@(\S+)/Si)) {
      echo -a Detected operator $regml(UserIP,1) not setting Z-Line on: $regml(UserIP,2)
    }
    ; If the user isn't an oper, do the zline.
    ; Note to self, make the zline time changable.
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


; Alias to start the script.
alias F7 {
  if (!$regex(ZLineSelected,$active,/^#\S+$/)) {
    echo -a You're active window isn't a channel, please only use this on channel windows.
    halt
  }

  if ($?!="Z-Line selected users?" == $false) { 
    Halt 
  }

  set %ZLineSelectedUsers_Reason $$?="Z-Line Reason:"
  set %ZLineSelectedUsers ON
  set %ZLineSelectedUsers_TotalUsers $snick($chan,0)

  var %x 1

  while (%x <= $snick($chan,0)) {
    userip $snick($chan,%x)

    inc %x
  }
}
