/**
* Script Description
** This script will automatically attempt untban you, get channel keys, and invite you to
** the channel you tried to join upon reciving an error message.
** This script will also automatically unban you when banned by a user when you're in the channel.
** Assuming you have the rights to do so.

*** There are no configuration settings for this script.
*** This script works for Atheme and Anope-based networks.
*/

; Raw 474 is the ban error numeric.
raw 474:*cannot join channel*:{
  echo 10 -ta * [AutoBypass] 4Banned: Could not join: $2
  ChanServ unban $2
  haltdef
}


; This is for Atheme
on $^*:Notice:/(\S+)\s\((\d+)\sbans?\sremoved\)\.$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp $+([,$network,/,$regml(1),]) 10Removed ban. [Matched $+(07,$regml(2),10) $+($iif($regml(2) > 1,bans,ban),])
  join -n $regml(1) | haltdef
}


; This is for Anope
on $^*:Notice:/unbanned\sfrom\s(\S+)\.$/Si:?:{ 
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  if ($me !ison $chan) {
    aline -ph @Ban/Key/Invite $timestamp $+([,$network,/,$regml(1),]) 10Removed ban.
    join -n $regml(1) | haltdef
  }
}


; Raw 473 is the +i error numeric.
raw 473:*cannot join channel*:{ 
  echo 10 -ta * [AutoBypass] 4Invite-Only: Could not join: $2
  ChanServ invite $2
  haltdef 
}

; This isn't going to work on networks that make the botserv bot do the invite instead of chanserv
; when the user does /chanserv invite #chan
on ^*:invite:#:{
  if ($nick == ChanServ) {
    if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

    aline -ph @Ban/Key/Invite $timestamp $+([,$network,/,$chan,]) 10Bypassed invite-only mode.
    Join -n $chan | haltdef
  }
}

; Raw 475 is the +k error numeric.
raw 475:*cannot join channel*:{
  echo 10 -ta * [AutoBypass] 4Keyed Channel: Could not join: $2
  ChanServ getkey $2
  haltdef
}

; This is for Atheme
on $^*:Notice:/(\S+)\skey\sis.\s(\S+)$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp $+([,$network,/,$regml(1),]) 10Bypassed channel key. [key: $+(07,$regml(2),10])

  if ($window($regml(1)) {
    join $regml(1) $regml(2)
    haltdef
  }
  else {
    join -n $regml(1) $regml(2)
    haltdef
  }
}

; This is for Anope (1.8.4) Not sure if it changes by version
; I used to use a different notice but when I was testing the script it didn't work
; So I assume this wont work with eariler versions of Anope.
on $^*:Notice:/^KEY\s(\S+)\s(\S+)$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp $+([,$network,]) 10Bypassed +k on:07 $regml(1) 10with key:07 $regml(2)

  ; This is sort of experimental. It should check to see if the window is open
  ; if so then it wont join -n just regular join.
  if ($window($regml(1)) {
    join $regml(1) $regml(2)
    haltdef
  }
  else {
    join -n $regml(1) $regml(2)
    haltdef
  }
}

; This unbans you when someone else sets a ban as long as you're a Op/Halfop it will remove the ban.
; You must be on the channel when the ban is set to remove it though, if you're banned+kicked and
; have autorejoin on the other part of the script will unban you and join you again.
on *:BAN:#:{
  var %x = 2, %i = 0, %BanMask

  if ($modefirst) { 
    while (%x <= $0) {
      if ($($+($,%x),2) iswm $ial($me)) { 
        inc %i | %BanMask = %BanMask $($+($,%x),2) 
      }

      inc %x
    }

    if (%BanMask) {
      if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

      aline -ph @Ban/Key/Invite $timestamp $+([,$network,/,$chan,]07) $nick 12banned07 %BanMask

      if (($me isop $chan) || ($me ishop $chan)) {
        mode $chan - $+ $str(b,%i) %BanMask
      }

    }
  }
}
