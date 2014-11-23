
function VertexStack(vertices) {
    this.vertices = vertices || [];
}
VertexStack.prototype = {
    contains: function(vertex){
        for (var i in this.vertices){
            if (this.vertices[i].equals(vertex)){
                return true;
            }
        }
        return false;
    }
};

function Tarjan(graph) {
    this.index = 0;
    this.stack = new VertexStack();
    this.graph = graph;
    this.scc = [];

    // reset trajan alg. node values
    for (var node in graph.nodes){
        this.graph.nodes[node].index= -1;
        this.graph.nodes[node].lowlink = -1;
    }
}
Tarjan.prototype = {
    run: function(){
        for (var i in this.graph.nodes){
            if (this.graph.nodes[i].index<0){
                console.log('root node:', this.graph.nodes[i]);
                this.strongconnect(this.graph.nodes[i]);
                console.log('RIP node:', this.graph.nodes[i]);
            } else {
                console.log('node already done: ',this.graph.nodes[i])
            }
        }
        return this.scc;
    },
    strongconnect: function(vertex){
        console.log('node:', vertex);
        // Set the depth index for v to the smallest unused index
        vertex.index = this.index;
        vertex.lowlink = this.index;
        this.index = this.index + 1;
        this.stack.vertices.push(vertex);

        // Consider successors of v
        // aka... consider each vertex in vertex.children
        for (var i in vertex.children) {
            var v = vertex;
            var w = this.graph.get_node(vertex.children[i]);
            console.log('\tchild:', w);
            if (w.index === undefined){
                console.log('\t\tw:', w, ', w.index:', w.index);
                throw Error('nodes not properly initialized!');
            } else if (w.index<0 ){
                console.log('\t\tunvisited');
                // Successor w has not yet been visited; recurse on it
                this.strongconnect(w);
                v.lowlink = Math.min(v.lowlink,w.lowlink);
            } else if (this.stack.contains(w)){
                console.log('\t\tin current scc')
                // Successor w is in stack S and hence in the current SCC
                v.lowlink = Math.min(v.lowlink,w.index);
            } else {
                console.log('\t\tno loops');
                console.log('\t\tindex:', w.index);
            }
        }

        // If v is a root node, pop the stack and generate an SCC
        if (vertex.lowlink==vertex.index){
            console.log('\tnew scc:', vertex.name);
            // start a new strongly connected component
            var vertices = [];
            var w = null;
            if (this.stack.vertices.length>0){
                do {
                    w = this.stack.vertices.pop();
                    // add w to current strongly connected component
                    vertices.push(w);
                } while (!vertex.equals(w));
            }
            // output the current strongly connected component
            // ... i'm going to push the results to a member scc array variable
            if (vertices.length>0){
                this.scc.push(vertices);
            }
        }
        console.log('done w/ node:', vertex);
    }
};