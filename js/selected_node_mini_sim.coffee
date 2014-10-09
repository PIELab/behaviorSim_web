`
function plot_personality_var_pdf(sigma, mu, selector_string){
    /*
    creates the bell curve plot
    */
    console.log('plot personality var pdf', sigma, mu, selector_string)
    if (!sigma){
        var sigma = 1.0;
    }
    if (!mu){
        var mu = 0.0;
    }
    if (!selector_string){
        var selector_string = '#Placeholder';
    }
    
    function density(x) {
        return 1 / (sigma*Math.sqrt(2*Math.PI)) * Math.exp(-(x-mu)*(x-mu)/(2*sigma*sigma));
    }
    
    var plot_range = sigma*4.0;
    var plot_step = sigma/8.0;
    var dd = [];
    for (var i = mu-plot_range; i <= mu+plot_range; i += plot_step)
        dd.push([i, density(i)]);
    var d1 = {
                label: "Gaussian",
                data: dd
    };
    var d2 = {marks: { show: true }, data: [], markdata: [
        {label: '3&sigma;', position: -3.0, row: 0},
        {label: '2&sigma;', position: -2.0, row: 0},
        {label: '&sigma;', position: -1.0, row: 0},
        {label: '&sigma;', position: 1.0, row: 0},
        {label: '2&sigma;', position: 2.0, row: 0},
        {label: '3&sigma;', position: 3.0, row: 0}
    ]};

    $.plot($(selector_string), [ d1, d2 ], {
        xaxis: { min: -plot_range*sigma, max: plot_range*sigma }
    });
}
`

stochastic_graph = () ->
    plot_personality_var_pdf(
        $('#personality-spec_sigma').html(), 
        $('#personality-spec_mu').html(), 
        '#selected-node-stochastic')

$listen document.getElementById('personality-spec_sigma'), 'change', =>
    stochastic_graph()
    
$listen document.getElementById('personality-spec_mu'), 'change', =>
    stochastic_graph()