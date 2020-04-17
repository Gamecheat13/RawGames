main()
{
	maps\mp\mp_barge_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_barge");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	setdvar("compassmaxrange","1500");
	//setdvar("r_godraysSunPosy2","-0.0176142");
	//setdvar("r_godraysSunPosx2","-0.661335");
	VisionSetNaked( "mp_barge" );
	//setExpFog(100,1500,.05,.05,.05,0);
}
