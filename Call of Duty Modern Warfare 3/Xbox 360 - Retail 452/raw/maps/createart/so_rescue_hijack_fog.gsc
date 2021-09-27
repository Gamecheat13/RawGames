// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\_utility::create_vision_set_fog( "so_rescue_hijack" );
	ent.startDist = 1;
	ent.halfwayDist = 821;
	ent.red = 0.187201;
	ent.green = 0.187201;
	ent.blue = 0.187201;
	ent.maxOpacity = 0.2;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 1;
	ent.sunRed = 0.424012;
	ent.sunGreen = 0.454538;
	ent.sunBlue = 0.474867;
	ent.sunDir = (0, 0, 0);
	ent.sunBeginFadeAngle = 0;
	ent.sunEndFadeAngle = 104.416;
	ent.normalFogScale = 2.07943;
 
	maps\_utility::vision_set_fog_changes( "so_rescue_hijack", 0 );
}
