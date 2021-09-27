// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\_utility::create_vision_set_fog( "hamburg" );
	ent.startDist = 108.978;
	ent.halfwayDist = 6098.16;
	ent.red = 0.555083;
	ent.green = 0.516596;
	ent.blue = 0.488973;
	ent.maxOpacity = 0.428619;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.741022;
	ent.sunGreen = 0.654154;
	ent.sunBlue = 0.503102;
	ent.sunDir = (0.807453, -0.107477, 0.580059);
	ent.sunBeginFadeAngle = 31.2405;
	ent.sunEndFadeAngle = 46.9162;
	ent.normalFogScale = 0.91799;
 
	ent = maps\_utility::create_vision_set_fog( "hamburg_garage" );
	ent.startDist = 636.105;
	ent.halfwayDist = 8145.02;
	ent.red = 0.495015;
	ent.green = 0.554261;
	ent.blue = 0.454984;
	ent.maxOpacity = 0.641317;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\_utility::create_vision_set_fog( "hamburg_landing" );
	ent.startDist = 108.978;
	ent.halfwayDist = 6098.16;
	ent.red = 0.555083;
	ent.green = 0.516596;
	ent.blue = 0.488973;
	ent.maxOpacity = 0.964131;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.741022;
	ent.sunGreen = 0.654154;
	ent.sunBlue = 0.503102;
	ent.sunDir = (0.807453, -0.107477, 0.580059);
	ent.sunBeginFadeAngle = 31.2405;
	ent.sunEndFadeAngle = 46.9162;
	ent.normalFogScale = 0.91799;
 
	ent = maps\_utility::create_vision_set_fog( "hamburg_garage_inside_tank" );
	ent.startDist = 0;
	ent.halfwayDist = 734.528;
	ent.red = 0.586333;
	ent.green = 0.547846;
	ent.blue = 0.512411;
	ent.maxOpacity = 0.0209443;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.391866;
	ent.sunGreen = 0.247685;
	ent.sunBlue = 0.186887;
	ent.sunDir = (0.807453, -0.107477, 0.580059);
	ent.sunBeginFadeAngle = 8;
	ent.sunEndFadeAngle = 145.938;
	ent.normalFogScale = 6.33423;
 
	ent = maps\_utility::create_vision_set_fog( "hamburg_end_building" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	maps\_utility::vision_set_fog_changes( "hamburg", 0 );
}
