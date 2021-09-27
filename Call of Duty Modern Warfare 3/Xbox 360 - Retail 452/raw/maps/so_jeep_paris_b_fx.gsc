main()
{
	level._effect[ "test_effect" ]										 = loadfx( "misc/moth_runner" );
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
	thread precacheFX();
	maps\createfx\so_jeep_paris_b_fx::main();
}

precacheFX()
{
	
	//gaz driver
	level._effect[ "blood_gaz_driver" ]										= loadfx( "misc/blood_gaz_driver" );
	
	//enemy flashligt
	level._effect[ "flashlight_ai" ]										= loadfx( "misc/flashlight_lensflare" );
	
	//smoke grenade
	level._effect[ "smokescreen" ]     										= LoadFX( "smoke/smoke_grenade_low" );
	
	//ambient fire
	level._effect[ "fire_ambient_1" ] 										= loadfx( "fire/fire_generic_atlas" );
	
	//ambient smoke
	level._effect[ "somke_large_low" ] 										= loadfx( "smoke/bg_smoke_plume" );
	level._effect[ "somke_ambient_large" ] 									= loadfx( "smoke/amb_smoke_distant_paris" );
	level._effect[ "fog_drive" ] 											= loadfx( "smoke/fog_ground_200_rundown" );
	level._effect[ "smoke_ceiling" ] 										= loadfx( "smoke/ceiling_smoke_generic" );
	level._effect[ "shaft_smoke" ]			 								= loadfx( "maps/paris/shaft_smoke" );

	//gas
	level._effect[ "poisonous_gas_ground_paris_200_bookstore" ] 			= loadfx( "smoke/poisonous_gas_ground_paris_200_bookstore" );
	level._effect[ "poisonous_gas_wallCrawl_paris" ]						= loadfx( "smoke/poisonous_gas_wallCrawl_paris" );
	level._effect[ "poison_movement" ]										= LoadFX( "impacts/footstep_poison" );
	level._effect[ "poison_movement_light" ]								= LoadFX( "impacts/footstep_poison_light" );
	level._effect[ "poison_movement_sunlight" ]								= LoadFX( "impacts/footstep_poison_sunlight" );
	level._effect[ "poison_movement_firelight" ]							= LoadFX( "impacts/footstep_poison_firelight" );
	level._effect[ "poison_movement_dark_groundcover" ]						= LoadFX( "impacts/footstep_poison_dark_groundcover_far_draw" );
	
	//to avoid asserts on startup
	level._effect["lights_worklight_flare"]									= loadfx("lights/lights_worklight_flare");
	level._effect["light_glow_walllight_white_flicker"]						= loadfx("misc/light_glow_walllight_white_flicker");	
}
	