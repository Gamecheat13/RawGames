
main()
{
	maps\mp\mp_rooftop_fx::main();
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_rooftop");
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	setdvar("compassmaxrange","1500");
	VisionSetNaked( "mp_rooftop" );
	//setExpFog(0,3700,.125,.125,.125,0);



	// Temp FX moved from createfx/mp_rooftop_fx.gsc, hand written FX should go in this file
	// createEffectFromEnt( "science_lightbeam01", "test01", -15 );
}
/*
createEffectFromEnt( effectName, targetNameForEnt, delay, targetNameForEffect )
{
	Fx_origin_ent = getent ( targetNameForEnt, "targetname" );
	ent = createOneshotEffect(effectName);
     	ent.v["origin"] = Fx_origin_ent.origin;
     	ent.v["angles"] = Fx_origin_ent.angles;
     	ent.v["fxid"] = effectName;
     	ent.v["delay"] = delay;

	if( isDefined( targetNameForEffect ) )
	{
		ent.v["targetName"] = targetNameForEffect;
	}
}
*/