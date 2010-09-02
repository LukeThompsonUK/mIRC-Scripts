on *:TEXT:!NumberGame:#:{
  if (%NumberGame) { echo -a Game already running, /GuessNumber numberhere to play! }
  else { 
    set %NumberGame.Answer $r(1,9999) 
    msg $chan Random number set, goodluck!
    msg $chan !GuessNumber numberhere to guess!
  }
}
on *:TEXT:!GuessNumber*:#:{
  if ($2 == %NumberGame.Answer) { 
    msg $chan You won! The number was %NumberGame.Answer
    unset %NumberGame 
    unset %NumberGame.Answer
  }
  elseif ($2 > %NumberGame.Answer) { msg $chan Lower... }
  elseif ($2 < %NumberGame.Answer) { msg $chan Higher... }
}
