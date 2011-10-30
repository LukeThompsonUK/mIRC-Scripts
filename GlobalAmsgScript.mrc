/*
Commands provided by this script:
* /GSettings -ignore #Channel - Will not message this channel when using /global
* /GSettings -unignore #Channel - Removes the channel from the do not message list
* /Global MessageHere - Will message the entire network (minus ignore list)
*/

alias global {
  var %c 1

  while (%c <= $chan(0)) {
    if (!$istok($ReturnIgnore,$chan(%c),44)) {
      msg $chan(%c) 7[10 Global 7]10 $1- 
    }

    inc %c
  }
}

alias gsettings {
  if ((-ignore isin $1) && ($regex($2,/#\S+/))) {
    writeini GlobalAmsgSettings.ini $network $2 ON
    echo 07 -a [Settings\GlobalAmsg] - Not globaling in the following channels: $ReturnIgnore
  }
  elseif ((-unignore isin $1) && ($regex($2/#\S+/))) {
    remini GlobalAmsgSettings.ini $network $2
    echo 07 -a [Settings\GlobalAmsg] - Not globaling in the following channels: $ReturnIgnore
  }
  else { 
    echo 07 -a [Settings\GlobalAmsg] - Syntax: 
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -<ignore|unignore> #Channel
  }
}

alias -l ReturnIgnore {
  var %Total $ini(GlobalAmsgSettings.ini, $network, 0)
  var %x 1
  while (%x <= %Total) {
    var %Return $addtok(%Return, $ini(GlobalAmsgSettings.ini, $network, %x), 44)
    inc %x
  }

  return %Return
}
