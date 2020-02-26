#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\afghanistan_utility;
#include maps\_vehicle;

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "deserted_sequence" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions	(you may have more than one skipto in this file)
-------------------------------------------------------------------------------------------*/

//
//	This is run before your main function is executed.  Put any skipto-only initialization here.
skipto_deserted()
{
	skipto_setup();
	
	start_teleport( "skipto_deserted_player" );
	
	level.woods = init_hero("woods");
	level.rebel_leader = init_hero("rebel_leader");
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	// Temp Development info
	/#
		IPrintLn( "Event Name" );
	#/
	// Initialization
	level turn_down_fog();
	level thread deserted_sequence();
	// Additional event logic    
}

deserted_sequence()
{
	flag_wait("deserted_sequence");
	
	level.player disableweapons();
	
	spawn_vehicle_from_targetname("deserted_pickup1");
	spawn_vehicle_from_targetname("deserted_pickup2");
	
	wait 3;
	
	vulture = GetEntarray("end_vulture", "targetname");
	vulture[0] thread handle_vulture();
	vulture[1] thread handle_vulture();
	vulture[2] thread handle_vulture();
	
	
	level thread run_scene("e6_s2_ontruck_trucks");	
	level thread run_scene("e6_s2_ontruck_2");
	level thread run_scene("e6_s2_ontruck_1");
	
	if(flag("screen_fade_out_start"))
	{
		flag_wait("screen_fade_out_end");
		
		level.player shellshock( "death", 7);
		screen_fade_in();
		
		flag_wait("screen_fade_in_end");
	}
	
	//level thread handle_vultures();
	
	level.scene_sys waittill("e6_s2_ontruck_1_done");
	
	level.rebel_leader Unlink();
	level.woods Unlink();
	
	for(i = 1; i < 4; i++)
	{
		muj_guard = GetEnt("m0" + i + "_guard_ai", "targetname");
		muj_guard Unlink();
	}
	
	run_scene("e6_s2_offtruck");
	set_screen_fade_timer(0.15);
	
	level thread screen_fade_out();
	run_scene_first_frame("e6_s2_deserted_single");
	wait 0.5;
	level thread screen_fade_in();
	
	run_scene("e6_s2_deserted_part1");
	
	level thread screen_fade_out();
	run_scene_first_frame("e6_s2_deserted_single");
	wait 0.5;
	level thread screen_fade_in();
	
	run_scene("e6_s2_deserted_part2");
	
	level thread screen_fade_out();
	run_scene_first_frame("e6_s2_deserted_single");
	wait 0.5;
	level thread screen_fade_in();
	
	thread run_scene("e6_s2_deserted_part3");
	
	wait 6.65;
	
	//vh_white_pickup = getent("deserted_pickup", "targetname");
	//vh_white_pickup Go_Path(GetVehicleNode("pickup_start_node", "targetname"));
	//vh_white_pickup SetBrake(false);
	
	//vh_white_pickup waittill("reached_end_node");
	level.player notify("mission_finished");
	nextmission();
}

#using_animtree( "critter" );
handle_vulture()
{
	self endon("deleted");
	self useanimtree(#animtree);
	
	while(1)
	{
		rand = RandomInt(100);
		
		self clearanim(%root, 0.0);
		
		if(rand < 70)
		{
			self setanim( %critter::a_vulture_idle, 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle);
		}
		else
		{
			self setanim( %critter::a_vulture_idle_twitch , 1, 0, 1);
			anim_durration = getanimlength(%critter::a_vulture_idle_twitch);
		}	
		wait anim_durration;
	}
}

/* ------------------------------------------------------------------------------------------
	SUPPORT functions
-------------------------------------------------------------------------------------------*/

// Everything else goes here

deserted_truck_kickup_dust( vh_truck )
{
	fx_kickup = GetFX( "truck_kickup_dust" );
	PlayFXOnTag( fx_kickup, vh_truck, "tag_origin" );
}

deserted_truck_kickout_impact( e_guy )
{
	fx_impact = GetFX( "kickout_dust_impact" );
	PlayFX( fx_impact, e_guy.origin );
}