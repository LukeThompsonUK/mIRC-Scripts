/saway {
  if ($1) {
    ; if ((!$away) && ($1)) {
    scon -at1 /away $1-
    echo 10 -at * Away: $1-
  }
  elseif (!$1) {
    if (!$away) { echo 10 -at * Error, not away. }
    else {
      echo 10 -at * Away Time: $duration($awaytime)
      scon -at1 /away
      echo 10 -at * Back from: $awaymsg
    }
  }
  else { echo 10 -at * It appears you errored somewhere in the script }
}