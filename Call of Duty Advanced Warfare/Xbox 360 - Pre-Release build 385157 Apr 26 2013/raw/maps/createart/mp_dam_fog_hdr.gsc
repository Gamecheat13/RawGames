// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\mp\_art::create_vision_set_fog( "mp_dam" );
	ent.startDist = 538;
	ent.halfwayDist = 146640;
	ent.red = 0.8;
	ent.green = 0.86;
	ent.blue = 0.97;
	ent.maxOpacity = 0.0996875;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\mp\_art::create_vision_set_fog( "mp_dam_underground" );
	ent.startDist = 3764.17;
	ent.halfwayDist = 19391;
	ent.red = 0.661137;
	ent.green = 0.554261;
	ent.blue = 0.454014;
	ent.maxOpacity = 0.7;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 
	ent = maps\mp\_art::create_vision_set_fog( "mp_dam_interior" );
	ent.startDist = 1050;
	ent.halfwayDist = 34000;
	ent.red = 0.76;
	ent.green = 0.89;
	ent.blue = 0.88;
	ent.maxOpacity = 0.19;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
 

 
}
 
setupfog()
{

	//* Fog section * 

	setDevDvar( "scr_fog_disable", "0" );

	setExpFog( 538, 146640, 0.8, 0.86, 0.97, 0.0996875, 0 );
	/#
	level._art_fog_setup = maps\createart\mp_dam_fog_hdr::main;
	#/
}
