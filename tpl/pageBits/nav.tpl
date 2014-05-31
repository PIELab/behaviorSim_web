

<div>
	<a 
		% if simManager.measurementsSet: 
			href='/think' class='navLink'>
		% else:
			href='#' class='navLink_disabled'>
		% end
	Think</a>
	↦
	<a 
		% if simManager.measurementsSet: 
			href='/draw' class='navLink'>
		% else:
			href='#' class='navLink_disabled'>
		% end
	Draw</a>
	↦
	<a 
		% if simManager.measurementsSet: 
			href='/specify' class='navLink'>
		% else:
			href='#' class='navLink_disabled'>
		% end
	Specify</a>

</div>

