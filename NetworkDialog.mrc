;
; Okay, this is my first serious dialog and as such it is prone to bugs and glitches
; Please let me know if you spot anything working in a way it shouldn't
; I am currently developing this for InspIRCd networks, I'm testing this on a 1.2.x based server
;

alias F6 { 
  dialog -md NetworkControl NetworkControl 
}

alias NetworkControl { 
  dialog -m NetworkControl NetworkControl 
}


on *:Dialog:NetworkControl:init:0:{
  ; This is called when we first start the dialog.
  ; set %NetworkControl_Dialog ON Commented out because it may not be used anymore?
  set %NetworkControl_Dialog_Network $network
  set %NetworkControl_Dialog_WHO ON

  ; This populates the drop-down box with the IRCd list.
  didtok NetworkControl 22 58 $readini(NetworkControlDialog.ini,MainSettings,IRCdList)

  if ($readini(NetworkControlDialog.ini,Preferences,IRCd)) {
    ; This sets the IRCd to the prefered one.
    did -c NetworkControl 22 $readini(NetworkControlDialog.ini,Preferences,IRCd)

    if ($readini(NetworkControlDialog.ini,Preferences,IRCd) !isnum 1-2) {
      ; 8 is the button, 9 is the edit box
      ; used for time-based who searches
      did -b NetworkControl 8,9
    }
    else { 
      ; This /who will only work on inspircd
      who 600 ut
    }
  }

  if ($readini(NetworkControlDialog.ini,Preferences,BanTime)) {
    ; Sets the ban time to what it was set to last time the dialog was open.
    did -a NetworkControl 17 $readini(NetworkControlDialog.ini,Preferences,BanTime)
  }

  if ($readini(NetworkControlDialog.ini,Preferences,IgnoreOper) == 1) {
    ; Sets the ignoreoper checkbox to true if you had it set when the dialog was closed last.
    did -c NetworkControl 26
  }

  if ($readini(NetworkControlDialog.ini,Preferences,IgnoreRegID) == 1) {
    ; Sets the ignoreregid checkbox to true if you had it set when the dialog was closed last.
    did -c NetworkControl 27
  }
}


dialog NetworkControl {
  title NetworkControl - by Shawn $+([,$network,])
  size 200 200 250 250
  option dbu

  ; I created a tab so if I want to expand this in the future it can be done with another tab.
  tab "Users" 1, 1 1 249 249

  ; So apparently after making 1 tab the others don't need to have so much shit
  tab "Configuration", 19

  ; This button can be used to view the entire network
  ; (Requires the ability to view past the normal /who limit)
  button "View entire network", 2, 193 15 55 10, tab 1

  ; This button clears the userlist
  button "Clear users", 14, 198 25 50 10, tab 1

  ; This button will give a pop-up asking for a reason, then ban all users on the marked list
  button "Ban marked users", 5, 198 35 50 10, tab 1

  ; This button will give a pop-up asking for a reason, then disconnect all users on the marked list
  button "Kill marked users", 28, 198 45 50 10, tab 1

  ; This button displays help.
  button "Help", 20, 198 200 50 10, tab 1

  ; This button lets you search for users in the last 'x' amount of seconds
  ; 'x' being the edit box, ID 9
  button "Search users", 8, 198 90 50 10, tab 1

  ; This button sends whatever is in the edit box (id:24) in a WHO search
  ; EXACTLY as it is typed in the box.
  button "WHO", 25, 190 160 50 10, tab 1 

  text "Userlist:", 15, 5 15 20 6, tab 1
  text "Marked users:", 16, 70 15 40 6, tab 1
  text "Specify the number of seconds to search back", 10, 185 65 60 15, tab 1
  text "Duration of ban:", 18, 5 33 40 10, tab 19
  text "IRCd:", 21, 5 21 13 10, tab 19
  text "Custom /WHO search", 23, 190 140 55 10, tab 1

  ; This is the userlist
  list 3, 5 21 50 200, multisel, tab 1

  ; This is the marked userlist
  list 6, 70 21 50 200, multisel, tab 1

  ; When you push the 'search users' button it checks this for the number of seconds to search back
  edit "600", 9, 198 80 50 10, tab 1

  ; This is the duration to ban the marked users for.
  ; Format can be any 1w1d1h1m1s combination.
  edit "", 17, 45 32 20 10, tab 19
  edit "", 24, 190 150 50 10, tab 1

  combo 22, 19 19 50 10, drop, tab 19

  check "Do not show opers when searching", 26, 5 43 95 10, tab 19

  ; This will only work on ircds that have the 'r' flag in /who output, inspircd needs a patch
  ; for this to work.
  ; Patch is located here: http://inspircd.org/forum/showthread.php?t=8347
  check "Do not show registered/identified users", 27, 5 53 105 10, tab 19
}


on *:Dialog:NetworkControl:sclick:22:{
  ; If the IRCd isn't InspIRCd then we can't use these.
  ; 1 = InspIRCd
  ; 2 = WGIRCd
  ; 8 is the button, 9 is the edit box for time-based searching
  ; 27 is the ignore registered/identified users checkbox. Needs the 'r' flag in /who output
  if ($did(22).sel isnum 1-2) { 
    did -e NetworkControl 8,9 
  }
  else { 
    did -b NetworkControl 8,9
  }
}


on *:Dialog:NetworkControl:sclick:14:{ 
  did -r NetworkControl 3 
  did -r NetworkControl 6
}


on *:Dialog:NetworkControl:sclick:25:{
  set %NetworkControl_Dialog_WHO ON
  WHO $did(24).text
}


on *:Dialog:NetworkControl:sclick:28:{
  ; This is called when the kill marked users button is pressed
  var %x $did(NetworkControl,6).lines
  var %KR $$?="Reason for disconnecting users?"

  while (%x > 0) {
    kill $did(NetworkControl,6,%x).text %KR
    dec %x
  }
}


on *:Dialog:NetworkControl:sclick:5:{
  ; This is called when the ban marked users button is pressed
  var %x $did(NetworkControl,6).lines
  set %NetworkControl_Dialog_ZLINE ON
  set %NetworkControl_Dialog_ZLINE_TotalUsers $did(NetworkControl,6).lines
  set %NetworkControl_Dialog_ZLINE_Reason $$?="Reason for banning?"

  ; This is to prevent %NetworkControl_Dialog_ZLINE_Duration being empty.
  if (!$did(NetworkControl,17).text) { 
    set %NetworkControl_Dialog_ZLINE_Duration 0
  }
  else {
    set %NetworkControl_Dialog_ZLINE_Duration $did(NetworkControl,17).text
  }

  while (%x > 0) {
    userip $did(NetworkControl,6,%x).text
    dec %x
  }
}


on *:Dialog:NetworkControl:sclick:8:{
  ; This is called when the "Search users" button
  set %NetworkControl_Dialog_WHO ON

  did -r NetworkControl 3
  WHO $did(NetworkControl,9).text tu
}


on *:Dialog:NetworkControl:sclick:2:{
  ; This is called when a user clicks the "View entire network" button.
  set %NetworkControl_Dialog_WHO ON

  did -r NetworkControl 3
  WHO * u
}


on *:Dialog:NetworkControl:sclick:3:{
  ; This is called when a user clicks any nick on the network userlist listbox.
  ; clicking any username on this table will remove them from here and add them to the list of marked users.

  ; This is used to keep from getting a weird bug where you'd add a blank line to the other list.
  if (!$did(3).seltext) { 
    halt 
  } 

  ; Checks to see if the name is already on the other list, if it is it deletes the name
  ; but doesn't add it to the other list.
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

  ; This is used to keep from getting a weird bug where you'd add a blank line to the other list.
  if (!$did(6).seltext) { 
    halt 
  } 

  if ($didwm(NetworkControl,3,$did(6).seltext)) { 
    ; Checks to see if the name is already on the other list, if it is it deletes the name
    ; but doesn't add it to the other list.
    did -d NetworkControl 6 $did(6).sel
    halt 
  }
  else {
    did -a NetworkControl 3 $did(6).seltext
    did -d NetworkControl 6 $did(6).sel
  }
}


on *:Dialog:NetworkControl:close:*:{
  ; This is called when the dialog is closed, we should ensure that we unset all variables
  ; and other things since we nolonger need them if the dialog isn't running.
  unset %NetworkControl_Dialog_*
  unset %NetworkControl_Dialog

  ; This will be used with the configuration tab to save preferences
  writeini NetworkControlDialog.ini Preferences IRCd $did(22).sel
  writeini NetworkControlDialog.ini Preferences BanTime $did(17).text
  writeini NetworkControlDialog.ini Preferences IgnoreOper $did(26).state
  writeini NetworkControlDialog.ini Preferences IgnoreRegID $did(27).state
}


on $^*:Snotice:/NICK:\sUser\s(\S+)(?:[^\]]+)to\s(\S+)/Si:{
  if ($network == %NetworkControl_Dialog_Network) {
    if ($didwm(NetworkControl,3,$regml(1))) {
      did -o NetworkControl 3 $didwm(NetworkControl,3,$regml(1)) $regml(2)
    }
    elseif ($didwm(NetworkControl,6,$regml(1))) {
      did -o NetworkControl 6 $didwm(NetworkControl,6,$regml(1)) $regml(2)
    }
  }
}


raw 352:*:{
  if (%NetworkControl_Dialog_WHO) {
    ; Ok, so $3 is the ident, $4 is the host, $5 is the server their on, $6 is their nick, $9- is their real name.
    ; We'll add all the names that we get to the userlist in the dialog.
    if ($didwm(NetworkControl,3,$6)) { 
      halt 
    }

    if ((* isin $7) && ($did(NetworkControl,26).state == 1)) {
      haltdef 
    }
    elseif ((r isincs $7) && ($did(NetworkControl,27).state == 1)) { 
      haltdef 
    }
    else { 
      did -a NetworkControl 3 $6 
    }

    haltdef
  }
}


raw 315:*:{
  if (%NetworkControl_Dialog_WHO) { 
    unset %NetworkControl_Dialog_WHO 
    haltdef
  }
}


raw 340:*:{
  if (%NetworkControl_Dialog_ZLINE) {
    if ($regex(UserIP,$1-,/(\S+)\*=(?:\S+)@(\S+)/Si)) {
      echo -as Detected operator $regml(UserIP,1) not setting Z-Line on: $regml(UserIP,2)
    }
    elseif ($regex(UserIP,$1-,/(\S+)=(?:\S+)@(\S+)$/Si)) {
      zline $regml(UserIP,2) %NetworkControl_Dialog_ZLINE_Duration $+(:,%NetworkControl_Dialog_ZLINE_Reason)
    }

    dec %NetworkControl_Dialog_ZLINE_TotalUsers

    if (%NetworkControl_Dialog_ZLINE_TotalUsers == 0) { 
      unset %NetworkControl_Dialog_ZLINE
      .timer 1 5 unset %NetworkControl_Dialog_ZLINE_*
    }
  }
}


dialog Help {
  title NetworkControl Help
  size 200 200 100 100
  option dbu

  text "By clicking users in the user/marked list you can move them back and forth between them, when you've marked all the users you wish to you can click the ban marked users button and ban them all.", 1, 1 1 60 60
}


on *:Dialog:NetworkControl:sclick:20:{
  ; This is the help button
  dialog -m Help Help
}
