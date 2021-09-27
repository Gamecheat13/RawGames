// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\_utility::create_vision_set_fog( "innocent" );
	ent.startDist = 168.236;
	ent.halfwayDist = 29441.5;
	ent.red = 0.442333;
	ent.green = 0.45838;
	ent.blue = 0.482829;
	ent.maxOpacity = 0.511051;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.374593;
	ent.sunGreen = 0.337511;
	ent.sunBlue = 0.310104;
	ent.sunDir = (0.183478, -0.964891, 0.187939);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 25.2747;
	ent.normalFogScale = 1.45109;
 
	ent = maps\_utility::create_vision_set_fog( "innocent_bloom" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\_utility::create_vision_set_fog( "innocent_explosion" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\_utility::create_vision_set_fog( "innocent_ending" );
	ent.startDist = 2430.67;
	ent.halfwayDist = 18186.6;
	ent.red = 0.215014;
	ent.green = 0.212964;
	ent.blue = 0.204205;
	ent.maxOpacity = 0.370646;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.780844;
	ent.sunGreen = 0.448173;
	ent.sunBlue = 0.125196;
	ent.sunDir = (-0.994187, 0.0505612, -0.0950589);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 25.2747;
	ent.normalFogScale = 1.07609;

	ent = maps\_utility::create_vision_set_fog( "london_westminster_station" );
	ent.startDist = 699.526;
	ent.halfwayDist = 1125.76;
	ent.red = 0.498264;
	ent.green = 0.497677;
	ent.blue = 0.476364;
	ent.maxOpacity = 0.135712;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.347043;
	ent.sunGreen = 0.347109;
	ent.sunBlue = 0.347109;
	ent.sunDir = (0.00422474, -0.344246, -0.93887);
	ent.sunBeginFadeAngle = 58.1884;
	ent.sunEndFadeAngle = 69.9882;
	ent.normalFogScale = 10;

	ent = maps\_utility::create_vision_set_fog( "london_westminster" );
	ent.startDist = 2722.91;
	ent.halfwayDist = 4136.04;
	ent.red = 0.442303;
	ent.green = 0.458309;
	ent.blue = 0.482889;
	ent.maxOpacity = 0.167967;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.596664;
	ent.sunGreen = 0.650091;
	ent.sunBlue = 0.639706;
	ent.sunDir = (0.0039, 0.0032, -1);
	ent.sunBeginFadeAngle = 92.1993;
	ent.sunEndFadeAngle = 100.149;
	ent.normalFogScale = 6.62768;

	ent = maps\_utility::create_vision_set_fog( "westminster_tunnel" );
	ent.startDist = 0;
	ent.halfwayDist = 2650.93;
	ent.red = 0.391738;
	ent.green = 0.416592;
	ent.blue = 0.455287;
	ent.maxOpacity = 0.726743;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	ent.sunRed = 0.760933;
	ent.sunGreen = 0.706447;
	ent.sunBlue = 0.677554;
	ent.sunDir = (-0.0268694, 0.987819, -0.153271);
	ent.sunBeginFadeAngle = 24.4611;
	ent.sunEndFadeAngle = 48.7264;
	ent.normalFogScale = 6.34916;

 
	maps\_utility::vision_set_fog_changes( "westminster_tunnel", 0 );
}
