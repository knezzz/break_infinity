import 'dart:math';

double log10(num num) {
  return log10e * log(num);
}

const int indexOf0InPowersOf10 = 323;
const double expn1 = 0.36787944117144232159553; // exp(-1)
const double omega = 0.56714329040978387299997;

int maxSignificantDigits = 17; //Maximum number of digits of precision to assume in Number

/// If we're ABOVE this value, increase a layer. (9e15 is close to the largest double eger that can fit in a int.)
const double expLimit = 9e15;
double layerDown = log10(expLimit); //If we're BELOW this value, drop down a layer. About 15.954.

///At layer 0, smaller non-zero numbers than this become layer 1 numbers with negative mag. After that the pattern continues as normal.
double firstNegLayer = 1 / expLimit;

int numberExpMax = 308; //The largest exponent that can appear in a Number, though not all mantissas are valid here.
int numberExpMin = -324; //The smallest exponent that can appear in a Number, though not all mantissas are valid here.
int maxEsInRow = 5; //For default toString behaviour, when to swap from eee... to (e^n) syntax.
