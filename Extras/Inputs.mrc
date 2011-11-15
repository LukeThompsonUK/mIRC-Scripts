; Coded on request for Matty.
/* Command List
.add <nick> <access>
.del <nick>

+q/-q <nick>
+a/-a <nick>
+o/-o <nick>
+h/-h <nick>
+v/-v <nick>

*/
on *:INPUT:#:{
  ; This line checks for the first command. It MUST begin with a ., +, or -
  noop $regex(Inputs,$1,/^([\.+-]\S+)/Si)


  if ($regml(Inputs,1) == .add) {
    noop $regex(Access,$2-3,/^(\S+)\s(\d+)$/Si)

    if ($regml(Access,0) == 2) {
      msg ChanServ access $chan add $regml(Access,1) $regml(Access,2)
    }
    else {
      echo -a Syntax: .add <nick> <access level>
      echo -a Example: .add Shawn 5
    }
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
  }
  elseif ($regml(Inputs,1) == .list) {
    msg ChanServ access $chan list
  }

  if ($istok(+q:-q,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
  }
  elseif ($istok(+a:-a,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
  }
  elseif ($istok(+o:-o,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
  }
  elseif ($istok(+h:-h,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
  }
  elseif ($istok(+v:-v,$regml(Inputs,1),58)) {
    if ($2) {
      mode $chan $regml(Inputs,1) $2
    }
    else {
      echo -a Syntax: $regml(Inputs,1) <nick>
      echo -a Example: $regml(Inputs,1) Shawn
    }
  }

}
