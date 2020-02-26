
main()
{
	maps\mp\mp_embassy_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_embassy");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	setExpFog(250,2500,.858,.658,.384,0);

	setdvar("compassmaxrange","1500");
	VisionSetNaked( "mp_embassy" );
}