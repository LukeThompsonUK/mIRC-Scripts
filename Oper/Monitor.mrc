/**
* Script Description:
** Monitors incomming connections based on a list and do optional things based on filter matches.
** All matches will show in a @Window.
*
* Configuration Settings / Commands:
** /Monitor [-s] <regex pattern> <reason> ( Sets up monitoring on the regex pattern given. )
** To remove a regex from the file, type it without a reason.
*** NOTE: YOUR REASON MAY NOT CONTAIN ANY : SYMBOLS
** Options include:
*** -s: Show in oper chan.
** /Monitor.status <network here> ( Prints given regexs for the network )
** /Monitor.settings oper-chan #channel ( Sets the oper channel. Defaults to #Services )
*** -t: Display a mIRC tool-tip. ($tip)
** Will display a small, 5 second $tip with the name of the person that matched and the reason.
*
* Settings File
** This script stores all settings in MonitorSettings.ini in the mIRC Directory.
** Type: //run $mIRCDir\MonitorSettings.ini to view.
*/


; *** CONNECT: Client connecting on port 6697: Nick!Ident@Host.com [IP.IP.IP.IP] [Test Nick]
on $*:SNOTICE:/^\*{3}\sCONNECT:.+port\s(\S+):\s(\S+)\s\[(\S+)\]\s\[(.+)\]/Si:{
  var %Lines $ini(MonitorSettings.ini, $network, 0)
  var %x 1

  while (%x <= %Lines) {
    var %Regex $ini(MonitorSettings.ini, $network, %x)
    ; If our regex matched we have to do stuff
    if ($regex(Monitor, $regml(2), %Regex) > 0) {
      var %To_Check $readini(MonitorSettings.ini,$network,%Regex)

      ; Gets the flags + reason
      if ($numtok(%To_Check,58) == 2) {
        var %Flags $gettok(%To_Check,1,58)
        var %Reason $gettok(%To_Check,2,58)
      }
      else {
        var %Reason %To_Check
      }

      ; Creates the @Window if it isn't already created.
      CreateWindow @Monitor

      ; Writes to @Monitor
      aline -ph @Monitor $timestamp $+([,$network,]) 04MATCH:07 $regml(2) $+([,$regml(3),])
      aline -ph @Monitor $timestamp $+([,$network,]) 10Regex:07 %Regex 10Flags:07 $iif(%Flags,%Flags,none) 10Reason:07 %Reason

      ; Message oper chan
      if (s isincs %Flags) {
        var %Channel $readini(MonitorSettings.ini,&Oper-Chan,$network)
        msg $iif(%Channel,%Channel,#Services) 04Match:07 $regml(2)
        msg $iif(%Channel,%Channel,#Services) 10Regex:07 %Regex 10Flags:07 $iif(%Flags,%Flags,none) 10Reason:07 %Reason
      }

      if (t isincs %Flags) {
        noop $tip(Monitor,Matched,10User:07 $regml(2) 10has matched Regex:07 $+(%Regex,10,$chr(44)) Reason:07 %Reason,10)
      }
    }

    inc %x
  }

}

; Handles the status command
alias Monitor.status {
  if ($1) {
    echo -a -
    echo -a Printing status for $1
    var %Lines $ini(MonitorSettings.ini, $1, 0)
    var %x 1
    while (%x <= %Lines) {
      var %Regex $ini(MonitorSettings.ini,$1,%x)
      var %To_Check $readini(MonitorSettings.ini,$1,%Regex)
      if ($numtok(%To_Check,58) == 2) {
        var %Flags $gettok(%To_Check,1,58)
        var %Reason $gettok(%To_Check,2,58)
      }
      else {
        var %Reason %To_Check
      }

      echo -a $+(%x,:) 10Regex:07 %Regex 10Flags:07 $iif(%Flags, %Flags, none) 10Reason:07 %Reason
      inc %x
    }
    echo -a -
  }
  else {
    echo -a No network given.
  }
}

; Handles the monitor.settings command
alias Monitor.settings {
  ; This is currently the only configurable option.
  if ($1 == oper-chan) {
    ; Check to make sure it's a valid channel.
    if ($regex($2,/^#\S+/)) {

      ; Create the window to write to.
      CreateWindow @Monitor

      ; Write the settings to the @Window
      aline -p @Monitor $timestamp $+([,$network,]) 10Oper display channel set to07 $2

      ; Check if we have one set already.
      if ($readini(MonitorSettings.ini,&Oper-Chan,$network)) {
        msg $readini(MonitorSettings.ini,&Oper-Chan,$network) 10Oper display channel changed to:07 $2
      }

      ; Write to file
      writeini MonitorSettings.ini &Oper-Chan $network $2

      ; Write to the new channel with basic information
      msg $2 10This channel has been set as the oper display channel for monitoring suspicious activity.
      msg $2 10If any matches are hit they will be printed here in the following format:
      msg $2 04MATCH:07 WhatMatched
      msg $2 10REGEX:07 REGEX 10Flags:07 flags 10Reason:07 Reason.
      msg $2 10Currently the only flag in use is 's' which shows the output here.
      msg $2 10Eventually there will be 'g' for gline, 'z' for zline, and 'k' for just a regular kill.
    }
    else {
      echo -a Invalid channel given, set oper display channel to default ( #Services )
      remini MonitorSettings.ini &Oper-Chan $network
    }
  }
}

; Handles the monitor command
alias Monitor {
  ; Checks to see if the user has given any specific flags.
  if ($left($1,1) == -) {
    var %flags = $right($1,-1)
    var %Regex = $2
    var %Reason = $3-
  }
  ; No flags given
  else {
    var %Regex $1
    var %Reason = $2-
  }

  ; Basic error checking
  if (!%Regex) {
    echo -a No regex given.
    halt
  }

  ; Creates the @Window if we don't have one.
  CreateWindow @Monitor

  ; If no reason is given we remove the regex from the file
  if (!%Reason) {
    echo -a No reason given, %Regex removed from file.
    aline -p @Monitor $timestamp $+([,$network,]) No reason given, %Regex removed from file.
    remini MonitorSettings.ini $network %Regex

    halt
  }

  ; Check for flags.
  if (%flags) {
    echo -a 10Regex:07 %Regex 10written to file with flags:07 %flags 10for reason:07 %Reason
    aline -p @Monitor $timestamp $+([,$network,]) 10Regex:07 %Regex 10written to file with flags:07 %flags 10for reason:07 %Reason
    writeini MonitorSettings.ini $network %Regex $+(%Flags,:,%Reason)

    halt
  }
  else {
    echo -a 10Regex:07 %Regex 10written to file for reason:07 %Reason
    aline -p @Monitor $timestamp $+([,$network,]) 10Regex:07 %Regex 10written to file for reason:07 %Reason
    writeini MonitorSettings.ini $network %Regex %Reason

    halt
  }
}

; Used to check if the window is open, if not it creates one.
alias -l CreateWindow {
  if (!$window($1)) {
    window -nz $1
  }
}
