#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\jeremy_tools;
//#include maps\_remotemortar_sp;

give_p99()
{
	self.weaponInfo[ "deserteagle" ] = self.weaponInfo[ self.sideArm ];
	self.sideArm = "deserteagle";
}

spawn_sandman() 
{
	setup_sandman();
	level.sandman make_hero();
	level.sandman give_p99();
}

spawn_price()
{
	setup_price();
	level.price make_hero();
	level.price give_p99();
}

spawn_truck()
{
	setup_truck();
	level.truck make_hero();
	level.truck give_p99();
}

spawn_grinch()
{
	setup_grinch();
	level.grinch make_hero();
	level.grinch give_p99();
}

objectives() 
{
	level.counter = 0;
//	flag_wait( "city_reveal" );
	wait( 1.0 );
	offset = ( 0, 0, 35 );
	flag_wait( "elevator_one_done_moving_new_beggining");
	wait( 1 );	
	//Find the President.\n
	Objective_Add( obj( "open" ), "active", &"RESCUE_2_OBJ_110" );
//	objective_add( obj( "yard1" ), "invisible", &"RESCUE_2_OBJ_2" );
//	objective_add( obj( "yard1_b" ), "invisible", &"RESCUE_2_OBJ_4" ); // kill hard targets

	objective_current( obj( "open" ) );
	if ( isdefined( level.price ) )
	objective_onentity( obj( "open" ), level.price, offset );

//	flag_wait( "start_yard_one" );
//	wait( 2.0 );
//	objective_add( obj( "open" ), "invisible", &"RESCUE_2_OBJ_1" ); // kill hard targets
//	objective_current( obj( "yard1_b" ) );
//	objective_add( obj( "yard1_b" ), "active", &"RESCUE_2_OBJ_4" ); // kill hard targets
//	objective_state( obj( "yard1_b" ), "active" );
//	objective_string( obj( "yard1_b" ), &"RESCUE_2_OBJ_2", level.counter );	
//	objective_current( obj( "yard1_b" ) );
	
//	Objective_Position( obj( "yard1_b" ), ( 3239, -729, -8320 ) );
//	Objective_AdditionalPosition( obj( "yard1_b" ),1, ( 9862, -5042, -7312 ) );

//	flag_wait( "hard_targets_dead" );	
//	objective_clearadditionalpositions( obj( "yard1_b" ));
//	waitframe();
	
	//	objective_complete( "open" );
//	objective_current( obj( "yard1_b" ), "invisible"  );
	
//	objective_add( obj( "open" ), "active", &"RESCUE_2_OBJ_1" ); // kill hard targets
//	objective_onentity( obj( "open" ), level.price, offset );
	
//	flag_wait( "blow_up_the_door" );
//	objective_add( obj( "doors" ), "active", &"RESCUE_2_OBJ_5" ); // kill hard targets
}

setup_sandman()
{
	level.sandman = spawn_targetname( "sandman" );
	waitframe();
	level.sandman.animname = "sandman";
	level.sandman.pushplayer = false;
//	level.sandman.ignoreMe = true;
	level.sandman thread magic_bullet_shield();
//	level.sandman.animname = "delta";
	level.sandman.goalradius = 64;
	level.sandman.dontavoidplayer = true;  
	level.sandman.nododgemove = true;
	level.sandman set_force_color( "r" );
	level.sandman disable_surprise();
//	level.sandman enable_cqbwalk();
//	level.sandman thread stealth_custom();
//	level.sandman thread fail_on_death();
	level.sandman SetThreatBiasGroup( "delta" );
//	level.sandman.disable_sniper_glint = true;
//	level.sandman thread animscripts\utility::PersonalColdBreath();
	level.oldADSrange = getDvarInt( "ai_playerADS_LOSRange", 150 );
	//setSavedDvar( "ai_playerADS_LOSRange", 0 );
}

setup_price()
{
	ent = getent( "price", "targetname" );
	level.price = spawn_targetname( "price" );
	waitframe();
	level.price.animname = "price";
//	level.price enable_cqbwalk();
	level.price.pushplayer = false;
//	level.price.ignoreMe = true;
	level.price thread magic_bullet_shield();
	level.price.goalradius = 64;
	level.price.dontavoidplayer = true;
	level.price.nododgemove = true;
	level.price set_force_color( "r" );
	level.price disable_surprise();
	level.price SetThreatBiasGroup( "delta" );
//	level.price thread animscripts\utility::PersonalColdBreath();
	level.oldADSrange = getDvarInt( "ai_playerADS_LOSRange", 150 );
	//setSavedDvar( "ai_playerADS_LOSRange", 0 );
}

setup_grinch()
{
	level.grinch = spawn_targetname( "grinch" );
	waitframe();
	level.grinch.animname = "grinch";
	level.grinch.pushplayer = false;
//	level.grinch enable_cqbwalk();
//	level.grinch.ignoreMe = true;
	level.grinch thread magic_bullet_shield();
	level.grinch.goalradius = 64;
	level.grinch.dontavoidplayer = true;
	level.grinch.nododgemove = true;
//	level.grinch set_force_color( "o" );
	level.grinch disable_surprise();
	level.grinch SetThreatBiasGroup( "delta" );
//	level.grinch thread animscripts\utility::PersonalColdBreath();
	level.oldADSrange = getDvarInt( "ai_playerADS_LOSRange", 150 );
	//setSavedDvar( "ai_playerADS_LOSRange", 0 );
}

setup_truck()
{
	ent = getent( "truck", "targetname" );
	level.truck = spawn_targetname( "truck" );
	waitframe();
	level.truck.animname = "truck";
	level.truck.pushplayer = false;
//	level.truck enable_cqbwalk();
//	level.truck.ignoreMe = true;
	level.truck thread magic_bullet_shield();
	level.truck.goalradius = 64;
	level.truck.dontavoidplayer = true;
	level.truck.nododgemove = true;
//	level.truck set_force_color( "o" );
	level.truck disable_surprise();
	level.truck SetThreatBiasGroup( "delta" );
//	level.truck thread animscripts\utility::PersonalColdBreath();
	level.oldADSrange = getDvarInt( "ai_playerADS_LOSRange", 150 );
	//array_allies = get
	//setSavedDvar( "ai_playerADS_LOSRange", 0 );
}

spawn_delta_one() // setup delta.
{
//	level.delta_one = spawn_targetname( "delta_one" );
//	level.delta_one.animname = "generic";
//	level.delta_one.pushplayer = true;
}

spawn_delta_two() // setup delta.
{
	level.delta_two = spawn_targetname( "delta_two" );
	level.delta_two.dontdropweapon = true;
	level.delta_two.animname = "generic";
	level.delta_two.pushplayer = true; 
}

nightvision_setup()
{
//	vision_set_changes( "castle", 4 );
	level.player setactionslot( 1, "nightvision" );
	waitframe();
	VisionSetNight( "castle_nvg_grain" );
	level.player ent_flag_set( "nightvision_dlight_enabled" );
}

// add new set of guys running from left to right.
elevator_down_setup() // You have five guys with
{	
//	thread elevator_rocket_guys();
	thread elevator_pathnode_think();
	waitframe();	
	//give_remotemissile_weapon( )
	// wait till a flag or trigger is hit
	level.warp_elevator = 0;
//	thread elevator_friends_think();
	thread control_player();
	thread elevator_pre_crash_anims();
	thread elevator_throw_ai_melee_moment();
	thread no_prone_check();
	thread elevator_think_three();
	thread elevator_sounds();
	thread elevator_doors();
//	thread elevator_light();
	thread elevator_ambush();
	thread cave_dialoge();
//	thread elevator_rocket_detection();
	flag_wait( "elevator_one_done_moving" );
}

// This is the guys who is thrown into position as the camera fades up.
elevator_throw_ai_melee_moment()
{ 
	elevator_tunnel_dead_guys = array_spawn_targetname( "elevator_tunnel_dead_guys" );
	foreach( ai in elevator_tunnel_dead_guys )
	{
		ai kill();
	}
	
	// this is guy who just lays on the ground.
	ai_dead_one = spawn_targetname( "elevator_dead_guy_one" );
	ai_dead_one linkto ( level.elevator );
	ai_dead_one.nodrop = true;
	ai_dead_one.grenadeammo = 0;
	ai_dead_one.dontdropweapon = true;
	ai_dead_one.noragdoll = 1;
	ai_dead_one.ignoreall = 1;
	ai_dead_one.ignoreme = 1;
	
	// this is the guys who is thrown over the shoulder.
	ai_thrown_one = spawn_targetname("elevator_dead_guy_othrow" );
	ai_thrown_one linkto ( level.elevator );
	ai_thrown_one.animname = "generic";
	ai_dead_one.nodrop = true;
	ai_dead_one.grenadeammo = 0;
	ai_thrown_one.dontdropweapon = true;
	ai_thrown_one.ignoreall = 1;
	ai_thrown_one.ignoreme = 1;
	ai_thrown_one.noragdoll = 1;
	wait( 5.4 );
	ai_thrown_one thread anim_single_solo( ai_thrown_one, "melee_f_awin_defend" );
	// face angles for price.
	level.price thread anim_single_solo( level.price, "melee_f_awin_attack" );
	wait( 0.7 );
	ai_dead_one kill();
	wait( 2.5 );
	ai_thrown_one.a.nodeath = true;
	ai_thrown_one.allowPain = true;
	ai_thrown_one.allowDeath = true;
	ai_thrown_one Kill();
}

// These are the guys talking to each other as the ele goes down.
elevator_pre_crash_anims()
{
//	wait( 1 );
	waitframe();
	level.sandman allowedstances( "crouch" );
	level.price allowedstances( "crouch" );
//	node1 = getstruct( "elevator_anim_sandman", "targetname" );
//	node2 = getstruct( "elevator_anim_price", "targetname" );
//	node1 linkto ( level.elevator );
//	node2 linkto ( level.elevator );
//	level.sandman unlink();
//	level.price unlink();
	
//	level.sandman ForceTeleport( node1.origin, node1.angles );
//	level.sandman SetGoalPos( node1.origin );
//	level.sandman LinkTo ( level.elevator );
//			
//	level.price ForceTeleport( node2.origin, node2.angles );
//	level.price SetGoalPos( node2.origin );
//	level.price LinkTo ( level.elevator );	
	
	wait( 4 );
	level.price thread anim_single_solo( level.price, "rescue_elevator_speaking_price" );
	level.sandman thread anim_single_solo( level.sandman, "rescue_elevator_speaking_sandman" );
}

no_prone_check()
{
	self endon ( "start_bay_runners" );
	trigger = getent( "no_prone_caves","targetname" );
	while( 1 )
	{
		if( level.player IsTouching( trigger ) )
		{
			level.player allowprone( false );
		}
		else 
			level.player allowprone( true );
		wait( 0.05 );
	}
	
}

elevator_rocket_guys()
{
	thread elevator_rocket_guys_runners();
	array_spawn_targetname( "elevator_passive_guys" );
	
	flag_wait("elevator_one_done_moving_new_beggining" );
	waittill_notify_or_timeout( "elevator_one_attack_now", 8.5 );
	flag_set( "elevator_one_attack_now");
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	enemy_ai = getentarray( "elevator_rocket_guys_two", "targetname" );
	maps\_spawner::flood_spawner_scripted( enemy_ai );
	
	// wait till the player shoots here ?
	enemy_ai = getentarray( "elevator_rocket_guy", "targetname" );
	maps\_spawner::flood_spawner_scripted( enemy_ai );	
	
	wait( 4 );
	level.delta_two.animname = "mccoy";
	level.delta_two thread dialogue_queue( "rescue_mcy_lookout" );
	level.truck delaythread( 1,  ::dialogue_queue, "rescue_trk_rpg" );
	wait( 2 );
	dude = getent( "elevator_rocket_guy_the_man", "targetname");
	
	level.rocket_dude = spawn_targetname( "elevator_rocket_guy_the_man", "targetname");
	waitframe();
	level.delta_two.animname = "generic";
	level.rocket_dude allowedstances( "stand" );
	level.rocket_dude.health = 10000;
//	level.rocket_dude thread magic_bullet_shield();
	level.rocket_dude.ignoreall = true;
	level.rocket_dude disable_pain();
	level.rocket_dude.goalradius = 2;
	
//	level.player thread radio_dialogue( "US_0_threat_rpg" );
	
	
	nodes = getnodearray( "rocket_random_fire", "targetname");
	random_node = 0;
	
	ent = array_randomize( nodes );
	num = RandomIntRange( 0,1 );
	switch( num )
	{
		case 0:
			MagicBullet( "rpg_straight", ( 5160, -13448, -5968 ), ( 5474, -14397.5, -5900 ) );
			level.rocket_dude setgoalnode( ent[ 0 ] );		
		case 1:
			MagicBullet( "rpg_straight", ( 5592, -13400, -5980 ), ( 5354, -14389.5, -5900 ) );
			level.rocket_dude setgoalnode( ent[ 1 ] );			
	}	
//	level.rocket_dude waittill( "goal" );	
//	level.rocket_dude.ignoreall = false;
	wait( 0.3 );
	flag_set( "start_ambush" );
			
	// PlayFXontag( getfx( "elevator_top_explosions" ), origin_tag, "tag_origin" );	
//	playfx( level._effect[ "wall_explosion_small_elevator" ], level.player.origin + ( 0, 0, 120 ), ( 0, 270, 1 ) );	
	playfx( level._effect[ "wall_exp_rpg_rescue2" ], ( 5474, -14397.5, -5850 ), ( 0, 90, 1 ) );
	wait( 0.7 );
//	playfx( level._effect[ "wall_explosion_small_elevator" ], ( 5442, -14381.5, -5850 ), ( 0, 90, 1 ) );
	wait( 1 );
	if( isalive( level.rocket_dude ) )
	{
		level.rocket_dude kill();
	}
	
//	playfx( level._effect[ "wall_explosion_small_elevator" ], ( 5410, -14397.5, -5850 ), ( 0, 180, 1 ) );
}

elevator_passive_guys_think()
{
	self endon( "death" );
	self.health = 1;
	self.goalradius = 1;
	self.goalheight = 1;
	self.ignoreall = 1;
	self.ignoreme = 1;
	
	while( 1 )
	{
		if( level.player attackbuttonpressed() || flag( "elevator_one_attack_now" ) )
		{
			flag_set( "elevator_one_attack_now" );
			self.goalradius = 2048;
			self.goalheight = 20;
			self.ignoreall = 0;
			self.ignoreme = 0;
			wait randomfloatrange( 0.3, 0.6 );
			self kill();
          	break;
		}
		wait( 0.05 );
	}
	
	//	waittill the player presses the fire button
	//	trigger 
}


elevator_rocket_guys_runners()
{
	level endon( "elevator_one_attack_now" );
	level endon( "kill_first_tunnel_guys" );
//	while( !flag( "elevator_one_attack_now" ) )
//	{
//		array_spawn_targetname( "elevator_rocket_guys" );
//		wait randomfloatrange( 1, 1.7 );
//	}
}

elevator_rocket_guys_think()
{
//	level endon ( "elevator_one_attack_now" );
//	level endon( "kill_first_tunnel_guys" );
//	self endon ( "death" );
//	self.ignoreall = 1;
//	self set_generic_run_anim( "active_patrolwalk_gundown" );
//	self.ignoreall = true;
//	self.goalradius = 50;
//	node1 = getnode( "elevator_rocket_guys_two_goal", "targetname" );
//	node2 = getnode( "elevator_rocket_guys_two_goal_two", "targetname" );
//	self setgoalnode( node1 );
//	self waittill ( "goal" );
//	self delete();
}

elevator_sounds()
{
		wait( 1 ); // the sounds should start about about half way through the lower text on the screen.
		level.price thread play_sound_on_entity( "scn_rescue_elevator_takedown" );
		wait( 8.3 );
		//level.sandman dialogue_queue( "rescue_snd_ready" );
		wait( 1 );
		music_play( "rescue_2_elevator_beg" );
		level.elevator thread play_sound_on_entity( "elev_run_start" );
//		level.elevator thread ele_random_sparks_for_normal_movement();
		wait( 0.5 );
		level.elevator thread play_loop_sound_on_entity( "elev_run_loop" );
		flag_wait( "elevator_one_done_moving_new_beggining" );
		level.elevator thread stop_loop_sound_on_entity( "elev_run_loop" );
		waitframe();
		level.elevator thread play_sound_on_entity( "elev_run_end" );
		waitframe();
		level.elevator thread play_sound_on_entity( "elev_door_open" );
//		wait( 12 );
//		level.elevator thread stop_loop_sound_on_entity( "elev_door_open" );
		// stopsound
//		play_sound_in_space( "elev_run_end", level.elevator.origin );
//		play_sound_in_space( "elev_run_start", level.elevator.origin );
//		play_sound_in_space( "elev_door_interupt", level.elevator.origin );
//		play_sound_in_space( "elev_door_open", level.elevator.origin );
//		play_sound_in_space( "elev_door_close", level.elevator.origin );
//		wait( 2 );
}

control_player()
{
	level.player freezecontrols( true );
	wait( 6.4 );
	level.player freezecontrols ( false );
}

delta_squad_think()
{
	flag_wait( "elevator_one_done_moving" );
}

//#using_animtree ( "generic" );
elevator_friends_think()
{
	self.ignoreall = 1;
	
	num = RandomIntRange( 0, 2 ); 
//	switch ( num )
//	{
//		case 0:
//			self.deathanim = %RPG_stand_death_stagger;
//		case 1:
//			self.deathanim = %airport_security_guard_pillar_death_R;
//	}
}

// You can't have path nodes, on top of over path nodes with a burshmodel inbetween it.
elevator_pathnode_think()
{
//	clip = getent( "ele_fake_floor", "targetname" );
//	clip delete();
//	clip connectpaths();
}

elevator_doors() // add sparks and shakes...
{
//	Earthquake( 0.2, 12, level.player.origin, 300 );
	// The doors are already in position
	door_r = getent( "door_r", "targetname" );
	door_l = getent( "door_l", "targetname" );
	
	// new two sets of doors
	door_r_top = getent( "door_r_top", "targetname" );
	door_l_top = getent( "door_l_top", "targetname" );
	door_gate_top = getent( "door_gate_top", "targetname" );


	door_r_bottom = getent( "door_r_bottom", "targetname" );
	door_l_bottom = getent( "door_l_bottom", "targetname" );	
	door_gate_bottom = getent( "door_gate_bottom_two", "targetname" );
	
	flag_wait( "elevator_one_done_moving_new_beggining" );
	thread elevator_rocket_guys();
	door_r_top moveto( door_r_top.origin +( 90,0,0 ), 13, 1, 0.1 );
	door_l_top moveto( door_l_top.origin +( -90,0,0 ), 13, 1, 0.1 );
	// hook up for sound
	thread top_doors_stephen( door_r_top ,door_l_top, door_gate_top );
	
	level.elevator delayThread( 12, ::play_sound_on_entity, "elev_bell_ding" );
	level.price delayThread( 8 , ::dialogue_queue, "rescue_pri_now" );	
	delayThread( 10.6, ::radio_dialogue, "rescue_rno_12oclock" );			
	//	level.scr_sound["grinch"][ "rescue_rno_12oclock" ] 		= "rescue_rno_12oclock";
	//	level.grinch delayThread( 11.7, ::dialogue_queue, "rescue_rno_12oclock" );	
	ai_array = getaiarray( "axis" );
	foreach( ai in ai_array )
	{
		ai getenemyinfo( level.player );
	}
	
	
	wait( 2 );
	door_gate_top moveto( door_gate_top.origin +( 0,0,500 ), 900, 0.1, 0.1 );	
	door_r_top waittill ( "movedone" );
	
	flag_wait("elevator_one_done_moving" );
	
	thread crash_dialogue();
	wait( 4.1 );
	// sound hookup
	thread bottom_doors_stephen( door_r_bottom ,door_l_bottom, door_gate_bottom );
	 
	level.elevator delayThread( 0, ::play_sound_on_entity, "elev_bell_ding" );
	thread door_2( door_l_bottom );
	door_r_bottom moveto( door_r_bottom.origin +( 30,0,0 ), 3, 1, 0.1 );
	Earthquake( 0.1, 6, level.player.origin, 300 );
	door_r_bottom waittill ( "movedone" );
	level.elevator delayThread( 0, ::play_sound_on_entity, "elev_bell_ding" );
	wait( 0.9 );
	Earthquake( 0.3, 0.3, level.player.origin, 300 );
	door_r_bottom moveto( door_r_bottom.origin +( 13,0,0 ), 0.4, 0.1, 0.1 );
	door_r_bottom waittill ( "movedone" );
	door_r_bottom moveto( door_r_bottom.origin +( 90,0,0 ), 5, 0.1, 0.1 );
	Earthquake( 0.2, 0.2, level.player.origin, 300 );
	wait( 1.5 );
	door_gate_bottom moveto( door_gate_bottom.origin +( 0,0,500 ), 60, 0.1, 0.1 );
}

top_doors_stephen( door_r_top ,door_l_top, door_gate_top )
{
	door_l_top thread play_sound_on_entity ( "scn_rescue_elevatordoors_top_open_l" );
	door_r_top thread play_sound_on_entity( "scn_rescue_elevatordoors_top_open_r" );
	door_gate_top thread play_sound_on_entity( "scn_rescue_elevatordoors_top_open_m" );
}

bottom_doors_stephen( door_r_bottom ,door_l_bottom, door_gate_bottom )
{
	door_l_bottom thread play_sound_on_entity( "scn_rescue_elevatordoors_bottom_open_l" );
	door_r_bottom thread play_sound_on_entity( "scn_rescue_elevatordoors_bottom_open_r" );
	door_gate_bottom thread play_sound_on_entity( "scn_rescue_elevatordoors_bottom_open_m" );
}

crash_dialogue()
{
//	level.sandman radio_dialogue( "rescue_snd_whatwasthat" );
//	level.price radio_dialogue( "rescue_pri_deathtrap" );
//	iprintlnbold( "Sandman: What the hell was that!" );
	wait( 2 );
//	iprintlnbold( "Price: This tubes a death trap" );
	wait( 6 );
	display_hint( "nvg" );
	flag_wait( "turn_off_nvg" );
	display_hint( "disable_nvg" );
}

door_2( door_l )
{
	door_l moveto( door_l.origin +( -30,0,0 ), 3, 1, 0.1 );
	door_l waittill ( "movedone" );
	Earthquake( 0.3, 0.3, level.player.origin, 300 );
	wait( 1.7 );
	door_l moveto( door_l.origin +( -26,0,0 ), 0.2, 0.1, 0.1 );
	door_l waittill ( "movedone" );
	Earthquake( 0.2, 0.2, level.player.origin, 300 );
	wait( 0.7 );
//	level.elevator delayThread( 0, ::play_sound_on_entity, "elev_bell_ding" );
	door_l moveto( door_l.origin +( -80,0,0 ), 0.7, 0.1, 0.1 );
	door_l waittill ( "movedone" );
	Earthquake( 0.4, 0.7, level.player.origin, 300 );
}

// rotate the camera to simulate the elevator falling. 
elevator_shock( time )
{
	level.ground_ref_ent = spawn_tag_origin();
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );


		if ( level.right_to_left == 0 )
		{
			level.ground_ref_ent rotatepitch( -3, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 5, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -2, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
		else if ( level.right_to_left == 1 )
		{		
			level.ground_ref_ent rotatepitch( 3, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -5, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 2, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
		else if ( level.right_to_left == 2 )
		{		
			level.ground_ref_ent rotatepitch( 8, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -6, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 4, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
		else if ( level.right_to_left == 3 )
		{		
			level.ground_ref_ent rotatepitch( -8, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 6, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -4, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
		else if ( level.right_to_left == 4 )
		{		
			level.ground_ref_ent rotatepitch( 14, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -18, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 4, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
		else if ( level.right_to_left == 5 )
		{		
			level.ground_ref_ent rotatepitch( -16, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( 12, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			level.ground_ref_ent rotatepitch( -7, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
		}
}

// make primary light follow the elevator
elevator_lights_think() 
{
	light_origin = spawn ( "script_origin", level.elevator.origin + ( 0, 0, 0 ) );
	light_origin linkto( level.elevator );
	// jillian
	playfx( level._effect[ "spotlight_dlight" ], light_origin.origin , ( 0, 0, 1 ) );
	
//	light = get_Target_ent( "ele_one_light_two" );	
//	thread maps\jeremy_tools::flickering_light( light, 0.3, 1.5 );
//	light delete();
//	light = get_Target_ent( "ele_one_light_three" );	
//	thread maps\jeremy_tools::flickering_light( light, 0.3, 1.5 );
}

move_elevator_primary_light( light )
{
	light SetLightIntensity( 1.4 );
	light thread follow_elevator( self );
	light = get_Target_ent( "ele_one_light_two" );	
	thread maps\jeremy_tools::flickering_light( light, 0.3, 1.5 );
	light = get_Target_ent( "ele_one_light_three" );	
	thread maps\jeremy_tools::flickering_light( light, 0.3, 1.5 );
//	wait( 0.9 );
//	light notify( "stop_flicker" ); */
	
//	wait( 25 );
//	intensity = light GetLightIntensity();
//	while ( intensity > 0 )
//	{
//		intensity -= 0.1;
//		light SetLightIntensity( intensity );
//		wait( 0.05 );
//	}
//	light notify( "kill_light" );
//	wait( 0.05 );
//	light SetLightIntensity( 0 );
	// RefillClip
}

follow_elevator( light )
{
//	self endon( "kill_light" );
//	self endon( "elevator_one_done_moving" );
//	offset = ( self.origin - level.elevator.origin );
	while ( 1 )
	{
		self MoveTo( level.elevator.origin + ( 0, 0, 0 ), 0.05 );
		//self MoveTo( level.elevator.origin + offset, 0.05 );
		wait( 0.05 );
	}
}


// start the ambush segment.
#using_animtree( "generic_human" );
elevator_ambush()
{	
	flag_wait( "elevator_one_done_moving_new_beggining" );
//	thread radio_dialogue( "rescue_snd_stackup" );
	level.delta_two.ignoreall = 1;
//	iprintlnbold( " Price: Mccoy and Jordan , stack up on that door " );
//	iprintlnbold( " Note: Animation pop because were on a moving brush. " );
//	wait( 1 );
//	level.grinch thread anim_loop_solo(level.grinch, "coverstand_hide_idle" );
//	level.truck thread anim_loop_solo(level.truck, "coverstand_hide_idle" );
	guys = getaiarray( "allies" );
	foreach( ai in guys )
	{
		//ai notify ( "reload_start" );
		//weapon = ai getcurrentprimaryweapon();
		//ai setweaponammoclip(  , 0 );
		//ai.bulletsinclip = 0;
	}
	
//	level.delta_two stop_magic_bullet_shield();
//	level.delta_one stop_magic_bullet_shield();
	waitframe();
//	level.delta_one.dontdropweapon = true;
	level.delta_two.dontdropweapon = true;
//	level.delta_two unlink();
//	level.delta_one unlink();
//	level.delta_one.noragdoll = true;
	level.delta_two.noragdoll = true;
//	level.delta_one.damageshield = 0;
//	level.delta_two.damageshield = 0;
	waitframe();
//	node1 = getent( "delta_one",  "script_noteworthy" );
//	node2 = getent( "delta_two",  "script_noteworthy" );
//	node1 = get_Target_ent( "delta_one_cover" );
//	node2 = get_target_ent( "delta_two_cover" );
	
	//	node1 anim_reach_solo( level.delta_one, "node1" );
	//	node2 anim_reach_solo( level.delta_two, "node2" );
	//	node1 anim_single_solo( level.delta_one, "covercrouch_run_in_M" );
	//	node2 anim_single_solo( level.delta_two, "covercrouch_run_in_ML" );

// We used to need this.
//	level.delta_two thread anim_loop_solo( level.delta_two, "covercrouch_hide_idle" );
	flag_wait( "elevator_one_attack_now");
//	wait( 1.3 );
//	level.delta_one notify ( "stop_loop" );
//	level.delta_two notify ( "stop_loop" );
	
	
	//node1 notify ( "stop_loop" );
	//node2 notify ( "stop_loop" );
	waitframe();
//	flag_wait( "start_ambush" );
	if( IsAlive( level.delta_two ))
	{
		level.delta_two.ignoreall = 0;	
	}
	level.sandman.ignoreall = 0;	
	level.price.ignoreall = 0;
	level.truck.ignoreall = 0;		
	level.grinch.ignoreall = 0;
	
	level.sandman.ignoreme = 0;	
	level.price.ignoreme = 0;
	level.truck.ignoreme = 0;		
	level.grinch.ignoreme = 0;		
	
//	wait( 3 );

	
	// I need a few more explosions in here.
	//	wait( 10 );
	
//	thread magic_bullet_ambush();
	
	
	//level.delta_one.deathanim = %exposed_death_blowback;
	if( IsAlive( level.delta_two ))
	{
		level.delta_two.deathanim = %stand_death_shoulder_spin;
	}
	//exposed_death_blowback
	//stand_death_shoulder_spin
	//exposed_dive_grenade_b
	//exposed_dive_grenade_f
	//	node1 thread anim_single_solo( level.delta_one, "exposed_death_blowback" );
	//	node2 thread anim_single_solo( level.delta_two, "stand_death_shoulder_spin" );
	
	wait( 0.1 );
	wait( 0.3 );
	//	level.delta_two kill();
	//level.delta_one dodamage( level.delta_one.health + 5000, level.delta_one.origin  );
	//level.delta_two dodamage( level.delta_two.health + 5000, level.delta_two.origin  );
	//	wait( 1 );
	//	wait( 20 );
	// magic_bullet
	wait( 6 );
	flag_set( "elevator_one_ambush" ); // send elevator down
	
	wait( 1.3 ); // Fixes new face animation: This way he finishes his line before I kill him.
//	level.delta_one kill();
	if( IsAlive( level.delta_two ))
	{
		level.delta_two kill();
	}
	// make team get into position
	// make guys start to walk towards door..
	// spawn bullets from behind it
	// spawn explosion outside of door
	// drop elevator
	// slowly open and the close the doors as it drops..
}

// For now this is a long version of this.
// However I want them to shoot through at exact cadence.
magic_bullet_ambush()
{
	struct1 = getstruct( "rpd_one", "targetname" );
	struct2 = getstruct( "rpd_two", "targetname" );
	struct3 = getstruct( "rpd_three", "targetname" );
	struct4 = getstruct( "rpd_four", "targetname" );
	
	struct1_target = getstruct( "rpd_t_one", "targetname" );
	struct2_target = getstruct( "rpd_t_two", "targetname" );
	struct3_target = getstruct( "rpd_t_three", "targetname" );
	struct4_target = getstruct( "rpd_t_four", "targetname" );
	struct5_target = getstruct( "rpd_t_five", "targetname" );
	struct6_target = getstruct( "rpd_t_six", "targetname" );
	struct7_target = getstruct( "rpd_t_seven", "targetname" );
	struct8_target = getstruct( "rpd_t_eight", "targetname" );
	struct9_target = getstruct( "rpd_t_nine", "targetname" );
	struct10_target = getstruct( "rpd_t_ten", "targetname" );
	struct11_target = getstruct( "rpd_t_eleven", "targetname" );
	
	MagicBullet( "g36c_reflex", struct2.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct8_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex",struct1.origin, struct7_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct11_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct2.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct1_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct6_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct11_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct9_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct1_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct6_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct7_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct10_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct8_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct6_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct11_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct10_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct7_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct8_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct2.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct8_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex",struct1.origin, struct7_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct11_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct2.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct1_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct6_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct11_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct9_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct2_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct4.origin, struct3_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct1.origin, struct4_target.origin );
	wait( 0.005);
	MagicBullet( "g36c_reflex", struct3.origin, struct5_target.origin );
	wait( 0.005);
}
	
// player fights in dark with nightvision
battle_one_in_cave()
{
	wait( 10 );
	level.turn_on_color_node_one = getent( "ai_use_orange_cnodes_o0", "targetname" );
	enemies_to_trigger = getentarray( "cave_ambush_support", "targetname" );
	dead_guys_before_move = 2;
	seconds_to_wait = 4;
	thread kill_color_node_on_activation();
	flag_wait( "elevator_one_done_moving" );
	array_spawn_targetname( "cave_ambush" );
	wait( 1 );
	get_ai_flow( level.turn_on_color_node_one, undefined, enemies_to_trigger, seconds_to_wait, dead_guys_before_move, undefined, undefined );
	waitframe();
	thread delay_color_node_on();
	level.price set_ignoresuppression( true );
	level.truck set_ignoresuppression( true );
	level.sandman set_ignoresuppression( true );
	level.grinch set_ignoresuppression( true );
	flow_flag = get_target_ent( "flow_flag_one" );
	seconds_to_wait = 3;
	turn_on_color_node_one = getent( "ai_use_red_cnodes_r1", "targetname" );
	turn_on_color_node_two = getent( "ai_use_orange_cnodes_o1", "targetname" );
	dead_guys_before_move = 2;
	waitframe();
	wait( 4 );
	level.price set_ignoresuppression( false );
	level.truck set_ignoresuppression( false );
	level.sandman set_ignoresuppression( false );
	level.grinch set_ignoresuppression( false );
	retreat_location = getent ( "retreat_to_zipline", "targetname" );
	get_ai_flow( turn_on_color_node_one, turn_on_color_node_two, undefined, seconds_to_wait, dead_guys_before_move, undefined, flow_flag );
	//delaythread( 2, ::get_ai_flow );
	
	// wait till there is less than 30 percent
	// spawn guys from behind..
	// when down 20 percent... make them run away...
	
//	level.truck set_force_color( "o" );
//	level.grinch set_force_color( "o" );
}

delay_color_node_on()
{
	wait( 6 );
	level.truck set_force_color( "o" );
	level.grinch set_force_color( "o" );
}

kill_color_node_on_activation()
{
	level.turn_on_color_node_one waittill ( "trigger" );
	level.turn_on_color_node_one delete();
}

cave_dialoge()
{
	turn_on_color_node_one = getent( "ai_use_red_cnodes_r1", "targetname" );
	turn_on_color_node_one waittill( "trigger" );
	
	level.sandman dialogue_queue( "rescue_snd_sweepleft" );
	level.price dialogue_queue( "rescue_pri_onme" ); 
//	iprintlnbold ( "Price: Truck, Grinch take top side, Sandman follow me" );
}

// make certain ai crouch during the ambush
cave_ambush_think() //
{
	self endon ( "death" );
	flag_clear( "elevator_one_attack_now" );
	self.a.disableLongDeath = true;
	thread count_to_ten();
	self.ignoreall = 1;
	while( 1 )
	{
		if( level.player attackbuttonpressed() || flag( "elevator_one_attack_now" ) )
		{
			flag_set( "elevator_one_attack_now" );
			level.price.ignoreall = 0;
			level.truck.ignoreall = 0;
			level.grinch.ignoreall = 0;
			level.sandman.ignoreall = 0;
			self.goalradius = 2048;
			self.goalheight = 20;
			self.ignoreall = 0;
			self.ignoreme = 0;
	       	break;
		}
		wait( 0.05 );
	}
	
	while( 1 ) // fixes bug where the player would run away from these ai and leave them behind.
	{
		if( distance( level.player.origin, self.origin ) > 800 )
		{
			self.goalradius = 548;
			self setgoalentity (level.player);
			self waittill( "goal" );
			self.goalradius = 2048;
			break;	
		}
		wait( 0.05 );
	}
}

count_to_ten()
{
	wait( 8.5 );
	flag_set( "elevator_one_attack_now" );
}

// allow guys to sprint away, if they can when the battle is low.
cave_ambush_support_think()
{
//	self endon ("death");
//	self enable_sprint();
//	wait( 2 );
//	self disable_sprint();
}

// controller that allows me to, move up ai, turn on nodes, make guys retreat, activate new enemies_to_trigger
// track how many guys are alive, 
get_ai_flow( turn_on_color_node_one, turn_on_color_node_two
, enemies_to_trigger, seconds_to_wait, dead_guys_before_move, retreat_location, flow_flag )
{
	flag_clear( "get_ai_flow_clear" );
	level endon ( "get_ai_flow_clear" );
	while( 1 )
	{
		axis = getaiarray( "axis" );
		// get_living_ai_array( ai_to_track , "script_noteworthy" );
		if ( IsDefined ( dead_guys_before_move ) )
		{
		 	if ( axis.size <= dead_guys_before_move || flag( "flow_flag_player_ahead_spawn_enemies" ) )
			{
				if ( IsDefined ( turn_on_color_node_one ) )
					turn_on_color_node_one activate_trigger();
					waitframe();
					
				if ( IsDefined ( turn_on_color_node_two ) )
					turn_on_color_node_two activate_trigger();
					waitframe();
					
				if ( Isdefined ( seconds_to_wait ) )	
				{
					if( !flag( "flow_flag_player_ahead_spawn_enemies" ) )
						wait( seconds_to_wait );
				}
				
				if( IsDefined ( enemies_to_trigger ) )
					foreach( spawner in enemies_to_trigger )
					{
						spawner spawn_ai ();
						//array_spawn_targetname( enemies_to_trigger );•
					}
					
				if( IsDefined ( retreat_location ) )
					foreach ( ai in axis )
					{
						if( IsAlive( ai ) )
						{
								ai setgoalvolumeauto( retreat_location );
						}
					}	
				
				if( IsDefined ( flow_flag ) )
				{
					flow_flag delete();
				}
					
				flag_clear ( "flow_flag_player_ahead_spawn_enemies" );						
				flag_set( "get_ai_flow_clear" );
				break;
			}
		}
		wait( 0.05 );
	}
}

elevator_think_three() // super cool long as grind with shakes.. and then one more fall...
{
		battlechatter_off( "allies" );
		battlechatter_off( "axis" );
		player_speed_percent( 82 );
		level.elevator = getent( "elevator_one",  "targetname" );	
		script_model_ele_rescue = getent( "script_model_ele_rescue",  "targetname" );
		waitframe();
		script_model_ele_rescue linkto ( level.elevator );
		
		// ele_dust
		level.spark_lighters = getentarray( "sparks_origin", "script_noteworthy");
		
		foreach( origin_location in level.spark_lighters )
		{
			origin_location linkto( level.elevator );
		}
		
		elect_lighters = getentarray( "elect_sparks_origin", "script_noteworthy");
		foreach( origin_location in elect_lighters )
		{
			origin_location linkto( level.elevator );
		}		
		

		thread elevator_lights_think();
		level.elevator thread loop_sparks();
		if ( level.warp_elevator == 0 )
		{
			thread loop_ele_shakes();
			
			//////////////////////// 
			// attach models      //
			////////////////////////
			
			volume = getent ( "elevator_volume", "targetname" );
			boxes = getentarray ( "destructible_toys" ,"targetname" );
			wires = getentarray ( "wires" ,"targetname" );
			handles = getentarray ( "handles" ,"targetname" );
			electricle_boxes = getentarray ( "electricle_boxes" ,"targetname" );
			

				foreach ( box in boxes )
				{
					if( box istouching( volume ) )
					{
						origin_tag = spawn_tag_origin();
						origin_tag.origin = box.origin;
						origin_tag linkto ( box );
						box linkto ( level.elevator );
					}
				}
				
				foreach ( wire in wires )
				{
					if( wire istouching( volume ) )
					{			

						origin_tag = spawn_tag_origin();
						origin_tag.origin = wire.origin;
						origin_tag linkto ( wire );
						wire linkto ( level.elevator );
					}
				}

			
				foreach ( handle in handles )
				{
					if( handle istouching( volume ) )
					{	
						
						origin_tag = spawn_tag_origin();
						origin_tag.origin = handle.origin;
						origin_tag linkto ( handle );
						handle linkto ( level.elevator );
					}
				}
				
				foreach ( handle in electricle_boxes )
				{
						handle linkto ( level.elevator );
				}		
			wait( 4 );
//			light_model = getent( "elevator_one_light", "targetname"  );
//			origin_tag = spawn_tag_origin();
//			origin_tag.origin = light_model.origin;
//			origin_tag linkto ( light_model );
//			light_model linkto ( level.elevator );
//			PlayFXontag( getfx( "flashlight_spotlight" ), origin_tag, "tag_origin" );
			thread elevator_dialogue();
//			wait( 0.3 );
			level.sandman.ignoreall = true;
			level.grinch.ignoreall = true;
			level.truck.ignoreall = true;
			level.price.ignoreall = true;
					
			level.player allowjump( false );
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, 3000 ), 0.2, 0.1, 0.1 );
			level.elevator waittill ( "movedone" );
			
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}

			thread ele_guys_crouch();
			wait( 5 ); // timing with intro screen...
			wait( 0.7 );

			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -1500 ), 12.5, 0.1, 3 );			
//			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -3000 ), 12.5, 0.1, 3 );
			level.elevator waittill ( "movedone" );
			Earthquake( 0.2, 4.3, level.player.origin, 1500 );
			
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}
			
	//		level.elevator delayThread( 0, ::play_sound_on_entity, "elev_bell_ding" );	
			// move ele much higher
			// should just create an origin to go to.
			// level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -100 ), 4, 0.1, 3 );
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -130 ), 3, 0.1, 2.9 );
			level.elevator waittill ( "movedone" );
			
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}
			
			flag_set( "elevator_one_done_moving_new_beggining" );
			wait( 7 );
			flag_set( "kill_first_tunnel_guys" );		
			//  flag_set( "elevator_one_ambush" );
			flag_set( "start_ambush" );
			

			//flag_set( "start_ambush" );
			flag_wait( "elevator_one_ambush" );
			
			thread delete_tunnel_ai();
	
			level.sandman.animname = "generic";
			level.grinch.animname = "generic";
			level.truck.animname = "generic";
			level.price.animname = "generic";
			
			thread quick_elevator_reactions();
			
			// added a new quick stop at the top before it falls down.
			Earthquake( 1.3, 0.7, level.player.origin, 300 );
			level.player EnableInvulnerability();
			// this used to be 1000
			wait( 0.3 );
			thread elevator_rotation();
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -90 ), 0.4, 0.1, 0.1 );
			level.elevator thread play_sound_on_entity( "scn_rescue_elevator_crash_groan" );
			thread react_first_drop_dialogue();
			level.right_to_left = 2;
			time = 0.8;
			thread elevator_shock( time );
			level.elevator waittill ( "movedone" );
			// hook up for sound

			
			
			//electric_sparks = getent( "sparks_electricle_one", "script_noteworthy");
			//playfx( getfx( "electrical_transformer_spark_runner_loop" ), electric_sparks.origin, (0,0,1) );
			
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -20 ), 1.7, 0.1, 0.1 );
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}
			
			playfx( level._effect[ "wall_exp_rpg_rescue2" ], level.elevator.origin + ( 0, 0, 70 ), ( 0, 270, 1 ) );	
			Earthquake( 0.3, 0.7, level.player.origin, 300 );
			level.anim_times = 0;	
			thread quick_elevator_reactions_inbetween();
			//thread quick_elevator_reactions();
			
			wait( 2.5 ); //5.3
			level notify( "fall_1" );	
			// creawk ceak......... cable snap!!!!!
			
			level.price.ignoreall = 1;
			level.truck.ignoreall = 1;
			level.grinch.ignoreall = 1;
			level.sandman.ignoreall = 1;
			
			Earthquake( 0.7, 1, level.player.origin, 300 );
			// this used to be 1000
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -2358 ), 3.3, 0.1, 0.1 );
			level.elevator thread play_sound_on_entity( "scn_rescue_elevator_crash_snap" );
			thread quick_elevator_reactions_inbetween();
			level.elevator waittill ( "movedone" );
			// hook up for sound

			

			
			
			playfx( level._effect[ "wall_exp_rpg_rescue2" ], level.elevator.origin + ( 0, 0, -30 ), ( 0, 270, 1 ) );			
			level.player ShellShock( "default", 1 );
	
			
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}
			
//			thread quick_elevator_reactions_inbetween();
			Earthquake( 1.4, 1.4, level.player.origin, 300 );
			level.right_to_left = 4;
			time = 0.8; // was 0.8
			thread elevator_shock( time );
			wait( 1.3 );
			
			// new
			// 50 orig
			level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -307 ), 0.3, 0.1, 0.1 );
			level notify( "fall_3" );
			// level.elevator MoveTo ( level.elevator.origin + ( 0, 0, -50 ), 0.3, 0.1, 0.1 );
			
			level.elevator waittill ( "movedone" );
			
			// hook up for sound
			level.elevator thread play_sound_on_entity( "scn_rescue_elevator_crash_impact" );
			
//			playfx( getfx( "elevator_collapse_impact" ), level.elevator.origin + ( 0,0,-53 ), (0,0,1) );
			level.player disableweapons();
			level.player ShellShock( "rescue_2_ele_crash", 4.5 );
	
			level.player allowjump( true );
			
			foreach( origin_location in level.spark_lighters )
			{
				origin_location thread ele_dust();
			}
			
			Earthquake( 1.4, 1.4, level.player.origin, 300 );
			
			
			thread quick_elevator_reactions_two();
			autosave_by_name( "elevator_one_done_moving" );
			level.right_to_left = 4;
			time = 0.8;
			thread elevator_shock( time );
			flag_set( "elevator_one_done_moving" );
			fx_volume_pause_noteworthy( "clean_fx_for_elevator_shaft"); // stop fx above the elevator crash.
			
//			struct = getstruct("dust_elevator", "targetname");
//			playfx( getfx( "explosion_type_1" ), struct.origin, (0,0,1) );
		//	flag_set( "sparks_elevator_one" );

			level.player DisableInvulnerability();
			wait( 1 );
			time = 0.8;
			level.ground_ref_ent rotatepitch( 8, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			playfx( getfx( "elevator_collapse_impact" ), level.elevator.origin + ( 0,0,-53 ), (0,0,1) );
			wait( 0.4 );
//			electric_sparks = getent( "sparks_electricle_two", "script_noteworthy");
//			playfx( getfx( "electrical_transformer_spark_runner_loop" ), electric_sparks.origin, (0,0,1) );
			electric_sparks = getent( "sparks_electricle_three", "script_noteworthy");
			playfx( getfx( "electrical_transformer_spark_runner_loop" ), electric_sparks.origin + ( 147 ,125, -50 ), (0,0,1) );			
			playfx( getfx( "electrical_transformer_spark_runner_loop" ), electric_sparks.origin + ( -144 ,125, -50 ), (0,0,1) );			
			wait( 3.3 ); 
			level.player enableweapons();
			thread turn_off_grenade_awareness();
			flag_wait( "reset_angles" );
			time = 0.3;
			level.ground_ref_ent rotatepitch( -16, time, time/2, time/2 );
			level.ground_ref_ent waittill( "rotatedone" );
			wait( 1 );
			autosave_by_name( "elevator_one_done_moving" );
		}
}

turn_off_grenade_awareness()
{
	level.sandman.grenadeawareness = false;
	level.grinch.grenadeawareness = false;
	level.truck.grenadeawareness = false;
	level.price.grenadeawareness = false;
	wait( 8 );	
	level.sandman.grenadeawareness = true;
	level.grinch.grenadeawareness = true;
	level.truck.grenadeawareness = true;
	level.price.grenadeawareness = true;	
}

unlink_ele_ai()
{
	musicstop();
	level.price unlink();
	level.truck unlink();
	level.grinch unlink();
	level.sandman unlink();
	wait( 3.4 );
	level.sandman dialogue_queue( "rescue_snd_status" );
	wait( 0.2 );
	level.truck dialogue_queue( "rescue_rno_imgood" );
	wait( 0.3 );
	level.grinch dialogue_queue( "rescue_rno_wereclear" );
	wait( 0.3 );
	level.sandman dialogue_queue( "rescue_snd_headsup" );
	wait( 0.3 );
	musicplay( "rescue_2_elevator_crash", 0 );
	level.sandman enable_cqbwalk();
	level.truck enable_cqbwalk();
	level.grinch enable_cqbwalk();
	level.price enable_cqbwalk();
	wait( 7 ); 
	musicplay( "rescue_2_action_3", 0 );
}

// the rotating after you hit feels off.
elevator_rotation()
{
	level.elevator rotatepitch ( -5, 0.3, 0.1, 0.1 );
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( 10, 0.3, 0.1, 0.1 ); // 0 is the middle
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( -7, 0.4, 0.1, 0.1 ); // 7 to the side
	level waittill( "fall_1" );	
	level.elevator rotatepitch ( 11, 0.8, 0.1, 0.1 ); // 4 over
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( -10,0.8, 0.1, 0.1 ); // - 6 the other side 
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( 13, 0.8, 0.1, 0.1 ); // 7 to the other side
	level waittill( "fall_3" );
	level.elevator rotatepitch ( -10, 0.8, 0.1, 0.1 );
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( 6, 0.8, 0.1, 0.1 );
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( -6, 0.8, 0.1, 0.1 ); // -3 over
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( 10, 0.3, 0.1, 0.1 );
	level.elevator waittill ( "rotatedone" );
	level.elevator rotatepitch ( -12, 0.3, 0.1, 0.1 ); // - 6	
	level.elevator waittill ( "rotatedone" );
	thread unlink_ele_ai();
}

react_first_drop_dialogue()
{
	wait( 1.7 );
	level.sandman dialogue_queue ( "rescue_snd_whatwasthat" );
	wait( 0.8 );
	level.price dialogue_queue( "rescue_pri_deathtrap" );
}

loop_ele_shakes()
{
	wait( 5 );
	num = RandomfloatRange( 0.5, 1.3 );
	num2 =	RandomfloatRange( 1.7, 2.5 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
	Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
		Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
		Earthquake( 0.2, num, level.player.origin, 1500 );
	wait( num2 );
		Earthquake( 0.2, num, level.player.origin, 1500 );
}

delete_tunnel_ai()
{
	
	maps\_spawner::killspawner( 20 );
	waitframe();
	
	enemies = getaiarray( "axis" );
	foreach( ai in enemies )
	{
		if( IsAlive( ai ) )
			ai delete();
	}
}

quick_elevator_reactions()
{
	
	level.sandman thread anim_single_solo(level.sandman, "stunned2" );
	wait( 0.3 ); 
	level.grinch thread anim_single_solo(level.grinch, "stunned1" ); 
	wait( 0.3 );
	level.truck thread anim_single_solo(level.truck, "stunned1" ); 
	wait( 0.2 );
	level.price thread anim_single_solo(level.price, "stunned2" ); 
}

quick_elevator_reactions_inbetween()
{	
	level.anim_times ++;
	if ( level.anim_times == 1 )
	{
		level.sandman thread anim_single_solo(level.sandman, "hijack_generic_stumble_stand1" );
		wait( 0.3 ); 
		level.grinch thread anim_single_solo(level.grinch, "hijack_generic_stumble_crouch1" ); 
		wait( 0.3 );
	//	level.truck thread anim_single_solo(level.truck, "hijack_generic_stumble_stand2" ); 
		wait( 0.2 );
		level.price thread anim_single_solo(level.price, "hijack_generic_stumble_crouch2" ); 	
	}
	else if ( level.anim_times == 2 )
	{
		level.sandman thread anim_single_solo(level.sandman, "hijack_generic_stumble_crouch2" );
		wait( 0.3 ); 
		level.grinch thread anim_single_solo(level.grinch, "hijack_generic_stumble_stand1" ); 
		wait( 0.3 );
		level.truck thread anim_single_solo(level.truck, "hijack_generic_stumble_crouch1" ); 
		wait( 0.2 );
		level.price thread anim_single_solo(level.price, "hijack_generic_stumble_stand2" ); 	
	}
}

quick_elevator_reactions_two()
{		
	level.price thread anim_single_solo(level.price, "stunned2" );
	wait( 0.3 );
	level.grinch thread anim_single_solo(level.grinch, "stunned1" ); 
	wait( 0.2 );
	level.sandman thread anim_single_solo(level.sandman, "stunned2" ); 			
	wait( 0.1 );
	level.truck thread anim_single_solo(level.truck, "stunned1" );
	waitframe();	
	level.sandman.animname = "sandman";
	level.grinch.animname = "grinch";
	level.truck.animname = "truck";
	level.price.animname = "price"; 
} 

elevator_dialogue()
{
	wait( 9 ); // intro
	level.sandman.animname = "sandman";
	level.grinch.animname = "grinch";
	level.truck.animname = "truck";
	level.price.animname = "price"; 
	
//	level.sandman playsound( "rescue_pri_diamondmine" );
	level.grinch dialogue_queue( "rescue_pri_diamondmine" ); //level.price
//	level.sandman dialogue_queue( "rescue_pri_wayacross" ); // price
	wait( 1 );
//	level.sandman dialogue_queue( "rescue_snd_rogerthat" ); //level.sandman
	guys = getaiarray( "allies" );
	foreach( ai in guys )
	{
		ai.bulletsinclip = 2;
	}

	wait( 6.3 );
//	level.sandman dialogue_queue( "rescue_snd_getready" ); //level.sandman
	
//	 level.price radio_dialogue( "rescue_pri_stillalive" ); // level.price
}

// play cool sparks as the ele falls down.
loop_sparks()
{
	// ele_dust
//	level.spark_lighters = getentarray( "sparks_origin", "script_noteworthy");

	flag_wait( "elevator_one_ambush" );
	wait( 2.3 );
	foreach( origin_location in level.spark_lighters )
	{	
		origin_location_tag = spawn_tag_origin();
		origin_location_tag thread manual_linkto( origin_location );
		//origin_location_tag linkto ( origin_location.origin );
		origin_location_tag thread ele_sparks();
	}
	
	flag_wait( "elevator_one_done_moving" );
	wait( 2 );
	foreach( origin_location in level.spark_lighters )
	{	
		//if( Isdefined( origin_location.script_parameters ) && origin_location.script_parameters == "stop_sparks")
		//{
		if( origin_location.targetname == "sparks_after" )
		{
			//origin_location thread ele_sparks_two();
		}
		//}
	}
}

ele_random_sparks_for_normal_movement()
{
	while( !flag ("elevator_one_done_moving_new_beggining") )
	{
		num = RandomIntRange( 0,8 );
		switch( num )
		{
			case 0:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 0 ].origin, (0,0,1) );	
			case 1:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 1 ].origin, (0,0,1) );	
			case 2:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 2 ].origin, (0,0,1) );	
			case 3:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 3 ].origin, (0,0,1) );	
			case 4:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 4 ].origin, (0,0,1) );	
			case 5:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 5 ].origin, (0,0,1) );	
			case 6:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 6 ].origin, (0,0,1) );	
			case 7:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 7 ].origin, (0,0,1) );
			case 8:
				playfx( getfx( "saw_sparks_one" ), level.spark_lighters[ 8 ].origin, (0,0,1) );		
		}
		wait RandomfloatRange( 0.7, 2);
	}
}

// used with ele going down
ele_sparks()
{
	level endon ( "elevator_one_done_moving" ); 
//	if( IsDefined ( self.targetname ) && self.targetname == "sparks_twelve" || self.targetname == "sparks_eleven" || self.targetname == "sparks_one" || self.targetname == "sparks_two" || self.targetname == "sparks_three" || self.targetname == "sparks_four" )
//	{
		playfxOnTag( getfx( "sparks_falling_runner_elevator" ), self, "tag_origin" );
//	}	
}

// turn these on after the crash.
ele_sparks_two()
{
	level endon ( "elevator_one_done_moving" ); 
	while ( 1 )
	{
		//wait randomfloatrange( .1 );
		//playfx( getfx( "saw_sparks_one" ), self.origin, (180,0,1), ( 0,0,270) );
		playfx( getfx( "saw_sparks_one" ), self.origin, (180,0,1), ( 0,0,270 ) );
		wait( 0.2 );
	}	
}

ele_dust()
{
		wait randomfloatrange( 0 , 1 ); 
		playfx( getfx( "dust_elevator_shake" ), self.origin, (0,0,1) );
}

// Add ambience to this scene
// TODO make guys reload
// play sound cool talking and looking anims
ele_guys_crouch()
{
	level.sandman allowedstances( "crouch" );
	level.price allowedstances( "crouch" );
//	flag_wait( "elevator_one_done_moving_new_beggining");	
	wait( 3.5 );
	level.truck allowedstances( "crouch" );
//	level.delta_one delete();
//	level.delta_one allowedstances( "crouch" );
	wait( 0.3);
	level.delta_two allowedstances( "crouch" );
	wait( 0.3);
	wait( 0.3);
	wait( 0.3);
	level.grinch allowedstances( "crouch" );
//	level.delta_two thread anim_single_solo( level.delta_two, "ny_manhattan_radio_talk_idle" );
	wait( 2.3 );
	level.truck thread anim_single_solo( level.truck, "ny_manhattan_radio_sandman_talk" );
	wait( 3.3 );
	level.grinch thread anim_single_solo( level.grinch, "ny_manhattan_radio_talk_idle" );
	
	flag_wait( "elevator_one_done_moving_new_beggining" );
	level.grinch StopAnimScripted();
	level.truck StopAnimScripted();
	level.delta_two StopAnimScripted();
	
	flag_wait( "elevator_one_done_moving" );
	level.truck allowedstances( "crouch", "stand", "prone" );
	level.sandman allowedstances( "crouch", "stand", "prone" );
	level.price allowedstances( "crouch", "stand", "prone" );
	level.grinch allowedstances( "crouch", "stand", "prone" );

}

elevator_opening_setup() // Ai ambush player at elevator
{
	//	level.warp_elevator = 1;
	//warp_elevator
	//	thread elevator_think( level.warp_elevator );
	// the doors open here
}

// battle with reppelling ai
zip_line_cave_setup() // Ai drop down from elevated positions using zip lines
{
	thread bay_small_door();
	thread zipline_dialouge();
	//	array_spawn_targetname( "cave_rappel_rpg" );	
	//	array_spawn_targetname( "cave_rappel" );
	//	guy = get_living_ai( "straight", "script_noteworthy" );
	trigger = getent( "spawn_rappel","targetname" );
	trigger waittill( "trigger" );
	playfx( level._effect[ "rescue_2_haxon_light" ], ( 6262, -12214.5, -8535 ), ( 0, 0, 1 ) );
	playfx( level._effect[ "hijack_fxlight_red_blink" ], ( 6132, -11016, -8446 ), ( 0, 0, 1 ) );	
	playfx( level._effect[ "hijack_fxlight_red_blink" ], ( 5784, -11010, -8450 ), ( 0, 0, 1 ) );	
	playfx( level._effect[ "hijack_fxlight_red_blink" ], ( 6490, -11522, -8498 ), ( 0, 0, 1 ) );
	autosave_by_name( "zip_line_cave" );
	//seconds_to_wait = 0;
	
	array_spawn_targetname( "cave_rappel_ground" );
	//wait( 3 );
	flag_wait( "now_spawn_rappel" );
	thread guys_that_lead_players_eye();
	thread cave_lead_player_eye_ground_left();
	thread dialogue_cave();
	array_spawn_targetname( "cave_rappel" );
	flow_flag = get_target_ent( "flow_flag_two" );
	turn_on_color_node_one = getent( "ai_use_orange_cnodes_o4", "targetname" );
	turn_on_color_node_two = getent( "ai_use_orange_cnodes_r5", "targetname" );
	enemies_to_trigger = getentarray( "cave_rappel_rpg", "targetname" );
	dead_guys_before_move = 8;
	get_ai_flow( undefined, undefined, enemies_to_trigger, undefined, dead_guys_before_move, undefined, undefined );
	dead_guys_before_move = 4;
	retreat_location = GetEnt( "retreat_to_cave", "targetname" );
	get_ai_flow( turn_on_color_node_one, turn_on_color_node_two, undefined, undefined, dead_guys_before_move, undefined, flow_flag );
}

// I should turn on their flash light as well.
guys_that_lead_players_eye()
{
	array_spawn_targetname( "cave_lead_player_eye_top" );
}

cave_lead_player_eye_top_think()
{
	node = getnode( "cave_lead_player_eye_top_goal", "targetname" );
	self.moveplaybackrate = 0.8; 
	self.ignoreme = true;
	self.ignoreall = true;
	self.health = 200;
	self.goalradius = 20;
	self.goalheight = 20;
	wait( 0.5 ); 
	self setgoalnode( node );
	self waittill( "goal" );  
	self delete();
}

cave_lead_player_eye_ground_left()
{
	array_spawn_targetname( "cave_lead_player_eye_ground_left" ); 
}

cave_lead_player_eye_ground_left_think()
{
	node = getnode( "cave_lead_player_eye_ground_left_goal", "targetname" );
	self.ignoreall = true;
	self.ignoreme = true;
	self.health = 1;
	self.goalradius = 20;
	self.goalheight = 20;
	self.combatmode = "no_cover";
	self setgoalentity( node );
	self waittill( "goal" ); 
	self.ignoreall = false;
	self.goalradius = 2048;
}

zipline_dialouge()
{
	turn_on_color_node_one = getent( "ai_use_orange_cnodes_o4", "targetname" );
	turn_on_color_node_one waittill( "trigger" );
	array_spawn_targetname( "cave_rappel_ground_3rd_wave" ); 
	
	wait( 1.3 );
	level.price dialogue_queue( "rescue_pri_sortemout" );
	musicstop( 6 );
	//iprintlnbold ( "Price: Mop em up!" );
}

dialogue_cave()
{
	wait( 4 );
	level.truck dialogue_queue( "rescue_trk_targetshigh" );
	wait( 0.4 );
	level.grinch dialogue_queue( "rescue_rno_iseeem" );
//	iprintlnbold( "Above US!!!!!" );
}

// Make thie door open so guys can retreat through it.
// Then close the door as they do.
bay_small_door() 
{
	level.small_bay_door_safety_clip = getent( "small_bay_door_safety_clip", "targetname" );
	level.small_bay_door = getent( "bay_small_door", "targetname" );
	level.bay_small_door_break = getent( "bay_small_door_breawk", "targetname" );
	burn_background = getent( "burn_background", "targetname" );
	// Hide burn decals
	burns = getentarray( "burns", "script_noteworthy" );
	foreach( decal in burns )
	{
		decal linkto ( level.small_bay_door );
		//decal linkto ( level.small_bay_door, "", (0, 0, -50), (0, 0, 0) );
		//decal moveto( level.small_bay_door.origin +( -1, 30,0 ), 0.1 );
		decal hide();
	}
	burn_background linkto ( level.small_bay_door );
	burn_background hide();
	//	bay_small_door_pipe_one_top = getent( "bay_small_door_pipe_one_top", "targetname" );
	//	bay_small_door_pipe_one_bottom = getent( "bay_small_door_pipe_one_bottom", "targetname" );
	//	bay_small_door_pipe_two_top = getent( "bay_small_door_pipe_two_top", "targetname" );
	//	bay_small_door_pipe_two_bottom = getent( "bay_small_door_pipe_two_bottom", "targetname" );
	//bay_small_door_wheel = getent( "bay_small_door_wheel", "targetname" );
 	
 //	bay_small_door_pipe_one_top linkto ( level.small_bay_door );
 //	 bay_small_door_pipe_one_top connectpaths();
 //	bay_small_door_pipe_one_bottom linkto ( level.small_bay_door );
 //	 bay_small_door_pipe_one_bottom connectpaths();
 //	bay_small_door_pipe_two_top linkto ( level.small_bay_door );
 //	 bay_small_door_pipe_two_top connectpaths();
 //	bay_small_door_pipe_two_bottom linkto ( level.small_bay_door );
 //	 bay_small_door_pipe_two_bottom connectpaths();
 	level.bay_small_door_break linkto ( level.small_bay_door );
 	//bay_small_door_wheel linkto ( level.small_bay_door );
 	level.bay_small_door_break connectpaths();
 	
 	level.small_bay_door rotateyaw( 80, 0.3, 0.1, 0.1 );
 	level.small_bay_door connectpaths();
 	flag_wait( "cave_runner_close_door" );
 	
 	dudes = getaiarray( "axis" );
 	foreach ( ai in dudes )
 	{
 		if ( IsDefined ( ai.script_noteworthy ) && ai.script_noteworthy == "up_top" )
 		{
 			ai Kill();
 		}
 	}
 	autosave_by_name( "cave_runner" );
 	level.small_bay_door thread bay_door_kill_player_when_too_close_to_door();
 	wait( 6 ); // wait till ai are dead of they are through the door.
 	level.small_bay_door rotateyaw( -80, 1, 0.1,0.1  );
 	level.small_bay_door disconnectpaths();
 	level.bay_small_door_break disconnectpaths();
 	level.small_bay_door waittill ("rotatedone");
 	level.small_bay_door_safety_clip delete();
 	
 	axis = getaiarray( "axis" ); 	
		foreach ( ai in axis )
		{
			if ( !IsAlive( ai ) )
			{
				continue;
			}
	
			if ( ai.origin[ 1 ] < -9748 )
			{
				continue;
			}
			
			ai delete();
		}
}

bay_door_kill_player_when_too_close_to_door()
{
	self endon ( "death" );
	num = 0;
	while( num <= 20 ) // this waits around 6 seconds, this will kill the player who is rushing by the ai.
	{
		num ++;
		if( distance( level.player.origin, self.origin ) < 100 )
		{
			level.player dodamage( level.player.health + 2, level.player.origin );
			wait( 0.3 );
			playfx( level._effect[ "wall_exp_rpg_rescue2" ], level.player.origin + ( 0, 0, 20 ), ( 0, 270, 1 ) );	;
			level.player playsound ( "grenade_explode_concrete" );
			Earthquake( 0.6, 1, level.player.origin, 300 );
			level.player dodamage( level.player.health + 2, level.player.origin );
			wait( 0.3 );
			level.player kill();
			break;
		}
		wait( 0.3 );
	}
}

// Quick system for playing anims of ai off of structs
// This function will be shorter, for now I did long because I was trying different things.
cave_rappel_think() 
{
	self endon ( "death" );
	self.animname = "generic";
	self.goalradius = 2;
	self.ignoreMe = 1;
	self.ignoreall = 1;
	self.health = 1;
	self disable_long_death();
	self thread interrupt_anim_on_damage_jl();
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "straight_1" )
	{
		self allowedstances( "stand" );
		wait( 0.1 );
		node_start = get_target_ent( "straight_1" );		
//		self thread follow_path_waitforplayer( node_start, undefined );
//		self thread enemy_rappel_anim_think();
//		wait( 1 );		
//			while ( self getAnimTime( getgenericanim("rappel_skylight_drop") ) < 0.96 )
//		wait ( 0.05 );
//			animation = self getAnim_Generic(  "rappel_skylight_drop" );
//			for ( ;; )
//			{
//				if ( self GetAnimTime( animation ) >= 0.96 )
//					break;
//				wait( 0.05 );
//			}
//			self notify( "killanimscript" );
		self.ignoreall = 0;
		self.ignoreme = 0;
		self.goalradius = 2000;
		self.goalheight = 100;
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "straight_2" )
	{
		wait( 2 );
		node_start = get_target_ent( "straight_2" );
		self thread follow_path_waitforplayer( node_start, undefined );
	//	self thread enemy_rappel_anim_think();
		wait( 2 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		self.goalradius = 2000;
		self.goalheight = 100;
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "straight_3" )
	{
		wait( 3 );
		node_start = get_target_ent( "straight_4" );
		self thread follow_path_waitforplayer( node_start, undefined );
		wait( 2 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		self.goalradius = 2000;
		self.goalheight = 100;
	}
	
	wait( 5 );
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "left_1" )
	{
		wait( 4 );
		self.ignoreall = 0;
		self.ignoreme = 0;

		struct = get_target_ent( "left_1" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "left_2" )
	{
		wait( 5 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		wait( 5 );
		struct = get_target_ent( "left_2" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "left_3" )
	{
		wait( 6 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		struct = get_target_ent( "left_3" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "right_1" )
	{
		wait( 8 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		struct = get_target_ent( "right_1" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "right_2" )
	{
		wait( 9 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		struct = get_target_ent( "right_2" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "right_3" )
	{
		wait( 10 );
		self.ignoreall = 0;
		self.ignoreme = 0;
		struct = get_target_ent( "right_3" );
		if ( IsDefined( struct.animation ) )
			self thread rope_think( struct );
	}
}

interrupt_anim_on_damage_jl( )
{
	self endon( "end_reaction" );
	self endon( "animation_killed_me" );
	self waittill( "damage" );
	self StopAnimScripted();
//	iprintlnbold( "I'm HIT" );
//	self notify( "stop_loop" );
}

enemy_rappel_anim_think()
{
	self endon( "death" );
	wait( 2.0 );
	while ( self getAnimTime( getgenericanim("rappel_skylight_drop") ) < 0.96 )
		wait ( 0.05 );	
	self notify( "killanimscript" );
}

#using_animtree( "script_model" );
rope_think( struct )
{
	self endon( "death" );

	self.animname = "generic";

	reference = struct;
	reference anim_first_frame_solo( self, self.animation );

	wait( 0.5 );

	eRopeOrg = Spawn( "script_origin", reference.origin );
	eRopeOrg.angles = reference.angles;

	eRope = Spawn( "script_model", eRopeOrg.origin );
	eRope SetModel( "coop_bridge_rappelrope" );
	eRope.animname = "rope_two";
	eRope assign_animtree();

	eRopeOrg anim_first_frame_solo( eRope, "coop_ropedrop_01" );
	eRopeOrg anim_single_solo( eRope, "coop_ropedrop_01" );

	self.allowdeath = true;
	eRopeOrg thread anim_single_solo( eRope, "coop_" + self.animation );
	reference thread anim_generic( self, self.animation );
	
	if ( IsDefined( self.script_vehicleride ) )
	{
		self waittill( "jumpedout" );
		wait 0.5;
	}
	eRope thread cleanup_rope();
	
	self.goalradius = 2048;
	self SetGoalEntity( level.player );
	self waittill( "goal" );
	self.health = 100;
	self.goalradius = 2048;
	self.goalheight = 200;
}

cleanup_rope()
{
	wait( 4.3 );
	eRope_origin = spawn ( "script_origin", self.origin );
	self linkto( eRope_origin );
	eRope_origin moveto ( eRope_origin.origin + ( 0, 0, -500 ), 0.3 );
	eRope_origin waittill( "movedone" );
	eRope_origin delete();
}

cave_rappel_ground_think() // when on the ground, do this.
{
}

// Support ai for this battle
cave_rappel_rpg_think()
{
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "up_top" )
	self allowedstances( "stand" );
	self.dontdropweapon = 1;
	self.goalradius = 20;
	self.goalheight = 20;
	self.health = 10;
}

// These guys run away in the cave, this should tie the battle together.
bay_runner_think()
{
	self.ignoreall = 1;
	self.ignoreme = 1;
	self.goalradius = 10;
	self.disablepain = true;
	self.grenadeawareness = false;
	self setflashbangimmunity( true );
	self.moveplaybackrate = 1.3;
	//	self.deathanim = // I want to make sure the one guys always does the slow death here.
	node = GetNode( "bay_runner_delete_me", "targetname" );
	waitframe();
	self enable_sprint();
	self SetGoalNode( node );
	wait( 2 );
	self waittill ( "goal" );
	self disable_sprint(); // guys don't sprint any more which fixes the sliding.
	self.ignoreme = 0;
	self Delete();
}

bay_runner_think_two()
{
	self.ignoreall = 1;
	self.health = 10;
	self.goalradius = 300;
	wait( 0.4 );
	node = GetNode( "bay_runner_delete_me", "targetname" );
	self SetGoalNode( node );
	self waittill ( "goal" );
	self kill();
//	self Delete();
}

// Ai saws door
// Once done enemy ai is seen running away.
// Then trigger color node to send friends in.
cave_saw_to_bay()
{
	flag_wait( "saw_door" );

	all_dead_before_move();
	
	autosave_by_name( "saw_door" );
	thread saw_door_dialogue();
	level.truck disable_cqbwalk();
	musicplay( "rescue_2_elevator_beg", 0 );
	//musicplay( "rescue_2_elevator_beg", 0 );
	node1 = get_target_ent ( "ludes_test2" );
	node1 anim_reach_solo ( level.truck, "rescue_saw_cutter" );
	level.bay_small_door_break connectpaths();
	level.bay_small_door_break unlink();
//	node1 anim_reach_solo ( level.truck, "saw_side_pickup" );
//	level.truck thread saw_sound_and_fx();
	
	node1 thread anim_single_solo ( level.truck, "rescue_saw_cutter" );
	wait( 9 );
	// 15.26667
	vec = VectorNormalize(level.player.origin - level.bay_small_door_break.origin);
//	p PhysicsLaunchClient( p.origin, vec*0.1 );
	mod = random( [200,350,450] );
	level.bay_small_door_break MoveGravity( vec*mod, 10 );
	level.bay_small_door_break RotateVelocity( (RandomFloatRange(-40,40),RandomFloatRange(-40,40),RandomFloatRange(-40,40) ), 10 );
	wait( 3.26667 );
	level.truck thread truck_hold_door_new();
	node4 = get_target_ent ( "kick_door_one" );
	node4 anim_reach_solo ( level.price, "doorkick_2_cqbwalk" );

	node4 thread anim_single_solo ( level.price, "doorkick_2_cqbwalk" );
	rotate_too = 100;
	
	fxnode = getstruct ( "saw_door_kick_fxnode", "targetname" );
	level.small_bay_door = getent( "bay_small_door", "targetname" );
	
	// scn_rescue_chopsaw_door_kick this is the new sound to play when kicking door.
	door_l = level.small_bay_door;
	waitframe();
	// added sound kick.
	
	thread kick_double_door_open( 	door_l, undefined, "scn_rescue_chopsaw_door_kick", 0.5, rotate_too, fxnode );
	door_l connectpaths();
	flag_set( "start_bay_sequence" );
	flag_set( "start_bay_runners" ); // sends enemies running
//	wait( 1 );
	level.price.disable_pain = true;
	level.truck.disable_pain = true;
	level.sandman.disable_pain = true;
	level.grinch.disable_pain = true;
	
	level.price set_ignoresuppression( true );
	level.truck set_ignoresuppression( true );
	level.sandman set_ignoresuppression( true );
	level.grinch set_ignoresuppression( true );

	level.price set_force_color( "r" ); 
	level.truck set_force_color( "r" ); 
	level.grinch set_force_color( "r" );
	flag_set( "saw_door_open" ); 		
	battlechatter_on( "allies" );
	//activate_trigger_with_targetname( "send_allies_through_door" );
	delaythread ( 0.3, ::activate_trigger_with_targetname,  "send_allies_through_door" );
	playfx( level._effect[ "rescue_2_haxon_light" ], ( 6055, -8260, -8440 ), ( 0, 0, 1 ) );
	autosave_by_name( "saw_in_bay_batle" );
	
	wait( 6 );
	level.price.disable_pain = true;
	level.truck.disable_pain = true;
	level.sandman.disable_pain = true;
	level.grinch.disable_pain = true;
	level.price set_ignoresuppression( false );
	level.truck set_ignoresuppression( false );
	level.sandman set_ignoresuppression( false );
	level.grinch set_ignoresuppression( false );
}


truck_hold_door_new()
{
	wait( 3 );
	level.truck thread anim_generic_loop( level.truck, "corner_standL_alert_idle" );
	flag( "start_bay_runners" );
	wait( 9 );
	level.truck anim_stopanimscripted();
	level.truck thread enable_cqbwalk();
}


all_dead_before_move()
{
	level endon ( "saw_door_open" );
	num = 0;


	while( 1 )
	{
		axis = getaiarray( "axis" );
		if( axis.size == num )
		{
			return;
		}
		foreach ( ai in axis )
		{
			if ( !IsAlive( ai ) )
			{
				continue;
			}
	
			if ( ai.origin[ 1 ] > -10200 || ai.origin[ 2 ] > -8444 )
			{
				continue;
			}
			
	//		level.player.origin, distance
			
			ai thread seek_player();
		}
		wait(0.5);
	}
}

seek_player()
{	
	self.goalradius = 148;
	self setgoalentity(level.player);
}

burn_decal_start()  
{
	burn_one = get_target_ent( "burn_one" );
	burn_two = get_target_ent( "burn_two" );
	burn_three = get_target_ent( "burn_three" );
	burn_four = get_target_ent( "burn_four" );
	burn_five = get_target_ent( "burn_five" );
	burn_six = get_target_ent( "burn_six" );
	burn_background = getent( "burn_background", "targetname" );
	
	burn_background show();
	burn_one show();	
	wait( 0.4 );
	burn_two show();
	wait( 0.4 );
	burn_three show();
	wait( 0.4 );
	burn_four show();
	wait( 0.4 );
	burn_five show();
	wait( 0.4 );
	burn_six show();	
}

truck_loop_cover()
{
	level.truck thread anim_generic_loop( level.truck, "corner_standL_alert_idle" );
	flag( "start_bay_runners" );
	wait( 9 );
	level.truck anim_stopanimscripted();
	level.truck thread enable_cqbwalk();
}

saw_door_dialogue()
{
	level.grinch dialogue_queue( "rescue_rno_allclear" );
	wait( 0.5 );
	level.sandman dialogue_queue( "rescue_snd_youreup" );
	wait( 0.5 );
	level.truck dialogue_queue( "rescue_trk_onit" );
}

vent_drop()
{
	org_sound = spawn( "script_origin", self.origin + ( 0, 0, -350 ) );
	assert( isdefined( org_sound ) );
	self waittill( "vent_drop" );
	thread play_sound_in_space( "launch_grate_falling", org_sound.origin );
	fTime = 2.5;
	newAngles = self.angles + ( 0, 0, 25 );
	self movez( -3500, fTime, fTime / 3 );
	self rotateto( newAngles, 1, .2 );
}

saw_sparks()
{
	self endon( "stop_sparks" );
	// self thread  play_sound_on_entity( "launch_chopsaw1" );
	while ( true )
	{
	playfxontag( getfx( "saw_sparks_one" ), self, "TAG_SPARKS" );
	playfxontag( getfx( "saw_sparks_bounce" ), self, "TAG_SPARKS" );
		wait( .1 );
	}
}

// The bay 
enter_bay_setup()
{	
	thread cave_saw_to_bay();
	flag_wait( "start_bay_sequence" );
	thread bay_snowmobile();
	thread bay_infantry();
	thread bay_large_doors();
}

// Guys running away directly when entering the door
bay_infantry() 
{
	flag_wait( "start_bay_runners" );
	thread bay_dialouge();	
	array_spawn_targetname( "bay_runner" );
	dudes = array_spawn_targetname( "bay_runner_stay" );
	array_thread( dudes, ::bay_runner_stay_think );
	
	flag_wait( "start_bay_combat" );
	array_spawn_targetname( "bay_runner_garage" );

	delaythread( 3, ::bay_blow_up_vehicles_so_ai_can_path );
	
	enemies_to_trigger = getentarray( "bay_garage_support", "targetname" );
	dead_guys_before_move = 5;
	//seconds_to_wait = 0;
	flow_flag = get_target_ent( "flow_flag_three" );
	get_ai_flow( undefined, undefined, enemies_to_trigger, undefined, dead_guys_before_move, undefined, flow_flag );
	wait( 5 );
	seconds_to_wait = 2;
	turn_on_color_node_one = getent( "ai_use_red_cnodes_r9", "targetname" );
	dead_guys_before_move = 4;
	thread get_ai_flow( turn_on_color_node_one, undefined, undefined, seconds_to_wait, dead_guys_before_move, undefined, undefined );
	battlechatter_off( "allies" );
}

bay_runner_stay_think()
{
	self.health = 20;
	self.accuracy = 0.2;
	self set_ignoresuppression( true );
	self allowedstances( "crouch" );
	self.goalradius = 50;
}

bay_blow_up_vehicles_so_ai_can_path()
{
	num = 0;
	while( num <= 40 )
	{
		num++;
		MagicBullet( "g36c_reflex", ( 5837, -8541, -8596 ), ( 5855, -8611, -8596 ), level.player );
		waitframe();
	}
}

bay_dialouge()
{
	trigger = getent("garage_color_node_r11 ", "targetname");
	turn_on_color_node_one = getent( "ai_use_red_cnodes_r9", "targetname" );
	turn_on_color_node_one waittill( "trigger" );
	// close the doors faster...
	musicstop( 8 );	
	level.price dialogue_queue( "rescue_pri_keepmoving" );
//	iprintlnbold ( "Price: Move keep the pressue on em!" );
	wait( 14 );
	
	if( Isdefined ( level.player.nightVision_Enabled ) && level.player.nightVision_Enabled == true )
	// if ( self ent_flag_exist( "nightvision_dlight_enabled" ) && self ent_flag( "nightvision_dlight_enabled" ) )
	{
		level.player NightvisionGogglesForceOff();
		level.player setactionslot( 1, "" ); // disable nightvision from this point on.
	}
	else
		level.player setactionslot( 1, "" ); // disable nightvision from this point on.
	level.grinch dialogue_queue( "rescue_rno_needanotherway" );
	thread reload_garage();

	if( IsDefined( trigger ) )
	{
		trigger activate_trigger (); // this stops a bug where the player can run forward and stop color nodes.
	}
//	iprintlnbold ( "Price: We gatta find another way out of here!" );
	level.sandman dialogue_queue( "rescue_snd_takestairwell" );
	// wait( 4 );
	level.sandman disable_cqbwalk();
	level.truck disable_cqbwalk();
	level.grinch disable_cqbwalk();
	level.price disable_cqbwalk();
	level.price.moveplaybackrate = 1.2;
	wait( 6 );
	if( IsDefined( trigger ) )
	{
		trigger delete();
	}
//	iprintlnbold ( "Sandman: To the left, there's gatta be another way out! " );
}

reload_garage()
{
	level.sandman.bulletsinclip = 2;
	wait( 2 );
	level.grinch.bulletsinclip = 2;
}

bay_runner_garage_think() //run to the ladder that goes up at the end the garage
{
	self endon ( "death" );
	self.goalradius = 200;
	node = get_target_ent( "bay_runner_garage_goal_lower" );
	self setgoalpos( node.origin );
	self waittill ( "goal" );
	self.goalradius = 2048; //  jillian,  this fixes the bunching issue
	//self delete;
}

bay_garage_support_think()
{
	self.goalradius = 500;
	node = get_target_ent( "bay_runner_garage_goal_lower" );
	self setgoalpos( node.origin );
	self waittill ( "goal" );
}

// start guys on the snbw mobiles so they can drive away.
bay_snowmobile() 
{
	flag_wait( "start_bay_combat" );
	// wait till player gets closer then tell them to drive...
	mobile_one = spawn_vehicle_from_targetname_and_drive ( "garage_snowmobile_one" );
	
	dudes = get_living_ai_array("high_threat_spawner","script_noteworthy");
	foreach( ai in dudes )
	{
		ai.health = 10000;
	}	
	
	mobile_one.kill_my_fx = 1;
	wait( 1 );
	mobile_two = spawn_vehicle_from_targetname_and_drive( "garage_snowmobile_two" );
	dudes = get_living_ai_array("high_threat_spawner","script_noteworthy");
	foreach( ai in dudes )
	{
		ai.health = 10000;
	}
	mobile_two.kill_my_fx = 1;
	thread bay_snowmobile_kill();
	mobile_two thread kill_player_when_too_close_to_door();
}

kill_player_when_too_close_to_door()
{
	self endon ( "death" );
	wait( 3 ); // I needed this wait so the distance check could be higher.
	while( 1 )
	{
		if( distance( level.player.origin, self.origin ) < 400 )
		{
			level.player dodamage( level.player.health + 2, level.player.origin );
			wait( 0.3 );
			playfx( level._effect[ "wall_exp_rpg_rescue2" ], level.player.origin + ( 0, 0, 20 ), ( 0, 270, 1 ) );	;
			level.player playsound ( "grenade_explode_concrete" );
			Earthquake( 0.6, 1, level.player.origin, 300 );
			level.player dodamage( level.player.health + 2, level.player.origin );
			wait( 0.3 );
			level.player setstance( "crouch" );
			level.player ShellShock( "default", 4 );
			break;
		}
		wait( 0.05 );
	}
}

bay_snowmobile_kill()
{
	dudes = get_living_ai_array( "high_threat_spawner", "script_noteworthy" );
	wait( 12 );
	foreach( ai in dudes )
	{
		if( IsAlive ( ai ) )
			ai kill();		
	}
	wait( 30 );
	one = get_vehicle( "garage_snowmobile_one",  "targetname" ); 
	two = get_vehicle( "garage_snowmobile_two",  "targetname" ); 
	one delete();
	two delete();
}

bay_large_doors()
{
	door_r = getentarray( "bay_door_r", "targetname" );
	door_l = getentarray( "bay_door_l", "targetname" );
	waitframe();
	foreach( part in door_r )
	{
		part moveto( part.origin +( 252,0,0 ), 0.1 );
	}
	foreach( part in door_l )
	{
		part moveto( part.origin +( -252,0,0 ), 0.1 );
	}
	flag_wait( "start_bay_combat" );
	//	wait( 2 );
	foreach( part in door_r )
	{ 
		part moveto( part.origin +( -303.5,0,0 ), 13, 1, 0.1 );
	}
	foreach( part in door_l )
	{
		part moveto( part.origin +( 303.5,0,0 ), 13, 1, 0.1 );
	}
	wait( 8 );
	//iprintlnbold( "These muppets are closing the main doors" );
//	wait( 2 );
	//flag_wait( "shut_large_bay_doors" );
}

bay_exit_double_door()
{
	flag_wait( "open_bay_double_doors" );
	
	dudes = get_living_ai_array( "hallway_guys_before_reveal","script_noteworthy" );
	foreach( ai in dudes )
	{
		ai kill();
	}
	
	thread ai_dumb_so_you_can_see_rocket_shooters();
	node1 = get_target_ent( "kick_door_three" ); // kick_door_foor
	node2 = get_target_ent( "kick_door_two" ); 
	node1 anim_reach_solo(level.price, "rescue_door_breach_p" );
	node2 anim_reach_solo(level.sandman, "rescue_door_breach_s" );
//	wait( 1 );
	level.price.animname = "price";
	level.sandman.animname = "sandman";
	waitframe();
	delayThread( 12.26667, ::music_play, "rescue_2_reveal" );

	node1 thread anim_single_solo( level.price, "rescue_door_breach_p" );
	node2 thread anim_single_solo( level.sandman, "rescue_door_breach_s" );
	array_spawn_targetname( "bay_top_outside_two" );
	battlechatter_off( "axis" );
	door_l = get_target_ent( "exit_bay_door_l" );
	door_r = get_target_ent( "exit_bay_door_r" );
	rotate_too = 170;
	// only do this if the player is close to this area.
	thread distance_check_cool_blur();

	fxnode = getstruct ( "bay_door_kick_fxnode", "targetname" );
	
	// sound hookup
	kick_double_door_open( door_l, door_r, "scn_rescue_stairs_doubledoor_kick", 13.56667, rotate_too, fxnode );
	flag_set( "start_yard_one" );
	thread outside_reveal_chatter();
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	setthreatbias( "allies_center", "yard_one_top_guys", 50000 );
	setthreatbias( "yard_one_top_guys", "allies_center", 50000 );
	level.sandman allowedstances( "crouch" );
	level.price allowedstances( "crouch" );
	flag_set( "top_side_god_off" );
	setthreatbias( "yard_one_top_guys", "delta", 0 );
	autosave_by_name( "open_bay_double_doors" );
	wait( 4 );
	// this moves ai from the player's path.
	activate_trigger_with_targetname( "color_node_r19" );
	level.truck thread ai_play_anim_and_follow_path( get_target_ent( "truck_top" ) );
	level.grinch thread ai_play_anim_and_follow_path( get_target_ent( "grinch_top" ) );
}

outside_reveal_chatter() 
{	
	wait( 4 );
	origin = ( 6038, -7376, -8200 );
	play_sound_in_space( "rescue_ru3_openfire", origin + ( 0, -100, 0 ) );
	play_sound_in_space( "rescue_ru2_stayaway", origin + ( -100, 0, 0 ) );
	play_sound_in_space( "rescue_ru1_getready", origin + ( 100, 0, 0 ) );
}

// If the player is close enough then do cool blur
distance_check_cool_blur()
{
	wait( 13.56667 );
	if( distance( level.player.origin, level.price.origin ) < 400 )
	{
		level.player thread vision_set_fog_changes( "rescue_2_sunblind", 1.5  );
		level.player delayThread( 0.43333, ::vision_set_fog_changes, "mine_exterior", 4 );
		level.lvl_visionset = "mine_exterior";
	}
}

ai_dumb_so_you_can_see_rocket_shooters()
{
	level.sandman.ignoreall = 1 ;
	level.truck.ignoreall = 1 ;
	level.grinch.ignoreall = 1 ;
	level.price.ignoreall = 1 ;
	level.sandman.ignoreme = 1 ;
	level.truck.ignoreme = 1 ;
	level.grinch.ignoreme = 1 ;
	level.price.ignoreme = 1 ;
	level.player.ignoreme = 1;
	flag_wait( "top_side_god_off" );
	
//	level.sandman allowedstances( "crouch" );
//	level.price allowedstances( "crouch" );
	
	level.sandman.ignoreall = 0 ;
	level.truck.ignoreall = 0 ;
	level.grinch.ignoreall = 0 ;
	level.price.ignoreall = 0 ;
	level.sandman.ignoreme = 0 ;
	level.truck.ignoreme = 0 ;
	level.grinch.ignoreme = 0 ;
	level.price.ignoreme = 0 ;
	level.player.ignoreme = 0;
	wait( 8 );
	
	level.sandman allowedstances( "crouch", "stand", "crouch" );
	level.price allowedstances( "crouch", "stand", "crouch" );

}

bay_top_outside_two_think()
{
//	self.ignoreall = 1;
//	self.health = 10;
//	wait( 1.3 );
//	self.ignoreall = 0;
	self thread magic_bullet_shield();
	self.goalradius = 1;
	self.goalheight = 1;
	self set_ignoresuppression( true );
	self allowedstances( "stand" );
	self SetThreatBiasGroup( "yard_one_top_guys" );
	flag_wait( "top_side_god_off" );
	self thread stop_magic_bullet_shield();
	//setthreatbiasagainstall
	//SetThreatBiasGroup
}

road_fighters_think()
{
	self endon ( "death" );
	self.ignoreall = true;
	//	self thread magic_bullet_shield();
	//	self.goalradius = 1;
	//	self.goalheight = 1;
	//	self set_ignoresuppression( true );
	//	self allowedstances( "stand" );
	//	self SetThreatBiasGroup( "yard_one_top_guys" );
	flag_wait( "top_side_god_off" );
	wait( 10 );
	self.ignoreall = false;
	//	self thread stop_magic_bullet_shield();
	// retreat
	flag_wait( "yard_retreat_one_new" );
	self.health = 1;
	self.ignoreall = true;
	volume = getent( "yard_retreat_one", "script_noteworthy" );
	self setgoalvolumeauto ( volume );			

}

exit_bay_setup() // fight through the glass as ai take cover around the snow cats
{
		thread rpg_guys();
		thread pull_up_trucks();
		thread first_engagement(); 
		//thread bay_exit_double_door();
}


// setup a row of 6 guys that are shooting rockets from this position.
rpg_guys()
{
}

pull_up_trucks()
{
}

// guys spawn in from below are heading out through the gates...
first_engagement()
{
}

outside_of_cave_tunnel_setup()
{
}

outside_of_cave_setup() // 
{
}

outside_of_cave_truck_setup() // 
{
}

exit_bay_doors_reveal_setup()
{
	flag_set( "ai_use_red_cnodes");
	thread bay_exit_double_door();
}

yard_one_setup()
{
	thread digger_move(); 
	flag_wait( "start_yard_one" );
	
	level.new_cave_door_collision = get_target_ent( "new_cave_door_collision" );
	level.new_cave_door_collision disconnectpaths();
	
	player_speed_percent( 100 );
	
	trigger = getent( "hillside_subs", "targetname" );
	trigger delete();
	
	thread yard_one_move_up_friends();
	thread snow();
	thread clean_up();
	thread new_yard_beggining_battle();
	thread track_guys_alive();
	level.power_trigger_damage = getent( "yard_blow_power_tower",  "targetname" );
	thread silo_destruction();
//	thread yard_above_cowbell();
	thread yard_big_strafes();
	level.color_node = getent( "color_node_r23_o13", "targetname" ); //send the friend forward when the snipers are killed.	
	thread littlebird_hero(); // currently setting this guy up...
	thread road_battle();
	thread uav_targets();
	thread yard_friends();
	thread yard_one_suburban_blocker();
	thread snipe_till_uav_is_ready();
	thread player_kills_ai();
	
	thread kill_spawner_in_the_middle();
	thread yard_one_snowmobile();
	thread yard_one_second_area();
	thread yard_start_heli_drop_think();
	level.sandman set_force_color( "r" );
	level.price set_force_color( "r" );
	level.truck set_force_color( "o" );
	level.grinch set_force_color( "o" );
	thread yard_battle_one();
//	thread yard_middle(); 
	wait( 10 );
	level.sandman disable_cqbwalk();
	level.truck disable_cqbwalk();
	level.grinch disable_cqbwalk();
	level.price disable_cqbwalk();
}


yard_one_move_up_friends()
{
	yard_one_color_node_forward_pre_one_before  = getent( "yard_one_color_node_forward_pre_one_before", "targetname" );
	yard_one_color_node_forward_pre_one  = getent( "yard_one_color_node_forward_pre_one", "targetname" );
	yard_one_color_node_forward  = getent( "yard_one_color_node_forward", "targetname" );
	yard_one_color_node_forward_two  = getent( "yard_one_color_node_forward_two", "targetname" );
	
	self endon ( "spawn_middle_yard" );
	flag_wait( "yard_activate_orange_nodes" );
	fx_volume_pause_noteworthy( "clean_fx_for_first_bottom_cave_one" );
	fx_volume_pause_noteworthy( "clean_fx_for_first_bottom_cave_two" );
	
	wait( 6 );
	
	volume = getent( "yard_retreat_one", "script_noteworthy" );
	tolerance = 1;
	volume_waittill_no_axis ( volume, tolerance );
	yard_one_color_node_forward_pre_one_before activate_trigger();
	
	wait( 4 );
	volume = getent( "yard_color_node_two", "targetname" );
	tolerance = 1;
	volume_waittill_no_axis ( volume, tolerance );
	level.sandman set_force_color( "o" );
	level.price set_force_color( "o" );
	yard_one_color_node_forward_pre_one activate_trigger();
	
	wait( 4 );	
	volume = getent( "yard_color_node_three", "targetname" );
	tolerance = 1;
	volume_waittill_no_axis ( volume, tolerance );
	yard_one_color_node_forward activate_trigger();
	
	wait( 2 );
	volume = getent( "yard_color_node_three", "targetname" );
	tolerance = 1;
	volume_waittill_no_axis ( volume, tolerance );
	yard_one_color_node_forward_two activate_trigger();
}


digger_move()
{
	exca_back = getent( "exca_back", "targetname");
	
	exca_arm = getent( "exca_arm", "targetname");
	
	exca_arm linkto( exca_back );
	
	exca_blades = getentarray( "exca_bucket_section", "targetname");
	
	foreach( piece in exca_blades )
	{	
		if( IsDefined( piece.script_noteworthy ) && piece.script_noteworthy == "origin_piece" )
		{
			level.origin_blade = spawn( "script_origin", piece.origin );
		}
	}
	
	waitframe();
	foreach( piece in exca_blades )
	{	
		piece linkto ( level.origin_blade ); 
	}
	
	level.origin_blade linkto( exca_back ); 
	

	exca_back rotateyaw( -90, 0.1  );
	flag_wait( "start_yard_one" );	
//	level.origin_blade waittill ( "rotatedone" );
	
	exca_back rotateyaw( 60, 90  );	
	
//	level.origin_blade rotateroll( -180, 20 );
//	level.origin_blade waittill ( rotatedone );
	//	while( !flag( "courtyard_cleared" ) )
	// I need to spawn an origin
	
//	exca_back rotateyaw(-90, 10, 0.1);
}


excavator_rotate()
{
	while( 1 )
	{
		level.origin_blade rotatepitch( -180, 20 );
		level.origin_blade waittill ( "rotatedone" );
		level.origin_blade rotatepitch( 180, 20 );
		level.origin_blade waittill ( "rotatedone" );
	}
}

silo_destruction() // think about blowing stuff up left and right..
{
	level.silo_1 = getentarray( "silo_1_pristine","targetname" );
	level.metal_railings_prestine = getentarray( "metal_railings_prestine","targetname" );
	
	level.silo_1_messed_up = getentarray( "silo_1_damage","targetname" );
	level.metal_railings_damaged = getentarray( "metal_railings_damaged","targetname" );
	
	
	foreach(  silo in level.silo_1_messed_up ) 
	{
		silo hide();	
	}
	
	foreach(  silo in level.metal_railings_damaged ) 
	{
		silo hide();	
	}
	wait( 5.0 );
	playfx( level._effect[ "bomb_explosion_ac130_small" ], level.metal_railings_damaged[ 0 ].origin + (0,0, -800), ( 0, 0, 1 ) );
	wait( 0.4);
//	level.silo_1[ 0 ] hide();
//	level.metal_railings_prestine[ 0 ] hide();
	wait( 10 );
	
//	level.silo_1_messed_up[ 0 ] show();
//	level.metal_railings_damaged[ 0 ] show();
	playfx( level._effect[ "bomb_explosion_ac130_small" ], level.silo_1_messed_up[ 0 ].origin, ( 0, 0, 1 ) );
	wait( 1.7 );
//	playfx( level._effect[ "bomb_explosion_ac130_small" ], level.silo_1_messed_up[ 0 ].origin, ( 0, 0, 1 ) );
	playfx( level._effect[ "bomb_explosion_ac130_small" ], level.silo_1_messed_up[ 1 ].origin, ( 0, 0, 1 ) );
	wait( 3.3 );
//	playfx( level._effect[ "bomb_explosion_ac130_small" ], level.silo_1_messed_up[ 1 ].origin, ( 0, 0, 1 ) );
//	level.silo_1_messed_up[ 1 ] show();
//	level.metal_railings_damaged[ 1 ] show();
//	level.silo_1[ 1 ] hide();
//	level.metal_railings_prestine[ 1 ] hide();
	wait( 1 );
	playfx( level._effect[ "bomb_explosion_ac130" ], level.silo_1_messed_up[ 1 ].origin + ( 0, 0 ,0 ), ( 0, 0, 1 ) );
}

yard_above_cowbell()
{
	level.ambient_paths = getentarray("2nd_tier_group_flyby", "targetname");
	level.heli_spawner_ambient = getent( "fake_hind", "targetname" );
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[2] );
	waitframe();
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[0] );
	waitframe();
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[1] );
	
	wait( 2 );
	level.ambient_paths = getentarray("3rd_tier_group_flyby", "targetname");
	level.heli_spawner_ambient = getent( "faker", "targetname" );
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[2] );
	waitframe();
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[0] );
	waitframe();
	level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[1] );
	
	
	while( !flag( "courtyard_cleared" ) )
	{
		wait randomfloatrange( 12, 16 );
		num = 0; 
		num = RandomIntRange ( 0,1 ); // random ents to ents
//		switch( num )
//		{
//			case 0:
//				level.ambient_paths = getentarray("2nd_tier_group_flyby", "targetname");
//			case 1:
//				level.ambient_paths = getentarray("2nd_tier_group_flyby_other_side", "targetname");
//		}

		level.ambient_paths = getentarray("2nd_tier_group_flyby", "targetname");
		
		amount_of_choppers = RandomIntRange ( 1,3 ); // random ents to ents
		for( i = 0; i < amount_of_choppers; i++ )
		{
			wait randomfloatrange( 1, 2 );
			
			num_two = 0;
			//num_two = RandomIntRange ( 0,2 ); // random ents to ents
			switch( num_two )
			{
				case 0:
					level.heli_spawner_ambient = getent( "fake_hind", "targetname" );
 					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[0] );
				case 1:
					level.heli_spawner_ambient = getent( "fake_hind", "targetname" );
					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[1] );
				case 2:
					level.heli_spawner_ambient = getent( "fake_hind", "targetname" );
					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[2] );
			}
		}
		waitframe();
		level.heli_spawner_ambient thread delete_chopper();
		num = 0; 
		num = RandomIntRange ( 0,1 ); // random ents to ents
		switch( num )
		{
			case 0:
				level.ambient_paths = getentarray("3rd_tier_group_flyby", "targetname");
			case 1:
				level.ambient_paths = getentarray("3rd_tier_group_flyby_other_side", "targetname");
		}
		
		level.ambient_paths = getentarray("3rd_tier_group_flyby", "targetname");

		amount_of_choppers = RandomIntRange ( 1,3 ); // random ents to ents
		for( i = 0; i < amount_of_choppers; i++ )
		{
			wait randomfloatrange( 1, 2 );
			num_two = 0;
			num_two = RandomIntRange ( 0, 2 ); // random ents to ents

			switch( num_two )
			{
				case 0:
					level.heli_spawner_ambient = getent( "faker", "targetname" );
					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[ 0 ] );
				case 1:
					level.heli_spawner_ambient = getent( "faker", "targetname" );
					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[ 1 ] );
				case 2:
					level.heli_spawner_ambient = getent( "faker", "targetname" );
					level.heli_spawner_ambient = level.heli_spawner_ambient move_spawn_and_go( level.ambient_paths[ 2 ] );
			}
			
			waitframe();
			array_thread( level.heli_spawner_ambient.mgturret, ::littlebird_minigun_delete );
			level.heli_spawner_ambient thread delete_chopper();
		}
		wait( 20 );
	}
}

yard_big_strafes() // test the three strafes real quick...
{
	flag_wait( "yard_start_strafes" ); // yard_start_heli_drop
	level.sandman thread dialogue_queue( "rescue_snd_cutthrough" );
//	wait( 20 );
	faker_4 = spawn_vehicle_from_targetname_and_drive ( "faker_4" );
	faker_4 thread delaythread( 1, ::hind_fire_loop_two );
	faker_4 notify( "stop_kicking_up_dust" );

	faker_4 thread delete_chopper(); 

//	ent = getent( "big_strafe_one", "targetname" );
//	heli_spawner = getent( "littlebird", "targetname" );
//	big_strafe_heli = heli_spawner move_spawn_and_go( ent );
//	big_strafe_heli thread delete_chopper();
//	waitframe();
	
	flag_wait( "spawn_in_last_subs" ); // yard_start_heli_drop
	// You don't see this now at all.
	faker_2 = spawn_vehicle_from_targetname_and_drive ( "faker_2" );
	faker_2 thread delaythread( 3, ::hind_fire_loop_two );
	faker_2 notify( "stop_kicking_up_dust" );
	faker_2 thread delete_chopper();
	wait( 7 );
//	ent = getent( "big_strafe_two", "targetname" );
//	heli_spawner = getent( "littlebird", "targetname" );
//	big_strafe_heli = heli_spawner move_spawn_and_go( ent );
//	big_strafe_heli thread delete_chopper();
//	waitframe();	
//	wait( 6 );
//	ent = getent( "big_strafe_three", "targetname" );
//	heli_spawner = getent( "littlebird", "targetname" );
//	big_strafe_heli = heli_spawner move_spawn_and_go( ent );
//	big_strafe_heli thread delete_chopper();
//	waitframe();

	faker_3 = spawn_vehicle_from_targetname_and_drive ( "faker_3" );
	faker_3 notify( "stop_kicking_up_dust" );
	
	faker_3 thread delaythread( 3, ::hind_fire_loop_two );
	faker_3 thread delete_chopper();
}

friends_drop_off( color_node_to_activate_1 )
{
	level.sandman dialogue_queue( "rescue_snd_hoptherail" );
	color_node_to_activate_1 activate_trigger();
	support_heli_one = spawn_vehicle_from_targetname_and_drive ( "heli_ally_drop_one" );
	support_heli_one notify( "stop_kicking_up_dust" );
	support_heli_one.script_friendname = "Honey";
	array_thread( support_heli_one.mgturret, ::littlebird_minigun );
	support_heli_one maps\_vehicle::godon();
	support_heli_one thread delete_chopper();
	wait( 1.3 );
	support_heli_two = spawn_vehicle_from_targetname_and_drive ( "heli_ally_drop_two" );
	support_heli_two notify( "stop_kicking_up_dust" );
	support_heli_two.script_friendname = "Badger";
	array_thread( support_heli_one.mgturret, ::littlebird_minigun );
	support_heli_two maps\_vehicle::godon();
	support_heli_two thread delete_chopper();
	wait( 4.5 );
	radio_dialogue( "rescue_lp1_ondeck" );
	radio_dialogue( "rescue_lp1_coverpattern" );
}

custom_script_anim_slide()
{
	level.grinch.goalradius = 2;
	current_struct = getstruct ( "mineyard_slide","targetname" );
	current_struct_two = getstruct ( "mineyard_slide_two","targetname" );

	slide_anim_reach = getent( "slide_anim_reach", "targetname" );
	slide_two_anim_reach = getent( "slide_two_anim_reawch", "targetname" );
	//slide_anim_reach = getstruct ( "slide_anim_reach","targetname" );
	//slide_two_anim_reach = getstruct ( "slide_two_anim_reach","targetname" );
//	level.grinch set_goal_ent( slide_anim_reach ); 
//	level.grinch waittill( "goal" );
	//slide_two_anim_reach anim_reach_solo ( level.grinch, "afgan_caves_price_slide" );
	current_struct_two thread anim_single_solo(level.grinch, "afgan_caves_price_slide" ); 	
//	slide_anim_reach anim_reach_solo ( level.price, "afgan_caves_price_slide" );
//	current_struct anim_single_solo(level.price, "afgan_caves_price_slide" ); 
////	wait( 5 );	
//	slide_two_anim_reach anim_reach_solo ( level.sandman, "afgan_caves_price_slide" );
//	current_struct_two thread anim_single_solo(level.sandman, "afgan_caves_price_slide" ); 	
//	slide_anim_reach anim_reach_solo ( level.truck, "afgan_caves_price_slide" );
//	current_struct anim_single_solo(level.truck, "afgan_caves_price_slide" ); 	
//
//	color_node_to_activate_1 = get_target_ent( "color_node_o7" );
//	color_node_to_activate_1 activate_trigger();
}

road_battle()
{
//	wait( 14 );
	enemy_ai = getentarray( "road_fighters", "targetname" );
	maps\_spawner::flood_spawner_scripted( enemy_ai );
}

littlebird_hero()
{
	wait( 4 );
	array_thread( getentarray( "littlebird_trigger", "targetname" ), ::littlebird_trigger );
	delaythread ( 5, ::radio_dialogue, "rescue_lp1_gunsguns" ); 
	level thread littlebird_spawn();
	//	wait( 10 ); 

	// this is the guy who spawns in from the left and then stays on the right side of the map.
	ent = getent( "amb_fly_by_two", "targetname" );
	heli_spawner = getent( "littlebird", "targetname" );
	level.amb_heli_right = heli_spawner move_spawn_and_go( ent );
	level.amb_heli_right maps\_vehicle::godon();
	level.amb_heli_right notify( "stop_kicking_up_dust" );
	
	array_thread( level.amb_heli_right.mgturret, ::littlebird_minigun );
	
	level.amb_heli_right waittill ( "reached_dynamic_path_end" );
	if( IsAlive( level.amb_heli_right ) ) 
	{
		ent = getent( "strafe_one_tier_one_right_side", "targetname" );
		level.amb_heli_right thread new_vehicle_path( ent );
		level.amb_heli_right waittill ( "reached_dynamic_path_end" );
		ent = getent( "strafe_two_tier_one_right_side", "targetname" );
		level.amb_heli_right thread new_vehicle_path( ent );		 
		level.amb_heli_right waittill ( "reached_dynamic_path_end" );
		paths = getentarray( "right_side_amb_strafs", "targetname" );
		level.amb_heli_right thread littlebird_ambient_left_right( paths );
	}
	else if( !IsAlive( level.amb_heli_right ) )
	{
		ent = getent( "amb_fly_by_two", "targetname" );
		heli_spawner = getent( "littlebird", "targetname" );
		level.amb_heli_right = heli_spawner move_spawn_and_go( ent );
		level.amb_heli_right notify( "stop_kicking_up_dust" );
	}
}

littlebird_ambient_left_right( paths )
{	
	self Vehicle_SetSpeed( 60,200, 200 );
	
	while( IsAlive ( self ) )
	{
		if( IsAlive( self ) )
		{
			ent = array_randomize( paths );
			num = RandomIntRange( 0,1 );
			switch( num )
			{
				case 0:
					self thread new_vehicle_path( ent[ 0 ] );		
				case 1:
					self thread new_vehicle_path( ent[ 1 ] );			
			}

		}
		self waittill ( "reached_dynamic_path_end" );
	}	
}	

littlebird_fire_minigun( )
{
	
	self endon( "stop_follow_path" );
	self endon( "stop_fire_minigun" );
	
	self SetVehWeapon( "turret_attackheli" );
	fire_time = 0.2;
	count = 0;
	while ( 1 )
	{
		self thread vehicle_scripts\_attack_heli::fire_guns();
		wait( fire_time );
		count++;
	}
}

littlebird_trigger()
{
	level endon( "spawn_littlebird" );
	self waittill( "trigger" );
	level notify( "spawn_littlebird", self.target );
}

// this is the guys who follows the player around.
littlebird_spawn()
{
	level waittill( "spawn_littlebird", ent_str );
	delaythread ( 5, ::radio_dialogue, "rescue_lp1_constructionsite" ); 	
	ent = getent( ent_str, "targetname" );

	heli_spawner = getent( "littlebird", "targetname" );
	level.heli = heli_spawner move_spawn_and_go( ent );
	level.heli notify( "stop_kicking_up_dust" );
	level.heli.script_friendname = "Viper One";
	
	level.heli thread littlebird_orginal_path();

	thread heli_yard_attack_suburbans();
	
	array_thread( level.heli.mgturret, ::littlebird_minigun );
	
	//spawn in a new heli if one of them is destroyed.
	while ( 1 )
	{
	  if ( !IsAlive( level.heli) && !flag( "courtyard_cleared" ) ) 
		{
		 ent = getent( "strafe_four_now", "targetname" );	
	     heli_spawner = getent( "littlebird", "targetname" );
	     level.heli = heli_spawner move_spawn_and_go( ent );
	     level.heli notify( "stop_kicking_up_dust" );
	     level.heli.script_friendname = "Viper Two";
	     level.heli Vehicle_SetSpeed( 60,200, 200 );
	     array_thread( level.heli.mgturret, ::littlebird_minigun );
	     // now I need to know where it should fly to.
	     wait( 5 );
		}
	 wait( 0.05 );
	}
	//level.heli.mgturret thread littlebird_minigun();

//	flag_clear( "littlebird_react" );
//	level.heli thread littlebird_reaction( "strafe_path" );
}

heli_yard_attack_suburbans() // engage the humvee when it appears...
{
	level.heli endon ( "death" );
	flag_wait( "middle_yard_blockers" );
	radio_dialogue( "rescue_lp1_engaging" );
	
	level.counter = 4;
	if( IsAlive( level.heli ) )
	{
		ent = getent( "engage_suburban", "targetname" );
		level.heli thread new_vehicle_path( ent );
		wait( 1 );
		radio_dialogue( "rescue_lp1_gunshot" );
	
		level.heli Vehicle_SetSpeed( 35,200, 200 );
	//	
	//	level.heli
	}
	wait( 1 );
	
	living_ai = get_living_ai_array( "heli_engage_suburb_guys", "script_noteworthy" );
	
	//level.heli.target_ent = get_vehicle( );
	
	while ( IsAlive( level.heli ) )
	{
		if( level.counter == 0 ) // or the player has just run forward
		{
			ent = getent( "strafe_four_now", "targetname" );
			level.heli thread new_vehicle_path( ent );
			level.heli Vehicle_SetSpeed( 35,200, 200 ); 
			break;
		}
		wait( 0.05 );
	}
	
	level.heli waittill ( "reached_dynamic_path_end" );
	level.heli Vehicle_SetSpeed( 35,200, 200 );
	
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_three_now", "targetname" );
	level.heli thread new_vehicle_path( ent );
	
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_five_now", "targetname" );
	level.heli thread new_vehicle_path( ent );

}

littlebird_orginal_path()
{
	level.heli endon ( "middle_yard_blockers" );
	level.heli endon ( "death" );
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_two_now", "targetname" );
	level.heli thread new_vehicle_path( ent );
	
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_four_now", "targetname" );
	level.heli thread new_vehicle_path( ent );
	
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_three_now", "targetname" );
	level.heli thread new_vehicle_path( ent );
	
	level.heli waittill ( "reached_dynamic_path_end" );
	ent = getent( "strafe_five_now", "targetname" );
	level.heli thread new_vehicle_path( ent );
}

detect_if_littlebird_in_front_of_hind()
{
	level.heli endon ("death");
//	volume = get_target_ent( "detect_if_littlebird" );
	waitframe();
//	while( 1 )
//	{
//		if( IsAlive( level.heli ) && level.heli IsTouching( volume ) )
//		{
			paths = getentarray( "escape_hind_middle", "targetname" );
			ent = array_randomize( paths );
			num = RandomIntRange( 0,2 );
			switch( num )
			{
				case 0:
					level.heli thread new_vehicle_path( ent[ 0 ] );		
				case 1:
					level.heli thread new_vehicle_path( ent[ 1 ] );		
				case 2:
					level.heli thread new_vehicle_path( ent[ 2 ] );		
			}
//			break;
			// do one more path where it just flies straight up.
//		}
//		wait( 0.05 );
//	}
	
}


littlebird_minigun()
{
	//self SetBottomArc( 18 );
	self SetBottomArc( 180 );
	self setrightarc( 20 );
	self setleftarc( 20 );
	self SetConvergenceTime( 1.5, "yaw" );
	self SetConvergenceTime( 0.7, "pitch" );
}

littlebird_minigun_delete()
{
	wait( 3 );
//	self mgoff();
	wait( 1 );
	//self SetBottomArc( 18 );
	//	self delete();
}

// almost done getting rockets to fire
fire_missile_setup()
{
	run_thread_on_noteworthy( "fire_missile", vehicle_scripts\_attack_heli::boneyard_style_heli_missile_attack );
}

//littlebird_init( no_repulsor )
//{
//	level notify( "road_heli_spawned" );
//	array_thread( self.mgturret, ::littlebird_minigun );
//	level.heli = self;
//	self.script_AI_invulnerable = true;
//
//	waittillframeend;
//	self thread makesentient( self.script_team );
//
//	if ( !isdefined( no_repulsor ) )
//		self thread toggle_repulsor();
//
//	self.fake_target = spawn( "script_model", (0,0,0) );
////	self.fake_target setmodel( "fx" );
//	self.fake_target linkto( self, "tag_origin", ( 100, 0, 150 ), ( 0, 0, 0 ) );
//	self thread fake_target_delete( self.fake_target );
//
////	/#
////		self thread drawpath();
////		ent = self.currentnode;
////		self thread mark_heli_path( ent );
////	#/
//}
	
yard_friends()
{
	trigger = get_Target_ent( "kill_spawner_courtyard" );
	trigger waittill( "trigger" );
	
	//dudes = getaiarray( "allies" );
	//flag_wait( "yard_activate_orange_nodes" );
	//	wait( 20 );
	// but I really need to wait for the player to get into the yard.
	left_ai = getentarray( "delta_yard_left", "script_noteworthy" );
	right_ai = getentarray( "delta_yard_right", "script_noteworthy" );
	maps\_spawner::flood_spawner_scripted( left_ai );
	maps\_spawner::flood_spawner_scripted( right_ai );
}

yard_big_uav_targets()
{	
	//fx_ent = getstruct( "hind_uav_two_target", "targetname" );
	fx_ent_entity = spawn( "script_origin", self.origin );
//	fx_ent = SpawnFx( level._effect[ "bomb_explosion_ac130_small" ], self.origin, (0,0,1) );
	self waittill( "damage" );
	radiusdamage( self.origin, 500, 50000, 50000 );
	thread hard_target_quake( fx_ent_entity );

	// old player objective
//	self waittill("damage", amount, attacker);
//	// self waittill( "trigger", undefined, attacker );
//	if( attacker == level.player ) 
//	{
//		level.counter --;
//		radiusdamage( self.origin, 3000, 50000, 50000 );
//	//	wait( 0.5 );
//		thread hard_target_quake( fx_ent_entity );
//	}
}

hard_target_quake( fx_ent_entity )
{
//	playfx( level._effect[ "snow_light" ], level.player.origin + ( 0, 0, 300 ), level.player.origin + ( 0, 0, 350 ) );
	Earthquake( 0.7, 1, level.player.origin, 300 );
//	triggerFX( fx_ent );
	//playfx( getfx( "saw_sparks_one" ), self.origin, (0,0,1) );
	playfx( level._effect[ "bomb_explosion_ac130_small" ], fx_ent_entity.origin, ( 0, 0, 1 ) );
	wait( 2.3 );
	playfx( level._effect[ "bomb_explosion_ac130_small" ], fx_ent_entity.origin + ( 0,1000,0 ), ( 0, 0, 1 ) );
////	triggerFX( fx_ent );
	wait( 2.3 );
	playfx( level._effect[ "bomb_explosion_ac130" ], fx_ent_entity.origin + ( 0,- 1000 ,0 ), ( 0, 0, 1 ) );
	wait( 1 );
	fx_ent_entity delete();
//	triggerFX( fx_ent );
//	playfx( getfx( "bomb_explosion_ac130_small" ), self.origin, ( 0, 0, 1 ) );
}

uav_targets()
{
	damage_triggers = getentarray( "yard_blow_big_objective", "targetname" );	
	foreach( trigger in damage_triggers )
	{
		trigger thread yard_big_uav_targets();
	}
	
//	thread hard_target_tracker();
//	level.counter = 2;

//	level.uav_struct.view_cone = 25;
//	waitframe();
	
	
//	level.uav_struct.draw_red_boxes = true;	
//	level.remote_missile_targets = getstructarray("hard_targets", "script_noteworthy");
//	target_one = getstruct( "hind_uav_one_target","targetname");
//	target_one_origin = spawn( "script_origin", target_one.origin );
//	target_two = getstruct( "hind_uav_two_target","targetname");
//	target_three = getstruct( "hind_uav_three_target","targetname");
//	level.remote_missile_targets = array_add( level.remote_missile_targets , target_one );
//	level.remote_missile_targets = array_add( level.remote_missile_targets , target_two );
//	level.remote_missile_targets = array_add( level.remote_missile_targets , target_three );
//	target_one thread maps\_remotemissile_utility::setup_remote_missile_target();
//	target_two thread maps\_remotemissile_utility::setup_remote_missile_target();
//	target_three thread maps\_remotemissile_utility::setup_remote_missile_target();
//	Target_SetShader( target_one_origin, "veh_hud_target" );
//	Target_SetShader( target_two, "hud_fofbox_self_sp" );
//	Target_SetShader( target_three, "hud_fofbox_self_sp" );
// just blow up all these targets when you see it.
// add new and cool twist
//
 
//	targets_one = spawn_vehicles_from_targetname( "hind_uav_one" );
//	targets_two = spawn_vehicles_from_targetname( "hind_uav_two" );

//	array_thread( targets_two, maps\_remotemissile_utility::setup_remote_missile_target );
//	array_thread( targets_one, maps\_remotemissile_utility::setup_remote_missile_target );
//	targets_three = spawn_vehicles_from_targetname( "hind_uav_three" );


//	while( 1 )
//	{	
//		if( level.counter == 0 )
//		{
//			flag_set( "hard_targets_dead" );
//			autosave_by_name( "hard_targets_dead" );
//			break;
//		}
//		wait( 0.5 );
//	}
//	
//	dudes = getaiarray( "axis" );
//	foreach( ai in dudes )
//	{
//		ai thread setup_remote_missile_target_guy();
//	}
//	
//	add_global_spawn_function( "axis", :: setup_remote_missile_target_guy ); // places red boxed for predator mode.
}

hard_target_tracker()
{
	while( 1 )
	{
		if( level.counter == 1 )
		{
			radio_dialogue( "rescue_pri_diamondmine" );
			//iprintlnbold( "YEAH, one down, get on that other location, quick!" );
			break;
		}
		wait( 0.05 );
	}
	
	/* while( 1 )
	{
		if( level.counter == 0 )
		{
			//iprintlnbold( "NICE SHOT!!!" );
			break;
		}
		wait( 0.05 );
	} */
}

delta_yard_right_think()
{
		self set_force_color( "r" );	
		//wait( 1.3 );
		self SetThreatBiasGroup( "allies_center" );
}

delta_yard_left_think()
{
		self set_force_color( "o" );
		//wait( 1.3);
		self SetThreatBiasGroup( "allies_center" );
}

snow()
{
	level endon( "stop_snow" );

	for ( ;; )
	{
		playfx( level.snow_effect, level.player.origin + level.snow_offset );
		wait( level.snow_delay );
	}
}

uav_path()
{
	// This allows the uav path to loop.
	self endon ("death");
	node_start = Getvehiclenode( "uav_end", "script_noteworthy" );
	node_go_to = Getvehiclenode( "uav_begin", "script_noteworthy" );
	while( 1 )
	{
		self waittill ( "reached_end_node ");
		self vehicle_switch_paths( node_start, node_go_to );
	}
}

snipe_till_uav_is_ready()
{
	// create timer...
	// player wait 20 seconds till the uav is up...
	// thread give_player_predator_drone();
}


// Spawn in initial: 
yard_one_snowmobile()
{
	level.heli_one = spawn_vehicle_from_targetname_and_drive ( "heli_one" );
	level.heli_one thread left_heli_amb_path_one();
	level.heli_one.script_friendname = "Hudson One";
	wait( 2 );
	level.heli_two = spawn_vehicle_from_targetname_and_drive ( "heli_one" );
	level.heli_two thread delete_chopper();
	level.heli_two.script_friendname = "Hudson Two";
	wait( 1 );
	delaythread ( 0, ::spawn_vehicle_from_targetname_and_drive, "hind_one" );
	
	waitframe();
	hind = get_vehicle("hind_one", "targetname" );
	hind thread delete_chopper();
	hind thread hind_fire_loop();

	spawn_vehicle_from_targetname_and_drive( "suburban_road_one_path_one" );
	delaythread( 5, :: spawn_vehicle_from_targetname_and_drive, "suburban_road_one_path_three" );
	delaythread( 7, :: spawn_vehicle_from_targetname_and_drive, "suburban_road_one_path_three" );

	wait( 1.7 );
	spawn_vehicle_from_targetname_and_drive( "suburban_road_one_path_two" );
	thread loop_suburbans();
	delaythread( 1.5, :: spawn_vehicle_from_targetname_and_drive, "suburban_road_one_path_two" );

	wait( 3 );
	mobile_three = spawn_vehicle_from_targetname_and_drive ( "suburban_two" );
	mobile_three.health = 10000;
//	mobile_three.veh_pathtype = "constrained";
	mobile_three waittill( "reached_end_node" );
	wait( 4 ); // I wait here, cause it's cooler to see this stop and the watch the guys get out.
	mobile_three.health = 390; // can kill with grenades
	hind waittill( "reached_end_node" );
	hind delete();
}

left_heli_amb_path_one()
{
	self waittill ( "reached_dynamic_path_end" );
 	ent = getent( "strafe_one_tier_one_left_side", "targetname" );
	self thread new_vehicle_path( ent );
	self waittill ( "reached_dynamic_path_end" );
	paths = getentarray( "left_side_amb_strafs", "targetname" );
	self thread littlebird_ambient_left_right( paths );
}
sub_delete()
{
	self waittill ( "reached_end_node" );	
	self delete();
}

loop_suburbans()
{
	wait( 5 ); 
	spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );
	wait( 3 ); 
	spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );
	wait( 6 );
	
	amb_sub = spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );
	amb_sub waittill ( "reached_end_node" );
		
	while( !flag( "hard_targets_dead" ) ) 
	{
		spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );	
		wait randomfloatrange( 6, 9 ); 
		spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );	
		wait randomfloatrange( 9, 13 ); 
		amb_sub= spawn_vehicle_from_targetname_and_drive ( "suburban_road_one_path_three" );	
		amb_sub waittill ( "reached_end_node" );	 
		wait randomfloatrange( 6, 11 ); 
	}
}

hind_fire_loop()
{
	self endon( "death" );
	self thread chopper_fire_rockets();
	wait( 3 );
	self notify( "stop_fire_rockets" );
	wait( 3 );
	self thread chopper_fire_rockets();
	wait( 2 );
	self notify( "stop_fire_rockets" );
	wait( 4 );
	self thread chopper_fire_rockets();
	wait( 2 );
	self notify( "stop_fire_rockets" );
	wait( 4 );
	self thread chopper_fire_rockets();
	wait( 2 );
	self notify( "stop_fire_rockets" );
}

hind_fire_loop_two()
{
	self endon( "death" );
	self thread chopper_fire_rockets();
	wait( 0.4 );
	self notify( "stop_fire_rockets" );
	wait( 1 );
	self thread chopper_fire_rockets();
	wait( 0.4 );
	self notify( "stop_fire_rockets" );
	wait( 1 );
	self thread chopper_fire_rockets();
	wait( 0.4 );
	self notify( "stop_fire_rockets" );
	wait( 1 );
	self thread chopper_fire_rockets();
	wait( 0.5 );
	self notify( "stop_fire_rockets" );
	
	
}

yard_one_suburban_blocker()
{
	flag_wait( "middle_yard_blockers" );
	mobile_one = spawn_vehicle_from_targetname_and_drive ( "suburban_four" );
//	mobile_one thread maps\_remotemissile_utility::setup_remote_missile_target();
//	mobile_one.script_team = "axis";
	mobile_one.health = 390; // can kill with grenades	
	wait( 2.3 );
	mobile_two = spawn_vehicle_from_targetname_and_drive ( "suburban_five" );
//	mobile_one.script_team = "axis";
//	mobile_one thread maps\_remotemissile_utility::setup_remote_missile_target();
	mobile_two.health = 390; // can kill with grenades	
}

kill_spawner_in_the_middle() // I just did this because this wasn't working in the editor.
{
	trigger = get_Target_ent( "kill_spawner_courtyard" );
	trigger waittill( "trigger" ); // or timeout.
	autosave_by_name( "middle_of_yard" );
	maps\_spawner::killspawner( 1 );
}

player_kills_ai( total_to_kill )
{
	flag_wait( "open_bay_double_doors" );
	color_node_to_activate_1 = get_target_ent( "color_node_o7" );
	//autosave_by_name( "open_bay_double_doors" );
	while( 1 ) 
	{
		if( level.player_killed_ai_count == 3 || flag( "hard_targets_dead" ) )
		{
			//level.player thread display_hint_timeout( "hint_predator_drone_" + self get_remotemissile_actionslot(), 6 );
//			color_node_to_activate_1 = get_target_ent( "color_node_o7" );
//			color_node_to_activate_1 activate_trigger();
			maps\_spawner::killspawner( 8 );
			wait( 2 );
			array_add( level.remote_missile_targets, level.player );
			//level.price radio_dialogue( "rescue_pri_diamondmine" );
			//iprintlnbold( "Price: Keep moving, the President just across the yard!" );
			wait( 2 );
			flag_set( "yard_retreat_one_new" );
			//iprintlnbold( "Sandman: Alright, lets go, move move!" );
			thread friends_drop_off( color_node_to_activate_1 );
//			thread custom_script_anim_slide();
			wait( 19 );
			thread give_player_predator_drone();	
			radio_dialogue( "rescue_hqr_fullagms" );
			wait( 1 );
			break;
		//	flag_wait( "hard_targets_dead" );
		}
		wait( 0.05 );
	}
}

kill_ai()
{
	self waittill("damage", amount, attacker);
	if( attacker == level.player ) 
	{	
		level.player_killed_ai_count ++;
	}
}

hard_target_dialogue()
{
	self endon( "hard_targets_dead" );
	//level.price radio_dialogue( "rescue_pri_diamondmine" );
	//iprintlnbold( "Price: Uav just came online, use the drone to kill their hard targets" ); 
	wait( 2 );
	//iprintlnbold( "Price: take out the hard targets!" ); 
	while( !flag( "hard_targets_dead" ) )
	{
		wait( 6 ); 
		//iprintlnbold( "take out the hard targets!" ); 
	}

}

yard_battle_one()
{
	flag_wait( "hard_targets_dead" );
	//flag_wait( "yard_activate_orange_nodes" );
	spawners = GetEntArray( "yard_one_read_flood", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
	
//	array_spawn_targetname("yard_one_read_flood_front",  "targetname");
	
}

// these guys should move around
yard_high_road_support_think() 
{
	self AllowedStances ( "stand" );
	wait( 3 );
	self.goalradius = 2048;
	self.goalheight = 20;
}

yard_one_second_area()
{
	flag_wait( "activate_second_yard_flood" );
	
	dudes = get_living_ai_array("heli_engage_suburb_guys", "script_noteworthy");
	foreach( dude in dudes )
	{
		if ( IsAlive ( dude ) )
			dude kill();
	}
	
	autosave_by_name( "activate_second_yard_flood" );
	spawners = GetEntArray( "yard_second_flood", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
}

yard_second_flood_think()
{
	self.accuracy = 0.6;
}

second_yard_runners_think()
{
	self endon( "death" );
	wait( 10 );
	self.ignoreall = 0;
}

yard_middle()
{
	trigger = getent("hillside_subs", "targetname" );
	trigger waittill( "trigger" );
	
	sub = spawn_vehicle_from_targetname_and_drive( "suburban_hillside_one" );
//	sub.script_team = "axis";
//	sub thread maps\_remotemissile_utility::setup_remote_missile_target();	
	flag_wait("spawn_middle_yard");	
	fake_ai_ceilings = GetEntArray( "fake_ai_cieling", "targetname" );
	foreach ( ceiling in fake_ai_ceilings )
	{
		ceiling connectpaths();
		waitframe();
		ceiling delete();
	}
	
	//sub = spawn_vehicle_from_targetname_and_drive( "suburban_three" );
	level.hind_two = spawn_vehicle_from_targetname_and_drive( "hind_two" );
	level.hind_two notify( "stop_kicking_up_dust" );
//	hind = get_vehicle( "hind_one", "targetname" );
//	start = getstruct( "hindyard_middle", "targetname" );
//	hind startpath( start );
	thread yard_middle_hind_think();
	wait( 4 );
	array_spawn_targetname( "yard_snipers" ); 
	thread detect_if_littlebird_in_front_of_hind();
	wait( 3.0 );
	wait( 2.5 );
	// I need to place this in a different function
	//level.price radio_dialogue( "rescue_pri_diamondmine" );
	//iprintlnbold( "Look out enemy chopper!" );
	wait( 1 );
	level.hind_two thread chopper_fire_rockets();
	wait( 2.7 );
	level.hind_two notify( "stop_fire_rockets" );
	wait( 5 );
	//iprintlnbold( "SNIPERS... SKY HIGH!" );

	flag_wait( "middle_yard_color_red" );
		
	ent = getent( "last_hind_path", "targetname" );
	waitframe();
	
	if( !flag( "courtyard_cleared" ) )
	{
		heli_spawner = getent( "hind_off_spawner", "targetname" );
		level.hind_three = heli_spawner move_spawn_and_go( ent );
		level.hind_three notify( "stop_kicking_up_dust" );
		level.hind_three waittill ( "reached_dynamic_path_end" );
		if( IsAlive( level.hind_three ) )
		{
			level.hind_three thread maps\_remotemissile_utility::setup_remote_missile_target();
			level.hind_three.script_team = "axis";
			level.hind_three thread hind_attack_player_end();
			level.hind_three thread hind_two_random_shoot();	
			level.hind_three.target_ent = level.player;
		}
	}
	if( IsAlive( level.heli ) )	
	{
		level.heli maps\_vehicle::godoff();
		wait( 2 );
		if( IsAlive( level.heli ) )	
		{
			level.heli.enablerocketdeath = true;
			level.heli dodamage( level.heli.health + 10000, level.heli.origin );
			level.heli thread random_crash_location(); 
		}
	}
}

track_guys_alive()
{
	// middle_move_ai_forward new trigger to check if guys are still aliev
	trigger = get_Target_ent( "spawn_snowmobile_middle" );
	trigger waittill( "trigger" );
	autosave_by_name( "spawn_snowmobile_middle" );
	thread middle_yard_dialogue();

	wait( 6 );
	wait( 3 );
	waitframe(); 
	while( 1 ) 
	{
		dudes = get_living_ai_array( "yard_focused_combat_squad", "script_noteworthy" );
		if( dudes.size <= 1  )
		{
				flag_set( "activate_second_yard_flood" );
				level.color_node activate_trigger();
				break;
		}
		wait( 0.05 );
	}
}

middle_yard_dialogue()
{
	level.sandman dialogue_queue( "rescue_snd_watchfire" );	
	radio_dialogue( "rescue_lp1_nextarea" );
}

// I need to make the guys retreat back after certain kills.
new_yard_beggining_battle()
{
	trigger = get_Target_ent( "spawn_snowmobile_middle" );
	trigger waittill( "trigger" );
	mobile_air = spawn_vehicle_from_targetname_and_drive ( "littlebird_strafe_hillside" );
	mobile_air notify( "stop_kicking_up_dust" );
	mobile_air thread delete_chopper();
	mobile_air.script_team = "allies";
	
	maps\_spawner::killspawner( 1000 );
	// kill_spawner_courtyard
	// We can't have this many friends with the team at this point.
	level.sandman set_force_color( "o" );
	level.price set_force_color( "o" );
	thread clean_up_extra_ai();

	waitframe();
	dudes = getaiarray( "allies" );
	foreach( dude in dudes )
	{
		if( IsAlive( dude ) )
		{
			dude set_force_color( "o" );
		}
	}
	mobile = spawn_vehicle_from_targetname_and_drive ( "yard_snowmobile_one" );
	waitframe();
	mobile VehPhys_DisableCrashing();
	mobile.health = 100;
	mobile Vehicle_SetSpeed( 30, 100, 100 );	
	mobile.veh_pathtype = "constrained";
	wait( 2 );
	mobile_two = spawn_vehicle_from_targetname_and_drive ( "yard_snowmobile_three" );
	waitframe();
	mobile_two VehPhys_DisableCrashing();
	mobile_two.health = 100;	
	mobile_two Vehicle_SetSpeed( 30, 100, 100 );
	mobile_two.veh_pathtype = "constrained";
	
	wait( 5 );
	mobile kill();
	waitframe();
	mobile delete();
	wait( 3 );
	mobile_two kill();
	waitframe();
	mobile_two delete();
}

clean_up_extra_ai()
{
	dudes = get_living_ai_array( "delta_yard_left", "script_noteworthy" );
	foreach ( ai in dudes )
	{	
		if( IsAlive( ai ) )
		{
			magicbullet( "g36c_reflex", ai.origin + (0,400,600), ai.origin );
			ai kill();
		}
	}
	dudes_two = get_living_ai_array( "delta_yard_right", "script_noteworthy" );
	foreach ( ai in dudes_two )
	{
		if( IsAlive( ai ) )
		{
			magicbullet( "g36c_reflex", ai.origin + (0,400,600), ai.origin );
			ai kill();
		}
	}
	dudes_three = get_living_ai_array( "viper_support_crew", "script_noteworthy" );
	foreach ( ai in dudes_two )
	{
		if( IsAlive( ai ) )
		{
			magicbullet( "g36c_reflex", ai.origin + (0,400,600), ai.origin );
			ai kill();
		}
	}
}

random_crash_location()
{
	paths = getentarray( "escape_hind_middle", "script_noteworthy" );
	ent = array_randomize( paths );
	num = RandomIntRange( 0,2 );
	switch( num )
	{
		case 0:
			level.heli.perferred_crash_location = ent[ 0 ] ;		
		case 1:
			level.heli.perferred_crash_location = ent[ 1 ];		
		case 2:
			level.heli.perferred_crash_location = ent[ 2 ];		
	}
}

yard_sniper_think() 
{
	self.favoriteenemy = level.player;
	self setlookatentity( level.player );
	createthreatbiasgroup( "player" );
	level.player setthreatbiasgroup( "player" );
	createthreatbiasgroup( "snipers" );
	self setthreatbiasgroup( "snipers" );
	setthreatbias( "snipers", "player", 50000 );
	self laserforceon();
	setsaveddvar( "laserrange", 4000 );
	setsaveddvar( "laserradius", 2 );
	self AllowedStances( "stand" );
	self thread sniper_track();
	// 0.( "axis", "player", 50000 );
	
	level.counter = 2;
	while( 1 )
	{
		if( level.counter == 0 )
		{
			// color_node_r23_o13
			level.color_node activate_trigger();			
			break;
		}
		wait( 0.05);		
	}
}

sniper_track()
{
	self waittill( "death" );
	level.counter --;
}

yard_start_heli_drop_think()
{
	//flag_wait( "yard_start_heli_drop" );
	flag_wait( "yard_activate_orange_nodes" ); // yard_start_heli_drop
	

	ent = getent( "drop_off_heli_path_one", "targetname" );
	waitframe();
	heli_spawner = getent( "m1_one", "targetname" );
	heli_one = heli_spawner move_spawn_and_go( ent );
	heli_one notify( "stop_kicking_up_dust" );
	
	wait( 5 );
	ent = getent( "drop_off_heli_path_two", "targetname" );

	waitframe();
	heli_spawner = getent( "m1_one", "targetname" );
	heli_two = heli_spawner move_spawn_and_go( ent );
	heli_two notify( "stop_kicking_up_dust" );	

	heli_one waittill ( "reached_dynamic_path_end" );
	
	heli_one delete();
	
	heli_two waittill ( "reached_dynamic_path_end" );
	heli_two delete();
}

delete_chopper()
{
	self waittill( "reached_dynamic_path_end" );
	self delete();
}

// flyup, shoot missle, use chaffes to avoid, predator
yard_middle_hind_think()
{
}


yard_two_setup()
{
	level.trigger_nodes_delete_me = getent( "delete_me_trigger", "targetname" );
	// setup doors
	thread yard_two_battle();

	thread change_color_node_to_red();
	
//	level.power_trigger_damage = getent( "yard_blow_power_tower",  "targetname" );
//	level.power_trigger_damage power_tower_damage_tracker();
}

yard_two_battle()
{
	flag_wait( "spawn_in_last_subs" );
	
	// If the player gets too far ahead, kill these ai.
	dudes = get_living_ai_array( "constr_guys", "script_noteworthy" );
	foreach( ai in dudes )
	{
		ai kill();
	}
	
	autosave_by_name( "activate_second_yard_flood" );
	thread yard_two_battle_door_dialogue();
	level.end_sub = spawn_vehicle_from_targetname_and_drive ( "suburban_end_one" );
//	level.end_sub thread maps\_remotemissile_utility::setup_remote_missile_target();
//	level.end_sub.script_team = "axis";
	wait( 2 );	
	level.end_sub_two = spawn_vehicle_from_targetname_and_drive ( "suburban_end_two" );
//	level.end_sub_two thread maps\_remotemissile_utility::setup_remote_missile_target();
//	level.end_sub.script_team = "axis";
//	level.counter = 3;
//	level.tank_one = spawn_vehicle_from_targetname_and_drive ( "com_support_t90_one" );
//	level.tank_one thread track_tanks();
//	level.tank_one mgon();
//	wait( 2 );
//	level.tank_two = spawn_vehicle_from_targetname_and_drive ( "com_support_t90_two" );
//	level.tank_two thread track_tanks();
//	level.tank_two mgon();
//	wait( 2 );
//	level.tank_three = spawn_vehicle_from_targetname_and_drive ( "com_support_t90_three" );
//	level.tank_three thread track_tanks();
//	level.tank_three mgon();
	

//	thread track_tanks();
	
//	wait( 45 );
	
//	while(  )
//	{
//		if (  level.counter == 0)
//		{
//			maps\_spawner::killspawner( 6 );
//			thread yard_cleared();
//			flag_set( "courtyard_cleared" );
//			break;
//		}
//		wait( 0.5 );
//	}		
}

random_grab_ai_send_to_player_area()
{
}

yard_two_battle_door_dialogue()
{
	self endon( "courtyard_cleared" ); 
	
	level.uav_is_destroyed = true;
	// disable_uav
	level.player maps\_remotemissile::remove_uav_weapon();
	if( isdefined( level.uav ) )
	{
		level.uav.health = 10;
		level.uav delete();
		//level.uav kill();
	}
	level notify( "uav_destroyed" );
	// overlord a sam just took out out uav
	level.sandman dialogue_queue( "rescue_snd_tookoutuav" );
	//level.sandman radio_dialogue( "rescue_snd_needpredator" );
	wait( 2 );
	wait( 2 );
	level.sandman dialogue_queue( "rescue_snd_anotherway" );	
	wait( 2 );
	level.price dialogue_queue( "rescue_pri_heavyfire" );	
	wait( 2 );
	radio_dialogue( "rescue_hqr_payloadtarget" );
	wait( 3 );
	level.sandman dialogue_queue( "rescue_snd_sittight" );
	music_stop( 5 );
	spawners = GetEntArray( "yard_com_support", "targetname" );
	maps\_spawner::flood_spawner_scripted( spawners );
	wait( 5 );
	level thread in_bound_missle_strike();
	wait( 3 );

	//iprintlnbold( "Truck: There coming from every where!" );
	
//	iprintlnbold( "Overlord: Reaper online!" );
//	thread give_player_predator_drone();  predater1 this is where you got it at the end!!!!
//	iprintlnbold( "Truck: Alright we've got to shut down the power to the door, then it'll open!" );
//	wait( 3 );	
//	iprintlnbold( "Price: Right, use the reaper on the door!" );
	thread loop_earthquakes_for_ar_strike();
	wait( 3 );
	
	if( IsAlive ( level.heli) ) 
	{
		level.heli dodamage( level.heli.health + 10000, level.heli.origin );		
	}

	flag_set( "blow_up_the_door" );
//	level.power_trigger_damage trigger_on();
//	hind_fake = spawn_vehicle_from_targetname( "hind_three_fake_box" );
//	hind_fake hide();
//	hind_fake thread hind_fake_damage();
//	hind_fake thread maps\_remotemissile_utility::setup_remote_missile_target();

//	wait( 3 );	
	level.power_trigger_damage = getent( "yard_blow_power_tower",  "targetname" );
	//level.power_trigger_damage power_tower_damage_tracker();
	level thread power_tower_damage_tracker();
	
//	wait( 3 );
//	while( !flag( "courtyard_cleared" ) )
//	{
//		//level.price radio_dialogue( "rescue_pri_diamondmine" );
//		iprintlnbold( "Price: Take out the door" );
//		wait( 5 );
//		iprintlnbold( "Price: The door,  take it out" );
//		wait( 10 );
//		iprintlnbold( "Price: TAKE IT OUT!!!" );
//	}	
}

loop_earthquakes_for_ar_strike()
{
	num = 0;
	while( num <= 7 )
	{
		num++;
		Earthquake( 0.6, 0.2, level.player.origin, 300 );
		wait randomfloatrange( 0.4, 0.7 );
		
	}
}


in_bound_missle_strike()
{
	// use stingers here
//	1400 -7952 -8596
//	2448 -8316 -8592
//	3860 -8580 -8592
//	6908 -8988 -8592
//	8196 -8752 -8592
// Earthquake( 0.5, 1, level.player.origin, 300 );
// above left
// 8700 -916 -8458

	
//MagicBullet( "remote_missile_not_player_snow_cluster", ( 1400, -7952, -596 ), ( 8700, -916, -8458 ) );
	wait( 0.2 );
// above center
//8854 -1186 -8452

// sound hookup
//thread play_sound_in_space( "scn_rescue_incoming_shell", rocket );
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 2448, -8316, -3592 ), ( 8854, -1186, -8452 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
wait( 0.2 );

// above Right
//8988 -1452 -8470
//rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 3860, -8580, -1592 ), ( 8988, -1452, -8470 ) );
//rocket thread rocket_delete();
wait( 0.2 );

// bottom center
//8906 -1264 -8722
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 6908, -8988, -3592 ), ( 8906, -1264, -8722 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
wait( 0.3 );
// bottom left
//8624 -1116 -8722
//rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 6908, -8988, -592 ), ( 8624, -1116, -8722 ) );
//rocket thread rocket_delete();
wait( 0.3 );

// bottom left
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 1400, -7952, -8596 ), ( 8624, -1116, -8722 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();

// forward left
//8250 -1180 -8722
//MagicBullet( "remote_missile_not_player_snow_cluster", ( 8196, -8752, -592 ), ( 8250, -1180, -8722 ) );
wait( 0.3 );

// forward right
//8517 -1755 -8734
// sound hookup
//thread play_sound_in_space( "scn_rescue_incoming_shell ", rocket );
//rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 1400, -7952, -3596 ), ( 8517, -1755 ,-8734 ) );
//rocket thread rocket_delete();
wait( 0.3 );
// forward center
//8590 -1368 -8722
//MagicBullet( "remote_missile_not_player_snow_cluster", ( 3860, -8580, -2592 ), ( 8590, -1368, -8722 ) );


//MagicBullet( "remote_missile_not_player_snow_cluster", ( 1400, -7952, -3596 ), ( 8700, -916, -8458 ) );
	wait( 0.2 );
// above center
//8854 -1186 -8452
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 2448, -8316, -1592 ), ( 8854, -1186, -8452 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
wait( 3 );

// above Right
//8988 -1452 -8470
//MagicBullet( "remote_missile_not_player_snow_cluster", ( 3860, -8580, -592 ), ( 8988, -1452, -8470 ) );
wait( 0.2 );

// bottom center
//8906 -1264 -8722
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 6908, -8988, -3592 ), ( 8906, -1264, -8722 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
wait( 0.3 );
// bottom left
//8624 -1116 -8722
//MagicBullet( "remote_missile_not_player_snow_cluster", ( 6908, -8988, -592 ), ( 8624, -1116, -8722 ) );
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 8196, -8752, -1592 ), ( 8250, -1180, -8722 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
wait( 0.3 );

// bottom left
//MagicBullet( "remote_missile_invasion", ( 1400, -7952, -8596 ), ( 8624, -1116, -8722 ) );

// forward left
//8250 -1180 -8722
// sound hookup
//thread play_sound_in_space( "scn_rescue_incoming_shell ", rocket );
rocket = MagicBullet( "remote_missile_not_player_snow_cluster", ( 8196, -8752, -1592 ), ( 8250, -1180, -8722 ) );
rocket thread play_sound_on_entity( "scn_rescue_incoming_shell" );
rocket thread rocket_delete();
}

rocket_delete()
{
	wait( 4 );
	if ( isdefined( self ) )
		self delete();
}

hind_fake_damage()
{
	self waittill( "death" );
	self delete();
}

power_tower_damage_tracker()
{
//	self waittill("damage", amount, attacker);
//	if( attacker == level.player ) 
//	{	
		if( IsAlive( level.hind_three ) )
		{
			level.hind_three kill();
		}
		thread yard_cleared();
		flag_set ( "courtyard_cleared" );
		musicstop( 8 );	 
		thread tower_power_explosions();
	wait( 10 );
	maps\_spawner::killspawner( 30 ); // stop spawing support above.
	maps\_spawner::killspawner( 5 ); // stop spawing support above.
// new design, kill off all remaining guys so you can just run into the caves now.	
//	wait( 20 );
	dudes = get_living_ai_array( "kill_on_art_strike", "script_noteworthy");
	foreach ( dude in dudes )
	{
		dude kill();
	}
	
	dudes = get_living_ai_array( "yard_com_support", "targetname");
	foreach ( dude in dudes )
	{
		dude kill();
	}
}

// adjusted for difficulty.
yard_com_support_think()
{
	self.accuracy = 0.7;
}

tower_power_explosions()
{
	ent1 = getent( "power_tower_1", "targetname" );
	ent2 = getent( "power_tower_2", "targetname" );
	ent3 = getent( "power_tower_3", "targetname" );
	ent4 = getent( "power_tower_4", "targetname" );
	ent5 = getent( "power_tower_5", "targetname" );
	ent6 = getent( "power_tower_6", "targetname" );
	woosh_cloud = getent( "woosh_cloud", "targetname" );
	wait( 0.6 );
	
	ai_axis = getaiarray( "axis" );
	
	Earthquake( 0.8, 1.3, level.player.origin, 300 );
//	playfx( level._effect[ "bomb_explosion_ac130" ], ent1.origin, ( 0, 0, 1 ) );
	
	exploder( "cave_door" );
	
	if ( Distance2d( level.player.origin, level.new_cave_door_collision.origin ) < 650 )
	{
		level.player kill();
		return;
	}
	
	level.price dialogue_queue( "rescue_pri_morelikeit" );
	level.new_cave_door_collision connectpaths();
	waitframe(); // I just added to be sure it connects paths before deleting.
	level.new_cave_door_collision delete();
	Earthquake( 0.9, 0.5, level.player.origin, 300 );
	playfx( level._effect[ "bomb_explosion_ac130" ], ent5.origin, ( 0, 0, 1 ) );
	
	flag_set( "cavern_door_open" ); // added from Carlos section.	
	wait( 3.5 );
	Earthquake( 0.9, 0.5, level.player.origin, 300 );
	playfx( level._effect[ "bomb_explosion_ac130" ], ent6.origin, ( 0, 0, 1 ) );
}

stumble_alot()
{
	self endon( "death" );
	if ( !isAlive(self) )
		return;
	for ( i=0; i<4; i++ )
	{
		num = RandomIntRange( 0, 5 );
		switch ( num )
		{
			case 0:
				self anim_generic( self, "hijack_generic_stumble_stand2" );
			case 1:
				self anim_generic( self, "hijack_generic_stumble_stand1" );
			case 3:
				self anim_generic( self, "hijack_generic_stumble_crouch1" );
			case 4:
				self anim_generic( self, "hijack_generic_stumble_crouch2" );
		}
	}
}

track_tanks()
{
	self waittill( "death" );
	level.counter --;
}

yard_cleared()
{
	if( IsDefined( level.trigger_nodes_delete_me ) )
	{
		level.trigger_nodes_delete_me delete();
	}
	
	wait( 2 );
	//level.price radio_dialogue( "rescue_pri_diamondmine" );
	//	iprintlnbold( "Price: That's it, the door's opening" );
	//	turn_on_color_node_one = getent( "ai_use_red_cnodes_r1", "targetname" );
	//	turn_on_color_node_two = getent( "ai_use_orange_cnodes_o1", "targetname" );
	dead_guys_before_move = 0;
	ai_axis = getaiarray( "axis" ); 
	foreach( ai in ai_axis )
	{
		ai.health = 1;
	}
	waitframe();
	//retreat_location = getent ( "retreat_to_zipline", "targetname" );
	//	thread get_ai_flow( color_node_to_activate, undefined, undefined, undefined, dead_guys_before_move, undefined );
	//	color_node_to_activate waittill( "trigger" );
	wait( 0.5 );
	wait( 4 );
	
	axis_ai = getaiarray( "axis" );
	foreach( ai in axis_ai )
	{
		self.accuracy = 0.0001;
	}
	//iprintlnbold( "Go go go !" );
}

change_color_node_to_red()
{
	level endon( "cavern_door_open" );
	flag_wait( "middle_yard_color_red" );
	ai_ally = getaiarray( "allies" ); // sets everyone to red for the end.
	foreach( ai in ai_ally )
	{
		ai set_force_color( "r" );
	}
}

set_start_positions( targetname ) // this teleports the  to the correct location.
{	
	start_positions = getstructarray( targetname, "targetname" );
	foreach ( pos in start_positions )
	{
		switch ( pos.script_noteworthy )
		{
			case "player":
				level.player SetOrigin( pos.origin );
				level.player SetPlayerAngles( pos.angles );
					if ( IsDefined ( level.elevator ) )
						level.player SetOrigin( pos.origin + ( 0,0,5 ) );
			break;
			case "sandman":
				pos = getstruct( "elevator_anim_sandman", "targetname" );
				level.sandman ForceTeleport( pos.origin, pos.angles );
				level.sandman SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.sandman LinkTo ( level.elevator );		
			break;
			case "truck":
				level.truck ForceTeleport( pos.origin, pos.angles );
				level.truck SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.truck LinkTo ( level.elevator );		
			break;
			case "price":
				pos = getstruct( "elevator_anim_price", "targetname" );
				level.price ForceTeleport( pos.origin, pos.angles );
				level.price SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.price LinkTo ( level.elevator );		
			break;
			case "grinch":
				level.grinch ForceTeleport( pos.origin, pos.angles );
				level.grinch SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.grinch LinkTo ( level.elevator );
			break;
//			case "delta_one":
//				if( IsDefined( level.delta_one ) )
//					level.delta_one ForceTeleport( pos.origin, pos.angles );
//					level.delta_one SetGoalPos( pos.origin );
//						if ( IsDefined ( level.elevator ) )
//					level.delta_one LinkTo ( level.elevator );
//			break;
			case "delta_two":
				if( IsDefined( level.delta_two ) )
					level.delta_two ForceTeleport( pos.origin, pos.angles );
					level.delta_two SetGoalPos( pos.origin );
						if ( IsDefined ( level.elevator ) )
					level.delta_two LinkTo ( level.elevator );
			break;
		}
	}
}

// I don't need this, this is extra. I will go back and mack this much cleaner.
set_start_positions_two( targetname ) // this teleports the  to the correct location.
{	
	start_positions = getstructarray( targetname, "targetname" );
	foreach ( pos in start_positions )
	{
		switch ( pos.script_noteworthy )
		{
			case "player":
				level.player SetOrigin( pos.origin + ( 0,0,20 )  );
				level.player SetPlayerAngles( pos.angles );
				//level.player LinkTo ( level.elevator );		
			break;
			case "sandman":
				level.sandman ForceTeleport( pos.origin, pos.angles );
				level.sandman SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.sandman LinkTo ( level.elevator );		
			break;
			case "truck":
				level.truck ForceTeleport( pos.origin, pos.angles );
				level.truck SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.truck LinkTo ( level.elevator );		
			break;
			case "price":
				level.price ForceTeleport( pos.origin, pos.angles );
				level.price SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.price LinkTo ( level.elevator );		
			break;
			case "grinch":
				level.grinch ForceTeleport( pos.origin, pos.angles );
				level.grinch SetGoalPos( pos.origin );
					if ( IsDefined ( level.elevator ) )
						level.grinch LinkTo ( level.elevator );
			break;
		}
	}
}



// This is going to be used to spawn dead workings along the sides of the walls.
//dead_body_spawner_trigger() // used to setup dead bodies for the workers in the cave.
//{
//	self waittill( "trigger" );
//	t = self get_target_ent();
//	structs = getstructarray( t.script_noteworthy, "script_noteworthy" );
//	foreach ( s in structs )
//	{
//		guy = t spawn_ai();
//	//	guy thread deletable_magic_bullet_shield();
//		guy.origin = s.origin;
//		guy.angles = s.angles;
//		guy SetCanDamage( false );
//		
//		anime = level.scr_anim[ "generic" ][ s.animation ];
//		if ( IsArray( anime ) )
//			anime = anime[ 0 ];
//			
//		guy gunless_anim_check( s.animation );
//		guy AnimScripted( "endanim", s.origin, s.angles, anime );
//		if ( isdefined( s.script_parameters ) )
//		{
//			if ( s.script_parameters == "notsolid" )
//			{
//				guy NotSolid();
//			}
////			if ( s.script_parameters == "ripples" )
////			{
////				guy thread ripples_on_body();
////			}
//		}
//		
//		if ( issubstr( s.animation, "death" ) )
//			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
//	}
//}

//physics_jolt_trigger() // use this for the shakes from the outside and inside the elevator.
//{
//	self waittill( "trigger" );
////	self script_delay();
//	
//	tank = get_vehicle( "apt_btr_backup", "targetname" );
//	
//	tank FireWeapon();
//	Earthquake( self.script_physics * 3, 0.6, self.origin, self.radius * 1.5 );
//	
//	node = getstructarray( self.target, "targetname" );
//	foreach ( n in node )
//	{
//		if ( cointoss() )
//			num = RandomFloatRange( 0.1, 0.2 );
//		else
//			num = RandomFloatRange( 0.4, 0.6 );
//			
//		delayThread( num, ::_Physics_Jitter, n.origin, n.radius, n.radius * 0.5, self.script_physics * 0.5, self.script_physics);
//		if ( isdefined( n.script_fxid ) )
//			fxid = n.script_fxid;
//		else
//			fxid = "ceiling_dust_default";
//		delayThread( num + RandomFloatRange( -1*num, 0.5 ), ::_play_fx, getfx( fxid ), n.origin );
//	}
//	lights = getentarray( self.script_parameters, "targetname" );
//	foreach ( l in lights )
//	{
//		l.old_intensity = l GetLightIntensity();
//		thread maps\_util_carlos::flickering_light( l, 0.2, 0.8 );
//		thread maps\_util_carlos::moving_light( l, 4 );
//	}
//	wait( 1.0 );
//	foreach ( l in lights )
//	{
//		l notify( "stop_flicker" );
//		l notify( "stop_movement" );
//		l setLightIntensity( l.old_intensity * RandomFloatRange( 0.7, 1.0 ) );
//		if ( cointoss() )
//			wait( RandomFloatRange( 0, 0.5 ) );
//	}
//}


// I proabably wont use this because I've made a new version of it.
enemy_group_almost_dead_run( alive_before_retreat, named_flag, color_node_to_activate, trigger_to_activate )
{	
	while( !flag( named_flag ) )
	{
			if ( level.counter_dead < alive_before_retreat ) // need to spawn same guys that come in
			{
				//activate_trigger_with_targetname( "courtyard_support_trigger" );
				if( IsDefined ( trigger_to_activate ) )
				{
					trigger_to_activate activate_trigger( );
				}
				flag_set ( named_flag );
				if( IsDefined ( color_node_to_activate ) )
				{	
					color_node_to_activate activate_trigger ( );
				}
				break;
			}
		wait( 0.05 );
	}
	
	if( IsDefined ( trigger_to_activate ) )
	{
		trigger_to_activate activate_trigger( );
	}
	if( IsDefined ( color_node_to_activate ) )
	{
		color_node_to_activate activate_trigger ( );
	}	
}

cave_dust() 
{
	level endon( "cave_exit" );
	volume = get_target_ent( "cave_shake_volume" );
	
	level.cave_shake_sound = "scn_prague_tank_alley_exp";
	level.cave_shake_source = get_Target_ent( "cave_shake_source" );
	level.shake_fx_num = 9;
	
	while( 1 )
	{
		wait( RandomFloatRange( 1,3 ) );
		
		if ( !level.player isTouching( volume ) )
			continue;

		strength = RandomFloatRange( 0.3, 0.6 );
		cave_shake( strength, "dust_source", "cave_one_light" );
		
		wait( RandomFloatRange( 1,3 ) );
	}
}

cave_shake( strength, origin_targetname, light_targetname, ignoreheight ) // borrowed from prague
{
	if ( !isdefined( ignoreheight ) )
		ignoreheight = false;
	
	lights = getentarray( light_targetname, "targetname" );
	origins = getstructarray( origin_targetname, "targetname" );
	f = AnglesToForward( level.player.angles )*128;
	origins = SortByDistance( origins, level.player.origin + f );
	times = 0;
	
	thread play_sound_in_space( level.cave_shake_sound, level.cave_shake_source.origin );
	//thread play_sound_in_space( level.cave_shake_sound );
	
	Earthquake( strength, strength, level.player.origin, 196 );
	foreach ( org in origins )
	{
		if ( org.origin[2] > level.player.origin[2] || ignoreheight )
		{
			if ( cointoss() )
			{
				if ( !isdefined( org.script_fxid ) )
					org.script_fxid = "ceiling_dust_default";
				delay = RandomFloatRange(0,1.5);
				
				if ( isdefined( org.angles ) )
					forward = AnglesToForward( org.angles );
				else
					forward = undefined;
					
				delayThread( delay, ::_Play_FX, getfx( org.script_fxid ), org.origin, forward );
				if ( isdefined( org.script_soundalias ) )
					delayThread( delay, ::play_sound_in_space, org.script_soundalias, org.origin );
				times += 1;
			}
		}
		if ( times > level.shake_fx_num )
		{
			break;
		}
	}
	
	foreach ( l in lights )
	{
		l thread shake_light_flicker();
	}
}

shake_light_flicker()
{
	old = self getLightIntensity();
	thread maps\_util_carlos::flickering_light( self, 0.2, 0.8 );
	wait( RandomFloatRange( 0.5,1 ) );
	self notify( "stop_flicker" );
	self setLightIntensity( old );
	self maps\_util_carlos::modelOnState();
}

_play_fx( id, org, forward )
{
	if ( !isdefined( forward ) )
		PlayFX( id, org );
	else
		PlayFX( id, org, forward );
}

dialog_handle_predator_infantry_kills()
{
	kills = 0;
	
	while( 1 )
	{
		level waittill( "remote_missile_exploded" );
		
		wait .1;
		
		if( isdefined( level.uav_killstats[ "ai" ] ) )
			kills = level.uav_killstats[ "ai" ];
		
			vehicle_alias = undefined;
			btr_kills = 0;
		
			vehicle_kills = 0;
			btr_kills = 0;
			helo_kills = 0;
			jeep_kills = 0;
			truck_kills = 0;

		foreach ( index, kills in level.uav_killstats )
		{
			if ( index == "ai" )
			{
				continue;
			}
	
			if ( kills  > 0 )
			{
				vehicle_kills = vehicle_kills + kills;
	
				if ( index == "btr" )
				{
					btr_kills = kills;
				}
				else if ( index == "helo" )
				{
					helo_kills = kills;
				}
				else if ( index == "jeep" )
				{
					jeep_kills = kills;
				}
				else if ( index == "truck" )
				{
					truck_kills = kills;
				}
			}
		}
		
		
		
		if( kills == 0 && vehicle_kills == 0 )
		{
//			alias = random( ["uav_0_kill", "uav_0_kill2"] );
//			radio_dialogue( alias );
		}
		kills = 0;
	}
}

give_player_predator_drone()
{
	//	level.player thread remoteRide();
	//level.player thread maps\_remotemortar_sp::remoteRide();
	//level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );
	flag_set( "player_has_predator_drones" );
//	thread dialog_handle_predator_infantry_kills();
	level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );
	predator_drone_control = getent( "predator_drone_control", "targetname" );
	predator_drone_control hide();
	predator_drone_control makeUnusable();
}

monitor_predator_usage()
{
	level endon ( "courtyard_cleared" );
	while( true )
	{
		level waittill ( "player_is_controlling_UAV" );
		{
			flag_set( "uav_in_use" );
			thread predator_shoot_hint();
		}
	
		level waittill ( "draw_target_end" );
		flag_clear( "uav_in_use" );
	}
}

predator_shoot_hint()
{
	level endon ( "player_fired_remote_missile" );
	level endon ( "predator_hind_dead" );
	level endon ( "draw_target_end" );
	
	wait 3;
	
	display_hint ( "hint_predator_shoot" );	
}

should_break_predator_shoot_hint()
{
	if ( level.player AttackButtonPressed() )
		return true;
	if ( !flag ( "uav_in_use" ) )
		return true;
	return false;
	
}

give_player_predator_reaper()
{
	//	level.player thread remoteRide();
//	level.player thread maps\_remotemortar_sp::remoteRide();
	//level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );
	flag_set( "player_has_predator_drones" );
	
	//	level.player giveWeapon( "remote_missile_detonator" );
	//	level.player SetActionSlot( 4, "weapon", "remote_missile_detonator" );
	//	level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );
	
	// level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );

	predator_drone_control = getent( "predator_drone_control", "targetname" );
	predator_drone_control hide();
	predator_drone_control makeUnusable();	
}

uav_target()
{
	while( 1 )
	{
		level.uavTargetEnt = getent ("target_for_uav",  "targetname"); // general aiming area for uav
		wait ( 1 );
	}
}


UAVRigAiming()
{
	level.uav endon ( "death" );
	for ( ;; )
	{
		if ( IsDefined( level.uavTargetEnt ) )
			targetPos = level.uavTargetEnt.origin;
		else if ( IsDefined( level.uavTargetPos ) )
			targetPos = level.uavTargetPos;
		else
			targetpos = ( 6073, -1210.5, -8246 );  // you could put this in invasion.map if you'd like.
			

		angles = VectorToAngles( targetPos - level.uav.origin );

		level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
		level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		wait 0.05;
	}
}

setup_remote_missile_target_guy() 
{
	if( isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "paradrop_guy_left" )
			return;
		if( self.script_noteworthy == "paradrop_guy_right" )
			return;
	}
	if( isdefined( self.ridingvehicle ) )
	{
		self endon( "death" );
		self waittill( "jumpedout" );	
	}
	
	// remote targeting requires a unique id.  //drones don't have it. not sure where this broke but I don't think it's my doi
	if( !isdefined( self.unique_id ) )
		return;
		
	self maps\_remotemissile_utility::setup_remote_missile_target();
}

loud_speakers()
{
	speaker = spawn( "script_origin", level.player.origin + ( 0,0, 10) );
	//speaker linkto( level.player, "tag_origin", ( 0,0, 1000), (0,0,0) );
	speaker linkto( level.player );
	
	level.speaker_location = "structs";	
	level.speaker_min_delay = 20;
	level.speaker_max_delay = 30;
	
	while( 1 )
	{
		switch( level.speaker_location )
		{
			case "off":
				break;
			case "player":
				speaker thread play_sound_on_entity( "prague_loud_speaker" );
				break;
			case "vehicle":
				vehicles = level.vehicles[ "axis" ];
				if ( vehicles.size > 0 )
				{
					vehicles = SortByDistance( vehicles, level.player.origin );
					vehicles[ 0 ] thread play_sound_on_entity( "prague_loud_speaker" );
					break;
				}
			default:
				structs = getstructarray( "speaker_location", "targetname" );
				structs = SortByDistance( structs, level.player.origin );
				thread play_sound_in_space( "prague_loud_speaker", structs[ 0 ].origin );
		}
		level waittill_notify_or_timeout( "play_loud_speaker", RandomFloatRange( level.speaker_min_delay, level.speaker_max_delay ) );
	}
}

start_uav()
{
	cur_vision_set = GetDvar( "vision_set_current" );
	set_vision_set( cur_vision_set, 0 );	// we need to do this to ensure the level.lvl_visionset is set for the uav code
	// uav_begin
	//uav = getent( "uav", "targetname");
	node = getvehiclenode( "uav_begin", "script_noteworthy");
	level.uav = spawn_vehicle_from_targetname( "uav" );
	thread reaper_player_model();
	flag_wait( "start_yard_one" );
	level.uav startpath( node );
	level.uav thread uav_path();
	level.uav.health = 50000;
	level.uav playLoopSound( "uav_engine_loop" );
	level.uavRig = spawn( "script_model", level.uav.origin );
	level.uavRig setmodel( "tag_origin" );
	thread uav_target();
	thread UAVRigAiming();
}

setup_uav()
{
	cur_vision_set = GetDvar( "vision_set_current" );
	set_vision_set( cur_vision_set, 0 );	// we need to do this to ensure the level.lvl_visionset is set for the uav code
	//  we may need to do some work on this for specops since it is using the level setting rather than a player setting
	level.uav = spawn_vehicle_from_targetname_and_drive( "uav" );
	level.uav playLoopSound( "uav_engine_loop" );
	level.uavRig = spawn( "script_model", level.uav.origin );
	level.uavRig setmodel( "tag_origin" );
	level.uav_struct.view_cone = 12;
	level.uav vehicle_setspeed ( 3, 15, 5 );
	thread UAVRigAiming();
	thread give_player_predator_drone();
	thread monitor_reaper_usage();
	level.uav hide();
}

monitor_reaper_usage()
{
	while( true )
	{
		level waittill ( "player_is_controlling_UAV" );
		{
			flag_set( "uav_in_use" );
			thread predator_shoot_hint();
		}
	
		level waittill ( "draw_target_end" );
		flag_clear( "uav_in_use" );
	}
}

reaper_player_model()
{
	//show a dummy player model while in predator viewcone
	level endon ( "courtyard_cleared" );
	
	dummy_spawner = spawn ( "script_origin", level.player.origin );
//	dummy = dummy_spawner spawn_ai ( true );
//	dummy_org = dummy.origin;
//	dummy_angles = dummy.angles;
//	dummy magic_bullet_shield();
//	dummy disable_pain();
	
	player_org = spawn ( "script_origin", ( 0, 0, 0 ) );
	player_angles = undefined;
	
	model = spawn ( "script_model", ( 0, 0, 0 ) );
	model linkto ( level.player );
	model setmodel ( "body_delta_elite_snow_assault_ab" );
	level.player thread maps\_remotemissile_utility::setup_remote_missile_target();
	model hide();
	
	
	while ( true )
	{
		while ( !flag ( "uav_in_use" ) )
		{
			player_org.origin = level.player.origin;
			player_angles = level.player getplayerangles ();
			stance = level.player getstance();
			model.angles = player_angles;
			model.origin = level.player.origin;
			
			wait 0.1;
		}
		
		while ( flag ( "uav_in_use" ) )
		{
			model.origin = level.player.origin;
			model show();
			flag_waitopen ( "uav_in_use" );
			model hide();
		}
	}
	
}


do_random_stunned_anim()
{
	//store current animname
	if(isdefined(self.animname) )
	{
		self.og_animname = self.animname;
	}
	
	//change animname to generic	
	self.animname = "generic";
	
	//establish the array of lines to use
	if(!IsDefined(level.stun_anims))
	{
		level.stun_anims = [];
		level.stun_anims[level.stun_anims.size] ="stunned1";
		level.stun_anims[level.stun_anims.size] ="stunned2";
		//level.stun_anims[level.stun_anims.size] ="stunned3";
		//level.stun_anims[level.stun_anims.size] ="stunned4";
		level.stun_anims[level.stun_anims.size] ="stunned5";
	}
	
	//and the used_lines array as well
	if(!IsDefined(level.used_stun_anims))
	{
		level.used_stun_anims = [];
	}	
	
	//mix up the array and pick a random one
	mixed_anims = array_randomize( level.stun_anims );
	random_anim = random (mixed_anims);
	
	self anim_single_solo( self, random_anim );
	
	//add that line to the used array
	level.used_stun_anims = add_to_array (level.used_stun_anims, random_anim );
	
	//remove the line from the lines array
	level.stun_anims = array_remove (level.stun_anims, random_anim);
	

	
	//if we've used all the lines
	if(level.stun_anims.size == 0)
	{
		//reset the array 
		level.stun_anims = level.used_stun_anims;
		
		//empty the used lines array
		level.used_stun_anims = [];
	}
	
	//restore orig animname
	self.animname = self.og_animname;	

}


// Hand written stuff for friendly spawning.
spawn_allies( )
{
	// 		(spawn_ally( "redend1" )) setup_red1(); // won't work if structs don't exist, as spawn returns undefined. Change over when BSP recompiled.
	temp = spawn_ally( "delta_yard_right" );
	if( IsDefined(temp) )
		temp setup_red1_right();
			
//	temp = spawn_ally( "delta_yard_left", override_spawn_name );
//	if( IsDefined(temp) )
//		temp setup_orange1_left();	
}

setup_red1_right()
{
	self set_force_color( "r" );
}

setup_orange1_left()
{
	self set_force_color( "o" );
}

spawn_ally( allyName , overrideSpawnPointName )
{
	spawnname = undefined;
    if ( !IsDefined( overrideSpawnPointName ))
    {
        spawnname = level.start_point + "_" + allyName;
    }
    else
    {
        spawnname = overrideSpawnPointName + "_" + allyName;    	
    }

    ally = spawn_noteworthy_at_struct_targetname( allyName , spawnname );
	
    return ally;
}
spawn_noteworthy_at_struct_targetname( noteworthyName , structName )
{
    noteworthy_spawner = getent( noteworthyName , "script_noteworthy" );
	noteworthy_start = getstruct( structName , "targetname" );
	if( IsDefined(noteworthy_spawner) && IsDefined(noteworthy_start) )
	{
		noteworthy_spawner.origin = noteworthy_start.origin;
		if(isdefined(noteworthy_start.angles))
		{
			noteworthy_spawner.angles = noteworthy_start.angles;
		}
		spawned = noteworthy_spawner spawn_ai();
	    return spawned;  
	}
	return undefined;
}

array_spawn_allow_fail( spawners, bForceSpawn )
{
	guys = [];
	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		//spawner script_delay();
		guy = spawner spawn_ai( bForceSpawn );
		if ( IsDefined( guy ))
		{
			guys[ guys.size ] = guy;
		}
	}
	return guys;
}

array_spawn_with_delay( spawners, bForceSpawn )
{
	guys = [];
	foreach ( spawner in spawners )
	{
		spawner.count = 1;
		spawner script_delay();
		guy = spawner spawn_ai( bForceSpawn );
		if ( IsDefined( guy ))
		{
			guys[ guys.size ] = guy;
		}
	}
	return guys;
}

array_spawn_targetname_allow_fail( targetname )
{
//	IPrintLnBold("array spawn: "+targetname);
	spawners = GetEntArray( targetname, "targetname" );
	AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
	return array_spawn_allow_fail( spawners );
}

array_spawn_targetname_with_delay( targetname )
{
//	IPrintLnBold("array spawn: "+targetname);
	spawners = GetEntArray( targetname, "targetname" );
	AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
	return array_spawn_with_delay( spawners );
}

array_spawn_targetname_allow_fail_setthreat( tospawn , threatgroup )
{
	spawned = array_spawn_targetname_allow_fail( tospawn);
	foreach(spawn in spawned)
	{
		spawn SetThreatBiasGroup( threatgroup );
	}
	return spawned;
}

// chopper firing code
chopper_fire_rockets()
{
	self endon( "death" );
	self endon( "stop_follow_path" );
	self endon( "stop_fire_rockets" );

	self SetVehWeapon( "missile_attackheli" );

//	fire_time = WeaponFireTime( "missile_attackheli" );
	fire_time = 0.2;
	count = 0;
	while ( 1 )
	{
		if ( count % 2 == 0 )
		{
			tag = "tag_missile_left";
			right = AnglesToRight( ( 0, self.angles[ 1 ], 0 ) + ( 0, 180, 0 ) );
		}
		else
		{
			tag = "tag_missile_right";
			right = AnglesToRight( ( 0, self.angles[ 1 ] , 0 ) );
		}

		offset = ( right * 60 );

		self FireWeapon( tag, self.target_ent, offset );

		wait( fire_time );
		count++;
	}
}

// self thread chopper_hover( path_point.origin, dist, "stop_follow_path" );
chopper_hover( origin, dist, extra_endon )
{
	self endon( "stop_chopper_hover" );

	if ( IsDefined( extra_endon ) )
	{
		self endon( extra_endon );
	}

	if ( !IsDefined( dist ) )
	{
		dist = 100;
	}

	while ( 1 )
	{
		x = RandomFloatRange( dist * -1, dist );
		y = RandomFloatRange( dist * -1, dist );
		z = RandomFloatRange( dist * -1, dist );

		self SetVehGoalPos( origin + ( x, y, z ), 1 );

		self Vehicle_SetSpeed( 5 + RandomInt( 10 ), 3, 3 );
		self waittill( "goal" );
	}
}

hind_attack_player_end()
{
	self endon ( "death" );
	//	struct = getstruct( "sewer_pipe_target", "targetname" );
	//	target = Spawn( "script_origin", level.player.origin );
	//	self.target_ent = target;

	//	littlebird_set_override_target( target );
	//  level.hind_two SetLookAtEnt( level.player );
	//self vehicle_paths( ent_target );
	self thread chopper_hover( self.origin, 100, undefined );
	self SetVehGoalPos( self.origin + (0, 0, 1) );
	
	// self.main_turret 
	
//	count = 0;
///	while ( 1 )
//	{
	self SetLookAtEnt( level.player );
	
	self SetVehGoalPos( ( 8924, -2640 ,-7840 ) );
	self waittill ( "reached_dynamic_path_end" );
	
//		wait 1.0;
//	}
	while( IsAlive( self ) )
	{
		
			num = RandomIntRange( 0, 3 ); 
			switch ( num )
			{
				case 0:
					self SetVehGoalPos( ( 8227, -3453, -7840 ) ); // far right
				//	self waittill ( "reac" );
					wait( 12 );
				case 1:
					self SetVehGoalPos( ( 9219, -1163, -7840 ) ); // middle
				//	self waittill ();
					wait( 12 );
				case 2:
					self SetVehGoalPos( ( 8924, -2640 ,-7840 ) ); // far left
				//	self waittill ();
					wait( 12 );
			}
			wait( 0.05 );
	}
//	self waittill( "fire_rockets" );
//	target thread ent_follow_path( struct.target, 200 );
//
//	self waittill( "prep_stop_rockets" );
//	level thread sewer_pipes();
//	littlebird_clear_override_target();
//
//	self waittill( "follow_path_done" );
//
////	self.pause_spot_light_monitor = undefined;
////	self.pause_spot_light_monitor = true;
//	self ent_flag_set( "spotlight_on" );
//	target Delete();
//
//	struct = getstruct( "construction_area_hoverpoint", "targetname" );
//	level.docks_littlebird.hover.hover_point = struct;
}

hind_two_random_shoot()
{
	self endon( "death" );
	while( IsAlive( self ) )
	{
			num = RandomIntRange( 0, 3 ); 
			switch ( num )
			{
				case 0:
					self thread chopper_fire_rockets();
					wait( 0.1 );
					self notify( "stop_fire_rockets" );
					wait( RandomFloatRange( 5, 10 ) );
				case 1:
					self thread chopper_fire_rockets();
					wait( 0.1 );
					self notify( "stop_fire_rockets" );
					wait( RandomFloatRange( 9, 15 ) );
				case 2:
					self thread chopper_fire_rockets();
					wait( 0.1 );
					self notify( "stop_fire_rockets" );
					wait( RandomFloatRange( 7, 11 ) );
			}
			wait( 0.05 );
	}
}

// vehicle stuff
move_spawn_and_go( path_ent )
{
	self.origin = path_ent.origin;
	if ( isdefined( path_ent.angles ) )
		self.angles = path_ent.angles;

	// changes targetname of ai so that they to can spawn
//	other_ents = getentarray( self.target, "targetname" );
//	foreach( ent in other_ents )
//	{
//		if ( isspawner( ent ) )
//			ent.targetname = path_ent.targetname;
//	}

	self.target = path_ent.targetname;

	vehicle = self thread maps\_vehicle::spawn_vehicle_and_gopath();

	return vehicle;
}

move_spawn_and_go_regular_nodes( path_ent )
{
	self.origin = path_ent.origin;

	self.target = path_ent.targetname;

	vehicle = self thread maps\_vehicle::spawn_vehicle_and_gopath();

	return vehicle;
}

new_vehicle_path( path_start )
{
	if ( !self maps\_vehicle::ishelicopter() )
		self StartPath( path_start );
	self thread maps\_vehicle::vehicle_paths( path_start );
}


//mark_heli_path( ent )
//{
///#
//	if ( getdvar( "debug_heli" ) == "" )
//		return;
//
//	old_ent = ent;
//	while( true )
//	{
//		draw_cross( ent.origin );
//		if ( !isdefined( ent.target ) )
//			break;
//		ent = getent( ent.target, "targetname" );
//		Line( ent.origin, old_ent.origin, ( 0.7,0,0 ), 1, false, 500 );
//		old_ent = ent;
//	}
//#/
//}


fake_helis_above_tier_one()
{
}

fake_helis_above_tier_two()
{
}

clean_up()
{
	// getting rid of all brushmodels behind the player
	// kill elevator
	wait( 2 );
//	level.elevator delete();
	
	// clean up all the spawners
//	add_clean_up_ent =  GetEntArray( "add_clean_up_ent", "script_paramaters" );
//	foreach( ent in add_clean_up_ent )
//	{
//		ent delete();
//	}
	
//	structs = getstructarray_delete( "fake_shooting", "targetname" );
//	structs_2 = getstructarray_delete( "delete_me", "targetname" );
	

	delete_me =  GetEntArray( "bay_garage_support", "targetname" );
//	cave_run_defender =  GetEntArray( "cave_run_defender", "script_noteworthy" );
//	delete_me = array_combine( "bay_garage_support", "cave_run_defender" );
	
//	cave_run_to_bay =  GetEntArray( "cave_run_to_bay", "script_noteworthy" );
//	delete_me = array_combine( "delete_me", "cave_run_to_bay" );

//	cave_rappel_ground =  GetEntArray( "cave_rappel_ground", "targetname" );
//	delete_me = array_combine( "delete_me", "cave_rappel_ground" );
	
	foreach( ent in delete_me )
	{
		ent delete();
	}		
	dude = getent( "elevator_volume", "targetname"  );
	dude delete();
//	door = getent( "elevator_rocket_detection", "targetname" );
//	door delete();
	
//	door_r = getent( "door_r", "targetname" );
//	door_r delete();
//	door_l = getent( "door_l", "targetname" );
//	door_l delete();
	
	// new two sets of doors
//	door_r_top = getent( "door_r_top", "targetname" );
//	door_r_top delete();
	door_l_top = getent( "door_l_top", "targetname" );
	door_l_top delete();
	door_gate_top = getent( "door_gate_top", "targetname" );
	door_gate_top delete();


	door_r_bottom = getent( "door_r_bottom", "targetname" );
	door_r_bottom delete();
	door_l_bottom = getent( "door_l_bottom", "targetname" );	
	door_l_bottom delete();
	door_gate_bottom = getent( "door_gate_bottom_two", "targetname" );
	door_gate_bottom delete();
	door_l = get_target_ent( "bay_small_door" );
	door_l delete();
	
	
//	reset_angles = getent( "reset_angles", "script_flag" );
//	reset_angles delete();
	
//	now_spawn_rappel =  GetEntArray( "now_spawn_rappel", "script_flag" );
//	foreach( ent in now_spawn_rappel )
//	{
//		ent delete();
//	}
	
//	cave_runner_close_door  = GetEntArray( "cave_runner_close_door", "script_flag" );
//	foreach( ent in cave_runner_close_door )
//	{
//		ent delete();
//	}
	
//	saw_door  = getent( "saw_door", "script_flag" );
//	saw_door delete();
//	start_bay_runners  = getent( "start_bay_runners", "script_flag" );
//	start_bay_runners delete();
//	start_bay_combat  = getent( "start_bay_combat", "script_flag" );
//	start_bay_combat delete();
	
	// this controls the shakes.
//	cave_shake_volume  = getent( "cave_shake_volume", "targetname" );
//	cave_shake_volume delete();
//	bay_runner_garage_goal_lower = getent( "door_r_bottom", "targetname" ); 
//	bay_runner_garage_goal_lower delete();
//	ai_use_red_cnodes_r9 = getent( "ai_use_red_cnodes_r9", "targetname" ); 
//	ai_use_red_cnodes_r9 delete();	
//	send_allies_through_door  = getent( "send_allies_through_door ", "targetname" ); 
//	send_allies_through_door  delete();		
}
