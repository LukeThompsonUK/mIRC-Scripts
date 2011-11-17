on ^*:TEXT:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (!$window(@AwayMessages)) { 
      window -nz @AwayMessages 
    }

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    haltdef
  }
}


on ^*:ACTION:*:#:{
  if ($regex($1-,/^is?(?:\x20am)?\x20(?:now\x20)?(away|back).?(?:\x20reason:?(?:\x20was:?)?|-)?\x20(.+)$/Si) != 0) {
    if (!$window(@AwayMessages)) { 
      window -nz @AwayMessages 
    }

    aline -ph @AwayMessages $timestamp $($+(07,$regml(1),:),2) $($+(12[10,$network,12:10,$chan,12:10,$nick,$iif($regml(2),12]10:,12])),2) $regml(2)

    haltdef
  }
}