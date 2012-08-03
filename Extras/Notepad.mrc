/**
* Script Description
** Opens a notepad for you to write in.
** Note: Does NOT save when closed.
*
* Configuration Settings / Commands:
** /notepad ( Opens the notepad )
*/

alias notepad {
  if (!$window(@Notepad)) { 
    window -nezg1 @Notepad 
  }
}

on *:INPUT:@Notepad:{ 
  aline -ph @Notepad $1- 
}
