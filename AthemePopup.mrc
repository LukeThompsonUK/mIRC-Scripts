Atheme
.NickServ
..Register: .msg NickServ REGISTER $?="Enter a password to register with" $?="Enter your email address"
..Identify: .msg NickServ IDENTIFY $?="Enter username to identify with" $?="Enter password"
..Ghost: .msg NickServ Ghost $?="Enter username to ghost" $?="Enter password"
..Change Password: .msg NickServ SET PASSWORD $?=Enter a new password."
..Group: {
  .msg NickServ IDENTIFY $?="Enter your main nickname to group with" $?="Enter your password"
  .msg NickServ GROUP 
}
.ChanServ
..Flags
...List: .msg ChanServ flags $chan
...Modify: .msg ChanServ flags $chan $?="Modify flags of what Nick/Mask?" $?="What flags do you want that person to have?"
..OP: .msg ChanServ OP $chan $?="Enter the nick to be OPed."
..Deop: .msg ChanServ DEOP $chan $?="Enter the nick to be DEOPed."
..Voice: .msg ChanServ VOICE $chan $?="Enter the nick to be Voiced."
..DeVoice: .msg ChanServ DEVOICE $chan $?="Enter the nick to be DeVoiced."
..Recover: .msg ChanServ RECOVER $?="Enter the channel to recover." 
