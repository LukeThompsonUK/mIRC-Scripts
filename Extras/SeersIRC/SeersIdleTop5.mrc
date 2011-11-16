; Only works on the SeersIRC network.
; Syntax: /Top [-show] [number of ranks to display, Defaults to 5]
; If -show is used then it will message the active window instead of echoing.

alias Top {
  ; Check for -show, if it's there then we message the active window instead of echoing.
  if ($regex($1,/^-show/Si)) {
    var %CheckForNumber $2
    set %Top.Display msg $active
  }
  else {
    var %CheckForNumber $1
    set %Top.Display echo -a
  }

  ; Check to see if they gave a number
  if ($regex(%CheckForNumber,/^\d+$/Si)) {
    set %Top %CheckForNumber
  }
  else {
    set %Top 5
    echo -a Syntax: /top [Number of ranks to display]
  }

  ; Display
  %Top.display Printing the top %Top user(s) in IdleRPG 

  ; Open the socket
  if ($sock(IdleTop)) { .sockclose IdleTop }
  Sockopen IdleTop www.seersirc.net 80
}

on *:SockOpen:IdleTop:{
  sockwrite -nt $sockname GET $+(/irpg/top.php?n=,%Top)
  sockwrite -nt $sockname Host: http://www.seersirc.net
  sockwrite -nt $sockname $crlf
}

on *:SockRead:IdleTop: {
  sockread %IdleTop

  ; Regex to grab the incoming line.
  noop $regex(IdleTop,%IdleTop,/\[(\d+)\]\s\[(\S+)\]\s\[(\d+)\]\s\[(.+)\]/Si)

  ; This is how the output is formatted, you can change it to whatever you want.
  ; $regml(IdleTop,0-4)
  ; 0 will display the number of matches
  ; 1 Displays the rank
  ; 2 Displays the users name
  ; 3 Displays the users level
  ; 4 Displays the users class.
  if ($regml(IdleTop,0) == 4) {
    %Top.Display Rank: $regml(IdleTop,1) - $regml(IdleTop,2) $+([Level:,$regml(IdleTop,3),])
  }
  ; The only time this should actually hit is at the end of output from the socket.
  else {
    ; Call the cleanup alias.
    .timerCLEANUP 1 5 CleanUp
  }
}

; We use this to remove variables at the end of script.
alias -l CleanUp {
  unset %Top.Display
  unset %Top
  unset %IdleTop
}
