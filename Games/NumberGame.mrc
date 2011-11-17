; One of those 'Guess what number' games.
; /NumberGame to start
; /GuessNumber <number> to play.

alias NumberGame {
  if (%NumberGame) { 
    echo -a Game already running, /GuessNumber numberhere to play! 
  }
  else { 
    set %NumberGame.Answer $r(1,9999) 
  
    echo -a Random number set, goodluck!
    echo -a /GuessNumber numberhere to guess!
  }
}


alias GuessNumber { 
  if ($1 == %NumberGame.Answer) { 
    echo -a You won! The number was %NumberGame.Answer

    unset %NumberGame 
    unset %NumberGame.Answer
  }
  elseif ($1 > %NumberGame.Answer) { 
    echo -a Lower... 
  }
  elseif ($1 < %NumberGame.Answer) { 
    echo -a Higher... 
  }
}
