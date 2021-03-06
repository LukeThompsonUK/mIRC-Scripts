/* Command List
* These commands work on any network that supports the modes.
+q/-q <nick>
+a/-a <nick>
+o/-o <nick>
+h/-h <nick>
+v/-v <nick>
+G/-G
+i/-i
+m/-m
+k/-k <key>

* This command works on any network that allows invites.
* /invite <nick> <chan>
.inv <nick>

* This command works on any network
.topic [optional topic]

* These commands are anope-based.
.add <nick> <access>
.del <nick>
.list [nick]

* These were written for anope but should work on any network that uses the following format
* for akicking.
* /msg ChanServ AKICK #Channel [ADD|DEL|LIST] <nick/host> [reason]
.akick <nick> [reason]
.delakick <nick>
.aklist

* This command is anope based.
.assign <botnick>

* This command is anope based.
.update
*/
on *:INPUT:#:{
  ; This line checks for the first command. It MUST begin with a ., +, or -
  noop $regex(Inputs,$1,/^([\.+-]\S+)/Si)

  ; ChanServ access based commands.
  if ($regml(Inputs,1) == .add) {
    noop $regex(Access,$2-3,/^(\S+)\s(\d+)$/Si)

    if ($regml(Access,0) == 2) {
      msg ChanServ access $chan add $regml(Access,1) $regml(Access,2)
    }
    else {
      echo -a Syntax: .add <nick> <access level>
      echo -a Example: .add Shawn 5
    }
    haltdef
  }
  elseif ($regml(Inputs,1) == .del) {
    if ($2) {
      msg ChanServ access $chan del $2
      mode $chan -qoahv $str($2 $chr(32),5)
    }
    else {
      echo -a Syntax: .del <nick>
      echo -a Example: .del Shawn
    }
    haltdef
  }
  elseif ($regml(Inputs,1) == .list) {
    if ($2) {
      msg ChanServ access $chan list $2
    }
    else {
      msg ChanServ access $chan list
    }
    haltdef
  }

  ; Channel user-mode related commands.
  elseif ($istokcs(+q:-q,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
    haltdef
  }
  elseif ($istokcs(+a:-a,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
    haltdef
  }
  elseif ($istokcs(+o:-o,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
    haltdef
  }
  elseif ($istokcs(+h:-h,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
    haltdef
  }
  elseif ($istokcs(+v:-v,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
    haltdef
  }
  elseif ($istokcs(+G:-G,$regml(Inputs,1),58)) {
    mode $chan $regml(Inputs,1)
    haltdef
  }
  elseif ($istokcs(+i:-i,$regml(Inputs,1),58)) {
    mode $chan $regml(Inputs,1)
    haltdef
  }
  elseif ($istokcs(+m:-m,$regml(Inputs,1),58)) {
    mode $chan $regml(Inputs,1)
    haltdef
  }
  elseif ($istokcs(+k:-k,$regml(Inputs,1),58)) {
    mode $chan $regml(Inputs,1) $2
    haltdef
  }

  ; Akick related commands.
  elseif ($regml(Inputs,1) == .akick) {
    if ($3) {
      msg ChanServ akick $chan add $2 $3-
    }
    elseif ($2) {
      msg ChanServ akick $chan add $2 Akick: No reason given.
    }
    else {
      echo -a Syntax: .akick <nick> [reason]
      echo -a Example: .akick Shawn Testing
    }
    haltdef
  }
  elseif ($regml(Inputs,1) == .delakick) {
    if ($2) {
      msg ChanServ akick $chan del $2
    }
    else {
      echo -a Syntax: .delakick <nick>
      echo -a Example: .delakick Shawn
    }
    haltdef
  }
  elseif ($regml(Inputs,1) == .aklist) {
    msg ChanServ akick $chan list
    haltdef
  }
  elseif ($regml(Inputs,1) == .clear) {
    if ($2 == akick) {
      msg ChanServ akick $chan clear
    }
    else {
      echo -a Syntax: .clear akick
    }
    haltdef
  }

  ; Invite command
  elseif ($regml(Inputs,1) == .inv) {
    if ($2) {
      invite $2 $chan
    }
    else {
      echo -a Syntax: .inv <nick>
      echo -a Example: .inv Shawn
    }
    haltdef
  }

  ; Topic command
  elseif ($regml(Inputs,1) == .topic) {
    if ($2) {
      topic $chan $2-
    }
    else {
      topic $chan
    }
    haltdef
  }

  ; Botserv assign
  elseif ($regml(Inputs,1) == .assign) {
    if ($2) {
      msg BotServ assign $chan $2
    }
    else {
      echo -a Syntax: .assign <botnick>
      echo -a Example: .assign X
    }
    haltdef
  }

  ; Update command.
  elseif ($regml(Inputs,1) == .update) {
    msg NickServ update
    haltdef
  }

}
