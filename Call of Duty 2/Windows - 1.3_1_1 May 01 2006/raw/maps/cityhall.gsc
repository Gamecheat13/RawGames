#include maps\_utility;
#include maps\_anim;

main()
{	

//	setExpFog(0.00003, 1, .88, .74, 0);
//	setCullFog(0, 13000, 1, .88, .74, 0);	

	setExpFog(0.00045, .58, .57, .57, 0);
	precacheModel("xmodel/weapon_stickybomb");
	precacheModel("xmodel/weapon_stickybomb_obj");
	precacheModel("xmodel/prop_door_metal_bunker_damaged");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("inventory_stickybomb");
	precacheString(&"CITYHALL_OBJ_REACH");

	// FOR REFERENCE ONLY -- DONT UNCOMMENT
	//setcvar("r_glow", "1");
	//setcvar("r_glowKernelSpread", "0.0079"); // 0.0085
	//setcvar("r_glowskybrightness", ".055"); // 0.04
	//setcvar("r_glownonskybias", "-0.890625"); // -0.61
	//setcvar("r_glownonskyscale", "0.64375"); // 0.8
	//setcvar("r_glowsmearopacity", "0.180313"); // 0.36
	level.axis_accuracy = 1.5;
	
	maps\cityhall_fx::main();
	level thread maps\cityhall_amb::main();	
	maps\_load::main();

	setEnvironment ("cold");
	
	level.inv_sticky = maps\_inventory::inventory_create( "inventory_stickybomb", true );
	level.friendlywave_thread = maps\cityhall::friendlyMethod;
	
	level.maxfriendlies = 4;
	level.flag["door exploded"] = false;
	level.flag["volsky_speech"] = false;

	thread IntroShout();
	thread Propaganda();
	thread Volsky();
	getEnt( "door sticky", "targetname" ) thread DoorSticky_Think();
	
	lvl_end = getent("level_end_origin","targetname");
	objective_add(1, "active", &"CITYHALL_OBJ_REACH", lvl_end.origin );
	objective_current(1);
	
	level.scrsound["volsky"]["openthatdoor"]	= "cityhall_vsk_openthatdoor";
	level.scrsound["volsky"]["thrudoor"]	= "cityhall_vsk_thrudoor";

	flag_wait( "door exploded" );

	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		soldiers[index].goalradius = 80;
		soldiers[index] setGoalNode( getNode( "level_end_node", "targetname" ) );
	}
	
	flag_wait( "volsky_speech" );
	maps\_endmission::nextmission();
}

	
friendlyMethod(guy)
{
	println ("zzzzzzzzzzzzzzzzzzzzzzz     here");
	guy setgoalentity (level.player);
}


IntroShout()
{
//	thread playSoundInSpace( level.scrsound["propaganda"]["propaganda1"], (-897,1088,104) );

	level waittill ( "starting final intro screen fadeout" );
	
	thread playSoundInSpace( "RU_1_order_move_generic", level.player.origin );
}


Propaganda()
{
	getEnt( "propaganda3", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda3", (6700,-2473,78) );

	getEnt( "propaganda4", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda4", (6700,-2473,78) );
}


Volsky()
{
	volskySpawner = getEnt( "volsky", "targetname" );
	volskySpawner.script_friendname = "Lt. Dimitri Volsky";

	volskySpawner waittill ( "spawned", soldier );
	
	level.volsky = soldier;	
	level.volsky setGoalEntity( level.player );
	level.volsky.animname = "volsky";
	level.volsky thread magic_bullet_shield();
	
	level.volsky anim_single_solo(level.volsky, "openthatdoor");
	flag_wait( "door exploded" );
	level.volsky anim_single_solo(level.volsky, "thrudoor");
	
	level.volsky setGoalNode( getNode( "level_end_node", "targetname" ) );
	flag_set( "volsky_speech" );
}

DoorSticky_Think()
{
	bunkerDoorModel = getEnt( "ugbunkerdoor1", "script_noteworthy" );
	bunkerDoor =  getEnt( bunkerDoorModel.target, "targetname" );
	bunkerDoor disconnectPaths();

	self setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	self waittill ( "trigger" );

	self triggerOff();

	level.inv_sticky maps\_inventory::inventory_destroy();

	bomb = getEnt( self.target, "targetname" );
	bomb setmodel ("xmodel/weapon_stickybomb");
	bomb playsound ("stickybomb_plant");
	bomb playloopsound ("bomb_tick");

	stopwatch = maps\_utility::getstopwatch(60);
	wait level.explosiveplanttime;

	bomb stoploopsound ("bomb_tick");
	stopwatch destroy();
	
	//BEGIN EXPLOSION
	earthquake( 0.25, 3, bunkerDoor.origin, 1050 );
	bunkerDoor playSound ("explo_plant_rand");
	radiusDamage( (7169, -2488, 72), 128, 200, 100 ); 
	bunkerDoorModel linkTo ( bunkerDoor );
	bunkerDoorModel setModel( "xmodel/prop_door_metal_bunker_damaged" );
	bunkerDoorModel playSound( "explo_metal_rand" );
	exploder( 4 );	
	bomb hide();
	bunkerDoor rotateYaw( 89, 0.1, 0.05, 0.05 );
	wait ( 2.0 );
	bunkerDoor connectPaths();
	flag_set( "door exploded" );
}
