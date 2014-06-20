% include('tpl/pageBits/header')

<body>
	<p class="textBox">
        Now we need to <b>draw</b> the connections between variables in your model. We can do this in many different ways, but in all ways we will use "network" graphs with "nodes" (for variables), "edges" (arrows) to show the connections between them. A short description of each graphing method is shown below, but more explaination will be given as you move foward.
    </p>

    <table border="1" >
        <tr>
            <td>	<a href="#" class="disabledButton">Probabalistic Graphical Model</a></td>
            <td>Edges contain coefficient weights that add at each node. This can be used to represent layers of linear combinations, and is the simplest graphical model used here. Non-linear functions and delay/decay time considerations are not included.</td>
        </tr>
        <tr>
            <td><a href="#" class="disabledButton" >Mediator/Moderator graph</a></td>
            <td>This graphical model builds on the probabilistic graphical model to allow for specification of mediator/moderator relationships specifically. This model is particularly useful for users already familar with describing variable relationships in terms of mediators & moderators. </td>
        </tr>
        <tr>
            <td><a href="#" class="disabledButton" >Fluid-Flow Analogy</a></td>
            <td>Building even further upon the mediator/moderator graph, this graphical model treats the flow of information between variables as a fluid, allowing for more modeling detail focused around time-latency, delay of effect, and others.</td>
        </tr>
        <tr>
            <td><a href="/draw/infoFlow" class="myButton">Information-Flow Graph</a></td>
            <td>This graph describes only informational dependencies between variables, meaning that a formulation must be chosen for each individual node in the graph. Though tedious, this method allows for the most control over the model and is the most general.</td>
        </tr>
    </table>

	%include('tpl/pageBits/nav')
</body>
