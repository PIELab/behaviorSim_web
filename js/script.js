 
 
 /*
  Next steps:
  
  - have it only initialize for new users
  - have it as a link as an optional tutorial for existing users
  -  
  
  
  
  
  
  */
 
 
 
 (function() {
	 var init, setupShepherd;
	 
	 init = function(){
		 return setupShepherd();
	 };

 	
 	
	
	setupShepherd = function() {
        	var tour;
        	
        	tour = new Shepherd.Tour({
        	defaults: {
        	classes: 'shepherd-theme-arrows', 
        	
        	showCancelLink: true
        	}
        	});
        	
        	// .content-header bottom
        	
        	tour.addStep('First Step', {
        	text: 'Welcome to BehaviorSIM!',
        	attachTo: '.content-header bottom',
        	buttons: [
        			{
        			text: 'Let\'s begin!',
        			action: tour.next
        			}
        			]
        		});
        	
        	
        	// attach to #canvas
        	tour.addStep('Canvas Intro', {
        	text: 'Here is where you can build your model and test several things!',
        	attachTo: '#canvas bottom',
        	buttons: [
        			{
        			text: 'Next!',
        			action: tour.next
        			}
        			]
        		});
        	
        		// attach to bottom of title above DSL Box  
        	tour.addStep('DSL Intro', {
        	text: 'Here you can program your flowchart using DSL!',
        	attachTo: '.title bottom',
        	buttons: [
        			{	
        			text: 'Next',
        			action: tour.next
        			}
        			]
        		});
        	
        	// #node-spec-box
        	tour.addStep('Mathematical Model', {
        	text: 'Here is the mathematical model for your model!',
        	attachTo: '#node-spec-box',
        	buttons: [
        			{
        			text: 'Let\'s get Started!',
        			action: tour.complete
        			}
        			]
        		});
        	
        	
        return tour.start();
    };
        	
      $(init);
      
  }).call(this);  