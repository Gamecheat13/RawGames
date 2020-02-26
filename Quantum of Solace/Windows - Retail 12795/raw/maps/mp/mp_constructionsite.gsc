
main()
{
	maps\mp\mp_constructionsite_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_constructionsite");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	setdvar("compassmaxrange","1500");
	VisionSetNaked( "mp_constructionsite" );
	setExpFog(0, 4000, 0.67843, 0.623529, 0.552941, 0);
}