/**
* Script Description
** Attempts to hide all away messages from channel windows.
*
* Configuration Settings / Commands:
** None!
*
* Settings File
** This script stores all settings in HideAwayScriptMessage.ini in the mIRC Directory.
** Type: //run $mIRCDir\HideAwayScriptMessage.ini to view.
*/

; Handles text
on ^*:TEXT:*:#:{
  if ($CheckForAway($1-) != 0) {

    ; Opens the @Window
    OpenWindow

    ; Add to @AwayMessages
    aline -ph @AwayMessages $timestamp $($+(07,$regml(CheckAway,1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(CheckAway,2),12]10:,12])),2) $regml(CheckAway,2)

    ; Halt the message from the channel
    haltdef
  }
}


; Handles actions
on ^*:ACTION:*:#:{
  if ($CheckForAway($1-) != 0) {

    ; Opens the @Window
    OpenWindow

    ; Add to @AwayMessages
    aline -ph @AwayMessages $timestamp $($+(07,$regml(CheckAway,1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(CheckAway,2),12]10:,12])),2) $regml(CheckAway,2)

    ; Halt the message from the channel
    haltdef
  }
}


; Moved this check down to an alias so I can expand to multiple regexs for better matching later.
alias -l CheckForAway {
  return $regex(CheckAway,$1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si)
}


; Moved this to it's own alias so I don't have to have it written twice.
alias -l OpenWindow {
  if (!$window(@AwayMessages)) {
    window -nz @AwayMessages
  }
}


; Accidently unloaded a script and it took me a good 10 minutes to figure out
; which one was unloaded, Adding this to all the scripts to prevent this problem
; happening again in the future.
on *:UNLOAD:{
  if (!$window(@Script_Log)) {
    window -nz @Script_Log
  }
  aline -ph @Script_Log Unloading: $script
}
