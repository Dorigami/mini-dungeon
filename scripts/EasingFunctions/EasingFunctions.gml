// in most cases, {x} must be a value 0 <= x <= 1
//--// Ease In
function easeInSine(x) {
	return 1 - cos((x * pi) / 2);
}
function easeInCubic(x) {
	return x * x * x;
}
function easeInQuint(x) {
	return x * x * x * x * x;
}
function easeInCirc(x){
	return 1 - sqrt(1 - power(x, 2));
}
function easeInElastic(x) {
	var c4 = (2 * pi) / 3;

	return x == 0 ? 0 : 
	       (x == 1 ? 1 : -power(2, 10 * x - 10) * sin((x * 10 - 10.75) * c4));
}
//--// Ease Out
function easeOutSine(x) {
  return sin((x * pi) / 2);
}
function easeOutQuad(x) {
	return 1 - (1 - x) * (1 - x);
}
function easeOutCubic(x) {
	return 1 - power(1 - x, 3);
}
function easeOutQuart(x) {
	return 1 - power(1 - x, 4);	
}
function easeOutQuint(x) {
	return 1 - power(1 - x, 5);
}
function easeOutExpo(x) {
	return x == 1 ? 1 : 1 - power(2, -10 * x);
}
function easeOutCirc(x) {
	return sqrt(1 - power(x - 1, 2));
}
function easeOutBack(x) {
	var c1 = 1.70158;
	var c3 = c1 + 1;

	return 1 + c3 * power(x - 1, 3) + c1 * power(x - 1, 2);
}
function easeOutElastic(x) {
	var c4 = (2 * pi) / 3;

	return x == 0 ? 0 : 
		   (x == 1 ? 1 : power(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1);
}
function easeOutBounce(x) {
	var n1 = 7.5625;
	var d1 = 2.75;

	if (x < 1 / d1) {
	    return n1 * x * x;
	} else if (x < 2 / d1) {
	    return n1 * (x - 1.5 / d1) * x + 0.75;
	} else if (x < 2.5 / d1) {
	    return n1 * (x - 2.25 / d1) * x + 0.9375;
	} else {
	    return n1 * (x - 2.625 / d1) * x + 0.984375;
	}
}

//-// Ease In-Out
function easeInOutSine(x) {
	return -(cos(pi * x) - 1) / 2;
}
function easeInOutCubic(x) {
	return x < 0.5 ? 4 * x * x * x : 1 - power(-2 * x + 2, 3) / 2;
}
function easeInOutQuint(x) {
	return x < 0.5 ? 16 * x * x * x * x * x : 1 - power(-2 * x + 2, 5) / 2;
}
function easeInOutCirc(x) {
	return x < 0.5
	  ? (1 - sqrt(1 - power(2 * x, 2))) / 2
	  : (sqrt(1 - power(-2 * x + 2, 2)) + 1) / 2;
}
function easeInOutElastic(x) {
	var c5 = (2 * pi) / 4.5;

	return x == 0 ? 0 : 
		   (x == 1 ? 1 : 
		   (x < 0.5 ? -(power(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2 : (power(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1));
}