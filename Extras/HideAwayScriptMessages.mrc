/**
* Script Description
** Attempts to hide all away messages from channel windows.
*
* Configuration Settings / Commands:
** /ah.settings -pm [ON/OFF] ( Will pm the offending user with a link to why away messages are annoying. )
** The message sent out is: 'Due to your recent away message you are kindly being asked to read this: http://shawn-smith.github.com/away_messages.html'
** The above doesn't currently work due to the link being removed. It will be added back when it's been rewritten to look nicer.
*
* Settings File
** This script stores all settings in HideAwayScriptMessage.ini.ini in the mIRC Directory.
** Type: //run $mIRCDir\HideAwayScriptMessage.ini to view.
*/

; Alias to handle settings, currently it only does the pm users on/off feature.
; Note to self, we need to move this to a link hosted by a more trustworthy host, don't want it going down.
alias ah.settings {
  ; Checks for -pm on|off
  if ($regex(HideAway,$1-,/-pm\s(on|off)$/Si)) {
    ; If it's on
    if ($regml(HideAway,1) == on) {
      writeini HideAwayScriptMessage.ini Configuration ShowURL ON
      echo 07 -a [HideAwayScriptMessages\Configuration]: Showing URL to users.
    }
    ; Off.
    elseif ($regml(HideAway,1) == off) {
      writeini HideAwayScriptMessage.ini Configuration ShowURL OFF
      echo 07 -a [HideAwayScriptMessages\Configuration]: Not showing URL to users.
    }
  }
  ; If it didn't match -pm on|off
  else {
    echo 07 -a [HideAwayScriptMessages\Configuration]: Usage: /ah.settings -pm [on|off]
  }
}


; Handles text
on ^*:TEXT:*:#:{
  if ($CheckForAway($1-) != 0) {

    ; Opens the @Window
    OpenWindow

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    ; Handles the URL messaging function
    if ($DoURL == ON) {
      SendURL $nick
    }

    haltdef
  }
}


; Handles actions
on ^*:ACTION:*:#:{
  if ($CheckForAway($1-) != 0) {

    ; Opens the @Window
    OpenWindow

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    ; Handles the URL messaging function
    if ($DoURL == ON) {
      SendURL $nick
    }

    haltdef
  }
}


; Moved this check down to an alias so I can expand to multiple regexs for better matching later.
alias -l CheckForAway {
  return $regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si)
}


; Moved this to it's own alias so I don't have to have it written twice.
alias -l OpenWindow {
  if (!$window(@AwayMessages)) {
    window -nz @AwayMessages
  }
}


; Sends the URL
alias -l SendURL {
  if (!%Spam. [ $+ [ $1 ] ]) {
    ;  msg $1 Due to your recent away message you are kindly being asked to read this: http://shawn-smith.github.com/away_messages.html
    msg $1 Please consider turning off public away messages. They are incredibly annoying.
    inc -u5 %Spam. [ $+ [ $1 ] ]
  }
}


; Returns ON/OFF
alias -l DoURL {
  return $readini(HideAwayScriptMessage.ini,Configuration,ShowURL)
}


; Accidently unloaded a script and it took me a good 10 minutes to figure out
; which one was unloaded, Adding this to all the scripts to prevent this problem
; happening again in the future.
on *:UNLOAD:{
  echo -a Unloading: $script
}
