on *:TEXT:!RPS*:#:{
  if (!$2) { 
    msg $chan Syntax:
    msg $chan /rps rock
    msg $chan /rps paper
    msg $chan /rps scissors
  }
  else { 
    var %Opponent = $r(1,3)
    if (%Opponent == 1) { %Opponent = Rock }
    elseif (%Opponent == 2) { %Opponent = Paper }
    else { %Opponent = Scissors }
  }
  if ($2 == Rock) {
    if (%Opponent = Rock) { msg $chan It's a tie! You're both Rock! }
    elseif (%Opponent = Paper) { msg $chan You lose! Opponent was Paper! }
    elseif (%Opponent = Scissors) { msg $chan You win! Opponent was Scissors! }
  }
  elseif ($2 == Paper) {
    if (%Opponent = Rock) { msg $chan You win! Opponent was Rock! }
    elseif (%Opponent = Paper) { msg $chan It's a tie! You're both Paper! }
    elseif (%Opponent = Scissors) { msg $chan You lose! Opponent was Scissors }
  }
  elseif ($2 == Scissors) {
    if (%Opponent = Rock) { msg $chan You lose! Opponent was Rock! }
    elseif (%Opponent = Paper) { msg $chan You win! Opponent was Paper! }
    elseif (%Opponent = Scissors) { msg $chan It's a tie! Opponent was Scissors! }
  }
}
