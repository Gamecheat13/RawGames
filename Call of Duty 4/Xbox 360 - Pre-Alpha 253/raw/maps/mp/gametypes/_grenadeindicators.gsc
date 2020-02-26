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
	if ( level.splitScreen )
	{
		// Splitscreen scale
		//self setclientdvar("cg_hudGrenadeIconInScope", "0");
		//self setclientdvar("cg_hudGrenadeIconMaxRange", "250");
		//self setclientdvar("cg_fovscale", ".75");
		self setclientdvars("cg_hudGrenadeIconHeight", "37.5", 
							"cg_hudGrenadeIconWidth", "37.5", 
							"cg_hudGrenadeIconOffset", "75", 
							"cg_hudGrenadePointerHeight", "18", 
							"cg_hudGrenadePointerWidth", "37.5", 
							"cg_hudGrenadePointerPivot", "18 40.5", 
							"cg_fovscale", "1" );
	}
	else
	{
		// Fullscreen scale
		//self setclientdvar("cg_hudGrenadeIconInScope", "0");
		//self setclientdvar("cg_hudGrenadeIconMaxRange", "250");
		self setclientdvars("cg_hudGrenadeIconHeight", "25", 
							"cg_hudGrenadeIconWidth", "25", 
							"cg_hudGrenadeIconOffset", "50", 
							"cg_hudGrenadePointerHeight", "12", 
							"cg_hudGrenadePointerWidth", "25", 
							"cg_hudGrenadePointerPivot", "12 27", 
							"cg_fovscale", "1");
	}
}
