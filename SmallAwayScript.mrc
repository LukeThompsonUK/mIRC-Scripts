alias saway {
  if ($1) {
    if ($away) { 
      scon -at1 away $1-
      echo 10 -at * Away reason changed to: $1-
    }
    else {
      scon -at1 away $1-
      echo 10 -at * Away: $1-
    }
  }
  elseif (!$1) {
    if (!$away) { 
      echo 10 -at * Error, not away. 
    }
    else {
      echo 10 -at * Away Time: $duration($awaytime)

      scon -at1 away
      echo 10 -at * Back from: $awaymsg
    }
  }
  else { 
    echo 10 -at * It appears you errored somewhere in the script 
  }
}


menu channel,status,nicklist {
  Away
  .Set yourself as away: /saway $?="Enter reason for going away"
  .Come back from away: /saway
}
