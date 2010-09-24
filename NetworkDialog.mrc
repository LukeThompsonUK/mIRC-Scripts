;
; Okay, this is my first serious dialog and as such it is prone to bugs and glitches
; Please let me know if you spot anything working in a way it shouldn't
; I am currently developing this for InspIRCd networks, I'm testing this on a 1.2.x based server
;
alias F6 {
  ; Calling the dialog, the -h switch is used to tie it to the active server window.
  dialog -mh NetworkControl NetworkControl
}
dialog NetworkControl {
  title NetworkControl - by Shawn
  size 200 200 250 250
  option dbu

  ; This will be for the entire network userlist
  tab "Users" 1, 1 1 249 249
  ; Pushing this will envoke a /who * u
  button "Refresh userlist", 2, 198 15 50 10, tab 1
  ; This will list all the users on the network at the time of pushing
  ; the 'refresh userlist' button
  list 3, 5 15 150 200, multisel, tab 1


  ; This will be for users that are marked as bad or watching
  tab "Marked users" 4, 2 2 249 249
  ; Pushing this will zline all users in the marked user table.
  button "Ban marked users", 5, 198 15 50 10, tab 4
  ; This will list all the marked users.
  list 6, 5 15 150 200, multisel, tab 4


  ; This tab will let you specify a number of seconds to search by
  tab "Search by time connected" 7, 3 3 249 249
  ; Pushing this will search for users that have been connected less than x amount of seconds.
  button "Search users", 8, 198 40 50 10, tab 7
  text "Specify the number of seconds to search back", 10, 185 15 60 15, tab 7
  edit "600", 9, 198 30 50 10, tab 7
  list 11, 5 15 150 200, multisel, tab 7
}
on *:Dialog:NetworkControl:sclick:5:{
  ; This is called when the ban marked users button is pressed
  var %x $did(NetworkControl,6).lines
  set %NetworkControl_Dialog_ZLINE ON
  set %NetworkControl_Dialog_ZLINE_TotalUsers $did(NetworkControl,6).lines
  set %NetworkControl_Dialog_ZLINE_Reason $$?="Reason for banning?"
  while (%x > 0) {
    userip $did(NetworkControl,6,%x).text
    dec %x
  }
}
on *:Dialog:NetworkControl:sclick:11:{
  ; This is called when you click any nick on the list in the searchusers tab
  did -a NetworkControl 6 $did(11).seltext
  did -d NetworkControl 11 $did(11).sel
}
on *:Dialog:NetworkControl:sclick:8:{
  ; This is called when the "Search users" button
  set %NetworkControl_Dialog_WHO_Timed ON
  WHO $did(NetworkControl,9).text tu
}
on *:Dialog:NetworkControl:sclick:2:{
  ; This is called when a user clicks the "Refresh userlist" button.
  set %NetworkControl_Dialog_WHO ON
  WHO * u
}
on *:Dialog:NetworkControl:sclick:3:{
  ; This is called when a user clicks any nick on the network userlist listbox.
  ; clicking any username on this table will remove them from here and add them to the list of marked users.
  ;echo -s $did(3).sel
  if ($didwm(NetworkControl,6,$did(3).seltext)) {
    did -d NetworkControl 3 $did(3).sel
    halt
  }
  else {
    did -a NetworkControl 6 $did(3).seltext
    did -d NetworkControl 3 $did(3).sel
  }
}
on *:Dialog:NetworkControl:sclick:6:{
  ; This is called when a user clicks any nick on the marked userlist listbox
  ; Clicking any username here will return them to the network userlist.
  if ($didwm(NetworkControl,3,$did(6).seltext)) { 
    did -d NetworkControl 6 $did(6).sel
    halt 
  }
  else {
    did -a NetworkControl 3 $did(6).seltext
    did -d NetworkControl 6 $did(6).sel
  }
}
on $^*:Snotice:/NICK:\sUser\s(\S+)(?:[^\]]+)to\s(\S+)/Si:{
  if ($network == %NetworkControl_Dialog_Network) {
    if ($didwm(NetworkControl,3,$regml(1))) {
      did -o NetworkControl 3 $didwm(NetworkControl,3,$regml(1)) $regml(2)
    }
    elseif ($didwm(NetworkControl,6,$regml(1))) {
      did -o NetworkControl 6 $didwm(NetworkControl,6,$regml(1)) $regml(2)
    }
    elseif ($didwm(NetworkControl,11,$regml(1))) {
      did -o NetworkControl 11 $didwm(NetworkControl,11,$regml(1)) $regml(2)
    }
  }
}
raw 352:*:{
  if (%NetworkControl_Dialog_WHO) {
    ; Ok, so $3 is the ident, $4 is the host, $5 is the server their on, $6 is their nick, $9- is their real name.
    ; We'll add all the names that we get to the userlist in the dialog.
    if ($didwm(NetworkControl,3,$6)) { halt }
    did -a NetworkControl 3 $6
    haltdef
  }
  elseif (%NetworkControl_Dialog_WHO_Timed) {
    if ($didwm(NetworkControl,11,$6)) { halt }
    did -a NetworkControl 11 $6
    haltdef
  }
}
raw 315:*:{
  if (%NetworkControl_Dialog_WHO) { 
    unset %NetworkControl_Dialog_WHO 
    haltdef
  }
  if (%NetworkControl_Dialog_WHO_Timed) { 
    unset %NetworkControl_Dialog_WHO_Timed 
    haltdef
  }
}
on *:Dialog:NetworkControl:close:*:{
  ; This is called when the dialog is closed, we should ensure that we unset all variables
  ; and other things since we nolonger need them if the dialog isn't running.
  unset %NetworkControl_Dialog_*
  unset %NetworkControl_Dialog
  unset %NetworkControl_WHO_Timed
}
on *:Dialog:NetworkControl:init:0:{
  ; This is called when we first start the dialog.
  set %NetworkControl_Dialog ON
  set %NetworkControl_Dialog_Network $network
}

raw 340:*:{
  if (%NetworkControl_Dialog_ZLINE) {
    if ($regex(UserIP,$1-,/(\S+)\*=(?:\S+)@(\S+)/Si)) {
      echo -a Detected operator $regml(UserIP,1) not setting Z-Line on: $regml(UserIP,2)
    }
    elseif ($regex(UserIP,$1-,/(\S+)=(?:\S+)@(\S+)$/Si)) {
      zline $regml(UserIP,2) 7d $+(:,%NetworkControl_Dialog_ZLINE_Reason)
    }
    dec %NetworkControl_Dialog_ZLINE_TotalUsers
    if (%NetworkControl_Dialog_ZLINE_TotalUsers == 0) { 
      unset %NetworkControl_Dialog_ZLINE
      .timer 1 5 unset %NetworkControl_Dialog_ZLINE_*
    }
  }
}
