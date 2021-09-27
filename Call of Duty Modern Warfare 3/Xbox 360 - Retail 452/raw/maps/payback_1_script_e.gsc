#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\payback_util;
#include maps\_anim;
#include maps\_audio;
//Breach
#include maps\_slowmo_breach_payback;


//This is ONLY called from the Jump to Start menu
s1_interrogation_jumpto()
{
	flag_set("wilhelm_over");
	
	kruger_breach_use_trig = GetEnt( "trigger_use_breach", "classname" );
	kruger_breach_use_trig trigger_off();
	
	// AUDIO: jump/checkpoints
	aud_send_msg("s1_interrogation");
	texploder(2300);
	exploder(2000);
	exploder(2500);
	
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	
	move_player_to_start();	
	
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	
	level.hannibal = spawn_ally("hannibal");	
	level.murdock = spawn_ally("murdock");
	level.barracus = spawn_ally("barracus");

	thread sandstorm_fx(4);
	
	objective_state (obj( "obj_kruger" ), "current");
	
	if ( !IsDefined( level.hannibal ) )
	{
	    level waittill( "hannibal_spawned" );
	}
	level.hannibal.animname = "generic";
	
	if ( !IsDefined( level.barracus ) )
	{
	    level waittill( "barracus_spawned" );
	}
	level.barracus.animname = "barracus";
	
	if ( !IsDefined( level.murdock ) )
	{
	    level waittill( "murdock_spawned" );
	}
	level.murdock.animname = "murdock";
	
	thread setup_breach();
	
	thread chopper_init_fog_brushes();
}

kruger_interrogation_init()
{
	flag_init( "kruger_damaged" );
	flag_init( "kruger_dead" );
	flag_init( "remove_gas_mask" );
	flag_init( "breach_ent_anims_done" );
	
	level.interrogation_origin = getent( "reference_waraabe_breach", "targetname" );
}

// Breach
setup_breach()
{
	
	autosave_by_name_silent( "pre_breach_save_1" );
	
	maps\payback_env_code::init_sandstorm_env_effects();
	
	// Show compound exit vista now
	GetEnt("compoundexit_vista", "targetname") Show();
	
	trigger_off( "gas_kill_trigger_1" , "targetname" );
	trigger_off( "gas_kill_trigger_2" , "targetname" );
	
	add_breach_func( ::payback_breach_enemy_overrides );
	add_breach_func( ::no_obj_hide );
	
	//battlechatter_off( "axis" ); // AUDIO: keep enemy battlechatter on for breach sequence, restored in payback_streets::handler_streets_area1()
	battlechatter_off( "allies" ); // AUDIO: turn off all battlechatter for breach sequence, restored in payback_streets::handler_streets_area1()
	
	thread stop_waraabe_pre_breach_conversation();
	thread waraabe_pre_breach_conversation();
	
	// move Price to the breach door
	thread price_goto_kruger_door();
	
	// move Soap to the breach door
	thread soap_goto_kruger_door();
	
	// price plays a generic animation which causes an error if this dialog line tries to play while it's going.
	while (level.price.animname == "generic")
	{
		wait 0.15;
	}

	// put obj marker on breach door
	breach_obj = getstruct( "breach_obj_spot" , "targetname" );
	Objective_SetPointerTextOverride( obj( "obj_kruger" ) , &"SCRIPT_WAYPOINT_BREACH" );
	Objective_Position( obj( "obj_kruger" ) , breach_obj.origin );

	level.price dialogue_queue( "payback_pri_doortooffice" );  // "That's the door to his office."

	wait .5;	
	
	trigger_on( "breach_save_trig_1" , "targetname" );
	
	level.price dialogue_queue( "payback_pri_needhimalive2" );  // "Alright.  Easy on the trigger, mates.  We need him alive."

	// spawn kruger
	spawn_kruger_with_spawn_funcs();
	
	thread setup_breach_and_interrogation_props();
	
	thread kruger_interrogation_start();
	
	thread price_into_kruger_room();
	thread soap_into_kruger_room();
	
	thread audio_breach_end();
	
	kruger_breach_use_trig = GetEnt( "trigger_use_breach", "classname" );
	kruger_breach_use_trig trigger_on();
	
	level waittill( "A door in breach group 1 has been activated." );
	
	aud_send_msg("pre_breach");
	
	Objective_Position( obj( "obj_kruger" ) , ( 0 , 0 , 0 ) );
	
	thread move_hannibal_by_kruger_door();
	thread move_barracus_by_kruger_door();
	thread move_murdock_by_kruger_door();
	
	level waittill( "breach_explosion" );
	
	thread clean_up_outer_compound_guys();
	
	aud_send_msg("mus_door_breached"); // AUDIO: hook for the breach
	
	wait .1;
	
	Objective_SetPointerTextOverride( obj( "obj_kruger" ) , &"PAYBACK_CAPTURE_KRUGER" );
	Objective_OnEntity( obj( "obj_kruger" ) , level.kruger , ( 0, 0, 64) );
	
	level waittill( "clear_capture_icon" );
	
	Objective_Position( obj( "obj_kruger" ) , ( 0 , 0 , 0 ) );
}

no_obj_hide( guy )
{
	setsaveddvar( "objectiveHide", false );
}

audio_breach_end()
{
	level waittill( "slowmo_breach_ending" );
	aud_send_msg("breach_end" );
}

waraabe_pre_breach_conversation()
{
	level endon( "breach_explosion" );
	
	level.pre_breach_sound_org = getent( "pre_breach_sound_org", "targetname" );
	
	// "Where’s my car? Why isn’t it here?"
	level.pre_breach_sound_org  play_sound_on_entity( "payback_wrb_mycar" );
	
	wait .5;
	
	// "The driver said he’s on the way.
	level.pre_breach_sound_org  play_sound_on_entity( "payback_mrc1_driver" );
	
	wait .5;
	
	// "That was five minutes ago!
	level.pre_breach_sound_org  play_sound_on_entity( "payback_wrb_fiveminutes" );
	
	wait .5;
	
	// "Sir, I don’t know what ...
	level.pre_breach_sound_org  play_sound_on_entity( "payback_mrc1_dontknow" );
	
	wait .5;
	
	// "I have to leave now.  Right now!
	level.pre_breach_sound_org  play_sound_on_entity( "payback_wrb_leavenow" );
	
	wait .5;
	
	// "I’m sure he’ll be here soon ...
	level.pre_breach_sound_org  play_sound_on_entity( "payback_mrc1_heresoon" );
	
	wait .5;
	
	// "We’re out of time! We’re trapped here!
	level.pre_breach_sound_org  play_sound_on_entity( "payback_wrb_trapped" );
}

stop_waraabe_pre_breach_conversation()
{
	level waittill( "breach_explosion" );
	
	aud_send_msg("breach_start");

	wait .1;
	
	level.pre_breach_sound_org StopSounds();
	
	wait .1;
	
	level.pre_breach_sound_org Delete();
}

move_hannibal_by_kruger_door()
{
	if ( !IsDefined( level.hannibal ) )
	{
	    level waittill( "hannibal_spawned" );
	}
	//level.hannibal.ignoreall = true;
	hannibal_spot = GetNode( "post_interrogation_hannibal_spot" , "targetname" );
	level.hannibal teleport_ai( hannibal_spot );
	level.hannibal SetGoalNode( hannibal_spot );
}

move_barracus_by_kruger_door()
{
	if ( !IsDefined( level.barracus ) )
	{
	    level waittill( "barracus_spawned" );
	}
	//level.barracus.ignoreall = true;
	barracus_spot = GetNode( "post_interrogation_barracus_spot" , "targetname" );
	level.barracus teleport_ai( barracus_spot );
	level.barracus SetGoalNode( barracus_spot );
}

move_murdock_by_kruger_door()
{
	if ( !IsDefined( level.murdock ) )
	{
	    level waittill( "murdock_spawned" );
	}
	//level.murdock.ignoreall = true;
	murdock_spot = GetNode( "post_interrogation_murdock_spot" , "targetname" );
	level.murdock teleport_ai( murdock_spot );
	level.murdock SetGoalNode( murdock_spot );
}

price_goto_kruger_door()
{
	level endon( "stop_price_stack_anims" );
	
	price_breach_stack_spot = getstruct( "price_breach_stack_spot" , "targetname" );
	level.price.goalradius = 15;
	
	price_breach_stack_spot anim_reach_solo( level.price , "payback_coverstand_trans_IN_R" );
	
	price_breach_stack_spot anim_single_solo( level.price , "payback_coverstand_trans_IN_R" );
	
	level.price anim_single_solo( level.price , "payback_coverstand_look_moveup" );
	
	level.price anim_loop_solo( level.price , "payback_coverstand_look_idle" , "stop_price_stack_loop" );
}

soap_goto_kruger_door()
{
	level endon( "stop_soap_stack_anims" );
	
	flag_wait("wilhelm_over");
	soap_breach_stack_spot = getstruct( "soap_breach_stack_spot" , "targetname" );
	level.soap.goalradius = 15;

	soap_breach_stack_spot anim_reach_solo( level.soap , "payback_corner_standL_trans_IN_2" );
	
	soap_breach_stack_spot anim_single_solo( level.soap , "payback_corner_standL_trans_IN_2" );
	
	level.soap anim_loop_solo( level.soap , "payback_corner_standl_alert_idle" , "stop_soap_stack_loop" );
}

spawn_kruger_with_spawn_funcs()
{
	// Kruger
	kruger_spawner = GetEnt( "kruger_spawner", "targetname" );
	kruger_spawner add_spawn_function( ::kruger_spawn_func );
	level.kruger = kruger_spawner spawn_ai( true );
}

kruger_spawn_func()
{
	level endon( "kruger_killed" );
	
	self.animname = "kruger";
	self.ignoreall = true;
	self.notarget = true;
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.disableBulletWhizbyReaction = true;
	self thread disable_pain();
	self thread disable_surprise();
	self thread magic_bullet_shield();
	self thread set_battlechatter( false );
	self thread setFlashbangImmunity();
	level.interrogation_origin thread anim_first_frame_solo( self , "waraabe_breach" );
	
	level waittill( "breach_enemy_anims" );
	
	self thread kruger_damage_watch();
	
	breach_ents = [];
	breach_ents[ 0 ] = level.dummy_prop_1;
	breach_ents[ 1 ] = level.waraabe_laptop;
	breach_ents[ 2 ] = level.dummy_prop_4;
	breach_ents[ 3 ] = level.dummy_prop_5;
	breach_ents[ 4 ] = self;

	self thread kruger_death_anims();
	thread interrogation_room_shutters();
	thread interrogation_room_curtains();
	level.interrogation_origin anim_single( breach_ents , "waraabe_breach" );	
	
	level.kruger gun_remove();
	
	flag_set( "breach_ent_anims_done" );
	
	self.a.pose = "prone";
	
	level.interrogation_origin anim_loop_solo( self , "waraabe_breach_injured_loop" , "stop_waraabe_injured_loop" );
}

#using_animtree( "generic_human" );
kruger_death_anims()
{
	self waittillmatch( "single anim", "death_stomach" );
	self.currentdeathanim = "waraabe_death_ground";
	
	self waittillmatch( "single anim", "death_on_crate" );
	self.currentdeathanim = "waraabe_death_crate";
	
	//Player clip to prevent player from being anywhere where Waraabe and crates animate, turns off now
	wait(3);
	player_clip = getent( "player_clip", "targetname" );
	player_clip NotSolid();
}

kruger_damage_watch()
{
	level endon( "kruger_dead" );
	self endon( "kruger_dead" );
	
	self.health = 1;
	
	while( !flag( "kruger_dead" ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		if( IsDefined( attacker ) && IsPlayer( attacker ) && ( amount > 1 ) )
		{
			if ( isdefined(self.currentdeathanim) )
			{
				level notify( "kruger_killed" );
				level notify( "kruger_killed_by_player" );
				
				if ( IsDefined( self.a.pose ) && self.a.pose != "prone" )
				{
					self.ragdoll_immediate = true;
				}
				self StopAnimScripted();
				
				if (IsDefined(self.currentdeathanim))
				{
					self thread fake_waraabe_death();
				}
				else
				{
					self stop_magic_bullet_shield();
					self kill();
				}	
					
				thread mission_fail_killed_waraabe();
				level waittill("end_level_waraabe_killed");
				return;
			}
		}
	}
}

mission_fail_killed_waraabe()
{
	wait .4;
	setDvar( "ui_deadquote", &"PAYBACK_KRUGER_NEEDED_ALIVE" );
	level notify( "mission failed" );
	missionFailedWrapper();
	level notify("end_level_waraabe_killed");
}

fake_waraabe_death()
{
	self thread anim_single_solo(self, self.currentdeathanim);
	wait(1);
	self.team = "neutral";
	wait(1);
	self StopAnimScripted();
	self SetAnim(self GetAnim(self.currentdeathanim), 1.0, 0.95, 0.0);
}

kill_no_react()
{
	if ( !isalive( self ) )
	{
		return;
	}
	flag_set( "kruger_dead" );
}

price_into_kruger_room()
{
	level waittill( "sp_slowmo_breachanim_done" );
	
	level notify( "stop_price_stack_anims" );
	level.price notify( "stop_price_stack_loop" );
	
	level.price anim_stopanimscripted();
	
	level.price ally_breach_prep();
	
	level.price_pre_breach_accuracy = level.price.baseaccuracy;
	level.price.baseaccuracy = level.price.baseaccuracy / 4;
	level.price.ignoreme = true;
	
	wait .05;
	
	level.price teleport_ai( GetNode( "kruger_room_price_spot" , "targetname" ) );
	
	level.price_hat = spawn_anim_model( "price_hat" );
	level.price_hat LinkTo(level.price, "J_Head", (0,0,0), (0,0,0));
	level.price_hat hide();

	//level waittill( "slomo_breach_over" );
	//level.interrogation_origin anim_reach_solo( level.price , "waraabe_interrogation" );
}

soap_into_kruger_room()
{
	level waittill( "sp_slowmo_breachanim_done" );
	
	level notify( "stop_soap_stack_anims" );
	level.soap notify( "stop_soap_stack_loop" );
	
	level.soap anim_stopanimscripted();
	
	level.soap ally_breach_prep();
	
	level.soap_pre_breach_accuracy = level.soap.baseaccuracy;
	level.soap.baseaccuracy = level.soap.baseaccuracy / 4;
	level.soap.ignoreme = true;

	wait .05;
	
	level.soap teleport_ai( GetNode( "kruger_room_soap_spot" , "targetname" ) );
	
	//level waittill( "slomo_breach_over" );
	//level.interrogation_origin anim_reach_solo( level.soap , "waraabe_interrogation" );
}

ally_breach_prep()
{
	self.ignoreexplosionevents = true;
	self.ignoresuppression = true;
	self.disableBulletWhizbyReaction = true;
	self.ignorerandombulletdamage = true;
	self thread disable_pain();
	self thread disable_surprise();
	self AllowedStances( "stand" );
	self.fixednode = true;
	self.dontmelee = true;
}

ally_breach_prep_clear()
{
	self.ignoreexplosionevents = false;
	self.ignoresuppression = false;
	self.disableBulletWhizbyReaction = false;
	self.ignorerandombulletdamage = false;
	self thread enable_pain();
	self thread enable_surprise();
	self AllowedStances( "stand" , "crouch" , "prone" );
	self.fixednode = false;
	self.dontmelee = undefined;
}

//breach enemy spawn funcs
payback_breach_enemy_overrides( guy )
{
	kruger_buddies = get_ai_group_ai( "kruger_buddies" );
	
	foreach ( buddy in kruger_buddies )
	{
		buddy thread payback_breach_enemy_overrides_func( guy );
	}
}

payback_breach_enemy_overrides_func( guy )
{
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "kruger_buddy_1" ) )
	{
		self.deathanim = getanim_generic( "generic_death" );
		self thread breach_player_shotgunned();
	}
	
	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "kruger_buddy_3" ) )
	{
		self.deathanim = getanim_generic( "generic_death_2" );
	}

	if ( IsDefined( self.script_noteworthy ) && ( self.script_noteworthy == "kruger_buddy_5" ) )
	{
		self disable_surprise();
	}

	self.perfectaim = true;
	self.disableBulletWhizbyReaction = true;
	self thread breach_enemy_cancel_ragdoll();
}

breach_player_shotgunned()
{
	level.player endon( "death" );
	
	self endon( "death" );
	
	self waittillmatch( "single anim", "fire" );
	
	vec = AnglesToForward( self GetTagAngles( "tag_flash" ) );
	vec2 = VectorNormalize( ( level.player.origin - self.origin ) );
	vecdot = VectorDot( vec, vec2 );

	if ( ( vecdot >= 0.96 ) && ( IsDefined( level.player ) ) && ( IsAlive( level.player ) ) )
	{
		self thread delay_player_kill();
	}

	self waittillmatch( "single anim", "fire" );
	
	vec = AnglesToForward( self GetTagAngles( "tag_flash" ) );
	vec2 = VectorNormalize( ( level.player.origin - self.origin ) );
	vecdot = VectorDot( vec, vec2 );

	if ( ( vecdot >= 0.96 ) && ( IsDefined( level.player ) ) && ( IsAlive( level.player ) ) )
	{
		self thread delay_player_kill();
	}
}

delay_player_kill()
{
	level.player endon( "death" );
	
	self endon( "death" );
	
	wait .1;
	
	level.player Kill();
}


// Breach End


kruger_interrogation_start()
{
	level endon( "kruger_killed" );
	flag_wait( "breach_room_guys_dead" );
	flag_wait( "breach_ent_anims_done" );
	
	battlechatter_off( "axis" ); // AUDIO: turn off all battlechatter for interrogation, restored in payback_streets::handler_streets_area1()
	
	thread breach_room_autosave_silent();
	
	level notify( "clear_capture_icon" );
	aud_send_msg("mix_interrogation");

	thread kruger_start_interrogation();
	thread start_interrogation_anims();
	thread take_off_gas_mask_wait();
}

breach_room_autosave_silent()
{
	level endon( "kruger_killed_by_player" );
	
	trigger = GetEnt( "breach_save_trig_2" , "targetname" );
	trigger trigger_on();
	trigger waittill( "trigger" );
	autosave_now_silent();
}

take_off_gas_mask_wait()
{
	flag_wait( "remove_gas_mask" );
	
	trigger_on( "gas_kill_trigger_1" , "targetname" );
	trigger_on( "gas_kill_trigger_2" , "targetname" );
	//level.player thread gas_mask_off_anim();
	level.player thread gas_mask_off_player_anim();
	level thread maps\payback_streets::streets();
	thread gas_kill_player_slow();
	thread gas_kill_player_fast();
}

gas_kill_player_slow()
{	
	level endon( "const_rappel_player_start" );
	
	while (true)
	{
		flag_wait("touching_gas_kill_slow");
		
		while(flag("touching_gas_kill_slow"))
		{
			wait(1.0);
			level.player DoDamage( 30 , level.player.origin );
			setDvar( "ui_deadquote", &"PAYBACK_FAIL_GAS" );
		}
	}
}

gas_kill_player_fast()
{
	level endon( "const_rappel_player_start" );
	
	flag_wait("touching_gas_kill_fast");
	
	level.player DoDamage( 999 , level.player.origin );
	setDvar( "ui_deadquote", &"PAYBACK_FAIL_GAS" );
}


price_start_interrogation()
{
	level.price waittillmatch( "single anim" , "end" );
	
	level.price ally_breach_prep_clear();
	
	level.price enable_ai_color();
	
	level.price.dontmelee = 0;
	
	trigger_activate_targetname_safe( "streets_init_price" );
}

price_hat()
{
	level.price thread anim_single_solo( level.price_hat , "price_hat_interrogation", "J_Head" );
	wait(.5);
	level.price_hat show();
	level.price SetModel("fullbody_price_africa_assault_a_nohat");	
}

swap_model(model)
{
	level.price SetModel("fullbody_price_africa_assault_a");
	level.price_hat delete();
	level.swap_model = true;
}

soap_start_interrogation()
{
	level.soap waittillmatch( "single anim" , "end" );
	
	level.soap ally_breach_prep_clear();
	
	level.soap enable_ai_color();
	activate_trigger_with_targetname( "streets_init_soap" );
}

waraabe_shot_in_leg( guy )
{
	thread price_shoot_kruger();
	PlayFXOnTag( level._effect[ "waraabe_leg_shot" ] , level.kruger , "TAG_WEAPON_CHEST" );
	wait .1;
	PlayFXOnTag( level._effect[ "waraabe_blood_drips" ] , level.kruger , "TAG_WEAPON_CHEST" );
	wait 1;
	StopFXOnTag( level._effect[ "waraabe_blood_drips" ] , level.kruger , "TAG_WEAPON_CHEST" );
}

price_shoot_kruger()
{
	level.price Shoot( 9999 , level.kruger GetTagOrigin( "TAG_WEAPON_CHEST" ) );
	wait .1;
	level.price Shoot( 9999 , level.kruger GetTagOrigin( "TAG_WEAPON_CHEST" ) );
	wait .1;
	level.price Shoot( 9999 , level.kruger GetTagOrigin( "TAG_WEAPON_CHEST" ) );
}
           
waraabe_leg_stomp( guy )
{
	PlayFXOnTag( level._effect[ "waraabe_leg_kick" ] , level.kruger , "TAG_WEAPON_CHEST" );
	wait .1;
	exploder(3001);
	
	level.crate_blood_decal_model show();
	
	// Putting this here to prevent them spawning in after Soap opens the door
	array_spawn_function_targetname( "post_interrogation_dead_drone" , ::post_interrogation_dead_drone_spawn_func );
	post_interrogation_dead_drones = array_spawn_targetname( "post_interrogation_dead_drone" );
	
	//StopFXOnTag( level._effect[ "flesh_hit" ] , level.kruger , "TAG_WEAPON_CHEST" );
}

kruger_start_interrogation()
{
	level endon( "kruger_killed" );
	level endon( "kruger_killed_by_player" );
	
 	level.kruger.allowdeath = 1;
 	level.interrogation_origin notify( "stop_waraabe_injured_loop" );
 	level.kruger.a.pose = "prone";
 	level.kruger.a.onback = true;
	level.interrogation_origin anim_single_solo( level.kruger , "payback_interrogation_warrabe" );
	level.interrogation_origin thread anim_loop_solo( level.kruger , "payback_interrogation_warrabe_death_loop" );
	level.kruger.team = "neutral";
	autosave_now_silent();
	flag_wait( "streets_area1_ambush" );
	//level.kruger.allowDeath = true;
	//level.kruger.a.nodeath = true;
	//level.kruger.diequietly = true;
	//level.kruger.noragdoll = 1;
	level.kruger stop_magic_bullet_shield();
	//level.kruger kill();
	level.kruger set_battlechatter( false );
	level.kruger delete();
}

setup_breach_and_interrogation_props()
{
	//Setup Dummy Prop 1 - front crates
	level.dummy_prop_1 = spawn_anim_model( "dummy_prop_1" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_1 , "waraabe_breach" );
	level.dummy_prop_1 Hide();

	//Setup Dummy Prop 2 - Gas Can and Extra Mask
	level.dummy_prop_2 = spawn_anim_model( "dummy_prop_2" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_2 , "waraabe_interrogation" );
	level.dummy_prop_2 Hide();
	
	//Setup laptop
	level.waraabe_laptop = spawn_anim_model( "waraabe_laptop" );
	level.interrogation_origin thread anim_first_frame_solo( level.waraabe_laptop , "waraabe_breach" );
	
	//Setup Dummy Prop 4 - back crates
	level.dummy_prop_4 = spawn_anim_model( "dummy_prop_4" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_4 , "waraabe_breach" );
	level.dummy_prop_4 Hide();
	
	//Setup Dummy Prop 5 - clipboard and phone
	level.dummy_prop_5 = spawn_anim_model( "dummy_prop_5" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_5 , "waraabe_breach" );
	level.dummy_prop_5 Hide();
	
	//Setup Dummy Prop 6 - exit door
	level.dummy_prop_6 = spawn_anim_model( "dummy_prop_6" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_6 , "waraabe_interrogation" );
	level.dummy_prop_6 Hide();
	
	level.dummy_prop_7 = spawn_anim_model( "dummy_prop_7" );
	level.interrogation_origin thread anim_first_frame_solo( level.dummy_prop_7 , "waraabe_interrogation" );
	level.dummy_prop_7 Hide();	

	//front crate 1
	front_crate_clip_1 = GetEnt( "front_crate_clip_1" , "targetname" );
	level.front_crate_1 = Spawn( "script_model", level.interrogation_origin.origin );
	level.front_crate_1 SetModel( "pb_weapon_casing_closed" );
	front_crate_clip_1.origin = level.interrogation_origin.origin;
	front_crate_clip_1.angles = level.interrogation_origin.angles;
	front_crate_clip_1 LinkTo( level.front_crate_1 );
	level.front_crate_1 LinkTo( level.dummy_prop_1 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	//level.front_crate_1 hide();
	
	level.crate_blood_decal_model = Spawn( "script_model", level.interrogation_origin.origin );
	level.crate_blood_decal_model SetModel( "pb_weapon_casing_closed_splatter" );
	level.crate_blood_decal_model LinkTo( level.dummy_prop_1 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.crate_blood_decal_model hide();

	//front crate 2
	front_crate_clip_2 = GetEnt( "front_crate_clip_2" , "targetname" );
	level.front_crate_2 = Spawn( "script_model", level.interrogation_origin.origin );
	level.front_crate_2 SetModel( "pb_weapon_casing_closed" );
	front_crate_clip_2.origin = level.interrogation_origin.origin;
	front_crate_clip_2.angles = level.interrogation_origin.angles;
	front_crate_clip_2 LinkTo( level.front_crate_2 );
	level.front_crate_2 LinkTo( level.dummy_prop_1 , "J_prop_2" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//Setup Gas Can
	level.gas_can = Spawn( "script_model", level.interrogation_origin.origin );
	level.gas_can SetModel( "pb_grenade_smoke" );
	level.gas_can LinkTo( level.dummy_prop_7 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.gas_can Hide();
	
	//Setup Extra Gas Mask	
	level.mask_3 = spawn_anim_model( "extra_new_gas_mask" );
	level.mask_3 Hide();
	level.interrogation_origin thread anim_first_frame_solo( level.mask_3 , "waraabe_interrogation" );

	//Setup Price's Gas Mask
	level.mask_1 = spawn_anim_model( "price_new_gas_mask" );
	level.mask_1 Hide();
	level.interrogation_origin thread anim_first_frame_solo( level.mask_1 , "waraabe_interrogation" );
	
	//Setup Soap's Gas Mask	
	level.mask_2 = spawn_anim_model( "soap_new_gas_mask" );
	level.mask_2 Hide();
	level.interrogation_origin thread anim_first_frame_solo( level.mask_2 , "waraabe_interrogation" );
	
	//back crate 1
	back_crate_clip_1 = GetEnt( "back_crate_clip_1" , "targetname" );
	level.back_crate_1 = Spawn( "script_model", level.interrogation_origin.origin );
	level.back_crate_1 SetModel( "pb_weapon_casing_closed" );
	back_crate_clip_1.origin = level.interrogation_origin.origin;
	back_crate_clip_1.angles = level.interrogation_origin.angles;
	back_crate_clip_1 LinkTo( level.back_crate_1 );
	level.back_crate_1 LinkTo( level.dummy_prop_4 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//back crate 2
	back_crate_clip_2 = GetEnt( "back_crate_clip_2" , "targetname" );
	level.back_crate_2 = Spawn( "script_model", level.interrogation_origin.origin );
	level.back_crate_2 SetModel( "pb_weapon_casing_closed" );
	back_crate_clip_2.origin = level.interrogation_origin.origin;
	back_crate_clip_2.angles = level.interrogation_origin.angles;
	back_crate_clip_2 LinkTo( level.back_crate_2 );
	level.back_crate_2 LinkTo( level.dummy_prop_4 , "J_prop_2" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//clipboard
	level.waraabe_clipboard = Spawn( "script_model", level.interrogation_origin.origin );
	level.waraabe_clipboard SetModel( "com_clipboard_wpaper" );
	level.waraabe_clipboard LinkTo( level.dummy_prop_5 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//phone
	level.waraabe_cellphone = Spawn( "script_model", level.interrogation_origin.origin );
	level.waraabe_cellphone SetModel( "hjk_cell_phone_off" );
	level.waraabe_cellphone LinkTo( level.dummy_prop_5 , "J_prop_2" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	//exit door
	level.interrogation_exit_door = Spawn( "script_model", level.interrogation_origin.origin );
	level.interrogation_exit_door SetModel( "pb_door_breach" );
	level.interrogation_exit_door LinkTo( level.dummy_prop_6 , "J_prop_1" , ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

start_interrogation_anims()
{
	interrogation_props = [];
	interrogation_props[ 0 ] = level.dummy_prop_1;
	interrogation_props[ 1 ] = level.dummy_prop_2;
	interrogation_props[ 2 ] = level.dummy_prop_4;
	interrogation_props[ 3 ] = level.dummy_prop_7;
	interrogation_props[ 4 ] = level.mask_1;
	interrogation_props[ 5 ] = level.mask_2;
	interrogation_props[ 6 ] = level.mask_3;
	interrogation_props[ 7 ] = level.price;
	interrogation_props[ 8 ] = level.soap;
	
	thread price_hat();
	
	level.price.baseaccuracy = level.price_pre_breach_accuracy;
	level.price.ignoreme = false;
	
	level.soap.baseaccuracy = level.soap_pre_breach_accuracy;
	level.soap.ignoreme = false;
	
	wait .05;
	
	level.interrogation_origin thread anim_single( interrogation_props , "waraabe_interrogation" );
	
	thread price_start_interrogation();
	thread soap_start_interrogation();
}

interrogation_room_shutters()
{
    interrogation_shutters = GetEntArray("interrogation_shutters","targetname");
    foreach(interrogation_shutter in interrogation_shutters)
    {
        interrogation_shutter delete();
    }
        
    anim_model_01 = spawn_anim_model("interrogation_room_shutters");
    anim_model_01 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_01 attach( "pb_window_arch_03_door", "J_prop_2" );
    
    anim_model_02 = spawn_anim_model("interrogation_room_shutters");
    anim_model_02 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_02 attach( "pb_window_arch_03_door", "J_prop_2" );    
    
    anim_model_03 = spawn_anim_model("interrogation_room_shutters");
    anim_model_03 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_03 attach( "pb_window_arch_03_door", "J_prop_2" );
    
    anim_model_04 = spawn_anim_model("interrogation_room_shutters");
    anim_model_04 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_04 attach( "pb_window_arch_03_door", "J_prop_2" );
    
    anim_model_05 = spawn_anim_model("interrogation_room_shutters");
    anim_model_05 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_05 attach( "pb_window_arch_03_door", "J_prop_2" );

    anim_model_06 = spawn_anim_model("interrogation_room_shutters");
    anim_model_06 attach( "pb_window_arch_03_door", "J_prop_1" );
    anim_model_06 attach( "pb_window_arch_03_door", "J_prop_2" );    
    
    level.interrogation_origin thread anim_loop_solo( anim_model_01, "shutters_01", "stop_looping_anims" );
    level.interrogation_origin thread anim_loop_solo( anim_model_02, "shutters_02", "stop_looping_anims" );
    level.interrogation_origin thread anim_loop_solo( anim_model_03, "shutters_03", "stop_looping_anims" );
    level.interrogation_origin thread anim_loop_solo( anim_model_04, "shutters_04", "stop_looping_anims" );
    level.interrogation_origin thread anim_loop_solo( anim_model_05, "shutters_05", "stop_looping_anims" );
    level.interrogation_origin thread anim_loop_solo( anim_model_06, "shutters_06", "stop_looping_anims" );
    
    flag_wait("start_construction_anims");
    
    anim_model_01 notify("stop_looping_anims");
    anim_model_01 delete();
    
    anim_model_02 notify("stop_looping_anims");
    anim_model_02 delete();
    
    anim_model_03 notify("stop_looping_anims");
    anim_model_03 delete();
    
    anim_model_04 notify("stop_looping_anims");
    anim_model_04 delete();

    anim_model_05 notify("stop_looping_anims");
    anim_model_05 delete();
    
    anim_model_06 notify("stop_looping_anims");
    anim_model_06 delete();
}

interrogation_room_curtains()
{
	interrogation_curtains1 = GetEnt("interrogation_curtains1","targetname");
	interrogation_curtains1.animname = "interrogation_room_curtains";
	interrogation_curtains1 SetAnimTree();
    level.interrogation_origin thread anim_loop_solo( interrogation_curtains1, "curtains_01", "stop_looping_anims" );
    
    interrogation_curtains2 = GetEnt("interrogation_curtains2","targetname");
	interrogation_curtains2.animname = "interrogation_room_curtains";
	interrogation_curtains2 SetAnimTree();
    level.interrogation_origin thread anim_loop_solo( interrogation_curtains2, "curtains_02", "stop_looping_anims" );
    
    interrogation_curtains4 = GetEnt("interrogation_curtains4","targetname");
	interrogation_curtains4.animname = "interrogation_room_curtains";
	interrogation_curtains4 SetAnimTree();
    level.interrogation_origin thread anim_loop_solo( interrogation_curtains4, "curtains_04", "stop_looping_anims" );
    
    interrogation_curtains5 = GetEnt("interrogation_curtains5","targetname");
	interrogation_curtains5.animname = "interrogation_room_curtains";
	interrogation_curtains5 SetAnimTree();
    level.interrogation_origin thread anim_loop_solo( interrogation_curtains5, "curtains_05", "stop_looping_anims" );
    
    interrogation_curtains6 = GetEnt("interrogation_curtains6","targetname");
	interrogation_curtains6.animname = "interrogation_room_curtains";
	interrogation_curtains6 SetAnimTree();
    level.interrogation_origin thread anim_loop_solo( interrogation_curtains6, "curtains_06", "stop_looping_anims" );
	
    flag_wait("start_construction_anims");
    
    interrogation_curtains1 notify("stop_looping_anims");
    interrogation_curtains1 delete();

    interrogation_curtains2 notify("stop_looping_anims");
    interrogation_curtains2 delete();

    interrogation_curtains4 notify("stop_looping_anims");
    interrogation_curtains4 delete();

    interrogation_curtains5 notify("stop_looping_anims");
    interrogation_curtains5 delete();

    interrogation_curtains6 notify("stop_looping_anims");
    interrogation_curtains6 delete();    
}

unhide_mask_1( mask_1 )
{
	level.mask_1 Show();

	thread gas_mask_on_player_anim();
}

unhide_mask_2( mask_2 )
{
	level.mask_2 Show();
}

unhide_mask_3( mask_3 )
{
	level.mask_3 Show();
}

unhide_gas_can( gas_can )
{
	level.gas_can Show();
}

activate_gas_can( gas_can )
{
	// need to get a metal "tink" sound here for when he hits the gas can, the actual gas can doesn't start smoking until activate_gas_can_2 gets called when the gas can settles on the ground
}
fx_sparks( gas_can )
{
	aud_send_msg( "gas_can_popped" , level.gas_can.origin );	
	PlayFXOnTag( level._effect[ "payback_spark_sm" ], level.dummy_prop_7, "J_prop_2" );
	sandstorm_fx(4);
}
fx_initial_spew(gas_can)
{
	PlayFXOnTag( level._effect[ "payback_interrogation_gas_runner_0" ], level.dummy_prop_7, "J_prop_2" );
}
fx_big_spew(gas_can)
{
	StopFXOnTag( level._effect[ "payback_interrogation_gas_runner_0" ], level.dummy_prop_7, "J_prop_2" );
	//exploder(1); // Ending Gas, move to fx_linger
	PlayFXOnTag( level._effect[ "payback_interrogation_gas1" ], level.dummy_prop_7, "J_prop_2" );
	//PlayFXOnTag( level._effect[ "payback_interrogation_gas3" ], level.dummy_prop_7, "J_prop_2" );
	wait(20);
	exploder(3000); // Ending Gas, move to fx_linger
	exploder(4000); // 
	
}

/*
wound_stomp(blank)
{
	PlayFXOnTag( level._effect[ "flesh_hit" ], level.kruger, "TAG_WEAPON_CHEST" );
}
*/
activate_gas_can_2( gas_can )
{
	//gas_fx_spot = GetEnt( "gas_fx_spot" , "targetname" );

	//PlayFx( level._effect[ "payback_interrogation_gas_new" ], gas_fx_spot.origin );
	
	//flag_wait( "remove_gas_mask" );
	
	//gas_fx_spot Delete();
}

hide_mask_1( mask_1 )
{
	level.mask_1 Hide();
	level.hide_mask_1 = true;
}

hide_mask_2( mask_2 )
{
	level.mask_2 Hide();
}

price_holster_mg( mg )
{
	level.price place_weapon_on( "m4_grenadier", "chest" );
}

open_exit_door( door )
{
	activate_trigger_with_targetname( "streets_init_bravo" );
	level.interrogation_origin anim_single_solo( level.dummy_prop_6 , "waraabe_interrogation" );
	
	exit_door_clip = GetEnt( "kruger_exit_door_clip" , "targetname" );
	exit_door_clip ConnectPaths();
	exit_door_clip Delete();
}

price_unholster_pistol( pistol )
{
	level.price_pistol = spawn( "script_model", level.price GetTagOrigin( "TAG_WEAPON_RIGHT" ) );
	level.price_pistol setmodel( "weapon_desert_eagle_tactical" );
	level.price_pistol linkto( level.price, "TAG_WEAPON_RIGHT", (0, 0, 0), (0, 0, 0) );
}

price_shoot_pistol( pistol )
{
	PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
	PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
	level.price_pistol thread play_sound_on_tag( "weap_deserteagle_fire_npc" , "TAG_FLASH" );
	magicBullet( "deserteagle" , level.price_pistol GetTagOrigin( "TAG_FLASH" ) , level.kruger GetTagOrigin( "J_Head" ) );
	PlayFXOnTag( level._effect[ "waraabe_head_shot" ] , level.kruger , "TAG_WEAPON_CHEST" );
	level.kruger kill_no_react();
	aud_send_msg("mus_beach");
}

price_holster_pistol( pistol )
{
	//setupforcityskip
	level.swap_model = false;
	level.hide_mask_1 = false;
	level.price_unholster_mg = false;
	
	level.price_pistol Delete();
	
	// "Nikolai, Kruger broke! We have what we need. Ready for exfil."
		
	objective_complete( obj( "obj_kruger" ) );
	objective_state( obj( "obj_primary_lz" ), "current");
	wait (1);
	level.price dialogue_queue( "payback_pri_krugerbroke" );
	
	// "Almost there - the LZ looks clear but I ve got movement in the distance."
	radio_dialogue( "payback_nik_lzlooksclear" );
	level.price dialogue_queue( "payback_pri_20seconds" );
	// "That storm is massive."
	wait .3;
	level.soap dialogue_queue( "payback_mct_massive" );
	// "We do not want to get caught in that nightmare. Let’s move."
	wait .5;
	level.price dialogue_queue( "payback_pri_nightmare" );
	
}

price_unholster_mg( mg )
{
	level.price place_weapon_on( "m4_grenadier", "right" );
	level.price_unholster_mg = true;
}

post_interrogation_dead_drone_spawn_func()
{
	reference = GetEnt( self.script_linkto , "script_linkname" );
	self gun_remove();
	self SetCanDamage( false );
	reference anim_generic( self, self.animation );
	self NotSolid();
}

bob_mask( hudElement )
{
	self endon( "stop_mask_bob" );

	weapIdleTime = 0;
	previousAngles = level.player GetPlayerAngles();
	offsetY = 0;	// for vertical changes. eg. jumping
	offsetX = 0;	// for turning left/right

	frameTime = 0.05;
	while (1)
	{
		if ( IsDefined( hudElement ) )
		{
			angles = level.player GetPlayerAngles();
			velocity = level.player GetVelocity();
			zVelocity = velocity[2];
			velocity = velocity - velocity * ( 0, 0, 1 ); // zero out z velocity ( up/down velocity )
			speedXY = Length( velocity );
			stance = level.player GetStance();

			// speedScale goes from 0 to 1 as speed goes between 0 and full sprint
			speedScale = clamp( speedXY, 0, 280 ) / 280;
			// bobXFraction and bobXFraction control the amount of the maximum xy displacement that is allocated to the bob motion.
			// The remainder goes to the xy offset due to turn and z velocity.
			// As speed increases more displacement goes to bob and less to the xy offset due to turn and z velocity.
			bobXFraction = 0.1 + speedScale * 0.25;
			bobYFraction = 0.1 + speedScale * 0.25;

			// bobScale controls the amount of bob displacement based on stance
			bobScale = 1.0;	// default
			if ( stance == "crouch" )	bobScale = 0.75;
			if ( stance == "prone" )	bobScale = 0.4;
			if ( stance == "stand" )	bobScale = 1.0;

			// bobSpeed controls the frequency of the bob cycle
			idleSpeed = 5.0;
			ADSSpeed = 0.9;
			playerADS = level.player playerADS();
			// lerp bobSpeed between idleSpeed and ADSSpeed
			bobSpeed = idleSpeed * ( 1.0 - playerADS ) + ADSSpeed * playerADS;
			bobSpeed = bobSpeed * ( 1 + speedScale * 2 );

			maxXYDisplacement = 5;	// corresponds to 650 by 490 in the hud elem SetShader()
			bobAmplitudeX = maxXYDisplacement * bobXFraction * bobScale;
			bobAmplitudeY = maxXYDisplacement * bobYFraction * bobScale;

			// control the bob motion in the same pattern as the viewmodel bob - through it will not be in phase
			weapIdleTime = weapIdleTime + frameTime * 1000.0 * bobSpeed;
			rad_to_deg = 57.295779513; // radians to degrees
			 // the constants 0.001 and 0.0007 match those in BG_ComputeAndApplyWeaponMovement_IdleAngles()
			verticalBob   = sin( weapIdleTime * 0.001  * rad_to_deg );
			horizontalBob = sin( weapIdleTime * 0.0007 * rad_to_deg );

			// calculate some x offset based on player turning
			angleDiffYaw = AngleClamp180( angles[ 1 ] - previousAngles[ 1 ] );
			angleDiffYaw = clamp( angleDiffYaw, -10, 10 );
			offsetXTarget = ( angleDiffYaw / 10 ) * maxXYDisplacement * ( 1 - bobXFraction );
			offsetXChange = offsetXTarget - offsetX;
			offsetX = offsetX + clamp( offsetXChange, -1.0, 1.0 );

			// calculate some y offset based on vertical velocity
			offsetYTarget = ( clamp( zVelocity, -200, 200 ) / 200 ) * maxXYDisplacement * ( 1 - bobYFraction );
			offsetYChange = offsetYTarget - offsetY;
			offsetY = offsetY + clamp( offsetYChange, -0.6, 0.6 );
			
			hudElement MoveOverTime( 0.05 );
			hudElement.x = clamp( ( verticalBob   * bobAmplitudeX + offsetX - maxXYDisplacement ), 0 - 2 * maxXYDisplacement, 0 );
			hudElement.y = clamp( ( horizontalBob * bobAmplitudeY + offsetY - maxXYDisplacement ), 0 - 2 * maxXYDisplacement, 0 );
			
			previousAngles = angles;
		}
		wait frameTime;
	}
}

gasmask_hud_on(bFade)
{
	wait 0.333; // AUDIO: wait timer is timed for audio, do not change without consulting audio department
	
	Assert(IsPlayer(self));	
	if(!IsDefined(bFade)) bFade = true;
		
	if(bFade)
	{	
		self set_black_fade( 1.0, 0.25 );
		wait(0.25);
	}
	
	SetHUDLighting( true );
	
	self.gasmask_hud_elem = NewHudElem();
	self.gasmask_hud_elem.x = 0;
	self.gasmask_hud_elem.y = 0;
	self.gasmask_hud_elem.horzAlign = "fullscreen";
	self.gasmask_hud_elem.vertAlign = "fullscreen";
	self.gasmask_hud_elem.foreground = false;
	self.gasmask_hud_elem.sort = -1; // trying to be behind introscreen_generic_black_fade_in	
	self.gasmask_hud_elem SetShader("gasmask_overlay_delta2", 650, 490);
	self.gasmask_hud_elem.alpha = 1.0;
	
	level.player delaythread( 1.0, ::gasmask_breathing );
	
	//scuba_mask = level.player GetCurrentWeapon();
	//scuba_mask hidepart( "J_Gun", "viewmodel_scuba_mask");
	
	if(bFade)
	{
		wait(0.25);
		self set_black_fade( 0.0, 0.25 );
	}
	thread bob_mask( self.gasmask_hud_elem );
}

gasmask_hud_off(bFade)
{
	wait 0.333; // AUDIO: wait timer is timed for audio, do not change without consulting audio department
	
	Assert(IsPlayer(self));	
	if(!IsDefined(bFade)) bFade = true;
	
	if(bFade)
	{
		self set_black_fade( 1.0, 0.25 );
		wait(0.25);
	}

	self notify( "stop_mask_bob" );

	self.gasmask_hud_elem Destroy();
	self.gasmask_hud_elem = undefined;
	level.player notify("stop_breathing");
	
	SetHUDLighting( false );
	
	if(bFade)
	{
		wait(0.25);
		self set_black_fade( 0.0, 0.25 );
	}
}

gasmask_breathing()
{
	delay = 1.0;
	self endon( "stop_breathing" );
	
	while ( 1 )
	{
		self play_sound_on_entity( "pybk_breathing_gasmask" );
		wait( delay );
	}
}

gas_mask_on_player_anim()
{
	level endon( "death" );
	aud_send_msg("gasmask_on_player"); // AUDIO: gas mask on
	level.player DisableWeaponSwitch();
	level.player DisableUsability();
	level.player DisableOffhandWeapons();
	wait(.25);
	level.player.last_weapon = level.player GetCurrentWeapon();
	level.player DisableWeapons();
	wait(.5);
	if ( level.player.last_weapon == "alt_ak47_grenadier" )
	{
		level.player.last_weapon = "ak47_grenadier";	// hack to fix SRE
	}
	if ( level.player.last_weapon == "alt_m4m203_acog_payback" )
	{
		level.player.last_weapon = "m4m203_acog_payback";	// hack to fix SRE
	}
	if ( level.player.last_weapon == "alt_m4_grenadier" )
	{
		level.player.last_weapon = "m4_grenadier";	// hack to fix SRE
	}
	
	stock_amt = undefined;
	clip_amt = undefined;
	
	if ( level.player.last_weapon != "none" )
	{
		stock_amt = level.player GetWeaponAmmoStock( level.player.last_weapon );
		clip_amt = level.player GetWeaponAmmoClip( level.player.last_weapon );
	}
		
	level.player TakeWeapon(level.player.last_weapon);
	level.player GiveWeapon( "scuba_mask_on" );
	level.player EnableWeapons();
	level.player SwitchToWeapon( "scuba_mask_on" );
	level.player delayThread( 0.75 , ::gasmask_hud_on );
	wait(2.5);
	level.player TakeWeapon( "scuba_mask_on" );
	level.player GiveWeapon(level.player.last_weapon);
	
	if ( level.player.last_weapon != "none" )
	{
		level.player SetWeaponAmmoStock( level.player.last_weapon , stock_amt );
		level.player SetWeaponAmmoClip( level.player.last_weapon , clip_amt );
		level.player SwitchToWeapon( level.player.last_weapon);
	}
	
	level.player EnableUsability();
	level.player EnableWeaponSwitch();	
	level.player EnableOffhandWeapons();
}

gas_mask_off_player_anim()
{
	level endon( "death" );
	aud_send_msg("gasmask_off_player"); // AUDIO: gas mask off
	level.player DisableWeaponSwitch();
	level.player DisableUsability();
	level.player DisableOffhandWeapons();
	wait(.25);
	level.player.last_weapon = level.player GetCurrentWeapon();

	level.player DisableWeapons();
	wait(.5);
	if ( level.player.last_weapon == "alt_ak47_grenadier" )
	{
		level.player.last_weapon = "ak47_grenadier";	// hack to fix SRE
	}
	if ( level.player.last_weapon == "alt_m4m203_acog_payback" )
	{
		level.player.last_weapon = "m4m203_acog_payback";	// hack to fix SRE
	}
	if ( level.player.last_weapon == "alt_m4_grenadier" )
	{
		level.player.last_weapon = "m4_grenadier";	// hack to fix SRE
	}
	
	stock_amt = undefined;
	clip_amt = undefined;
	
	if ( level.player.last_weapon != "none" )
	{
		stock_amt = level.player GetWeaponAmmoStock( level.player.last_weapon );
		clip_amt = level.player GetWeaponAmmoClip( level.player.last_weapon );
	}
	
	level.player TakeWeapon(level.player.last_weapon);
	level.player GiveWeapon( "scuba_mask_off" );
	level.player EnableWeapons();
	level.player SwitchToWeapon( "scuba_mask_off" );
	level.player delayThread( 0.02 , ::gasmask_hud_off );
	wait(2.5);
	level.player TakeWeapon( "scuba_mask_off" );
	level.player GiveWeapon(level.player.last_weapon);
	
	if ( level.player.last_weapon != "none" )
	{
		level.player SetWeaponAmmoStock( level.player.last_weapon , stock_amt );
		level.player SetWeaponAmmoClip( level.player.last_weapon , clip_amt );
		level.player SwitchToWeapon( level.player.last_weapon);	
	}
			
	level.player EnableUsability();
	level.player EnableWeaponSwitch();	
	level.player EnableOffhandWeapons();
    autosave_now();
}

remember_prev_weapon_ammo( weapon )
{
	if ( level.player.last_weapon != "none" )
	{
		curAmt = level.player GetCurrentWeaponClipAmmo();
		clipSize = WeaponClipSize( weapon );
		if ( IsDefined( clipSize ) )
		{
			level.player SetWeaponAmmoClip( level.player.last_weapon , curAmt );
		}
	}
}


clean_up_outer_compound_guys()
{
	wait 0.5;
	
	enemies = GetAIArray( "axis" );
	foreach (guy in enemies)
	{
		if (!IsDefined(guy.script_noteworthy) || 
		    (IsDefined(guy.script_noteworthy) && !IsSubStr(guy.script_noteworthy, "kruger")))
		{
			guy delete();
		}
	}
}