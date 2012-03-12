/**
* Script Description
** Attempts to hide all away messages from channel windows.
*
* Configuration Settings / Commands:
** /ah.settings -pm [ON/OFF] ( Will pm the offending user with a link to why away messages are annoying. )
** The message sent out is: 'Due to your recent away message you are kindly being asked to read this: http://sackheads.org/~bnaylor/spew/away_msgs.html'
*
* Settings File
** This script stores all settings in HideAwayScriptMessage.ini.ini in the mIRC Directory.
** Type: //run $mIRCDir\HideAwayScriptMessage.ini to view.
*/

; Alias to handle settings, currently it only does the pm users on/off feature.
; Note to self, we need to move this to a link hosted by a more trustworthy host, don't want it going down.
alias ah.settings {
  if ($1 == -pm) {
    if ($2 == on) {
      writeini HideAwayScriptMessage.ini Configuration ShowURL ON
      echo 07 -a [HideAwayScriptMessages\Configuration]: Showing URL to users.
    }
    elseif ($2 == off) {
      writeini HideAwayScriptMessage.ini Configuration ShowURL OFF
      echo 07 -a [HideAwayScriptMessages\Configuration]: Not showing URL to users.
    }
    else {
      echo 07 -a [HideAwayScriptMessages\Configuration]: Usage: /ah.settings -pm [on|off]
    }
  }
}


; Handles text
on ^*:TEXT:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (!$window(@AwayMessages)) { 
      window -nz @AwayMessages 
    }

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    ; Handles the URL messaging function
    if ($DoURL == ON) {
      if (!%Spam. [ $+ [ $nick ] ]) {
        msg $nick Due to your recent away message you are kindly being asked to read this: http://sackheads.org/~bnaylor/spew/away_msgs.html
        inc -u5 %Spam. [ $+ [ $nick ] ]
      }
    }

    haltdef
  }
}


; Handles actions
on ^*:ACTION:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (!$window(@AwayMessages)) { 
      window -nz @AwayMessages 
    }

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    ; Handles the URL messaging function
    if ($DoURL == ON) {
      if (!%Spam. [ $+ [ $nick ] ]) {
        msg $nick Due to your recent away message you are kindly being asked to read this: http://sackheads.org/~bnaylor/spew/away_msgs.html
        inc -u5 %Spam. [ $+ [ $nick ] ]
      }
    }

    haltdef
  }
}


; Returns ON/OFF
alias -l DoURL {
  return $readini(HideAwayScriptMessage.ini,Configuration,ShowURL)
}
