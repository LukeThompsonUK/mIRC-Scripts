/**
* Script Description
** This script is used to message every channel on a network.
** Note: Only messages the current network, no option to message multiple networks at once.
*
* Configuration Settings
** /GSettings -gignore #Channel - Will not message this channel on any network you use /global on
** /GSettings -gunignore #Channel - Removes the channel from the global do not message list
** /GSettings -ignore #Channel - Will not message this channel on this network when using /global
** /GSettings -unignore #Channel - Removes the channel from the network-specific do not message list
** /GSettings -Status - Prints all ignore lists.
** /Global MessageHere - Will message the entire network (minus ignore list)
*
* Settings File
** This script stores all settings in GlobalAmsgSettings.ini in the mIRC Directory.
** Type: //run $mIRCDir\GlobalAmsgSettings.ini to view.
*/

alias global {
  var %c 1

  ; Loops for each channel.
  while (%c <= $chan(0)) {

    ; Check the global ignore first
    if (!$istok($ReturnIgnore(Global),$chan(%c),44)) {

      ; If that's all good check the network-specific ignore
      if (!$istok($ReturnIgnore($network),$chan(%c),44)) {
        ; Once again all good, message the channel.
        msg $chan(%c) 7[10 Global 7]10 $1-
      }

    }

    inc %c
  }
}

alias gsettings {
  if ((-gignore isin $1) && ($regex($2,/#\S+/))) {
    writeini GlobalAmsgSettings.ini Global $2 ON
    echo 07 -a [Settings\GlobalAmsg] - Global Ignore: $iif($ReturnIgnore(Global),$ReturnIgnore(Global),Empty!)
  }
  elseif ((-gunignore isin $1) && ($regex($2,/#\S+/))) {
    remini GlobalAmsgSettings.ini Global $2

    if ($ini(GlobalAmsgSettings.ini,Global,0) == 0) {
      remini GlobalAmsgSettings.ini Global
    }

    echo 07 -a [Settings\GlobalAmsg] - Global Ignore: $iif($ReturnIgnore(Global),$ReturnIgnore(Global),Empty!)
  }
  elseif ((-ignore isin $1) && ($regex($2,/#\S+/))) {
    writeini GlobalAmsgSettings.ini $network $2 ON
    echo 07 -a [Settings\GlobalAmsg] - $network Ignore: $iif($ReturnIgnore($network),$ReturnIgnore($network),Empty!)
  }
  elseif ((-unignore isin $1) && ($regex($2,/#\S+/))) {
    remini GlobalAmsgSettings.ini $network $2

    if ($ini(GlobalAmsgSettings.ini,$network,0) == 0) {
      remini GlobalAmsgSettings.ini $network
    }

    echo 07 -a [Settings\GlobalAmsg] - $network Ignore: $iif($ReturnIgnore($network),$ReturnIgnore($network),Empty!)
  }
  elseif (-status isin $1) {
    var %x 1

    while (%x < $ini(GlobalAmsgSettings.ini,0)) {
      echo 07 -a [Settings\GlobalAmsg] - $ini(GlobalAmsgSettings.ini,%x) Ignore: $iif($ReturnIgnore($ini(GlobalAmsgSettings.ini,%x)),$ReturnIgnore($ini(GlobalAmsgSettings.ini,%x)),Empty!)
      inc %x
    }

    ; This is to print help information if there are no ignore lists.
    if ($ini(GlobalAmsgSettings.ini,0) == 0) {
      echo 07 -a [Settings\GlobalAmsg] - You don't have any channels added to an ignore list.
      echo 07 -a [Settings\GlobalAmsg] - Type ' /GSettings ' to get a list of commands.
    }
  }
  else { 
    echo 07 -a [Settings\GlobalAmsg] - Commands:
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -gignore #Channel - Will not message this channel on any network you use /global on
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -gunignore #Channel - Removes this channel from the global do not message list
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -ignore #Channel - Will not message this channel on this network when using /global
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -unignore #Channel - Removes this channel from the network-specific do not message list
    echo 07 -a [Settings\GlobalAmsg] - /GSettings -Status - Prints all ignore lists.
    echo 07 -a [Settings\GlobalAmsg] - /Global MessageHere - Will message the entire network (minus ignore list)
  }
}

alias ReturnIgnore {
  var %Total $ini(GlobalAmsgSettings.ini, $1, 0)
  var %x 1
  while (%x <= %Total) {
    var %Return $addtok(%Return, $ini(GlobalAmsgSettings.ini, $1, %x), 44)
    inc %x
  }

  return %Return
}
