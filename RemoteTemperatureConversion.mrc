/*
This script is used to convert tempature between two scales.
Usage: !Temp SCALE TEMPERATURE
Example: /Temp F 94.5
Supported scales:
- F (Fahrenheit)
- C (Celsius)
*/

on $*:TEXT:/^[!@.]Temp\s([FC])\s(-?\d+)$/Si:#:{
  ; $regml(2) will be the temperature to convert
  ; $regml(1) will be the scale you're using, it'll convert to the other.
  if ($regml(2) isnum) {
    if (F == $regml(1)) {
      msg $chan 07 $+ $regml(2) in Fahrenheit is: $calc(($regml(2) - 32) * 5/9) in Celsius.
    }
    elseif (C == $regml(1)) {
      msg $chan 07 $+ $regml(2) in Celsius is: $calc($regml(2) * (9/5) + 32) in Fahrenheit.
    }
  }
}
