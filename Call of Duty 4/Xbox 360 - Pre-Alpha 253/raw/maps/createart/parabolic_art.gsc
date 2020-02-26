//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "31981.7");
	setdvar("scr_fog_nearplane", "16689.2");
	setdvar("scr_fog_red", "0.0864362");
	setdvar("scr_fog_green", "0.127279");
	setdvar("scr_fog_blue", "0.154118");

	//

	setExpFog(16689.2, 31981.7, 0.0864362, 0.127279, 0.154118, 0);
	VisionSetNaked( "parabolic", 0 );

}
