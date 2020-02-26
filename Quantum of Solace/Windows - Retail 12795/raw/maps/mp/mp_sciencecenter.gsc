
main()
{
	maps\mp\mp_sciencecenter_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_sciencecenter");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	setdvar("compassmaxrange","1500");

	VisionSetNaked( "mp_sciencecenter" );
}