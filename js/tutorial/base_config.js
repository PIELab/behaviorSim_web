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

// sample data to use for SE
function sampleData(start, stop, stp_strt_percent, stp_stop_percent, low, high){
    // returns array of x,y points between time start & stop with a step function in it
    var t_step = 1;

    var range = stop-start;
    var stp_strt = stp_strt_percent*range+start;
    var stp_stop = stp_stop_percent*range+start;

    var arr = [];
    for (var i = start; i<stop; i = i+t_step){
        if (i < stp_strt){
            //before step
            arr.push({x: i, y: low})
        } else if( i < stp_stop){
            // in step
            arr.push({x: i, y: high})
        } else {
            // after step
            arr.push({x: i, y: low})
        }
    }
    return arr;
}