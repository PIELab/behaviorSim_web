% include ('tpl/pageBits/header')

<body>
    <p>
        Now let's dive a little deeper and think about what each connection between variables means.
    </p>
    
    <br>
    
    <div id='infoFlow'>
        YOUR DIAGRAM HERE
    </div>
    
    <br>

    <p>
        Let's start out with the "source verticies" (variables without any inflows). Since they have no variables going into them, we have to make an assumption about how they change over time. 
    </p>

    <div>
        <div class="inline">
            <div>
                ZOOMED IN VIEW OF CURRENT NODE
            </div>
            <div>
                Selected Node
            </div>
        </div>
        <div class="inline">
            <div>
		         <div class="inline">
		             For VAR NAME, 
		         </div>
		         <div class="inline">
		             PULLDOWNSELECTBOX
		         </div>
            </div>
            <div class="inline">
                OPTIONS FOR SELCTION
            </div>
            <div class="inline">
                TIME SERIES FOR NODE
            </div>
        </div>


    </div>

	<div>
    <a href="#" class="disabledButton">Previous Node</a>
    <a href="#" class="myButton">Next Node</a>
    <a href="#" class="disabledButton">Done</a>
   </div>
	%include('tpl/pageBits/nav')
</body>
