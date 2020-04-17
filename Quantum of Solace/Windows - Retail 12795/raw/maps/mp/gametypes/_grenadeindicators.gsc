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
		self setclientdvar("cg_hudGrenadeIconHeight", "37.5");
		self setclientdvar("cg_hudGrenadeIconWidth", "37.5");
		self setclientdvar("cg_hudGrenadeIconOffset", "75");
		//self setclientdvar("cg_hudGrenadeIconInScope", "0");
		//self setclientdvar("cg_hudGrenadeIconMaxRange", "250");
		self setclientdvar("cg_hudGrenadePointerHeight", "18");
		self setclientdvar("cg_hudGrenadePointerWidth", "37.5");
		self setclientdvar("cg_hudGrenadePointerPivot", "18 40.5");
		self setclientdvar("cg_fovscale", ".75");
	}
	else
	{
		// Fullscreen scale
		self setclientdvar("cg_hudGrenadeIconHeight", "25");
		self setclientdvar("cg_hudGrenadeIconWidth", "25");
		self setclientdvar("cg_hudGrenadeIconOffset", "50");
		//self setclientdvar("cg_hudGrenadeIconInScope", "0");
		//self setclientdvar("cg_hudGrenadeIconMaxRange", "250");
		self setclientdvar("cg_hudGrenadePointerHeight", "12");
		self setclientdvar("cg_hudGrenadePointerWidth", "25");
		self setclientdvar("cg_hudGrenadePointerPivot", "12 27");
		self setclientdvar("cg_fovscale", "1");
	}
}
