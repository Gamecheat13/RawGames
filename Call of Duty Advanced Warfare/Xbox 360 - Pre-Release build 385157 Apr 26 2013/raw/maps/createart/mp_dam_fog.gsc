// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\mp\_art::create_vision_set_fog( "mp_dam" );
	ent.startDist = 1050;
	ent.halfwayDist = 34000;
	ent.red = 0.8;
	ent.green = 0.86;
	ent.blue = .97;
	ent.maxOpacity = 0.17;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
	
	ent = maps\mp\_art::create_vision_set_fog( "mp_dam_underground" );
	ent.startDist = 500;
	ent.halfwayDist = 5000;
	ent.red = 0.83;
	ent.green = 0.72;
	ent.blue = 0.58;
	ent.maxOpacity = 0.40;
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

	setExpFog( 185.058, 2497.74, 0.627451, 0.717647, 0.745098, 1, 0, 0.839216, 0.690196, 0.568627, (0.00390755, 0.00323934, -1), 83.5416, 92.7872, 2.25266 );
	/#
	level._art_fog_setup = maps\createart\mp_dam_fog::main;
	#/
}
