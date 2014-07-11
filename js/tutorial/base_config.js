 // TODO: add start_time & make time-steps in days...
var timeStart = 0;
var timeStop  = 15;

function sign(x) {
    // returns the sign of a number as +-1
    return typeof x === 'number' ? x ? x < 0 ? -1 : 1 : x === x ? 0 : NaN : NaN;
}

// functions for converting UI slider values into more interesting model values
function mapThresh(percent){
    return percent/10;
}
function mapScale(percent){
    return percent/10;
}

var thresh = mapThresh(10);
var scale  = mapScale(70);