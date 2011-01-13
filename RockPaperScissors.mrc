alias RPS {
  if (!$1) { 
    echo -a Syntax:
    echo -a rps rock
    echo -a rps paper
    echo -a rps scissors
  }
  else { 
    var %Opponent = $r(1,3)

    if (%Opponent == 1) { 
      %Opponent = Rock 
    }
    elseif (%Opponent == 2) { 
      %Opponent = Paper 
    }
    else { 
      %Opponent = Scissors 
    }
  }

  if ($1 == Rock) {
    if (%Opponent = Rock) { 
      echo -a It's a tie! You're both Rock! 
    }
    elseif (%Opponent = Paper) {
      echo -a You lose! Opponent was Paper! 
    }
    elseif (%Opponent = Scissors) { 
      echo -a You win! Opponent was Scissors! 
    }
  }
  elseif ($1 == Paper) {
    if (%Opponent = Rock) { 
      echo -a You win! Opponent was Rock! 
    }
    elseif (%Opponent = Paper) { 
      echo -a It's a tie! You're both Paper! 
    }
    elseif (%Opponent = Scissors) { 
      echo -a You lose! Opponent was Scissors 
    }
  }
  elseif ($1 == Scissors) {
    if (%Opponent = Rock) { 
      echo -a You lose! Opponent was Rock! 
    }
    elseif (%Opponent = Paper) { 
      echo -a You win! Opponent was Paper! 
    }
    elseif (%Opponent = Scissors) { 
      echo -a It's a tie! Opponent was Scissors! 
    }
  }
}
