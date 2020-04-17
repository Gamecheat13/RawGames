main()
{
	maps\mp\mp_MiamiConcourse_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_MiamiConcourse");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	setdvar("compassmaxrange","1500");
	VisionSetNaked( "mp_MiamiConcourse" );
	//setExpFog(0,3700,.125,.125,.125,0);
}
