; Trivia Script
; by Shawn Smith
; Provids the start and stop trivia command.
on $*:TEXT:/^!(s)?trivia$/Si:#Trivia:{
  if ((!trivia isin $1) && (!%Trivia)) { set %trivia ON | /setnewq }
  elseif (!trivia isin $1) { .msg $chan There is currently a Trivia game running. Type !Question to see the current question. }
  elseif (!strivia isin $1) { .timerSETNEWQ off | .timerTimesUp off | unset %Trivia | unset %NextQ | unset %Ans | unset %hint | .msg #Trivia Trivia Stopped. }
}
; Provides the rank command
on $*:TEXT:/^!rank(\s.+)?$/Si:#Trivia:{
  if (!$2) {
    var %nick $replace($nick,],$chr(41),[,$chr(40))
    if (!$readini(TriviaScores.ini,n,$network,%nick)) { .msg #Trivia $nick has 0 points. }
    else { .msg $chan $nick has $readini(TriviaScores.ini,n,$network,%nick) $iif($readini(TriviaScores.ini,n,$network,%nick) == 1,Point!,Points!) }
  }
  else { 
    var %nick $replace($2,],$chr(41),[,$chr(40))
    if (!$readini(TriviaScores.ini,n,$network,%nick)) { .msg #Trivia $2 has 0 points. }
    else { .msg $chan $2 has $readini(TriviaScores.ini,n,$network,%nick) $iif($readini(TriviaScores.ini,n,$network,%nick) == 1,Point!,Points!) }
  }
}
; Provides the command to ask what the current question is.
on $*:TEXT:/^!Q(uestion)?$/Si:#Trivia:{
  if (%NextQ) {
    if (!%Question.Spam) { .msg $chan The current question is: %NextQ | .msg $chan The answer space is: $regsubex(%ans,/\S/g,*) }
    inc -u10 %Question.Spam
  }
  else { .Msg $chan The Trivia game is currently off or is waiting for a new question to be set. If a new question as not been set within 5 seconds; type 7!Trivia to start a new game. }
}
; Provides the hint commant
on $*:TEXT:/^!h(int)?$/Si:#Trivia:{
  inc %hint
  if (%hint < 4) { var %Len $floor($calc($Len(%Ans) *(.75/ %hint))) }
  else { msg $chan You've used 3 hints on this question and displayed 75% of the answer. Try guessing or use !Skip if you can not answer it. | halt }
  .msg $chan Your hint is: $hint(%Ans,%Len)
  .ignore -u5 $address($nick,5)
  .notice $nick You've been ignored for 5 seconds for using the !hint command.
}
alias hint {
  var %b $1
  while $count(%b,*) < $len($remove(%b,$chr(32))) && $v1 < $calc($replace($2,%,/100* $v2)) {
    var %a $r(1,999)
    if $mid(%b,%a) >= ! {
      if * $+ $mid($v1,2) {
      }
    }
    %b = $left(%b,$({,%a)) $+ $v1
  }
  return %b
} 
on *:TEXT:!Credits:*:{
  if (!%Credit.Spam. $+ $nick) { msg $nick $Credits }
  inc -u10 %Credit.Spam. $+ $nick
}
; Skips the current question.
on *:TEXT:!Skip:#Trivia:{ .timerTimesUp off | unset %hint, %ans, %PrevWinner, %WinRow | /setnewq }
on *:TEXT:*:#Trivia:{
  if ($istok($1-,%ans,42)) { 
    .TimerTimesUp off
    var %nick $replace($nick,],$chr(41),[,$chr(40))
    writeini TriviaScores.ini $Network %nick $calc($readini(TriviaScores.ini,n,$network,%nick) +1)
    if ($nick = %PrevWinner) { inc %WinRow }
    else { set %WinRow 1 | set %PrevWinner $nick }
    .msg #Trivia $nick is correct! The answer was %ans $+ . $iif(%WinRow > 1,$nick has got the last %WinRow questions right!,)
    unset %ans
    unset %hint
    .msg #Trivia $nick now has: $readini(TriviaScores.ini,n,$network,%nick) $iif($readini(TriviaScores.ini,n,$network,%nick) == 1,point!,points!)
    if ($readini(TriviaScores.ini,n,$network,%nick) == 500) { msg $chan Congratulations $nick $+ ! You just recieved your 500th point and have been given voice access! | ChanServ access $chan add $nick 3 | mode $chan +v $nick }
    .TimerTimesUp off
    .timerSETNEWQ 1 5 /setnewq
  }
}
; Run out of time and set a new question.
alias -l TimesUp {
  .msg #Trivia Times up! The answer was %Ans - Setting new question..
  unset %Ans, %hint, %PrevWinner, %WinRow
  /setnewq
}
; Set a new question
alias -l setnewq {
  var %Prev $readn
  var %QNum $Lines(RuneScape.txt)
  var %Next $read(RuneScape.txt)
  if ($gettok(%Next,1,42) == Scramble) { set %NextQ Unscramble the following: $scramble($gettok(%Next,2,42)) }
  else { set %NextQ $gettok(%Next,1,42) }
  set %Ans $gettok(%next,2-,42)
  if (%Next == %Prev) { /setnewq }
  else { 
    .msg #Trivia %NextQ 
    .msg #Trivia Answer Space: $regsubex(%ans,/\S/g,*)
  }
  .timerTimesUp 1 60 /TimesUp
}
; Used for the scrable
alias -l scramble {
  tokenize 32 $1-
  var %i = 1, %temp.smbl
  while (%i <= $0) {
    var %word = $eval($+($,%i),2)
    while (%word != $null) { var %rand = $rand(1, $len(%word)), %temp.smbl = %temp.smbl $+ $mid(%word, %rand, 1), %word = $left(%word, $calc(%rand - 1)) $+ $right(%word, $calc(-1 * %rand)) }
    %temp.smbl = %temp.smbl $+ ;
    inc %i
  }
  return $lower($replace(%temp.smbl,;,$chr(32)))
}

on *:disconnect:{ unset %Trivia | unset %NextQ | unset %Ans | unset %hint | echo -a It seems we've disconnected from $network $+ . Stopping the Trivia game. }
on *:BAN:#:{
  if (($me isop $chan) || ($me ishop $chan)) {
    var %x = 2, %i = 0, %BanMask
    if ($modefirst) { 
      while (%x <= $0) {
        if ($($+($,%x),2) iswm $ial($me)) { inc %i | %BanMask = %BanMask $($+($,%x),2) }
        inc %x
      }
      mode $chan - $+ $str(b,%i) %BanMask
    }
  }
}
on *:Kick:#Trivia:{ if ($me == $knick) { join $Chan } }
on *:PART:#Trivia:{
  if (!%Trivia.Part.Spam. [ $+ [ $nick ] ]) {
    var %Nick $replace($nick,],$chr(41),[,$chr(40))
    .msg $nick Aww...Why did you leave? $iif($readini(TriviaScores.ini,n,$network,%Nick) > 0,Your score is $readini(TriviaScores.ini,n,$network,%nick) $+ . You should come back and play more later to keep it high!,You currently don't seem to have a score! Come play soon and see how high you can get it!)
    invite $nick $chan
  }
  inc -u7 %Trivia.Part.Spam. [ $+ [ $nick ] ]
}
on *:START:{
  echo -sg Trivia Script written by Shawn Smith
  echo -sg All future (Official) releases of this script will be released on HomelessHackers.net
  echo -sg Any alteration to this code (for what-ever reason) should be posted in a reply
  echo -sg to the origial release post on HomelessHackers.net
}
alias -l Credits {
  ; For everyone else who starts editing this script after it's release, feel free to add
  ; your name to the credits list using a comma, ex: return Shawn Smith, Next Name, Name 3, Etc
  return Original Coder: Shawn Smith - Contributers: Chris Logan(Questions)
}
on ^*:TEXT:*:#:{
  ; This is used to catch all other commands and hide them from showing in the channel windows, so we don't have to use more ram holding them in memory.
  haltdef
}
