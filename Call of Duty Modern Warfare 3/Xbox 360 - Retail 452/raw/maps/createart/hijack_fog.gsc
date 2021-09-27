// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\_utility::create_vision_set_fog( "hijack" );
	ent.startDist = 1470.25;
	ent.halfwayDist = 46718.3;
	ent.red = 0.50218;
	ent.green = 0.534208;
	ent.blue = 0.559985;
	ent.maxOpacity = 0.0972208;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.424012;
	ent.sunGreen = 0.454538;
	ent.sunBlue = 0.474867;
	ent.sunDir = (0, 0, 0);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 104.416;
	ent.normalFogScale = 2.07943;
 
	ent = maps\_utility::create_vision_set_fog( "hijack_airplane" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\_utility::create_vision_set_fog( "hijack_airplane_combat" );
	ent.startDist = 0;
	ent.halfwayDist = 58233.4;
	ent.red = 0.567992;
	ent.green = 0.463575;
	ent.blue = 0.374757;
	ent.maxOpacity = 0.152002;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\_utility::create_vision_set_fog( "hijack_cargo" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.5;
	ent.sunGreen = 0.5;
	ent.sunBlue = 0.5;
	ent.sunDir = (0, 0, 0);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 1;
	ent.normalFogScale = 1;
 
	ent = maps\_utility::create_vision_set_fog( "aftermath" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
 
	ent = maps\_utility::create_vision_set_fog( "hijack_conference" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	
	ent = maps\_utility::create_vision_set_fog( "hijack_ending" );
    ent.startDist = 126.086;
    ent.halfwayDist = 354.282;
    ent.red = 0.134937;
    ent.green = 0.175035;
    ent.blue = 0.208264;
    ent.maxOpacity = 0.2593;
    ent.transitionTime = 0;
    ent.sunFogEnabled = 1;
    ent.sunRed = 0.469572;
    ent.sunGreen = 0.33342;
    ent.sunBlue = 0.181738;
    ent.sunDir = (0.0855744, -0.974006, 0.209737);
    ent.sunBeginFadeAngle = 1;
    ent.sunEndFadeAngle = 35.6228;
    ent.normalFogScale = 0.45123;

 
	maps\_utility::vision_set_fog_changes( "hijack", 0 );
}
