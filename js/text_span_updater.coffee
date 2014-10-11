`
function update_selected_node_texts(){
    // updates all tspans of class selected_node_text to display new node name
    // and tspans of class node_inflow_count to contain proper count
    $('.selected_node_text').text(model_builder.selected_node);
    $('.node_inflow_count').text(getInputsOf(model_builder.selected_node).length);
    $('.selected_node_functional_form').text(model_builder.get_selected_node_functional_form())
}
`

model_changed_event.add_action(update_selected_node_texts)
node_selection_changed.add_action(update_selected_node_texts)