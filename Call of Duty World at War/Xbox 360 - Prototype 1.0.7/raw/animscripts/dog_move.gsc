#using_animtree ("dog");

main()
{
	self endon("killanimscript");
	//self endon("movemode");

	self clearanim(%root, 0.1);

	if ( !isdefined( self.traverseComplete ) )
	{	
		self.traverseComplete = undefined;
		self clearanim(%german_shepherd_run_start, 0);
		self setflaggedanimrestart("dog_prerun", %german_shepherd_run_start, 1, 0.2, 1);

		self waittillmatch( "dog_prerun", "end" );
	}

	self clearanim(%german_shepherd_run_start, 0);

	weights = self getRunAnimWeights();
	
	self setanimrestart(%german_shepherd_run, weights["center"], 0, 1);
	self setanimrestart(%german_shepherd_run_lean_L, weights["left"], 0.1, 1);
	self setanimrestart(%german_shepherd_run_lean_R, weights["right"], 0.1, 1);
	
	while (1)
	{
		wait 0.05;

		weights = self getRunAnimWeights();

		self setanim(%german_shepherd_run, weights["center"], 0.2, 1);
		self setanim(%german_shepherd_run_lean_L, weights["left"], 0.2, 1);
		self setanim(%german_shepherd_run_lean_R, weights["right"], 0.2, 1);
	}
}

getRunAnimWeights()
{
	weights = [];
	weights["center"] = 0;
	weights["left"] = 0;
	weights["right"] = 0;
	
	if ( self.leanAmount > 0 )
	{
		if ( self.leanAmount < 0.95 )
			self.leanAmount	= 0.95;

		weights["left"] = 0;
		weights["right"] = (1 - self.leanAmount) * 20;

		if ( weights["right"] > 1 )
			weights["right"] = 1;	
		else if ( weights["right"] < 0 )
			weights["right"] = 0;	
			
		weights["center"] = 1 - weights["right"];
	}
	else if ( self.leanAmount < 0 )
	{
		if ( self.leanAmount > -0.95 )
			self.leanAmount	= -0.95;

		weights["right"] = 0;
		weights["left"] = (1 + self.leanAmount) * 20;

		if ( weights["left"] > 1 )
			weights["left"] = 1;
		if ( weights["left"] < 0 )
			weights["left"] = 0;		

		weights["center"] = 1 - weights["left"];
	}
	else
	{
		weights["left"] = 0;
		weights["right"] = 0;
		weights["center"] = 1;		
	}
	
	return weights;
}