main()
{
	level._effect[ "wood" ]				 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]				 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]			 = loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect["firelp_barrel_pm"]	 = loadfx ("fire/firelp_barrel_pm");
	level._effect["antiair_runner"]		 = loadfx ("misc/antiair_runner_night");

	ambientFX();
	maps\createfx\mp_bog_fx::main();
}

ambientFX()
{
	// temp fire effects
	
	ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5312, -356, 52);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (4946, 226, 34);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5584, 518, 48);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5748, 934, 50);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5370, 1670, 6);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (4402, 2088, 64);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (3304, 1772, 32);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (3056, 1370, 0);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (2654, 1586, 32);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (2414, 1368, 4);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (2108, 794, 26);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (2226, 544, 10);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (1556, 384, 28);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (3522, 890, 36);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5110, 1310, 28);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("firelp_barrel_pm");
    ent.v["origin"] = (5918, 2360, 72);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "firelp_barrel_pm";
    ent.v["delay"] = -15;
    
    // temp AA gun effects
    
    ent = maps\mp\_utility::createOneshotEffect("antiair_runner");
    ent.v["origin"] = (-388, -2764, 16);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "antiair_runner";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("antiair_runner");
    ent.v["origin"] = (5026, -1856, -12);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "antiair_runner";
    ent.v["delay"] = -15;
    
    ent = maps\mp\_utility::createOneshotEffect("antiair_runner");
    ent.v["origin"] = (9740, 2048, 106);
    ent.v["angles"] = (270,0,0);
    ent.v["fxid"] = "antiair_runner";
    ent.v["delay"] = -15;
}