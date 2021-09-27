#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_stealth_utility;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
#include maps\_nightvision;

spawn_sandman()
{
	setup_sandman();
}


objectives()
{
	flag_wait( "city_reveal" );
	wait( 10.0 );
	offset = ( 0, 0, 35 );
	
	objective_add( obj( "rendezvous" ), "active", &"PRAGUE_OBJ_1" );
	objective_add( obj( "rally" ), "invisible", &"PRAGUE_OBJ_2" );
	objective_add( obj( "fight" ), "invisible", &"PRAGUE_OBJ_3" );
	objective_add( obj( "snipe" ), "invisible", &"PRAGUE_OBJ_4" );
	
	objective_current( obj( "rendezvous" ) );
	if ( isdefined( level.price ) )
		objective_onentity( obj( "rendezvous" ), level.price, offset );
	
	flag_wait( "start_kamarov_scene" );
	wait( 2.0 );
	objective_state( obj( "rendezvous" ), "done" );	
	
	flag_wait( "start_follow_soap_icon" );
	objective_current( obj( "rally" ) );
	objective_onentity( obj( "rally" ), level.sandman, offset );
	
	flag_wait( "pre_courtyard_ally_clean_up" );
	wait( 2.0 );
	objective_state( obj( "rally" ), "done" );
	
	flag_wait( "fire_flare" );
	wait( 6.0 );
	objective_current( obj( "fight" ) );
	objective_onentity( obj( "fight" ), level.sandman, offset );
	
	flag_wait( "church_player_in_main_hall" );
	objective_state( obj( "fight" ), "done" );
	objective_current( obj( "snipe" ) );
	objective_onentity( obj( "snipe" ), level.sandman, offset );
	
	flag_wait( "the_end" );
	objective_state( obj( "snipe" ), "done" );
}

spawn_kamarov()
{
	if ( !isdefined( level.kamarov ) )
		level.kamarov = spawn_targetname( "kamarov" );
}

spawn_price()
{
	level.price = spawn_targetname( "civ_driver" );
	level.price thread setup_price();
}

setup_sandman()
{
	level.sandman = spawn_targetname( "sandman" );
	waittillframeend;
	level.sandman.pushplayer = true;
	level.sandman.ignoreMe = true;
	level.sandman thread magic_bullet_shield();
	level.sandman.animname = "delta";
	level.sandman.goalradius = 64;
	level.sandman.dontavoidplayer = true;
	level.sandman.nododgemove = true;
	level.sandman set_force_color( "r" );
	level.sandman enable_cqbwalk();
	level.sandman disable_surprise();
	level.sandman thread stealth_custom();
	level.sandman thread fail_on_death();
	level.sandman thread remove_bulletshield();
	level.sandman thread sandman_spotted_notify();
	level.sandman SetThreatBiasGroup( "delta" );
	level.sandman.disable_sniper_glint = true;
	level.oldADSrange = getDvarInt( "ai_playerADS_LOSRange", 150 );
	//setSavedDvar( "ai_playerADS_LOSRange", 0 );
}

fail_on_death()
{
	level endon( "missionfailed" );
	level.player endon( "death" );

	self waittill( "death", other );

	radio_dialogue_stop();

	quote = undefined;

	if ( IsPlayer( other ) )
		//Friendly fire will not be tolerated.
		quote = &"PRAGUE_FRIENDLY_FIRE_WILL_NOT";
	else
		//Your actions got Sandman killed.
		quote = &"PRAGUE_YOUR_ACTIONS_GOT_CPT";

	SetDvar( "ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();
}

i_can_kill_sandman()
{
	self endon( "death" );
	level.sandman endon( "death" );
	level.sandman endon( "remove_bulletshield" );

	flag_wait( "_stealth_spotted" );
	level.sandman notify( "remove_bulletshield" );
}

remove_bulletshield()
{
	self endon( "death" );
	self waittill( "remove_bulletshield" );
	wait( 15.0 );
	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self stop_magic_bullet_shield();
		wait( 5.0 );
		if ( IsAlive( self ) )
		{
			self StopAnimScripted();
			self Kill();
		}
	}
}

setup_kamarov()
{
	level.kamarov = self;
	self.pushable = false;
	self.pushplayer = true;
	self Pushplayer( true );
	self.goalradius = 8;
	self.ignoreme = true;
	self.animname = "kamarov";
	self thread deletable_magic_bullet_shield();
	self.disable_sniper_glint = true;
}

setup_price()
{
	level.price = self;
	self.pushable = false;
	self.goalradius = 8;
	self.ignoreme = true;
	self.animname = "price";
	self thread deletable_magic_bullet_shield();	
	self.disable_sniper_glint = true;
	self pushplayer( true );
	self.pushplayer = true;
}

set_start_positions( targetname )
{
	thread force_flash_setup();
	
	start_positions = getstructarray( targetname, "targetname" );
	foreach ( pos in start_positions )
	{
		switch ( pos.script_noteworthy )
		{
			case "player":
				level.player SetOrigin( pos.origin );
				level.player SetPlayerAngles( pos.angles );
			break;
			case "sandman":
				level.sandman ForceTeleport( pos.origin, pos.angles );
				level.sandman SetGoalPos( pos.origin );
			break;
			case "kamarov":
				level.kamarov ForceTeleport( pos.origin, pos.angles );
				level.kamarov SetGoalPos( pos.origin );
			break;
			case "price":
				level.price ForceTeleport( pos.origin, pos.angles );
				level.price SetGoalPos( pos.origin );
			break;
		}
	}
}

sewer_gate()
{
	gate = get_target_ent( "sewer_gate" );
	gate NotSolid();
	gate Hide();
	gate ConnectPaths();
	
	flag_wait( "spawn_alcove_guys" );
	flag_wait( "sandman_past_sewer_gate" );
	trigger_wait( "player_at_sewer_exit", "script_noteworthy" );
	gate Solid();
	gate Show();
	gate DisconnectPaths();
}

kamarov_scene()
{
	node = get_target_ent( "sewer_resistance_flare_node" );
	
	/* kamarov_node = get_target_ent( "sewer_kamarov_node" );
	level.kamarov ForceTeleport( kamarov_node.origin, kamarov_node.angles );
	level.kamarov SetGoalPos( kamarov_node.origin ); */
		
	disable_trigger_with_targetname( "exit_the_water" );
	level.kamarov_guys = array_spawn_targetname( "sewer_resistance_backup" );
	guys = level.kamarov_guys;
	foreach ( g in guys )
	{
		g.animname = g.script_noteworthy;
		node thread anim_loop_solo( g, "sewer_get_out_idle" );
		g thread set_generic_idle_forever( "unarmed_idle" );
		g set_generic_run_anim( "unarmed_walk" );
		g.disableArrivals = true;
		g.disableExits = true;
		g forceUseWeapon( level.sandman.weapon, "primary" );
		g.Pushable = false;
	}
	
	level.kamarov attach( "mil_emergency_flare", "tag_inhand", true );
	
	level.price gun_remove();
	level.sandman gun_remove();
	
	trigger_wait_targetname( "start_meet" );

	array_thread( guys, ::delete_on_notify, "spawn_alcove_guys" );
	
	level.price notify( "stop_path" );
	level.sandman notify( "stop_path" );
	node thread anim_reach( [ level.price, level.sandman ], "sewer_get_out" );
	
	level.kamarov.animname = "kamarov";
	level.kamarov delaythread( 0.6, ::anim_single_solo, level.kamarov, "prague_kmv_whattookyou" );
	level.kamarov thread sewer_flare_pop();
	
	level waittill( "player_got_up" );
	
	thread group_flavorbursts( level.drones[ "allies" ].array, "cz", 20, 27, false, "spawn_alcove_guys" );
	
	level endon( "sandman_stop_look_convoy" );
	wait( 0.7 );
	//Soap: You're intel was off, Kamarov.  You said this area would be clear.
	level.sandman anim_single_solo( level.sandman, "prague_mct_intelwasoff" );
	//Kamarov: I'm sure it was nothing you couldn't handle.
	//level.kamarov anim_single_solo( level.kamarov, "prague_kmv_uprising" );	
	wait( 2.8 );
	//Kamarov: Do you know what had to be done to get you this far?
	level.kamarov dialogue_queue( "prague_kmv_thisfar" );	
	//Price: Enough chit-chat.  Soap, Yuri - best get on your way.  We'll meet you at the rally point.
	level.price anim_single_solo( level.price, "prague_pri_chitchat" );
	wait( 0.4 );
	
	flag_set( "start_follow_soap_icon" );
	
	thread sewer_soap_nag();
	
	flag_wait( "start_follow_soap" );
	level.sandman.moveplaybackrate = 1;
	level.sandman disable_cqbwalk();
	level.sandman thread follow_path_waitforplayer( get_target_ent( "soap_sewer_3" ) );
	level.price.pushable = 0;
	level.kamarov.pushable = 0;
	
	level.sandman.goalradius = 128;
	level.sandman allowedStances( "stand", "crouch", "prone" );
	
}

sewer_soap_nag()
{
	level endon( "start_follow_soap" );
	
	while ( !flag( "start_follow_soap" ) )
	{
		//Soap: Let's go, Yuri.
		level.sandman thread dialogue_queue( "prague_mct_letsgoyuri" );
		wait( 9 );
		level.sandman thread anim_generic( level.sandman, "signal_moveout" );
	}
}

dustfall()
{
	level endon( "start_alcove" );
	
	trigger = get_Target_ent( "dustfall_trigger" );
	
	dust_src = getstructarray_delete( "dustfall_src", "targetname" );
	
	while( 1 )
	{
		trigger waittill( "trigger" );
		org = random( dust_src );
		PlayFX( getfx( "ceiling_dust_default" ), org.origin + ( RandomFloatRange(0,10), RandomFloatRange(0,10), 0 ) );
		wait( RandomFloatRange( 0.3, 0.4 ) );
	}
}

sewer_flare_pop()
{
	self endon( "death" );
	self gun_remove();
	
	node = get_target_ent( "sewer_resistance_flare_node" );
	node thread anim_single_solo( self, "flare_pop" );
	
	while( self getanimtime( self getanim( "flare_pop" ) ) < 0.32 )
		wait( 0.05 );
	
	playfxontag( getfx( "flare_ambient" ), self, "tag_fire_fx" );
	level notify( "sewer_popped" );
	lights_flick = getentarray( "sewer_flare_primary", "script_noteworthy" );
	array_thread ( lights_flick, ::flare_light );	
	
	thread play_sound_in_space( "scn_prague_flare_ignite", node.origin );	
//	thread play_loopsound_in_space( "scn_prague_flare_burn_loop", node.origin );

	level.price thread sewer_price_think();
	wait( 2 );
	level.sandman thread sewer_soap_think();

	node waittill( "flare_pop" );
	node thread anim_loop_solo( self, "sewer_get_out_idle" );
	enable_trigger_with_targetname( "exit_the_water" );
	trigger_wait_targetname( "exit_the_water" );
	level notify( "player_got_up" );
	
	player_rig = get_player_rig();
//	level.player_legs = spawn_anim_model( "player_legs" );
	level.player DisableWeapons();
	level.player TakeAllWeapons();
//	level.player_legs Hide();
	blend_player_to_arms( 0.2 );
	level.player_rig Hide();
	delayThread( 0.2, ::link_player_to_arms, 10, 10, 10, 10 );
	
	level.kamarov thread sewer_kamarov_think();
	
	node notify( "stop_loop" );	
	level.sandman notify( "start_sewer_getout" );
	level.price notify( "start_sewer_getout" );
	node anim_single( [ level.kamarov, player_rig ], "sewer_get_out" );
}

sewer_kamarov_think()
{
	self endon( "death" );
	self disable_cqbwalk();
	self.disableArrivals = true;
	self.disableExits = true;
	self set_generic_run_anim( "flare_walk" );
	self.moveplaybackrate = 3;
//	self thread set_generic_idle_forever( "flare_idle" );
	node = get_target_ent( "sewer_kamarov_path" );
	delayThread( 10, ::kill_entrance_flare );
	self follow_path_waitforplayer( node, 0 );
	lastnode = get_Target_ent( "kamarov_path_end" );
	lastnode anim_generic_reach( self, "prague_sewer_turnaround_kamarov" );
	lastnode anim_generic( self, "prague_sewer_turnaround_kamarov" );
	lastnode anim_generic_loop( self, "flare_idle" ); 
}

stay_after_anim( node )
{
	node waittill( "sewer_get_out" );
	self setGoalPos( self.origin );
}

sewer_price_think()
{
	self endon( "start_sewer_getout" );
	node = get_target_ent( "sewer_resistance_flare_node" );
	helper = undefined;
	foreach ( guy in level.kamarov_guys )
	{
		if ( guy.animname == "pricehelper" )
		{
			helper = guy;
			break;
		}
	}
	self thread sewer_price_think2( node, helper );
	node anim_reach_solo( self, "sewer_get_out" );
	node thread anim_single( [helper, self], "sewer_get_out" );
	delayThread( 2, maps\_fx::script_PlayFXOnTag, getfx( "water_emerge" ), self, "J_Neck" );
	helper thread stay_after_anim( node );
	self disable_cqbwalk();
	self maps\prague_new_intro::disable_ai_swim();
	while ( self getAnimTime( self getanim( "sewer_get_out" ) ) < 0.66 )
		wait( 0.05 );
	
	node = get_target_ent( "price_sewer_1" );
	self setGoalNode( node );
	self anim_generic_run( self, "readystand_trans_2_run_2" );
	self.noneedtoteleport = true;
	self notify( "start_sewer_getout" );
}

sewer_price_think2( node, helper )
{
	self waittill( "start_sewer_getout" );

	self.moveplaybackrate = 0.6;

	if ( !isdefined( self.noneedtoteleport ) )
	{
		self StopAnimScripted();
		self maps\prague_new_intro::disable_ai_swim();
		wait( 0.6 );
		node = get_target_ent( "price_sewer_1" );
		self ForceTeleport( node.origin, node.angles );
		self setGoalNode( node );
		self gun_recall();
	}
	flag_wait( "player_out_of_water" );
	wait( 1.5 );
	self setGoalNode( get_target_ent( "price_sewer_2" ) );
	self waittill( "goal" );
	wait( 1 );
	self disable_cqbwalk();
}

sewer_soap_think()
{
	self endon( "start_sewer_getout" );
	node = get_target_ent( "sewer_resistance_flare_node" );
	helper = undefined;
	foreach ( guy in level.kamarov_guys )
	{
		if ( guy.animname == "soaphelper" )
		{
			helper = guy;
			break;
		}
	}
	self thread sewer_soap_think2( node, helper );
	node anim_reach_solo( self, "sewer_get_out" );
	node thread anim_single( [helper, self], "sewer_get_out" );
	delayThread( 2, maps\_fx::script_PlayFXOnTag, getfx( "water_emerge" ), self, "J_Neck" );
	helper thread stay_after_anim( node );
	while ( self getAnimTime( self getanim( "sewer_get_out" ) ) < 0.68 )
		wait( 0.05 );
	self maps\prague_new_intro::disable_ai_swim();
	node = get_target_ent( "soap_sewer_1" );
	self setGoalNode( node );
	self disable_cqbwalk();
	self anim_generic_run( self, "readystand_trans_2_run_2" );
	self.noneedtoteleport = true;
	self notify( "start_sewer_getout" );
}

sewer_soap_think2( node, helper )
{
	self waittill( "start_sewer_getout" );

	self.moveplaybackrate = 0.6;

	if ( !isdefined( self.noneedtoteleport ) )
	{
		self StopAnimScripted();
		self maps\prague_new_intro::disable_ai_swim();
		wait( 0.6 );
		node = get_target_ent( "soap_sewer_1" );
		self ForceTeleport( node.origin, node.angles );
		self setGoalNode( node ); 
		self gun_recall();
	}
	flag_wait( "player_out_of_water" );
	wait( 1 );
	self setGoalNode( get_target_ent( "soap_sewer_2" ) );
}

kill_entrance_flare()
{
	light = get_target_ent( "entrance_flare_primary" );
	light notify( "stop_flicker" );
	light notify( "stop_movement" );
	while ( light getLightIntensity() > 0 )
	{
		light setLightIntensity( max( light getLightIntensity() - 0.1, 0 ) );
		wait( 0.1 );
	}
	light setLightColor( ( .9, .95, 1 ) );
	while ( light getLightIntensity() < 0.4 )
	{
		light setLightIntensity( light getLightIntensity() + 0.1 );
		wait( 0.15 );
	}
}

flare_light()
{
	self setLightintensity( 1 );	
	thread flickering_light( self, 1.0, 1.25 );
	thread moving_light( self, 4 );
}

enable_sewer_walk()
{
	self set_generic_run_anim( "active_patrolwalk_gundown" );
	self thread set_generic_idle_forever( "casual_stand_idle" );
	self.disableExits = true;
	self.disableArrivals = true;
	self.moveplaybackrate = 1.2;
}

disable_sewer_walk()
{
	self clear_run_anim();
	self clear_generic_idle_anim();
	self notify( "clear_idle_anim" );
	self.disableExits = false;
	self.disableArrivals = false;
	self.moveplaybackrate = 1;
}

murder_scene()
{
	thread sewer_runners();
	thread sewer_draggers();
}

sewer_draggers()
{
	flag_wait( "start_sewer_drag" );
	drag_group = array_spawn_targetname( "sewer_drag" );
	foreach ( guy in drag_group )
	{
		if ( guy.team == "allies" )
		{
			guy gun_remove();
			guy.animname = "victim";
		}
		else
		{
			guy.animname = "enemy";
		}
		
		guy thread drag_think();
	}
}

drag_think()
{
	self endon( "death" );
	node = self get_target_ent();
	anime = node.script_animation;
	node thread anim_first_frame_solo( self, anime );
	node script_delay();
	node notify( "stop_first_frame" );
	node anim_single_solo( self, anime );
	if ( self.team == "allies" )
	{
		self.noragdoll = true;
		node anim_single_solo( self, anime + "_kill" );
	}
	else
	{
		node anim_single_solo( self, anime + "_kill" );
		self delete();
	}
		
}

sewer_runners()
{
	thread sewer_killers();
	level endon( "stop_sewer_runners" );
	trigger_wait_targetname( "sewer_runner_trigger" );
	level endon( "level_cleanup" );
	while( 1 )
	{
		guys = array_spawn_targetname( "sewer_civ_runner" );
		foreach ( guy in guys )
		{
			guy gun_remove();
			guy thread drone_assign_unique_death();
			guy.runAnim = level.civ_runs[ RandomIntRange( 0, level.civ_runs.size ) ];
		}
		wait( RandomFloatRange( 1.9, 2.5 ) );
	}
}

sewer_killers()
{
	trigger_wait_targetname( "sewer_killer_trigger" );
//	level notify( "stop_sewer_runners" );
	wait( 1.0 );
	drones = array_spawn_targetname( "sewer_killers" );
	array_thread( drones, ::sewer_killer_think );
	flag_set( "start_sewer_drag" );
}

sewer_killer_think()
{	
	self endon( "death" );
	self thread delete_on_notify();
	wait( RandomFloatRange(0, 2) );
	self notify( "move" );
	drone = self;
//	thread play_sound_in_space( "RU_0_stealth_alert" );
	drone_give_weaponsound( drone );
	
	drone waittill( "goal" );
	drone thread maps\_drone::drone_play_looping_anim( level.drone_anims[ "axis" ][ "coverstand" ][ "fire" ], 1 );
	wait( 0.1 );
	times = RandomIntRange( 3, 5 );
	times = 99;
	for ( i=0; i<times; i++ )
	{
		if ( cointoss() )
		{
			drone maps\_drone::drone_shoot();
		}
		else
		{
			drone drone_burst_fire();
		}
		
		/*
		if ( cointoss() )
		{
			forward = AnglesToForward( drone.angles );
			org = drone.origin + forward*256 + (RandomFloatRange(-64,64), RandomFloatRange(-64,64), 0);
			thread play_sound_in_space( "generic_death_falling_scream", org );
		}
		*/
			
		wait( RandomFloatRange(1,2) );
	}
	drone.target = "sewer_runner_runout";
	drone.script_noteworthy = "delete_on_goal";
	drone.runAnim = getgenericanim( "active_patrolwalk_gundown" );
	wait( RandomFloatRange( 1, 2 ) );
	thread play_sound_in_space( "stealth_0_hmph" );
	drone thread maps\_drone::drone_move();
}

drone_resistance_fight( node )
{
	self endon( "death" );
	
	if ( issubstr( node.animation, "_l" ) && !issubstr( node.animation, "_l2r" ) )
		side = "_l";
	else
		side = "_r";
		
	anims = [
	"prague_resistance_cover_idle_once",
	"prague_resistance_cover_shoot" ];
	
	num = RandomIntRange( 0, anims.size );
	node thread anim_generic_loop( self, "prague_resistance_cover_idle" + side );
	if ( isdefined( node.script_flag_wait ) )
		flag_wait( node.script_flag_wait );
	node script_delay();
	node notify( "stop_loop" );
	while( 1 )
	{
		node anim_generic( self, anims[ num ] + side );
		num = num + 1;
		num = num % anims.size;
	}
}

drone_burst_fire()
{
	self maps\_drone::drone_shoot();
	wait( randomfloatrange( .1, .15 ) );
	self maps\_drone::drone_shoot();
	wait( randomfloatrange( .1, .15 ) );
	self maps\_drone::drone_shoot();
	wait( randomfloatrange( .1, .15 ) );
	self maps\_drone::drone_shoot();
	wait( randomfloatrange( .1, .15 ) );
}

#using_animtree( "script_model" );

sandman_stop_look_convoy()
{
	flag_wait( "sandman_stop_look_convoy" );
	music_play( "prague_tension_2", 3 );	

	node = get_target_ent( "sandman_exit_sewer_path" );

	level.sandman disable_cqbwalk();
	level.sandman disable_sewer_walk();
	level.sandman disable_ai_color();
	
	level.sandman thread follow_path_waitforplayer( node );
	level.sandman.goalradius = 128;
	level.sandman pushplayer( true );
	
	radio_dialogue_stop();
	
	level.sandman waittill( "path_end_reached" );
	level.sandman.goalradius = 64;
}

sandman_knife_kill()
{	
	flag_wait( "start_alcove" );
	node = get_target_ent( "alcove_cornerR" );
	level.sandman.ignoreall = true;
	level.sandman notify( "stop_path" );
	level.sandman setGoalNode( node );
	level.sandman waittill( "goal" );
	wait( 1.5 );
	flag_wait( "sandman_knife_trigger" );
	
	thread alcove_scene_dialogue();
	flag_set( "alley_lights_out" );
	node = node get_target_ent();
	level.sandman disable_cqbwalk();
	node anim_generic_reach( level.sandman, "signal_enemy_coverR" );
	node anim_generic( level.sandman, "signal_enemy_coverR" );
}

alcove_scene()
{
	level endon( "alley_move_up" );	
	flag_wait( "spawn_alcove_guys" );
	
	anim.notetracks[ "gun_2_chest" ] = animscripts\notetracks::noteTrackGunToChest;
	
	patrol = array_spawn_Targetname( "alcove_patrol" );
	snipers = array_spawn_Targetname( "alcove_snipers" );
	s = get_target_ent( "carrot" );
	array_thread( patrol, ::alcove_guys_think );
	
	thread alcove_snipers( snipers );
	thread alcove_dog_patrol();
	
	flag_wait( "alcove_snipers_dead" );
	flag_wait( "alcove_dog_dead" );
	volume_waittill_no_axis( "alcove_volume" );
	waittill_no_suspicious_enemies();
	flag_waitopen( "_stealth_spotted" );
	flag_set( "alley_move_up" );
	flag_set( "sandman_killfirms" );
}

alcove_guys_think()
{
	level endon( "_stealth_spotted" );
	self endon( "death" );
	self thread alcove_guys_react();
	if ( cointoss() )
		self thread set_generic_idle_forever( "patrol_idle_" + RandomIntRange( 1, 7 ) );
	self.combatmode = "no_cover";
	self set_generic_run_anim( "patrol_walk" );
	flag_wait( "alcove_guys_leave" );
	wait( 1.0 );
	self set_generic_run_anim( "active_patrolwalk_gundown" );
	flag_wait( "start_alley" );
	self set_generic_run_anim( "patrol_walk" );
}

alcove_guys_react()
{
	self endon( "death" );
	flag_wait( "_stealth_spotted" );
	self.combatmode = "cover";
}

alcove_sniper_sight()
{
	level endon( "alcove_snipers_dead" );
	volume = get_target_ent( "alcove_volume" );
	while( 1 )
	{
		corpses = GetCorpseArray();
		foreach ( corpse in corpses )
		{
			if ( !IsSubStr( corpse.classname, "civilian" ) )
			{
				if ( corpse IsTouching( volume ) )
				{
					flag_set( "_stealth_spotted" );
					return;
				}
			}	
		}
		wait( 0.2 );
	}
}

alcove_dog_patrol()
{
	dog = spawn_targetname( "dog_eater" );
	node = get_target_ent( "dog_eat" );
	dog.script_noteworthy = "dog_walker_dog";
	dog endon( "death" );
	dog thread flag_on_death( "alcove_dog_dead" );
	
	node thread anim_generic_loop( dog, "eat" );
	node thread interrupt_anim_on_alert_or_damage( dog );
/*	
	flag_wait( "alcove_snipers_dead" );
	wait( 1.0 );
	vec = level.sandman.origin - node.origin;
	node.angles = VectorToAngles( vec );
	node notify( "stop_loop" );
	node anim_generic( dog, "german_shepherd_attackidle_once" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_growl" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	node anim_generic( dog, "german_shepherd_attackidle_bark" );
	node thread anim_generic_run( dog, "german_shepherd_run_start" );
	delayThread( 2.0, ::flag_set, "_stealth_spotted" );
	dog maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( level.player.origin );
*/
	flag_wait( "_stealth_spotted" );	
	dog.goalradius = 96;
	dog setGoalEntity( level.player );
}

alcove_snipers( snipers )
{
	foreach( s in snipers )
	{
		PlayFxOnTag( getfx( "flashlight" ), s, "TAG_FLASH" );
		s thread remove_ignoreme_on_spotted();
		s thread attack_player_on_spotted();
		waittillframeend;
		s notify( "awake" );
	}
	
	killfirm = true;
	
	while( 1 )
	{
		snipers = array_removedead( snipers );
		if ( snipers.size == 1 && killfirm && !flag( "_stealth_spotted" ) )
		{
			level.last_nag_time = GetTime();
			radio_dialogue_stop();
			delayThread( RandomFloatRange( 1,2 ), ::array_spawn_targetname, "alcove_heli_post" );
			level notify( "player_killed_sniper" );
			thread radio_dialogue( "prague_mct_taketheother" );
			killfirm = false;
			level.last_nag_time = GetTime();
		}
		if ( snipers.size == 0 )
			break;
		wait( 0.1 );
	}
	flag_set( "alcove_snipers_dead" );
	disable_trigger_with_targetname( "alcove_sniper_spotted_trigger" );
}

alcove_sniper_nag()
{
	level endon( "alcove_snipers_dead" );
	level endon( "_stealth_spotted" );
	level endon( "player_killed_sniper" );
	
	wait( 5.0 );
	
	level.last_nag_time = GetTime();
	while( 1 )
	{
		wait( 8.0 );
		if ( GetTime() - level.last_nag_time >= 8000 )
		{
			radio_dialogue( "prague_mct_snipersrooftop" );
			wait( 8.0 );
			level.last_nag_time = GetTime();
		}
	}
}

alcove_sniper_hint()
{
	level endon( "_stealth_spotted" );
	level endon( "alcove_snipers_dead" );
	node = get_target_ent( "looking_at_dog" );
	
	wait( 4.0 );
	
	while( 1 )
	{
		if ( level.player player_looking_at( node.origin, 0.99, true ) )
		{
			if ( level.player ADSButtonPressed() )
			{
				level.last_nag_time = GetTime();
				radio_dialogue( "prague_stop_4" );
				radio_dialogue( "prague_mct_rooftopfirst" );
				wait( 10.0 );
			}
		}
		wait( 0.5 );
	}
}

alcove_scene_dialogue()
{
	level endon( "alley_move_up" );
	level endon( "_stealth_spotted" );
	flag_wait( "alley_lights_out" );
	wait( 0.1 );
	radio_dialogue_stop();

	//Soap: Hold up.  Got contacts - twenty meters ahead.
	level.sandman dialogue_queue( "prague_snd_holdup2targets" );
	//Soap: Stay low, and keep to the shadows.  We don't want to attract any attention.
	thread radio_dialogue( "prague_snd_staylow" );
	level.sandman thread anim_generic( level.sandman, "corner_standR_trans_OUT_8" );
	level.sandman disable_cqbwalk();
	level.sandman allowedStances( "crouch", "prone" );
	level.sandman setGoalNode( get_target_ent( "alcove_prone" ) );	
	level.sandman thread prone_on_goal( "alley_move_up" );
	
	flag_wait( "spawn_alcove_guys" );
	wait( 2.0 );
	level.sandman waittill_notify_or_timeout( "goal", 5 );

	level.sandman.goalradius = 64;
	level.sandman PushPlayer( true );
	
	if ( getdifficulty() == "easy" )
	{
		thread display_hint_timeout( "hint_prone", 5 );
	}
	
	//Soap: Five guys, snipers on the roof, and a bloody german shepherd.
	if ( !flag( "alcove_snipers_dead" ) )
	{
		radio_dialogue( "prague_mct_fiveguys" );
		wait( 0.5 );
	}
	//Soap: Sit tight.  We'll see what they do.
	radio_dialogue( "prague_mct_sittight" );
	flag_set( "alcove_guys_leave" );
	wait( 2.0 );
	//Soap: They're splitting up.  Must be our lucky day.
	radio_dialogue( "prague_mct_splittingup" );
	wait( 2.5 );

	flag_clear( "sandman_killfirms" );

	alcove_snipers_dialogue();
	volume_waittill_no_axis( "alcove_platform_volume" );
	flag_wait( "alcove_snipers_dead" );
	
	level.sandman.ignoreall = false;
	
	//level.sandman thread animscripts\corner::stepOutAndShootEnemy();
	//level.sandman thread animscripts\corner::StartAiming( undefined, false, .3 );
	if ( !flag( "alcove_dog_dead" ) )
	{
		guy = get_living_ai( "dog_walker", "script_noteworthy" );
		dog = get_living_ai( "dog_walker_dog", "script_noteworthy" );
		level.sandman.favoriteenemy = guy;
		radio_dialogue( "prague_mct_dogandfriend" );
//		level.sandman anim_generic( level.sandman, "CornerCrR_alert_2_lean" );
		
		level.paired_death_max_distance = 1024;
		
		if ( isDefined( dog ) )
			dog thread paired_death_think();
		
		if ( isDefined( guy ) )
		{
			guy thread paired_death_think();
			waitframe();
			level.sandman stealth_shot( guy );
		}
		else if ( isDefined( dog ) )
		{
			level.sandman stealth_shot( dog );
		}
		
		flag_wait( "alcove_dog_dead" );
		
		level.paired_death_max_distance = 512;
	}
	
	flag_set( "sandman_killfirms" );
}

alcove_snipers_dialogue()
{
	level endon( "player_killed_sniper" );
	level endon( "alcove_snipers_dead" );
	if ( !flag( "alcove_snipers_dead" ) )
	{
		thread alcove_sniper_nag();
		thread alcove_sniper_hint();
		radio_dialogue( "prague_mct_snipersfirst" );
		wait( 0.5 );
		thread radio_dialogue( "prague_mct_alertothers" );
		flag_wait( "alcove_snipers_dead" );
	}
}

street_convoy_spawn()
{
	level endon( "_stealth_spotted" );
	flag_wait( "alcove_moved_up" );
	array_spawn_targetname( "street_convoy" );
}

alcove_backup()
{
	level endon( "alley_move_up" );
	flag_wait( "_stealth_spotted" );
	guys = array_spawn_targetname( "alcove_backup_guys" );
	wait( 0.5 );
	guys = array_removedead( guys );
	guys = array_removeundefined( guys );
	foreach ( g in guys )
	{
		g.goalradius = 300;
		g getEnemyInfo( level.player );
		g setGoalEntity( level.player );
	}
}

alley_move_up()
{
	level endon( "start_alley" );
	flag_wait( "alley_move_up" );
	flag_waitopen( "_stealth_spotted" );
	level endon( "_stealth_spotted" );
	autosave_stealth();
	paired_death_restart();
	thread sandman_end_encounter( "prague_mct_hidebodies" );
	if ( level.sandman.a.pose == "prone" )
		level.sandman anim_generic( level.sandman, "prone_2_stand" );
	level.sandman AllowedStances( "stand", "crouch", "prone" );
	
	flag_set( "alcove_moved_up" );
	
//	radio_dialogue_stop();
	level.sandman StopAnimScripted();

	disable_trigger_with_noteworthy( "alcove_death_trigger" );
	enable_trigger_with_targetname( "flag_alley_trigger" );

	level.sandman disable_cqbwalk();
	level.sandman notify( "stop_loop" );
	level.sandman.ignoreAll = true;
	level.sandman.goalradius = 128;
	
	volume = get_Target_ent( "alley_hostage_volume" );
	empty = volume_is_empty( volume );
	
	if ( !empty )
	{
		delaythread( 3.5, ::radio_dialogue, "prague_snd_holdup" );
	}
	
	level.sandman follow_path_waitforplayer( get_target_ent( "sandman_moves_up" ), 512 );
	level.sandman.goalradius = 64;
	wait( 1.5 );
	/*trigger_wait_targetname( "sandman_signal_stop" );
//	level.sandman thread anim_generic( level.sandman, "signal_stop_coverR" );
	radio_dialogue( "prague_mct_staydown" );
	*/
}

check_dead_bodies_think()
{
	self notify( "stop_corpse_search" );
	if ( !IsDefined( self.script_noteworthy ) )
	{
		self set_generic_run_anim( "bully_walk" );
		self.goalradius = 64;
		self endon( "death" );
		level endon( "_stealth_spotted" );
		self endon( "_stealth_bad_event_listener" );
		node = self get_target_ent();
		
		node anim_generic_reach( self, node.animation );
		node anim_generic( self, node.animation );
		
		self.target = node.target;
		self thread maps\_patrol::patrol();
		
		flag_wait( "alley_sandman_in_position" );
		self thread paired_death_think();
	}
	else if ( self.script_noteworthy == "alley_snipers" )
	{
		self thread teleport_on_spotted();
	}
	else if ( self.script_noteworthy == "passerby" )
	{
		self delayThread( 1.0, ::set_generic_run_anim, self.animation );
	}
	if ( self.type == "dog" )
	{
		self thread anim_generic_loop( self, "german_shepherd_attackidle" );
		self thread interrupt_anim_on_alert_or_damage( self );
	}	
}

set_spotted_on_bad_event()
{
	self endon( "death" );
	self thread set_spotted_on_not_normal();
	self ent_flag_wait( "_stealth_bad_event_listener" );
	wait( 0.5 );
	flag_set( "_stealth_spotted" );
}

set_spotted_on_not_normal()
{
	self endon( "death" );
	self ent_flag_waitopen( "_stealth_normal" );
	wait( 0.5 );
	flag_set( "_stealth_spotted" );
}

teleport_on_spotted()
{
	self endon( "death" );
	/* self removeAIEventListener( "projectile_impact" );
	thread set_spotted_on_bad_event(); */
	flag_wait( "_stealth_spotted" );
	self.accuracy = 0.9;
	wait( 5.0 );
	while( 1 )
	{
		if ( SightTracePassed( self GetEye(), level.player GetEye(), false, self ) )
		{
			wait( 5 );
		}
		else 
			break;
	}

	while( 1 )
	{
		org = self GetEye();

		if ( player_looking_at( org, 0.8, true ) )
			wait( 0.05 );
		else
			break;
	}
	
	nodes = getstructarray( "alley_teleport_node", "targetname" );
	nodes = SortByDistance( nodes, level.player.origin );
	
	teleported = false;
	
	foreach ( n in nodes )
	{
		if ( Distance2d( level.player.origin, n.origin ) < 256 || SightTracePassed( level.player GetEye(), n.origin, false, self ) )
		{
			wait( 0.1 );
			continue;
		}
		
		self Teleport( n.origin, self.angles );
		waittillframeend;
		
		if ( Distance2d( self.origin, n.origin ) < 64 )
		{
			teleported = true;
			break;
		}
	}
	
	if ( teleported )
	{	
		self.favoriteenemy = level.player;
		self.goalradius = 256;
		self setGoalEntity( level.player );
	}
	else
		self delete();
}

helicopter_ai_mode( eTarget )
{
	self endon( "death" );

	for ( ;; )
	{
		MagicBullet( "pecheneg", self.fx_ent.origin, level.player GetEye() );
		wait( RandomFloatRange( 0.05, 0.2 ) );
	}
}

alley_blocker()
{
	btrs = spawn_vehicles_from_targetname( "alley_btr_blocker" );
	array_thread( btrs, ::btr_attack_player_on_spotted );
	array_thread( btrs, ::delete_on_notify );
	flag_wait( "start_alley" );
	wait( 0.1 );
	foreach ( b in btrs )
		b notify( "awake" );
		
	trigger_wait_targetname( "alley_blocker_trigger" );
	
	level.sandman notify( "remove_bulletshield" );
}

foot_patrol_incoming()
{
	flag_wait( "start_alley" );
	flag_waitopen( "_stealth_spotted" );
	level endon( "_stealth_spotted" );
	level endon( "start_long_convoy" );
	autosave_stealth();
	wait( 1.0 );
	
	thread foot_patrol_backup();	
	thread sandman_spot_foot_patrol();
	
	level.sandman.moveplaybackrate = 1.0;
	level.sandman.goalradius = 8;
	level.sandman disable_ai_color();
	level.sandman disable_cqbwalk();
	level.sandman AllowedStances( "crouch", "prone" );
	volume = get_Target_ent( "alley_hostage_volume" );
	empty = volume_is_empty( volume );
	
	if ( !empty )
	{
		node = GetNode( "sandman_crossover_0", "targetname" );
	}
	else
	{
		node = GetNode( "sandman_crossover_1", "targetname" );
	
		drones = level.drones[ "neutral" ].array;
		foreach ( d in drones )
		{
			if ( d isTouching( volume ) )
				d delete();
		}
	
	}
	wait( 0.5 );
	level.sandman allowedStances( "stand", "crouch", "prone" );	
	level.sandman.ignoreAll = true;
	level.sandman SetGoalNode( node );
	level.sandman waittill( "goal" );
	childthread dog_growl();

	if ( !empty )
	{
		wait( 1.0 );
		radio_dialogue( "prague_mct_lockingdown" );
	}
	radio_dialogue( "prague_mct_followme" );

	flag_set( "alley_sandman_in_position" );
	
	level.sandman.ignoreAll = true;
	level.sandman.goalradius = 64;
	level.sandman disable_cqbwalk();
	if ( !empty )
	{
		level.sandman thread follow_path_waitforplayer( get_Target_ent( "sandman_crossover_2" ), 200 );
	}
	else
	{
		level.sandman thread follow_path_waitforplayer( get_Target_ent( "sandman_crossover_2" ), 300 );
	}
	node = get_Target_ent( "sandman_crossover_2" );
	node waittill( "trigger" );
	level.sandman enable_cqbwalk();
	level.sandman.ignoreAll = false;
	
	//level.sandman.ignoreAll = false;
}

dog_growl()
{
	dog = undefined;
	ai = get_living_ai_array( "patrollers", "script_noteworthy" );
	foreach( a in ai )
	{
		if ( a.classname == "actor_enemy_dog" )
			dog = a;
	}
	if ( isdefined( dog ) )
	{
		dog delaythread( RandomFloatRange( 0, 1 ), ::anim_generic, dog, "german_shepherd_attackidle_growl" );
		dog waittill( "german_shepherd_attackidle_growl" );
		dog delaythread( RandomFloatRange( 1, 3 ), ::anim_generic, dog, "german_shepherd_attackidle_bark" );
		dog waittill( "german_shepherd_attackidle_bark" );
		dog delaythread( RandomFloatRange( 1, 3 ), ::anim_generic, dog, "german_shepherd_attackidle_bark" );
	}
}

foot_patrol_dead()
{	
	flag_clear( "sandman_killfirms" );
	volume_waittill_no_axis( "alley_volume" );
	waittill_no_suspicious_enemies();
	level.sandman.ignoreAll = true;
	flag_set( "foot_patrol_dead" );
}

foot_patrol_backup()
{
	level endon( "start_long_convoy" );
	flag_wait( "_stealth_spotted" );
	backup = array_spawn_targetname( "foot_patrol_backup" );
	foreach ( b in backup )
	{
		b.goalradius = 1024;
		b SetGoalPos( level.player.origin );
	}
	flag_waitopen( "_stealth_spotted" );
	sandman_end_encounter( "prague_clear_3" );
	flag_set( "alley_sandman_in_position" );
	flag_set( "alley_sniper_dead" );
	flag_set( "alley_heli_left" );
	disable_trigger_with_noteworthy( "alley_heli_failsafe_trigger" );
	flag_set( "start_long_convoy" );
}

sandman_spot_foot_patrol()
{
	level endon( "_stealth_spotted" );
	level endon( "start_long_convoy" );
	level endon( "foot_patrol_dead" );
	
	flag_wait( "alley_2_sandman_move_up" );
	thread foot_patrol_dead_move();

	level.alley_patrol_guys = array_spawn_targetname( "alley_patrol" );
	guys = level.alley_patrol_guys;
	foreach ( g in guys )
	{
		g.grenadeammo = 0;
		g.ignoreMe = false;
	}
	array_thread( guys, ::active_patrol );
	array_thread( guys, ::paired_death_think );
	
	thread foot_patrol_dead();
	
	wait( 3.0 );
	
	if ( !flag( "foot_patrol_dead" ) )
	{
		level.sandman.ignoreall = false;
		radio_dialogue( "prague_mct_12oclock" );
		wait( 0.5 );
		radio_dialogue( "prague_mct_yougetone" );
		wait( 1.0 );
		thread radio_dialogue( "prague_mct_onyou" );
	
	/*
		guy = level.paired_death_group[ level.paired_death_group.size - 1 ];
		level.sandman.favoriteenemy = guy;
		level waittill( "enemy_down" );
		sandman_stealth_shot( guy );
	*/
		flag_wait( "foot_patrol_dead" );
	}
}

sniper_line()
{
	level endon( "alley_sniper_dead" );
	wait( 2 );
	radio_dialogue( "prague_mct_eyeshigh" );
	flag_set( "alley_sniper_dead" );
}

switch_to_streets_minimap()
{
	flag_wait( "alley_heli_start" );
	maps\_compass::setupMiniMap( "compass_map_prague_streets", "streets_minimap_corner" );	
}

foot_patrol_dead_move()
{
	level endon( "long_convoy_move" );
	level endon( "_stealth_spotted" );
	
	thread switch_to_streets_minimap();
	
	flag_wait( "foot_patrol_dead" );
	thread chopper_escape();
	level.heli Vehicle_TurnEngineOn();
	thread alley_heli_logic();
	guys = array_removeDead( level.alley_patrol_guys );
	if ( guys.size < 2 )
		sandman_end_encounter( "prague_killfirm_other_1" );
	else
		sandman_end_encounter( "prague_go_5" );
		
	if ( !flag( "alley_sniper_dead" ) )
		thread sniper_line();
	
	flag_set( "sandman_killfirms" );
	level endon( "chopper_escape" );
	level.sandman pushplayer( true );
	delayThread( 7, ::flag_set, "chopper_escape" );
	level.sandman follow_path_waitforplayer( get_Target_ent( "sandman_crossover_4" ), 256 );
	flag_set( "chopper_escape" );
}

chopper_escape()
{
	level endon( "alley_spotted" );
	flag_wait( "chopper_escape" );
	thread disable_alley_spotted_trigger();
	wait( 1 );
	level.sandman pushplayer( true );
	level.sandman disable_cqbwalk();
	level.sandman enable_sprint();
	level.sandman AllowedStances( "stand", "crouch", "prone" );
	thread radio_dialogue( "prague_mct_throughhere" );
	
	wait( 0.4 );
	level.sandman.goalradius = 96;
	level.sandman thread follow_path_waitforplayer( get_target_ent( "alley_cqb_turn" ), 256 );
	
	level endon( "alley_heli_left" );
	
	if ( !flag( "start_long_convoy" ) )
		level.sandman waittill_notify_or_flag( "path_end_reached", "start_long_convoy" );
	
	thread hotel_room_radio();
}

hotel_room_radio()
{	
	level endon( "alley_spotted" );
	level.sandman notify( "stop_path" );
	radio_node = get_target_ent( "radio_talk_node" );
	radio_node anim_generic_reach( level.sandman, "prague_soap_radio_talk" );
	thread sandman_radio_node_logic( radio_node );
	n = get_target_ent( "radio_talk_node_end" );
	level.sandman setGoalNode( n );
	level.sandman disable_sprint();

	flag_wait( "alley_heli_left" );	

	flag_set( "start_long_convoy" );
}

disable_alley_spotted_trigger()
{
	flag_wait( "alley_heli_left" );	
	disable_trigger_with_noteworthy( "alley_heli_failsafe_trigger" );
	flag_clear( "alley_spotted" );
}

alley_heli_logic()
{
	flag_wait( "alley_heli_start" );
	stop_last_spot_light();
	StopFXOnTag( getfx( "heli_spotlight_cheap" ), level.heli.fx_ent, "tag_origin" );
	flag_wait( "alley_sniper_dead" );
	activate_trigger_with_noteworthy( "heli_flyby_alley" );
	flag_wait( "chopper_escape" );
	level.heli thread helicopter_spot_alley();
	
	level.heli delaythread( 3, ::heli_wants_spotlight );
}

sandman_radio_node_logic( radio_node )
{
	level.sandman endon( "death" );
	level endon( "alley_spotted" );
	level endon( "long_convoy_move" );
	radio_node anim_generic( level.sandman, "prague_soap_radio_talk" );
	level.sandman thread anim_generic_loop( level.sandman, "cornerL_idle" );
	//Price: Copy.  We'll keep an eye out.
	radio_dialogue( "prague_pri_eyeout" );
	flag_wait( "start_long_convoy" );
	thread radio_dialogue( "prague_go_1" );
	level.sandman notify( "stop_loop" );
	level.sandman enable_cqbwalk();
	level.sandman anim_generic( level.sandman, "corner_standL_trans_CQB_OUT_6" );
}

helicopter_spot_alley()
{
	level endon( "alley_spotted" );
	level endon( "sandman_at_red_house" );
	self endon( "death" );

	volume = get_target_ent( "alley_interior_volume" );
	thread alley_heli_failsafe();
	childthread alley_heli_react_damage();
	while ( 1 )
	{
		wait 0.1;
		spot_distance = Distance2D( level.player.origin, self.dlight.origin );
		heli_distance = Distance2D( level.player.origin, self.origin );
		//if ( ( spot_distance <= 500 ) && !level.player isTouching( volume ) )
		if ( ( heli_distance <= 1500 ) 
		&& ( within_fov_2d( self.origin, self.angles, level.player.origin, cos(75) ) || spot_distance <= 200 ) 
		&& !level.player isTouching( volume ) )
			break;
	}
	flag_set( "alley_spotted" );
	level.sandman StopAnimScripted();
}

alley_heli_react_damage()
{
	while( 1 )
	{
		self waittill( "damage", damage, attacker );
		if ( attacker == level.player )
		{
			flag_set( "alley_spotted" );
			break;
		}
	}
}

alley_heli_failsafe()
{
	level endon( "sandman_at_red_house" );
	flag_wait( "alley_spotted" );
	level notify( "kill_heli_triggers" );
	self notify( "new_behavior" );
	self helicopter_setturrettargetent( level.player );
	self heli_wants_spotlight();
	flag_set( "_stealth_spotted" );
	
	self thread vehicle_paths( get_target_ent( "heli_attack_player" ) );
	self delayThread( 2.0, ::helicopter_ai_mode, level.player );	
	thread long_convoy_backup();
	level.player endon( "death" );
	level.sandman notify( "stop_loop" );
	level.sandman StopAnimScripted();
	level.sandman.ignoreme = false;
	level.sandman stop_magic_bullet_shield();
	wait( 5.0 );
	level.sandman kill();
}

long_convoy()
{
	level.sandman endon( "death" );
	disable_trigger_with_targetname( "cleanup_foot_trigger1" );
	disable_trigger_with_targetname( "cleanup_foot_trigger2" );
	thread long_convoy_move();
	flag_wait( "start_long_convoy" );
	flag_wait( "alley_heli_left" );
	flag_waitopen( "_stealth_spotted" );
	thread dog_jump();
	thread bad_guys_enter_red_house();
	thread long_convoy_foot_cleanup();
	thread long_convoy_close_tunnel_doors();
	thread long_convoy_exit_door_logic();
	thread long_convoy_deadbody_shot();
		
	level.sandman AllowedStances( "stand", "crouch", "prone" );
	level.sandman.goalradius = 128;
	level.sandman follow_path_waitforplayer( get_target_ent( "sandman_prep_convoy" ), 128 );

//	level.sandman thread follow_path_waitforplayer( get_target_ent( "sandman_long_convoy_path" ), 768 );
}

#using_animtree( "script_model" );

open_red_house_door()
{
	door = link_door_to_clips( "red_house_entrance" );
	mover = Spawn( "script_model", door.origin );
	mover.angles = door.angles;
	mover SetModel( "tag_origin" );
	mover UseAnimTree(#animtree );
	door LinkTo( mover );
	mover SetAnim( %prague_redhouse_sneakin_door, 1.0 );
	
	trigger_wait_targetname( "red_house_open_front_door" );
	door Unlink();

	volume = get_target_ent( "red_house_volume" );
	door ConnectPaths();
	if ( level.player isTouching( volume ) )
	{
		door RotateTo( door.angles - ( 0, -80, 0 ), 1 );
		door waittill( "rotatedone" );
		door RotateTo( door.angles - ( 0, -90, 0 ), 1 );
		door waittill( "rotatedone" );
	}
	else
	{
		door RotateTo( door.angles - ( 0, 90, 0 ), 1 );
		door waittill( "rotatedone" );
	}
	door DisconnectPaths();
	
	mover Delete();
}

long_convoy_move()
{
	level.sandman endon( "death" );
	flag_wait( "long_convoy_move" );
	thread long_convoy_death_triggers();

//	array_spawn_targetname( "tunnel_kickers" );	
	level.vignette_list = SortByDistance( level.vignette_list, level.player.origin );
	thread play_sound_in_space( "scn_prague_enemy_convoy", level.vignette_list[0].origin );
	
	junk = getentarray( "shop_junk", "targetname" );
	array_thread( junk, ::shop_junk_shake );
	
	// magic reload so sandman doesn't reload in the red house
	level.sandman animscripts\weaponList::RefillClip();
	
	foreach ( ent in level.vignette_list )
	{
		ent notify( "awake" );
	}

	thread start_vignette();
	
	if ( flag( "_stealth_spotted" ) )
		return;
	
	level endon( "_stealth_spotted" );
	hidden = [];
	hidden[ "prone" ]	 = 70;
	hidden[ "crouch" ]	 = 400;
	hidden[ "stand" ]	 = 400;
	maps\_stealth_visibility_system::system_set_detect_ranges( hidden );

	wait( 0.7 );
	
	music_play( "prague_danger_2" );
	level endon( "_stealth_spotted" );
	//Sandman: You hear that?
	radio_dialogue( "prague_snd_youhearthat" );
	
	wait( 0.5 );
	
	//Sandman: Emeny convoy!  Quick, get off the street!
	thread radio_dialogue( "prague_snd_enemyconvoy" );
	if ( flag( "alley_heli_left" ) )
		autosave_stealth();
	
	prp = level.sandman.pathrandompercent;
	level.sandman.pathrandompercent = 0;
	level.sandman notify( "stop_path" );
	level.sandman notify( "stop_loop" );
	level.sandman StopAnimScripted();
	level.sandman PushPlayer( true );
	level.sandman.ignoreMe = true;
	level.sandman.ignoreAll = true;
	level.sandman AllowedStances( "stand" );
	level.sandman.goalradius = 128;
	level.sandman disable_cqbwalk();
	level.sandman enable_sprint();
	
	node = get_target_ent( "long_convoy_sandman_enter" );
	level.sandman follow_path_waitforplayer( node, 0 );
	
	node = get_Target_ent( "sandman_redhouse_cover" );
	node anim_reach_solo( level.sandman, "prague_redhouse_sneak" );
	flag_set( "sandman_at_red_house" );
	level.sandman.pathrandompercent = prp;
	
	node thread anim_single_solo( level.sandman, "prague_redhouse_sneak" );
	level.sandman childthread long_convoy_sandman_look_at_player();
	
	thread open_red_house_door();

	level.sandman thread disable_sprint();
	wait( 0.05 );
	childthread long_convoy_sandman_path();	
	while ( level.sandman GetAnimTime( level.sandman getanim( "prague_redhouse_sneak" ) ) < 0.4 )
		wait( 0.05 );
	//Sandman: Stay low… there's too many of them…
	//thread radio_dialogue( "prague_snd_toomany" );
	childthread long_convoy_cut_the_player_some_slack();
	
	while ( level.sandman GetAnimTime( level.sandman getanim( "prague_redhouse_sneak" ) ) < 0.75 )
		wait( 0.05 );
	

	while ( level.sandman GetAnimTime( level.sandman getanim( "prague_redhouse_sneak" ) ) < 0.85 )
		wait( 0.05 );
	//Sandman: Get down.
	level.sandman childthread radio_within_proximity( "prague_snd_getdown" );
	
	ai = getaiarray( "axis" );
	thread group_flavorbursts( ai, "ru", 4, 5, false, "bad_guys_enter_red_house" );
	
	diff = getdifficulty();
	if ( Distance2d( level.player.origin, level.sandman.origin ) < 300 && (diff != "fu") )
		delayThread( 1.2, ::display_hint_timeout, "hint_prone", 5 );
		
	node waittill( "prague_redhouse_sneak" );
	level.sandman set_moveplaybackrate( 0.65 );
	wait( 2.0 );
	level.player notify( "long_convoy_time_to_get_serious" );
	
	triggers = getentarray( "stealth_range_trigger" , "targetname" );
	foreach ( t in triggers )
	{
		if ( level.player IsTouching( t ) )
		{
			hidden = [];
			hidden[ "prone" ]	 = t.start_color[ 2 ];
			hidden[ "crouch" ]	 = t.start_color[ 1 ];
			hidden[ "stand" ]	 = t.start_color[ 0 ];	
			maps\_stealth_visibility_system::system_set_detect_ranges( hidden );	
			level.player.rangeTriggerOverride = false;
			break;
		}
	}
}

long_convoy_sandman_look_at_player()
{
	while ( level.sandman getAnimTime( level.sandman getanim( "prague_redhouse_sneak" ) ) < 0.53 )
		wait( 0.05 );
	
	level.sandman SetLookAtEntity( level.player );
	
	while ( level.sandman getAnimTime( level.sandman getanim( "prague_redhouse_sneak" ) ) < 0.595 )
		wait( 0.05 );
		
	level.sandman SetLookAtEntity();
}

long_convoy_death_triggers()
{
	level endon( "pre_courtyard_ally_clean_up" );
	
	flag_wait( "_stealth_spotted" );
	triggers = getentarray( "long_convoy_death", "script_noteworthy" );
	foreach ( t in triggers )
		t trigger_on();
	
	t = getent( "courtyard_start_trigger", "targetname" );
	if ( isdefined( t ) )
		t trigger_off();

	wait( 0.1 );

	volume = get_target_ent( "convoy_delete_volume" );
	ents = getaiarray( "axis" );
	foreach ( e in ents )
	{
		if ( e isTouching( volume ) )
		{
			e delete();
		}
	}
		
	long_convoy_backup();
}

long_convoy_backup()
{
	nodes = getstructarray( "long_convoy_backup_node", "targetname" );
	while( 1 )
	{
		ai = getaiarray( "axis" );
		
		if ( ai.size < 5 )
		{
			nodes = SortByDistance( nodes, level.player.origin );
			n = nodes[ nodes.size -1 ];
			guys = array_spawn_targetname( n.target, undefined, true );
			array_thread( guys, ::i_can_kill_sandman );
			wait( 5.0 );
		}
		
		wait( 1.0 );
	}
}

long_convoy_cut_the_player_some_slack()
{
	level.sandman endon( "death" );
	level endon( "_stealth_spotted" );
	level.player endon( "long_convoy_time_to_get_serious" );
	level.player.rangeTriggerOverride = true;
	
	hidden = [];
	hidden[ "stand" ] = 200;
	hidden[ "crouch" ] = 200;
	hidden[ "prone" ] = 70;
	
	while( 1 )
	{
		if ( Distance2d( level.player.origin, level.sandman.origin ) < 196 )
			maps\_stealth_visibility_system::system_set_detect_ranges( hidden );
		else
			maps\_stealth_visibility_system::system_default_detect_ranges();
			
		wait( 0.05 );
	}
}

long_convoy_sandman_path()
{
	thread long_convoy_sandman_exit();
	level endon( "long_convoy_all_clear" );
	level endon( "_stealth_spotted" );
	level.sandman AllowedStances( "prone" );
	level.sandman.goalradius = 32;
	level.sandman thread follow_path_waitforplayer( get_target_ent( "sandman_red_house_path" ), 0 );
	level.sandman set_generic_idle_forever( "prone_hide_idle" );
//	level.sandman waittill( "path_end_reached" );
	flag_wait( "red_house_dog_jump" );
	wait( 3.5 );
	level.sandman notify( "stop_path" );
	level.sandman thread anim_single_solo( level.sandman, "prone_hide" );
	//Soap: Don't…move.
	level.sandman radio_within_proximity( "prague_mct_dontmove" );
	delaythread( 1.5, ::set_alert_on_movement, 0.8, get_target_ent( "convoy_scare_detect" ), "convoy_scare_done", &"PRAGUE_DONT_MOVE" );
	flag_wait( "convoy_scare_done" );
	level.sandman.goalradius = 2;
	level.sandman follow_path_waitforplayer( get_target_ent( "sandman_red_house_resume_path" ), 0 );
	
	delayThread( 2.0, ::flag_set, "long_convoy_deadbody_shot" );
	flag_set( "start_deadbody_sequence" );
//	array_spawn_targetname( "long_convoy_foot_extra" );
	
	waittillframeend;
	thread long_convoy_wait_for_clear();
}

long_convoy_deadbody_shot()
{
	node = get_target_ent( "shop_murder" );
	spawner = getent( "deadguy_civ", "script_noteworthy" );
	deadguy = spawner spawn_ai();
	spawn_failed();
	deadguy.animname = "victim";
	deadguy hero_head();
	deadguy setCanDamage( false );
	node thread anim_loop_solo( deadguy, "deadguy_idle" );
	
	flag_wait( "start_deadbody_sequence" );
	level.sandman notify( "stop_path" );
	delaythread( 5, ::set_alert_on_movement, 0.9, get_target_ent( "deadbody_shot_detect" ), "long_convoy_all_clear", &"PRAGUE_DONT_MOVE" );
	guys = array_spawn_targetname( "long_convoy_foot_3" );
	foreach ( guy in guys )
	{
		guy.animname = guy.script_noteworthy;
		guy thread delete_on_notify( "long_convoy_cleanup_foot" );
		if ( guy.animname == "shooter1" )
		{
			guy.patrol_walk_anim = "active_patrolwalk_v2";
			guy thread attachFlashlight_removeOnSpotted( true );
		}
		else
		{
			guy.patrol_walk_anim = "active_patrolwalk_gundown";
		}
	}
	
	thread group_flavorbursts( guys, "ru", 8, 8, false );
	
	node = get_target_ent( "shop_murder" );
	
	foreach ( guy in guys )
	{
		node thread interrupt_anim_on_alert_or_damage( guy );
	}
		
	anim_guys = [ deadguy, guys[0], guys[1] ];
	node thread anim_single( anim_guys, "deadguy_shot" );	
	waitframe();
	ai = getaiarray( "axis" );
	foreach ( guy in ai )
	{
		guy removeAIEventListener( "gunshot_teammate" );
		guy removeAIEventListener( "projectile_impact" );
		guy notify( "stop_corpse_search" );	
	}
	array_thread( guys, maps\_patrol::patrol );
			
	wait( 8 );
	exploder( "shop_glass" );
	exploder( 99 );
	exploder( "pf0_99" );
	deadguy random_bloodspurt( 0.4 );
}

long_convoy_sandman_exit()
{	
	level endon( "_stealth_spotted" );
	flag_wait( "long_convoy_all_clear" );
	wait( 2.0 );
	flag_waitopen( "_stealth_spotted" );
	MusicStop( 8 );
	enable_trigger_with_targetname( "cleanup_foot_trigger1" );
	enable_trigger_with_targetname( "cleanup_foot_trigger2" );

	delaythread( 4, ::radio_dialogue, "prague_mct_sharpish" );
	level.sandman follow_path_waitforplayer( get_target_ent( "sandman_exit_red_house_path" ), 0 );
	
	if ( !volume_is_empty( get_target_ent("convoy_back_volume") ) )
	{
		radio_dialogue( "prague_mct_easy" );
		volume_waittill_no_axis( "convoy_back_volume" );
	}
	
	while( Distance2d( level.sandman.origin, level.player.origin ) > 300 && !flag( "player_outside_red_house" ) )
		wait( 0.05 );
	
	if ( flag( "player_outside_red_house" ) )
	{
		autosave_stealth();
		flag_set( "start_courtyard" );
		wait( 0.3 );
		flag_set( "new_courtyard_start" );
	}
		
	if ( !flag( "new_courtyard_start" ) )
	{
		level endon( "new_courtyard_start" );
		
		wait( 1.5 );
		
		level.sandman.moveplaybackrate = 1;
		node = get_target_ent( "red_house_crouch_node" );
	//	node = node get_target_ent();
		
		radio_dialogue( "prague_mct_getready" );
		wait( 1 );
		level.sandman notify( "clear_idle_anim" );
		level.sandman clear_generic_idle_anim();
		level.sandman thread anim_generic( level.sandman, "prone_2_stand" );
		thread radio_dialogue( "prague_mct_go" );
		level.sandman AllowedStances( "stand", "crouch", "prone" );
	
		level.sandman follow_path_waitforplayer( node, 192 );
		
		flag_wait( "player_outside_red_house" );
		autosave_stealth();
	
		level.sandman PushPlayer( true );
		level.sandman thread follow_path_waitforplayer( get_target_ent( "move_to_courtyard_node2" ), 400 );
		trigger_wait_targetname( "player_close_to_dumpster" );
		level.sandman notify( "stop_path" );
		long_convoy_traverse_to_courtyard();
	}
	
	flag_wait( "pre_courtyard_ally_clean_up" );
	
	if ( !flag( "sandman_climb_dumpster" ) )
	{
		node = get_Target_ent( "courtyard_takedown" );
		teleport_node = get_target_Ent( "move_to_courtyard_node2" );
		
		d1 = Distance2d( node.origin, level.sandman.origin );
		d2 = Distance2d( teleport_node.origin, level.sandman.origin );
		
		if ( d2 < d1 )
			level.sandman ForceTeleport( teleport_node.origin );
	}
}

long_convoy_traverse_to_courtyard()
{
/*	level endon( "_stealth_spotted" );

	node1 = get_target_ent( "climb_dumpster" );
	level.sandman set_moveplaybackrate( 1.0 );
	node1 anim_generic_reach( level.sandman, "dumpster_climb_1" );
	level.sandman thread play_sound_on_entity( "scn_prague_price_dumpster_jump" );
	node1 thread anim_generic_run( level.sandman, "dumpster_climb_1" );
*/	
	node = get_Target_ent( "courtyard_takedown" );
	node anim_reach_solo( level.sandman, "new_ally_kill" );
	flag_set( "sandman_climb_dumpster" );	
}

long_convoy_btr_think()
{
	PlayFxOnTag( getfx( "dlight_red" ), self, "TAG_REAR_LIGHT_LEFT" );
	PlayFxOnTag( getfx( "dlight_red" ), self, "TAG_REAR_LIGHT_RIGHT" );
	self.rumbleon = true;
	self build_rumble_unique( "subtle_tank_rumble", 0.3, 4.5, 300, 1, 1 );
	self add_to_vignette_list();

	self.fxtag = "tag_front_light_right";
	self thread btr_attack_player_on_spotted();
	wait( 1.0 );
	self notify( "kill_rumble_forever" );
	flag_wait( "long_convoy_move" );
	self thread vehicle_rumble_even_if_not_moving();
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "spotlight" )
	{
		self.fxtag = "tag_front_light_right";
		light = get_Target_ent( "btr_primary_light" );
		self thread move_btr_primary_light( light );
	}
	else
	{
		self.fxtag = "tag_turret_light";
	}
	self waittill( "move" );
	self thread gopath();
	self thread vehicle_stop_on_alert();
	
	self Vehicle_SetSpeed( .45, 10, 10 );
	flag_wait( "sandman_at_red_house" );
	self ResumeSpeed( 5 );
		
	self endon( "death" );
	/*
	while ( true )
	{
		PhysicsJitter( self.origin, 1024.0, 10.0, 0.15, 0.15 );
		wait( 0.1 );
	}
	*/
}

vehicle_stop_on_alert()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	while ( 1 )
	{
		level waittill( "vehicle_stop" );
		self Vehicle_SetSpeed( 0, 5, 5 );
		if ( !flag( "long_convoy_btr_stop" ) )
		{
			level waittill_notify_or_timeout( "vehicle_resume", 30.0 );
			self ResumeSpeed( 8 );
		}
	}
}

long_convoy_btr_stop()
{
	flag_wait( "long_convoy_move" );
	
	vehicles = getvehiclearray();
	btrs = [];
	foreach ( v in vehicles )
	{
		if ( v.classname == "script_vehicle_btr80" )
			btrs[ btrs.size ] = v;
	}
	
	self waittill( "trigger" );
	flag_set( "long_convoy_btr_stop" );
	foreach ( b in btrs )
	{
		b Vehicle_SetSpeed( 0, 5, 15 );
	}
	
	flag_wait( "convoy_scare_done" );
	flag_wait( "long_convoy_deadbody_shot" );

	volume_waittill_no_axis( "big_convoy_volume" );

	flag_waitopen( "_stealth_spotted" );
	flag_clear( "long_convoy_btr_stop" );
	foreach ( b in btrs )
	{
		b ResumeSpeed( 8 );
	}
}

move_btr_primary_light( light )
{
	light thread follow_btr( self );
	/*
	light SetLightIntensity( 0.1 );
	wait( 2.0 );
	thread flickering_light( light, 0.3, 1.5 );
	wait( 0.9 );
	light notify( "stop_flicker" ); */
	light SetLightIntensity( 1.1 );
	
	wait( 25 );
	intensity = light GetLightIntensity();
	while ( intensity > 0 )
	{
		intensity -= 0.1;
		light SetLightIntensity( intensity );
		wait( 0.05 );
	}
	light notify( "kill_light" );
	wait( 0.05 );
	light SetLightIntensity( 0 );
}

follow_btr( btr )
{
	self endon( "kill_light" );
	offset = ( self.origin - btr.origin );
	while ( 1 )
	{
		self MoveTo( btr.origin + offset, 0.05 );
		wait( 0.05 );
	}
}

long_convoy_close_tunnel_doors()
{
	door_l = get_target_ent( "tunnel_door_left" );
	door_r = get_target_ent( "tunnel_door_right" );
	
	flag_wait( "long_convoy_move" );
	flag_wait_either( "long_convoy_btr_stop", "long_convoy_all_clear" );
	
	door_l rotateTo( door_l.angles + ( 0,-90,0 ), 3 );
	door_r rotateTo( door_r.angles + ( 0,90,0 ), 3 );
}

long_convoy_exit_door_logic()
{
	flag_wait( "long_convoy_open_exit_gate" );
	door_l = get_target_ent( "tunnel_exit_left" );
	door_r = get_target_ent( "tunnel_exit_right" );
	door_l rotateTo( door_l.angles + ( 0,90,0 ), 1 );
	door_r rotateTo( door_r.angles + ( 0,-90,0 ), 1 );
	door_l connectpaths();
	door_r connectpaths();
	flag_waitopen( "long_convoy_open_exit_gate" );
	wait( 20.0 );
	door_l rotateTo( door_l.angles + ( 0,-90,0 ), 1 );
	door_r rotateTo( door_r.angles + ( 0,90,0 ), 1 );
}

long_convoy_foot_cleanup()
{
	flag_wait( "start_courtyard" );
	flag_wait( "cleanup_foot" );
	if ( !flag( "_stealth_spotted" ) )
	{
		level notify( "long_convoy_cleanup_foot" );
		wait( 1.0 );
		guys = array_spawn_targetname( "long_convoy_foot_4" );
		spawn_failed();
		foreach( g in guys )
		{
			g notify( "awake" );
		}
		waittillframeend;
		foreach( g in guys )
		{
			g notify( "move" );
		}
	}
}

long_convoy_foot_think()
{
	self endon( "death" );
	self.ignoreMe = false;
	self.ignoreAll = false;
	self thread attack_player_on_spotted();
	self thread delete_on_notify();
	self thread delete_on_notify( "long_convoy_cleanup_foot" );
	if ( !flag( "sandman_at_red_house" ) )
		self.moveplaybackrate = 0.5;
	self.goalradius = 16;
	self add_to_vignette_list();
	self waittill( "move" );
	self thread i_can_kill_sandman();
	self thread alert_btr();
	self.goalradius = 128;
	
	if ( !flag( "alley_spotted" ) )
	{
		if ( IsDefined( self.animation ) )
		{
			self thread active_patrol( self.animation );
		}
		else
		{
			self thread maps\_patrol::patrol();
		}
	}

	wait( 0.1 );
	self notify( "stop_corpse_search" );
	
	if ( !flag( "sandman_at_red_house" ) )
	{
		flag_wait( "sandman_at_red_house" );
		self.moveplaybackrate = 0.6;
		self delayThread( 6.0, ::set_moveplaybackrate, 1.0 );
	}
	
	flag_wait( "long_convoy_btr_stop" );
	flag_waitopen( "long_convoy_btr_stop" );
	
	self clear_run_anim();
	node = get_target_ent( "long_convoy_foot_exit" );
	self SetGoalPos( node.origin );
}

group_flavorbursts( ents, nationality, convStartID, convEndID, loop, endon_string )
{
	level endon( "_stealth_spotted" );
	level endon( "stop_radiobursts" );
	if ( isdefined( endon_string ) )
		level endon( endon_string );

	conversation = convStartID;
	
	while ( true )
	{
		burstID = conversation;
		aliases = getFlavorBurstAliases( nationality, burstID );

		foreach ( i, alias in aliases )
		{
			ents = array_removeUndefined( ents );
			
			if ( ents.size < 2 )
				return;
			
			ents = SortByDistance( ents, level.player.origin );
			burster = ents[ RandomIntRange( 0, int( min( 4, ents.size ) ) ) ];
			
			// play the burst
			if ( isAI( burster ) )
			{
				burster animscripts\battlechatter::playFlavorBurstLine( burster, alias );
			}
			else
			{
				soundOrg = spawn_tag_origin();
				soundOrg.origin = burster.origin;
				soundOrg PlaySound( alias, alias, true );
				soundOrg waittill( alias );
				soundOrg delete();
			}

			if ( i != ( aliases.size - 1 ) )
			{
				wait( RandomFloatRange( 0.2, 0.5 ) );
			}
		}
		
		conversation += 1;
		if ( conversation > convEndID && !loop )
			break;
		
		wait( RandomFloatRange( 2,4 ) );
	}
}

getFlavorBurstAliases( nationality, burstID, startingLine )
{
	if ( !IsDefined( startingLine ) )
	{
		startingLine = 1;
	}

	burstLine = startingLine;
	aliases = [];

	while ( 1 )
	{
		alias = "prague_" + nationality + "_conv" + burstID + "_" + burstLine;

		burstLine++;

		if ( SoundExists( alias ) )
		{
			aliases[ aliases.size ] = alias;
		}
		else
		{
			break;
		}
	}

	return aliases;
}

long_convoy_clear_run_anim()
{
	volume = get_target_ent( "red_house_volume" );
	
	level endon( "pre_courtyard_ally_clean_up" );
	level endon( "cleanup_foot" );
	level endon( "_stealth_spotted" );
	while ( 1 )
	{
		self waittill( "trigger", guy );
		
		guy notify( "remove_flashlight" );
		
		if ( level.player IsTouching( volume ) )
		{
			guy clear_run_anim();
			guy enable_sprint();
		}
		else
		{
			guy set_generic_run_anim( "active_patrolwalk_gundown" );
		}
	}
}

clear_run_anim_trigger()
{
	while ( 1 )
	{
		self waittill( "trigger", guy );
		
		guy notify( "remove_flashlight" );
		guy clear_run_anim();
	}
}

alert_btr()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	self thread set_spotted_on_bad_event();
	while ( 1 )
	{
		self waittill( "_stealth_enemy_alert_level_change", type );
		
		_type = type;
		if ( IsSubStr( type, "warning" ) )
			_type = "warning";
		
		switch ( _type )
		{
			case "warning":
			case "alert":
				level notify( "vehicle_stop" );
				wait( 0.5 );
				self thread maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( level.player.origin );
				delayThread( 0.5, ::flag_set, "_stealth_spotted" );
				break;
			case "reset":
				level notify( "vehicle_resume" );
		}		
	}
}

dog_jump()
{
	level endon( "_stealth_spotted" );
	flag_wait( "red_house_dog_jump" );
	thread dog_scare();
	wait( 3.0 );	
	node = get_target_ent( "dog_jump_node" );
	dog = spawn_targetname( "dog_jump_dog" );
	
	node anim_generic( dog, "sniper_escape_dog_fence" );
	dog anim_generic( dog, "german_shepherd_attackidle_growl" );
	
	wait( 5.0 );
	dog Delete();
}

dog_scare()
{
	guys = array_spawn_targetname( "dog_scare_guy" );
	speaker = undefined;
	foreach ( guy in guys )
	{
		animation = "patrol_walk";
		if ( isdefined( guy.animation ) )
			animation = guy.animation;
		guy.animname = guy.script_noteworthy;
		guy set_generic_run_anim( animation );
		if ( issubstr( animation, "active_patrolwalk_v" ) )
		{
			guy thread attachFlashlight_removeOnSpotted( 1 );
			speaker = guy;
		}
		guy thread flag_on_death( "convoy_scare_done" );
	}
	node = get_target_ent( "convoy_scare" );

	level endon( "_stealth_spotted" );

	node anim_reach( guys, "dog_scare" );
	
//	thread group_flavorbursts( guys, "ru", 12, 12, false );
	
	foreach ( guy in guys )
	{
		node thread interrupt_anim_on_alert_or_damage( guy );
	}
	
	speaker childthread play_sound_on_entity( "scn_prague_russian_dogscare_npc" );
	thread group_flavorbursts( [speaker,speaker], "ru", 13, 13, false );
	node anim_single( guys, "dog_scare" );
	
	foreach ( guy in guys )
	{
		if ( IsAlive( guy ) && guy ent_flag( "_stealth_normal" ) )
		{
			guy thread long_convoy_foot_think();
			guy.target = "dog_scare_exit_" + guy.animname;
			waittillframeend;
			guy notify( "awake" );
			guy notify( "move" );
		}
		else
		{
			flag_set( "_stealth_spotted" );
		}
	}
	flag_set( "convoy_scare_done" );
/*	
	guy = spawn_targetname( "long_convoy_foot_after_scare" );
	guy thread long_convoy_foot_think();
	waittillframeend;
	guy notify( "awake" );
	guy notify( "move" );
*/
}

bad_guys_enter_red_house()
{
	doors = [];	
	doors = array_add( doors, red_house_backdoor_setup( "red_house_backdoor_l" ) );
	doors = array_add( doors, red_house_backdoor_setup( "red_house_backdoor_r" ) );
	flag_wait( "long_convoy_move" );
	flag_wait_either( "bad_guys_enter_red_house", "_stealth_spotted" );	
	dudes = array_spawn_targetname( "long_convoy_foot_2" );

	foreach ( door in doors )
	{
		door thread hunted_style_door_open();
		wait( 1.0 );
	}
	wait( 0.05 );
	
	if ( flag( "long_convoy_move" ) )
	{
		foreach ( guy in dudes )
		{
			guy notify( "awake" );
		}
	}
	
	wait( 3.0 );
	if ( !flag( "_stealth_spotted" ) )
	{
		//Sandman: Shh….they're inside the building.
		level.sandman thread radio_within_proximity( "prague_snd_insidebuilding" );
		ai = getaiarray( "axis" );
		thread group_flavorbursts( ai, "ru", 6, 7, false, "red_house_dog_jump" );
		start_vignette();
	}
}

red_house_backdoor_setup( doorname )
{
	door = GetEntArray( doorname, "targetname" );
	board = undefined;
	foreach ( part in door )
	{
		switch ( part.classname )
		{
			case "script_brushmodel":
				board = part;
				break;
		}
		if ( IsDefined( board ) )
			break;
	}
	
	foreach ( part in door )
	{
		switch ( part.classname )
		{
			case "script_brushmodel":
				break;
			default:
				part LinkTo( board );
		}
	}
	
	return board;
}

long_convoy_wait_for_clear()
{
	level.sandman thread anim_single_solo( level.sandman, "prone_hide" );
	volume_waittill_no_axis( "convoy_forward_area" );
	flag_set( "long_convoy_all_clear" );
	disable_trigger_with_Targetname( "convoy_spotted_trigger" );
}

apartment_scene()
{
	wait( 2 );
	spawners = getentarray( "apt_resistance_drone_spawner", "targetname" );
	
	drones = [];
	
	foreach ( spawner in spawners )
	{
		spawnpoints = getstructarray_delete( spawner.script_noteworthy, "targetname" );
		
		foreach ( p in spawnpoints )
		{
			spawner.origin = p.origin;
			spawner.angles = p.angles;
			if ( isdefined( p.target ) )
			{
				spawner.target = p.target;
			}
			drone = spawner spawn_ai( true );
			drone.script = "drone";
			drone_give_weaponsound( drone );
			
			drone.noragdoll = 1;
			
			if ( isdefined( p.script_bulletshield ) )
			{
				drone thread deletable_magic_bullet_shield();
			}
			
			drone thread delete_on_notify();
			drone thread drone_parameters( p );
			drone thread mission_fail_on_death();
			drones =  array_add( drones, drone );
			
			if ( IsDefined( p.script_animation ) )
			{
				drone.deathanim = getgenericanim( p.script_animation );
			}
			
			if ( IsDefined( p.script_noteworthy ) )
			{
				if ( p.script_noteworthy == "explosion_death" )
				{
					drone thread assign_explosion_death();
				}
				else
				{
					drone thread maps\_drone::drone_fight( p.script_noteworthy, p );
					if ( IsSubStr( p.animation, "death" ) )
					{
						drone.deathanim = getgenericanim( p.animation );
						if ( issubstr( p.animation, "stagger" ) )
						{
							drone thread stagger_death();
						}
					}
				}
			}
			if ( IsDefined( p.animation ) )
			{
				if ( issubstr( p.animation, "prague_resistance_cover" ) )
				{
					drone thread drone_resistance_fight( p );
				}
				else if ( !IsDefined( p.script_noteworthy ) || p.script_noteworthy == "explosion_death" )
				{
					drone gunless_anim_check( p.animation );
					if ( isdefined( p.script_delay ) && p.script_delay == 0 )
						p thread anim_generic_loop( drone, p.animation );
					else
						p delayThread( RandomFloatRange( 0, 1 ), ::anim_generic_loop, drone, p.animation );
				}
			}
			spawner.target = undefined;
		}
	}
	
	thread group_flavorbursts( drones, "cz", 1, 19, true, "start_apartment_exit" );
}

apartment_dust()
{
	level endon( "start_apartment_exit" );
	volume = get_target_ent( "apt_shake_volume" );
	
	level.apt_shake_sound = "scn_prague_tank_alley_exp";
	level.apt_shake_source = get_Target_ent( "apt_shake_source" );
	while( 1 )
	{
		wait( RandomFloatRange( 1,3 ) );
		
		if ( !level.player isTouching( volume ) )
			continue;

		strength = RandomFloatRange( 0.4, 0.6 );
		apt_shake( strength );
		
		wait( RandomFloatRange( 2,5 ) );
	}
}

apt_shake( strength )
{
	lights = getentarray( "apt_floodlight", "script_noteworthy" );
	origins = getstructarray( "apt_dust_source", "targetname" );		
	origins = SortByDistance( origins, level.player.origin );
	times = 0;
	
	thread play_sound_in_space( level.apt_shake_sound, level.apt_shake_source.origin );
	
	Earthquake( strength, strength, level.player.origin, 196 );
	foreach ( org in origins )
	{
		if ( org.origin[2] > level.player.origin[2] )
		{
			if ( cointoss() )
			{
				if ( !isdefined( org.script_fxid ) )
					org.script_fxid = "ceiling_dust_default";
				delayThread( RandomFloatRange(0,1) , ::_Play_FX, getfx( org.script_fxid ), org.origin );
				times += 1;
			}
		}
		if ( times > 5 )
		{
			break;
		}
	}
	
	foreach ( l in lights )
	{
		thread flickering_light( l, 0.2, 0.8 );
	}
	
	wait( RandomFloatRange( 1,2 ) );
	
	foreach ( l in lights )
	{
		l notify( "stop_flicker" );
		l setLightIntensity( 1.25 );
	}
}

apartment_exploder()
{
	thread apartment_exploder_2();
	trigger = get_target_ent( "apt_exploder" );
	trigger_wait_targetname( "apt_exploder" );
	trigger thread play_sound_on_entity( "scn_prague_apt_wall_exp" );
	thread apt_shake( 0.5 );
	sandman_apt_react();	
//	level.sandman follow_path_waitforplayer( get_Target_ent( "sandman_apt_path2" ) );
}

apartment_exploder_2()
{
	trigger = get_target_ent( "apt_wall_exploder" );
	trigger_wait_targetname( "apt_wall_exploder" );
	trigger thread play_sound_on_entity( "scn_prague_apt_wall_exp" );
	thread apt_shake( 0.5 );
	sandman_apt_react();
}

sandman_apt_react()
{
	if ( level.sandman.a.state == "cover" )
	{
		level.sandman anim_generic( level.sandman, "coverL_react" );
	}
	else if ( level.sandman.movemode == "run" )
	{
		level.sandman thread anim_generic( level.sandman, "stand_react" );
		while( level.sandman getAnimTime( getgenericanim( "stand_react" ) ) < 0.5 )
			wait( 0.05 );
		
		level.sandman thread anim_generic_run( level.sandman, "stand_2_run_f_2" );
	}
}

sandman_apartment_think()
{
	flag_wait( "apartment_upstairs" );
	
	level.player.participation = 0;
	
	maps\_spawner::killspawner( 5002 );
	ai = getaiarray( "axis" );
	array_call( ai, ::delete );
	
	level.apt_shake_sound = "scn_prague_tank_apart_exp";
	level.apt_shake_source = get_Target_ent( "apt_shake_source_2" );
	
	level.sandman notify( "stop_path" );
	//Soap: Hold your fire.
	radio_dialogue( "prague_snd_holdup" );
	wait( 1.1 );
	//Soap: Take point, Yuri.
	radio_dialogue( "prague_mct_takepoint" );
	thread take_point_nag();
	thread apt_objective_marker();
	level.sandman set_force_color( "c" );
	level.sandman disable_cqbwalk();
	
	trigger_wait_targetname( "apt_exploder" );
	wait( 0.1 );
	
	//Soap: The building's not going to take much more of this.
	thread radio_dialogue( "prague_mct_takemuchmore" );
	
	trigger_wait_targetname( "player_at_end_of_apartments" );

	current_weapon = level.player GetCurrentPrimaryWeapon();
	if ( IsSubStr( current_weapon, "silence" ) )
	{		
		//Soap: Might get rough out there mate, you ready?
		thread radio_dialogue( "prague_mct_getrough" );
		
		level.player wait_for_unsilenced_weapon_pickup();
	}
	flag_set( "start_apartment_fight" );
	level.sandman.moveplaybackrate = 1.0;
	level.sandman.ignoreAll = false;
}

take_point_nag()
{
	level endon( "apt_player_kill_point_nags" );
	wait( 1.5 );
	while( !flag( "apt_player_kill_point_nags" ) )
	{
		radio_dialogue( "prague_mct_scoutahead" ); 
		wait( 0.4 );
		radio_dialogue( "prague_mct_takepoint" ); 
		wait( 5.0 );
		radio_dialogue( "prague_mct_coveroursix" ); 
		wait( 8.0 );
	}
	
}

apt_objective_marker()
{
	level endon( "start_gallery" );
	
	trigger = get_target_ent( "apt_objective_origin" );
	while ( isdefined( trigger ) )
	{
		if( Isdefined ( trigger.script_noteworthy ) && trigger.script_noteworthy == "mg_gunners" )
		{
			diff = getdifficulty();
			if ( diff == "easy" ) // only show objective on easy
				Objective_Position( obj( "fight" ), trigger.origin );
			else
				Objective_Position( obj( "fight" ), (0,0,0) );
			objective_setpointertextoverride( obj( "fight" ), &"prague_targets");
			flag_wait( "mg_event_done" );
			trigger activate_trigger();
			trigger = trigger get_target_ent();	
		}

		Objective_SetPointerTextOverride( obj( "fight" ), "" );
		Objective_Position( obj( "fight" ), trigger.origin );
		trigger waittill( "trigger" );
		trigger = trigger get_target_ent();		
	}
}

peptalk()
{
	trigger_wait_targetname( "peptalk_setup" );
	
	node = get_target_ent( "peptalk" );
	guys = array_spawn_targetname( "peptalk_guys" );
	
	i = 0;
	foreach ( g in guys )
	{
		g.animname = "r" + i;
		i += 1;
	}
		
	node thread anim_first_frame( guys, "peptalk" );
	
	flag_wait( "peptalk_start" );
	
	node thread anim_single_run( guys, "peptalk" );

	array_thread( guys, ::peptalk_think );
}

peptalk_think()
{
	self endon( "death" );
	node = self get_target_ent();
	self.ignoreSuppression = true;
	self.disableExits = true;
	self.goalradius = 64;
	self setGoalPos( node.origin );
	
	if ( isdefined( self.script_noteworthy )  )
	{
		self waittill( "goal" );
		self.goalradius = 256;
		self.disableExits = false;
		self.ignoreSuppression = false;
		self set_force_color( "o" );
	}
	else
	{
		wait( RandomFloatRange( 3,5 ) );
		self kill();
	}
}

wait_for_unsilenced_weapon_pickup()
{
	level endon( "start_apartment_fight" );
	level endon( "nonsilenced_weapon_pickup" );

	while ( true )
	{
		self waittill( "weapon_change" );

		current_weapon = self GetCurrentPrimaryWeapon();
		if ( !IsDefined( current_weapon ) )
			continue;
			
		if ( current_weapon == "none" )
			continue;

		if ( current_weapon == "c4" )
			continue;
			
		if ( current_weapon == "claymore" )
			continue;
			
		if ( IsSubStr( current_weapon, "silence" ) )
			continue;
		
		break;
	}

	level notify( "nonsilenced_weapon_pickup" );
}

apartment_rpg_guy()
{
	self endon( "death" );
	self set_ignoreme( true );
	
	wait 0.05;
	
	self.goalheight = 32;
	self.goalradius = 32;
	
	self waittill( "goal" );
	
	vehicles = get_vehicle_array( "plaza_btr_shooting", "targetname" );
	
	self SetEntityTarget( vehicles[ 0 ] );
	self delayThread( 3.0, ::set_ignoreme, false );
	self delayCall( 15.0, ::ClearEnemy );	
}

#using_animtree( "generic_human" );

apt_runner_drone_think()
{
	self endon( "death" );
	if ( isdefined( self.script_parameters ) )
	{
		self.script_noteworthy = self.script_parameters;	
	}
	
	if ( isdefined( self.animation ) )
	{
		self.runAnim = getgenericanim( self.animation );
		if ( self.weapon != "none"  )
			self gun_remove();
		self.idleAnim = %civilain_crouch_hide_idle;
	}
	
	if ( isAI( self ) )
	{
		node = get_target_ent( self.target );
		self.ignoreSuppression = true;
		self.ignoreall = true;
		self.goalradius = 96;
		self.goalheight = 32;
		self follow_path_waitforplayer( node, 0 );
		if ( isdefined( self.script_noteworthy ) )
		{
			if ( self.script_noteworthy == "delete_on_goal" )
			{
				wait( 1.0 );
				if ( isalive( self ) )
					self delete();
			}
			else if ( self.script_noteworthy == "die_on_goal" )
			{
				if ( isalive( self ) )
					self kill();
			}
			else
			{
				self set_force_color( "o" );
				self enable_ai_color();
			}
		}
		else
		{
			self set_force_color( "o" );
			self enable_ai_color();
		}
	}
}

resistance_cover_behavior()
{
	self endon( "death" );
	if ( isdefined( self.script_bulletshield ) )
	{
		self thread deletable_magic_bullet_shield();
	}
	node = self get_target_ent();
	
	anims = [ "prague_resistance_cover_shoot_l", 
	"prague_resistance_cover_shoot_l", 
	"prague_resistance_cover_l2r", 
	"prague_resistance_cover_shoot_r", 
	"prague_resistance_cover_shoot_r", 
	"prague_resistance_cover_r2l" ];
	
	self.script = "drone"; 
	drone_give_weaponsound( self );
	num = RandomIntRange( 0, anims.size );
	while ( 1 )
	{
		node anim_generic( self, anims[ num ] );
		num = num + 1;
		num = num % anims.size;
	}
}

inside_apt_resistance_anim_think()
{
	self thread delete_on_notify();
	self.noragdoll = true;
	self endon( "death" );
	self thread mission_fail_on_death();
	if ( isdefined( self.script_bulletshield ) )
	{
		self thread deletable_magic_bullet_shield();
	}

	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;
	
	self gunless_anim_check( node.animation );
	self drone_parameters( node );
	
	if ( IsAI( self ) && isdefined( self.moveoverride ) )
	{
		node anim_generic_reach( self, node.animation );
	}
	
	if ( IsSubStr( node.animation, "door" ) )
	{
		door = node get_target_ent();
		door assign_animtree( "door" );
		door.animname = "door";
		door thread anim_single_solo( door, node.animation + "_door" );
	}
	
	node anim_generic( self, node.animation );
	
	if ( isAI( self ) )
	{
		self delete();
	}
}

inside_apt_resistance_anim_then_idle_think()
{
	self thread delete_on_notify();
	self.noragdoll = true;
	self endon( "death" );
	self thread mission_fail_on_death();
	if ( isdefined( self.script_bulletshield ) )
	{
		self thread deletable_magic_bullet_shield();
	}
	
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;

	self drone_parameters( node );
	self gunless_anim_check( node.animation );
	
	node anim_generic( self, node.animation );
	
	if ( isdefined( node.script_flag_set ) )
		flag_set( node.script_flag_set );
	
	node anim_generic_loop( self, node.animation + "_idle" );
}

inside_apt_resistance_anim_then_die_think()
{
	self thread delete_on_notify();
	self.noragdoll = true;
	self endon( "death" );
	self thread mission_fail_on_death();
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;
	
	self.deathanim = getgenericanim( node.animation + "_death" );
	
	self gunless_anim_check( node.animation );
	self drone_parameters( node );
	
	if ( issubstr( node.animation, "crawl" ) )
	{
		self.a = spawnstruct();
		self.a.pose = "prone";
		self delaythread( 0.1, animscripts\pain::dyingCrawlBloodSmear );
	}
		
	node anim_generic( self, node.animation );
	self.noragdoll = true;
	self kill();
}

mission_fail_on_death()
{
	self waittill( "death", killer );
	
	if ( isdefined( killer ) && killer == level.player )
	{
		SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_CIVILIAN_KILLED" );	// You shot a civilian. Watch your fire!
		SetBlur( 30, 2 );
		missionfailedwrapper();
	}
}

drone_parameters( node )
{
	if ( !isdefined( node.script_parameters ) )
		return;
	if ( isSubstr( node.script_parameters, "force_ragdoll" ) )
		self.noragdoll = undefined;	
	if ( isSubstr( node.script_parameters, "notsolid" ) )
		self notsolid();
	if ( isSubstr( node.script_parameters, "hero_head" ) )
		self hero_head();
	if ( isSubstr( node.script_parameters, "cold_breath" ) )
	{
		self.a = SpawnStruct();
		self.a.movement = "stop";
		self thread animscripts\utility::PersonalColdBreath();
	}
	if ( isSubStr( node.script_parameters, "painsound" ) )
	{
		self thread drone_pain_sound();
	}
}

drone_pain_sound()
{
	self endon( "death" );
	while( 1 )
	{
		self play_sound_on_entity( "prague_pain" );
		wait( RandomFloatRange( 1,3 ) );
	}
}

gunless_anim_check( animation )
{
	if ( array_contains( level.gunless_anims, animation ) && self.weapon != "none" )
		self gun_remove();
	else if ( !isAI( self ) )
	{
		self.script = "drone";
		drone_give_weaponsound( self );
	}
}

molotov_guy_think()
{
	self endon( "death" );
	self disable_ai_color();

	self script_delay();
	node = self get_target_ent();
	node2 = node get_target_ent();
	
	node anim_generic_reach( self, "molotov_throw" );
	
	self thread maps\_molotov::throw_molotov( node2, true );
	wait( 1.0 );
	self enable_ai_color();
}

mg_event()
{
	triggers = getentarray( "mg_event_wait", "script_noteworthy" );
	foreach( t in triggers )
		t trigger_off();
		
	level.player_mg_target = spawn_tag_origin();
	level.player_mg_target.origin = level.player.origin + ( 0, 0, 16 );
	level.player_mg_target linkTo( level.player );
	
	trigger_wait_targetname( "mg_trigger" );
	
	thread radio_dialogue( "prague_mct_turretgunners" ); 
	//iprintlnbold( "Bloody hell! Those machine gunners are kicking our arse!" );
	thread mg_nag();

//	wait( 20 );	
//	volume_waittill_no_axis( "mg_nest_ONE" );
	volume_waittill_no_axis( "mg_nest_two" );
	
	flag_set( "mg_event_done" );
	autosave_by_name( "mg_event_done" );
	
	array_call( level.apt_mg, ::setmode, "manual" );
	
	radio_dialogue_stop();
	radio_dialogue( "prague_mct_theyredown" ); 
	
	level.player_mg_target delete();
	
	maps\_spawner::killspawner( 250 );
	
	foreach( t in triggers )
		t trigger_on();
		
	triggers = getentarray( "mg_event_wait_off", "script_noteworthy" );
	foreach( t in triggers )
		t trigger_off();
	
//	trigger_wait_targetname( "player_flank" );
	array_spawn_targetname( "apt_fight_good_4" );
	spawn_failed();
//	activate_trigger_with_targetname( "resistance_advance_after_mg" );
}

mg_nag()
{
	level endon( "mg_event_done" );
	wait( 5.5 );
	while( 1 )
	{
		radio_dialogue( "prague_mct_flankthem" ); 
		wait( 5.0 );
		radio_dialogue( "prague_mct_fromalcove" ); 
		wait( 8.0 );
	}
}

mg_guy_think()
{
	waittillframeend;
	
	self endon( "death" );
	self AllowedStances( "stand" );
	self.favoriteenemy = level.player;
	self.ignoreme = true;
	self.fixednode = true;
	self.goalradius = 128;
	self.combatmode = "ambush";
	self disable_long_death();
	
	if ( !isdefined( level.apt_mg ) )
		level.apt_mg = [];
	
	turret = self get_target_ent();
	level.apt_mg = array_add( level.apt_mg, turret );
	
	self useturret( turret );
	self thread turret_track_ai( turret );
	self setGoalPos( turret.origin );

	trigger_wait_targetname( "mg_trigger" );
	wait( 0.05 );

	turret MakeUnusable();
	turret setmode( "auto_ai" );
 	turret setturretteam( "axis" );
	turret SetConvergenceTime( 7, "yaw" );
	turret SetConvergenceTime( 3, "pitch" );
	turret SetAISpread( 3 );
	self childthread stay_on_turret( turret );
	
	diff = getdifficulty();
	if ( diff == "easy" )
	{
		wait( RandomFloatRange( 30, 60 ) );
		self.ignoreme = false;
		self kill();
	}
}

turret_track_player( turret )
{
	self notify( "using_turret" );
	self endon( "death" );
	self endon( "using_turret" );
	
	turret setmode( "manual_ai" );
	turret settargetentity( level.player_mg_target );
	wait( RandomFloatRange( 5,7 ) );
	self thread turret_track_ai( turret );
}

turret_track_ai( turret )
{
	self notify( "using_turret" );
	self endon( "death" );
	self endon( "using_turret" );
	
	turret ClearTargetEntity();
	turret setmode( "auto_ai" );
	wait( RandomFloatRange( 2,5 ) );
	self thread turret_track_player( turret );
}

stay_on_turret( turret )
{
	while( 1 )
	{
		if ( IsTurretActive( turret ) )
			wait( 0.5 );
		self useturret( turret );
		self notify( "using_turret" );
		self thread turret_track_player( turret );
		wait( 0.5 );
	}
}

damage_taken() // you can also kill off these guys...
{
//	self endon ( "death" );
	self waittill( "damage" );
	flag_set( "allow_mg_gunners_to_die" );
}

jump_on_turret()
{
}


mg_guy_support()
{
	waittillframeend;
	self delete();
	
	
//	self endon( "death" );
//	self AllowedStances( "stand" );
//	self.favoriteenemy = level.player;
//	self.ignoreme = true;
//	self.fixednode = true;
//	self.goalradius = 2;
//	self.goalheight = 2;
//	self.combatmode = "ambush";
//	self disable_long_death();
//	self thread damage_taken();
//	flag_wait( "allow_mg_gunners_to_die" );
//	self.ignoreme = false;
	
	
//	turret = self get_target_ent();
//	self useturret( turret );
//	self setGoalPos( turret.origin );
//	turret SetMode( "auto_ai" );
//	turret MakeUnusable();
}

magic_rpg()
{
	flag_wait( "magic_rpg_go" );
	flag_wait( "mg_event_done" );
	level notify( "kill_battle_3b_smoke" );
//	thread magic_smoke( "apartment_fight_smoke" );
	nodes = getstructarray( "magic_rpg_source", "targetname" );
	nodes = SortByDistance( nodes, level.player.origin );
	foreach ( n in nodes )
		magic_rpg_fire( n );
	
	cheers = [];
	s = get_Target_ent( "celebrate_walla_left" );
	c = Spawn( "script_model", s.origin );
	c SetModel( "tag_origin" );
	c.sound = "walla_prague_tank_celebrate_left";
	cheers[ cheers.size ] = c;
	s = get_Target_ent( "celebrate_walla_right" );
	c = Spawn( "script_model", s.origin );
	c SetModel( "tag_origin" );
	c.sound = "walla_prague_tank_celebrate_right";
	cheers[ cheers.size ] = c;
	
	/*foreach ( c in cheers )
	{
		c thread play_loop_sound_on_tag( c.sound + "_looping", "tag_origin", true );
	}*/
	
	wait( 3.0 );
	struct = get_target_ent( "apt_retreat_node" );
	enemies = GetAIArray( "axis" );
	volume = get_Target_ent( "street_1_volume" );
	nodes = GetNodesInRadius( struct.origin, 512, 0, 128, "path" );
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			e.goalradius = 256;
			e.ignoreSuppression = true;
			e.pacifist = true;
			e SetGoalNode( nodes[ RandomIntRange( 0, nodes.size ) ] );
		}
	}
	
	drones = array_spawn_targetname( "apt_fight_good_5a_drone", undefined, true );	

	ai = GetAIArray( "allies" );
	foreach ( a in ai )
	{
		if ( IsDefined( a.script_forcecolor ) && a.script_forceColor == "g" )
			a set_force_color( "o" );
	}
	flag_wait( "crowd_charge" );
	
	node = get_target_ent( "tank_big_explosion" );
	
	foreach ( c in cheers )
	{
		o = node.origin;
		c thread play_sound_on_tag( c.sound, "tag_origin", true );
		c MoveTo( ( o[ 0 ], o[ 1 ], c.origin[ 2 ] ), 5.0 );
	}
	
	foreach ( d in drones )
	{
		if ( IsAlive( d ) )
			d set_force_color( "o" );
	}
	
	wait( 1.0 );
	
	foreach ( c in cheers )
	{
		c notify( "stop_sound" + c.sound + "_looping" );
	}
}

magic_rpg_fire( node1 )
{		
	node2 = node1 get_Target_Ent();
	vehicles = getvehiclearray();
	btrs = [];
	foreach ( v in vehicles )
	{
		if ( v.classname == "script_vehicle_btr80" )
			btrs[ btrs.size ] = v;
	}
	btrs = SortByDistance( btrs, node2.origin );
	
	attractor = Missile_CreateAttractorEnt( btrs[ 0 ], 100000, 512 );
	
	wait( RandomFloatRange( 0.0, 0.5 ) );	
	rpg = MagicBullet( "rpg", node1.origin, node2.origin );
	rpg waittill( "death" );
	if ( btrs[ 0 ].health > 0 )
		btrs[ 0 ] Kill();
	
	Missile_DeleteAttractor( attractor );
}



crowd_charge()
{	
	flag_wait( "crowd_charge" );
	flag_wait( "mg_event_done" );

	level.speaker_location = "vehicle";
	
	drones = array_spawn_targetname( "apt_fight_good_5_drone" );
	
	n = get_Target_ent( "tank_big_explosion" );
	if ( player_looking_at( n.origin, 0.65, true ) )
		drones2 = array_spawn_targetname( "apt_fight_good_5b_drone" );
	else
		drones2 = [];
	
	drones = array_combine( drones, drones2 );
	foreach ( d in drones )
	{
		if ( cointoss() )
			d.runAnim = %run_n_gun_F;
	}
	
	/*
	wait( 0.05 );
	thread maps\_spawner::flood_spawner_scripted( GetEntArray( "apt_fight_good_4", "targetname" ) );
	wait( 0.05 );
	thread maps\_spawner::flood_spawner_scripted( GetEntArray( "apt_fight_good_4b", "targetname" ) );
	*/
	volume = get_target_ent( "apartment_fight_cleanup_volume" );
	ai = getaiarray( "allies" );
	foreach ( a in ai )
	{
		if ( a isTouching( volume ) )
			a kill();
	}
		
	heli = spawn_vehicle_from_targetname_and_drive( "backup_heli" );
	
	heli thread helicopter_searchlight_on();
	drones = level.drones[ "allies" ].array;
	heli thread heli_target( drones );
	
	heli notify( "stop_kicking_up_dust" );
				
	wait( 3.5 );
	
	tank = spawn_vehicle_from_Targetname_and_drive( "apt_btr_backup" );
	foreach ( mg in tank.mgturret )
		mg setDefaultDropPitch( 0 );
		
	wait( 1.0 );
	
	foreach ( mg in tank.mgturret )
		mg setMode( "manual" );

	level notify( "kill_battle_3_smoke" );
	level notify( "kill_battle_3b_smoke" );
	level notify( "kill_battle_3c_smoke" );
		
	level notify( "sandman_panic" );
	
	trigger = get_target_ent( "tank_fire_trigger" );
	trigger waittill_notify_or_timeout( "trigger", 3.0 );
	
	tank tank_big_explosion( drones );
	
	flag_wait( "start_gallery" );
	tank Vehicle_SetSpeed( 3, 3, 3 );
	
	flag_wait( "gallery_exit" );
	
	if ( isdefined( heli ) )
	{
		heli helicopter_searchlight_off();
		heli Delete();
	}
}

tank_death_zone( node )
{
	self waittill( "reached_end_node" );
	
	while ( 1 )
	{
		if ( !level.trailer_guy )
		{
			if ( Distance2d( level.player.origin, self.origin ) < 600 )
			{
				self setTurretTargetEnt( level.player );
				self.turret_target = level.player;
				wait( 2.0 );
				if ( Distance2d( level.player.origin, self.origin ) < 600 )
				{
					PlayFx( getfx( "tank_impact_exaggerated" ), level.player.origin );
					wait( 0.1 );
					level.player kill();
				}
				else
				{
					self.turret_target = node;
					self setTurretTargetVec( node.origin );
				}
			}
		}
		wait( 0.5 );
	}
}

tank_big_explosion( drones )
{
	level endon( "stop_the_killing" );
	node = get_Target_ent( "tank_big_explosion" );
	n = get_Target_ent( "tank_big_explosion_level" );
	self SetTurretTargetVec( node.origin );
	
	wait( 1.0 );
	player_in_blast_radius = Distance2D( level.player.origin, node.origin ) < node.radius * 1.75;

//	if ( player_in_blast_radius )
	{
		self FireWeapon();
		wait( 0.05 );
		PlayFX( getfx( "tank_impact_exaggerated" ), node.origin );
		Earthquake( 1.5, 0.5, node.origin, node.radius * 2.0 );
	
		foreach ( d in drones )
		{	
			d.noragdoll = true;
			d thread ragdoll_if_above( n.origin[2] + 10 );	
			if ( Distance2D( node.origin, d.origin ) < node.radius )
			{
				if ( cointoss() )
				{
					dir = undefined;
					if ( Distance2D( node.origin, d.origin ) < node.radius * 0.15 )
					{
						dir = "u";
					}
					else if ( Distance2D( node.origin, d.origin ) < node.radius * 0.75 )
					{
						angles_to_damage = VectorToAngles( d.origin - node.origin );
						d.damageyaw = angles_to_damage[ 1 ] - d.angles[ 1 ];
						
						if ( d.damageyaw > 180 )
							d.damageyaw = d.damageyaw - 360;
						if ( ( d.damageyaw > 135 ) || ( d.damageyaw <= -135 ) )	// Front quadrant
						{
							dir = "b";
						}
						else if ( ( d.damageyaw > 45 ) && ( d.damageyaw <= 135 ) )		// Right quadrant
						{
							dir = "l";
						}
						else if ( ( d.damageyaw > - 45 ) && ( d.damageyaw <= 45 ) )		// Back quadrant
						{
							dir = "f";
						}
						else
						{															// Left quadrant
							dir = "r";
						}
					}
					
					
					
					if ( IsDefined( dir ) )
					{
						num = RandomIntRange( 0, level.explosion_deaths[ dir ].size );
						d.deathanim = level.explosion_deaths[ dir ][ num ];
					}
				}
				d.skipdeathfx = true;
				d Kill();
			}
		}	
		
		RadiusDamage( node.origin, node.radius, 200, 60 );
		
		wait( 0.1 );
		if ( Distance2D( level.player.origin, node.origin ) < node.radius * 1.75 )
		{
			shocktime = 6.0;
			MusicStop( 0 );
			level.player SetStance( "prone" );
			level.player ShellShock( "prague_explosion", shocktime );
			thread stop_the_killing( shocktime * 1.5 );
			/*
			wait( 0.05 );
			
			goalnode = get_target_ent( "sandman_infront_of_gallery" );
			if ( Distance2d( level.sandman.origin, node.origin ) > Distance2d( level.player.origin, node.origin ) 
			&& !within_fov( level.player.origin, level.player.angles, level.sandman.origin, 75 ) )
			{
				fwd = AnglesToForward( level.player.angles );
				org = level.player.origin - (fwd*100);
				level.sandman ForceTeleport( org, VectorToAngles( node.origin-org ) );
			}
			*/
		}
	}
	
	self thread tank_ai( node );
	wait( 0.5 );
	PlayFX( getfx( "falling_debris" ), level.player.origin );
	level notify( "play_loud_speaker" );
	a1 = level.drones[ "allies" ].array;
	a2 = GetAIArray( "allies" );
	drones = array_combine( a1, a2 );
	ai = SortByDistance( drones, self.origin );
	
	tank_death_corridoor = get_Target_ent( "tank_death_corridoor" );
	
	foreach ( a in ai )
	{
		if ( IsDefined( a ) && a != level.sandman )
		{
			if ( !isAI( a ) )
				a Solid();
			if ( a isTouching( tank_death_corridoor ) || !isAI( a ) )
			{
				if ( !isAI( a ) )
					a NotSolid();
				a Kill();
				if ( player_in_blast_radius )
					wait( RandomFloatRange( 0.05, 0.2 ) );
				else
					wait( RandomFloatRange( 0.05, 0.1 ) );
			}
		}
	}
	

}

ragdoll_if_above( ht )
{
	self waittill( "death" );
	
	wait( 2 );
	
	if ( !isdefined( self ) )
		return;
	
	if ( self.origin[2] > ht )
	{
		self delete();
		
	}
}

tank_ai( node )
{
	level.trailer_guy = GetDvarInt( "trailer", 0 );
	
	self endon( "death" );
	self.turret_target = node;
	self childthread tank_force_turret();
	self childthread tank_find_targets();
	self childthread tank_death_zone( node );
	trigger = get_target_ent( "tank_target_trigger" );
	while( 1 )
	{
		trigger waittill( "trigger" );
		wait( 1.0 );
		if ( !level.trailer_guy )
		{
			self.turret_target = level.player;
			self setTurretTargetEnt( level.player );
			while( level.player isTouching( trigger ) || Distance2d( level.player.origin, self.origin ) <= 512 )
			{
				self setTurretTargetEnt( level.player );
				wait( 1.0 );
			}
		}
		self.turret_target = node;
		self SetTurretTargetVec( node.origin );
	}
}

tank_find_targets()
{
	self endon( "death" );
	while( 1 )
	{
		targets = level.drones[ "allies" ].array;
		targets = array_combine( targets, getaiarray( "allies" ) );
		targets = SortByDistance( targets, self.origin );
		
		if ( self.turret_target != level.player )
		{
			foreach ( t in targets )
			{
				if ( isdefined( t ) && t != level.sandman )
				{
					if ( self.turret_target == level.player )
					{
						self setTurretTargetEnt( level.player );
						break;
					}
						
					self.turret_target = t;
					self setTurretTargetEnt( t );
					t waittill_notify_or_timeout( "death", RandomIntRange( 3,6 ) );
				}
			}
		}
		else
			wait( 1.0 );
		wait( 0.5 );
	}
}

tank_force_turret()
{
	self endon( "death" );
	while( 1 )
	{
		times = RandomIntRange( 50, 70 );
		
		for ( i=0; i<times; i++ )
		{
			turret_org = self GetTagOrigin( "tag_turret2" );
			if ( isdefined( self.turret_target ) )
			{
				MagicBullet( "pecheneg", turret_org, self.turret_target.origin );
			}
			foreach ( mg in self.mgturret )
			{
				mg maps\_mgturret::DoShoot();
			}
		}
		
		wait( RandomFloatRange( 2, 10 ) );
	}
}

stop_the_killing( time )
{
	level.player EnableInvulnerability();
	wait( time );
	level notify( "stop_the_killing" );
	level.player DisableInvulnerability();
}

apt_fight_sandman_think()
{
	thread sandman_changes_weapons();
	flag_wait( "start_apartment_exit" );
	battlechatter_on( "allies" );
	level.sandman set_battlechatter( true );
	flag_wait( "mg_event_done" );
	flag_wait( "magic_rpg_go" );
	//Sandman: There's the church.
//	thread radio_dialogue( "prague_snd_church" );
	wait( 3.0 );
	//Sandman: Alright, BTRs are down. Let's go!
//	thread radio_dialogue( "prague_snd_btrsdown" );
//	flag_wait( "crowd_charge" );
	level waittill( "sandman_panic" );
	fx_volume_pause_noteworthy( "tank_cleanup_fx_volume" );
	//Sandman: TANK!!  Get to cover!!
	thread radio_dialogue( "prague_snd_gettocover" );
	battlechatter_off( "allies" );
	level.sandman set_battlechatter( false );
	level.sandman.ignoreSuppression = true;
	level.sandman.pacifist = true;
	level.sandman.a.disablepain = true;
	level.sandman enable_sprint();
	level.sandman disable_ai_color();
	obpa = level.sandman.badplaceawareness;
	level.sandman.badplaceawareness = 0;
	level.sandman.grenadeawareness = 0;
	node = get_target_ent( "sandman_infront_of_gallery" );
	level.sandman SetGoalNode( node );
	level.sandman waittill( "goal" );
	level.sandman.pacifist = false;
	level.sandman disable_sprint();
	
	coder_debug = GetDvarInt( "coder_debug", 0 );
	if ( coder_debug )
		thread tank_badplace();	
	
	node = get_target_ent( "sandman_inside_gallery" );
	BadPlace_Cylinder( "gallery_window", 30, node.origin, 256, 96, "axis" );
	
	if ( !flag( "start_gallery" ) )
	{
		level.sandman thread apt_fight_sandman_nag();
		n = get_target_ent( "obj_statue" );
		Objective_Position( obj( "fight" ), n.origin );
		
		trigger = get_target_ent( "player_infront_of_gallery" );
		trigger waittill( "trigger" );
		Objective_OnEntity( obj( "fight" ), level.sandman );
		
		level.sandman notify( "go_to_gallery" );
		level.sandman.ignoreAll = true;
		
		//Sandman: We gotta get outta this courtyard…
		thread radio_dialogue( "prague_snd_outofcourtyard" );
		thread gallery_nag();
		
		node = get_Target_ent( "gallery_jump_node" );
		node anim_reach_solo( level.sandman, "gallery_jump" );
		node thread anim_single_solo( level.sandman, "gallery_jump" );
		
		while( level.sandman getAnimTime( level.sandman getanim( "gallery_jump" ) ) < 0.25 )
			wait( 0.05 );
		
		if ( !coder_debug )
			thread tank_badplace();	
		exploder( "gallery_window" );
		exploder( 3 );
		n = get_target_ent( "obj_gallery" );
		
		if ( !flag( "start_gallery" ) )
			Objective_Position( obj( "fight" ), n.origin );
		
		node waittill( "gallery_jump" );
		
		level.sandman.ignoreSuppression = false;
		level.sandman.a.disablepain = false;
		level.sandman.badplaceawareness = obpa;
		level.sandman.grenadeawareness = 0.9;
	}
}

gallery_nag()
{
	level endon( "start_gallery" );
	while( !flag( "start_gallery" ) )
	{
		//Sandman: This way.	
		thread radio_dialogue( "prague_snd_thisway2" );
		wait( 9 );
		thread radio_dialogue( "prague_snd_thisway2" );
		wait( 12 );
		//Sandman: We gotta get outta this courtyard…
		thread radio_dialogue( "prague_snd_outofcourtyard" );
		wait( 15 );
	}
}

sandman_changes_weapons()
{
	count = 20;
	base_time = count;
	dot = .9;
	dot_only = true;
			
	for ( ;; )
	{
		org = level.sandman GetEye();

		if ( !player_looking_at( org, dot, dot_only ) )
		{
			count--;
			if ( count <= 0 )
				break;
		}
		else
		{
			count = base_time;
		}
		wait( 0.05 );
	}
	
	level.sandman forceUseWeapon( "ak47", "primary" );
	//level.price forceUseWeapon( "ak47_arctic_acog", "primary" );
	
}

apt_fight_sandman_nag()
{
	level endon( "start_gallery" );
	self endon( "go_to_gallery" );
	while ( 1 )
	{
		wait( 1.0 );
		//Sandman: FROST!  I'm over by the statue! Come to me!
		radio_dialogue( "prague_snd_bythestatue" );
		wait( 6.0 );
		//Sandman: Get your ass over here!!
		radio_dialogue( "prague_snd_getasshere" );
		wait( 10.0 );
	}
}

btr_target( drones )
{
	self endon( "stop_shooting" );
	self endon( "death" );
	drones = SortByDistance( drones, self.origin );
	if ( drones.size > 0 )
	{
		self SetTurretTargetEnt( drones[ 0 ] );
		wait( 1.0 );
	}
	foreach ( d in drones )
	{
		if ( IsDefined( d ) )
		{
			d.deathanim = level.random_explosion_deaths[ RandomIntRange( 0, level.random_explosion_deaths.size ) ];
			self SetTurretTargetEnt( d );
			self FireWeapon();
			wait( RandomFloatRange( 3.0, 4.0 ) );
		}
	}
	
	while ( 1 )
	{
		self FireWeapon();
		wait( RandomFloatRange( 3.0, 4.0 ) );
	}
}

heli_target( drones )
{
	self endon( "stop_shooting" );
	self endon( "death" );
	
	while( 1 )
	{
		drones = level.drones[ "allies" ].array;
		drones = array_combine( drones, getaiarray( "allies" ) );
		
		if ( drones.size == 0 )
			break;
			
		drones = SortByDistance( drones, self.origin );
		foreach ( d in drones )
		{
			if ( IsDefined( d ) && d != level.sandman )
			{
				self helicopter_setturrettargetent( d );
				d waittill_notify_or_timeout( "death", RandomFloatRange( 3,6 ) );
				break;
			}
		}
		wait( 0.1 );
	}
	
	self helicopter_setturrettargetent( self.spotlight_default_target );
}

resume_stealth()
{
	flag_wait( "start_gallery" );
	flag_clear( "_stealth_spotted" );
	flag_set( "sandman_announce_spotted" );
//	level.sandman ent_flag_set( "stealth_enabled" );
//	level.sandman thread sandman_spotted_notify();
	level.sandman.ignoreMe = true;
	level.sandman.ignoreAll = true;
	level.player.ignoreMe = true;
	
	flag_wait( "gallery_exit" );
	
	blocker = get_target_ent( "gallery_exit_blocker" );
	blocker NotSolid();
	blocker ConnectPaths();
	
	axis = GetAIArray( "axis" );
	foreach ( a in axis )
	{
		if ( !isdefined( a.donotcleanup ) )
			a Delete();
	}
	
	flag_wait( "entering_white_building" );
	
	level.player.ignoreMe = false;
	if ( !flag( "white_building_breachers_in_position" ) )
	{
		level.sandman.ignoreMe = false;
	}
	else
	{
		ai = getaiarray( "allies" );
		foreach ( a in ai )
		{
			a.ignoreMe = true;
		}
		ai = getaiarray( "axis" );
		foreach ( a in ai )
		{
			a clearEnemy();
		}
	}
	flag_set( "white_building_breachers_in_position" );
}

sandman_gallery_think()
{
	level endon( "gallery_exit" );
	level.sandman disable_cqbwalk();
	//level.sandman set_generic_run_anim( "_stealth_patrol_jog" );
	thread radio_dialogue( "prague_mct_move" );
	/*
	wait( 3.0 );
	//Sandman: Alright, we're clear.
	// radio_dialogue( "prague_snd_wereclear" );
	wait( 1.0 );
	//Sandman: Advancing.  Watch my six.
	// thread radio_dialogue( "prague_snd_advancing" );
	node = get_target_ent( "gallery_path" );
	node waittill( "trigger" );
	wait( 4.0 );
	radio_dialogue( "prague_clear_2" );
	*/
}

sandman_gallery_exit()
{
	level endon( "_stealth_spotted" );
	level endon( "inside_second_building" );
	music_stop( 5 );
	flag_wait( "gallery_exit" );
	music_play( "prague_busted_3" );
	
	//Soap: Hang on, got more armor on the road.
	thread radio_dialogue( "prague_snd_waitforem" );
	level.sandman clear_run_anim();
	flag_wait( "gallery_street_clear" );
	//Sandman: On me.
	radio_dialogue( "prague_snd_onme2" );
}

tank_badplace()
{
	wait( 0.1 );
	tank = get_vehicle( "apt_btr_backup", "targetname" );
	coder_debug = GetDvarInt( "coder_debug", 0 );
	tank endon( "death" );
	while( 1 )
	{
		if ( coder_debug )
			BadPlace_Cylinder( "tank_badplace", 1.5, tank.origin, 1024, 128, "allies" );
		else
			BadPlace_Cylinder( "tank_badplace", 1.5, tank.origin, 512, 128, "allies" );
		wait( 1.5 );
	}
}

btrs_drive_away()
{
	level endon( "_stealth_spotted" );
	flag_wait( "start_gallery" );
	
	//btrs = spawn_vehicles_from_targetname( "apt_btr_backup" );
	//btrs[ 0 ] notify( "awake" );
	//array_thread( btrs, ::btr_target, [] );
	//node = GetVehicleNode( "gallery_btr_exit_far", "targetname" );
	//tank AttachPath( node );
	//tank thread btr_attack_player_on_flag( "btr_spotted" );
	//tank delaythread( 1.0, ::goPath );
	
	btr_deploy = spawn_vehicle_from_targetname( "gallery_btr_troop_deployer" );
	btr_watchdog = spawn_vehicle_from_targetname( "gallery_btr_watchdog" );
	wait( 0.05 );
	targets = getstructarray( "btr_targets", "targetname" );
	btr_deploy thread btr_randomly_fire( targets );
	btr_watchdog thread btr_randomly_fire( targets );

	flag_wait( "gallery_exit" );
	wait( 0.05 );
	reinforcements = array_spawn_targetname( "gallery_reinforcements" );
	truck = spawn_vehicle_from_targetname( "gallery_truck_watchdog" );
	
	btr_deploy notify( "awake" );
	btr_watchdog notify( "awake" );
	
	delayThread( 0.0, ::run_to_square, reinforcements );
	btr_deploy delaythread( 0.0, ::goPath );
	btr_watchdog delaythread( 0.0, ::goPath );
	truck delaythread( 0.0, ::goPath );
}

btr_randomly_fire( targets )
{
	self endon( "death" );
	self endon( "stop_random_fire" );
	while ( 1 )
	{
		foreach ( t in targets )
		{
			self SetTurretTargetVec( t.origin );
			wait( RandomFloatRange( 2, 5 ) );
			times = RandomIntRange( 1, 5 );
			for ( i = 0; i < times; i++ )
			{
				self fire_at_target();
				wait( RandomFloatRange( 0.5, 2 ) );
			}
		}
	}
}

run_to_square( guys )	//self should be an array of dudes
{
	point = get_target_ent( "battle_point" );
	nodes = GetNodesInRadius( point.origin, 512, 0, 128, "path" );
	guys = array_removeDead( guys );
	foreach ( p in guys )
	{
		node = nodes[ RandomIntRange( 0, nodes.size ) ];
		nodes = array_remove( nodes, node );
		p SetGoalNode( node );
		p thread delete_on_goal();
		p.fixednode = false;
	}
}

heli_drops_troops()
{
	level endon( "_stealth_spotted" );
	node = get_Target_ent( "gallery_heli_unload_node" );
	node.origin = groundpos( node.origin );
	
	flag_wait( "gallery_exit" );

	wait( 0.05 );
	heli = spawn_vehicle_from_targetname( "backup_heli_secondary" );
	
	wait( 0.05 );
	node.origin = node.origin + ( 0, 0, heli.fastropeoffset );
	heli SetHoverParams( 0, 0, 0 );
	
	heli vehicle_paths( node );
	flag_wait( "inside_second_building" );
	guys = heli vehicle_unload( "both" );
	heli waittill( "unloaded" );
	thread run_to_square( guys );
	heli vehicle_paths( get_Target_ent( "gallery_heli_leave_node" ) );
	heli delete();
}

sandman_opens_bank()
{
	level endon( "_stealth_spotted" );
	flag_wait( "gallery_exit" );
	blocker = get_target_ent( "bank_blocker" );
	blocker NotSolid();
	blocker ConnectPaths();
	wait( 0.1 );
	volume_waittill_no_axis( "gallery_street" );
	flag_set( "gallery_street_clear" );
	level.sandman disable_cqbwalk();
	
	node = get_target_ent( "sandman_pre_bank_wait" );
	level.sandman setGoalNode( node );
	
	trigger = get_Target_ent( "corner_bank_trigger" );
	trigger waittill( "trigger" );
	
	flag_set( "inside_second_building" );
	//Sandman: Road's a no-go.  We'll have to move through here.
	thread radio_dialogue( "prague_snd_roadsanogo" );
	
	door = get_target_ent( "corner_bank_door" );
	node = get_target_ent( "sandman_open_corner_bank" );
	node anim_generic_reach( level.sandman, "door_slowopen_arrive" );
	node anim_generic( level.sandman, "door_slowopen_arrive" );
	door thread shoulder_door_open( "scn_prague_shoulder_door_open" );
	node anim_generic_run( level.sandman, "door_slowopen_shoulder" );
	
	thread white_building_dialogue();
	
	level.sandman AllowedStances( "stand", "crouch", "prone" );
	level.sandman SetGoalNode( get_Target_ent( "sandman_corner_bank_hide" ) );
	//Sandman: Shit, more targets.
	radio_dialogue( "prague_snd_moretargets" );
	//Sandman: Stay quiet…they don't know we're here.
	level.sandman delayThread( 0.4, ::dialogue_queue, "prague_snd_theydontknow" );
	
	level endon( "entering_white_building" );
	volume_waittill_no_axis( "front_of_bank_volume" );
	flag_set( "white_building_breachers_in_position" );
	thread bank_post_wait();
}

bank_post_wait()
{	
	if ( !flag( "_stealth_spotted" ) && !flag( "btr_spotted" ) )
		autosave_tactical();
	
	level.sandman enable_cqbwalk();
	level.sandman pushplayer( true );
	//Sandman: Nice and easy, Frost.
	level.sandman thread dialogue_queue( "prague_snd_niceandeasy" );
}

guy_runs_and_gets_owned()
{
	flag_wait( "inside_second_building" );
	
	guys = array_spawn_targetname( "bank_civ" );
	array_thread( guys, ::bank_civ_think );
	
	trigger = undefined;
	triggers = getentarray( "ak47", "script_noteworthy" );
	foreach ( t in triggers )
	{
		if ( isdefined( t.script_parameters ) && t.script_parameters == "bank_civ_death_trigger" )
			trigger = t;
	}
	trigger waittill( "trigger" );
	
	source = trigger get_target_ent();
	
	thread play_sound_in_space( "RU_0_stealth_alert", source.origin );
}
	
bank_civ_think()
{
	self.goalradius = 64;
	self endon( "death" );
	
	flag_wait( "entering_white_building" );
	
	wait( 0.7 );
	
	node = get_target_ent( "bank_civ_node" );	
	self setGoalPos( node.origin );
	
	self set_generic_run_anim( "civilian_run_hunched_A" );
//	self thread anim_generic( self, self.animation );
//	wait( 0.1 );
//	while( self getAnimTime( getgenericanim( self.animation ) ) < 0.2 )
//		wait( 0.05 );
//	self StopAnimScripted();
	
	trigger = undefined;
	triggers = getentarray( "ak47", "script_noteworthy" );
	foreach ( t in triggers )
	{
		if ( isdefined( t.script_parameters ) && t.script_parameters == "bank_civ_death_trigger" )
			trigger = t;
	}
	trigger waittill( "trigger" );
	
	source = trigger get_target_ent();
	
	wait( 0.5 );
	MagicBullet( "ak47", source.origin, self getEye() );
	wait( 1.0 );
	self kill();
	
}

white_building_dialogue()
{	
	flag_wait( "white_building_breachers_in_position" );
	blocker = get_target_ent( "bank_blocker" );
	blocker Solid();
	blocker DisconnectPaths();
	level.sandman SetGoalNode( get_target_ent( "sandman_white_building_wait" ) );
	level.sandman thread wait_for_player_to_engage();

//	if ( !flag( "entering_white_building" ) )
	{
		level notify( "stop_stealth_busted_music" );
		wait( 0.5 );
		level.sandman SetGoalNode( get_target_ent( "sandman_white_building_hide2" ) );
		trigger = undefined;
		triggers = getentarray( "ak47", "script_noteworthy" );
		foreach ( t in triggers )
		{
			if ( isdefined( t.script_parameters ) && t.script_parameters == "bank_civ_death_trigger" )
				trigger = t;
		}
		trigger waittill( "trigger" );
		flag_wait( "entering_white_building" );
		thread fake_smoke_grenade();
		wait( 0.5 );
		level endon( "_stealth_spotted" );
		//Sandman: We got company.  No getting past these guys quietly.  Wait for my go…
		radio_dialogue( "prague_snd_gotcompany" );
		level.sandman thread sandman_throw_grenade();
		wait( 2.5 );
	}
	/* else
	{
		level.sandman SetGoalNode( get_target_ent( "sandman_white_building_hide2" ) );
		level.sandman waittill( "goal" );
	} */
	flag_clear( "sandman_announce_spotted" );
	music_stop( 2 );
	//Sandman: Alright, smoke em.
	radio_dialogue( "prague_snd_smokeem" );
	delayThread( 2.7 , ::flag_set, "bank_wakeup" );
	delayThread( 3.0 , ::flag_set, "_stealth_spotted" );
}

sandman_throw_grenade()
{
	setdvar( "scr_expDeathMayMoveCheck", "off" );
	old = self.grenadeawareness;
	self.grenadeawareness = 0;
	n = get_target_ent( "sandman_white_building_hide2" );
	node = SpawnStruct();
	trace = BulletTrace( n.origin, n.origin - (0,0,500), false, level.sandman );
	node.origin = trace[ "position" ];
	node.angles = n.angles + (0,90,0);
	node anim_generic_reach( self, "CornerCrL_grenadeA" );
	node thread anim_generic( self, "CornerCrL_grenadeA" );
	self waittillmatch( "single anim", "grenade_left" );
	self Attach( "weapon_m67_grenade", "tag_inhand" );
	self waittillmatch( "single anim", "grenade_throw" );
	self Detach( "weapon_m67_grenade", "tag_inhand" );
	fwd = AnglesToForward( node.angles );
	tagorigin = self getTagOrigin( "tag_inhand" ) + fwd*5;
	n1 = get_target_ent( "sandman_grenade_dest" );
	g = MagicGrenade( "fraggrenade", tagorigin, n1.origin, 1.5 ); 
	wait( 3.8 );
	self.grenadeawareness = old;
	setdvar( "scr_expDeathMayMoveCheck", "on" );
}

fake_smoke_grenade()
{
	n1 = get_target_ent( "fake_smoke_source" );
	n2 = n1 get_target_ent();
	
	can = MagicGrenade( "flash_grenade", n1.origin, n2.origin, 500 );
	wait( 3.0 );
	org = spawn_tag_origin();
	org.origin = can.origin;
	org.angles = can.angles;
	//org setModel( "projectile_us_smoke_grenade" );
	org linkto( can );
	//can delete();

	playfxontag( getfx( "smoke_stream" ), org, "Tag_origin" );
	
	thread magic_smoke( "bank_battle_smoke", 45 );
	wait( 20.0 );
	
	can delete();	
	org delete();
}

wait_for_player_to_engage()
{
	level waittill( "bank_wakeup" );
	battlechatter_on( "allies" );
	level.sandman set_battlechatter( true );
	music_play( "prague_busted_2" );
	wait( 1.0 );
	level.sandman.goalradius = 128;
	level.sandman set_ignoreall( false );
	level.sandman setGoalNode( get_target_Ent( "sandman_bank_cover" ) );
//	level.sandman waittill( "goal" );
	trigger_wait_targetname( "bank_backup_trigger" );
	thread radio_dialogue( "prague_mct_morehostiles" );
	trigger_wait_targetname( "bank_backup_trigger_2" );
	wait( 2.0 );
	volume_waittill_no_axis( "white_building_volume" );
	
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		a delete();
	}
	
	level.sandman.goalradius = 256;
	level.sandman enable_sprint();
	music_stop( 0 );
	delaythread( 1.0, ::music_play, "prague_danger_3" );
	level.sandman thread follow_path_waitforplayer( get_target_ent( "start_church_path" ) );
	flag_set( "sandman_announce_spotted" );
	battlechatter_off( "allies" );
	level.sandman set_battlechatter( false );
	node = get_target_ent( "sandman_white_building_wait" );
	
	BadPlace_Cylinder( "bank_badplace", 30, node.origin, 256, 96, "allies" );
	level.sandman disable_cqbwalk();
	autosave_by_name( "start_church" );
	radio_dialogue( "prague_snd_covertracks" );
	radio_dialogue( "prague_snd_improvise" );
}

secure_white_building()
{
	level endon( "_stealth_spotted" );
	nodes = GetNodeArray( "white_building_breachers_waitnodes", "targetname" );
	breachers = array_spawn_targetname( "white_building_breachers" );
	node = get_target_ent( "enemies_breach_white_building" );
			
	i = 0;
	foreach ( n in nodes )
	{
		if ( IsAlive( breachers[ i ] ) )
		{
			breachers[ i ] thread magic_bullet_shield();
			breachers[ i ] LaserForceOn();
			breachers[ i ].goalradius = 64;
			breachers[ i ].donotcleanup = true;
			breachers[ i ] SetGoalNode( n );
			breachers[ i ].ignoreall = true;
		}
		i++;
	}
	
	door = link_door_to_clips( "white_building_door" );

	kicker = breachers[ 0 ];
	other = breachers[ 1 ];
	guards =[ breachers[ 2 ], breachers[ 3 ] ];
	
	node thread anim_generic_first_frame( other, "breach_enter" );
	node thread anim_generic_first_frame( kicker, "breach_kick" );
	
	flag_wait( "entering_white_building" );
	
	wait( 2.0 );
	
	node notify( "stop_first_frame" );	

	foreach ( guy in breachers )
	{
		guy stop_magic_bullet_shield();
	}
	
	door thread kick_door_open();
	node thread anim_generic( kicker, "breach_kick" );
	node anim_generic( other, "breach_enter" );
	
	other thread cqb_patrol( "search_path_1" );
	kicker thread cqb_patrol( "search_path_2" );
	kicker.health = 1;
	other.health = 1;
	
	guards = remove_dead_from_array( guards );
	array_thread( guards, ::wait_for_patrol );
	breachers = array_removeDead( breachers );
	foreach ( guy in breachers )
	{	
		guy.grenadeawareness = 0;
	}
	
	flag_wait( "bank_wakeup" );
	breachers = array_removeDead( breachers );
	foreach ( guy in breachers )
	{
		guy.ignoreall = false;
		guy.script_stealthgroup = "bank_guys";
		guy thread stealth_custom();
		guy disable_long_death();
		waittillframeend;
		guy RemoveAIEventListener( "gunshot" );
		guy RemoveAIEventListener( "gunshot_teammate" );
		guy RemoveAIEventListener( "bulletwhizby" );
	}

	wait( 2.0 );
	
	breachers = array_removeDead( breachers );
	foreach ( guy in breachers )
	{
		guy addAIEventListener( "gunshot_teammate" );
		guy addAIEventListener( "bulletwhizby" );
	}
}

cqb_patrol( path )	
{
	num = randomint( 3 );
	self.moveplaybackrate = 1.2;
	self.patrol_walk_anim = "cqb_walk";
	self delayThread( 0.1, ::clear_run_anim );
	self delayThread( 0.1, ::enable_cqbwalk );
	self disable_long_death();
	self ClearEnemy();
	self maps\_patrol::patrol( path );
	waitframe();
	self.moveplaybackrate = 1.0;
	self.favoriteenemy = level.player;
	self SetGoalPos( level.player.origin );
	self.goalradius = 256;	
	delayThread( 1.0, ::flag_set, "_stealth_spotted" );
	if ( isdefined( self._stealth ) )
		self maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( level.player.origin );
}

wait_for_patrol()
{
	self endon( "death" );
	level waittill( "_stealth_spotted" );
	wait( 0.5 );
	self enable_cqbwalk();
	self.moveplaybackrate = 1.0;
	self.favoriteenemy = level.player;
	self.goalradius = 128;
	self SetGoalEntity( level.player );
}

bank_backup_think()
{
	self endon( "death" );
	self enable_cqbwalk();
	self LaserForceOn();
	self.favoriteenemy = level.player;
	self.goalradius = 512;
//	self setGoalEntity( level.player );
	self disable_long_death();
	
	wait( 15.0 );
	self.goalradius = 256;
	
	wait( 5.0 );
	self.goalradius = 128;
}

/*
	UTILITIES
*/

clear_ignore_on_spotted()
{
	self endon( "death" );
	flag_wait( "_stealth_spotted" );
	self.ignoreMe = false;
	self.ignoreAll = false;
}

vignette_loop_setup()
{
	self thread delete_on_notify();
	
	wait( RandomFloatRange( 0, 3 ) );
	if ( IsDefined( self.animation ) )
	{
		node = SpawnStruct();
		node.origin = self.origin;
		node.angles = self.angles;
		node thread anim_generic_loop( self, self.animation );
	}
}

run_to_delete_node()
{
	self endon( "death" );
	self.last_patrol_goal.patrol_claimed = undefined;
	
	self.goalradius = 16;
	self notify( "remove_flashlight" );
	self clear_run_anim();
	node = get_Target_ent( "long_convoy_delete_node" );
	self SetGoalPos( node.origin );
	self waittill( "goal" );
	self Delete();	
}

vignette_runner_setup()
{
	if ( IsDefined( self.animation ) )
	{
		self.runAnim = getgenericanim( self.animation );
		self set_generic_run_anim( self.animation );
	}
	else
	{
		self.animation = "patrol_walk";
	}
	self thread add_to_vignette_list();
	if ( IsAI( self ) )
	{
		if ( IsDefined( self.script_patroller ) && self.script_patroller == 1 )
		{
			self thread delete_on_notify();
			self.goalradius = 16;
			self anim_generic_first_frame( self, self.animation );	
			self waittill( "move" );
			self notify( "stop_first_frame" );
			self thread maps\_patrol::patrol();
			self thread remove_ignoreme_on_spotted();
		}
	}
}

remove_ignoreme_on_spotted()
{
	self endon( "death" );
	flag_wait( "_stealth_spotted" );
	self.ignoreMe = false;
	self.ignoreall = false;
}

start_vignette_trigger()
{
	self waittill( "trigger" );
	start_vignette();
	self Delete();
}

start_vignette()	
{
	if ( !IsDefined( level.vignette_list ) )
		level.vignette_list = [];
	
	foreach ( e in level.vignette_list )
	{
		wait( RandomFloatRange( 0, 0.2 ) );
		e notify( "move" );
	}
	
	level.vignette_list = [];
}

add_to_vignette_list()
{
	if ( !IsDefined( level.vignette_list ) )
	{
		level.vignette_list = [];
	}
	
	level.vignette_list[ level.vignette_list.size ] = self;
}

vignette_btr_think()
{
	self build_rumble_unique( "subtle_tank_rumble", 0.2, 4.5, 192, 1, 1 );
	self.rumbleon = true;
	self endon( "death" );
	self waittill( "move" );
	self thread gopath();
	
	self thread delete_on_notify();
	while ( true )
	{
		//Earthquake( 0.15, 0.1, self.origin - ( 0, 0, 128 ), 360.0 );
		wait( 0.1 );
	}
}

level_cleanup_trigger()
{
	self waittill( "trigger" );
	level notify( "level_cleanup" );
	self Delete();
}

// heli constants:
CONST_searchlight_move_speed	= 1;	// seconds
CONST_searchlight_jitter		= 20;

// temp patrol chopper that shines spot light on script_struct "scan_node"
patrol_chopper( targetname )
{
	level.scan_nodes = [];
	
	helicopter = spawn_vehicle_from_targetname( targetname );
	helicopter SetHoverParams( 32, 10, 3 );
	helicopter SetJitterParams( ( 0, 0, 20 ), 2, 3 );
	
	level.heli = helicopter;
	
	helicopter thread helicopter_searchlight_on();
	helicopter thread helicopter_searchlight_path();
	helicopter thread heli_spotlight_scan();
	
	helicopter Vehicle_TurnEngineOff();
}

// scan pattern
heli_spotlight_scan()
{
	self endon( "new_behavior" );
	self endon( "death" );
	node = undefined;
	while ( 1 )
	{			
		if ( level.scan_nodes.size > 0 )
		{
			if ( !IsDefined( node ) || !IsDefined( node.target ) || !array_contains( level.scan_nodes, node ) )
			{
				if ( level.scan_nodes.size > 1 )
				{
					oldnode = node;
					index = RandomInt( level.scan_nodes.size );
					node = level.scan_nodes[ index ];
					if ( isdefined( oldnode ) && oldnode == node )
					{
						index = ( index + 1 ) % ( level.scan_nodes.size );
						node = level.scan_nodes[ index ];
					}
				}
				else
				{
					node = level.scan_nodes[ 0 ];
				}
				
			}
			else
			{
				node = node get_target_ent();
				level.scan_nodes[ level.scan_nodes.size ] = node;
			}
			time = level.heli_spot_movetime;
			if ( IsDefined( node.script_delay ) )
				time = node.script_delay;
			waittime = level.heli_spot_staytime;
			if ( IsDefined( node.script_wait ) )
				waittime = node.script_wait;
				
			level.target_dummy thread move_dummy_to( node.origin, time );
			level waittill_notify_or_timeout( "change_spot", time + waittime );
		}
		wait( 0.05 );
	}
}
// ---------------------------------------------------------------------------------
// HELICOPTER STUFF - SEARCH LIGHT:
// ---------------------------------------------------------------------------------

helicopter_searchlight_path()
{
	self endon ( "death" );

	level.target_dummy = Spawn( "script_model", self.origin );
	level.target_dummy SetModel( "tag_origin" );
	self helicopter_setturrettargetent( level.target_dummy );
}

helicopter_searchlight_on( fx_tag )
	{
	//while ( distance( level.player.origin, self.origin ) > 7000 )
	//	wait 0.2;

	if ( !isdefined( fx_tag ) )
		fx_tag = "tag_barrel";

	self.fx_tag = fx_tag;

	self endon( "death" );
	
	self helicopter_searchlight_off();
	self StartIgnoringSpotLight();

	self spawn_searchlight_target();
	self helicopter_setturrettargetent( self.spotlight_default_target );

	self.dlight = Spawn( "script_model", self GetTagOrigin( self.fx_tag ) );
	self.dlight SetModel( "tag_origin" );
	self thread delete_on_death( self.dlight );
	
	self.fx_ent = Spawn( "script_model", self GetTagOrigin( self.fx_tag ) );
	self.fx_ent SetModel( "tag_origin" );
	self thread delete_on_death( self.fx_ent );

	self thread helicopter_searchlight_effect();
	self thread update_spotlight_pos();
	self thread update_spotlight_vec();
	
	wait 0.5;
	self heli_wants_spotlight();
}

update_spotlight_pos()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self.fx_ent.origin = self GetTagOrigin( self.fx_tag );
		wait 0.05;
	}	
}

update_spotlight_vec()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self.fx_ent RotateTo( VectorToAngles( self.current_turret_target.origin - self.fx_ent.origin ), 0.25 );
		wait 0.25;
	}
}

move_dummy_to( org, time )
{
	self notify( "new_target" );
	self endon( "new_target" );
	
	offset = CONST_searchlight_jitter;
	
	if ( IsDefined( self ) )
	{
		self MoveTo( org, time );
		
		// jittering
		wait time;
		while ( 1 )
		{	
			x = ( org[ 0 ] - ( offset / 2 ) ) + RandomInt( offset );
			y = ( org[ 1 ] - ( offset / 2 ) ) + RandomInt( offset );
			z = ( org[ 2 ] - ( offset / 2 ) ) + RandomInt( offset );
			
			new_org = ( x, y, z );
			
			self MoveTo( new_org, 0.1 );
			wait 0.1;
		}	
	}
}

helicopter_setturrettargetent( target_ent )
{
	if ( !IsDefined( target_ent ) )
		target_ent = self.spotlight_default_target;

	self.current_turret_target = target_ent;
	self SetTurretTargetEnt( target_ent );
}

helicopter_getturrettargetent()
{
	return self.current_turret_target;
}

helicopter_searchlight_off()
{
	if ( IsDefined( self.fx_ent ) )
		self.fx_ent Delete();
}

helicopter_searchlight_effect()
{
	self endon( "death" );

	self.dlight.spot_radius = 256;
	count = 0;
	while ( true )
	{
//		vector = anglestoforward( self gettagangles( self.fx_tag ) );
		vector = AnglesToForward( self.fx_ent.angles );
		start = self GetTagOrigin( self.fx_tag );
		end = self GetTagOrigin( self.fx_tag ) + ( vector * 7000 );

		trace = BulletTrace( start, end, false, self );
		dropspot = trace[ "position" ];
		dropspot = dropspot + ( vector * -96 );

		self.dlight MoveTo( dropspot, .2 );

		wait 0.2;
	}
}

spawn_searchlight_target()
{
	spawn_origin = self GetTagOrigin( "tag_ground" );

	target_ent = Spawn( "script_origin", spawn_origin );
	target_ent LinkTo( self, "tag_ground", ( 512, 0, -256 ), ( 0, 0, 0 ) );
	self.spotlight_default_target = target_ent;
	self thread searchlight_target_death();
}

searchlight_target_death()
{
	ent = self.spotlight_default_target;
	self waittill( "death" );
	ent Delete();
}

heli_scan_update()
{
	level endon( "kill_heli_triggers" );
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( other == level.player || other == level.heli )
			break;
	}
	self script_delay();
	level.scan_nodes = getstructarray( self.target, "targetname" );
	level.heli helicopter_setturrettargetent( level.target_dummy );
	level notify( "change_spot" );
}

heli_move_update()
{
	level endon( "kill_heli_triggers" );
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( !IsDefined( other ) )
			break;
		if ( other == level.player || other == level.heli )
			break;
	}
	self script_delay();
	node = get_target_ent( self.target );
	level.heli vehicle_paths( node );
}

heli_teleport()
{
	level endon( "kill_heli_triggers" );
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( other == level.player || other == level.heli )
			break;
	}
	self script_delay();
	node = get_target_ent( self.target );
	level.heli Vehicle_Teleport( node.origin, node.angles );
	wait( 0.1 );
	level.heli vehicle_paths( node );
}

heli_default_target_trigger()
{
	level endon( "kill_heli_triggers" );
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( other == level.player || other == level.heli )
			break;
	}
	self script_delay();
	level.heli helicopter_setturrettargetent();
}

// SPOTLIGHT STUFF BORROWED FROM LONDON

spot_light( fxname, cheapfx, tag_name, death_ent )
{
    if ( IsDefined( level.last_spot_light ) )
    {
        struct = level.last_spot_light;
        // stop the spotlight shadowmap version
        if ( IsDefined( struct.entity ) )
        {
	        StopFXOnTag( struct.effect_id, struct.entity, struct.tag_name );
	        // start the low budget version
	        if ( IsDefined( struct.cheap_effect_id ) )
	          PlayFXOnTag( struct.cheap_effect_id, struct.entity, struct.tag_name );
        }
        wait 0.1;
    }

	level notify( "spotlight_changed_owner" );
	waitframe();
    struct = SpawnStruct();
    struct.effect_id = getfx( fxname );
    if ( isdefined( cheapfx ) )
    	struct.cheap_effect_id = getfx( cheapfx );
    struct.entity = self;
    struct.tag_name = tag_name;
    
    PlayFXOnTag( struct.effect_id, struct.entity, struct.tag_name );
    
    if ( IsDefined( death_ent ) )
    {
        self thread spot_light_death( death_ent );
        
    }
    level.last_spot_light = struct;
}

stop_last_spot_light()
{
	if ( IsDefined( level.last_spot_light ) )
	{
		struct = level.last_spot_light;
		// stop the spotlight shadowmap version
		StopFXOnTag( struct.effect_id, struct.entity, struct.tag_name );
		level.last_spot_light = undefined;
	}
}

spot_light_death( death_ent )
{
    self notify ( "new_spot_light_death" );
    self endon ( "new_spot_light_death" );
    self endon ( "death" );
    death_ent waittill ( "death" );
    self Delete();
}

turn_on_streetlight()
{
	targetent = get_target_ent( self.target );
	
	while ( 1 )
	{
		self waittill( "trigger" );
		StopFXOnTag( getfx( "streetlamp_spotlight_cheap" ), targetent, "tag_origin" );
		targetent spot_light( "streetlamp_spotlight", "streetlamp_spotlight_cheap", "tag_origin" );
		level waittill( "spotlight_changed_owner" );
	}
}

turn_on_heli_spot()
{
	targetent = get_target_ent( self.target );
	
	while ( 1 )
	{
		self waittill( "trigger" );
		level.heli heli_wants_spotlight();
		level waittill( "spotlight_changed_owner" );
	}
}

Heli_wants_spotlight()
{
	StopFXOnTag( getfx( "heli_spotlight_cheap" ), self.fx_ent, "tag_origin" );
	self.fx_ent spot_light( "heli_spotlight", "heli_spotlight_cheap", "tag_origin" );
}

level_cleanup_thread()
{
	maps\_compass::setupMiniMap( "compass_map_prague_intro", "intro_minimap_corner" );
	delayThread( 5, ::autosave_tactical );
	delayThread( 10, maps\_spawner::killspawner, 100 );
	flag_wait( "start_sewers" );
	level notify( "level_cleanup" );
	maps\_spawner::killspawner( 900 );
	flag_wait( "player_out_of_water" );
	level notify( "cleanup_dead_bodies" );
	cleanup_volume( "intro_cleanup_volume", true, false, true );
	
	flag_wait( "start_alcove" );
	level notify( "level_cleanup" );
	maps\_spawner::killspawner( 901 );
	

	flag_wait( "start_long_convoy" );
	level.rain_effect = "rain_heavy_cheap";
	cleanup_volume( "alcove_cleanup_volume" );

//	level notify( "cleanup_dead_bodies" );
	
	flag_wait_either( "pre_courtyard_ally_clean_up", "player_hopped_courtyard_fence" );
	
	flag_set( "pre_courtyard_ally_clean_up" );
	level notify( "cleanup_snipers" );
	level notify( "cleanup_dead_bodies" );
	level notify( "kill_alley_smoke" );
	level notify( "level_cleanup" );
	fx_volume_pause_noteworthy( "partition_1_fx_volume" );
	maps\_spawner::killspawner( 902 );
	flag_wait( "start_apartments" );
	level notify( "stop_shutters" );
	maps\_compass::setupMiniMap( "compass_map_prague_church", "church_minimap_corner" );
	cleanup_volume( "courtyard_cleanup_volume" );
	level notify( "cleanup_puzzle" );
	level notify( "kill_plaza_smoke" );
	flag_wait( "start_apartment_fight" );
	level notify( "stop_rain" );
	maps\_spawner::killspawner( 940 );
	maps\_spawner::killspawner( 950 );
	flag_wait( "start_apartment_exit" );
	
	fx_volume_pause_noteworthy( "partition_2_fx_volume" );
	fx_volume_pause_noteworthy( "partition_2_fx_volume_2" );
	blocker = get_Target_Ent( "apartment_blocker" );
	blocker NotSolid();
	blocker ConnectPaths();
	blocker Delete();
	level notify( "level_cleanup" );
	level notify( "kill_battle_1_smoke" );
	level notify( "kill_battle_2_smoke" );
	flag_wait( "start_gallery" );
	level notify( "kill_apartment_fight_smoke" );
	level notify( "kill_battle_3_smoke" );
	level notify( "kill_battle_3b_smoke" );
	level notify( "kill_battle_3c_smoke" );
	flag_wait( "gallery_exit" );
	fx_volume_pause_noteworthy( "partition_3_fx_volume" );
}

cleanup_volume( volume_targetname, delete_drones, delete_ai, delete_spawners )
{
	
	if ( !isdefined( delete_drones ) )
		delete_drones = true;
	if ( !isdefined( delete_ai ) )
		delete_ai = true;
	if ( !isdefined( delete_spawners ) )
		delete_spawners = true;
		
	volume = get_target_ent( volume_targetname );
	
	// DELETE DRONES
	if ( delete_drones )
	{
		drones = level.drones[ "neutral" ].array;
		foreach ( d in drones )
		{
			if ( d isTouching( volume ) )
				d delete();
		}
	}
	
	if ( delete_spawners )
	{
		spawners = getspawnerarray();
		foreach ( s in spawners )
		{
			if ( s isTouching( volume ) )
				s delete();
		}
	}
	
	if ( delete_ai )
	{
		ai = getaiarray( "axis" );
		array = [];
		foreach ( a in ai )
		{
			if ( a istouching( volume ) )
			{
				array = array_add( array, a );
			}
		}
		thread ai_delete_when_out_of_sight( array, 128 );
	}
	
	// delete shutters
/*	leftShutters = [];
	array = GetEntArray( "shutter_left", "targetname" );
	leftShutters = array_combine( leftShutters, array );

	array = GetEntArray( "shutter_right_open", "targetname" );
	leftShutters = array_combine( leftShutters, array );

	array = GetEntArray( "shutter_left_closed", "targetname" );
	leftShutters = array_combine( leftShutters, array );

	foreach ( shutter in leftShutters )
	{
		if ( shutter isTouching( volume ) )
			shutter delete();
	}

	rightShutters = [];
	array = GetEntArray( "shutter_right", "targetname" );
	rightShutters = array_combine( rightShutters, array );

	array = GetEntArray( "shutter_left_open", "targetname" );
	rightShutters = array_combine( rightShutters, array );

	array = GetEntArray( "shutter_right_closed", "targetname" );
	rightShutters = array_combine( rightShutters, array );
	
	foreach ( shutter in rightShutters )
	{
		if ( shutter isTouching( volume ) )
			shutter delete();
	}
*/
}

paired_death_restart()
{
	level notify( "paired_death_restart" );
	level.paired_death_group = [];
	level.paired_death_max_distance = 512;
}

paired_death_think()
{
	level endon( "paired_death_restart" );
	self thread paired_death_add();
	self waittill_either( "death", "damage" );
	
	// shoot my buddy
	orig = self.origin;
	
	if ( !isdefined( orig ) )
		return;
		
	wait( 0.3 );
	if ( level.paired_death_group.size > 0 )
	{
		enemies = level.paired_death_group;
		enemies = array_removedead( enemies );
		enemies = SortByDistance( enemies, orig );
		
		foreach ( e in enemies )
		{	
			if ( e != self )
			{
				if ( Distance2D( e.origin, orig ) < level.paired_death_max_distance )
				{
					sandman_stealth_shot( e );
				}
				break;
			}
		}
	}
}

paired_death_wait_flag( flagname )
{
	if ( flag( flagname ) )
		return;
		
	level endon( flagname );
	while ( level.paired_death_group.size > 0 )
	{
		wait( 0.05 );
	}
	
	thread flag_set( flagname );
}

paired_death_wait()
{
	while ( level.paired_death_group.size > 0 )
	{
		wait( 0.05 );
	}
}

paired_death_add()
{
	if ( !IsDefined( level.paired_death_group ) )
		level.paired_death_group = [];
	
	level.paired_death_group[ level.paired_death_group.size ] = self;
	self waittill( "death" );
	level.paired_death_group = array_remove( level.paired_death_group, self );
}

sandman_stealth_shot( guy )
{
	level.sandman stealth_shot( guy );
	level notify( "other_guy_died" );
}

stealth_custom()
{
	self maps\_stealth_utility::stealth_plugin_basic();

	if ( IsPlayer( self ) )
		return;

	switch( self.team )
	{
		case "axis":
		case "team3":
			self maps\_stealth_utility::stealth_plugin_threat();
			self maps\_stealth_utility::stealth_enable_seek_player_on_spotted();
			self stealth_corpse_enemy_main();
			self maps\_stealth_utility::stealth_plugin_event_all();

			threat_array[ "warning1" ] = maps\_stealth_threat_enemy::enemy_alert_level_warning2;
			threat_array[ "attack" ] = ::Small_Goal_Attack_Behavior;
			self stealth_threat_behavior_custom( threat_array );
			
			stealth_plugin_event_flashbang( ::enemy_event_reaction_flashbang_custom, maps\_stealth_animation_funcs::enemy_animation_nothing );
			break;

		case "allies":
			array = [];
			array[ "hidden" ] = ::custom_friendly_hidden;
			array[ "spotted" ] = ::custom_friendly_spotted;
			self maps\_stealth_utility::stealth_plugin_aicolor( array );
			self maps\_stealth_utility::stealth_plugin_accuracy();
			self maps\_stealth_utility::stealth_plugin_smart_stance();
	}
}

Small_Goal_Attack_Behavior()
{
	self.pathrandompercent = 200;
	self notify( "clear_idle_anim" );
	self thread disable_cqbwalk();
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	

	self.goalradius = 400;

	self endon( "death" );
	wait( RandomFloatRange( 10, 30 ) );
	
	self ent_flag_set( "_stealth_override_goalpos" );

	self.favoriteenemy = level.player;
	self GetEnemyInfo( level.player );

	while ( isdefined( self.enemy ) && self ent_flag( "_stealth_enabled" ) )
	{
		self setgoalpos( self.enemy.origin );

		wait 4;
	}
}

enemy_alert_level_attack_custom()
{
	self.ignoreme = false;
	self.ignoreall = false;
	self thread maps\_stealth_shared_utilities::enemy_announce_spotted( self.origin );
	
	if ( isdefined( self.script_goalvolume ) )
		self thread maps\_spawner::set_goal_volume();
	else
		self maps\_stealth_threat_enemy::enemy_close_in_on_target();
}

enemy_event_reaction_flashbang_custom( type )
{
	origin = self._stealth.logic.event.awareness_param[ type ];

	// hack to get around code bug
	if ( self isFlashed() && self.script == "<custom>" )
	{
		wait 0.05;
		self SetFlashBanged( true );
	}

	wait 0.05;
	if ( self.script == "flashed" )
		self waittill( "stop_flashbang_effect" );

	node = self maps\_stealth_shared_utilities::enemy_find_free_pathnode_near( origin, 300, 40 );// 2
	
	if ( isdefined( node ) )
	{
		self thread maps\_stealth_shared_utilities::enemy_announce_wtf();
		self thread maps\_stealth_shared_utilities::enemy_announce_spotted_bring_group( origin );
	}

	flag_set( "_stealth_spotted" );

	self maps\_stealth_event_enemy::enemy_investigate_position( node );
}

custom_friendly_hidden()
{
	self.goalradius = 16;
	self disable_surprise();
	self disable_ai_color();
	self.fixednode = true;
	self.ignoreme = true;
//	self PushPlayer( true );
}

custom_friendly_spotted()
{
	self.goalradius = 512;
	self enable_surprise();
	self disable_ai_color();
	self disable_cqbwalk();
	self notify( "clear_idle_anim" );
	self.moveplaybackrate = 1.0;
	self AllowedStances( "stand", "crouch", "prone" );
	self.fixednode = false;
//	self PushPlayer( false );
	self.ignoreme = false;
	self.ignoreall = false;
}

stop_anim_on_spotted( ent, animation )
{
	self endon( "death" );
	ent endon( animation );
	flag_wait( "_stealth_spotted" );
	self StopAnimScripted();
}

sandman_follow_path()
{
	self waittill( "trigger" );
	self script_delay();
	level.sandman follow_path_waitforplayer( self get_target_ent() );
}

active_patrol( patrol_walk_anim )
{
		if ( IsDefined( self.animation ) )
			self.patrol_walk_anim = self.animation;
		else
			self.patrol_walk_anim = "active_patrolwalk_v2";

		if ( IsDefined( patrol_walk_anim ) )
			self.patrol_walk_anim = patrol_walk_anim;

		if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "spotlight" )
			useSpotlight = 1;
		else if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "oldflashlight" )
			useSpotlight = 2;
		else
			useSpotlight = 0;
			
		if ( IsSubStr( self.patrol_walk_anim, "active_patrolwalk_v" ) && !isdefined( self.flashlight ) )
			self thread attachFlashlight_removeOnSpotted( useSpotlight );
			
		self maps\_patrol::patrol();
}

attachFlashlight( useSpotlight )
{
	attach_tag = "TAG_INHAND";
	self.flashlight = Spawn( "script_model", self.origin );
	flashlight = self.flashlight;
	
	flashlight.owner = self;
	flashlight.origin = self GetTagOrigin( attach_tag );
	flashlight.angles = self GetTagAngles( attach_tag );
	flashlight SetModel( "com_flashlight_off" );
	flashlight LinkTo( self, attach_tag );
	
		
	if ( !IsDefined( useSpotlight ) )
		self.useSpotlight = 0;
	else
		self.useSpotlight = useSpotlight;
		
	self thread flashlight_think();
}

attachFlashlight_removeOnSpotted( useSpotlight )
{
	self attachFlashlight( useSpotlight );
	flashlight = self.flashlight;
	
	wait( 0.1 );
	self notify( "flashlight_on" );
	self thread remove_flashlight_on_alert();
	self waittill_any( "death", "remove_flashlight", "enemy" );
	wait( 0.1 );
	if ( IsAlive( self ) )
	{
		self notify( "flashlight_off" );
		self notify( "stop_flashlight_thread" );
		self clear_run_anim();
		//self set_generic_run_anim( "patrol_walk" );
	}
	flashlight Delete();
}

remove_flashlight_on_alert()
{
	self endon( "death" );
	self endon( "remove_flashlight" );
	
	while ( 1 )
	{
		/*self waittill( "_stealth_enemy_alert_level_change", type );
		
		_type = type;
		if ( IsSubStr( type, "warning" ) )
			_type = "warning";
		
		switch ( _type )
		{
			case "warning":
			case "alert":
				self notify( "remove_flashlight" );
				break;
		}
		*/
		self ent_flag_waitopen( "_stealth_normal" );
		self notify( "remove_flashlight" );		
	}
}

flashlight_think()
{
	self endon( "death" );
	self endon( "remove_flashlight" );
	self endon( "stop_flashlight_thread" );
	
	flashlight = self.flashlight;

	while ( 1 )
	{
		self waittill( "flashlight_on" );
		
		if ( self.useSpotlight == 1 )
			fxname = "flashlight_spotlight";
		else if ( self.useSpotlight == 2 )
			fxname = "flashlight";
		else
			fxname = "flashlight_spotlight_cheap";

		self.flashlight SetModel( "com_flashlight_on" );
		if ( self.useSpotlight == 1 )
		{
			flashlight spot_light( fxname, fxname + "_cheap", "tag_light", flashlight );
			self StartIgnoringSpotLight();
			self waittill( "flashlight_off" );
			self StopIgnoringSpotLight();
			if ( level.last_spot_light.entity == flashlight )
				stop_last_spot_light();
			else
				fxname = fxname + "_cheap";
		}
		else
		{
			PlayFXOnTag( getfx( fxname ), flashlight, "tag_light" );
			self waittill( "flashlight_off" );
		}
		self.flashlight SetModel( "com_flashlight_off" );
		StopFXOnTag( getfx( fxname ), flashlight, "tag_light" );
	}
}

stealth_range_trigger()
{
	self endon( "death" );
	if ( !IsDefined( self.start_color ) )
		return;
	
	level.player.isTouchingRangeTrigger = false;
	level.player.rangeTriggerOverride = false;
	
	hidden = [];
	hidden[ "prone" ]	 = self.start_color[ 2 ];
	hidden[ "crouch" ]	 = self.start_color[ 1 ];
	hidden[ "stand" ]	 = self.start_color[ 0 ];
	
	while ( 1 )
	{
		self waittill( "trigger" );

		if ( !level.player.rangeTriggerOverride )
		{
			while ( level.player IsTouching( self ) && !level.player.rangeTriggerOverride )
			{
				maps\_stealth_visibility_system::system_set_detect_ranges( hidden );
				level.player.isTouchingRangeTrigger = true;
				wait( 0.1 );
			}
			
			level.player.isTouchingRangeTrigger = false;
			wait( 0.2 );
			
			if ( !level.player.isTouchingRangeTrigger && !level.player.rangeTriggerOverride )
				maps\_stealth_visibility_system::system_default_detect_ranges();
		}
	}
}

/* 
CUSTOM CORPSE STUFF - because we don't want enemies caring about dead civs
*/

stealth_corpse_enemy_main()
{
	self maps\_stealth_corpse_enemy::enemy_init();

	self thread enemy_corpse_logic();
	self thread maps\_stealth_corpse_enemy::enemy_Corpse_Loop();
}

enemy_corpse_logic()
{
	self endon( "death" );
	self endon( "pain_death" );
	self endon( "stop_corpse_search" );

	self thread maps\_stealth_corpse_enemy::enemy_corpse_found_loop();
	while ( 1 )
	{
		if ( self ent_flag_exist( "_stealth_behavior_asleep" ) )
			self ent_flag_waitopen( "_stealth_behavior_asleep" );

		self ent_flag_wait( "_stealth_enabled" );

		while ( !self stealth_group_spotted_flag() && !self ent_flag( "_stealth_attack" ) )
		{
			found = false;
			saw = false;
			corpse = undefined;
			dist = undefined;

			corpseArray = GetCorpseArray();
			
			for ( i = 0; i < corpseArray.size; i++ )
			{
				corpse = corpseArray[ i ];
				
				if ( IsSubStr( corpse.classname, "civilian" ) )
					continue;
				
				if ( IsDefined( corpse.found ) )
					continue;

				if ( !IsDefined( level.corpse_behavior_doesnt_require_player_sight ) )
					if ( !maps\_stealth_corpse_enemy::player_can_see_corpse( corpse.origin ) )
						continue;

				distsqrd = DistanceSquared( self.origin, corpse.origin );
				heightdiff = abs( self.origin[2] - corpse.origin[2] );
				ht = 256;
				if ( self.type != "dog" )
					dist = level._stealth.logic.corpse.found_distsqrd;
				else
					dist = level._stealth.logic.corpse.found_dog_distsqrd;

				// can't find corpses that are at different elevations
				if ( heightdiff > ht )
					continue;
					
				// are we so close that we actually found one?
				if ( distsqrd < dist )
				{
					found = true;
					break;
				}

				//that's the only check for finding a guy - now lets see if we just see anyone
				//and make sure not to make any duplicates...we don't want to notify seeing the 
				//same corpse multiple times

				//have we already seen this guy?
				if ( IsDefined( self._stealth.logic.corpse.corpse_entity ) )
				{
					if ( self._stealth.logic.corpse.corpse_entity == corpse )
						continue;

					//ok so it's a new guy - is this one closer than the one we already have?
					distsqrd2 = DistanceSquared( self.origin, self._stealth.logic.corpse.corpse_entity.origin );
					if ( distsqrd2 <= distsqrd )
						continue;
				}

				//are we close enough to check?
				if ( distsqrd > level._stealth.logic.corpse.sight_distsqrd )
					continue;

				//ok how about close enough to automatically see one?
				if ( distsqrd < level._stealth.logic.corpse.detect_distsqrd )
				{
					//do we have clear line of sight to the corpse
					if ( self CanSee( corpse ) )
					{
						saw = true;
						break;
					}
				}

				//if not do we happen to look at him at this distance?
				angles = self GetTagAngles( "tag_eye" );
				origin = self GetEye();

        sight = AnglesToForward( angles );
				vec_to_corpse	= VectorNormalize( corpse.origin - origin );

				//are we looking towards a corpse
				if ( VectorDot( sight, vec_to_corpse ) > 0.55 )
				{
					//do we have clear line of sight to the corpse
					if ( self CanSee( corpse ) )
					{
						saw = true;
						break;
					}
				}
			}
			
			if ( found )
			{
				if ( !ent_flag( "_stealth_found_corpse" ) )
					self ent_flag_set( "_stealth_found_corpse" );
				else
					self notify( "_stealth_found_corpse" );

				//if he found it then we can clear his seeing one
				self ent_flag_clear( "_stealth_saw_corpse" );

				self thread maps\_stealth_corpse_enemy::enemy_corpse_found( corpse );

				self notify( "awareness_corpse", "found_corpse", corpse );
			}
			else if ( saw )
			{
				self._stealth.logic.corpse.corpse_entity = corpse;
				self._stealth.logic.corpse.origin = corpse.origin;

				if ( !ent_flag( "_stealth_saw_corpse" ) )
					self ent_flag_set( "_stealth_saw_corpse" );
				else
					self notify( "_stealth_saw_corpse" );

				level notify( "_stealth_saw_corpse" );
				self notify( "awareness_corpse", "saw_corpse", corpse );
			}

			wait 0.5;// was .05
		}

		self maps\_stealth_corpse_enemy::remove_corpse_loop_while_stealth_broken();
		self stealth_group_spotted_flag_waitopen();
		self ent_flag_waitopen( "_stealth_attack" );
	}
}

delete_triggerer()
{
	while ( 1 )
	{
		self waittill( "trigger", triggerer );
		if ( isdefined( triggerer ) )
		{
			if ( !flag( "_stealth_spotted" ) )
			{
				if ( IsDefined( triggerer.last_patrol_goal ) )
				{
					triggerer.last_patrol_goal.patrol_claimed = undefined;
				}
				triggerer notify( "remove_flashlight" );
				triggerer Delete();
			}
		}
		wait( 0.5 );
	}
}

notify_on_death_or_damage( note )
{
	self waittill_either( "death", "damage" );
	level notify( note );
}

stop_anim_on_death_or_damage()
{
	self waittill_either( "death", "damage" );
	self StopAnimScripted();
}

death_notify()
{
	self waittill( "death", killer );

	if ( !flag( "sandman_killfirms" ) )
		return;

	if ( !IsDefined( killer ) )
		return;
	
	wait( 1.0 );
	
	if ( GetTime() - level.last_killfirm_time < level.last_killfirm_timeout )
		return;
		
	if ( killer == level.player && self was_headshot() )
	{
		if ( flag( "_stealth_spotted" ) == false && enemies_are_unaware() && maps\_stealth_utility::stealth_is_everything_normal() )
		{
			if ( GetTime() - level.last_killfirm_time < level.last_killfirm_timeout )
				return;			
			level.last_killfirm_time = GetTime();
			radio_dialogue( "prague_killfirm_player_" + RandomIntRange( 1, 4 ) );
		}
	}
	else if ( killer == level.sandman )
	{
		if ( GetTime() - level.last_killfirm_time < level.last_killfirm_timeout )
			return;			
		level.last_killfirm_time = GetTime();
		radio_dialogue( "prague_killfirm_other_" + RandomIntRange( 1, 5 ) );
	}
}

was_headshot()
{
	if ( !IsDefined( self.damageLocation ) )
	{
		return false;
	}
	
	return( self.damageLocation == "helmet" || self.damageLocation == "head" || self.damageLocation == "neck" );
}

physics_explosion_trigger()
{
	self waittill( "trigger" );
	node = self get_Target_ent();
	
	if ( IsDefined( self.script_radius ) )
		script_radius = self.script_radius;
	else
		script_radius = 0;
	
	PhysicsExplosionSphere( node.origin, node.radius, script_radius, self.script_burst );
	
	self Delete();
}

sandman_spotted_notify()
{
	self endon( "death" );
	level.got_spotted = false;
	level.spotted_times = 0;
	while ( self ent_flag( "_stealth_enabled" ) )
	{
		flag_wait( "_stealth_spotted" );
		if ( flag( "sandman_announce_spotted" )  )
		{
			level.got_spotted = true;
			level.spotted_times = ( level.spotted_times%3 ) + 1;
			
			if ( flag( "start_alcove" ) )
				thread display_hint_timeout( "short_scope", 8 );
			radio_dialogue_stop();
			
			if ( !flag( "player_out_of_water" ) )
				radio_dialogue_interupt( "prague_pri_compromised" );
			else
				radio_dialogue_interupt( "prague_spotted_" + level.spotted_times );
		}
		flag_waitopen( "_stealth_spotted" );
	}
}

sandman_end_encounter( dialogue )
{
	if ( level.got_spotted )
	{
		radio_dialogue( "prague_recover_" + level.spotted_times );
		level.got_spotted = false;
	}
	else
	{
		wait( 1.1 );
		radio_dialogue( dialogue );
	}
}

kill_me()
{
	wait( 0.5 );
	self script_delay();
	self Kill();
}

drone_assign_unique_death( deatharray )
{
	if ( !IsDefined( deatharray ) )
		deatharray = level.drone_deaths;
	self.deathanim = deatharray[ RandomIntRange( 0, deatharray.size ) ];
	self.noragdoll = true;
	self NotSolid();
	
	if ( !IsDefined( self.moveplaybackrate ) )
		self.moveplaybackrate = 1.0;
	
	movespeed = self.moveplaybackrate;
	self.moveplaybackrate = RandomFloatRange( movespeed * 0.8, movespeed );
	self thread drone_proper_death();
}

drone_proper_death()
{	
	self waittill_either( "death", "damage" );
	
	if ( !isdefined( self ) || isdefined(self.skipdeathfx) )
		return;
		
	thread play_sound_in_space( "generic_death_falling_scream", self.origin );
	if ( cointoss() )
	{
		num = RandomIntRange( 1, 3 );
		self bodyshot( "bodyshot" + num, "J_SpineUpper" );
	}
	else
	{
		num = RandomIntRange( 1, 3 );
		self bodyshot( "headshot" + num, "tag_eye" );
	}
	wait( 2.0 );
	self animscripts\death::play_blood_pool();
}

bodyshot( fx, tag )
{
	origin = self GetTagOrigin( tag );

	PlayFX( getfx( fx ), origin );
}

stealth_spotted_trigger()
{
	special_volume = get_Target_ent( "inside_white_building_volume" );
	while ( 1 )
	{
		self waittill( "trigger", other );
		if ( other == level.player && !( level.player isTouching( special_volume ) ) )
			break;
	}
	
	flag_set( "_stealth_spotted" );
	flag_set( "btr_spotted" );
	
	level.sandman.ignoreMe = false;
	level.sandman.ignoreAll = false;
	
	level.player.ignoreMe = false;
	level.sandman notify( "remove_bulletshield" );
	
	ai = GetAIArray( "axis" );
	foreach ( a in ai )
	{
		a StopAnimScripted();
		a.favoriteenemy = level.player;
		a.ignoreMe = false;
		a SetGoalEntity( level.player );
	}
	
	wait( 4 );
	PlayFx( getfx( "tank_impact_exaggerated" ), level.player.origin );
		wait( 0.1 );
	level.player kill();
}


attack_player_on_spotted()
{
	self endon( "death" );
	if ( isdefined( self._stealth ) )
	{
		self ent_flag_clear( "_stealth_enabled" );
	}
	self.ignoreall = true;
	self.ignoreMe = true;
	self set_battlechatter( false );
	self waittill( "awake" );
	if ( isdefined( self._stealth ) )
	{
		self ent_flag_set( "_stealth_enabled" );
		self ent_flag_clear( "_stealth_bad_event_listener" );
	}
	else
	{
		self thread stealth_custom();
	}
	self ClearEnemy();
	self.ignoreall = false;
	self endon( "cancel_spotted_reaction" );
	flag_wait( "_stealth_spotted" );
	self clear_run_anim();
	self allowedStances( "stand", "crouch", "prone" );
	self.disableArrivals = false;
	self.disableExits = false;
	self.moveplaybackrate = 1.0;
	self.ignoreMe = false;
	self.ignoreAll = false;
	self.baseaccuracy = 999999;
	self.favoriteenemy = level.player;
}

btr_attack_player_on_spotted()
{
	self endon( "death" );
	self endon( "cancel_spotted_reaction" );
	thread btr_attack_player_on_flag( "_stealth_spotted" );
	while( 1 )
	{
		self waittill( "damage", damage, attacker );
		if ( attacker == level.player )
		{
			flag_set( "_stealth_spotted" );
			break;
		}
	}
}

btr_attack_player_on_flag( flagname )
{
	foreach ( turret in self.mgturret )
		turret notify( "stop_burst_fire_unmanned" );
	self endon( "death" );
	self waittill( "awake" );
	while( 1 )
	{
		flag_wait( flagname );
		self notify( "stop_random_fire" );
		self.ignoreMe = false;
		self.ignoreAll = false;
		self.baseaccuracy = 9999;
		self.favoriteenemy = level.player;
		foreach ( turret in self.mgturret )
			turret thread maps\_mgturret::burst_fire_unmanned();
		self thread btr_target_player();
		
		flag_waitopen( flagname );
		
		foreach ( turret in self.mgturret )
			turret notify( "stop_burst_fire_unmanned" );
		self notify( "stop_shooting" );
	}
}

btr_target_player()
{
	self endon( "death" );
	self endon( "stop_shooting" );
	self Vehicle_SetSpeedImmediate( 0.0, 5.0 );
	if ( IsDefined( self.fxtag ) )
	{
		StopFXOnTag( getfx( "heli_spotlight_cheap" ), self, self.fxtag );
		StopFXOnTag( getfx( "heli_spotlight" ), self, self.fxtag );
	}

	self SetTurretTargetEnt( level.player );
	wait( 1.5 );
	while ( IsAlive( level.player ) )
	{
		self SetTurretTargetEnt( level.player ); //randomvec was 50
		if ( self can_see_player() )
			self fire_at_target();
		wait( 0.3 );
	}
}

fire_at_target()
{
	burstsize = RandomIntRange( 2, 15 );
	//println("         **HITTING PLAYER, burst: " + burstsize );
	fireTime = 0.1;
	for ( i = 0; i < burstsize; i++ )
	{
		self FireWeapon();
		wait fireTime;
	}
}

can_see_player()
{	
	player = level.player;
	tag_flash_loc = self GetTagOrigin( "tag_flash" );
	//BulletTracePassed( <start>, <end>, <hit characters>, <ignore entity> );
	player_eye = player GetEye();
	if ( SightTracePassed( tag_flash_loc, player_eye, false, self ) )
	{
		if ( IsDefined( level.debug ) )
			Line( tag_flash_loc, player_eye, ( 0.2, 0.5, 0.8 ), 0.5, false, 60 );
		return true;
	}
	else
	{
		//println( "        ---trace failed" );
		return false;
	}
}

sandman_clear_run_anim_trigger()
{
	self waittill( "trigger" );
	level.sandman clear_run_anim();
}

cargo_heli_think()
{
	if ( !flag( "start_sewers" ) )
	{
		self notify( "stop_kicking_up_dust" );
		waitframe();
	}
	cargo = GetEntArray( self.script_noteworthy, "targetname" );
	self.cargo = cargo;

	btr = undefined;
	foreach ( c in self.cargo )
	{
		if ( IsSubStr( c.model, "vehicle" ) )
			btr = c;
		c LinkTo( self );
		c Show();
	}
	
	if ( !flag( "start_sewers" ) )
		self thread maps\_vehicle::aircraft_dust_kickup( btr );		
		
	self waittill( "death" );
	foreach ( c in self.cargo )
	{
		c Delete();
	}		

}

idle_spawner_trigger()
{
	self waittill( "trigger" );
	spawners = getentarray( self.target, "targetname" );
	foreach( t in spawners )
	{
		structs = getstructarray_delete( t.script_noteworthy, "script_noteworthy" );
		foreach ( s in structs )
		{
			guy = t spawn_ai();
			guy.origin = s.origin;
			guy.angles = s.angles;
	
			guy gunless_anim_check( s.animation );
			switch( s.animation )
			{
				case "roadkill_cover_radio_soldier3":
					guy hero_head();
					guy attach( "mil_mre_chocolate01", "TAG_INHAND", 1 );
				break;
				case "training_basketball_rest":
					guy hero_head();
					guy attach( "com_bottle2", "TAG_INHAND", 1 );
				break;
			}
			s thread anim_generic_loop( guy, s.animation );
		}
	}
}

dead_body_spawner_trigger()
{
	self waittill( "trigger" );
	t = self get_target_ent();
	structs = getstructarray_delete( t.script_noteworthy, "script_noteworthy" );
	foreach ( s in structs )
	{
		guy = t spawn_ai();
	//	guy thread deletable_magic_bullet_shield();
		guy.origin = s.origin;
		guy.angles = s.angles;
		guy SetCanDamage( false );
		
		anime = level.scr_anim[ "generic" ][ s.animation ];
		if ( IsArray( anime ) )
			anime = anime[ 0 ];
			
		guy gunless_anim_check( s.animation );
		guy AnimScripted( "endanim", s.origin, s.angles, anime );
		if ( isdefined( s.script_parameters ) )
		{
			if ( s.script_parameters == "notsolid" )
			{
				guy NotSolid();
			}
			if ( s.script_parameters == "ripples" )
			{
				guy thread ripples_on_body();
			}
		}
		
		if ( issubstr( s.animation, "death" ) )
			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
	}
}

ripples_on_body()
{
	self endon( "death" );
	wait( 0.1 );
	n = get_target_ent( "water_level_org" );
	org = ( self.origin[ 0 ], self.origin[ 1 ], n.origin[ 2 ]-1 );
	while( 1 )
	{
		PlayFX( getfx( "water_movement" ), org );
		wait( RandomFloatRange( 0.5, 1 ) );
	}
}

#using_animtree( "generic_human" );

custom_animset_run_move()
{
	initAnimSet = [];
	initAnimSet[ "sprint" ] = %sprint_loop_distant;
	initAnimSet[ "sprint_short" ] = %sprint1_loop;
	initAnimSet[ "prone" ] = %prone_crawl;

	initAnimSet[ "straight" ] = %run_lowready_F;
	
	initAnimSet[ "move_f" ] = %walk_forward;
	initAnimSet[ "move_l" ] = %walk_left;
	initAnimSet[ "move_r" ] = %walk_right;
	initAnimSet[ "move_b" ] = %walk_backward; //this looks too fast to be natural
	
	initAnimSet[ "crouch" ] = %crouch_sprint;
	initAnimSet[ "crouch_l" ] = %crouch_fastwalk_L;
	initAnimSet[ "crouch_r" ] = %crouch_fastwalk_R;
	initAnimSet[ "crouch_b" ] = %crouch_fastwalk_B;
	
	initAnimSet[ "stairs_up" ] = %traverse_stair_run_01;
	initAnimSet[ "stairs_down" ] = %traverse_stair_run_down;
	
	anim.animsets.move[ "run" ] = initAnimSet;	
}

turn_on_streetlight_trigger()
{
	self waittill( "trigger" );
	ent = self get_target_ent();
	
	ent spot_light( "streetlamp_spotlight", "flashlight_spotlight_cheap", "tag_origin" );
}

remove_ignore_trigger()
{
	self waittill( "trigger" );
	ai = getaiarray( "axis" );
	guys = [];
	foreach ( a in ai )
	{
		if ( a isTouching( self ) )
		{
			a.ignoreall = false;
			guys = array_add( guys, a );
		}
	}
	wait( 2.0 );
	self script_delay();
	guys = array_removeDead( guys );
	if ( guys.size > 0 )
		flag_set( "_stealth_spotted" );
}

build_heli_rumble_unique()
{
	self build_rumble_unique( "tank_rumble", 0.3, 2.5, 512, 1, 1 );
	wait( 0.1 );
	self.rumbleon = true;
	foreach ( c in self.cargo )
	{
		if ( IsSubStr( c.model, "vehicle" ) )
		{
			c.vehicle_rumble_unique = self.vehicle_rumble_unique;
			c thread vehicle_rumble_even_if_not_moving();
		}	
	}
}

vehicle_rumble_even_if_not_moving()
{
// makes vehicle rumble

	self endon( "kill_rumble_forever" );
	
	classname = self.classname;
	if ( is_iw4_map_sp() )
		classname = self.vehicletype;
		
	rumblestruct = undefined;
	if ( IsDefined( self.vehicle_rumble_unique ) )
	{
		rumblestruct = self.vehicle_rumble_unique;
	}
	else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble_override;
	}
	else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble[ classname ];
	}

	if ( !IsDefined( rumblestruct ) )
	{
		return;
	}

	height = rumblestruct.radius * 2;
	zoffset = -1 * rumblestruct.radius;
	areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger EnableLinkTo();
	areatrigger LinkTo( self );
	self.rumbletrigger = areatrigger;
	self endon( "death" );
// 	( rumble, scale, duration, radius, basetime, randomaditionaltime )

	//.rumbleon is not used anywhere else 
	//and the current behavior is to turn it on by default but respect it if someone turns it off
	if ( !IsDefined( self.rumbleon ) )
		self.rumbleon = true;
		
	if ( IsDefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale;
	else
		self.rumble_scale = 0.15;

	if ( IsDefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration;
	else
		self.rumble_duration = 4.5;

	if ( IsDefined( rumblestruct.radius ) )
	{
		self.rumble_radius = rumblestruct.radius;
	}
	else
	{
		self.rumble_radius = 600;
	}

	if ( IsDefined( rumblestruct.basetime ) )
	{
		self.rumble_basetime = rumblestruct.basetime;
	}
	else
	{
		self.rumble_basetime = 1;
	}

	if ( IsDefined( rumblestruct.randomaditionaltime ) )
	{
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	}
	else
	{
		self.rumble_randomaditionaltime = 1;
	}

	areatrigger.radius = self.rumble_radius;
	while ( 1 )
	{
		areatrigger waittill( "trigger" );
		if ( !self.rumbleon )
		{
			wait 0.1;
			continue;
		}

		self PlayRumbleLoopOnEntity( rumblestruct.rumble );

		while ( level.player IsTouching( areatrigger ) && self.rumbleon )
		{
			Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( rumblestruct.rumble );
	}
}

door_shut_trigger()
{
	door = self get_target_ent();
	angle1 = door.angles;
	angle2 = door.angles - (0,75,0);
	door rotateTo( angle2, 0.5 );
	
	self waittill( "trigger" );
	self script_delay();
	
	door rotateTo( angle1, 0.3 );
}

shop_junk_shake()
{
	self endon( "death" );
	self thread delete_on_notify();
	level endon( "level_cleanup" );
	level endon( "_stealth_spotted" );
	i = [ -1, 1 ];
	j = 0;
	old_org = self.origin;
	roll = IsSubstr( self.model, "bottle" );
	if ( isdefined( self.script_parameters ) )
		roll = ( self.script_parameters != "not_roll" );
	
	rotate = true;
	if ( isdefined( self.script_parameters ) )
		rotate = ( self.script_parameters != "not_rotate" );
		
	if ( cointoss() )
	{
		while( 1 )
		{
			time = 0.05;
			if ( rotate )
			{
				self.angles = self.angles + (0, RandomFloatRange(-1, 2), 0);
				if ( roll )
					self.angles = self.angles + (RandomFloatRange(-1, 3), 0, 0);
			}
			self.origin = old_org + ( RandomFloatRange( -0.05, 0.05 ), RandomFloatRange( -0.05, 0.05 ), RandomFloatRange(0,0.05));
			wait( time );
		}
	}
	else
	{
		while( 1 )
		{
			time = 0.05;
			if ( rotate )
			{
				self.angles = self.angles + (0, RandomFloatRange(-2, 1), 0);
				if ( roll )
					self.angles = self.angles + (RandomFloatRange(-3, 1), 0, 0);
			}
			self.origin = old_org + ( RandomFloatRange( -0.05, 0.05 ), RandomFloatRange( -0.05, 0.05 ), RandomFloatRange(0,0.05));
			wait( time );
		}
	}
}

stealth_busted_music()
{
	level endon( "stop_stealth_busted_music" );
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		music_play( "prague_busted_1" );
		flag_waitopen( "_stealth_spotted" );
		music_stop( 3 );
	}
}

physics_jolt_trigger()
{
	self waittill( "trigger" );
//	self script_delay();
	
	tank = get_vehicle( "apt_btr_backup", "targetname" );
	
	tank FireWeapon();
	Earthquake( self.script_physics * 3, 0.6, self.origin, self.radius * 1.5 );
	
	node = getstructarray( self.target, "targetname" );
	foreach ( n in node )
	{
		if ( cointoss() )
			num = RandomFloatRange( 0.1, 0.2 );
		else
			num = RandomFloatRange( 0.4, 0.6 );
			
		delayThread( num, ::_Physics_Jitter, n.origin, n.radius, n.radius * 0.5, self.script_physics * 0.5, self.script_physics);
		if ( isdefined( n.script_fxid ) )
			fxid = n.script_fxid;
		else
			fxid = "ceiling_dust_default";
		delayThread( num + RandomFloatRange( -1*num, 0.5 ), ::_play_fx, getfx( fxid ), n.origin );
	}
	lights = getentarray( self.script_parameters, "targetname" );
	foreach ( l in lights )
	{
		l.old_intensity = l GetLightIntensity();
		thread flickering_light( l, 0.2, 0.8 );
		thread moving_light( l, 4 );
	}
	wait( 1.0 );
	foreach ( l in lights )
	{
		l notify( "stop_flicker" );
		l notify( "stop_movement" );
		l setLightIntensity( l.old_intensity * RandomFloatRange( 0.7, 1.0 ) );
		if ( cointoss() )
			wait( RandomFloatRange( 0, 0.5 ) );
	}
}

_play_fx( id, org )
{
	PlayFX( id, org );
}

_physics_jitter( org, rad_outer, rad_inner, min_dis, max_dis )
{
	PhysicsJitter( org, rad_outer, rad_inner, min_dis, max_dis );
}

drone_give_weaponsound( drone )
{
	drone.weaponsound = undefined;
	iRand = randomintrange( 1, 4 );
	
	//assign drone a random weapon for sound variety
	{
		if( iRand == 1 )
			drone.weaponsound = "drone_ak47_fire_npc";
		else if( iRand == 2 )
			drone.weaponsound = "drone_g36c_fire_npc";
		if( iRand == 3 )
			drone.weaponsound = "drone_fnp90_fire_npc";
	}
}

// jeremy l added one key value pair to keep track of ai for prague
get_living_ai_array_parameters( name, type ) 
{
	ai = GetAISpeciesArray( "all", "all" );

	array = [];
	foreach ( actor in ai )
	{
		if ( !isalive( actor ) )
			continue;

		switch( type )
		{
			case "targetname":{
				if ( IsDefined( actor.targetname ) && actor.targetname == name )
					array[ array.size ] = actor;
			}break;
		 	case "parameters":{
				if ( IsDefined( actor.script_parameters ) && actor.script_parameters == name )
					array[ array.size ] = actor;
			}break;
		}
	}
	return array;
}

stagger_death()
{
	self waittill( "death" );
	
	if ( !isdefined( self ) )
		return;
	
	time = getAnimLength( self.deathanim ) * 0.3 ;
	self random_bloodspurt( time );
}

random_bloodspurt( time, tags )
{	
	if ( !isdefined( tags ) )
		tags = [ "j_spinelower", "j_spineupper", "j_shoulder_le", "j_shoulder_ri", "j_head" ];
	
	fxs = [ "bodyshot1", "bodyshot2", "headshot1", "headshot2" ];
	
	elapsed = 0;
	
	while( time > elapsed )
	{
		fxname = fxs[ RandomIntRange( 0,fxs.size ) ];
		PlayFXOnTag( getfx( fxname ), self, tags[ RandomIntRange(0,tags.size) ] );
		t = RandomFloatRange( 0.1, 0.2 );
		wait( t );
		elapsed = elapsed + t;
	}
}

set_alert_on_movement( req_distance, volume, endon_flag, deathquote )
{
	level endon( endon_flag );
	level.sandman endon( "follow_path" );
	
	while( 1 )
	{
		dist = level.player GetNormalizedMovement();
		if ( Distance( ( 0, 0, 0 ), dist ) > req_distance )
		{				
			ai = getAIArray( "axis" );
			ai = sortbydistance( ai, level.player.origin );
			
			if ( ai.size > 0 )
			{
				if ( Distance2d( ai[ 0 ].origin, level.player.origin ) < 512 )
				{
					if ( !isdefined( volume ) || level.player isTouching( volume ) )
					{
						ai[ 0 ].favoriteenemy = level.player;
						ai[ 0 ] getEnemyInfo( level.player );	
						thread force_deathquote( deathquote );
						delayThread( 2.0, ::flag_set, "_stealth_spotted" );
						break;
					}
				}
			}	
		}
		wait( 0.2 );
	}
}

force_deathquote( deathquote )
{	
	if ( isdefined( deathquote ) )
	{
		level notify( "new_quote_string" );
		setDvar( "ui_deadquote", deathquote );
		level.player waittill( "death" );
		setDvar( "ui_deadquote", deathquote );
	}
}

assign_explosion_death()
{
	self waittill( "death" );
	if ( !isdefined( self ) )
		return;
	node = get_target_ent( "explosion_death_node" );
	node.radius = 512;
	
	dir = undefined;
	{
		angles_to_damage = VectorToAngles( self.origin - node.origin );
		self.damageyaw = angles_to_damage[ 1 ] - self.angles[ 1 ];
		
		if ( self.damageyaw > 180 )
			self.damageyaw = self.damageyaw - 360;
		if ( ( self.damageyaw > 135 ) || ( self.damageyaw <= -135 ) )	// Front quadrant
		{
			dir = "b"; // b is causing clipping issues
		}
		else if ( ( self.damageyaw > 45 ) && ( self.damageyaw <= 135 ) )		// Right quadrant
		{
			dir = "l";
		}
		else if ( ( self.damageyaw > - 45 ) && ( self.damageyaw <= 45 ) )		// Back quadrant
		{
			dir = "f";
		}
		else
		{															// Left quadrant
			dir = "r";
		}
					
		if ( IsDefined( dir ) )
		{
			num = RandomIntRange( 0, level.explosion_deaths[ dir ].size );
			self.deathanim = level.explosion_deaths[ dir ][ num ];
			self.noragdoll = undefined;
		}
	}
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

hero_head()
{
	self Detach( self.headModel, "" );

	if ( isdefined( self.hatmodel ) )
		self Detach( self.hatmodel, "" );	

	if ( issubstr( self.model, "female" ) )
		head = "head_london_female_b";
	else
	{
		model = "body_prague_civ_male_b";
		if ( cointoss() )
			model = model + "b";
		self setModel( model );
		head = random( level.male_heads );
	}
	self Attach( head, "", true );
	self.headModel = head;
}

// ELEVATOR STOLEN FROM DCBURNING

elevator_dude_think( spawner )
{
	/* sLoop = "dcburning_elevator_corpse_idle_A";
	sNudge = "dcburning_elevator_corpse_bump_A"; */
	sLoop = "dcburning_elevator_corpse_idle_B";
	sNudge = "dcburning_elevator_corpse_bump_B";
	self.allowdeath = false;
	self.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
	self.script_looping = 0;	
	self setcontents( 0 );
	self.ignoreme = true;
	self setlookattext( "", &"" );
	reference = getstruct( "elevator_body" , "script_noteworthy" );
	iAnimSwitched = 0;
	self hero_head();
	/* elevator_clip = getent( "elevator_clip", "targetname" );
	elevator_clip.origin = elevator_clip.origin + ( 0, 0, 32 ); */
	self stopanimscripted();
	while( !flag( "pre_courtyard_ally_clean_up" ) )
	{
		reference thread anim_generic_loop( self, sLoop, "stop_idle" );
		self waittill( "doors_closing" );
		reference notify( "stop_idle" );
		/*
		if ( ( flag( "player_looking_at_elevator" ) ) && ( isdefined( iAnimSwitched ) ) )
		{
			iAnimSwitched = undefined;
			reference anim_generic( self, "dcburning_elevator_corpse_trans_A_2_B" );
			
			sLoop = "dcburning_elevator_corpse_idle_B";
			sNudge = "dcburning_elevator_corpse_bump_B";
		}
		*/
		reference anim_generic( self, sNudge );
	}
	self delete();
}

elevator_start()
{
	spawner = getent( "elevator_guy", "targetname" );
	elevator_dude = spawner dronespawn();
	elevator_dude thread elevator_dude_think( spawner );
	elevator_door_left = getent( "elevator_door_left", "targetname" );
	elevator_door_right = getent( "elevator_door_right", "targetname" );
	elevator_door_left.startPos = elevator_door_left.origin;
	elevator_door_right.startPos = elevator_door_right.origin;
	
	movedistLeft = -28;
	movedistRight = 28;
	movetime = 2;
	
	musak_org = getent( "musak_org", "targetname" );
	musak_org playloopsound( "elev_musak_loop" );
	
	while( !flag( "pre_courtyard_ally_clean_up" ) )
	{
		thread play_sound_in_space( "elev_bell_ding", elevator_door_left.origin );
		thread play_sound_in_space( "elev_door_close", elevator_door_left.origin );
		elevator_door_left movex( movedistLeft, movetime, movetime / 2 );
		elevator_door_right movex( movedistRight, movetime, movetime / 2 );
		
		wait( movetime - .25 );
		elevator_dude notify( "doors_closing" );
		wait( .25 );
		
		thread play_sound_in_space( "elev_door_open", elevator_door_left.origin );
		elevator_door_left moveto( elevator_door_left.startPos, movetime, movetime / 2, movetime / 2 );
		elevator_door_right moveto( elevator_door_right.startPos, movetime, movetime / 2, movetime / 2 );
		
		wait( movetime );
		
		wait( 1.25 );
	}
	musak_org stoploopsound();
	musak_org delete();
}


player_ignore_trigger()
{
	while ( 1 )
	{
		self waittill( "trigger" );
		oldignoreme = level.player.ignoreme;
		if ( !flag( "_stealth_spotted" ) )
			level.player.ignoreme = true;
		while ( level.player IsTouching( self ) && !flag( "_stealth_spotted" ) )
			wait( 0.2 );
		if ( !flag( "_stealth_spotted" ) )
		{
			ai = getaiarray( "axis" );
			foreach ( a in ai )
			{
				a clearEnemy();
				a.oldignoreall = a.ignoreall;
				a.ignoreall = true;
			}
		}
		level.player.ignoreme = oldignoreme;
		wait( 0.1 );
		if ( !flag( "_stealth_spotted" ) )
		{
			ai = getaiarray( "axis" );
			foreach ( a in ai )
			{
				a clearEnemy();
				if ( isdefined( a.oldignoreall ) )
					a.ignoreall = a.oldignoreall;
			}
		}
	}
}


//force_flash_setup( times )
force_flash_setup()
{
	array = getentarray( "force_flash", "targetname" );
	level thread force_flash();
	array_thread( array, ::force_flash );
}

force_flash()
{
	self waittill( "trigger" );

		thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );
	
	if( IsDefined ( self.script_parameters ) && ( self.script_parameters == "1" ) )
	{
		level thread force_flash_extra();
	}
	else if( IsDefined ( self.script_parameters ) && ( self.script_parameters == "2" ) )
	{
		level thread force_flash_extra_two();
	}
}

force_flash_extra()
{
	wait( 0.9 );
	thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );	
}

force_flash_extra_two()
{
	wait( 2 );
	thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );
//	wait( 1 );
//	thread maps\_weather::lightningFlash( maps\prague_fx::lightning_normal, maps\prague_fx::lightning_flash );	
}

let_it_rain()
{
	level.rain_effect = "rain_heavy";
	level.player endon( "death" );
	level endon( "stop_rain" );
	
	while( 1 )
	{
		PlayFX( getfx( level.rain_effect ), level.player.origin + (0,0,1024) );
		wait( 1.0/3.0 );
	}
}

apartment_moans()
{
	nodes = getstructarray_delete( "moan_node", "targetname" );
	array_thread( nodes, ::moan_thread );
}

moan_thread()
{
	level endon( "start_apartment_exit" );
	while( 1 )
	{
		wait( RandomFloatRange( 1, 4 ) );
		play_sound_in_space( "prague_pain_door", self.origin );
	}
}

FLASHBANG_ALERT_RANGE = 1024;

flashbang_track_setup()
{
	NotifyOnCommand( "player_flashbang_out", "-smoke" );
	NotifyOnCommand( "player_flashbang_out", "+smoke" );

	level.player thread flashbang_track_setup_check();
}

flashbang_track_setup_check()
{
	while ( 1 )
	{
		//this one hit's as soon as the button is pressed - that's why we want
		//to set the flag here and not after the grenade has left the hand
		//with "grenade fire" 
		self waittill( "player_flashbang_out" );
		flag_set( "_stealth_player_nade" );
		
		self waittill( "grenade_fire", grenade );
		thread alert_nearby_enemies_on_death( grenade );
		thread maps\_stealth_visibility_system::player_grenade_check_dieout( grenade );
	}
}

alert_nearby_enemies_on_death( grenade )
{
	level endon( "_stealth_spotted" );
	if ( flag( "_stealth_spotted" ) )
		return;
	
	grenade waittill( "explode", org );
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		if ( a ent_flag_exist( "_stealth_enabled" ) && a ent_flag( "_stealth_enabled" ) )
		{
			if ( Distance( a.origin, org ) < FLASHBANG_ALERT_RANGE )
			{
				node = a maps\_stealth_shared_utilities::enemy_find_free_pathnode_near( org, 300, 40 );// 2
	
				a notify( "ai_event", "grenade danger", grenade ); // treat the flashbang like a grenade
				if ( isdefined( node ) )
				{
					a thread maps\_stealth_shared_utilities::enemy_announce_wtf();
					a maps\_stealth_event_enemy::enemy_investigate_position( node );
				}
			}
		}
	}
}

delete_after_delay( delay )
{
	wait( delay );
	if ( isdefined( self ) )
		self delete();
}

prone_on_goal( end_flag )
{
	if ( isdefined( end_flag ) )
	{
		level endon( end_flag );
	}
	
	level endon( "_stealth_spotted" );
	self endon( "follow_path" );
	self endon( "death" );
	
	self waittill( "goal" );
	wait( 1.0 );

	self thread anim_generic( self, "crouch_2_prone" );
	self setGoalPos( self.origin );
	self allowedStances( "prone" );
}