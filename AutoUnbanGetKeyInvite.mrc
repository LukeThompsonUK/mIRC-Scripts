; Raw 474 is the ban error numeric.
raw 474:*cannot join channel*:{ cs unban $2 | haltdef }
; This is for Atheme
on $^*:Notice:/(\S+)\s\(\d+\sbans?\sremoved\)\.$/Si:?:{
  join -n $regml(1) | haltdef
}
; This is for Anope
on $^*:Notice:/unbanned\sfrom\s(\S+)\.$/Si:?:{ 
  join -n $regml(1) | haltdef
}

; Raw 473 is the +i error numeric.
raw 473:*cannot join channel*:{ cs invite $2 | haltdef }
; This isn't going to work on networks that make the botserv bot do the invite instead of chanserv
; when the user does /chanserv invite #chan
on ^*:invite:#:{
  if ($nick == ChanServ) {
    Join -n $chan | haltdef
  }
}

; Raw 475 is the +k error numeric.
raw 475:*cannot join channel*:{ cs getkey $2 | haltdef }
; This is for Atheme
on $^*:Notice:/(\S+)\skey\sis.\s(\S+)$/Si:?:{
  join -n $regml(1) $regml(2) | haltdef
}
; This is for Anope (1.8.4) Not sure if it changes by version
; I used to use a different notice but when I was testing the script it didn't work
; So I assume this wont work with eariler versions of Anope.
on $^*:Notice:/KEY\s(\S+)\s(\S+)$/Si:?:{
  join -n $regml(1) $regml(2) | haltdef
}
