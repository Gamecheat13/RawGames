#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper_code;
#include common_scripts\utility;

// Clip hedge boundaries
// Add path nodes
// Add prints for missing dialog
// place enemy patrols
// Add objectives
// work out enemies detecting your presence
// should Price be the current objective? if the player loses him how does he find him again? friendlies aren't shown on compass any more.
// price should move with weapon stowed

#using_animtree( "generic_human" );
main()
{
	level.cosine["180"] = cos(180);
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;

	initLevel();
	thread initPlayer();
	thread initPrice();
	//initAxis();
	//initFlags();

	//initDefault();
	
	wait 1;
	musicPlay( "scoutsniper_pripyat_music" ); 
}

initLevel()
{
	maps\createart\scoutsniper_art::main();

	default_start( ::initDefault );
	add_start( "default", ::initDefault );
	add_start( "hind", ::initHind );
	add_start( "field", ::initFieldCrossing );

	initFlags();

	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_bmp::main( "vehicle_bmp" );
	maps\scoutsniper_fx::main();
	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_scoutsniper" );
	maps\scoutsniper_anim::main();
	
	thread maps\scoutsniper_amb::main();
	thread initRadiation();
	thread initStealthDetection();

	thread updateFog();
	
	battlechatter_off( "allies" );
	createThreatBiasGroup( "allies" ); 
	createThreatBiasGroup( "axis" );
	createThreatBiasGroup( "oblivious" );
	//setignoremegroup( "allies", "axis" ); 		// axis ignore allies
	//setignoremegroup( "axis", "allies" );			// allies ignore axis
	
	setignoremegroup( "allies", "oblivious" );		// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );		// oblivious ignore axis
	setignoremegroup( "oblivious", "allies" );		// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );		// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious
	
	array_thread( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, ::patrol);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::null);
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::patrol);
}

initPlayer()
{
	level.player setthreatbiasgroup( "allies" );

	// set player stance to prone
	//level.player allowstand( false );
	//level.player allowstand( false );
	
	//delayThread( 5, ::temp );
	//wait .3;
	thread temp();
}

temp()
{
	wait .3;
	//level.player freezeControls( true );
	level.player setstance( "crouch" );	// something is making the player get up
	level.player disableWeapons();
	level.player thread execAIStealthDetection();
}

initPrice()
{
	spawner = getent( "price", "script_noteworthy" );
	level.price = spawner dospawn();
	spawn_failed( level.price );
	assert( isDefined( level.price ) );

	//level.price setthreatbiasgroup( "allies" );
	level.price.ignoreall = true;

	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	
	//node = getnode( "price_start_node", "targetname" );
	//level.price setgoalnode( node );
	//level.price.goalradius = node.radius;
	//level.price allowedstances( "prone" );
	//level.price.a.pose = "prone";

	level.price thread execAIStealthDetection();
}

initAxis()
{
	spawner = getent( "patroller1", "script_noteworthy" );
	level.patroller1 = spawner dospawn();
	spawn_failed( level.patroller1 );
	assert( isDefined( level.patroller1 ) );
	self.ignoreall = true;

	self.goalradius = 16;
	self.script_radius = 16;
}

initFlags()
{
	flag_init( "spawn_fieldcrawl" );
	flag_init( "helicopter_unloading" );
}

initDefault()
{
	thread initHind();
	thread initFieldCrossing();

	thread execDefault();
}

execDefault()
{
	//thread maps\_introscreen::introscreen_delay( &"SCOUTSNIPER_TITLE", &"SCOUTSNIPER_DATE", &"SCOUTSNIPER_PLACE", &"SCOUTSNIPER_INFO", undefined, undefined, undefined);

	level.player allowstand( true );
	
	hotel_entrance = getent( "hotel_entrance", "targetname" );
	//objective_add( 1, "active", &"SCOUTSNIPER_OBJECTIVE1", hotel_entrance.origin );
	//objective_current( 1 );
	
	reference = getent( "price_start_node", "targetname" );
	reference thread anim_first_frame_solo( level.price, "scoutsniper_opening_price" );

	wait 12;
	
	dialogprint( "Price - Too much radiation. We'll have to go around.", 1 );

	wait 1;
	
	level.price allowedstances( "stand" );
	
	//level.price thread anim_single_solo( level.price, "scoutsniper_opening_price" );
	//reference thread anim_single_solo( level.price, "wave" );
	reference thread anim_custom_animmode_solo( level.price, "gravity", "scoutsniper_opening_price" );

	//price moves to a stopping point
	node = getnode( "price_intro_path", "targetname" );
	level.price thread follow_path( node );

	//wait 6.85;
	//level.price stopanimscripted();
	
	//dialogprint( "Price - Follow me, and keep low." );

	//wait till goal
	//wait till player has reached price

	thread scripted_array_spawn( "patrollers", "script_noteworthy", true );

	/*spawner = getent( "patroller1", "script_noteworthy" );
	patroller1 = spawner dospawn();
	spawn_failed( patroller1 );
	assert( isDefined( patroller1 ) );
	patroller1 thread patrol(); //test

	spawner = getent( "patroller2", "script_noteworthy" );
	patroller2 = spawner dospawn();
	spawn_failed( patroller1 );
	assert( isDefined( patroller1 ) );
	patroller1 thread patrol(); //test*/

	level.price waittill( "path_end_reached" );

	thread scripted_array_spawn( "tableguards", "script_noteworthy", true );
	


	dialogprint( "Price - Keep an eye out. Enemy presence could be any where around here.", 3 );
	dialogprint( "Price - Maintain a low profile and they'll never know we were here.", 3 );
	dialogprint( "Price - Alright, let's move out.", 3 );
	
	//price moves up a little to a new position
	node = getnode( "price_contact_node", "targetname" );
	level.price setgoalnode( node );
	level.price waittill( "goal" );
		
	dialogprint( "Price - Contact.", 3 );
	dialogprint( "Price - Enemy patrol, dead ahead.", 3 );
	dialogprint( "Price - Likely more inside." );
}

initHind()
{
	//level.player setOrigin(( -34448, -836, 191 ) );
	//level.player setPlayerAngles(( 0, 18, 0 ) );
	
	thread execHind();
}

initFieldCrossing()
{
	//(-32060 241 411) 
	//level.player setOrigin(( -32060, 224, 260 ) );
	//level.player setPlayerAngles(( 0, 23, 0 ) );
	
	thread execFieldCrossing();
}

execHind()
{
	trigger = getent( "field_hind_trigger", "targetname" );
	trigger waittill( "trigger" );

	field_hind = spawn_vehicle_from_targetname_and_drive( "field_hind" );
	
	//field_hind waittill( "goal" );
	//field_hind vehicle_land();
}

execFieldCrossing()
{
	trigger = getent( "field_crossing_trigger", "targetname" );
	trigger waittill( "trigger" );

	thread spawnFieldBmps();
	thread spawnFieldGuards();
}

spawnFieldBmps()
{
	field_bmp1 = spawn_vehicle_from_targetname_and_drive( "bmp1" );
	field_bmp1 thread execVehicleStealthDetection();
	//field_bmp1.script_turretmg = false;

	wait 1;
	field_bmp2 = spawn_vehicle_from_targetname_and_drive( "bmp2" );
	field_bmp2 thread execVehicleStealthDetection();
	//field_bmp2.script_turretmg = false;
	
	wait 2;
	field_bmp3 = spawn_vehicle_from_targetname_and_drive( "bmp3" );
	field_bmp3 thread execVehicleStealthDetection();
	//field_bmp3.script_turretmg = false;

	wait .5;
	field_bmp4 = spawn_vehicle_from_targetname_and_drive( "bmp4" );
	field_bmp4 thread execVehicleStealthDetection();
	//field_bmp4.script_turretmg = false;

	musicStop();
	wait .05;
	
	musicPlay( "scoutsniper_surrounded_music" ); 
}

spawnFieldGuards()
{
	thread scripted_array_spawn( "field_guard", "script_noteworthy", true );
}

null()
{

}

