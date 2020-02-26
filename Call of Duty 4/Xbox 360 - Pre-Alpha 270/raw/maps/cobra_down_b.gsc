#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree("generic_human");


main()
{
	maps\_load::main();
	level thread maps\cobra_down_b_amb::main();
	playerInit();

	setExpFog(0, 6000, 126.0/255, 89.0/255 , 81.0/255, 0); 
	VisionSetNaked( "cobra_down" );
   	thread SunSet();
   	
   	
   	       
}

playerInit()
{	
	level.player takeAllWeapons();
	level.player giveWeapon("usp");
	level.player giveWeapon("m4_grunt");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");	
	level.player switchToWeapon("m4_grunt");
}

SunSet()
{
	level.sunSetInterpColors = [];
	//setExpFog( 200, 8000, .07, .07, .13, 0 );
	//sunSetInitColor( "sun", (0,0,0) );
	VisionSetNaked( "cobra_down" );

	thread doSunsetColors();
	
	//setExpFog(200, 8000, .07, .07, .13, 0);
/*	interval = .05;
	while(1)
	{
		sunColor = sunSetIncrTime( "sun", interval );
		setSunLight( sunColor[0], sunColor[1], sunColor[2] );
		wait interval;
	}
*/
}

doSunSetColors()
{
	// these intervals will probably need tweaking when there's gameplay.

	// note that we don't actually wait for the intervals to pass.
	// if we hit the next trigger before it passes, everything will just
	// interpolate ahead from its current value.
	
	///////////////////////////////////////////////////////////
	// #1st trigger
	getent("sunset_01", "targetname") waittill("trigger");
	interval = 40;
	//setExpFog( 200, 10000, .1, .1, .2, interval );
	//sunSetSetColorTarget( "sun", (0,0,0), interval );
	VisionSetNaked( "cobra_sunset1", interval );
	
	///////////////////////////////////////////////////////////
	// #2nd trigger
	getent("sunset_02", "targetname") waittill("trigger");
	interval = 30;
	//setExpFog( 200, 12000, .27, .25, .35, interval );
	//sunSetSetColorTarget( "sun", vectorScale( (1,.4,.1), .75 ), interval );
	VisionSetNaked( "cobra_sunset2", interval );

	///////////////////////////////////////////////////////////
	// #3: approaching the industrial area. sun becomes strong red over 20 seconds
	getent("sunset_03", "targetname") waittill("trigger");
	interval = 20;
	//setExpFog( 200, 30000, .65, .5, .3, interval );
	//sunSetSetColorTarget( "sun", vectorScale( (1,.55,.25), 1 ), interval );
	VisionSetNaked( "cobra_sunset3", interval );

/*
	///////////////////////////////////////////////////////////
	// #4: leaving the industrial area. sun becomes near white over 20 seconds
	getent("sunrise4", "targetname") waittill("trigger");
	interval = 20;
	setExpFog( 200, 60000, .8, .65, .5, interval );
	sunSetSetColorTarget( "sun", vectorScale( (1,.7,.4), 1.35 ), interval );
	VisionSetNaked( "icbm_sunrise4", interval );
	
*/
}

sunSetIncrTime(colorName, time)
{
	data = level.sunSetInterpColors[colorName];
	
	assert( isdefined( data ) );
	
	data["timePassed"] += time;
	if ( data["timePassed"] >= data["timeTotal"] )
		data["timePassed"] = data["timeTotal"];
	
	A = data["start"];
	B = data["target"];
	t = data["timePassed"] / data["timeTotal"];
	
	data["current"] = vectorScale( A, 1 - t ) + vectorScale( B, t );
	
	level.sunSetInterpColors[colorName] = data;
	
	return data["current"];
}


sunSetInitColor(colorName, color)
{
	data["start"] = color;
	data["target"] = color;
	data["current"] = color;
	data["timePassed"] = 0;
	data["timeTotal"] = 1;
	
	level.sunSetInterpColors[colorName] = data;
}

sunSetSetColorTarget(colorName, targetColor, time)
{
	data = level.sunSetInterpColors[colorName];
	
	assert( isdefined( data ) );
	
	data["start"] = data["current"];
	data["target"] = targetColor;
	data["timePassed"] = 0;
	data["timeTotal"] = time;
	
	level.sunSetInterpColors[colorName] = data;
}

