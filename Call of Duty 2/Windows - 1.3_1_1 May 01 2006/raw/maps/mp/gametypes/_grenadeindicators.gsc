init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread updateGrenadeIndicators();
	}
}

updateGrenadeIndicators()
{
	self endon("disconnect");
	
	for(;;)
	{
		// Fullscreen scale
		self setClientCvar("cg_hudGrenadeIconHeight", "25");
		self setClientCvar("cg_hudGrenadeIconWidth", "25");
		self setClientCvar("cg_hudGrenadeIconOffset", "50");
		//self setClientCvar("cg_hudGrenadeIconInScope", "0");
		//self setClientCvar("cg_hudGrenadeIconMaxRange", "250");
		self setClientCvar("cg_hudGrenadePointerHeight", "12");
		self setClientCvar("cg_hudGrenadePointerWidth", "25");
		self setClientCvar("cg_hudGrenadePointerPivot", "12 27");
		self setClientCvar("cg_fovscale", "1");

		while(!isSplitScreen())
			wait .05;
			
		// Splitscreen scale
		self setClientCvar("cg_hudGrenadeIconHeight", "37.5");
		self setClientCvar("cg_hudGrenadeIconWidth", "37.5");
		self setClientCvar("cg_hudGrenadeIconOffset", "75");
		//self setClientCvar("cg_hudGrenadeIconInScope", "0");
		//self setClientCvar("cg_hudGrenadeIconMaxRange", "250");
		self setClientCvar("cg_hudGrenadePointerHeight", "18");
		self setClientCvar("cg_hudGrenadePointerWidth", "37.5");
		self setClientCvar("cg_hudGrenadePointerPivot", "18 40.5");
		self setClientCvar("cg_fovscale", ".75");
		
		while(isSplitScreen())
			wait .05;
	}
}
