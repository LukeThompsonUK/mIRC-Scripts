/*
This script is used to convert tempature between two scales.
Usage: !Temp SCALE TEMPERATURE
Example: /Temp F 94.5
Supported scales:
- F (Fahrenheit)
- C (Celsius)
*/

on *:TEXT:!Temp*:#:{
  ; $3 will be the temperature to convert
  ; $2 will be the scale you're using, it'll convert to the other 2 scales.
  if ($3 isnum) {
    if (F == $2) {
      msg $chan 07 $+ $3 in Fahrenheit is:
      msg $chan 07 $+ $calc(($3 - 32) * 5/9) in Celsius.
    }
    elseif (C == $2) {
      msg $chan 07 $+ $3 in Celsius is:
      msg $chan 07 $+ $calc($3 * (9/5) + 32) in Fahrenheit.
    }
  }
}
