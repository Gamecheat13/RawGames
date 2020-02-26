main()
{

	level.tweakfile = false;

	//* Fog and vision section * 

	setDevDvar( "scr_fog_disable", "0" );

    ent = maps\_utility::create_vision_set_fog( "whitehouse" );
    ent.startDist = 5882;
    ent.halfwayDist = 4070;
    ent.red = 0.217;
    ent.green = 0.136;
    ent.blue = 0.101;
    ent.maxOpacity = 0.58;
    ent.transitionTime = 0;

    ent = maps\_utility::create_vision_set_fog( "dcemp_tunnels" );
    ent.startDist = 5882;
    ent.halfwayDist = 4070;
    ent.red = 0.217;
    ent.green = 0.136;
    ent.blue = 0.101;
    ent.maxOpacity = 0.58;
    ent.transitionTime = 0;
}

