Atheme
.NickServ
..Register: .msg NickServ REGISTER $?="Enter a password to register with" $?="Enter your email address"
..Identify
...Identify via password: .msg NickServ IDENTIFY $?="Enter username to identify with" $?="Enter password"
...SSL Fingerprint list: .msg NickServ CERT LIST
...SSL Fingerprint add: .msg NickServ CERT ADD $?="Please enter the fingerprint to autoidentify with"
...SSL Fingerprint del: .msg NickServ CERT DEL $?="Please enter the fingerprint to remove"
..Ghost: .msg NickServ Ghost $?="Enter username to ghost" $?="Enter password"
..Change Password: .msg NickServ SET PASSWORD $?=Enter a new password."
..Ungroup: .msg NickServ UNGROUP $?="Enter name to ungroup"
..Info: .msg NickServ INFO $?="Enter name to get info on"
..SendPass: .msg NickServ SENDPASS $?="Enter name to sendpass to"
..NOOP: .msg NickServ SET NOOP $?="On or Off?"
..NeverOP: .msg NickServ SET NEVEROP $?="On or Off?"
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
..Invite: .msg ChanServ INVITE $?="Enter channel to invite to"
..Kick: .msg ChanServ KICK $chan $?="Enter nick to kick" $?="Enter reason for kick"
..KickBan: .msg ChanServ KICKBAN $chan $?="Enter nick to kick-ban" $?="Enter reason for kick-ban"
..ModeLock: .msg ChanServ SET MLOCK $chan $?="Enter modes to lock"
