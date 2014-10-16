`
function plot_personality_var_pdf(sigma, mu, highlight, selector_string){
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
    var left = mu - plot_range;
    var right = mu + plot_range;
    console.log('stoch plot: mu='+mu+', sigma='+sigma+', range=['+left+','+right+'], step='+plot_step);
    for (var i = left; i <= right; i += plot_step)
        dd.push([i, density(i)]);

    var d1 = {
        label: "PDF",
        data: dd,
        points: {show: false},
        lines: {show: true}

    };
    var d2 = {
        label: "Selected Value",
        data: [[highlight, density(highlight)]],
        points: {show: true},
        lines: {show: false}
    };

    try{
        $.plot(selector_string, [d1, d2]);
    }catch (err){
        console.log(dd);
        console.log(selector_string);
        throw err
    }

}
`

draw_stochastic_graph = () ->
    selected_value = .7
    if model_builder.get_selected_node_type() == 'personality-var-options'
        try
            sigma = parseInt(simulator.get_node_spec_parameter(model_builder.selected_node, 'sigma'))
            mu = parseInt(simulator.get_node_spec_parameter(model_builder.selected_node, 'mu'))
        catch error
            if error.message.split(':')[0] == "node not found, id" or error.message.split("'")[0] == 'Cannot read property '
                sigma = 1
                mu = 0
            else
                console.log('ERR getting stochastic parameters')
                throw error
        $('#selected-node-stochastic').height('15em')
        plot_personality_var_pdf(sigma, mu, selected_value, '#selected-node-stochastic')

    else
        $('#selected-node-stochastic').html('')
        $('#selected-node-stochastic').height(0)

model_changed_event.add_action(draw_stochastic_graph)
node_selection_changed.add_action(draw_stochastic_graph)

$listen document.getElementById('personality-spec_sigma'), 'change', =>
    stochastic_graph()
    
$listen document.getElementById('personality-spec_mu'), 'change', =>
    stochastic_graph()