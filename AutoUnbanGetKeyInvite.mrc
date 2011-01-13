; Raw 474 is the ban error numeric.
raw 474:*cannot join channel*:{ cs unban $2 | haltdef }

; This is for Atheme
on $^*:Notice:/(\S+)\s\(\d+\sbans?\sremoved\)\.$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp 10Removed ban from:07 $regml(1)
  join -n $regml(1) | haltdef
}

; This is for Anope
on $^*:Notice:/unbanned\sfrom\s(\S+)\.$/Si:?:{ 
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp 10Removed ban from:07 $regml(1)
  join -n $regml(1) | haltdef
}

; Raw 473 is the +i error numeric.
raw 473:*cannot join channel*:{ cs invite $2 | haltdef }

; This isn't going to work on networks that make the botserv bot do the invite instead of chanserv
; when the user does /chanserv invite #chan
on ^*:invite:#:{
  if ($nick == ChanServ) {
    if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

    aline -ph @Ban/Key/Invite $timestamp 10Bypassed +i on:07 $chan
    Join -n $chan | haltdef
  }
}

; Raw 475 is the +k error numeric.
raw 475:*cannot join channel*:{ cs getkey $2 | haltdef }

; This is for Atheme
on $^*:Notice:/(\S+)\skey\sis.\s(\S+)$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp 10Bypassed +k on:07 $regml(1) 10with key:07 $regml(2)
  join -n $regml(1) $regml(2) | haltdef
}

; This is for Anope (1.8.4) Not sure if it changes by version
; I used to use a different notice but when I was testing the script it didn't work
; So I assume this wont work with eariler versions of Anope.
on $^*:Notice:/KEY\s(\S+)\s(\S+)$/Si:?:{
  if (!$window(@Ban/Key/Invite)) { window -nz @Ban/Key/Invite }

  aline -ph @Ban/Key/Invite $timestamp 10Bypassed +k on:07 $regml(1) 10with key:07 $regml(2)
  join -n $regml(1) $regml(2) | haltdef
}

; This unbans you when someone else sets a ban as long as you're a Op/Halfop it will remove the ban.
; You must be on the channel when the ban is set to remove it though, if you're banned+kicked and
; have autorejoin on the other part of the script will unban you and join you again.
on *:BAN:#:{
  if (($me isop $chan) || ($me ishop $chan)) {
    var %x = 2, %i = 0, %BanMask

    if ($modefirst) { 
      while (%x <= $0) {
        if ($($+($,%x),2) iswm $ial($me)) { 
          inc %i | %BanMask = %BanMask $($+($,%x),2) 
        }

        inc %x
      }

      mode $chan - $+ $str(b,%i) %BanMask
    }
  }
}
