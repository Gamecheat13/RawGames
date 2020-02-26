main()
{
	precacheFX();
	spawnWorldFX();

	
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

precacheFX()

{	
		level._effect["dust_wnd_slw_lp_mpcrash"]					= loadfx ("dust/dust_wnd_slw_lp_mpcrash");
		level._effect["dust_wnd_slw_lp_mpcrash_fld"]			    = loadfx ("dust/dust_wnd_slw_lp_mpcrash_fld");
		level._effect["dust_wnd_lp_mpcrash_alley"]			    	= loadfx ("dust/dust_wnd_lp_mpcrash_alley");

		level._effect["smoke_lp_mpcrash"]							= loadfx ("smoke/smoke_lp_mpcrash");
		level._effect["flak_explosion"]								= loadfx ("explosions/large_vehicle_explosion");		
}


spawnWorldFX()
{		
	//location: Near Crash site	
	//maps\mp\_fx::loopfx("smoke_lp_mpcrash", (425,650,125), 0.75, (425,650,198));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (291,110,144), 1.5, (291,110,244));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (226,-152,144), 1.5, (226,-152,244));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (826,-437,136), 1.5, (826,-437,236));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (1128,-631,88), 1.5, (1128,-631,188));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (1237,-1138,80), 1.5, (1237,-1138,180));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash_fld", (300,-1806,110), 0.5, (300,-1786,157));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash_fld", (-57,-1830,142), 0.5, (-57,-1810,189));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-291,-651,101), 2, (-291,-651,201));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-327,188,160), 2, (-327,188,260));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-423,570,232), 2, (-423,570,332));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-255,1917,228), 2, (-255,1917,328));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (883,376,155), 2, (883,376,255));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (390,668,155), 2, (390,668,255));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (869,712,155), 2, (869,712,255));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (936,1129,128), 2, (936,1129,228));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-448,1099,239), 2, (-448,1099,339));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (660,-1003,112), 2, (660,-1003,212));
	maps\mp\_fx::loopfx("dust_wnd_slw_lp_mpcrash", (1570,29,131), 1.5, (1570,29,231));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-290,-1070,85), 2, (-290,-1070,185));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-232,-1469,85), 2, (-232,-1469,185));
	maps\mp\_fx::loopfx("dust_wnd_lp_mpcrash_alley", (-737,-1242,325), 2, (-737,-1242,425));	
}