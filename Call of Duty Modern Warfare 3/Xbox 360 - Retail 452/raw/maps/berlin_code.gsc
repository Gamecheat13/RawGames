#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_audio;
#include maps\_shg_common;
#include maps\berlin_util;
#include maps\_hud_util;


/**************************
SETUP UTILS
**************************/

spawn_berlin_friendlies( location )
{
	//level heroes
	level.heroes = [];
	
	setup_friendly_spawner ( "lone_star", ::setup_lone_star );
	setup_friendly_spawner ( "essex", ::setup_essex );
	setup_friendly_spawner ( "truck", ::setup_truck );
	
	spawn_friendlies(location,"lone_star");
	spawn_friendlies(location,"essex");
	spawn_friendlies(location,"truck");
}

setup_friendly_spawner ( name, func )
{
	ent_arr = getentarray( name, "script_noteworthy" );
	foreach(ent in ent_arr)
	{
		ent add_spawn_function( func );
	}
}

setup_lone_star()
{
	level.lone_star = self;
	self.animname = "lone_star";
	self setup_hero_generic();
	
	level.heroes[0] = level.lone_star;
}

setup_essex()
{
	level.essex = self;
	self.animname = "essex";
	self setup_hero_generic();
	
	level.heroes[1] = level.essex;	
}

setup_truck()
{
	level.truck = self;
	self.animname = "truck";
	self setup_hero_generic();
	
	level.heroes[2] = level.truck;
}

setup_hero_generic()
{
	self thread magic_bullet_shield();
	self thread uphill_run();
	self.awareness = 1;
	self.cqb_wide_poi_track = true;
	//might not need this anymore - self set_accuracy( .5 );
	self.grenadeWeapon = "ninebang_grenade";	
}

get_littlebird_friendlies()
{
	ents = getentarray("little_bird_friendlies", "script_noteworthy");
	friends = [];
	foreach(ent in ents)
	{
		if(!isSpawner(ent))
			friends = add_to_array(friends, ent);
	}
	friends = add_to_array(friends, level.lone_star); //sandman
	friends = add_to_array(friends, level.essex); //grinch
	friends = add_to_array(friends, level.truck);
	
	return friends;
}

/**************************
INTRO SEQUENCE
**************************/

intro_sequence()
{
	
	vision_set_fog_changes("berlin_collapse", 0); //Staying consistent with visionset changes to match parkway
	
	
	level.player FreezeControls( true );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 3,4 );
	wait(4);//wait for the fade to go away
	level.player FreezeControls( false );
}

intro_artillery_shot()
{
	level notify ( "stop_building_collapse_ambush" );
	
	forward = AnglesToForward( level.player.angles );
	vector = forward * 300;
	dummy = spawn_tag_origin();
	dummy.origin = level.player.origin + vector;
	trace = BulletTrace( dummy.origin + (0,0,100), dummy.origin - (0,0,1000), false );
	whistle_time = 1;
	thread incoming_artillery( trace["position"], "generic_explosion", whistle_time, "artillery_ambush_final_incoming", "artillery_ambush_final_explosion" );
	wait(whistle_time);
	//shellshock
	level.player shellshock( "berlin_intro", 3 );
	//earthquake(.1, .5, level.player.origin, 512);//earthquake is in
	PlayRumbleOnPosition("heavy_3s",level.player.origin);
}

intro_flashback_slowmo()
{
	slowmo_setspeed_slow( .3 );
	slowmo_setlerptime_in( 0 );
	slowmo_lerp_in();
				
	wait( 1 );
		
	slowmo_setlerptime_out( 0 );
	slowmo_lerp_out();
}

intro_player_disable_grenades()
{
	flag_wait( "aftermath_se_complete" );
	level.player disableoffhandweapons();//don't allow friendly fire
}

intro_fade_2_white()
{
	level endon( "mission failed" );//in case of freindly fire before it
	
	flag_wait( "start_intro_fade_2_white" );
	
	//point of no return no endon
	handle_intro_fade();
}

handle_intro_fade()
{
		fade_out_time = 1;
		white_out_time = 3;
		text_wait_time = 0;
		thread introscreen_generic_fade_out( "black", white_out_time, 0, fade_out_time );
		lines = [];
		lines[0] = &"BERLIN_INTROSCREEN_20MINS";
		thread slow_player_movement_over_time();//slow down the player during fade
		wait(fade_out_time);
		thread twenty_minutes_earlier_feed_lines( lines, text_wait_time );
		flag_set("intro_outro_full_white");
		level.player FreezeControls( true );//don't let the player move around when we are full white
		wait(white_out_time-0.1);//giving an extra tenth of a second so the fade in from white works without a pop
		flag_set("intro_sequence_complete");
		level.player setmovespeedscale(1);
		level.player FreezeControls( false );		
		
		vision_set_fog_changes("berlin_heli", 0); //Staying consistent with visionset changes - changed back to "default"
}

slow_player_movement_over_time()
{
	level endon("intro_sequence_complete");
	i=1;
	while( i > .1 )
	{
		i -= .1;
		level.player setmovespeedscale(i);
		wait(.5);
	}
}

reset_after_intro()
{
	flag_wait( "intro_sequence_complete" );
	
	flag_clear( "sandman_start_aftermath" );
	flag_clear( "ambush_after_building_collapse_start" );
	flag_clear( "player_near_ceiling_collapse" );
	flag_clear( "player_at_ceiling_collapse" );
	flag_clear( "lone_star_at_ceiling_collapse" );
	flag_clear( "ceiling_collapse_complete" );
	flag_clear( "intro_lone_star_facial_anim_complete" );
}


/**************************
HELI RIDE
**************************/

heli_ride_intro_text()
{
	level.player FreezeControls( true );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 3,4 );
	flag_set("intro_start_on_path");
	aud_send_msg("fade_in_heli_ride");
	thread do_intro_text();
	wait(5);//wait for the fade to go away
	level.player FreezeControls( false );
	
	wait( 4 ); //wait for the intro text to go away
	flag_set("start_sandman_vo");//start sandman talking
}

do_intro_text()
{
	wait( .5 );
	lines = [];
	// "D Day + 1"
	lines[ lines.size ] = &"BERLIN_INTROSCREEN_LINE1";
	// Day 10 - <Time>
	lines[ lines.size ]     = &"BERLIN_INTROSCREEN_LINE2";
	// Delta
	lines[ lines.size ] = &"BERLIN_INTROSCREEN_LINE3";
	// US BattleGroup 2nd Battalion
	lines[ lines.size ] = &"BERLIN_INTROSCREEN_LINE4";
	// Berlin, Germany
	lines[ lines.size ] = &"BERLIN_INTROSCREEN_LINE5";
	
	level.intro_offset = -1;

	maps\_introscreen::introscreen_feed_lines( lines );	
}

spawn_intro()
{
	intro_spawners = getentarray("intro_vehicle_column", "script_noteworthy");
	kills_bad_tank = undefined;
	foreach(spawner in intro_spawners)
	{
		assert(IsSpawner(spawner));
 		veh = spawner spawn_vehicle_and_gopath();
 		assert(isdefined(veh));
 		if(isdefined(veh.script_parameters))
 		{
 			if(veh.script_parameters == "intro_tank_aim_left")
 				kills_bad_tank = veh;
 			veh setturrettargetent( getEnt( veh.script_parameters, "targetname" ) );
 		}
	}
	
	drone_spawner_arr = getentarray("flyover_street_battle", "targetname");
	drones = array_spawn( drone_spawner_arr, true );
	thread ai_delete_when_out_of_sight(drones, 512);
	
	wait(1);
	
	assert(isdefined(kills_bad_tank));
	
	intro_bad_tank = GetEnt( "intro_bad_tank", "targetname" );
	intro_bad_tank spawn_vehicle_and_gopath();
	
	kills_bad_tank shoot_on_flag( "intro_tank_left", intro_bad_tank );
}

heartbeat_rumble()
{
	level endon( "stop_heartbeat_rumble" );
	while( true )
	{
		level.player PlayRumbleOnEntity( "heavy_3s" );
		wait( .1 );
		StopAllRumbles();
		wait( .05 );
		level.player PlayRumbleOnEntity( "light_1s" );
		wait( .1 );
		StopAllRumbles();
		wait( 1.2 );
	}
}

heartbeat_rumble_off()
{
	level notify( "stop_heartbeat_rumble" );
	StopAllRumbles();
}

shoot_on_flag(wait_for, target)
{
	assert(isalive(self));
	self endon("death");
	target endon("death");
	if(!flag_exist(wait_for))
		flag_init(wait_for);
	flag_wait( wait_for );
	
	self setturrettargetent( target );
	wait(0.3);
	self fireweapon();
	wait(0.05);
	self fireweapon();
	target kill(self.origin, self, self);
}

spawn_apache()
{
	apachespawner = getent("attack_apache", "script_noteworthy");
	apache = vehicle_spawn(apachespawner);
	apache setmaxpitchroll(10,60);
	
	return apache;
}

spawn_playerbird()
{
	playerbirdspawner = getent("playerbird", "targetname");
	playerbird = vehicle_spawn(playerbirdspawner);
	aud_send_msg("spawn_playerbird", playerbird);
	return playerbird;
}

#using_animtree( "generic_human" );

spawn_deadbird()
{
	deadbirdspawner = getent("deadbird", "targetname");
	deadbird = vehicle_spawn(deadbirdspawner);
	aud_send_msg("spawn_deadbird", deadbird);
	deadbirdcrashlocation = getent("dead_little_bird_crash_location", "script_noteworthy");
	deadbird.perferred_crash_location = deadbirdcrashlocation;
	deadbird.enableRocketDeath = false;
	deadbird.ignore_death_fx = true;
	return deadbird;	
}

spawn_intro_helicopters()
{
	intro_helicopters = getEntArray("ambient_helicopter","targetname");
	array_thread( intro_helicopters, ::add_spawn_function, ::godon );
	level.intro_heli = [];
	foreach(heli in intro_helicopters)
	{
		ent_to_add = heli spawn_vehicle();
		ent_to_add setmaxpitchroll(20,60);
		level.intro_heli = array_add(level.intro_heli, ent_to_add);
	}
}

intro_heli_ride_sandman_anims()
{
	//level.lone_star thread dialog_prime( "berlin_cby_graniteteam" );//made into RAM
	//set his looping idle anim
	level.lone_star thread anim_loop_solo(level.lone_star, "heli_ride", "intro_heli_hit");
	//Sandman: Granite team is hitting the target building - we drew overwatch! The president's daughter should still be inside the hotel!
	level.lone_star thread dialogue_queue( "berlin_cby_graniteteam" );

	flag_wait ( "intro_heli_hit" );
	level.lone_star notify ( "intro_heli_hit" );

	// do his crash reaction anim
	level.lone_star anim_single_solo ( level.lone_star, "heli_crash_reaction");
}

heli_ride_ambient(deadbird)
{
	array_thread(level.intro_heli,::gopath);
	
	thread javelin_attack();
	
	little_bird_crasher = spawn_ambient_little_bird_crasher();
	little_bird_crasher setmaxpitchroll(10,40);
	little_bird_crasher thread monitor_little_bird_crasher();
	
	attack_apache2_spawner = getEnt("attack_apache2","script_noteworthy");
	attack_apache2 = vehicle_spawn(attack_apache2_spawner);
	attack_apache2 setmaxpitchroll(20,60);
	gopath(attack_apache2);
	attack_apache2 thread monitor_attack_apache("attack_apache2_fire","apache_attack2_target");
	
	attack_apache3_spawner = getEnt("attack_apache3","script_noteworthy");
	attack_apache3 = vehicle_spawn(attack_apache3_spawner);
	attack_apache3 setmaxpitchroll(20,60);
	attack_apache3 godon();
	gopath(attack_apache3);
	attack_apache3 thread monitor_attack_apache("attack_apache3_fire", "apache_attack3_target");
	attack_apache3 thread monitor_attack_apache("player_unloaded_from_intro_flight", "apache_attack3_target2");
	deadbird godon();
	deadbirdcrashlocation = getent("dead_little_bird_crash_location", "script_noteworthy");
	deadbird thread berlin_littlebird_crash( deadbirdcrashlocation );
	thread monitor_aa_building_Rpg_attack(deadbird);
	thread aa_building_rpg_attacker_hit_deadbird(deadbird);
	deadbird thread monitor_deadbird_force_kill();
	flag_wait("apache_fire2");
	
	flag_wait("player_unloaded_from_intro_flight");
	
	level notify("stop_battlefield_effects");	//stop battlefield effects
	level notify("stop_drone_spawner");	 //stop battle drones
	
}

spawn_ambient_little_bird_crasher()
{
	crasherspawner = getent("ambient_little_bird_crasher", "targetname");
	crasher = vehicle_spawn(crasherspawner);
	crashercrashlocation = getstruct("ambient_little_bird_crash_location", "targetname");
	crasher.perferred_crash_location = crashercrashlocation;
	crasher.enableRocketDeath = true;
	gopath(crasher);
	return crasher;	
}

javelin_attack()
{
	flag_wait("start_sandman_vo");
	wait(.5);
	
	launch_site_arr = getstructarray("javelin_launch_site","targetname");
	assert(launch_site_arr.size > 2);
	launch_target_behind = getEnt("javelin_target_behind","targetname");
	javelin1 = launch_target_behind fake_javelin(launch_site_arr[0]);
	aud_send_msg("intro_javelin_fire_1", javelin1);
	
	flag_wait("ambient_little_bird_hit");
	wait(3.8);
	
	javelin_target_riverfront = getEnt( "javelin_target_riverfront", "targetname" );
	javelin3 = javelin_target_riverfront fake_javelin(launch_site_arr[1]);
	aud_send_msg("intro_javelin_fire_3", javelin3);
}

monitor_little_bird_crasher()
{
	flag_wait("start_sandman_vo");
	wait(4.2);
	jav_launcher = getstruct("ambient_little_bird_crasher_missile_fire","targetname");
	javelin2 = self fake_javelin(jav_launcher);
	aud_send_msg("intro_javelin_fire_2", javelin2);
}

monitor_deadbird_force_kill()
{
	self endon("death");
	flag_wait("deadbird_kill");
	self notify("death");
}

//to replace monitor_deadbird_force_kill?
array_message_relay( arr, self_endon_arr, waitfor, self_notify )
{
	if(!isarray( arr ) )
		arr = [ arr ];
	foreach(a in arr)
	{
		a thread message_relay_proc( self_endon_arr, waitfor, self_notify );
	}
}

message_relay_proc( self_endon_arr, waitfor, self_notify )
{
	foreach( e in self_endon_arr )
	{
		self endon(e);	
	}
	
	flag_wait(waitfor);
	
	foreach( n in self_notify )
	{
		self notify(n);	
	}
}

monitor_aa_building_rpg_attack(deadbird)
{
	flag_wait("aa_building_start_rpg_attackers");
	rpg_attackers = array_spawn_noteworthy("aa_building_rpg_attacker");
	array_thread(rpg_attackers, ::aa_building_rpg_attacker_hit_building);
}

aa_building_rpg_attacker_hit_deadbird(rocket_target)
{
	flag_wait("apache_fire2");
	spawner = getent("aa_building_rpg_attacker_scripted", "script_noteworthy");
	attacker = spawner spawn_ai( true );
	attacker thread magic_bullet_shield();
	attacker place_weapon_on( "stinger_speedy", "back" );
	attacker.animname = "generic";
	anim_ent = getent("aa_building_rpg_attack_anim", "targetname");
	
	anim_ent anim_reach_solo(attacker, "contengency_rocket_moment");
	attacker place_weapon_on( "stinger_speedy", "chest" );
	anim_ent thread anim_single_solo( attacker, "contengency_rocket_moment" );
	
	attacker waittillmatch( "single anim", "fire rocket" );
	flag_set( "rpg_attacker_fires" );
	org_hand = attacker gettagorigin( "TAG_INHAND" );
	rocket_target godoff();
	stinger = magicbullet( "stinger_speedy", org_hand, rocket_target.origin );
	stinger missile_setTargetEnt(rocket_target);

	aud_send_msg("RPG_fires_at_deadbird", stinger);

	attacker thread stop_magic_bullet_shield();
	attacker place_weapon_on( "stinger_speedy", "none" );
	thread MagicBulletWrapper( level.friendly_sniper_weapon, level.lone_star.origin, attacker.origin + (0,0,32), attacker );
	//rocket_target notify("death");
	attacker waittillmatch( "single anim", "end" );
}

aa_building_rpg_attacker_hit_building()
{
	self endon("death");
    self.old_weapon = self.weapon;
    self.animname = "generic";
    self forceUseWeapon( "rpg" , "primary" );

    self waittill("goal");
    
	wait(3.5);

	target_org = getstruct("amb_missile_hit", "targetname");
   	org_hand = self gettagorigin( "TAG_INHAND" );
   	stinger = magicbullet( "stinger_speedy", org_hand, target_org.origin );	

    self forceUseWeapon( self.old_weapon , "primary" );

    self.script_forcegoal =0;
    
    while(isdefined(stinger))
    {
    	wait(0.05);	
    }
    playfx( getfx("tank_shot_impact"), target_org.origin);
    self.ignoreall = false;
}

monitor_attack_apache(flag_wait_name, apache_target_name)
{
	flag_wait(flag_wait_name);
	apache_target = getent(apache_target_name, "targetname");
	self heli_fire(apache_target, 3);
	apache_target delete();
}

despawn_intro()
{
	//removing the tank column
	intro_ents = getentarray("intro_vehicle_column", "script_noteworthy");
	foreach(ent in intro_ents)
	{
		ent delete();
	}
	
	street_battle_drones = getentarray("flyover_street_battle", "targetname");
	array_delete( street_battle_drones );
}

rooftop_action(apache, deadbird)
{
	apache godon();

	flag_wait("apache_fire1");
	
	apache_target = getent("aa_building_hit0", "targetname");
	apache heli_fire(apache_target, 3);
	apache_target delete();
	aud_send_msg("apache_fires_missiles1", apache);
	
	apache_target = getent("aa_building_hit1", "targetname");
	apache heli_fire(apache_target, 2);
	apache_target delete();
	aud_send_msg("apache_fires_missiles2", apache);
	
	apache_target = getent("aa_building_hit2", "targetname");
	apache heli_fire(apache_target, 3);
	apache_target delete();
}

cheap_hind_fire( target )
{
	assert( isDefined( target ) );
	self waittill( "cheap_hind_fire" );
	self thread maps\_helicopter_globals::fire_missile( "hind_rpg_cheap", 3, target, 0.3 );
}

heli_fire( target, weaponIdx, num_shots, offset )
{
	if(!isdefined(weaponIdx))
		weaponIdx = 1; //20mm
		
	if(!isdefined(num_shots))
		num_shots = 1;

	if(!isdefined(offset))
		offset = (0,0,0);
		
	self SetTurretTargetEnt( target );
	
	cur_weap = level.apache_weapons[weaponIdx];
	tag_arr = level.apache_tags[weaponIdx];
	self SetVehWeapon( cur_weap );
	
	for(j = 0; j < num_shots; j++)
	{
		missile = self FireWeapon( tag_arr[ j % tag_arr.size ], target, offset );
		aud_send_msg("apache_fire_missile", missile);
		
		if(isdefined(missile))
			missile delayCall( 1, ::Missile_ClearTarget );
		
		if( weaponIdx == 1 )
			wait( .1 );
		else
			wait RandomFloatRange( 0.2, 0.3 );	
	}
}

monitor_little_bird_unload(playerbird)
{
	flag_wait("little_bird_unload_at_next_node");
	
	autosave_by_name( "little_bird_unload_01" );

	level.lone_star notify("stop_heli_ride_anim");
	
	exit_pos = getstruct("player_exit_little_bird", "script_noteworthy");

	
	playerbird waittill_any( "goal", "near_goal" );

	playerbird waittill("unloading");
	level.player lerp_player_view_to_position( exit_pos.origin, level.player.angles, .5, .1 );
	level.player unlink();
	flag_set("player_unloaded_from_intro_flight");
}

berlin_littlebird_crash( crashStruct )
{
	assert(isdefined(crashStruct));
	assert(isdefined(crashStruct.origin));
	while( isdefined( self ) )
	{
		self waittill( "damage", amount, attacker, enemy_org, impact_org, type );
		if ( !isdefined( type ) )
			continue;
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( amount ) )
			continue;
		if ( isplayer( attacker ) )
			continue;
		if ( ( type == "MOD_PROJECTILE" ) && ( amount > 999 ) )
			break;
		if ( ( type == "MOD_PROJECTILE_SPLASH" ) && ( amount == 4000 ) )
			break;
	}
	flag_set( "intro_heli_hit" );
	self vehicle_detachfrompath();
	self setvehgoalpos( crashStruct.origin, false );
	aud_send_msg("deadbird_hit", self);
	earthquake( .3, 1.5, level.player.origin, 1600 );
	self Vehicle_SetSpeed( 80 );
	self thread littlebird_spinout();
	
	array_thread( self.riders,::berlin_littlebird_rider_death, self );
	playfxOnTag( getfx( "crash_main_01" ), self, "tag_deathfx" );
	while ( distance( self.origin, crashStruct.origin ) > 100 )
	{
		playfxOnTag( getfx( "chopper_smoke_trail" ), self, "tag_deathfx" );
		wait( .1 );
	}
	aud_send_msg("deadbird_crash", self);
	dummy = spawn( "script_origin", self gettagorigin( "tag_deathfx" ) );
	playfx( getfx( "crash_end_01" ), dummy.origin );
	earthquake( .3, 2, level.player.origin, 1600 );
	self delete();
	dummy delete();
	
	foreach( r in self.riders )
	{
		if(isdefined(r) && isalive(r))
			r kill();
	}
	
	level.player delaythread( 2.3, ::play_rumble_on_entity, "light_1s" );
}

play_rumble_on_entity( rumblename )
{
	self PlayRumbleOnEntity( rumblename );
}

littlebird_spinout()
{
	self SetMaxPitchRoll( 100, 200 );
	self setturningability( 1 );
	yawspeed = 1400;
	yawaccel = 200;
	targetyaw = undefined;

	while ( isdefined( self ) )
	{
		targetyaw = self.angles[ 1 ] - 300;
		self setyawspeed( yawspeed, yawaccel );
		self settargetyaw( targetyaw );
		wait 0.1;
	}
}

berlin_littlebird_rider_death( heli )
{
	//3
	if ( ( self.vehicle_position == 0 ) || ( self.vehicle_position == 1 ) )
		return;
	tag = "tag_detach_left";
	self.ragdoll_getout_death = 1;
	linked = false;
	
	sAnim = undefined;
	if ( ( self.vehicle_position == 2 ) || ( self.vehicle_position == 3 ) || ( self.vehicle_position == 4 ) )
	{
		tag = "tag_detach_right";
	}
	
	if ( ( self.vehicle_position == 2 ) || ( self.vehicle_position == 5 ) )
		sAnim = "little_bird_death_guy1";
	else if ( ( self.vehicle_position == 3 ) || ( self.vehicle_position == 6 ) || ( self.vehicle_position == 7 ) )
		sAnim = "little_bird_death_guy3";
	else if ( self.vehicle_position == 4 )
	{
		linked = true;
		sAnim = "little_bird_death_guy2";
	}
	
	self.animname = "generic";
	self setcontents( 0 );
	self stopanimscripted();
	self.skipdeathanim	= 1;
	self delaythread( randomfloatrange( .3, 1 ), ::play_sound_in_space, "generic_death_falling" );
	pos = heli gettagorigin( tag );
	angles = heli gettagangles( tag );
	dummy = undefined;
	
	if ( linked )
	{
		heli anim_generic( self, sAnim, tag );
	}
	else
	{
		dummy = spawn( "script_origin", pos );
		dummy.angles = angles;
		dummy thread updatePos( heli, tag );
		dummy thread ent_cleanup( heli );
		self unlink();
		self linkto( dummy );
		dummy anim_generic( self, sAnim );
		if( isdefined( self ) )
			self unlink();
	}
		
	if( isdefined( self ) )
		self kill();
}

ent_cleanup( ent )
{
	ent waittill( "death" );
	self delete();
}

updatePos( heli, tag )
{
	heli endon( "death" );
	self endon( "death " );
	org = undefined;
	while( true )
	{
		wait( 0.05 );
		org = heli gettagorigin( tag );
		self.origin = org;
	}
}

MagicBulletWrapper(weapon, from, to, kill_target)
{
	wait 0.2;
	magicbullet(weapon, from, to);
	if( isdefined( kill_target)  && isAlive( kill_target ) )
	{
		kill_target notify("killanimscript");
		node = getnode( "path_rpg_attacker_after_node", "targetname" );
		kill_target set_goal_node( node );
	}
	wait( 3 );
	if( isdefined( kill_target ) && isAlive( kill_target ) )
	{
		kill_target bloody_death();
	}
}


/**************************
CHOPPER CRASH
**************************/

start_indoor_think()
{
	aa_trigger_indoor_think_arr = GetEntArray( "aa_trigger_indoor_think", "targetname" );
	array_thread( aa_trigger_indoor_think_arr, ::monitor_indoor_think );
}

start_outdoor_think()
{
	aa_trigger_outdoor_think_arr = GetEntArray( "aa_trigger_outdoor_think", "targetname" );
	array_thread( aa_trigger_outdoor_think_arr, ::monitor_outdoor_think );
}

monitor_outdoor_think()
{
	assert( ( self.spawnflags & 1 ) || ( self.spawnflags & 2 ) || ( self.spawnflags & 4 ), "trigger_outdoor at " + self.origin + " is not set up to trigger AI! Check one of the AI checkboxes on the trigger." );

	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", guy );
		if ( !isAI( guy ) )
			continue;

		guy thread ignore_triggers( 0.15 );

		guy disable_cqbwalk();
	}	
}

monitor_indoor_think()
{
	assert( ( self.spawnflags & 1 ) || ( self.spawnflags & 2 ) || ( self.spawnflags & 4 ), "trigger_indoor at " + self.origin + " is not set up to trigger AI! Check one of the AI checkboxes on the trigger." );

	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", guy );
		if ( !isAI( guy ) )
			continue;

		guy thread ignore_triggers( 0.15 );

		guy enable_cqbwalk();
	}

}

monitor_building_throw()
{
	level.lone_star thread trigger_wait_multiple_once_from_targetname( "lone_star_near_building_throw", "lone_star_near_building_throw" ); //wait for sandman to be near position
	flag_wait("player_near_building_throw");
	
	aud_send_msg( "mus_enter_aa_building_stairwell" );
	
	guys = [];
	guys[0]= level.lone_star;
	victim = getent("building_throw_victim","script_noteworthy");
	volume = getent( "building_throw_clear_volume", "targetname" );
	
	//CLEAR OUT HALLWAY
	thread clear_enemies_in_volume( volume, "building_throw_victim" );
	victim add_spawn_function( ::path_if_cancelled );
	
	flag_wait( "lone_star_near_building_throw" );
	
	//HANDLE ALLY
	
	//path ally to position - he should already be there from color triggers
	building_throw_wait = getstruct("berlin_throw_from_building_delta_wait","targetname");
	guys[0] disable_ai_color();
	guys[0] set_goal_pos(building_throw_wait.origin);
	
	//setup ally think
	guys[0] thread building_throw_ally_think();
	
	//HANDLE ENEMY
	
	flag_wait("building_throw_start");
	level notify( "stop_clearing_enemies_in_volume" );
	
	//spawn enemy
	guys[1] = victim spawn_ai();
	
	//opportunity to cancel out
	if( ( !isDefined( guys[1] ) || !isAlive( guys[1] ) ) || player_can_see_ai( guys[1] ) )
	{
		level notify( "building_throw_cancelled" );
		guys[0] set_goal_node(getnode("essex_cover_after_throw", "targetname"));
		guys[0] enable_ai_color_dontmove();
		return;
	}
	
	//POINT OF NO RETURN
	guys[1] notify( "anim_point_of_no_return" );
	guys[1] thread building_throw_enemy_think();
	throw_off_building( guys );
	
	aud_send_msg( "mus_enter_aa_building_combat" );
}

path_if_cancelled()
{
	self endon( "death" );
	self endon( "anim_point_of_no_return" );
	
	level waittill( "building_throw_cancelled" );
	loc = getstruct( "building_throw_clear_loc", "targetname" );
	self set_goal_radius( 8 );
	self set_goal_pos( loc.origin );
}

clear_enemies_in_volume( volume, exclude_noteworthy )
{
	level endon( "stop_clearing_enemies_in_volume" );
	assert( isdefined( volume ) );
	loc = getstruct( volume.target, "targetname" );
	assert( isdefined( loc ) );
	
	has_exclude = false;
	if( isDefined( exclude_noteworthy ) )
		has_exclude = true;
	exclude_guy = undefined;
	
	while( 1 )
	{
		enemies = getaiarray( "axis" );
		
		foreach( enemy in enemies )
		{
			if( has_exclude && isDefined( enemy.script_noteworthy ) && enemy.script_noteworthy == exclude_noteworthy )
			{
				break;
			}
			else if( enemy isTouching( volume ) )
			{
				enemy thread handle_enemy_path_clear_volume( loc );
			}
		}
		
		wait( .2 );
	}
}

handle_enemy_path_clear_volume( loc )
{
	self endon( "death" );
	
	self set_goal_radius( 6 );
	self set_goal_pos( loc.origin );
	if( isdefined( loc.radius ) )
	{
		self waittill( "goal" );
		if( isdefined( self ) )
			self set_goal_radius( loc.radius );
	}
}

building_throw_ally_think()
{
	self endon( "death" );
	
	self.goalradius = 10;
	self.allowpain = false;
	self.disableBulletWhizbyReaction = true;
	self.ignoreall = true;
	self.ignoreme = true;
	
	level waittill_either( "building_throw_complete", "building_throw_cancelled" );
	
	self.allowpain = true;
	self.disableBulletWhizbyReaction = false;
	self.ignoreall = false;
	self.ignoreme = false;
}

building_throw_enemy_think()
{
	self endon( "death" );
	
	self.animname = "defender";
	self.allowpain = false;
	self.disableBulletWhizbyReaction = true;
	//self.ignoreall = true;
	self.ignoreme = true;
}

throw_off_building( guys )
{
	level.building_throw_fire_counter = 0;
	
	org = getstruct("berlin_throw_from_building","targetname");

	//spawn and setup victim
	
	org anim_reach_together(guys, "berlin_throw_from_building");
	//play paired
	if(isalive(guys[1]))
	{
		org anim_single_run(guys, "berlin_throw_from_building");
		if(isalive(guys[1]))
			guys[1] kill();
	}
	
	level notify( "building_throw_complete" );
	guys[0] set_goal_radius( 32 );
	guys[0] set_goal_node(getnode("essex_cover_after_throw", "targetname"));
	guys[0] enable_ai_color_dontmove();
}

monitor_aa_frag_throw()
{
	trig = getent("aa_frag_throw_trigger", "targetname");
	trig waittill("trigger");
	
	assert(isdefined(trig.script_noteworthy));
	targets = getstructarray(trig.script_noteworthy, "script_noteworthy");
	
	guy_arr = [ level.essex, level.truck];
	assert(targets.size == guy_arr.size);
	
	idx = 0;
	foreach(guy in guy_arr)
	{
		start = guy;
		end = targets[idx];
		manual_vel = ( end.origin - start.origin );
		
		//start offset
		offset = (0.1 * manual_vel[0],0.1 * manual_vel[1],96);
		start_org = start.origin + offset;
		
		//manual tweaking 
		tweak_vel = (1.1,1.1,3.3);
		manual_vel = manual_vel * tweak_vel;
	
		guy.grenadeWeapon = "fraggrenade";	
		guy MagicGrenadeManual(start_org, manual_vel, 2.3);
		
		/#
//		thread DLine(start_org, end.origin, 5);
//		thread DLine(start.origin, start_org, 5);
		#/
		wait(0.6);
		idx++;
	}
}

monitor_mainstreet_battle()
{
	flag_wait("mainstreet_battle_start");
	
	thread random_tracers( "mainstreet_west_tracer", "mainstreet_east_tracer","mainstreet_battle_stop");
	thread random_tracers( "mainstreet_west_tracer", "mainstreet_east_tracer","mainstreet_battle_stop");
	
	thread random_tracers( "alley_west_tracer", "alley_east_tracer","mainstreet_battle_stop");
	thread random_tracers( "alley_west_tracer", "alley_east_tracer","mainstreet_battle_stop");
	
	flag_wait("mainstreet_battle_stop");

	level notify("stop_battlefield_effects");	//stop battlefield effects
	level notify("stop_drone_spawner");	 //stop battle drones
}

WhileDefined( ents, check_interval )
{
	if(!isdefined(check_interval))
		check_interval = 0.05;
		
	assert(check_interval > 0);		
	
	done = false;
	
	while(!done)
	{
		wait(check_interval);
		
		done = true;
		foreach(e in ents)
		{
			if(isdefined(e))
				done = false;
				break;
		}	
	}
}

RemovePriority(pri)
{
	foreach( k,v in level.airspace_list )
	{
		if(v == pri)
		{
			level.airspace_list = array_remove_index(level.airspace_list, k);
			break;
		}
	}
}

NextPriority()
{
	level.berlin_airspace_checked++;
	high = 0;
	foreach( i in level.airspace_list )
	{
		if( i > high )
			high = i;
	}
	return high;
}

Acquire_AirSpaceLock( priority )
{
	thread airspace_fail_controller();
	
	if(!isdefined(priority))
		priority = 1;
		
	assert(priority >= 1);		

	if( !isdefined( level.berlin_reload_airspace_locked ) )
		level.berlin_reload_airspace_locked = 0;
		
	if( !isdefined( level.berlin_airspace_checked ) )
		level.berlin_airspace_checked = 0;
		
	if( !isDefined( level.airspace_list ) )
	{
		level.airspace_list = [];
	}
		
	level.airspace_list[level.airspace_list.size] = priority;
	
	//if its locked we wait
	while( level.berlin_reload_airspace_locked || NextPriority() != priority)
	{
		level waittill( "berlin_reload_airspace_open" );
	}
	
	RemovePriority(priority);
	
	level.berlin_reload_airspace_locked = priority;
}

airspace_fail_controller()
{
	level notify("airspace_fail_controller");
	level endon("airspace_fail_controller");
	
	while(1)
	{
		level waittill( "berlin_reload_airspace_open" );
		while( level.berlin_airspace_checked < level.airspace_list.size )
		{
			wait(0.05);
		}

		//no one claimed the airspace 
		if( !level.berlin_reload_airspace_locked && level.airspace_list.size)
		{
			RemovePriority(NextPriority());
			delaycall( 0.1, ::Release_AirSpaceLock);
		}
	}
}

Release_AirSpaceLock()
{
	//it would be great if we could be sure that we were the ones who owned the lock
	level.berlin_airspace_checked = 0;
	level.berlin_reload_airspace_locked = 0;
	level notify("berlin_reload_airspace_open");
}

mainstreet_hind_fire()
{
	self endon( "death" );
	
	target = getent( "mainstreet_heli1_fire_target", "targetname" );
	self cheap_hind_fire( target );
}

MonitorAABuildingAmbiance()
{
	//north is a trigger lookat
	thread MonitorAABuildingNorth("trigger_aa_building_north");
	
	trigger = getent("trigger_aa_building_east", "targetname");
	trigger thread MonitorAABuildingEast();
	
	trigger = getent("trigger_aa_building_west", "targetname");
	trigger thread MonitorAABuildingWest();
	
	trigger = getent("trigger_aa_building_south", "targetname");
	heli = trigger MonitorAABuildingSouth();
	
	flag_wait("player_on_roof");
	thread guyOutWindow("roof_guy", "roof_scene", "snipe_player_in_position");
}

MonitorRadiusDamageOn(flag_name)
{
	self godon();
	while(isdefined(self))
	{
		level waittill(flag_name);
		glassradiusDamage( self.currentnode.origin, 256, 1000, 100 );
		PhysicsJitter( self.currentnode.origin, 1024, 0.0, 0.5, 4.0 );
		flag_clear(flag_name);
		wait(0.05);
	}
}

MonitorAABuildingNorth(flag_name)
{
	level endon ("player_on_roof");
	level waittill(flag_name);
	spawner = getent("flyby_a10", "targetname");
	veh = spawner thread spawn_vehicle_and_gopath();
	aud_send_msg("spawn_aabuilding_a10_flyby", veh);
	//veh thread MonitorRadiusDamageOn("aa_a10_window_break");
}

MonitorAABuildingEast()
{
	level endon ("player_on_roof");
	self waittill("trigger");
}
	
MonitorAABuildingSouth()
{
	level endon ("player_on_roof");
	self waittill("trigger");
	spawner = getent("hind_flyby_spawner", "targetname");
	heli = spawner spawn_vehicle_and_gopath();
	heli setmaxpitchroll(10,60);
	aud_send_msg("hind_flyby_stairwell", heli);
	return heli;
}
	
MonitorAABuildingWest()
{
	level endon ("player_on_roof");
	self waittill("trigger");
}


/***********************
SNIPER SCRIPT
***********************/

roof_top_sniper()
{
	//SETUP
	//rooftop sniping
	level.sniper_kills							= 0;
	level.player_sniper_kills					= 0;
	
	//7 dudes patrol
	level.total_rooftop_patrollers				= 7;
	//6 dudes run out left upper roof
	level.total_upperroof_enemies				= 6;
	level.total_roof_kills_needed				= level.total_rooftop_patrollers + level.total_upperroof_enemies; 

	level.delta_squad_at_goal					= 0;
	level.sniper_tanks_dead						= 0;
	level.additional_sniper_time				= 0;
	level.rooftop_sniper_timer_mod				= 2;
	
	//Street level combat
	level.sniper_parkway_kills					= 0;
	level.sniper_parkway_player_kills			= 0;
	level.sniper_parkway_total_kills			= 15;
	assert(level.rooftop_sniper_timer_mod > 0);
	
	level.allow_ambient_missiles = true;
		
	//ROOF TOP COMBAT
	setup_hotel_rooftop_battle();
	thread spawn_ambient_ally_helis();
	thread berlin_reload_events("sniper_complete");
	
	//add_override_shadow_loc_in_special_scope("shadow_override_upper_roof");
	//add_override_shadow_loc_in_special_scope("shadow_override_granite_drop_off");
	//add_override_shadow_loc_in_special_scope("shadow_override_lower_roof");
	
	flag_wait_either("aa_building_level4_dead", "snipe_player_in_position");
	aud_send_msg( "mus_aa_building_roof_guys_dead" );
	thread put_friendlies_into_sniping_pos();//needs to come after roof_top_snipe_ai_threats because of start point issues
	thread glowy_sniper_rifle();
	
	flag_wait( "snipe_player_in_position" );
	autosave_by_name( "sniper_01" );
	
	thread path_patrollers_around();//dev task to make enemies look busy
	thread spawn_delta_support_squad(); //granite team in heli

	array_thread( level.heroes , ::set_accuracy, 1.5, "sniper_complete" ); //set ally accuracy high so they can help
	
	flag_wait( "bravo_team_spawned" );
	thread spawn_hotel_rooftop_enemies();	//spawn roof top dudes on the left - 6 dudes
	thread delta_squad_movement(); //Handle movement across roof to the rappel location
	
	flag_wait( "sniper_delta_support_squad_unloaded" );
	autosave_by_name( "sniper_02" );
	
	flag_wait( "snipe_hotel_roof_complete" );
	autosave_by_name( "sniper_03" );
	
	level.allow_ambient_missiles = false;
	
	//STREET LEVEL COMBAT
	level.sniper_retreat_node = getstruct( "sniper_enemies_retreat", "targetname" );
	
	thread spawn_ground_level_enemies(); //handle enemy spawning down on the street
	thread spawn_sniper_tanks();
	thread monitor_sniper_tanks_dead();
	thread heros_fire_control_for_scene(); //set ally ai to ignore all during granite death scene
	thread roof_top_enable_a10();

	
	level waittill("last_sniper_tank_dead");
	
	autosave_by_name( "sniper_04" );
	
	clean_up_sniper_section();
}

path_patrollers_around()
{
	nodes = getnodearray( "sniper_rooftop_nodes", "targetname" );
	foreach( guy in level.sniper_patrollers )
	{
		nodes = array_randomize( nodes );
		node = nodes[0];
		
		if( isDefined( guy ) && isAlive( guy ) && isDefined( node ) )
		{
			guy thread path_sniper_patroller( node );
			nodes = array_remove( nodes, node );
			wait( randomfloatrange( 1, 2 ) );
		}
	}
}

path_sniper_patroller( node )
{
	self endon( "death" );
	
	old_goalradius = self.goalradius;
	self set_goal_radius( 32 );
	self set_goal_node( node );
	self waittill( "goal" );
	wait( 3 );
	self set_goal_radius( old_goalradius );
}

sniper_objectives()
{
	flag_wait("snipe_player_in_position");
	
	level.snipe_obj_num = level.objective_count;
	Objective_Add( level.snipe_obj_num, "current", &"BERLIN_SNIPE_B" );
	level.objective_count++;

	if( !flag( "sniper_hotel_roof_clear" ) )
	{
		Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_TARGETS" );
		level.sniper_patrollers thread keep_obj_on_average_pos( level.snipe_obj_num, "sniper_hotel_roof_clear" );
	}
	
	flag_wait( "bravo_team_spawned" );
	flag_wait_either( "sniper_hotel_roof_clear", "sniper_delta_support_squad_unloaded" );
	wait( .05 ); //avg_pos_cleanup will nuke our objective since they listen for the same message, lets wait a frame
	
	Objective_OnEntity( level.snipe_obj_num, level.delta_support_squad[3] );
	Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_PROTECT");
	
	flag_wait( "spawn_hotel_rooftop_enemies_complete" );
	
	Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_TARGETS" );
	level.hotel_snipe_roof_enemies thread keep_obj_on_average_pos( level.snipe_obj_num, "snipe_hotel_roof_complete" );
	
	flag_wait( "snipe_hotel_roof_complete" );
	wait( .05 );
	
	Objective_OnEntity( level.snipe_obj_num, level.delta_support_squad[3] );
	Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_PROTECT");
	
	/* WE MAY WANT THIS AT SOME POINT TO GET THE PLAYER'S ATTENTION DOWN ON THE STREET
	wait( 3 );
	Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_TARGETS" );
	level.parkway_snipe_enemies1 thread keep_obj_on_average_pos( level.snipe_obj_num, "paint_targets_vo" );
	*/
	
	flag_wait("tanks_scripted_fire");
	wait( 4 );
	
	Objective_Position( level.snipe_obj_num, (0,0,0) );
	level.air_support_obj_num = level.objective_count;
	Objective_Add( level.air_support_obj_num, "current", &"BERLIN_AIR_SUPPORT");
	level.objective_count++;
	Objective_SetPointerTextOverride( level.air_support_obj_num, &"BERLIN_DESTROY" );
	if( isAlive( level.sniper_tank_1 ) )
	{
		level.sniper_tank_1 thread obj_dot_on_tank(level.air_support_obj_num, 1 );
	}
	
	flag_wait( "spawn_sniper_tanks_complete" );
	
	if( isAlive( level.sniper_tank_3 ) )//probably don't need this check since it just spawned, but in case timing changes later.
	{
		level.sniper_tank_3 thread obj_dot_on_tank( level.air_support_obj_num, 3 );
	}
	if( isAlive( level.sniper_tank_2 ) )
	{
		level.sniper_tank_2 thread obj_dot_on_tank(level.air_support_obj_num, 2 );
	}
	
	flag_wait( "parkway_tank_dead" );
	objective_complete( level.air_support_obj_num );
	wait( .05 );
	
	Objective_OnEntity( level.snipe_obj_num, level.delta_support_squad[0] );
	Objective_SetPointerTextOverride(level.snipe_obj_num, &"BERLIN_GRANITE");
	
	flag_wait( "granite_team_dead" );
	Objective_Position( level.snipe_obj_num, (0,0,0) );
	
	flag_wait("sniper_complete");
	objective_complete( level.snipe_obj_num );
}

keep_obj_on_average_pos( obj_num, waitfor )
{
	level endon( waitfor );
	
	average_target_pos_ent = spawn( "script_model", ( 0, 0, 0 ) );
	average_target_pos_ent thread avg_pos_cleanup( obj_num, waitfor );
	Objective_OnEntity( obj_num, average_target_pos_ent );
	Objective_State_NoMessage( obj_num, "current" );
	
	last_update_size = 0;
	while ( IsDefined( self ) && self.size > 0 )
	{
		alive_arr = array_removedead(self);
		if(last_update_size != alive_arr.size)
		{
			last_update_size = self.size;
			average_position = ( 0, 0, 0 );
			total_guys = 0;
			lerp_position = false;
			foreach ( enemy in self )
			{
				if ( IsDefined( enemy ) && IsAlive( enemy ) )
				{
					average_position = average_position + enemy.origin;
					total_guys++;
				}
			}
			average_position = average_position / total_guys;
			
			//bump it up
			average_position += (0,0,128);

			//dont move if its not that much
			if(128 < Distance2D( average_target_pos_ent.origin, average_position ) )
				average_target_pos_ent.origin = average_position;
		}
		wait .25;
		
	}
	
	average_target_pos_ent notify("no_cleanup");
	Objective_Position( obj_num, (0,0,0) );
	average_target_pos_ent Delete();
	
	wait( .05 );
}

avg_pos_cleanup( obj, waitfor )
{
	self endon("no_cleanup");
	flag_wait( waitfor );
	Objective_position( obj, ( 0,0,0 ) );
	wait( .05 );
	self delete();
}

setup_hotel_rooftop_battle()
{
	//patrollers
	roof_top_spawners = getentarray("hotel_snipe_roof_enemies_patrol", "targetname");
	array_thread( roof_top_spawners, ::add_spawn_function, ::roof_top_enemy_think );
	array_thread( roof_top_spawners, ::add_spawn_function, ::snipe_hotel_roof_ai_death_counter, level.total_roof_kills_needed );
	level.sniper_patrollers = array_spawn( roof_top_spawners, true );
	
	//thread play_react_in_player_fov(level.sniper_patrollers);
	
	//street level friendlies
	level.sniper_friendlies = array_spawn_targetname( "sniper_support_friendlies" );
	array_thread( level.sniper_friendlies, ::sniper_friendlies_invulnerable );
	
	
	//threats
	thread setup_hotel_rooftop_battle_threatbiasgroups();
	
	//random fire at ents
	target_ents = getentarray( "sniper_dummy_targets", "targetname" );
	array_thread( level.sniper_patrollers, ::ai_random_fire_at_ents, target_ents, "snipe_player_in_position" );
}

sniper_friendlies_invulnerable()
{
	self magic_bullet_shield();
	
	flag_wait("start_parkway_tank");
	
	self stop_magic_bullet_shield();
}

setup_hotel_rooftop_battle_threatbiasgroups()
{
	//baddies
	smart_createthreatbiasgroup( "rooftop_axis" );
	level.sniper_patrollers array_setthreatbiasgroup( "rooftop_axis" );
	
	//street level friendlies
	smart_createthreatbiasgroup( "street_level_friendlies" );
	level.sniper_friendlies array_setthreatbiasgroup( "street_level_friendlies" );
	
	//heroes
	smart_createthreatbiasgroup( "friendlies" );
	level.heroes array_setthreatbiasgroup( "friendlies" );
	
	//player
	smart_createthreatbiasgroup( "player" );
	level.player SetThreatBiasGroup( "player" );
	
	//ignore player and heroes
	maps\_utility::ignoreEachOther( "friendlies", "rooftop_axis" );
	SetIgnoreMeGroup( "player", "rooftop_axis" );
	
	//enemies aware of street friendlies
	setthreatbias( "rooftop_axis", "street_level_friendlies", 100 );
	
	flag_wait( "snipe_player_in_position" );
	flag_wait( "allies_in_sniping_position" );
	
	setthreatbias( "friendlies", "rooftop_axis", 100 );
	setthreatbias( "rooftop_axis", "friendlies", 90 );
}

spawn_ambient_ally_helis()
{
	flag_wait( "player_halfway_through_rooftop" );
	
	Acquire_AirSpaceLock( 9 );
	level.rooftop_ally_helis = spawn_vehicles_from_targetname_and_drive( "sniper_friendly_ambient_helis" );
	aud_send_msg("ambient_ally_helis", level.rooftop_ally_helis);
	level.rooftop_ally_helis thread setup_ally_heli_survivors_and_victims();
	
	whileDefined( level.rooftop_ally_helis );
	Release_AirSpaceLock();
	level notify( "rooftop_ally_helis_dead" );
}

setup_ally_heli_survivors_and_victims()
{
	crash_loc = getstruct( "ambient_ally_heli_preferred_crash_loc", "targetname" );
	victim_helis = get_alive_from_noteworthy( "victim", level.rooftop_ally_helis );
	
	foreach( heli in self )
	{
		if( heli != victim_helis[0] )
		{
			heli SetCanDamage( false );
		}
		else
		{
			heli.preferred_crash_location = crash_loc;
			rpg_enemies_shoot_ambient_helis( victim_helis );
		}
	}
}

rpg_enemies_shoot_ambient_helis( victim_helis )
{
	level endon( "rooftop_ally_helis_dead" );
	
	flag_wait( "sniper_victim_heli_shoot" );
	
	rpg_dudes = get_alive_from_noteworthy( "rpg_guys", level.sniper_patrollers );
	wait( .05 );
	array_thread( rpg_dudes, ::set_preferredtarget, victim_helis[0] );
}

spawn_hotel_rooftop_enemies()
{
	flag_wait( "sniper_delta_support_squad_unloaded" );
	wait( 2 ); //"spawn_sniper_patrol_wave2"
	
	hotel_snipe_roof_enemies = getentarray("hotel_snipe_roof_enemies", "script_noteworthy");
	array_thread( hotel_snipe_roof_enemies, ::add_spawn_function, ::roof_top_enemy_think );
	array_thread( hotel_snipe_roof_enemies, ::add_spawn_function, ::snipe_hotel_roof_ai_death_counter, level.total_roof_kills_needed );
	level.hotel_snipe_roof_enemies = array_spawn(hotel_snipe_roof_enemies);
	
	flag_set( "spawn_hotel_rooftop_enemies_complete" );
}

clean_up_sniper_section()
{
	flag_wait( "sniper_delta_support_guys_dead" );
	flag_wait( "sniper_vo_complete" );
	
	assert(!flag("missionfailed"));

	flag_set("sniper_complete");
			
	level notify("stop_monitoring_reload");
	level notify("stop_processing_aim_vo_feedback");
		
	//clean up anyone we left on the street
	flag_wait("player_rappels");
	array_thread(getentarray("bravo_team_ground_enemies1","script_noteworthy"),::self_delete);
	array_thread(getentarray("bravo_team_ground_enemies1_2","script_noteworthy"),::self_delete);
	array_thread(getentarray("bravo_team_ground_enemies2","script_noteworthy"),::self_delete);
	array_thread(getentarray("bravo_team_ground_enemies3","script_noteworthy"),::self_delete);
	array_thread(getentarray("bravo_team_ground_enemies4","script_noteworthy"),::self_delete);
	array_thread(getentarray("bravo_team_ground_enemies5","script_noteworthy"),::self_delete);
	
	level.sniper_friendlies = array_removeDead( level.sniper_friendlies );
	array_thread(level.sniper_friendlies, ::self_delete );
	
	turn_off_shadow_override();
}

heros_fire_control_for_scene()
{
	flag_wait( "bravo_team_reached_lower_rooftop" );
	wait( 2 );
	array_thread( level.heroes, ::set_ignoreall, true );
	
	flag_wait("sniper_complete");
	array_thread( level.heroes, ::set_ignoreall, false );
}

sniper_enemies_run_away_think(retreat_node)
{
	self endon( "death" );
	
	flag_wait("parkway_tank_dead");
	wait( 10 );
	
	self.awareness = 1;
	self disable_awareness();
	self thread set_goal_pos( retreat_node.origin );
	wait( 5 );
	dummy_array = [];
	dummy_array[0] = self;
	thread ai_delete_when_out_of_sight(dummy_array, 1024);
}

ai_random_fire_at_ents( ents, wait_flag )
{
	self endon( "death" );
	self endon( "sniper_complete" );
	
	if( isDefined( wait_flag ) )
	{
		flag_wait( wait_flag );
	}
	
	wait( randomfloatrange( 1, 3 ) );
	
	while( true )
	{
		ents = array_randomize( ents );
		assert(isdefined(ents[0]));
		assert(isdefined( self ));
		self SetEntityTarget( ents[0] );
		wait( randomfloatrange( 1, 3 ) );
	}
}

spawn_delta_support_squad()
{
	flag_wait( "sniper_hotel_roof_spawn_helis" );
	Acquire_AirSpaceLock( 10 );
	
	flag_wait_or_timeout( "sniper_hotel_roof_clear", 17 );
	sniper_support_helis = spawn_vehicles_from_targetname_and_drive( "sniper_delta_support_helis" );
	aud_send_msg("sniper_support_helis", sniper_support_helis);
	
	//define heli types
	level.delta_support_main_heli = undefined;
	level.delta_suport_attack_helis = [];
	level.delta_support_protector_heli = [];
	
	foreach( heli in sniper_support_helis )
	{
		heli setCanDamage( false );
		if( isDefined( heli.script_noteworthy ) && heli.script_noteworthy == "sniper_delta_support_main_heli" )
		{
			level.delta_support_main_heli = heli;
			level.delta_support_main_heli magic_bullet_shield();
		}
		if( isDefined( heli.script_noteworthy ) && heli.script_noteworthy == "attacker" )
		{
			level.delta_suport_attack_helis[level.delta_suport_attack_helis.size] = heli;
			heli setmaxpitchroll(10,60);
		}
		if( isDefined( heli.script_noteworthy ) && heli.script_noteworthy == "protector" )
		{
			level.delta_support_protector_heli = heli;
			heli setmaxpitchroll(20,60);
		}
	}
	
	//define support squad from heli riders
	level.delta_support_squad = [];
	foreach( rider in level.delta_support_main_heli.riders )
	{
		if( isDefined( rider.script_noteworthy ) && rider.script_noteworthy != "sniper_delta_support_pilots" )
		{
			level.delta_support_squad[level.delta_support_squad.size] = rider;
		}
	}
	wait( .05 );//wait for everyone to spawn
	
	array_thread(level.delta_support_squad, ::magic_bullet_shield);
	
	flag_set("bravo_team_spawned");
	
	//heli is in a good spot to shoot up left over dudes
	attack_locs = getentarray( "granite_attack_heli_fire_locs", "targetname" );
	flag_wait( "delta_support_squad_heli_check_failure" );//this comes from radiant on heli's path
	
	foreach( heli in level.delta_suport_attack_helis )
	{
		heli thread heli_attack( level.sniper_patrollers, attack_locs );
	}
	level.delta_support_protector_heli  thread heli_attack( level.sniper_patrollers, attack_locs, 1, "start_heli_fire" );
	
	level.delta_support_main_heli waittill( "unloaded" );
	flag_set( "sniper_delta_support_squad_unloaded" );
	
	level.delta_support_main_heli stop_magic_bullet_shield();
	
	whileDefined( sniper_support_helis );
	Release_AirSpaceLock();
	level notify( "delta_support_helis_complete" );
}

//target_arr: these are the dudes it will shoot
//alt_locs: these are the alt locations it will shoot once all the dudes are dead
heli_attack( target_arr, alt_locs, weaponIdx, self_waittill, level_endon_arr )
{
	self endon( "death" );
	self endon( "stop_heli_fire" );//this comes from radiant on the heli_struct, script_noteworthy does a notify on the heli
	level endon( "stop_heli_fire" );
	
	if(isdefined(level_endon_arr) )
	{
		if(!isarray(level_endon_arr))
			level_endon_arr = [level_endon_arr];

		foreach( level_endon in level_endon_arr )
			level endon( level_endon );
	}
	
	if( isDefined( self_waittill ) )
	{
		self waittill( self_waittill );
	}
	
	if( !isdefined( weaponIdx ) )
	{
		weaponIdx = 3; //1 = "cobra_20mm", 2 = "cobra_Hellfire", 3 = "cobra_Sidewinder"
	}
	
	target_arr = array_removeDead( target_arr );
	
	if( target_arr.size > 0 )
	{
		target_arr = array_randomize( target_arr );
		
		foreach( target in target_arr )
		{			
			//no need to randomize again since the order has been scrambled
			if(isDefined( target ) && isAlive( target ) )
			{
				self heli_fire( target, weaponIdx, 1 );
				if(isalive( target ))
					target Kill();
			}
			wait(randomfloatrange( 0.1, .2 ) );
		}
	}
	
	if( isDefined( alt_locs ) )
	{
		alt_locs = array_randomize( alt_locs );
		foreach( alt_loc in alt_locs )
		{
			assert( isDefined( alt_loc ) );
			self heli_fire( alt_loc, weaponIdx, randomInt(2) + 1 );
		}
		wait(randomfloatrange( 0.1, .2 ) );
	}
}

spawn_sniper_tanks()
{
	wait( 2 );
	
	sniper_tank_spawners = getentarray( "sniper_tanks", "script_noteworthy" );
	tank_targets = getentarray( "sniper_tank_fire_loc", "script_noteworthy" );
	tank_scripted_targets = getentarray( "sniper_tank_fire_loc_alt", "script_noteworthy" );
	
	array_thread( sniper_tank_spawners, ::add_spawn_function, ::setup_sniper_tank );
	array_thread( sniper_tank_spawners, ::add_spawn_function, ::tank_fire_at_targets, tank_scripted_targets, 5, 7, "tanks_scripted_fire" );
	array_thread( sniper_tank_spawners, ::add_spawn_function, ::tank_fire_at_targets, tank_targets, 5, 7, "tanks_random_fire" );
	array_thread( sniper_tank_spawners, ::add_spawn_function, ::kill_path_on_death );//need to add this function to the tanks in case there are flag waits on nodes that may never get set and vehicle script doesn't endon death. causes bug if death happens first then the flag gets set.
	
	level.sniper_increase_time = 0;
	
	//tank 1
	level.sniper_tank_1 = spawn_vehicle_from_targetname_and_drive( "bravo_team_tank_first" );
	level.sniper_tank_1 thread mission_fail_sniper_tank( "sniper_tank_1_reached_path_end", 33 );
	aud_send_msg("sniper_tank_01", level.sniper_tank_1);
	
	wait( 4 );
	
	//SECOND TANK WAVE
	flag_wait("start_parkway_tank");
	wait( 2 );
	level.sniper_increase_time = 0; //reset for third tank
	
	//tank 2
	level.sniper_tank_2 = spawn_vehicle_from_targetname_and_drive("bravo_team_tank_second");
	level.sniper_tank_2 thread mission_fail_sniper_tank( "sniper_tank_2_reached_path_end", 12, "sniper_tank_2_mission_failing" );
	level.sniper_tank_2 thread increase_timer_on_death( 9 );
	aud_send_msg("sniper_tank_02", level.sniper_tank_2);
	
	wait( 5 );
	
	//tank 3
	level.sniper_tank_3 = spawn_vehicle_from_targetname_and_drive("bravo_team_tank_final");
	level.sniper_tank_3 thread mission_fail_sniper_tank( "park_way_tank_arrived", 15 );
	level.sniper_tank_3 thread increase_timer_on_death( 9 );
	aud_send_msg("sniper_tank_03", level.sniper_tank_3);
	
	flag_set( "spawn_sniper_tanks_complete" );
	
	wait( 2 );
	maps\berlin_a10::turn_on_a10_hud_hint();
}

increase_timer_on_death( time )
{
	level endon( "parkway_tank_dead" );
	self waittill( "death" );
	
	assert( isDefined( time ) );
	
	if( !isDefined( level.sniper_increase_time ) )
	{
		level.sniper_increase_time = 0;
	}
	
	level.sniper_increase_time = level.sniper_increase_time + time;
}

//COPIED THIS FROM WARLORD, WE REALLY SHOULD FIX THE VEHICLE CODE. ::vehicle_paths_non_heli( node ) SHOULD ENDON DEATH I THINK.
kill_path_on_death()
{
	// needed to fix what looks to be a bug in the vehicle code.
	//   vehicle_paths keeps running after a vehicle is killed, and if certain
	//   triggers/flags are hit, it will try to resume the vehicle after death
	
	// also kill path when driver is killed
	self wait_to_kill_path();
	self notify( "newpath" );
}

wait_to_kill_path()
{
	self endon( "death" );
	self endon( "driver dead" );
	level waittill( "eternity" );
}

setup_sniper_tank()
{
	self endon( "death" );
	self thread monitor_death_incoming();
	self maps\berlin_a10::a10_add_target();
  self thread maps\berlin_a10::a10_remove_target_ondeath();		
	self thread watch_tank_death();
	self thread self_delete_on_flag_set( "player_rappels" );
}

/* NOT USED
break_from_tank(goal)
{
	self endon( "death" );
	flag_wait( "sniper_tank_1_reached_path_end" );
	self set_goal_pos( goal.origin );
}
*/

monitor_sniper_tanks_dead()
{
	while( 1 )
	{
		if(	level.sniper_tanks_dead >= 1 )
		{
			flag_set("sniper_tanks_one_dead");
			flag_set("start_parkway_tank");
			break;
		}
		wait( 0.1 );
	}
	
	while( 1 )
	{
		if(	level.sniper_tanks_dead >= 2 )
		{
			flag_set("sniper_tanks_two_dead");
			break;
		}
		wait( 0.1 );
	}
	
	while( 1 )
	{
		if(	level.sniper_tanks_dead >= 3 )
		{
			flag_set( "parkway_tank_dead" );
			level notify("last_sniper_tank_dead");
			break;
		}
		wait( 0.1 );
	}
}

mission_fail_sniper_tank( flag, wait_time, flag_to_set_on_fail )
{
	self endon( "death" );
	
	if( isDefined( flag ) )
	{
		flag_wait( flag );
	}
	
	if( isDefined( wait_time ) )
	{
		wait( wait_time );
	}
	
	if( isDefined( level.sniper_increase_time ) )
	{
		wait( level.sniper_increase_time );
	}
	
	if( !isDefined( level.mission_failing ) )
	{
		level.mission_failing = false;
	}
	if( level.mission_failing )
	{
		return;
	}
		
	if( !self.death_pending ) //target has been marked a10s on their way, just in time
	{
		self notify( "stop_random_tank_fire" );
		if( isDefined( flag_to_set_on_fail ) )
		{
			flag_set( flag_to_set_on_fail );
		}
		
		self notify( "stop_firing" );
		self setturrettargetent(level.heroes[1]);
		wait( 3.7 );
		
		if( !self.death_pending && !level.mission_failing ) //target has been marked a10s on their way, just in time. Also other tank is causing the mission to fail.
		{
			level.mission_failing = true;
			self fireweapon(); 
			playfx( level._effect[ "artillery" ], level.heroes[1].origin );
			level.heroes[1] stop_magic_bullet_shield();
			level.heroes[1] kill();
			Objective_State(level.air_support_obj_num,"failed");
			SetDvar( "ui_deadquote", &"BERLIN_SNIPER_TANK_FAIL_QUOTE" );
			missionFailedWrapper();
		}
	}
}

berlin_reload_events( flag_end_on )
{
	thread maps\berlin_util::monitor_reload_event( flag_end_on ); //start reload events thread
	reload_count = 0;
	
	//needs to be level wide because of other ambient threads needing to respect this
	level.berlin_reload_amb_timer = GetTime();
	while(!flag(flag_end_on))
	{
		waittill_any("start_reload", flag_end_on);
		if(flag(flag_end_on))
			break;
			
		if(level.berlin_reload_amb_timer < GetTime())
		{
			level.berlin_reload_amb_timer = GetTime() + 10 * 1000; //10 seconds between events
			reload_count++;
			switch(reload_count)
			{
				case 1:
					Acquire_AirSpaceLock();
					veh_1 = spawn_vehicles_from_targetname_and_drive( "aa_building_flyover_1" );
					aud_send_msg("warthog_A10_flyby_01", veh_1);
					wait( 2 );
					veh_2 = spawn_vehicles_from_targetname_and_drive( "aa_building_flyover_2" );
					aud_send_msg("warthog_A10_flyby_02", veh_2);
					whileDefined( veh_1 );
					whileDefined( veh_2 );
					Release_AirSpaceLock();
					break;
				case 2:
					if( !isDefined( level.allow_ambient_missiles ) || level.allow_ambient_missiles == true )//saving vfx to prevent popping
					{
						Acquire_AirSpaceLock();
						veh_3 = spawn_vehicles_from_targetname_and_drive( "mainstreet_hind" );
						array_thread( veh_3, ::mainstreet_hind_fire );//making custom fire function so I can use the hind_rpg_cheap for vfx limits
						aud_send_msg("missile_hinds", veh_3);
						whileDefined( veh_3 );
						Release_AirSpaceLock();
					}
					break;
				case 3:
					Acquire_AirSpaceLock();
					veh_4 = spawn_vehicles_from_targetname_and_drive( "mainstreet_hind2" );
					aud_send_msg("mainstreet_hind2", veh_4);
					whileDefined( veh_4 );
					Release_AirSpaceLock();
					break;			
				case 4:
					Acquire_AirSpaceLock();
					veh_5 =spawn_vehicles_from_targetname_and_drive( "mainstreet_hind3" );
					aud_send_msg("mainstreet_hind3", veh_5);
					whileDefined( veh_5 );
					Release_AirSpaceLock();
					break;
				case 5:
					Acquire_AirSpaceLock();
					veh_6 = spawn_vehicles_from_targetname_and_drive( "mainstreet_hind_random" );
					whileDefined( veh_6 );
					Release_AirSpaceLock();
					break;
				case 6:
					Acquire_AirSpaceLock();
					veh_7 = spawn_vehicles_from_targetname_and_drive( "hind_attack_apache3_killer" );
					aud_send_msg("hind_attack_apache3_killer", veh_7);
					whileDefined( veh_7 );
					Release_AirSpaceLock();
					break;
			};
		}
	}
}

put_friendlies_into_sniping_pos()
{
	level.truck thread roof_top_snipe_setup_spotter_1();
	level.lone_star thread roof_top_snipe_setup_spotter_2();
	level.essex thread roof_top_snipe_setup_sniper();
}

glowy_sniper_rifle()
{
	check_for_sniper();
	sniper = getent( "aa_building_sniper_rifle", "targetname" );
	
	if( !flag( "stop_sniper_glow" ) )
	{
		sniper add_weapon_glow( "stop_sniper_glow" );
	}
}

check_for_sniper()
{
	weapons = level.player GetWeaponsListPrimaries();
	primary = level.player GetCurrentPrimaryWeapon();
	
	foreach( weapon in weapons )
	{
		if( weapon == level.secondary_weapon )
		{
			weapon_ammo = level.player GetAmmoCount( weapon );
			
			if( weapon == primary && weapon_ammo > 0 )
			{
				flag_set( "stop_sniper_glow" );
				return;
			}
		}
	}
	
	thread monitor_sniper_pickup();
}

monitor_sniper_pickup()
{
	level endon( "sniper_complete" );
	
	while( 1 )
	{
		weapons = level.player GetWeaponsListPrimaries();
		primary = level.player GetCurrentPrimaryWeapon();
		
		foreach( weapon in weapons )
		{
			if( weapon == level.secondary_weapon )
			{
				weapon_ammo = level.player GetAmmoCount( weapon );
				
				if( weapon == primary && weapon_ammo > 0 )
				{
					flag_set( "stop_sniper_glow" );
					return;
				}
			}
		}
		wait( .1 );
	}
}

add_weapon_glow( optional_glow_delete_flag, showWeapon )
{
	weapon_glow = Spawn( "script_model", ( 0, 0, 0 ) );
	weapon_glow SetContents( 0 );
	model = self.model + "_obj";
	weapon_glow SetModel( model );
	
	weapon_name = self.classname;
	if(string_starts_with( weapon_name, "weapon_" ) )
		weapon_name = getsubstr( weapon_name, 7 );
	weapon_glow update_weapon_tag_visibility( weapon_name, model );
	
	if( !isDefined( showWeapon ) || !showWeapon )
	{
		self Hide();
	}

	weapon_glow.origin = self.origin;
	weapon_glow.angles = self.angles;

	self add_wait( ::delete_on_not_defined );
	if ( IsDefined( optional_glow_delete_flag ) )
	{
		flag_assert( optional_glow_delete_flag );
		add_wait( ::flag_wait, optional_glow_delete_flag );
	}

	do_wait_any();

	if( isDefined( self ) )
		self Show();
	if( isDefined( weapon_glow ) )
		weapon_glow Delete();
}

monitor_roof_top_fail_timer(countToFailAt, amountOfTime, fail_quote, flag_to_end_on)
{
	level endon(flag_to_end_on);
	level.additional_sniper_time = amountOfTime * level.rooftop_sniper_timer_mod;
	assert(level.rooftop_sniper_timer_mod > 0);
	while(level.additional_sniper_time)
	{
		//account for each kill giving you more time
		assert(level.rooftop_sniper_timer_mod > 0);
		amountOfTime = level.additional_sniper_time * level.rooftop_sniper_timer_mod;
		level.additional_sniper_time = 0;
		wait(amountOfTime);
	}	
	
	if(level.player_sniper_kills < countToFailAt )
	{
		foreach(guy in level.delta_support_squad)
		{
			guy stop_magic_bullet_shield();
			wait(.05);
			guy kill();
		}
		
		//its possible and valid to not have this objective set before you fail
		if(isdefined(level.snipe_obj_num))
			Objective_State(level.snipe_obj_num,"failed");

		SetDvar( "ui_deadquote", fail_quote );
		missionFailedWrapper();
	}
}

delta_squad_movement()
{
	flag_wait( "sniper_delta_support_squad_unloaded" );
	activate_trigger_with_targetname( "sniper_delta_support_squad_path_roof_1" );
	
	flag_wait( "delta_support_squad_roof_advance_2" );
	activate_trigger_with_targetname( "sniper_delta_support_squad_path_roof_2" );
	
	flag_wait( "snipe_hotel_roof_complete" );
	activate_trigger_with_targetname( "sniper_delta_support_squad_path_roof_3" );
	
	flag_wait( "tanks_scripted_fire" );
	activate_trigger_with_targetname( "sniper_delta_support_squad_path_roof_4" );

	flag_wait( "parkway_tank_dead" );
		
	//start rappelling guys quickly
	level.delta_squad_ready_to_rappel = 0;
	level.delta_support_squad[0] thread delta_support_moveToRappel(0, "bravo_rappel_drop" );
	level.delta_support_squad[1] thread delta_support_moveToRappel(1, "bravo_rappel_drop02" );
	level.delta_support_squad[2] thread delta_support_moveToRappel(2, "bravo_rappel_drop03" );
	level.delta_support_squad[3] thread delta_support_moveToRappel(3, "bravo_rappel_drop04" );
	
	flag_wait( "bravo_team_reached_lower_rooftop" );
	wait( 2 );
	
	flag_wait_or_timeout( "player_looking_at_granite", 25 );
	flag_set( "player_looking_at_granite" );
	
	//move the team and do the breach
	support_squad_breach( level.delta_support_squad, "hotel_lower_door_animent");
	
	//path dudes into hotel when it's complete
	
	enter_hotel_loc = getstruct( "snipe_hotel_interior_loc", "targetname" );
	array_thread( level.delta_support_squad, ::set_goal_radius, 8 );
	array_thread( level.delta_support_squad, ::delta_support_next_node_wrapper, enter_hotel_loc.origin );

	flag_set( "delta_support_in_hotel" );
	
	wait(4);
	shoot_fx = getfx( "m16_muzzleflash" );	
	
	snipe_hotel_interior_fire_start = GetStruct( "snipe_hotel_interior_fire_start", "targetname" );

	snipe_hotel_interior_fire_end = GetStruct( "snipe_hotel_interior_fire_end", "targetname" );
	
	array_thread( level.delta_support_squad, ::stop_magic_bullet_shield );
	
	weapons_fire_time = 1.25;
	total_time = 0;
	while(total_time < weapons_fire_time)
	{
		level.player PlayFX( shoot_fx, snipe_hotel_interior_fire_start.origin);
		MagicBullet("ak47", snipe_hotel_interior_fire_start.origin, snipe_hotel_interior_fire_end.origin + randomOrigin( 32 ) );
		
		wait_time = 0.05;
		if(cointoss())
			wait_time = 0.15;
		
		total_time += wait_time;
		wait(wait_time);
	}
	
	flag_wait( "sniper_delta_support_guys_dead" );

	//play explosion fx, try to throw ragdolls out
	//playfx( getfx("tank_shot_impact"), snipe_hotel_interior_fire_end.origin);
	exploder(2222);
	aud_send_msg("granite_dead_room_explode", 2222);
	physicsexplosionsphere(snipe_hotel_interior_fire_end.origin, 200, 200, 3);
	array_call( array_removedead(level.delta_support_squad), ::kill );
	
	flag_set( "granite_team_dead" );
	
	flag_wait("sniper_complete");
	ai_delete_when_out_of_sight(level.delta_support_squad, 1024);
}

delta_support_next_node_wrapper( goal_pos )
{
	assert(isdefined(self.my_next_node_delay));
	wait( self.my_next_node_delay );
	self set_goal_pos(goal_pos);
}

support_squad_breach( guys, anim_ent_tname)
{	
	assert(guys.size == 4);

	kick_guys = [];
	foreach(g in guys)
	{
		if(g.breach_scene_role == "essex" || g.breach_scene_role == "lone_star")
		{
			kick_guys[kick_guys.size] = g;
			g.animname = g.breach_scene_role;
			g.my_next_node_delay = 0.05;
		}
		else
		{
			g thread go_to_node_with_targetname(g.breach_scene_role);
			g.my_next_node_delay = randomfloatrange(0.5, 2);
		}
	}
	
	anim_ent = getstruct(anim_ent_tname, "targetname");
	assert(isdefined(anim_ent));	
	
	anim_ent anim_reach_together(kick_guys, "breach_kick");
	flag_set("delta_support_breach_kick");
	anim_ent thread anim_single(kick_guys, "breach_kick");
	thread maps\berlin_fx::door_kick_vfx_1();
	wait(.4);
	door = getent("hotel_lower_roof_door", "targetname");
	assert(isdefined(door));
	door do_door_open();
}

randomOrigin( xRange, yRange, zRange )
{
	assert(isdefined(xRange));
	
	if(!isdefined(yRange))
	{
		yRange = xRange;
	}
	
	if(!isdefined(zRange))
	{
		zRange = yRange;	
	}
	
	v = [xRange,yRange,zRange];
	
	return (randomint(v[0]*2) - v[0], randomint(v[1]*2) - v[1], randomint(v[2]*2) - v[2]);
}



roof_top_enable_a10()
{
	//waiting for dialog to play
	flag_wait( "paint_targets_vo" );
	thread a10_decal_sniper_fix();
	thread maps\berlin_a10::airstrike_on(true);
}

a10_decal_sniper_fix()
{
	if( GetDvar( "r_polygonOffsetBiasMult", "not_set" ) != "not_set" )
	{
		SetSavedDvar( "r_polygonOffsetBiasMult", 0 );
		flag_wait("player_rappels");
		SetSavedDvar( "r_polygonOffsetBiasMult", 1 );
	}
}

delta_support_parkway_snipe_ai_think( retreat_node )
{
	self thread delta_support_parkway_snipe_ai_death_counter();
	
	self endon( "death" );
	
	self thread sniper_enemies_run_away_think( retreat_node );
	
	//random fire at ents
	target_ents = getentarray( "sniper_dummy_targets", "targetname" );
	self thread ai_random_fire_at_ents( target_ents, "parkway_tank_dead" );
	
	self setthreatbiasgroup( "axis" );
	self set_accuracy( .125 ); //1/8 accuracy
	self disable_long_death();
}

delta_support_parkway_snipe_ai_death_counter()
{
	self waittill("death", attacker);

	level.sniper_parkway_kills++;
	if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
	{
		level.sniper_parkway_player_kills++;
	}
	
	if(level.sniper_parkway_kills >= 6 && !flag( "delta_support_street_enemies4" ))
	{
		flag_set("delta_support_street_enemies4");
	}
}

spawn_ground_level_enemies()
{
	level endon( "parkway_tank_dead" );
	
	thread sniper_street_level_threatbias_think();
	wait( .05 );//wait for threat bias call
	
	//escort team
	tank_escort_team_spawners = getentarray( "bravo_team_ground_tank_escort", "script_noteworthy" );
	//goal = getstruct( "bravo_team_ground_enemies5_target1", "targetname" );
	//array_thread( tank_escort_team_spawners, ::add_spawn_function, ::break_from_tank, goal );
	array_thread( tank_escort_team_spawners, ::add_spawn_function, ::delta_support_parkway_snipe_ai_think, level.sniper_retreat_node );
	tank_escort_team = array_spawn_noteworthy( "bravo_team_ground_tank_escort" );
	//thread tank_walker_set_ai( tank_escort_team, level.sniper_tank_1 );
	
	wait( 7 );
	//flag_wait( "tanks_random_fire" );
	level.parkway_snipe_enemies1 = sniper_spawn_dudes_from_targetname( "bravo_team_ground_enemies3" );
	
	flag_wait( "delta_support_street_enemies4" );
	parkway_snipe_enemies2 = thread sniper_spawn_dudes_from_targetname( "bravo_team_ground_enemies5" );
}

sniper_spawn_dudes_from_targetname( targetname, wait_flag )
{
	if( isDefined( wait_flag ) )
	{
		flag_wait( wait_flag );
	}
	spawners = getentarray( targetname, "targetname" );
	array_thread( spawners, ::add_spawn_function, ::delta_support_parkway_snipe_ai_think, level.sniper_retreat_node );
	enemies = [];
	foreach( spawner in spawners )
	{
		current_enemies = getaiarray( "axis" );
		if( current_enemies.size <= 10 )
		{
			guy = spawner spawn_ai( true );
			enemies[enemies.size] = guy;
			if(isdefined(guy))
			{
				guy.dropWeapon = false;
			}
			
		}
		else
		{
			return enemies;
		}
	}
	return enemies;
}

sniper_street_level_threatbias_think()
{
	smart_createthreatbiasgroup( "player_other" );
	level.player setthreatbiasgroup( "player_other" );
	setignoremegroup( "player_other", "axis" );
	wait( .05 );
	
	//clear threat bias
	flag_wait( "sniper_complete" );
	
	smart_createthreatbiasgroup( "player" );
	level.player setthreatbiasgroup( "player" );
	wait( .05 );
}

obj_dot_on_tank( objective_id, index, objective_delay)
{
	
	if ( IsDefined( objective_delay ) )
	{
		wait objective_delay;
	}
	
	if(isAlive(self))
	{
		Objective_AdditionalEntity( objective_id, index, self, (0,0,128) ) ;
		self waittill("death");
		Objective_AdditionalPosition( objective_id, index, (0,0,0) ) ;
	}

}

watch_tank_death()
{
	self waittill( "death" );
	level.sniper_tanks_dead++;
}

roof_top_snipe_setup_spotter_1()
{
	//spotter 1 has binoculars
	org = getnode( "aa_building_spot_point", "targetname" );
	self disable_ai_color();
	
	self set_goal_radius( 8 );
	self set_goal_pos( org.origin );
	self waittill("goal");
	
	org anim_single_solo(self,"berlin_crouch_2_spotting");
	
	self thread anim_loop_solo(self,"sniper_escape_spotter_idle","stop_snipe_anim");	
	binocs = spawn( "script_model", (0,0,0) );
	binocs setmodel( level.scr_model[ "binocs" ] );
	binocs linkto( self, "TAG_INHAND", (0,0,0), (0,0,0) );
	
	//flag_wait( "snipe_hotel_roof_complete" );
	flag_wait( "sniper_complete" );
	
	self notify("stop_snipe_anim");
	binocs delete();
	flag_wait_or_timeout( "player_near_rappel", 5 );//wait time to prevent clumping. wait endson the flag
	flag_set( "truck_sniping_position_complete" );
}

roof_top_snipe_setup_spotter_2()
{
	//gets on the radio
	org = getstruct( "lone_star_spot_point", "targetname" );
	org anim_reach_solo( self, "sniper_escape_spotter_idle" );
	org anim_single_solo_gravity( self, "stand_2_crouch" );
	self anim_single_solo_gravity( self, "casual_crouch_idle_in" );
	self anim_single_solo_gravity( self, "bog_b_spotter_casual_2_spot" );
	self thread anim_loop_solo( self, "bog_b_spotter_spot_idle", "stop_snipe_anim" );
	
	flag_set( "allies_in_sniping_position" );
	
	//move into sniping position to help lonestar
	flag_wait( "sniper_delta_support_squad_unloaded" );
	self notify( "stop_snipe_anim" );
	self anim_single_solo( self, "bog_b_spotter_spot_2_casual" );
	self anim_single_solo( self, "casual_crouch_idle_out" );
	
	self AllowedStances( "crouch" );
	node = getnode( "aa_building_spot_point_2", "targetname" );
	self set_goal_radius( 8 );
	self set_goal_node( node );
	self waittill("goal");
	self set_goal_radius( 8 );
	
	//go back to radioing
	flag_wait( "parkway_tank_dead" );
	
	node anim_reach_solo( self, "sniper_escape_spotter_idle" );
	node anim_single_solo_gravity( self, "stand_2_crouch" );
	self anim_single_solo_gravity( self, "casual_crouch_idle_in" );
	self anim_single_solo_gravity( self, "bog_b_spotter_casual_2_spot" );
	self thread anim_loop_solo( self, "bog_b_spotter_spot_idle", "stop_snipe_anim" );
	
	//gets up and goes
	flag_wait( "sniper_complete" );
	
	self AllowedStances( "stand", "crouch", "prone" );
	self notify( "stop_snipe_anim" );
	self anim_single_solo( self, "bog_b_spotter_spot_2_casual" );
	self anim_single_solo( self, "casual_crouch_idle_out" );
	flag_wait_or_timeout( "player_near_rappel", 2 );//wait time to prevent clumping. wait endson the flag
	flag_set( "lone_star_sniping_position_complete" );
}

roof_top_snipe_setup_sniper()
{
	//sniper stays couched sniping
	org = getNode( "aa_building_snipe_point", "targetname" );
	self disable_ai_color();
	
	self set_goal_radius( 8 );
	self set_goal_pos( org.origin );
	wait( .05 );
	self waittill( "goal" );
	self AllowedStances( "crouch" );
	self set_goal_radius( 75 );
	
	self.old_weapon = self.weapon;
	//self animscripts\shared::placeWeaponOn( self.weapon, "right" );//use this for double weapon bug. Some previous animation is causing the weapon to not be placed in the right spot when it finishes.
	self forceUseWeapon( level.friendly_sniper_weapon, "primary" );
	
	flag_wait( "sniper_complete" );
	
	self AllowedStances( "stand", "crouch", "prone" );
	self forceUseWeapon( self.old_weapon, "primary" );
	flag_wait_or_timeout( "player_near_rappel", 1 );//wait time to prevent clumping. wait endson the flag
	flag_set( "grinch_sniping_position_complete" );
}

roof_top_enemy_think()
{
	self endon( "death" );
	
	self disable_long_death();
}

delta_support_moveToRappel(rappel_idx, drop_anim )
{
	self endon("death");
	anim_ent_arr = getstructarray( "delta_support_squad_rappel_loc", "targetname" );
	Assert(anim_ent_arr.size >= rappel_idx);
		
	self.rappel_struct = anim_ent_arr[rappel_idx];
	position_id = self.rappel_struct.script_noteworthy;
	Assert( isDefined( position_id ) );
	
	self setGoalPos(self.rappel_struct.origin);
	self.goalradius = 8;
	self waittill("goal");
	
	self thread handle_sniper_rappel_rope( drop_anim );
	
	self.animname = "generic";
	wait(1.0);
	self.rappel_struct anim_reach_solo( self, "bravo_rappel_mount" );
	self.rappel_struct anim_single_solo( self, "bravo_rappel_mount" );
	self.rappel_struct thread anim_loop_solo( self, "bravo_rappel_idle", "start_drop" );
	
	//level.delta_squad_ready_to_rappel++;
	
	//while( level.delta_squad_ready_to_rappel < level.delta_support_squad.size )
	//{
	//	wait( .05 );
	//}
	
	flag_set( "bravo_team_begin_rappel" );
	
	self delta_support_rappel( position_id, drop_anim );
}

delta_support_rappel( position_id, drop_anim )
{
	self.rappel_struct notify( "start_drop" );
	self stopanimscripted();
	
	buddy_and_rope[ 0 ] = self;
	
	if( isDefined( drop_anim ) )
		self.rappel_struct thread anim_single( buddy_and_rope, drop_anim );
	else
		self.rappel_struct thread anim_single( buddy_and_rope, "bravo_rappel_drop" );
	
	goal_arr = getNodearray("delta_support_on_ground_cover","targetname");
	target_goal = undefined;
	
	foreach( goal in goal_arr )
	{
		if( goal.script_noteworthy == position_id )
		{
			target_goal = goal;
			break;
		}
	} 
	Assert( isDefined( target_goal ) );
	
	self setGoalNode( target_goal );
	
	assert( isdefined( target_goal.script_parameters ) );
	self.breach_scene_role = target_goal.script_parameters;
	
	wait(.05);
	
	self waittill("goal");
	level.delta_squad_at_goal++;
	if( level.delta_squad_at_goal >= level.delta_support_squad.size )
	{
		flag_set( "bravo_team_reached_lower_rooftop" );
	}
}

handle_sniper_rappel_rope( drop_anim )
{
	self waittill( "spawn_rope" );
	assert( isDefined( self.rappel_struct ) );
	
	rope = spawn_anim_model( "rope", self.rappel_struct.origin );
	
	self.rappel_struct anim_first_frame_solo( rope, "bravo_rappel_mount" );
	
	self thread handle_sniper_rappel_rope_drop( rope, drop_anim );
	
	self.rappel_struct anim_single_solo( rope, "bravo_rappel_mount" );
	self.rappel_struct thread anim_loop_solo( rope, "bravo_rappel_idle", "start_drop" );
	
	flag_wait( "player_rappels" );
	rope delete();
}

handle_sniper_rappel_rope_drop( rope, drop_anim )
{
	self.rappel_struct waittill( "start_drop" );
	rope stopanimscripted();
	
	if( isDefined( drop_anim ) )
		self.rappel_struct thread anim_single_solo( rope, drop_anim );
	else
		self.rappel_struct thread anim_single_solo( rope, "bravo_rappel_drop" );
}

monitor_death_incoming()
{
	assert(!isdefined(self.death_pending));
	self.death_pending = false;
	self endon("death");
	level waittill("laser_coordinates_received");
	self.death_pending = true;
}

russian_snipe_setup_spotter(targetnode)
{
	org = getnode(targetnode,"targetname");
	self setGoalNode(org);
	self.goalradius = 10;
	wait(.05);
	self waittill("goal");
	wait(.5);
	if(isAlive(self))
	{
		org anim_single_solo(self,"berlin_crouch_2_spotting");	
		self thread anim_loop_solo(self,"berlin_crouch_2_spotting_idle","stop_snipe_anim");	
		binocs = spawn( "script_model", (0,0,0) );
		binocs setmodel( level.scr_model[ "binocs" ] );
		binocs linkto( self, "TAG_INHAND", (0,0,0), (0,0,0) );
		self.allowdeath = true;
		self waittill("death");
		binocs delete();
	}
}

russian_snipe_setup_sniper(targetnode)
{
	org = getNode(targetnode,"targetname");
	self setGoalNode(org);
	self.goalradius = 10;
}

bravo_team_essex_take_shot(targetEntArray)
{
	foreach(targetEnt in targetEntArray)
	{
		if(isAlive(targetEnt))
		{
			offset = (0,0, 16);
			if(targetEnt.a.pose == "stand")
				offset = (0,0, 32);
			else if(targetEnt.a.pose == "crouch")
				offset = (0,0, 24);
			magicbullet(level.friendly_sniper_weapon, level.essex.origin + (AnglesToForward( level.essex.angles ) * 60  ), targetent.origin + offset);
			wait(.2);
			targetEnt kill();
			wait(.5);
		}
	}
}

player_does_damage()
{
	level endon( "sniper_patrollers_alerted" );
	attacker = self;
	//stay in this loop until the player shoots the dude
	while( isdefined(attacker) && !isplayer(attacker))
	{
		self waittill( "damage", amount, attacker );
		wait( .05 );
	}
	level notify( "player_hit_patroller" );
}

snipe_hotel_roof_ai_death_counter(total_guys_to_kill)
{
	
	self waittill("death", attacker);
	level notify("snipe_hotel_roof_death");
	
	if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
	{
		level.player_sniper_kills++;
		level.additional_sniper_time += 5;
		level notify( "snipe_hotel_roof_player_kill" );
	}
	
	level.sniper_kills++;
	
	if( level.sniper_kills >= 2 )
	{
		flag_set( "sniper_hotel_roof_spawn_helis" );
	}
	
	if( level.sniper_kills >= total_guys_to_kill )
	{
		flag_set( "snipe_hotel_roof_complete" );
	}
	
	else if( level.sniper_kills >= total_guys_to_kill-2 )
	{
		flag_set( "delta_support_squad_roof_advance_2" );
	}
	
	else if( level.sniper_kills >= total_guys_to_kill-4 )
	{
		flag_set( "delta_support_squad_roof_advance_1" );
	}
	
	else if( level.sniper_kills >= level.total_rooftop_patrollers )
	{
		flag_set( "sniper_hotel_roof_clear" );
		flag_set( "spawn_sniper_patrol_wave2" );
	}
}

snipe_ai_think(total_guys_to_kill, flag_to_set)
{
	self waittill( "death", attacker );
	level endon( flag_to_set );

	if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
	{
		level.sniper_kills++;
	}
	
	if ( level.sniper_kills >= total_guys_to_kill)
	{
		//if(sniper_targets_alive() == 0){
			flag_set( flag_to_set );
		//}
	}
	else{
		respawn_sniper_target(total_guys_to_kill, flag_to_set);
	}
	

}

//used to respawn sniper targets if you have not killed enough or friendlies kill them.
respawn_sniper_target(total_guys_to_kill, flag_to_set)
{
		spawners = getentarray(self.script_noteworthy,"script_noteworthy");
		level endon( flag_to_set);
		while (1)
		{
			foreach(spawner in spawners){
				if(isDefined(spawner.spawnflags) && spawner.spawnflags == 1)
				{
					spawner.count++;
					wait(randomintrange(1, 6));
					guy = spawner spawn_ai();
					if(isdefined(guy))
					{
						guy thread snipe_ai_think(total_guys_to_kill, flag_to_set);
						return;
					}
				}
			}
			wait 0.5;
		}
}

sniper_targets_alive()
{
		ents = getentarray(self.script_noteworthy,"script_noteworthy");
		guys_alive=0;
		foreach(ent in ents)
		{
			if(!isSpawner(ent) && isAlive(ent))
			{
				guys_alive++;
			}
		}
		return guys_alive;
}

/* NOT USED
tank_walker_set_ai(escort_team,vehicle)
{
	for(i=0; i<6; i++)
	{
		if(isdefined(escort_team[i]))
		{
			org = vehicle getTagOrigin("tag_walker"+i);
			ent = spawn("script_origin", org);
			ent linkto(vehicle, "tag_walker"+i);
			escort_team[i] thread tank_walker_set(ent);
		}
	}
}

tank_walker_set(target_ent)
{
	self.goalradius = 300;
	self setgoalentity(target_ent, 200);
	
	self waittill("damage");

	self.last_set_goalnode 	 = undefined;
	self.last_set_goalpos 	 = self.origin;
	self.last_set_goalent 	 = undefined;
	self.goalradius = 512;

	target_ent delete();
}
*/

/***********************
RAPPEL SCIRPT
***********************/
spawn_rappel_ropes()
{
	level.lone_star thread spawn_ai_rope( "rappel_ai_anim_ent1" );
	level.essex thread spawn_ai_rope( "rappel_ai_anim_ent2" );
	level.truck thread spawn_ai_rope( "rappel_ai_anim_ent3" );
	
	spawn_rappel_rope("rappel_player_rope_obj", "rope_player", "rappel_player", "player_rope_long_obj");
}

buildingrappel()
{
	wait( .05 );//wait for other sniper section threads to finish up whatever they have to do
	
	thread player_rappel_building();
	
	level.lone_star thread hero_rappel_building( "rappel_ai_anim_ent1", "rappel_lone_star_wait" );
	level.essex thread hero_rappel_building( "rappel_ai_anim_ent2", "rappel_essex_wait" );
	level.truck thread hero_rappel_building( "rappel_ai_anim_ent3", "rappel_truck_wait" );
	
	flag_wait("player_rappels");
	
	SetSavedDvar( "compass", "0" );
	aud_send_msg("player_rappels");
	thread maps\berlin_fx::rappel_dof();//rappel depth of field
	thread rappel_ambient_a10();
	flag_set("rappel_end");
	
	flag_wait( "rappel_complete" );
	
	SetSavedDvar( "compass", "1" );
}

player_rappel_building()
{
	flag_set("player_can_rappel");
	
	level.building_rope_player hide();
	
	level.building_rope_player_obj = spawn_anim_model( "player_rope_long_obj" );
	ent = getstruct( "rappel_player_rope_obj", "targetname" );	
	ent anim_first_frame_solo( level.building_rope_player_obj, "rappel_player" );	
	
	flag_wait("player_near_rappel"); //the trigger in Radiant is waiting for "sniper_complete" before being active, if you change what comes before this change the radiant trigger.
	
	//Player rappel
	thread buildingrappel_player("rappel_animent", "rappel_player", "rappel_trigger", "player_rappels");	
}

hero_rappel_building( rappel_ent_targetname, waiting_node_targetname )
{
	rappel_ent = getstruct( rappel_ent_targetname, "targetname" );
	anim_name = "rappel_ai";
	
	//prevent clumping
	if( self == level.lone_star )
		flag_wait( "lone_star_sniping_position_complete" );//wait for his getup anim to finish from sniper section
	if( self == level.truck )
		flag_wait( "truck_sniping_position_complete" );
	if( self == level.essex )
		flag_wait( "grinch_sniping_position_complete" );
	
	self path_hero_to_rappel_waiting_spot( waiting_node_targetname );
	
	flag_wait( "player_near_rappel" );
	
	//handle truck
	if( self == level.truck )
	{
		self thread truck_path_and_rappel( rappel_ent, anim_name );
		return;
	}
	
	//handle lone star and grinch
	flag_wait( "player_rappels" );
	flag_wait( "rappel_teleport_dudes" );
	
	if( !self.reached_rappel_start_spot )//teleport dudes if they're falling behind
	{
		wait( randomfloatrange( .5, 2 ) );
		rappel_ent anim_first_frame_solo( self, anim_name );
	}
	self buildingrappel_ai( rappel_ent, anim_name );
	self enable_ai_color();
}

path_hero_to_rappel_waiting_spot( node_targetname )
{
	self notify( "rappel_new_goal" );
	self endon( "rappel_new_goal" );
	level endon( "rappel_teleport_dudes" );
	
	node = getnode( node_targetname, "targetname");
	self.rappel_start_spot = node;
	self.reached_rappel_start_spot = false;
	self set_goal_radius( 32 );
	self set_goal_node( node );
	self childthread hero_rappel_waittill_goal();
}

hero_rappel_waittill_goal()
{
	self waittill( "goal" );
	self.reached_rappel_start_spot = true;
}

truck_path_and_rappel( rappel_anim_ent, anim_name )
{
	self disable_ai_color();
	self.disablearrivals = true;
	
	self truck_path_to_rappel();
	
	self.disablearrivals = false;
	
	if( !self.reached_rappel_start_spot )
	{
		self AllowedStances( "stand" );
		rappel_anim_ent anim_first_frame_solo( self, anim_name );
	}
	self buildingrappel_ai( rappel_anim_ent, anim_name );
	
	finished_node = getnode( "path_truck_post_rappel", "targetname" );
	self set_goal_node( finished_node );
	self enable_ai_color();
	self AllowedStances( "stand", "crouch", "prone" );
}

truck_path_to_rappel( rappel_anim_ent, anim_name )
{
	node_1 = getnode( "rappel_truck_path_1", "targetname" );
	node_2 = getnode( "rappel_truck_path_1", "targetname" );
	
	self.rappel_start_spot = node_2;
	self.reached_rappel_start_spot = false;
	
	self notify( "rappel_new_goal" );
	self endon( "rappel_new_goal" );
	level endon( "rappel_teleport_dudes" );
	
	self set_goal_radius( 32 );
	self set_goal_node( node_1 );
	self waittill( "goal" );
	self set_goal_node( node_2 );
	self waittill( "goal" );
	self.reached_rappel_start_spot = true;
}

buildingrappel_ai( rappel_anim_ent, anim_name )
{
	self.fixednode = true;
	
	rappel_anim_ent anim_reach_solo( self, anim_name );
	self.rappelling = true;
	
	actors = [];
	actors[0] = self;
	actors[1] = self.rappel_rope;
	
	rappel_anim_ent thread anim_single_run( actors, anim_name);
	
	self.rappelling = undefined;
}

rappel_ambient_a10()
{
	//thread rappel_a10_explosion_rumble();
	wait(4.5);
	a10 = getEnt("a10_rappel","targetname");
	a10 = a10 spawn_vehicle_and_gopath();
	flag_wait("a10_rappel_start_firing");
	a10 thread maps\berlin_util::a10_muzzle_flash_fx("a10_rappel_stop_firing");
	aud_send_msg("a10_rappel_fire", a10);
	flag_wait("a10_rappel_start_shells");
	a10 thread a10_shell_ejects_fx("a10_rappel_stop_shells");
}

rappel_a10_explosion_rumble()
{
	flag_wait( "trigger_vfx_window_expl_rappel" );
	wait( 1.3 );
	level.player PlayRumbleOnEntity( "heavy_3s" );
	wait( 1.25 );
	level.player PlayRumbleOnEntity( "heavy_3s" );
	wait( 1.25 );
	level.player PlayRumbleOnEntity( "heavy_3s" );
}

//for benifit of the player lets thicken them up when it gets close to them
//player and a10 are on a rail
//no need to calc this every time
//establish a linear velocity and go with that
a10_shell_ejects_fx(stopFiringOnNotify){
	level endon(stopFiringOnNotify);
	fx = getfx("a10_shells");
	dist = [];
	dist[0] = distance2d( self.origin, level.player.origin );
	wait(0.05);
	dist[1] = distance2d( self.origin, level.player.origin );
	
	//get the change
	delta = dist[0] - dist[1]; 
	
	//it better be going down
	assert(delta > 0);
	
	delta_per_second = delta / 0.05;
	time_to_intercept = dist[1] / delta_per_second;
	
	time_on_path = 0.0;
	sleep_time = 0.05;
	
	while(1){
		nudge = 0.0;
		if(time_on_path == time_to_intercept)
			nudge = 0.01;
		percent = abs(1/(time_on_path - time_to_intercept + nudge));
		
		PlayFXOnTag( fx, self, "tag_gun" );
		org = self getTagOrigin("tag_gun");
		org_offset = (0,0,-1024);
		org += org_offset;
		
		forward = anglestoforward(self.angles) * -32;
		playfx(fx,org + forward);
		
		forward = anglestoforward(self.angles) * -64;
		playfx(fx,org + forward);
		
		forward = anglestoforward(self.angles) * 32;
		playfx(fx,org + forward);
		
		forward = anglestoforward(self.angles) * 64;
		playfx(fx,org + forward);
				
		if(percent > 10)
		{
			forward = anglestoforward(self.angles) * 96;
			playfx(fx,org + forward);
			
			forward = anglestoforward(self.angles) * -96;
			playfx(fx,org + forward);			
			
			if(percent > 20)
			{
				forward = anglestoforward(self.angles) * 16;
				playfx(fx,org + forward + (0, 0, 32) );
				
				forward = anglestoforward(self.angles) * -16;
				playfx(fx,org + forward + (0, 0, 32) );
				
				forward = anglestoforward(self.angles) * 16;
				playfx(fx,org + forward + (0, 0, 64) );
				
				forward = anglestoforward(self.angles) * -16;
				playfx(fx,org + forward + (0, 0, 64) );				
			
				if(percent > 80)
				{
					above_player = (level.player.origin[0], level.player.origin[1], org[2]);
					playfx(fx, above_player  );
					playfx(fx, above_player + (0, 0, 32) );
					playfx(fx, above_player + (0, 0, 64) );
					playfx(fx, above_player + (0, 0, 96) );
					playfx(fx, above_player + (0, 0, 128) );
				}
			}
		}
		
		
		wait(sleep_time);
		time_on_path += sleep_time;
	}
}


buildingrappel_player(player_ent_targetname, scene_name, trigger_noteworthy, flag_name)
{
	ent = SpawnStruct();
	ent.rope_obj = level.building_rope_player_obj;
	ent.rope = level.building_rope_player;
	ent.flag_name = flag_name;

	ent.anim_ent = getstruct( player_ent_targetname, "targetname" );
	ent.scene = scene_name;
	ent.unlink_time = 9.3;

	trigger_ent = GetEnt( trigger_noteworthy, "script_noteworthy" );

	// Press and hold^3 &&1 ^7to rappel.
	trigger_ent SetHintString( &"BERLIN_RAPPEL_HINT" );
	flag_wait( ent.flag_name );
	aud_send_msg("mus_player_rappel");
	
	trigger_ent Delete();

	maps\_shg_common::SetUpPlayerForAnimations();
	
	if ( IsDefined( ent.rope_obj ) )
		ent.rope_obj Delete();
	ent.rope_obj = undefined;

	// player rappels
	player_rig = spawn_anim_model( "player_rig", ent.anim_ent.origin );
	player_rig DontCastShadows();
	player_rig hide();
	
	ent.anim_ent anim_first_frame_solo( player_rig, ent.scene );
	
	player_legs = spawn_anim_model( "player_legs", ent.anim_ent.origin );
	player_legs hide();
	
	rope_carabiner = spawn_anim_model( "rope_carabiner", ent.anim_ent.origin );
	rope_carabiner hide();

	scene = [];
	scene[ 0 ] = ent.rope;
	scene[ 1 ] = player_rig;
	scene[ 2 ] = player_legs;	
	scene[ 3 ] = rope_carabiner;	

	level.player DisableWeapons();

	blend_time = 0.5;
	level.player PlayerLinkToBlend( player_rig, "tag_player", blend_time, 0.2, 0.2 );
	
	level.player waittill_notify_or_timeout("weapon_change", 2);
	
	show_time = 0.05;
	player_rig 		delayCall( show_time, ::Show );
	player_legs 	delayCall( show_time, ::Show );
	ent.rope 		delayCall( show_time, ::Show );
	rope_carabiner 	delayCall( show_time, ::Show );
		
	level.raptime = GetTime();
	
	level.player delayCall( ent.unlink_time, ::Unlink );
	level.player delayCall( ent.unlink_time - 0.35, ::EnableWeapons );
	level.player delayCall( ent.unlink_time - 0.35, ::allowcrouch, true );
	level.player delayCall( ent.unlink_time - 0.35, ::allowprone, true );

	player_rig delayCall( ent.unlink_time, ::Delete );
	player_legs delayCall( ent.unlink_time, ::Delete );
	rope_carabiner delayCall( ent.unlink_time, ::Delete );
	
	length = getanimlength( getanim_from_animname( ent.scene, scene[ 1 ].animname ) );
	delaythread( length, ::flag_set, "rappel_complete" );
	delaythread( .5, ::flag_set, "rappel_teleport_dudes" );
	
	ent.anim_ent anim_single( scene, ent.scene );
	
	maps\_shg_common::SetUpPlayerForGamePlay();
}

spawn_rappel_rope(player_ent_targetname, player_rope_name, player_anim_name, rope_obj_name)
{
	ent = getstruct( player_ent_targetname, "targetname" );
	level.building_rope_player = spawn_anim_model( player_rope_name );
	
	level.building_rope_player.animname = player_rope_name;
	ent anim_first_frame_solo( level.building_rope_player, "rappel_player_idle" );
	
	level.building_rope_player DontCastShadows();
}

spawn_ai_rope( rappel_ent_targetname )
{
	anim_ent = getstruct( rappel_ent_targetname, "targetname" );
	new_rope = spawn_anim_model( "ai_rope" );
	new_rope.animname = "ai_rope";
	self.rappel_rope = new_rope;
	anim_ent anim_first_frame_solo( new_rope, "rappel_ai" );
}


/*********************
DOWNED APACHE
*********************/

downed_apache_dudes()
{
	thread player_passed_downed_apache();
	thread downed_apache_corpses();
	thread downed_apache_paired_corpse();
}

player_passed_downed_apache()
{
	trigger_wait_targetname( "player_passed_apache" );
	flag_set( "player_passed_apache" );
}

downed_apache_corpses()
{
	spawners = [];
	spawner_1 = getent( "downed_apache_corpse_1", "targetname" );
	spawner_2 = getent( "downed_apache_corpse_2", "targetname" );
	spawner_1 thread corpse_setup( spawner_1, "dying_corpse_pose", "clean_up_downed_apache" );
	spawner_2 thread corpse_setup( spawner_2, "dying_corpse_pose", "clean_up_downed_apache" );
}

downed_apache_paired_corpse()
{
	spawner = getent ("apache_crawling_death_guy_1", "targetname");
	org = getstruct( "apache_wounded_soldier_check_org", "targetname" );
	
	dummy = spawner corpse_setup( org, "hunted_woundedhostage_idle_start" );
	guys = [];
	guys[0] = level.truck;
	guys[1] = dummy;
	dummy.animname = "generic";
	
	guys[0] trigger_wait_multiple_once_from_targetname( "trig_apache_wounded_soldier_check" );
	flag_set( "vo_check_wounded_soldier" );
	
	guys[1] thread self_delete_on_flag_set( "clean_up_downed_apache" );
	org anim_reach_solo( guys[0], "hunted_woundedhostage_check" ); 
	org anim_single( guys, "hunted_woundedhostage_check" );
	org anim_single( guys, "hunted_woundedhostage_check_end" );
	guys[0] enable_ai_color();
	if( !flag( "player_passed_apache" ) )
		activate_trigger_with_targetname( "trig_path_after_downed_apache" );
}

/***********************
BRIDGE BATTLE
***********************/

bridge_tank_battle()
{
	level.tanks_killed=0;
	flag_wait("start_bridge_battle");
	thread MonitorGarageGlassBreak();
	
	array_thread(getEntArray("bridge_usa_troops","script_noteworthy"),::spawn_ai, true); 
	
	thread bridge_fighters();
	thread monitor_enemy_fall_back();
	
	level.rus_tanks = [];
	level.rus_tanks[0] = getent("rus_tank1", "script_noteworthy");
	
	//spawing rus tanks
	level.rus_tanks[0] = level.rus_tanks[0] thread spawn_vehicle();
	level.rus_tanks[0].firing_at_tank = false;
	aud_send_msg("rus_bridge_tanks", level.rus_tanks[0]);
	level.rus_tanks[0] maps\berlin_a10::a10_add_target();
  	level.rus_tanks[0] thread maps\berlin_a10::a10_remove_target_ondeath();
	//level.rus_tanks[0].fire_at_player_vol = getentarray("tank1_fire_at_player_volume","script_noteworthy");
	
	//setup turrets to fire at dudes
	targets = getstructarray( "muzzle_flash_loc", "targetname" );
	array_thread( level.rus_tanks, ::tank_turret_think, targets );
	
	tank_dudes = getentarray( "turret_gunners", "script_noteworthy" );
	array_thread( tank_dudes, ::monitor_bridge_fighter );
	
	
	//player is has eyes on the bridge battle area.
	flag_wait("player_at_bridge_battle");
	
	//this will simulate a friendly sniper targeting bad guys in the given volume (in the players FOV) until the end notify is sent
	//thread maps\berlin_util::FriendlySniperFire("friendly_sniper_fire_volume", "rus_all_tanks_dead");
	//"script_struct" targetname and end on notify
	thread AmbientMuzzleFlash("muzzle_flash_loc", "rus_all_tanks_dead");
	thread AmbientMuzzleFlash("muzzle_flash_loc", "rus_all_tanks_dead");
	
	//rus tank 1 fire ambient after killing usa tank 1
	thread bridge_kill_player( level.rus_tanks[0] );
}

bridge_kill_player( tank )
{
	volume = getent( "tank1_fire_at_player_volume", "script_noteworthy" );
	kill_player_with_tank( tank, volume, "trig_bridge_kill_player", undefined, "rus_all_tanks_dead" );
}

tank_turret_think( target_array )
{
	self endon( "death" );
	turret = self.mgturret[1];
	
	//waittill there's a turret owner
	while( !isDefined( turret GetTurretOwner() ) )
	{
		wait( .05 );
	}
	
	turret.aiowner endon( "death" );
	target = spawn( "script_origin", target_array[0].origin );
	
	//shoot down bridgeway
	turret SetMode( "manual" );
	turret set_accuracy( .01 );
	while( !flag( "bridge_fighters_start_fighting" ) )
	{
		target_array = array_randomize( target_array );
		target.origin = target_array[0].origin;
		turret SetTargetEntity( target, (0,0,0) );
		wait( 2.5 );
		turret ClearTargetEntity();
		wait( .05 );
	}
	

	//wait for awareness after flank
	wait( randomfloatrange( .3, 1 ) );
	
	
	//closer tank shoots at allies but not player
	turret ClearTargetEntity();
	thread flag_set_delayed( "tank_turret_target_player", 12 );
	allies = getaiarray( "allies" );
	while( true )
	{
		if( flag( "tank_turret_target_player" ) )
		{
			break;
		}
		allies = array_randomize( allies );
		if( isDefined( allies[0] ) && isAlive( allies[0] ) )
		{
			turret SetTargetEntity( allies[0], (0,0,0) );
			wait( 2.5 );
			turret ClearTargetEntity();
		}
		wait( .05 );
	}
	
	
	//normal ai shooting player and allies
	turret SetMode( "sentry" );
}

MonitorGarageGlassBreak()
{
	trigger = GetEnt( "parking_garage_break_glass", "targetname" );
	assert(isdefined(trigger));
	trigger waittill("trigger");
	start_point = GetStruct(trigger.target, "targetname");
	end_point = GetStruct(start_point.target, "targetname");
	MagicBullet( "rpg_straight", start_point.origin, end_point.origin );
}

bridge_ignore_friendlies()
{
	smart_createthreatbiasgroup( "friendlies" );
	level.heroes array_setthreatbiasgroup( "friendlies" );
	
	smart_createthreatbiasgroup( "player" );
	level.player SetThreatBiasGroup("player");
	
	SetIgnoreMeGroup("friendlies","bridge_sleeper");
	SetIgnoreMeGroup("player","bridge_sleeper");
}

monitor_bridge_fighter()
{
	self waittill("death");
	level.bridge_fighter_dead++;
	flag_set( "bridge_fighters_start_fighting" );
}

monitor_bridge_fighter_shooting()
{
	self endon("death");
	self endon("stop_random_shooting");

	self waittill("goal");
	
	while(1)
	{
		self shoot();
		wait(RandomFloatRange(.5, 1.5));
		if(self.lastweapon == "rpg")
			wait(RandomFloatRange(5.5, 8.5));
	}

}

bridge_fighters_wake_up(fighters)
{
	baddies_sorted = SortByDistance(fighters, level.player.origin);
	count = 0;
	for (i=0; i<=baddies_sorted.size; i++)
	{
		if ( isAlive(baddies_sorted[i]) )
		{
			baddies_sorted[i] bridge_fighter_wake_up();
			count++;
		}
		
		if (count > 2)
		{
			wait( 3.0 );
			count = 0;
		}
	}
}

bridge_fighter_wake_up()
{
	self endon( "death" );
	
	wait( randomfloatrange( .3, 1 ) );
	
	self SetThreatBiasGroup("axis");
	self notify("stop_random_shooting");
	self.ignoreall = false;
	self.goalradius = 512;
}

bridge_fighter_wake_up_first_guy()
{
	self endon( "death" );
	
	wait( randomfloatrange( .3, 1 ) );
	node = getnode( "bridge_spawn1_first_guy_goal", "targetname" );
	self setGoalNode( node );
	self SetThreatBiasGroup("axis");
	self notify("stop_random_shooting");
	self.ignoreall = false;
	self.goalradius = 512;
}

bridge_sleeper_set_bias_group()
{
	self SetThreatBiasGroup("bridge_sleeper");
	self.ignoreall = true;
	self.goalradius = 10;
}

bridge_fighters()
{
	CreateThreatBiasGroup( "bridge_sleeper" );
	level.bridge_fighter_dead = 0;
	//spawn the intial set of guys
	bridge_spawners = getEntArray( "bridge_spawn1","targetname" );
	array_thread( bridge_spawners, ::add_spawn_function, ::monitor_bridge_fighter );
	array_thread( bridge_spawners, ::add_spawn_function, ::monitor_bridge_fighter_shooting );
	array_thread( bridge_spawners, ::add_spawn_function, ::bridge_sleeper_set_bias_group );
	bridge_enemies = array_spawn( bridge_spawners, true );

	//have the bridge_1 dudes ignore the player and friendlies until one is dead
	thread bridge_ignore_friendlies();
	
	//pick an enemy closest to the player to wake up right away
	flag_wait( "player_at_bridge_battle" );
	bridge_enemies = array_removeundefined(bridge_enemies);
	if(bridge_enemies.size > 0)
	{
		baddies_sorted = SortByDistance( bridge_enemies, level.player.origin );
		baddies_sorted[0] thread bridge_fighter_wake_up_first_guy();
		
		//wait until the player has shot a guy to wake up the rest, by closest to the player
		flag_wait("bridge_fighters_start_fighting"); //this comes from killing a dude
		thread bridge_fighters_wake_up( bridge_enemies );
	}

	//Spawning filler guys if the player is sitting back
	while(level.bridge_fighter_dead < 6) //wait till X dudes dead
	{
		wait(.1);
	}
	
	spawners = getentarray( "bridge_spawn_flood2", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::monitor_bridge_fighter );
	if(spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
	
	wait(1);
	
	//spawning the second spawn group if the player hasn't hit the trigger yet.
	flag_wait("bridge_one_tank_destroyed");

	//starting the last spawn group if the player hasn't triggered it yet.
	while(level.bridge_fighter_dead < 8) //wait till X dudes dead
	{
		wait(.1);
	}
	
	spawners = getentarray( "bridge_spawn_flood", "targetname" );
	if(spawners.size > 0)
	{
		maps\_spawner::flood_spawner_scripted( spawners );
	}
}

monitor_bridge_battle_color_advance()
{
	trigger_off( "bridge_battle_color_advance_1", "targetname" );
	trigger_off( "bridge_battle_color_advance_2", "targetname" );
	flag_wait("rus_all_tanks_dead");
	trigger_on( "bridge_battle_color_advance_1", "targetname" );
	trigger_on( "bridge_battle_color_advance_2", "targetname" );
}

monitor_enemy_fall_back()
{
	thread monitor_fallback_timer();
	//flag_wait_either( "enemies_retreat","rus_all_tanks_dead_delay" );
	flag_wait( "enemies_retreat" );
	maps\_spawner::killspawner(19);  //stopping the flood spawners "bridge_spawn_flood"
	maps\_spawner::killspawner(18);  //stopping the flood spawners "bridge_spawn_flood"
	
	baddies = getaiarray( "axis" );
	
	retreat_node = getstruct( "bridge_fall_back_pos", "targetname" );
	baddies_sorted = SortByDistance( baddies, retreat_node.origin );
	count = 0;
	for (i=baddies_sorted.size-1; i>=0; i--)
	{
		if ( isAlive(baddies_sorted[i]) )
		{
			baddies_sorted[i] set_goal_pos( retreat_node.origin );
			baddies_sorted[i] set_goal_radius( retreat_node.radius );
			baddies_sorted[i] notify( "retreat" );
			count++;
		}
		if (count > 3)
		{
			wait( 6.0 );
			count = 0;
		}
	}
}

monitor_fallback_timer()
{
	flag_wait ("rus_all_tanks_dead");
	delaythread( 30, ::flag_set, "rus_all_tanks_dead_delay" );
}

monitor_tank_fire_at_player()
{
	self endon("death");
	self endon("stop_firing");
	self.firing_at_player = false;
	
	if(isdefined(self.fire_at_player_vol))
	{
		while(isdefined(self) && isalive(self))
		{
			if(check_volumes(self.fire_at_player_vol) && self.firing_at_player == false)
			{
				self notify("stop_random_tank_fire");
				self fireweapon();
				level.player kill();
				self.firing_at_player = true;
				wait(5);  //waiting so the target change doesn't get stuck trying to switch back to the bridge troops
			}
			else if(self.firing_at_player == true)
			{
				self notify("stop_tank_fire_at_player");
				self thread tank_fire_at_enemies("bridge_usa_troops");
				self.firing_at_player = false;
				wait(5);
			}
			wait(1);
		}
	}
}

//checking all volumes to see if the player is in any of them
check_volumes(volume_array)
{
	foreach(volume in volume_array)
	{
		if(level.player isTouching(volume))
			return true;
		wait(0.05);
	}
	return false;
}

tank_shoot_at_player()
{
	self endon( "death" );
	self endon( "stop_tank_fire_at_player" );
	target = level.player;
	while( isdefined( self ) && isalive( self ) )
	{		
		if( isdefined( target )&& target.health > 0 )
		{
			self setturrettargetent( target, (randomintrange(-64, 64), randomintrange(-64, 64), randomintrange(-16, 100) ) );
			if( SightTracePassed( self.origin + (0,0,100), target.origin + (0,0,40), false, self ) )
			{	
				self fireweapon();
				wait( randomintrange( 2,7 ) );
			}
			else
			{
				wait( 1 );
			}	
		}
		else
		{	
			wait( 1 );
		}
	}
}

destroy_tanks_objective(rus_tanks)
{
	//add pickup rpg objective
	rpg = getent( "bridge_rpg", "targetname" );
	level.kill_tanks_obj = level.objective_count; 
	Objective_Add( level.kill_tanks_obj, "current", &"BERLIN_DESTROY_TANKS_OBJ", rpg.origin );
	Objective_Position( level.kill_tanks_obj, rpg.origin );
	level.objective_count++;
	
	flag_wait( "player_sees_bridge_battle" );
	
	//handle glowy RPG
	check_for_rpg();
	if( !flag( "stop_rpg_glow" ) )
	{
		rpg add_weapon_glow( "stop_rpg_glow", true ); //wait till the player has picked up the rpg
	}
	
	flag_set( "bridge_rpg_picked_up" );
	aud_send_msg("bridge_rpg_picked_up");
	
	//monitor tanks for objective.
	if( isdefined( rus_tanks[0] ) && isalive( rus_tanks[0] ) )
	{
		Objective_Position( level.kill_tanks_obj, rus_tanks[0].origin + (0,0,0) );
		rus_tanks[0] thread monitor_bridge_tank();
		aud_send_msg("destroy_tank_with_rpg_objective", rus_tanks[0]);
	}
	else
	{
		level.tanks_killed++;
	}
	
	Objective_SetPointerTextOverride(level.kill_tanks_obj, &"BERLIN_DESTROY");
	level.objective_count++;
	
	while( 1 )
	{
		if( level.tanks_killed == 1 )
		{
				flag_set("rus_all_tanks_dead");
				flag_set( "stop_rpg_glow" );
				return;
		}
		wait( .5 );
	}
}

rpg_weapon_switch_hint()
{
	weapon = level.player GetCurrentPrimaryWeapon();
	
	if( weapon == "rpg_player" || weapon == "rpg" )
	{
		return true;
	}
	
	return false;
}

check_for_rpg()
{
	weapons = level.player GetWeaponsListPrimaries();
	primary = level.player GetCurrentPrimaryWeapon();
	
	foreach( weapon in weapons )
	{
		if( weapon == "rpg_player" || weapon == "rpg" )
		{
			weapon_ammo = level.player GetAmmoCount( weapon );
			
			if( weapon == primary )
			{
				if( weapon_ammo > 0 )
				{
					flag_set( "stop_rpg_glow" );
					return;
				}
			}
			
			//switch weapons hint
			else
			{
				delaythread( 6, ::display_hint, "rpg_secondary" );
				
				if( weapon_ammo > 0 )
				{
					flag_set( "stop_rpg_glow" );
					return;
				}
			}
		}
	}
	
	thread monitor_rpg_pickup();
}

monitor_rpg_pickup()
{
	level endon( "rus_all_tanks_dead" );
	
	while( 1 )
	{
		weapons = level.player GetWeaponsListPrimaries();
		primary = level.player GetCurrentPrimaryWeapon();
		
		foreach( weapon in weapons )
		{
			if( weapon == "rpg_player" || weapon == "rpg" )
			{
				weapon_ammo = level.player GetAmmoCount( weapon );
				
				if( weapon == primary )
				{
					if( weapon_ammo > 0 )
					{
						flag_set( "stop_rpg_glow" );
						return;
					}
				}
			}
		}
		wait( .1 );
	}
}

path_heroes_post_bridge_tank_destroyed()
{
	trigger_off( "bridge_color_trig_01", "targetname" );
	
	flag_wait("rus_all_tanks_dead");
	wait( 7 );
	
	thread activate_trigger_with_targetname( "path_allies_post_destroy_bridge_tank" );
	trigger_on( "bridge_color_trig_01", "targetname" );
	
	flag_wait( "bridge_combat_dudes_dead" );
	activate_trigger_with_targetname( "trig_path_heroes_bridge_02" );
	special_trig = getent( "bridge_color_trig_02", "targetname" );
	if( isDefined( special_trig ) )
	{
		trigger_off( "bridge_color_trig_02", "targetname" );
	}
}

path_heroes_post_tanks_over_barrier_1()
{
	flag_wait( "usa_tanks_start_parkway" );
	wait( 5 );
	
	if( !flag( "cancel_scripted_color_trigs" ) )//player is too far forward
	{
		thread activate_trigger_with_targetname( "path_heroes_post_tanks_over_barrier_1" );
	}
	
	flag_wait( "parkway_tank_right_pause_01" );
	
	if( !flag( "cancel_scripted_color_trigs" ) )//player is too far forward
	{
		thread activate_trigger_with_targetname( "trig_path_heroes_parkway_02" );
	}
	
	flag_wait( "parkway_tank_left_pause_01" );
	
	if( !flag( "cancel_scripted_color_trigs" ) ) //player is too far forward
	{
		thread activate_trigger_with_targetname( "trig_path_heroes_parkway_01" );
	}
}

monitor_bridge_tank()
{
	self waittill( "death" );
	
	objective_position(level.kill_tanks_obj,(0,0,0));
		
	level.tanks_killed++;
	flag_set("bridge_one_tank_destroyed");//start rus_tank3 to move
}

monitor_bridge_battle_fail_condition(tank)
{
	level endon("rus_all_tanks_dead");
	if(isDefined(level.rus_tanks))
	{//setting up for parkway start point which doesn't spawn the russian tanks.
		tank waittill("death");
		Objective_State(level.take_bridge_obj_num,"failed");
		SetDvar( "ui_deadquote", &"BERLIN_BRIDGE_BATTLE_FAIL_QUOTE" );
		missionFailedWrapper();
	}
}

monitor_rus_tank_kill_me(flag_to_wait_for, add_time)
{
	//Sets up russian tanks to kill this tank when it gets to a vehicle node
	self endon("death");
	self gopath();
	
	flag_wait(flag_to_wait_for);
	if( isDefined( add_time ) )
	{
		wait( add_time );
	}
	
	while(1)
	{
		if(isDefined(level.rus_tanks))
		{
			foreach(opp_tank in level.rus_tanks)
			{
				if(isAlive(opp_tank)&&(opp_tank.firing_at_tank == false))
				{
					opp_tank tank_kill_me(self);	
					break;
				}	
			}
		}
		wait(.25);
	}
}

tank_kill_me(tank_target)
{
	self endon("death");
	self notify("stop_firing");
	self.firing_at_tank = true;
	self setturrettargetent(tank_target);
	wait(2);
	self fireweapon();
	tank_target godoff();
	self.firing_at_tank = false;
	tank_target notify("death");
}

monitor_death( flag_to_set, endon_msg )
{
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	self waittill( "death" );
	
	if( isDefined( flag_to_set ) )
	{
		flag_set( flag_to_set );
	}
}

monitor_bridge_battle_ambient()
{
	thread monitor_bridge_battle_apache_shotdown();
	thread monitor_bridge_battle_apache_ambient();
}

bridge_activate_a10_hint()
{
	level waittill( "bridge_activate_a10_hint" );
	if( !flag( "rus_all_tanks_dead" ) )
	{
		maps\berlin_a10::turn_on_a10_hud_hint();
	}
}

monitor_bridge_battle_apache_shotdown()
{
	flag_wait("start_ambient_apache_shotdown");
	apache_shotdown = getent("bridge_battle_apache_shotdown", "targetname");
	apache_shotdown = apache_shotdown spawn_vehicle_and_gopath();
	apache_shotdown.preferred_crash_style = 0; //0 = crash_rotate, 1 = crash_zigzag, 2 = crash_directed, 3 = in_air_explosion
	aud_send_msg("bridge_battle_apache_shotdown_spawn", apache_shotdown);
	crashloc = getstruct("bridge_battle_apache_shotdown_crash_location", "script_noteworthy");
	apache_shotdown.perferred_crash_location = crashloc;
	flag_wait("bridge_battle_apache_shotdown_fire1");
	apache_shotdown_target = getent("bridge_battle_apache_shotdown_target2", "targetname");
	apache_shotdown thread heli_fire(apache_shotdown_target, 2, 2);
	
	flag_wait("bridge_battle_apache_shotdown_start");
	
	jav_launcher = getstruct("bridge_battle_apache_shotdown_loc", "targetname");
	javelin = apache_shotdown thread fake_javelin(jav_launcher, "direct");
	aud_send_msg("bridge_battle_apache_shotdown_jav_launch", javelin);
}

monitor_bridge_battle_apache_ambient()
{
	flag_wait("start_ambient_apaches");
	apaches = getentArray("bridge_battle_apache", "targetname");
	array_thread(apaches, ::spawn_vehicle_and_gopath);
}


/***********************
PARKWAY SCRIPT
***********************/

monitor_parkway_drones()
{
	array_thread(getEntArray("parkway_friendly_drone","script_noteworthy"), ::basic_ai_respawn);
	
	flag_wait("start_parkway_drones2");

	ai_delete_when_out_of_sight(getEntArray("parkway_friendly_drone","script_noteworthy"), 512);
	array_thread(getEntArray("parkway_friendly_drone_2","script_noteworthy"), ::basic_ai_respawn);
}

basic_ai_respawn()
{
	level notify("stop_basic_drone_spawner");//stop other spawn loops so this function only goes once at a time
	level endon("stop_basic_drone_spawner");
	
	while(1)
	{
		if( self.count < 1 )
		{
			return;
		}
		
		dude = self spawn_ai();
		
		if( !spawn_failed( self ) )
		{
			dude waittill( "death" );
		}
		else
		{
			wait( 8 );
		}
		wait(.05);
	}
}

basic_drone_respawn()
{
	level notify("stop_basic_drone_spawner");//stop other spawn loops so this function only goes once at a time
	level endon("stop_basic_drone_spawner");
	my_drone = undefined;
	
	while(1)
	{
		if(!isdefined(self.my_drone) || !isalive(self.my_drone))
		{
			self.count++;
			self.my_drone = self spawn_ai();
			self.my_drone.spawner = self; //point the drone at its spawner in case we convert it to a real Actor
		}
		
		//all spawners wait a standard amount of time so the respawns running up dont look like a stream of ants
		//this will cause clumping which looks better
		wait(8.0);	
	}
}

monitor_parkway_player_path()
{
	//setup alpha team threat group
	smart_createthreatbiasgroup( "friendlies" );
	level.heroes array_setthreatbiasgroup( "friendlies" );
	
	//change ignores based on where the player is.
	trigger_right_array = getentArray("parkway_spawners_right", "targetname");
	trigger_left_array = getentArray("parkway_spawners_left", "targetname");
	
	array_thread(trigger_right_array, ::parkway_threat, "right");
	array_thread(trigger_left_array, ::parkway_threat, "left");
}

parkway_threat(direction)
{
	self waittill( "trigger" );
	
	//give the guys a second to spawn
	wait( 1 );
	
	if( direction == "left" )
	{
		//SetIgnoreMeGroup("friendlies","axis");
	}
	
	if( isdefined(self.script_noteworthy ) )
	{
		//disable the other trigger in this choice set
		possible_choices = GetEntArray( self.script_noteworthy, "script_noteworthy" );
		
		foreach( thing in possible_choices )
		{
			thing delete();
		}
	}
}

parkway_advance_tanks()
{
	level endon("missionfailed");
	
	level.usa_tanks = [];
	
	flag_wait("usa_tanks_start_bridge_advance");
	
	ally_deadtank_spawner = getent("usa_tank2", "script_noteworthy");
	ally_tank_spawner_1 = getent("usa_tank3", "script_noteworthy");
	ally_tank_spawner_2 = getent("usa_tank4", "script_noteworthy");
	
	//spawing ally dead tank
	ally_deadtank = ally_deadtank_spawner spawn_vehicle_and_gopath();
	aud_send_msg("ally_deadtank", ally_deadtank );
	ally_deadtank thread monitor_rus_tank_kill_me("usa_deadtank_in_pos");
	ally_deadtank thread monitor_death( "bridge_deadtank_dead", "rus_all_tanks_dead" );
	ally_deadtank thread tank_fire_at_enemies("bridge_tank_target");
	ally_deadtank thread maps\berlin_a10::a10_add_target();
	ally_deadtank thread maps\berlin_a10::a10_remove_target_ondeath();
	ally_deadtank godon();
	ally_deadtank setvehiclelookattext( "Blutertragen", &"" );
	level.usa_tanks[0] = ally_deadtank;
	
	ally_tanks = [];
	
	//spawning ally tank 1
	volume_1 = getent( "parkway_right_volume", "targetname" );
	ally_tanks[0] = ally_tank_spawner_1 spawn_vehicle_and_gopath();
	aud_send_msg("ally_tank_00", ally_tanks[0]);
	thread monitor_bridge_battle_fail_condition( ally_tanks[0] );//level fails if tank dies on bridge
	ally_tanks[0] thread monitor_rus_tank_kill_me("usa_tanks_half_way_on_bridge", 5 );
	ally_tanks[0] setvehiclelookattext( "Vorschlaghammer", &"" );
	ally_tanks[0] thread ally_tank_1_think( volume_1 );
	ally_tanks[0] thread ally_tank_1_go_over_barricade();
	ally_tanks[0] thread survive_friendly_rocket();
	level.usa_tanks[1] = ally_tanks[0];
	aud_send_msg("ally_tank_01", level.usa_tanks[1]);
	ally_tanks[0].treadfx_freq_scale = 2;
	
	//spawning ally tank 2
	volume_2 = getent( "parkway_left_volume", "targetname" );
	ally_tanks[1] = ally_tank_spawner_2 spawn_vehicle_and_gopath();
	ally_tanks[1] setvehiclelookattext( "Zerstörer", &"" );
	ally_tanks[1] thread ally_tank_2_think();
	ally_tanks[1] thread ally_tank_2_go_over_barricade();
	ally_tanks[1] thread survive_friendly_rocket();
	
	level.usa_tanks[2] = ally_tanks[1];
	aud_send_msg("ally_tank_02", level.usa_tanks[2]);
	ally_tanks[1].treadfx_freq_scale = 2;
	
	array_thread( ally_tanks, ::tank_stop_shooting, "lone_star_going_down" );
	array_thread( ally_tanks, ::setup_ally_tank );

	//Parkway	
	flag_wait("rus_all_tanks_dead");
	
	array_call( ally_tanks, ::vehicle_setspeed, 10, 5, 5 );
	
	flag_wait("usa_tank2_in_pos");
	
	array_thread( ally_tanks, ::build_rumble_unique, "tank_rumble", .05, 1.5, 300, .3, .3 );
	array_thread( ally_tanks, ::send_notify, "stop_random_tank_fire" );
	array_call( ally_tanks, ::clearturrettarget );
	array_thread( ally_tanks, ::parkway_tank_shotgun, "berlin_parkway_busy_targets" );
	
	//kill guys behind our tanks
	//thread kill_ai_behind( "axis", ally_tanks );
}

ally_tank_1_go_over_barricade()
{
	//wait for tank in position
	flag_wait( "usa_tank1_in_pos" );
	
	//wait for player to hit trigger
	flag_wait( "usa_tanks_start_parkway" );
	
	//do audio and vfx
	aud_send_msg( "usa_tank1_start_parkway", self );
	thread maps\berlin_fx::tank_dirt_vfx(self);
}

survive_friendly_rocket()
{
	self endon("death");
	self godon();
	
	while(1)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if( attacker == level.player && type == "MOD_PROJECTILE")
			break;
	}
	
	//hint( &"BERLIN_FRIENDLY_TANK_FIRE_WARNING", 3 );
	display_hint( "damage_leapard_hint" );
	//warn about shooting friendly tanks
	
	while(1)
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if( attacker == level.player && type == "MOD_PROJECTILE")
			break;
	}
	
	godoff();
	self kill();
}

ally_tank_2_go_over_barricade()
{
	//wait for tank in position
	flag_wait( "usa_tank2_in_pos" );
	
	//wait for player to hit trigger
	flag_wait( "usa_tanks_start_parkway" );
	
	//do audio and vfx
	aud_send_msg( "usa_tank2_start_parkway", self );
	thread maps\berlin_fx::tank_dirt_vfx2(self);
}

tank_stop_shooting( flag )
{
	flag_wait( flag );
	self notify("stop_random_tank_fire");
}

setup_ally_tank()
{
	self endon( "death" );
	
	self thread maps\berlin_a10::a10_add_target();
	self thread maps\berlin_a10::a10_remove_target_ondeath();	
	self thread fail_mission_on_death("player_interacting_with_wounded_lonestar");
	self vehicle_setspeed(5, 5, 5);
	self godon();
	
	if( !flag( "rus_all_tanks_dead" ) )
		wait(1);
	
	self thread tank_fire_at_enemies("bridge_tank_target");
	self thread turret_target_on_flag("parkway_target_point", "rus_all_tanks_dead");
}

ally_tank_1_think( volume )
{
	self endon( "death" );
	level endon( "lone_star_going_down" );
	
	flag_wait( "usa_tanks_start_parkway" );
	wait( randomfloatrange( 1, 2 ) );

	//self thread tank_fire_at_enemies_in_volume( volume );
	
}

//volume is optional
parkway_tank_shotgun( tname_busy_targets )
{
	self endon("death");
	self notify("stop_random_tank_fire");
	self endon("stop_random_tank_fire");
	
	if(!isdefined(level.berlin_tank_fcs))
	{
		level.berlin_tank_fcs = true;
		level.berlin_tank_fcs_cooldown = 5 * 1000;
		level.berlin_tank_fcs_next_time = GetTime();
	}
	
	show_debug_targeting = false;
	//next step is to make the height difference zero in all these checks
	
	target_cone_cos = cos(45);
	fire_cone_cos = cos(10);
	targeting_dist = 2048;
	targeting_dist_sq = targeting_dist * targeting_dist;
	self mgOn();
	
	target_infantry_cooldown = 2;
	target_infantry_last_time = 0;
	
	busy_target_arr = [];
	if(isdefined(tname_busy_targets))
	{
		busy_target_arr = GetEntArray( tname_busy_targets, "targetname");
	}
	
	berlin_tank_fcs();
	
	while(1)
	{
		targ = undefined;
		while(!isdefined(targ))
		{
			wait(0.05);
			if(GetTime() > target_infantry_last_time + 1000 * target_infantry_cooldown )
			{
				target_infantry_last_time = GetTime();
						
				axis = getaiarray("axis");
				
				//ignore certain scripted dudes to keep it difficult
				foreach( baddy in axis )
				{
					if( isDefined( baddy.script_noteworthy) && baddy.script_noteworthy == "tank_ignoreme" )
						axis = array_remove( axis, baddy );
				}
				
				barrel_org = self gettagorigin( "tag_flash" );
				axis = SortByDistance( axis, barrel_org );
				
				//walk from nearest
				forward = AnglesToForward(self.angles);
				this_frame = 0;
				foreach( g in axis )
				{
					if(!isdefined(g) || !isalive(g) )
					{
						continue;
					}
					if( distancesquared(barrel_org, g.origin) > targeting_dist_sq )
						break;//sorted by distance so dont eval anymore this loop
					vec = get_targeting_vector(g, barrel_org); //offset is wonky from barrel in one case and origin in another
					dot = vectordot(forward, vec);
					
					if(dot > target_cone_cos)
					{ 
						/# 
						if(show_debug_targeting)
							thread DLine( barrel_org, g.origin, 1, (0,1,0) ); 
						#/
						targ = g;
						break;
					}
					/# 
					if(show_debug_targeting)
						thread DLine( barrel_org, g.origin, 1, (1,0,0) ); 
					#/
					this_frame++;
					if(this_frame == 10 || this_frame == 20)
						wait(0.05);
				}
			}
			else //cant target infantry look cool
			{
				assert(busy_target_arr.size > 0);
				if(busy_target_arr.size > 0)
				{
					targ = busy_target_arr[randomint(busy_target_arr.size)];
					//this needs to run the same target in cone vetting script for nominating targets
				}
			}
		}
		
		self SetTurretTargetEnt(targ, targ maps\berlin_util::stanceOffsetHelper() );
		//we are not pointing at it enough to fire
		barrel_dot = 0;
		time_tracking = 0;
		tracking_limit = 3;
		while(isdefined(targ) && barrel_dot < fire_cone_cos )
		{
			/#
			if(show_debug_targeting)
				Print3d(self.origin - (0,0,32), "TARGET FOUND", (1,1,1));
			#/
			barrel_org = self gettagorigin( "tag_flash" );
			barrel_angles = self gettagangles( "tag_turret" );
			barrel_forward = AnglesToForward(barrel_angles);
			vec = get_targeting_vector(targ, barrel_org); 
			barrel_dot = vectordot(barrel_forward, vec);
			
			forward = AnglesToForward(self.angles);
			dot = vectordot(forward, vec);
			
			if(dot < target_cone_cos ) //out of firing range 
			{
				/#
				if(show_debug_targeting)
					Print3d(self.origin, "OUTSIDE FORWARD CONE", (1,1,1),1,3*20);
				#/
				targ = undefined;
				break;
			}
			else if(barrel_dot > fire_cone_cos ) //as soon as we're valid break out
			{
				
				/# 
				if(show_debug_targeting)
				{
					Print3d(self.origin, "BARREL READY", (1,1,1),1,3*20);
					thread DLine( barrel_org, barrel_org + forward * 256, .2, (0,1,1) ); 
					thread DLine( barrel_org, barrel_org + barrel_forward * 256, .2, (1,1,0) ); 
				}
				#/				
				break;	
			}
			else
			{
				/# 
				if(show_debug_targeting)				
				{
					debug_str = "BARREL_MOVING : " + acos(barrel_dot) + " vs " + acos(fire_cone_cos);
					Print3d(self.origin, debug_str, (1,1,1),1,3);	
				}
				#/
			}
			wait_time = .15;
			time_tracking += wait_time;
			wait( wait_time ); //info gets a little old but as long as the wait is low its not that stale
			
			if(time_tracking > tracking_limit)
			{
				targ = undefined;
			}
		}
		
		self ClearTurretTarget(); //we think we're pointing at it stop moving
		
		if(isdefined(targ))
		{
			if(IsAI(targ))
			{
				wait(.6); //so we see the tank not fire
				//we want to fire a sabot round
								
				self SetVehWeapon( "leopard_2a7_sabot" );
				self FireWeapon();
					
				berlin_tank_fcs();
			}
			else //script origin
			{
				wait(.8);
				
				self SetVehWeapon( "leopard_2a7_turret" );
				self FireWeapon();
				berlin_tank_fcs();
			}
		}
		
		//tanks need pass sightCheck
	} 
}

berlin_tank_fcs()
{
	cur_time = GetTime();
	wait_time_ms = level.berlin_tank_fcs_next_time - GetTime();
	level.berlin_tank_fcs_next_time = level.berlin_tank_fcs_next_time + level.berlin_tank_fcs_cooldown;
	if(wait_time_ms > 0)
		wait (wait_time_ms / 1000);
}

get_targeting_vector( guy, barrel_org )
{
	return vectornormalize(guy.origin + guy maps\berlin_util::stanceOffsetHelper() - barrel_org);	
}

ally_tank_2_think()
{
	self endon( "death" );
	
	self parkway_tank_destroy_cover_scene();
	self thread parkway_tank_shotgun( "berlin_parkway_busy_targets");
}

monitor_skip_destroy_cover_scene(obj)
{
	obj endon("start_parkway_cover_scene");
	obj endon("parkway_cover_scene_missed");
	self waittill("trigger");
	obj notify("parkway_cover_scene_missed");
}

parkway_tank_destroy_cover_scene()
{
	self endon("death");
	
	level endon("parkway_cover_scene_missed");
	trig_arr = getEntArray("parkway_color_triggers1", "script_noteworthy");	
	array_thread( trig_arr, ::monitor_skip_destroy_cover_scene, self );
	
	
	flag_wait("usa_tank2_in_pos");
	wait( 1 );
	
	self notify("stop_random_tank_fire");
	shooter = self;
	assert(isdefined(shooter));
	tank_shot_target = GetEnt( "tank_shot_target", "targetname" );
	assert(isdefined(tank_shot_target));
	shooter setTurretTargetEnt(tank_shot_target);

	flag_wait("parkway_tank_shot");
	
	self notify("start_parkway_cover_scene");
	wait(1);
	shooter fireweapon();
	wait(0.25);
	playfx( getfx("tank_destroy_cover"), tank_shot_target.origin);
	
	entArr = GetEntArray("tank_shot_destructible", "targetname");
	foreach(e in entArr)
	{
		if(isdefined(e.script_notworthy))
			e SetModel(e.script_notworthy);
		else
			e Delete();
	}
	
	collision_pieces = getentarray( "parkway_scripted_tank_fire_col", "targetname" );
	if( isDefined( collision_pieces ) )
	{
		foreach( collision_piece in collision_pieces )
		{
			collision_piece delete();
		}
	}
	
	PhysicsExplosionSphere(tank_shot_target.origin, 256, 100, 4);
	
	//dudes = get_alive_from_noteworthy( "parkway_scripted_tank_target" );
	//array_thread( dudes, ::guy_grenade_death );
	
	shooter clearturrettarget();
}

/* NOT USED
kill_ai_behind( team, kill_vehicles )
{
	level endon("lone_star_going_down");
	if(!isdefined(kill_vehicles) || !isarray(kill_vehicles) || kill_vehicles.size == 0)
		return;
		
	while(1)
	{
		bad_guys = getAIarray(team);
		
		//it's possible to kill all of the badguys making this an infinite loop.
		if(bad_guys.size ==0)
		{
				wait(.5);
		}
		
		foreach( guy in bad_guys )
		{
			//valid AI only, can go stale because of wait
			if(!isdefined(guy) || !isAI(guy) || !IsAlive(guy))
				continue;
			
			behind_count = 0;
			foreach( veh in kill_vehicles )
			{
				if(isdefined(veh) && !targetisinfront( veh, guy.origin ))
				{
					behind_count++;
				}
			}
			
			killer = kill_vehicles[randomInt(kill_vehicles.size)];
			if(behind_count == kill_vehicles.size) //behind all
			{
				guy Kill(killer.origin, killer);
			}
			else if(behind_count > 0)//behind some
			{
				guy Kill(killer.origin, killer);
			}

			//only check one guy per frame
			wait(0.05);
		}
	}
}

targetisinfront( other, target )
{
	forwardvec 	 = anglestoforward( flat_angle( other.angles ) );
	normalvec 	 = vectorNormalize( flat_origin( target ) - other.origin );
	dot 		 = vectordot( forwardvec, normalvec );

	if ( dot > 0 )
		return true;
	else
		return false;
}
*/


/*******************
BUILDING COLLAPSE
********************/

monitorWoundedLonestar()
{
	trigger_wait_targetname( "trigger_lone_star_wounded" ); //for vfx
	
	flag_set("lone_star_going_down");

	anim_target = getstruct("lone_star_grenade_hit_anim_loc","targetname");
	flag_set("lone_star_wounded");

	//trigger sethintstring( "Press and hold^3 &&1 ^7to help that guy" );	// Press and hold^3 &&1 ^7to help that guy	
	trigger_wait_targetname( "trigger_player_help_auto" );
	
	maps\_shg_common::SetUpPlayerForAnimations();
	
	flag_clear("lone_star_wounded");
	flag_set("player_interacting_with_wounded_lonestar");
	
	maps\_spawner::killspawner(28);  //stopping the flood spawners at the end of parkway
	
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "hud_showStance", "0");
	
	level.player DisableWeapons();
	thread move_building_victims_up();
	thread cleanup_parkway_tanks();

	//setup anims
	player_rig = spawn_anim_model( "player_rig", level.player.origin );
	actors[0] = level.lone_star;
	actors[1] = player_rig;
	building_static = getent("building_to_destroy", "script_noteworthy");
	//building_static radiusdamage( building_static.origin, 1024, 1000, 700);	
	building_static delete();
	building = spawn_anim_model("bahn_tower_collapse", anim_target.origin);
	
	aud_send_msg("destroyBuilding", building);
	actors = array_add(actors, building);
	actors = array_add(actors, level.building_car);

	//play anim
	anim_name = "bahn_tower";
	player_rig.animname = "player_rig";
	level.player PlayerLinkToBlend( player_rig, "tag_player", 0.5, 0.2, 0.2 );
	level.player freezeControls(true);
	level.player EnableInvulnerability();//don't allow death
	level.essex hide();
	level.truck hide();

	delaythread(.05, ::destroyBuilding);
	anim_target thread anim_single(actors, anim_name, undefined);
			
	level notify("building_collapsed");

  //wait for anim
	wait(8.5);
	
	anim_target thread anim_loop_solo(level.lone_star, "building_explosion_hit_wounded_loop", "end_lone_star_wounded_loop");
	
	level.player PlayerLinkToDelta( player_rig, "tag_player", 0.5, 15,15,15,15,true );
	
	black_overlay = get_black_overlay();
	
	//blinking
	black_overlay delayThread( 1, ::exp_fade_overlay, .6, .75 );
	black_overlay delayThread( 1.6, ::exp_fade_overlay, 0, .5 );
	
	//smk trail on giant piece flying toward camera
	building thread maps\berlin_fx::smktrail_giant_flying_debri();
	
	vision_set_fog_changes("berlin_collapse", 2.25); //Staying consistent with visionset changes to match parkway
	//iprintlnbold("Visionset: collapse");
	
	
	black_overlay delayThread( 3.7, ::exp_fade_overlay, .9, .5 );
	black_overlay delayThread( 4.3, ::exp_fade_overlay, .2, .5 );
	
	delayThread( 8.3, ::blur_overlay, 7, 1.5 );//so we match the blur during the aftermath sequence
	
	black_overlay delayThread( 11.4, ::exp_fade_overlay, 1, .4 );
	//Player teleport
	black_overlay delayThread( 12.0, ::exp_fade_overlay, 0, .5 );
	//delayThread( 9.1, ::blur_overlay, 0, 3 );
	wait(.2);
	earthquake(.2, 10, level.player.origin, 512);
	PlayRumbleOnPosition("heavy_3s",level.player.origin);

	wait(3.2);
	//starting shell shock when the building impacts the other building
	level.player shellshock("berlin_building",35);
	earthquake(.1, .5, level.player.origin, 512);
	PlayRumbleOnPosition("heavy_3s",level.player.origin);

	//wait for anim before teleport
	wait(8.4);
	
	//////////TELEPORT PLAYER///////////
	
	level.player Unlink();
	player_teleport_loc = getstruct("player_teleport","targetname");
	teleport_player(player_teleport_loc);
	
	maps\_shg_common::SetUpPlayerForGamePlay();
	level.player DisableInvulnerability();//don't allow death

	anim_target notify("end_lone_star_wounded_loop");
	level.lone_star notify("killanimscript");
	lone_star_teleport_loc = getstruct("lone_star_teleport","targetname");
	level.lone_star forceTeleport(lone_star_teleport_loc.origin, lone_star_teleport_loc.angles);
	level.lone_star change_character_model("body_hero_sandman_delta_dusty");
	level.lone_star disable_sprint();

	essex_teleport_loc = getstruct("essex_teleport","targetname");
	level.essex forceTeleport(essex_teleport_loc.origin, essex_teleport_loc.angles);
	level.essex change_character_model( "body_delta_woodland_assault_aa_dusty" );
	level.essex Show();
	
	truck_teleport_loc = getstruct("truck_teleport","targetname");
	level.truck forceTeleport(truck_teleport_loc.origin, truck_teleport_loc.angles);
	level.truck change_character_model("body_hero_truck_delta_dusty");
	level.truck Show();
	
	//////////TELEPORT COMPLETE//////////	
	
	flag_set( "player_teleport_after_collapse_complete" );
	aud_send_msg("building_collapse_teleport_complete");
}

exp_fade_overlay( target_alpha, fade_time )
{
	self notify( "exp_fade_overlay" );
	self endon( "exp_fade_overlay" );

	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i = 0; i < fade_steps; i++ )
	{
		current_angle += step_angle;

		self FadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - Cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = Sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

get_black_overlay()
{
	if ( !isdefined( level.black_overlay ) )
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	level.black_overlay.sort = -1;
	level.black_overlay.foreground = false;
	return level.black_overlay;
}

blur_overlay( target, time )
{
	SetBlur( target, time );
}

move_building_victims_up()
{
	//spawn runners
	level.building_victims = array_spawn(getEntArray("building_victim", "targetname"),true);
}

cleanup_parkway_tanks()
{
	level waittill( "building_collapsed" );
	
	if( isDefined( level.usa_tanks ) )
	{
		foreach(tank in level.usa_tanks)
		{
			if( isDefined( tank ) )
			{
				//have the tanks stop fireing so we don't get stuck trying to tell removed ents what to do.
				tank notify( "stop_random_tank_fire" );
				tank notify( "stop_targeted_firing" );
				
				if( tank == level.usa_tanks[2] )//left tank
				{
					//prevent the player from clipping with the tank during his anim if he gets ahead of it
					if( !flag( "usa_tank_left_past_end" ) )
					{
						volume = getent( "usa_tank_left_delete_volume", "targetname" );
						assert( isDefined( volume ) );
						
						//if tank doesn't stop driving it will collide with the player during his anim
						//tank notify( "newpath" );
						tank Vehicle_SetSpeed( 0, 5, 5);
						
						//player will collide with tank during his anim  if it's right behind him so delete the tank
						tank_toucher = spawn( "script_origin", tank.origin + ( 0, 0, 32 ) );
						if( tank_toucher isTouching( volume ) )
						{
							tank delaythread( .3, ::self_delete );
						}
					}
				}
				
				else //handle other 2 tanks
				{
					tank delaythread( 2.9, ::self_delete );//waittill after the player looks forward at the explosion and after the player has looked back, so we don't see it has dissappeared.
				}
			}
		}
	}
}

destroyBuilding()
{
	thread building_collapse_vfx();
	//set dof for building explosion so fg elements are blurry
	thread maps\berlin_fx::building_explosion_dof();
		
	explosion_org = getstruct("building_victim_explosion_org", "targetname");
	radiusdamage( explosion_org.origin, 500, 1000, 700);	
	//controller rumble for the initial explosion
	PlayRumbleOnPosition("heavy_3s",level.player.origin);
	
	wait(.2);
	
	slowmo_setspeed_slow(.3);
	slowmo_setlerptime_in( 0 );
	slowmo_lerp_in();
				
	wait(.3);
		
	slowmo_setlerptime_out( 0 );
	slowmo_lerp_out();
	
	//victims = getEntArray("building_victim", "targetname");
	foreach(guy in level.building_victims){
		if(isAlive(guy)){
			guy kill();
		}
	}
	//removing all the bad guys so people don't fire after the explosion.
	array_thread(getAIarray("axis"),::self_delete);
	
}

building_collapse_vfx()
{
	building = getstruct("building_to_collapse_origin", "targetname");
	
	//triggering all exploder vfx in sequence during the building fall
	thread maps\berlin_fx::building_fall_sequence_vfx();	
}

building_collapse_setup_subcompact()
{
	anim_target = getstruct("lone_star_grenade_hit_anim_loc","targetname");
	level.building_car = spawn_anim_model("car", anim_target.origin);
	anim_target anim_first_frame_solo(level.building_car, "bahn_tower");
	
}

building_collapse_car_impact(guy)
{
	PlayRumbleOnPosition("light_1s",level.player.origin);
}

low_res_shadow_fix()
{
	SetSavedDvar("sm_sunsamplesizenear", "0.07");
	wait 15.0;
	size = 0.07;
	finalsize = 0.25;
	time = 3.0;
	curtime = 0.0;
	while (curtime < time)
	{
		val = (finalsize - size)*(curtime/time) +size;
		SetSavedDvar("sm_sunsamplesizenear", ""+val);
		curtime += 0.07;
		wait 0.05;
	}
	SetSavedDvar("sm_sunsamplesizenear", "0.25");	
}


/********************
AFTERMATH
********************/

aftermath_se()
{
	level.player setViewmodel( "viewhands_delta_dirty" );
	
	maps\_shg_common::SetUpPlayerForAnimations();
	
	thread clean_up_parkway();
	
	//fix low-res shadows on viewmodel and blend back to default
	thread low_res_shadow_fix();
	
	//play get paired anim with lonestar
	player_rig_aftermath = spawn_anim_model( "player_rig_bloody", level.player.origin );
	aftermath_actors[0] = level.lone_star;
	aftermath_actors[1] = player_rig_aftermath;
	
	delayThread( 3.6, ::stop_shell_shock_wrapper );
	delayThread( 3.8, ::blur_overlay, 1, 0.5 );
	delaythread( 2.5, ::heartbeat_rumble );
	//delayThread( 5.3, ::shell_shock_wrapper_endon_flag, "berlin_building", "swivel_fades_out" );

	player_rig_aftermath.animname = "player_rig_bloody";
	player_rig_aftermath.weapon = "none"; // not sure why I need to do this..it was complaining that the wepon was undefined in the notetrack functions if this wasn't here
	player_rig_aftermath thread maps\berlin_fx::falling_dust_player_hand();
	
	level.player PlayerLinkToBlend( player_rig_aftermath, "tag_player", 0.5, 0.2, 0.2 );
	anim_target_aftermath = getstruct("aftermath_anim_org","targetname");
	anim_target_aftermath thread sandman_aftermath_anim(aftermath_actors[0], "aftermath");
	anim_target_aftermath anim_single_solo(aftermath_actors[1], "aftermath");
	
	//swinging wires and falling debris
	building_wires = spawn_anim_model("berlin_sgt_down_recovery_wires", anim_target_aftermath.origin);
	anim_target_aftermath thread anim_single_solo(building_wires, "bahn_tower_parts");
	
	SetSavedDvar( "hud_showStance", "1");
	SetSavedDvar( "compass", "1" );
	
	//clean up scene
	
	level.player lerp_player_view_to_position( level.player.origin + (0,0,60), level.player.angles - (0,40,0), .5, .1 );
	level.player Unlink();
	player_rig_aftermath delete();
	level.player EnableWeapons();
	level.player freezeControls(false);
	
	thread player_swivel_blur();
	
	maps\_shg_common::SetUpPlayerForGamePlay();
	
	flag_set( "aftermath_se_complete" );
}

sandman_aftermath_anim(sandman, anime)
{
	//level.lone_star thread dialog_prime( "head_for_building" ); - doing with RAM now
	
	flag_wait ( "sandman_start_aftermath" );
	self thread anim_single_solo(sandman, anime);
	sandman dialogue_queue("head_for_building");
	
	flag_set( "intro_lone_star_facial_anim_complete" );
}

shell_shock_wrapper_endon_flag(shock_name, flagy)
{
	duration = 50;
	level.player shellshock(shock_name,duration);
	flag_wait (flagy);
	level.player StopShellShock();
}

shell_shock_wrapper(shock_name, duration)
{
	level.player shellshock(shock_name,duration);
}

stop_shell_shock_wrapper()
{
	level.player StopShellShock();
}

aftermath_ambush()
{
	flag_set("ambush_after_building_collapse_start");
	
	level endon( "intro_sequence_complete" );
	level.player EnableInvulnerability();
	thread clean_up_building_collapse_ambient();
	
	wait( 8.1 );
	
	//1.8 sec lead in time needed here, had .45 or so. 10 - 1.35 = 8.65
	pos = getstruct( "scripted_artillery_spot", "targetname" );
	whistle_time = 1.85;
	thread incoming_artillery( pos.origin, undefined, whistle_time, "artillery_ambush_first_incoming", "artillery_ambush_first_explosion" );
	delaythread( whistle_time, ::handle_first_artillery_shot_rumble );
	
	//wait(randomFloatRange( 1, 1.5));
	wait(1.5); // force the longer wait to make sure no ambush explosions happen before the first scripted explosion.
	thread artillery_ambush();
	
	wait( 13 );
	
	if( flag( "not_intro" ) )//start hurting the player
		thread artillery_ambush_hurt_player();
		
	level.player DisableInvulnerability();
}

handle_first_artillery_shot_rumble()
{
	heartbeat_rumble_off();
	level.player PlayRumbleOnEntity( "heavy_3s" );
	earthquake(.5, .5, level.player.origin, 512);
}
//TODO: make this not linear, use random ents and while loop
player_swivel_blur()
{
	thread blur_overlay( 3, .5 );
	wait (.5);
	thread blur_overlay( 1.5, .1 );
	wait (.7);
	thread blur_overlay( 3, .2 );
	wait (.4);
	thread blur_overlay( 1.3, .1 );
	wait (.3);
	thread blur_overlay( 3, .3 );
	wait (.4);
	thread blur_overlay( 1, .1 );
	wait (.7);
	thread blur_overlay( 0, 3 );
}

path_heroes_post_building_collapse()
{
	level.lone_star thread path_hero_post_building_collapse( "lone_star_regroup" );
	level.essex thread path_hero_post_building_collapse( "essex_regroup" );
	level.truck thread path_hero_post_building_collapse( "truck_regroup" );

	level.lone_star set_run_anim( "patrol_jog" );
	wait( 16 );
	level.lone_star clear_run_anim();
}

path_hero_post_building_collapse( node_targetname )
{
	assert( isDefined( node_targetname ) );
	newgoal = getnode( node_targetname, "targetname" );
	self.goalradius = 8;
	self setgoalnode(newgoal);
}

clean_up_building_collapse_ambient()
{
	//Clean up all the ambient guys and vfx once the player is in the fallen building.
	flag_wait("entered_building_collapse");
	
	level notify("stop_building_collapse_ambush");
	//clean up wounded
	array_thread( getentarray( "building_collapse_ambient", "script_noteworthy" ), ::self_delete);
}

artillery_ambush()
{
	level notify( "stop_artillery_ambush" );
	level endon( "stop_artillery_ambush" );
	level endon("stop_building_collapse_ambush");
	artillery_locations = getstructarray("artillery_explosion","targetname");
	skip = randomIntRange( 3, 6 );
	skip_counter = 0;
	
	while(1)
	{
		skip_counter++;
		if ( skip_counter != skip )
		{
			pos = artillery_locations[randomIntRange(0,artillery_locations.size)].origin;
			thread incoming_artillery( pos );
		}
		else //skip the artillery fire and reset the counter
		{
			skip = randomIntRange( 3, 6 );
			skip_counter = 0;
		}
		wait(randomFloatRange(.1, 1.5));
	}
}

artillery_ambush_hurt_player()
{
	level notify( "stop_artillery_ambush" );
	level endon( "stop_artillery_ambush" );
	level endon("stop_building_collapse_ambush");
	artillery_locations = getstructarray("artillery_explosion","targetname");
	skip = randomIntRange( 3, 6 );
	skip_counter = 0;
	
	volume = getent( "ambush_hurt_player_volume", "targetname" );
	
	while(1)
	{
		skip_counter++;
		if ( skip_counter != skip )
		{
			if( level.player isTouching( volume ) ) //hurt the player
			{
				forward = AnglesToForward( level.player.angles );
				vector = forward * randomintrange( 200, 300 );
				trace = BulletTrace( ( level.player.origin + vector ) + (0,0,100), ( level.player.origin + vector ) - (0,0,1000), false );
				incoming_artillery( trace["position"] );
				//rumble
				earthquake(.1, .5, level.player.origin, 512);
				PlayRumbleOnPosition("heavy_3s",level.player.origin);
				
				level.player DoDamage( 50, trace["position"] );
			}
			else
			{
				pos = artillery_locations[randomIntRange(0,artillery_locations.size)].origin;
				thread incoming_artillery( pos );
			}
		}
		else //skip the artillery fire and reset the counter
		{
			skip = randomIntRange( 3, 6 );
			skip_counter = 0;
		}
		wait(randomFloatRange(.1, 1.5));
	}
}

// Plays an "incomming", waits a bit, then plays FX and earthquake.
incoming_artillery( pos, fxname, whistle_time, whistle_msg, impact_msg )
{
	//define stuff
	assert( isDefined( pos ) );
	if(!isDefined( fxname ) )
	{
		fxname = "artillery";
	}
	if( !isDefined( whistle_time ) )
	{
		probability = RandomInt(5);
		
		if (probability < 4)
		{
			whistle_time = randomfloatrange( 0.25, 0.65 );
		}	
		else
		{
			whistle_time = randomfloatrange( 0.65, 1.0 );
		}
	}
	if( !isDefined( whistle_msg ) )
	{
		whistle_msg = "artillery_ambush_incoming";
	}
	if( !isDefined( impact_msg ) )
	{
		impact_msg = "artillery_ambush_explosion";
	}
	
	//go and play sound
	aud_send_msg( whistle_msg, [pos, whistle_time] ); //play whistle sound
	wait( whistle_time ); // Wait for incoming sound to play a bit.
	aud_send_msg(impact_msg, pos); // Play explosion sound.
	
	// Play exploder FX.
	playfx( level._effect[ fxname ], pos );
	earthquake( .3, .75, pos, 1024 );
	playrumbleonposition( "heavy_3s", pos );
	
	return whistle_time;
}

/*NOT USED
rpg_ambush()
{
	level endon("stop_building_collapse_ambush");
	rpg_target_locations = getstructarray("artillery_explosion","targetname");
	rpg_firing_locations = getstructarray("rpg_fire_point","targetname");
	while(1)
	{
		MagicBullet( "rpg",rpg_firing_locations[randomIntRange(0,rpg_firing_locations.size)].origin,rpg_target_locations[randomIntRange(0,rpg_target_locations.size)].origin);
		wait(randomIntRange(1, 3));
	}
}
*/

clean_up_parkway()
{
	level notify("kill_color_replacements");
	level notify("stop_basic_drone_spawner");
	wait(.05);
	
	flag_wait( "player_teleport_after_collapse_complete" );
	
	delete_vol = GetEnt("parkway_clean_up_vol", "script_noteworthy");
	assert(isdefined(delete_vol));
	aiarray = getaiarray();

	aiarray_in_volume = [];
	foreach( guy in aiarray )
	{
		if ( guy isTouching( delete_vol ) )
		{
			aiarray_in_volume[ aiarray_in_volume.size ] = guy;
			if( isDefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield == 1 )
			{
				guy stop_magic_bullet_shield();
			}
		}
	}
	array_delete(aiarray_in_volume);
	array_delete(level.drones["allies"].array);
	array_delete(level.drones["axis"].array);
}

setup_corporate_ambient( reset_after_use )
{
	ai_ambient = getentarray( "building_collapse_ambient", "targetname" );
	array_thread( ai_ambient, ::ai_ambient_play_anim, reset_after_use );
}

ai_ambient_play_anim( reset_after_use )
{
	assert( isdefined( self.animation ) );	//must be defined in the spawner
	sAnim = self.animation;
	ai_dude = undefined;
	
	if( isDefined( reset_after_use ) && reset_after_use )
		flag_msg = "intro_sequence_complete";
		
	else
		flag_msg = "emerge_door_open";
	
	switch( sAnim )
	{
		case "dcburning_elevator_corpse_idle_B":
			ai_dude = self corpse_setup( self, "dcburning_elevator_corpse_idle_B" );
			break;
		case "hunted_dying_deadguy_endidle":
			ai_dude = self corpse_setup( self, "hunted_dying_deadguy_endidle" );
			break;
		case "death_sitting_pose_v2":
			ai_dude = self corpse_setup( self, "death_sitting_pose_v2" );
			break;
		case "paris_npc_dead_poses_v02":
			ai_dude = self corpse_setup( self, "paris_npc_dead_poses_v02" );
			break;
		case "paris_npc_dead_poses_v06":
			ai_dude = self corpse_setup( self, "paris_npc_dead_poses_v06" );
			break;
		case "paris_npc_dead_poses_v07":
			ai_dude = self corpse_setup( self, "paris_npc_dead_poses_v07" );
			break;
		case "dying_crawl":
			if( isDefined( self.script_noteworthy ) && self.script_noteworthy == "double" )
			{
				wait( randomfloatrange( .2, .5 ) );//so that they don't look syncronized
				ai_dude = self spawn_ai( true );
				ai_dude.allowdeath = true;
				ai_dude.ragdoll_immediate = true;
				ai_dude endon( "death" );
				ai_dude gun_remove();
				ai_dude anim_generic_gravity( ai_dude, "dying_crawl" );
				ai_dude anim_generic_gravity( ai_dude, "dying_crawl" );
				ai_dude anim_generic_gravity( ai_dude, "dying_crawl_death_v2" );
				ai_dude kill_no_react();
				break;
			}
			else
			{
				ai_dude = self spawn_ai( true );
				ai_dude gun_remove();
				ai_dude.allowdeath = true;
				ai_dude.ragdoll_immediate = true;
				ai_dude endon( "death" );
				ai_dude anim_generic_gravity( ai_dude, "dying_crawl" );
				ai_dude anim_generic_gravity( ai_dude, "dying_crawl_death_v1" );
				ai_dude kill_no_react();
				break;
			}
		case "DC_Burning_bunker_stumble":
			org = spawn( "script_origin", self.origin );
			org.angles = self.angles;
			ai_dude = self spawn_ai( true );
			ai_dude.allowDeath = true;
			ai_dude.ragdoll_immediate = true;
			ai_dude endon( "death" );
			ai_dude gun_remove();
			org anim_generic_gravity( ai_dude, "DC_Burning_bunker_stumble" );
			ai_dude thread anim_generic_loop( ai_dude, "DC_Burning_bunker_sit_idle", flag_msg );
			break;
		case "civilain_crouch_hide_idle":
			ai_dude = self spawn_ai( true );
			ai_dude.allowDeath = true;
			ai_dude.ragdoll_immediate = true;
			ai_dude endon( "death" );
			ai_dude gun_remove();
			ai_dude thread anim_generic_loop( ai_dude, "civilain_crouch_hide_idle", flag_msg );
			break;
		default:
			break;
	}
	if( isDefined( ai_dude ) )//for the guys that have been killed they'll get deleted naturally hopefully
	{
		ai_dude thread ai_anim_clean_up( flag_msg );
	}
}

ai_anim_clean_up( flag_msg )
{
	flag_wait( flag_msg );
	wait( .05 );
	if( isDefined( self ) )
	{
		self notify( "stop_loop" );
		self anim_stopanimscripted();
		self delete();
	}
}
	
/* NOT USED - DON'T DELETE YET
ai_ambient_noprop_think()
{
	//-----------------------
	//GLOBAL SCRIPT TO HANDLE ALL AMMBIENT GUYS
	//-------------------------
	self endon( "death" );
	assert( isdefined( self.animation ) );	//must be defined in the spawner
	sAnim = self.animation;
	bSpecial = false;
	
	if( isDefined( self.script_linkto ) )
	{
		self.eAnimEnt = getent(self.script_linkto, "script_linkname");
	}

	if ( !isdefined( self.eAnimEnt ) )
		self.eAnimEnt = self.spawner;

	
	sFailSafeFlag = undefined;
	//-----------------------
	//SPECIAL CASES
	//-------------------------
	switch( sAnim )
	{
		case "civilian_run_2_crawldeath":
			self gun_remove();
			self.skipDeathAnim = true;
			self.noragdoll = true;
			break;
		case "DC_Burning_bunker_stumble":
			self.skipDeathAnim = true;
			self gun_remove();
			break;
		case "airport_civ_dying_groupB_pull":
				self.deathanim = GetGenericAnim("airport_civ_dying_groupB_pull_death");
			break;
		case "airport_civ_dying_groupB_wounded":
				self.deathanim = GetGenericAnim("airport_civ_dying_groupB_wounded_death");
			break;
		default:
			self gun_remove();
			break;
	}
	
	self thread ai_ambient_think( sAnim, sFailSafeFlag );

}

ai_ambient_think( sAnim, sFailSafeFlag )
{	
	self endon( "death" );
	self AI_ambient_ignored(); 
	eGoal = undefined;
	sAnimGo = undefined;
	looping = false;
	//-----------------------
	//DOES AI HAVE A GOAL NODE?
	//-------------------------	
	if ( isdefined( self.target ) )
		eGoal = getnode( self.target, "targetname" );
	
	//-----------------------
	//CLEANUP PROPS AND ANIMATION NODE WHEN DEAD
	//-------------------------
	self thread ai_ambient_cleanup();

	//-----------------------
	//GO AHEAD AND PLAY LOOPING IDLE (IF ANIM IS LOOPING)
	//-------------------------	
	if ( isarray( level.scr_anim[ "generic" ][ sAnim ] ) )
	{
		looping = true;

		self.eAnimEnt thread anim_generic_loop( self, sAnim, "stop_idle" );
		sAnimGo = sAnim + "_go";	//This will be the next animation to play after the loop (if defined)
		if ( anim_exists( sAnimGo ) )
			sAnim = sAnimGo;
		else
			sAnimGo = undefined;
	}
	//-----------------------
	//FREEZE FRAME AT START OF ANIM (IF IT'S NOT A LOOP)
	//-------------------------	
	else
		self.eAnimEnt anim_generic_first_frame( self, sAnim );

	//-----------------------
	//WAIT FOR A FLAG (IF DEFINED IN THE SPAWNER) THEN PLAY ANIM
	//-------------------------
	if ( isdefined( self.script_flag ) )
	{
		if ( isdefined( sFailSafeFlag ) )
			flag_wait_either( self.script_flag, sFailSafeFlag );
		else
			flag_wait( self.script_flag );
		
	}
	
	
	//-----------------------
	//IF HEADED TO A GOAL NODE LATER....
	//-------------------------	
	if ( isdefined( eGoal ) )
	{
		self.disablearrivals = true;
		self.disableexits = true;
	}
	
	if ( !looping ) 
		self.eAnimEnt anim_generic( self, sAnim );
		
	if ( isdefined( sAnimGo ) )
	{
		self.eAnimEnt notify( "stop_idle" );
		self.eAnimEnt anim_generic( self, sAnimGo );
	}

	//-----------------------
	//DO CUSTOM SHIT BASED ON ANIMNAME
	//-------------------------
	switch( sAnim )
	{
		case "civilian_run_2_crawldeath":
			self kill();
			break;
		case "DC_Burning_bunker_stumble":
			if(isAlive(self))
			{
				self kill();
			}
			break;
		case "airport_civ_dying_groupB_pull":
			
			if(isAlive(self))
			{
				//self.eAnimEnt anim_single_solo(self,"airport_civ_dying_groupB_pull_death");
				self kill();
			}
			break;
		case "airport_civ_dying_groupB_wounded":
			if(isAlive(self))
			{
				//self.eAnimEnt anim_single_solo(self,"airport_civ_dying_groupB_wounded_death");
				self kill();
			}
			break;
		case "blow_back_dead":
			if(isAlive(self))
			{
				self kill();
			}
			break;
		case "hunted_dying_deadguy_endidle":
			if(isAlive(self))
			{
				self kill();
			}
			break;
	}
	
	//-----------------------
	//FINISH ANIM THEN RUN TO A NODE
	//-------------------------	
	if ( isdefined( eGoal ) )
	{
		self setgoalnode( eGoal );
		wait( 1 );
		self.disablearrivals = false;
		self.disableexits = false;
		self waittill( "goal" );
		if ( isdefined( self.cqbwalking ) && self.cqbwalking )
			self cqb_walk( "off" );
	}
	
	//-----------------------
	//FINISH ANIM THEN PLAY LOOPING IDLE
	//-------------------------	
	else if ( isdefined( level.scr_anim[ "generic" ][ sAnim + "_idle" ] ) )
		self.eAnimEnt thread anim_generic_loop( self, sAnim + "_idle", "stop_idle" );
		
	else if ( isdefined( level.scr_anim[ "generic" ][ sAnim + "_endidle" ] ) )
		self.eAnimEnt thread anim_generic_loop( self, sAnim + "_endidle", "stop_idle" );
		
		
	//-----------------------
	//PLAY MORTAR REACTIONS IF AVAILABLE
	//-------------------------	
	if ( anim_exists( sAnim + "_react" ) )
	{
		if ( !looping )
			sAnim = sAnim + "_idle";
		sAnimReact = sAnim + "_react";
		
		if ( anim_exists( sAnim + "_react2" ) )
			sAnimReact2 = sAnim + "_react2";
		else
			sAnimReact2 = sAnimReact;
		while( isdefined( self ) )
		{
			level waittill( "mortar_hit" );
			self.eAnimEnt notify( "stop_idle" );
			self notify ( "stop_idle" );
			waittillframeend;
			if ( RandomInt( 100 ) > 50 )
				anim_generic( self, sAnimReact );
			else
				anim_generic( self, sAnimReact2 );
			thread anim_generic_loop( self, sAnim, "stop_idle" );
			
		}
	}
}

AI_ambient_ignored()
{
	self endon( "death" );
	if ( !isdefined( self ) ) 
		return;
	if ( ( isdefined( self.code_classname ) ) && ( self.code_classname == "script_model" ) )
		return;
	self setFlashbangImmunity( true );
	self.ignoreme = true;
	self.ignoreall = true;
	self.grenadeawareness = 0;
}

anim_exists( sAnim, animname )
{
	if ( !isdefined( animname ) )
		animname = "generic";
	if ( isDefined( level.scr_anim[ animname ][ sAnim ] ) )
		return true;
	else
		return false;
}

ai_ambient_cleanup()
{
	self waittill( "death" );
	if ( ( isdefined( self.eAnimEnt ) ) && ( !isspawner( self.eAnimEnt ) ) )
		self.eAnimEnt delete();
			
}

monitor_carry_ai_death(wounded)
{
	self waittill( "death" );
	if( isAlive( wounded )&& wounded isLinked() )
	{
		wounded unlink();
		wounded.skipDeathAnim = true;
		wounded kill();
	}
}

monitor_carry_ai_wounded_death(carrier)
{
	self waittill( "death" );
	if( isAlive( carrier ) )
	{
		carrier.skipDeathAnim = true;
		carrier kill();
	}
}
*/

/******************
TRAVERSE BUILDING
******************/

monitor_roof_collapse( reset_after_use )
{
	level endon( "intro_sequence_complete" );
	
	hide_ceiling();
	thread ceiling_collapse_begins( reset_after_use );
	level.lone_star thread roof_collapse_reaction();
	level.lone_star thread waittill_near_ceiling_collapse();
	
	flag_wait_either( "player_at_ceiling_collapse", "lone_star_at_ceiling_collapse" ); //this comes from radiant
	
	if( flag( "player_at_ceiling_collapse" ) )
		flag_set( "collapse_roof" );
	else
		delaythread( 1, ::flag_set, "collapse_roof" );
}

hide_ceiling()
{
	ceiling = getentarray("collapse_building_roof_fall","targetname");
	
	foreach(ent in ceiling)
	{
		ent hide();
	}
}

roof_collapse_reaction()
{
	self endon( "death" );
	self endon( "intro_sequence_complete" );
	
	
	if( !flag( "player_at_ceiling_collapse" ) )
	{
		flag_wait( "player_near_ceiling_collapse" );
		
		node = getnode( "ceiling_collapse_node", "targetname" );
		self thread path_to_node( node, "ceiling_collapse" );
	}
	
	flag_wait( 	"lone_star_at_ceiling_collapse" );
	
	if( !flag( "player_at_ceiling_collapse" ) )
	{
		anim_target = getstruct("fallen_building_ceiling_collapse", "targetname");
		
		//wait( .5 ); //wait so it looks like a reaction and not scripted
	
		//ceiling collapse reaction
		self disable_ai_color();
		activate_trigger_with_targetname( "path_post_ceiling_collapse" );
		anim_target anim_reach_solo(self, "roof_collapse");
		length = getanimlength( getanim_from_animname( "roof_collapse", self.animname ) );
		anim_target thread anim_single_solo_run(self, "roof_collapse");
		wait( length - .5 );
		self enable_cqbwalk();
		self enable_ai_color();
	}
	
	flag_set( "ceiling_collapse_complete" );
}

path_to_node( node, endon_flag )
{
	self endon( "death" );
	if( isDefined( endon_flag ) )
	{
		level endon( endon_flag );
	}
	
	old_radius = self.goalradius;
	self.goalradius = 8;
	self set_goal_node( node );
	self waittill( "goal" );
	if( isDefined( old_radius ) )
	{
		self set_goal_radius( old_radius );
	}
}

waittill_near_ceiling_collapse()
{
	level endon( "intro_sequence_complete" );
	
	self trigger_wait_multiple_once_from_targetname( "trig_lone_star_enter_collapsed_building" );
	flag_set( "lone_star_at_ceiling_collapse" );
}

ceiling_collapse_begins( reset_after_use )
{
	level endon( "collapse_fx_stop" );
	flag_wait( "collapse_roof" );
	org = getstruct( "ceiling_collapse_org", "targetname" );
	target = getstruct( org.target, "targetname" );
	angles = vectortoangles( target.origin - org.origin );
	dist = distance( org.origin, target.origin );
	forward = anglestoforward( angles );

	org2 = getstruct( "ceiling_collapse_org2", "targetname" );
	target2 = getstruct( org2.target, "targetname" );
	angles2 = vectortoangles( target2.origin - org2.origin );
	dist2 = distance( org2.origin, target2.origin );
	forward2 = anglestoforward( angles2 );
	
	//trigger ceiling dust and rock falls when ceiling collapse
	exploder(10105);
	
	ceiling = getentarray("collapse_building_roof_fall","targetname");
	thread anim_ceiling( reset_after_use );
	earthquake(.5,3.5, org.origin, 850);
	level.player PlayRumbleOnEntity( "heavy_3s" );
	aud_send_msg("ceiling_collapse_begins");
	wait( 3.0 );
	foreach(ent in ceiling)
	{
		ent show();
	}
}

anim_ceiling( reset_after_use )
{
	large_arr = getentarray("ceiling_collapse_anim_large", "targetname");
	small1_arr = getentarray("ceiling_collapse_anim_small1", "targetname");
	small2_arr = getentarray("ceiling_collapse_anim_small2", "targetname");
	
	array_thread( small1_arr, ::handle_anim_ceiling, ( 0, 0, 20 ), 0, reset_after_use );
	array_thread( small2_arr, ::handle_anim_ceiling, ( 0, 0, 30 ), 0, reset_after_use );
	array_thread( large_arr, ::handle_anim_ceiling, ( 0, 0, -35 ), .25, reset_after_use );
}

handle_anim_ceiling( angles, waittime, reset_after_use )
{
	assert( isDefined( angles ) );
	assert( isDefined( reset_after_use ) );
	
	if( isDefined( waittime ) )
	{
		wait( waittime );
	}
	
	self RotateTo( self.angles - angles, 0.5, 0.5, 0 );
	
	wait(5);
	
	self hide();
	
	if( reset_after_use )
	{
		flag_wait( "intro_sequence_complete" );
		self.angles = self.angles + angles;
		
		wait( .05 );
		self show();
	}
}

playfx_collapse( origin, forward, dist, fx_msg, time )
{
	level endon( "collapse_fx_stop" );
	ent = spawnstruct();
	ent endon( "stop" );
	ent delaythread( time, ::send_notify, "stop" );
	
	fx = getfx( fx_msg );
	wait_time = 0.5;
	for ( ;; )
	{
		org = origin + forward * randomfloat( dist );
		PlayFX( fx, org );
		wait( wait_time );
		wait_time -= 0.35;
		if ( wait_time < 0.5 )
			wait_time = 0.5;
	}
}

traverse_building_ally_behavior()
{
	level endon( "intro_sequence_complete" );
	
	array_thread( level.heroes, ::traverse_building_posture );
	array_thread( level.heroes, ::traverse_building_crouch );
	org = getstruct( "fallen_building_slide_org", "targetname" );
	
	flag_wait( "not_intro" );
	
	array_thread( level.heroes, ::traverse_building_slide, org );
	level.lone_star thread monitor_patrol_360_turn();
	level.lone_star thread monitor_friendly_at_emerge_door( "lone_star_at_emerge_door" );
	level.truck thread monitor_friendly_at_emerge_door( "truck_at_emerge_door" );
}

traverse_building_posture()
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	self trigger_wait_multiple_once_from_targetname ("trig_lone_star_enter_collapsed_building");
	self thread traverse_building_cqbwalk();
}

traverse_building_cqbwalk()
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	self enable_cqbwalk();
	flag_wait( "building_traverse_end" );
	self disable_cqbwalk();
}

traverse_building_crouch()
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	self trigger_wait_multiple_once_from_targetname ("traverse_building_begin_force_crouch");
	self thread force_crouch();
	self trigger_wait_multiple_once_from_targetname ("traverse_building_end_force_crouch");
	self notify ("traverse_end_crouch_walk");
}

force_crouch()
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	self notify( "begin_crouching" );
	old_moverate = self.moveplaybackrate;
	self thread force_stand(old_moverate);
	self disable_cqbwalk();
	self.moveplaybackrate = 1.1;
	self anim_single_solo (self, "cqb_to_ventwalk");
	self set_run_anim( "ventwalk" );
}

force_stand(old_moverate)
{
	self waittill ("traverse_end_crouch_walk");
	self clear_run_anim ();
	if( isDefined( old_moverate ) )
	{
		self.moveplaybackrate = old_moverate;
	}
	self enable_cqbwalk();
	self thread ally_move_dynamic_speed();
	self notify ( "done_crouching" );
}

traverse_building_slide(org)
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	self trigger_wait_multiple_once_from_targetname ("traverse_building_begin_slide");
	
	
	self force_slide( org );
	wait( .05 );
}

force_slide(org)
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	
	//self set_anim_lock();
	self ally_stop_dynamic_speed();
	
	self notify( "begin_sliding" );
	old_moverate = self.moveplaybackrate;
	self.moveplaybackrate = 1;
	//self disable_ai_color();
	org anim_reach_solo( self, "slide" );
	org anim_single_solo_run( self, "slide" );
	self thread ally_move_dynamic_speed();
	self enable_ai_color();
	self.moveplaybackrate = old_moverate;
	self notify( "sliding_complete" );
	
	//self clear_anim_lock();
}

monitor_patrol_360_turn()
{
	self endon( "death" );
	level endon( "intro_sequence_complete" );
	
	trigger = getent( "fallen_building_patrol_360_turn", "targetname" );
	org = getstruct( trigger.target, "targetname" );
	
	self trigger_wait_multiple_once_from_targetname( "fallen_building_patrol_360_turn" );
	
	//self set_anim_lock();
	
	self ally_stop_dynamic_speed();
	//self disable_ai_color();
	
	length = getanimlength( getanim_from_animname( "patrol_jog_360_once", self.animname ) );
	org anim_reach_solo( self, "patrol_jog_360_once" );
	org thread maps\berlin_util::anim_single_solo_gravity( self, "patrol_jog_360_once" );
	
	self thread path_ai_post_360_jog();
	
	//faking anim_single_run since there's no anim_single_run_gravity
	wait( length - .23 ); //starting blend at .23 instead of .2 since Jordan gave me 7 frames instead of 6
	self stopanimscripted();
	org notify( "patrol_jog_360_once" );
	
	//self clear_anim_lock();
	
	wait( .6 );
	self enable_ai_color();
	self thread ally_move_dynamic_speed();
	self notify( "patrol_jog_360_complete" );
}

path_ai_post_360_jog()
{
	self endon( "death" );
	
	self disable_ai_color();
	node = getnode( "path_lone_star_post_360_jog", "targetname" );
	self set_goal_pos( node.origin );
	self set_goal_radius( 30 );
}

monitor_traverse_building_ambient()
{
	thread object_fall_gravity( "beam_fall_trigger", 1 );
	thread object_fall_gravity( "ibeam_fall_trigger", 3, "heavy_3s" );
	thread object_fall_gravity( "ibeam_fall2_trigger", 3, "heavy_3s" );
	thread object_fall_gravity( "ceiling_fall_trigger", 1 );
	
	thread object_fall_vfx_trigger( "falling_office_objects_trigger" );
	thread object_fall_vfx_trigger( "falling_office_objects_trigger2" );
}

building_falling_column( reset_after_use )
{
	level endon( "intro_sequence_complete" );
	
	if( !isDefined( level.column ) )
	{
		level.column = getent( "building_falling_column", "targetname");
	}
	level.column.animname = "berlin_falling_column";
	level.column assign_animtree ( "berlin_falling_column" );
	column_org = getstruct( "building_falling_column_org", "targetname");
	column_org thread anim_first_frame_solo ( level.column, "falling_column" );
	
	waittill_falling_column_trig();
	
	aud_send_msg("building_falling_column", level.column); 
	
	//point of no return
	if( reset_after_use )
	{
		thread reset_falling_column( column_org );
	}
	falling_column_anim( column_org );	
}

waittill_falling_column_trig()
{
	level endon( "intro_sequence_complete" );
	
	flag_wait ( "sandman_start_aftermath" );
	
	while( 1 )
	{
		dude = trigger_wait_targetname( "building_falling_column_trig" );
		if ( dude == level.lone_star || dude == level.player )
		{
			break;
		}
		wait( .05 );
	}
}

reset_falling_column( column_org )
{
	flag_wait( "intro_sequence_complete" );
	level.column anim_stopanimscripted();
	wait( .1 );
	level.column delete();
	level.column = spawn( "script_model", column_org.origin );
	level.column setModel( "concrete_column_collapse" );
}

falling_column_anim( column_org )
{
	//vfx when column falls
	level.column thread maps\berlin_fx::building_falling_column_vfx();
	pos = getstruct( "building_falling_column_artillery", "targetname" );
	playfx( level._effect[ "artillery" ], pos.origin );
	
	//anim
	column_org anim_single_solo( level.column, "falling_column" );
	flag_set( "falling_column_fell" ); //only used in intro sequence
}

object_fall_vfx_trigger( trigger_targetname )
{
	level endon( "building_traverse_end" );
	
	trigger = getEnt(trigger_targetname, "targetname");
	trigger waittill("trigger");
	
	vfx_loc = GetStruct(trigger.target, "targetname");
	aud_send_msg( "aftermath_falling_object", [trigger_targetname, trigger] );
	playfx(getfx("falling_objects"), vfx_loc.origin);
}

object_fall_gravity( trigger_target_name, earthquake_time, rumblename )
{
	level endon( "end_current_object_fall_threads" );
	
	// there are 39.3700787 inches in a meter
	// (dist in meters) = (0)t + (0.5)(9.8)t2
	// t = sqrt ((dist in meters) / (.5)(9.8))
	
	trigger = getent(trigger_target_name, "targetname");
	faller = getent(trigger.target, "targetname");
	height_mod = undefined;
	
	//get attachments

	attachments = getentarray( faller.target, "targetname" );
	
	if( isDefined( attachments ) )
	{
		foreach( attachment in attachments )
		{
			//height modifier in case the origin isn't the center of mass
			if( isDefined( attachment.script_noteworthy ) && attachment.script_noteworthy == "center_mass" )
			{
				height_mod = attachment;
			}
			else
			{
				attachment LinkTo( faller );
			}
		}
	}
	
	target_ent = getStruct(faller.target, "targetname");
	
	if( !isDefined( height_mod ) )
	{
		height_mod = faller;
	}
	dist_in = height_mod.origin[2] - target_ent.origin[2];
	//assert( dist_in > 0 ); disabling assert since we check if time == 0 below, likely temp
	time = sqrt ( (dist_in / 39.3700787) / (.5 * 9.8) );
	//assert( time > 0 ); disabling assert since we check if time == 0 below, likely temp
	shake_intensity = randomfloatrange( 0.2, 0.3 );

	trigger waittill("trigger");
	
	if( time > 0 )
	{
		aud_send_msg( "aftermath_falling_object", [trigger_target_name, faller] );
		
		wait( 0.3 );
		
		if(isdefined(earthquake_time))
		{
			earthquake(shake_intensity, earthquake_time, level.player.origin, 500);
			if( !isDefined( rumblename ) )
			{
				rumblename = "light_1s";
			}
			PlayRumbleOnPosition( rumblename, target_ent.origin );
		}
		
		wait( 0.3 );
		thread object_fall_vfx(target_ent);
		
		faller RotateTo(target_ent.angles, time, time, 0);
		faller MoveTo(target_ent.origin, time, time, 0);
		
		if(isdefined(target_ent.script_parameters))
		{
			wait(time);
			playfx(getfx(target_ent.script_parameters), target_ent.origin);
		}
	}
}

/*NOT USED
object_fall_intro_reset(initial_pos, initial_angles)
{
	flag_wait( "intro_sequence_complete" );
	self.origin = initial_pos;
	self.angles = initial_angles;
	level notify( "end_current_object_fall_threads" );
}
*/

object_fall_vfx(target_ent)
{
	//play vfx
	if(IsDefined(target_ent.target))
	{
		vfx_loc = GetStruct(target_ent.target, "targetname");
		if(IsDefined(vfx_loc.target))
		{
			thread object_fall_vfx(vfx_loc);
		}
		
		if(isDefined(vfx_loc.script_delay))
			wait(vfx_loc.script_delay);
		
		effect_name = "rock_falling";
		if(isdefined(vfx_loc.script_parameters))
			effect_name = vfx_loc.script_parameters;
		playfx(getfx(effect_name), vfx_loc.origin);
		aud_send_msg( "building_shake_rock_falling",  vfx_loc.origin);
	}
}

random_shake()
{
	vfx_locs = getstructarray ( "random_shake_vfx_loc", "script_noteworthy" );
	level endon ( "building_traverse_end" );
	while( true )
	{
		wait( 0.05 );
		shake_time = randomfloatrange( 1.0, 2.0 );
		noshake_time = randomfloatrange( 4.0, 6.0 );
		shake_intensity = randomfloatrange( 0.1, 0.25 );
		shake_close = false;
		if ( shake_intensity >= 0.17 )
		{
			aud_send_msg( "building_shake_rumble_lg" );
			shake_close = true;
		}
		else if ( shake_intensity >= 0.13 )
		{
			aud_send_msg( "building_shake_rumble_med" );
			shake_close = false;
		}
		else if ( shake_intensity >= 0.1 )
		{
			aud_send_msg( "building_shake_rumble_sm" );
			shake_close = false;
		}
		wait( 0.3 );
		earthquake( shake_intensity, shake_time, level.player.origin, 500);
		if( isDefined( vfx_locs ) && shake_close == true )
		{
			wait( 0.3 );
			thread random_shake_vfx(vfx_locs);
		}
		wait( noshake_time );
	}
}

random_shake_vfx(vfx_locs)
{
	assertex( isDefined( vfx_locs ), "calling random shake vfx without any locator structs in the world" );
	
	//check to see if vfx locator is in FOV. if it isn't take it out of the array.
	foreach (vfx_loc in vfx_locs)
	{
		if( within_fov( level.player.origin, level.player.angles, vfx_loc.origin, Cos( 45 ) ) == false )
		{
			vfx_locs = array_remove( vfx_locs, vfx_loc );
		}
	}
	
	//check to see which vfx locator is closest to the player and play a vfx on it
	new_vfx_loc = getclosest( level.player.origin, vfx_locs );
	if( isDefined( new_vfx_loc ) )
	{
		if( isDefined( new_vfx_loc.script_delay ) )
		{
			wait( new_vfx_loc.script_delay );
		}
		playfx( getfx("postcollapse_falling_dirt_camShk" ), new_vfx_loc.origin);
		aud_send_msg( "building_shake_dirt_debris", new_vfx_loc.origin );
	}
}

traverse_building_tank_corpse()
{

	spawner_1 = getent( "traverse_building_tank_corpse", "targetname" );
	org_1 = getstruct( "traverse_building_tank_corpse_org", "targetname" );
	spawner_1 thread corpse_setup( org_1, "tank_corpse", "clean_up_tank_corpse" );
	thread maps\berlin_fx::door_godray_vfx();
}

monitor_friendly_at_emerge_door( flag )
{
	level endon( "intro_sequence_complete" );
	self trigger_wait_multiple_once_from_targetname( "trig_lone_star_at_emerge_door" );
	flag_set( flag );
}


/****************
EMERGE
****************/

berlin_setup_tvs()
{
	//play cinematics on the TVs
	SetSavedDvar( "cg_cinematicFullScreen", "0" );

	thread tv_cinematic_think_hotel();
}

tv_cinematic_think_hotel()
{
	flag_wait( "emerge_door_begin_open" );
	thread tv_movie();
	
	flag_wait("player_top_of_hotel_stairwell");
	level notify( "stop_cinematic" );
	StopCinematicInGame();
}

tv_movie()
{
	level endon( "stop_cinematic" );
	
	while ( 1 )
	{
		CinematicInGameLoopResident( "berlin_tvanamorphic" );
	
		wait( 5 );
	
		while ( IsCinematicPlaying() )
		{
			wait( 1 );
		}
	}
}

setup_emerge_combat()
{
	//lone star opens door from fallen building
	thread open_emerge_door();
	
	//advance friendlies once area is clear of enemies
	thread activate_trigger_on_deathflag( "emerge_friendlies_advance", "emerge_dudes_dead" );
	
	//emerge combat
	thread emerge_combat_wave_1();
	thread emerge_combat_wave_2();
}

emerge_combat_wave_1()
{
	emerge_combat_1_spawners = getentarray( "emerge_combat_wave_1", "script_noteworthy" );
	array_thread( emerge_combat_1_spawners, ::add_spawn_function, ::emerge_combat_1_guys_think );
	flag_wait( "emerge_door_in_position" );
	array_spawn( emerge_combat_1_spawners, true );
}

emerge_combat_1_guys_think()
{
	self endon( "death" );
	self.ignoreall = true;
	flag_wait( "emerge_door_open" );
	wait( 1.7 );
	self.ignoreall = false;
}

emerge_combat_wave_2()
{
	flag_wait( "emerge_dudes_dead" ); //comes from deathflag on dudes and a trigger, whichever happens first
	dudes2 = getentarray( "emerge_combat_wave_2", "script_noteworthy" );
	array_thread( dudes2, ::spawn_ai, true );
}

open_emerge_door()
{
	flag_wait( "building_traverse_end" );//comes from the player in radiant
	
	//flag_wait( "truck_at_emerge_door" );//comes from monitor dudes at emerge door function. waits for truck to get to the door
	flag_wait( "lone_star_at_emerge_door" );//comes from monitor dudes at emerge door function. waits for lone_star to get to the door
	
	array_thread( level.heroes, ::ally_stop_dynamic_speed );
	array_thread( level.heroes, ::ignore_all_wrapper, "emerge_door_open" );

	wait(.05);
	anim_ent = getstruct( "emerge_essex_open_door", "targetname" );
	anim_ent anim_reach_solo(level.lone_star, "emerge_open_door" );
	//anim_ent anim_reach_and_approach_solo( level.lone_star, "emerge_open_door", undefined, "Cover Right" );
	
	flag_set( "emerge_door_in_position" );
	
	doorArr = GetEntArray( "emerge_exit_door", "targetname" );
	
	//door thread hunted_style_door_open();
	//wait(0.5);
	//level.lone_star disable_ai_color();
	anim_ent thread anim_single_solo( level.lone_star, "emerge_open_door" );
	flag_wait( "emerge_door_begin_open" );
	thread maps\berlin_fx::door_emerge_vfx();
	
	//special_door_open();
	door = getent( "emerge_exit_door", "targetname" );
	door do_door_open(110);
	flag_set( "emerge_door_open" );
	
	//lone star move up
	level.lone_star thread go_to_node_with_targetname( "lone_star_wait_after_emerge" );
	
	autosave_by_name( "emerge_01" );
	
	//level.lone_star clear_anim_lock();
}

go_to_node_with_targetname( targetname )
{
	self endon( "death" );
	old_radius = self.goalradius;
	self set_goal_radius( 8 );
	node = getnode( targetname, "targetname" );
	self SetGoalnode( node );
	wait(.05);
	self enable_ai_color_dontmove();
	self waittill("goal");
	self set_goal_radius( old_radius );
}

special_door_open()
{
	doorArr = GetEntArray( "emerge_exit_door", "targetname" );
	attachments = getentarray( "emerge_exit_attachments", "targetname" );
	door = doorArr[0];
	new_door_array = [];

	//manually link attachments to first brush in door array

	foreach( part in doorArr )
	{
		if( part != doorArr[0] )
		{
			new_door_array[ new_door_array.size ] = part;
		}
	}
	
	foreach( new_part in new_door_array )
	{
		new_part LinkTo( door );
	}
	
	foreach( attachment in attachments )
	{
		attachment LinkTo( door );
	}
	
	door do_door_open(110);
	flag_set( "emerge_door_open" );
}

set_accuracy( multiplyer, wait_flag, endon_msg )
{
	self endon( "death" );
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	//save off old accuracy
	old_accuracy = undefined;
	if( isDefined( self.accuracy ) )
	{
		old_accuracy = self.accuracy;
	}
	
	//accuracy multiplyer
	if( !isDefined( multiplyer ) )
	{
		multiplyer = .25; // 1/4
	}
	
	self.accuracy = self.accuracy * multiplyer;
	
	//after a while set back to old accuracy
	if( isDefined( wait_flag) )
	{
		flag_wait( wait_flag );
		if( isDefined( old_accuracy ) )
		{
			self.accuracy = old_accuracy;
		}
	}
}

activate_trigger_on_deathflag( trig_targetname, deathflag )
{
	flag_wait( deathflag );
	trig = getent( trig_targetname, "targetname" );
	if( isDefined( trig ) )
	{
		activate_trigger_with_targetname( trig_targetname );
	}
}

/****************
LAST STAND
****************/

setup_defend_sequence()
{
	//tanks
	level.last_stand_tanks = spawn_vehicles_from_targetname_and_drive( "last_stand_tank" );
	aud_send_msg("last_stand_tanks", level.last_stand_tanks);
	level.scripted_tank = spawn_vehicle_from_targetname_and_drive( "scripted_last_stand_tank" );
	aud_send_msg("last_stand_tank_scripted", level.scripted_tank);
	level.scripted_tank thread last_stand_scripted_tank_fire();//scripted tank has a scripted fire then gets added to the last_stand_tanks array
	thread last_stand_tanks_sequenced_fire();//tanks firing at random spots
	
	//fail state if player leaves hotel
	thread last_stand_player_fail( level.scripted_tank );
	
	//spawners lower level
	delaythread( 3, ::array_spawn_targetname, "ending_north_spawn", true );
	
	//guys outside stairwell shooting
	stairwell_target_locs = getentarray( "stairwell_target_loc", "targetname" );
	last_stand_stairwell_shooters = getentarray( "last_stand_stairwell_shooters", "script_noteworthy" );
	array_thread( last_stand_stairwell_shooters, ::add_spawn_function, ::ai_random_fire_at_ents, stairwell_target_locs, "player_looking_at_door_to_stairwell" );
	
	wait( 3.5 );
	
	autosave_by_name( "last_stand_1" );
	
	wait(3);
	
	autosave_by_name( "last_stand_2" );
	
	wait (1.5);// give the player some time to get up the stairs
}

last_stand_scripted_tank_fire()
{
	self endon( "death" );
	self endon( "stop_firing" );
	level endon( "stop_firing" );
	
	target = getent( "hotel_scripted_tank_fire", "targetname" );
	self setturrettargetent( target );
	
	flag_wait( "hotel_scripted_tank_fire" );
	
	wait( .05 );
	self fireweapon();
	
	//set this one up to be like the others
	self thread last_stand_tank_join_sequenced_fire();
}

last_stand_tank_join_sequenced_fire()
{
	self endon( "death" );
	self endon( "stop_firing" );
	level endon( "stop_firing" );
	
	assert( isdefined( self.script_noteworthy ) );
	self.targetentarray = getEntArray( self.script_noteworthy, "script_noteworthy" );
	self set_random_turret_target();
	
	level.last_stand_tanks = array_add( level.last_stand_tanks, self );
	if( flag( "last_stand_tanks_stopped_firing" ) )
	{
		thread last_stand_tanks_sequenced_fire();
	}
}

last_stand_tanks_sequenced_fire()
{
	level endon( "stop_firing" );
	
	//define the targets for the tanks
	foreach( tank in level.last_stand_tanks )
	{
		assert( isdefined( tank.script_noteworthy ) );
		tank.targetentarray = getEntArray( tank.script_noteworthy, "script_noteworthy" );
	}
	
	active_tank = undefined;
	
	//start sequencing (loop)
	while( true )
	{
		//define active tank
		level.last_stand_tanks = array_randomize( level.last_stand_tanks );
		foreach( tank in level.last_stand_tanks )
		{
			if( isDefined( tank ) && isAlive( tank ) )
			{
				active_tank = tank;
				break;
			}
			else
			{
				array_remove( level.last_stand_tanks, tank );
				if( level.last_stand_tanks.size <= 0 )
				{
					flag_set( "last_stand_tanks_stopped_firing" );
					return;
				}
			}
		}
		
		if( isdefined( active_tank ) && isAlive( active_tank ) )
		{
			//set target, wait and fire
			active_tank last_stand_tank_fire_random_target();
		}
		wait( randomfloatrange( 5, 6 ) );
	}
}

last_stand_tank_fire_random_target()
{
	self endon( "death" );
	self endon( "stop_firing" );
	level endon( "stop_firing" );
	
	self thread set_random_turret_target();
	wait( randomfloatrange( 2, 3 ) );//wait for turret to get into position initially
	self fireweapon();
}

set_random_turret_target()
{
	self endon( "death" );
	self endon( "stop_firing" );
	level endon( "stop_firing" );
	
	assert( isdefined( self.targetentarray ) );
	while( true )
	{
		target_array = array_randomize( self.targetentarray );
		if( self vehicle_canTurretTargetPoint( target_array[0].origin ) )
		{
			self setturrettargetent( target_array[0] , (randomintrange(-64, 64),randomintrange(-64, 64),randomintrange(-16, 100)));
			break;
		}
		wait( .05 );
	}
}

last_stand_player_fail( tank )
{
	volume = getent( "last_stand_kill_player", "targetname" );
	level.last_stand_tanks = array_remove( level.last_stand_tanks, tank );
	kill_player_with_tank( tank, volume, "last_stand_kill_player_trig", ::last_stand_tank_join_sequenced_fire, "reverse_breach_start", &"BERLIN_LAST_STAND_FAIL" );
}

kill_player_with_tank( tank, volume, trig_targetname, return_think_func, endon_msg, ui_deadquote )
{
	if( isDefined( endon_msg ) )
	{
		level endon( endon_msg );
	}
	
	while(1)
	{
		if( level.player isTouching( volume ) )
		{
			if( isDefined( tank ) && isAlive( tank ) )
			{
				tank notify( "stop_firing" );
				tank setturrettargetent( level.player, ( 0, 0, 20 ) );
				tank thread tank_fire_during_player_fail();
			}
			
			//waittill trigger or not in volume
			waittill_trigger_or_not_in_volume( volume, trig_targetname );//don't thread this
			if( flag( "tank_killed_player" ) )
			{
				if( isDefined( ui_deadquote ) )
				{
					SetDvar( "ui_deadquote", ui_deadquote );
					missionFailedWrapper();
				}
				level.player kill();
			}
			else
			{
				//else stop and go back to firing random things
				if( isDefined( tank ) && isAlive( tank ) && isDefined( return_think_func ) )
				{
					tank thread [[ return_think_func ]]();
				}
			}
		}
		wait( .1 );
	}
}

tank_fire_during_player_fail()
{
	level endon( "player_not_in_tank_kill_volume" );
	self endon( "death" );
	
	flag_wait_or_timeout( "tank_killed_player", 5 );
	if( isDefined( self ) )
	{
		self fireweapon();
		wait( .5 );
	}
}

waittill_trigger_or_not_in_volume( volume, trig_targetname)
{
	level endon( "player_not_in_tank_kill_volume" );
	
	thread waittill_not_in_volume( volume );
	thread waittill_trigger_set_flag( trig_targetname, "tank_killed_player" );
	
	flag_wait( "tank_killed_player" );
}

waittill_not_in_volume( volume )
{
	level endon( "tank_killed_player" );
	
	while( level.player isTouching( volume ) )
	{
		wait( .05 );
	}
	level notify( "player_not_in_tank_kill_volume" );
	
	return;		
}

waittill_trigger_set_flag( trig_targetname, flag_name )
{
	level endon( "player_not_in_tank_kill_volume" );
	
	trigger_wait_targetname( trig_targetname );
	flag_set( flag_name );
}


/***************
ROOF RUN
***************/

setup_run_to_roof()
{
	flag_wait( "player_reached_lower_floor_hotel" );
	array_thread( level.heroes, ::set_allowpain, false );	
	
	flag_wait("player_looking_at_door_to_stairwell");
	
	//kick in first door
	//array_thread( level.heroes, ::disable_ai_color );
	array_thread( level.heroes, ::disable_cqbwalk );
	array_thread( level.heroes, ::set_neverEnableCQB, true);
	
	last_stand_kick_open_door();
	
	//prepare allies for pathing
	array_thread( level.heroes, ::set_allowpain, true );	
	array_thread( level.heroes, ::enable_ai_color_dontmove );
	array_thread( level.heroes, ::disable_awareness );
	level.lone_star set_force_color("o");
	level.essex set_force_color("r");
	level.truck set_force_color("y");
	
	//send allies to waiting nodes in stairwell
	activate_trigger_with_targetname ("last_stand_stairwell_wait"); 
	
	//allies traverse to the top of the stairwell using color triggers
	
	//prepare allies for pathing in hallway
	array_thread( level.heroes, ::setup_allies_for_reverse_breach_hall );
	
	flag_wait("player_top_of_hotel_stairwell"); //player at the top of the stairwell
	
	aud_send_msg( "mus_player_at_top_of_hotel_stairwell" );
	
	thread exfil_hall_dudes();
	autosave_by_name( "run_up_to_roof_01" );
	
	//tell tanks to stop firing
	level notify("stop_firing");
	
	level.lone_star set_force_color("o");
	level.essex set_force_color("r");
	level.truck set_force_color("r");
	
	//send allies to waiting nodes in exfil hallway
	activate_trigger_with_targetname( "exfil_hall_color_trig_01" );
	wait( 2 );
	activate_trigger_with_targetname( "exfil_hall_color_trig_02" );
}

set_allowpain( value )
{
	self.allowpain = value;
}

setup_allies_for_reverse_breach_hall()
{
	self trigger_wait_multiple_once_from_targetname( "trig_ally_last_stand_door_kick_2" );
	self thread enable_cqbwalk();
	self thread enable_awareness();
}

last_stand_kick_open_door()
{	
	thread last_stand_truck_wait_for_door();
	
	anim_ent = getstruct("door_hotel_stairs_restaurant_point", "targetname");
	guy = level.lone_star;
	door = getent("door_hotel_stairs_restaurant", "targetname");
	
	anim_ent anim_reach_solo(guy, "doorkick_2_cqbrun");
	
	anim_ent thread last_stand_open_door_anim( guy, "doorkick_2_cqbrun" );
	
	thread maps\berlin_fx::door_kick_vfx_1();
	aud_send_msg("last_stand_door_kick",door);
	wait(.5);
	door thread last_stand_door_open();
}

last_stand_open_door_anim( guy, animname )
{
	guy PushPlayer( true );
	self anim_single_run_solo( guy, animname );
	guy PushPlayer( false );
}

last_stand_door_open()
{
	self do_door_open();
	flag_set( "door_hotel_stairs_1_open" );
}

last_stand_truck_wait_for_door()
{
	//todo merge with berlin_code::go_to_node_with_targetname ?
	level.truck disable_ai_color();
	node = getnode("open_first_door_truck_wait", "targetname");
	level.truck.goalradius = 10;
	level.truck setgoalnode(node);
}

disable_awareness()
{
	assert(self.awareness);
	self.awareness = 0;
	self.ignoreall = true;
	self.dontmelee = true;
	self.ignoreSuppression = true;
	self.suppressionwait_old = self.suppressionwait;
	self.suppressionwait = 0;
	self disable_surprise();
	self.IgnoreRandomBulletDamage = true;
	self disable_bulletwhizbyreaction();
	self disable_pain();
	self disable_danger_react();
	self.grenadeawareness = 0;
	self.ignoreme = 1;
	self enable_dontevershoot();
	self.disableFriendlyFireReaction = true;
}

has_awareness()
{
	return self.awareness;
}

enable_awareness()
{
	assert(!self.awareness);
	self.awareness = 1;
	self.ignoreall = false;
	self.dontmelee = undefined;
	self.ignoreSuppression = false;
	assert(isdefined(self.suppressionwait_old));
	self.suppressionwait = self.suppressionwait_old;
	self.suppressionwait_old = undefined;
	self enable_surprise();
	self.IgnoreRandomBulletDamage = false;
	self enable_bulletwhizbyreaction();
	self enable_pain();
	self.grenadeawareness = 1;
	self.ignoreme = 0;
	self disable_dontevershoot();
	self.disableFriendlyFireReaction = undefined;
}

exfil_hall_dudes()
{
	//spawn dudes outside door
	dudes = array_spawn( getentarray( "exfil_rus_3", "script_noteworthy" ) );
}

do_door_open(angle, time, accel, decel)
{
	if( !isDefined( angle ) )
		angle = -120;
	if( !isDefined( time ) )
		time = 0.5;
	if( !isDefined( accel ) )
		accel = 0;
	if( !isDefined( decel ) )
		decel = 0.5;
	
	//optional attachments, door handles etc.
	//IN RADIANT: add the handle as a script_model: com_door_05_handle_l and com_door_05_handle_r and link the door to the handle(s)
	if (isDefined (self.target))
	{
		attachments = getentarray (self.target, "targetname");
		foreach (attachment in attachments)
		{
			attachment LinkTo (self);
		}
	}
	self RotateTo( self.angles + ( 0, angle, 0 ), time, accel, decel );
	self waittill( "rotatedone" );
	self ConnectPaths();
}

GrenadeWrapper( grenade_type, from, to, arm_time)
{
	MagicGrenade( grenade_type, from, to, arm_time );
}

/******************
REVERSE BREACH
******************/

setup_reverse_breach()
{
	//setup fx for reverse breach
	breach_fx = GetEntArray( "breach_fx", "targetname" );
	array_thread( breach_fx, ::breach_fx_setup );
	
	thread monitor_reverse_breach();
}

move_to_reverse_breach_door( goal_targetname )
{
	goal = getNode( goal_targetname, "targetname" );
	self disable_ai_color();
	//self set_goal_radius( 8 );
	level.lone_star set_goal_node( goal );
	//self set_goal_radius( 8 );
	self disable_cqbwalk();
}

monitor_reverse_breach()
{
	anim_ent = getstruct("reverse_breach_anim_point","targetname");
	
	///HELI AND HELI ACTORS IDLE///
	//spawn heli
	heli = spawn_reverse_breach_heli();
	thread maps\berlin_fx::heli_endinterior(heli);
	
	//define heli actors
	heli_actors = spawn_reverse_breach_heli_actors();
	heli_actors = array_add( heli_actors, heli );
	
	anim_ent thread anim_loop( heli_actors, "reverse_breach_idle" );
	
	//-------------//
	
	//wait till dudes dead or timeout to move up again
	flag_wait_or_timeout( "exfil_hallway_dudes_dead", 15 );
	flag_set( "exfil_hallway_dudes_dead" );
	
	/*
	Notetracks
	weapon_pullout = to pullout VM weapon early
	door_breach = triggers the explosion of the door
	draw_gun = player drawing the pistol from guy's holster
	*/

	//setup lone star at the door
	anim_ent anim_reach_solo( level.lone_star, "reverse_breach_guy_enter" );
	anim_ent anim_single_solo( level.lone_star, "reverse_breach_guy_enter" );
	anim_ent thread anim_loop_solo( level.lone_star, "reverse_breach_stand_idle", "stop_ground_dudes_idle" );
	
	flag_set( "reverse_breach_ready" );
	
	thread setup_reverse_breach_trigger();
	
	//player to presses X
	flag_wait( "trigger_start_reverse_breach" );
	
	aud_send_msg("reverse_breach_start");
	maps\_shg_common::SetUpPlayerForAnimations();
	reverse_breach_cleanup_weapons(); // Cleanup any weapons on the ground
	flag_set("reverse_breach_start");
	
	///DO REVERSE BREACH///
	//spawn rig
	player_rig = spawn_anim_model( "player_rig", anim_ent.origin );
 	player_rig Hide();
 		
	//spawn player body as a model
	level.player_body = spawn_anim_model( "reverse_breach_player_body", anim_ent.origin );
	level.player_body Hide();
	level.player_body.animname = "reverse_breach_player_body";
	reverse_breach_gun = spawn_anim_model( "reverse_breach_gun", anim_ent.origin );
	reverse_breach_gun HidePart( "TAG_SILENCER" );
	reverse_breach_gun.animname = "reverse_breach_gun";
	
	array_thread( level.heroes, ::set_ignoreall, true );
	
	breach_actors = [];
	breach_actors[0] = player_rig;
	breach_actors[1] = level.player_body;
	breach_actors[2] = reverse_breach_gun;
	breach_actors[3] = level.lone_star;
	
 	anim_ent anim_first_frame( breach_actors, "reverse_breach" );
	
	//lerp player
	player_rig lerp_player_view_to_tag( level.player, "tag_player", .5, 1, 50, 50, 25, 5 );
	level.player PlayerLinkToDelta( player_rig, "tag_player",  1, 50, 50, 25, 5 );

	//when to show everything
	player_rig delayCall( 0.6, ::Show );
	level.player_body delayCall( 0.6, ::Show );
	
	//remove collision on door
	door_col = getent("reverse_breach_door_collision", "targetname");
	door_col ConnectPaths();
	door_col delete();
	
	setsavedDvar( "g_friendlyNameDist", 0 );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "hud_showStance", "0");
	
	level.player AllowAds( false );
	
	//play animation
	level.lone_star anim_stopanimscripted();
	anim_ent notify( "stop_ground_dudes_idle" );
	anim_ent anim_single(breach_actors, "reverse_breach");
	
	//loop anims until guys are dead or player is dead
	if( !flag( "reverse_breach_complete" ) )
	{
		anim_ent thread anim_loop( breach_actors, "reverse_breach_idle", "stop_breach_actor_idle" );
	}
	
	//wait for guys to get killed
	flag_wait("reverse_breach_complete");
	wait(0.5);
	
	level.essex.ignoreall = false;
	level.truck.ignoreall = false;	
	
	level.player disableWeapons();
	
	level.lone_star anim_stopanimscripted();
	anim_ent notify( "stop_breach_actor_idle" );
	
	///GETUP AND END///
	
	aud_send_msg( "reverse_breach_getup" );
	
	//play getup anim on heli actors
	anim_ent thread anim_single( heli_actors, "reverse_breach_getup" );
	
	anim_ent thread handle_lone_star_getup_and_end( level.lone_star );
	
	//play getup and end anim on ground actors
	ground_actors = [];
	ground_actors[0] = level.essex;
	anim_ent thread handle_reverse_breach_getup_and_end( ground_actors );
	
	///PLAYER GETUP///
	player_parts = [];
	player_parts[0] = player_rig;
	player_parts[1] = level.player_body;
	// about 1 in 5 times, the gun doesn't sync with the body animation, instead we will attach the gun to the wrist
	//player_parts[2] = reverse_breach_gun;
 	anim_ent anim_first_frame( player_parts, "reverse_breach_getup" );
	rel_pos = ( -14.350, -1.056,  -2.094 ); // relative offset of wrist to gun - from Maya
	rel_ang = (  7.341, 171.453, -82.298 ); // relative angles of wrist to gun - from Maya
 	reverse_breach_gun LinkTo( player_rig, "j_wrist_ri", rel_pos, rel_ang );

	length = getanimlength( getanim_from_animname( "reverse_breach_getup", "player_rig" ) );
	thread lerp_fov_overtime( 6.16, 40 ); //6.16 is the current anim length, using the hard value so once the anim length changes it will still look good.
	anim_ent thread anim_single( player_parts, "reverse_breach_getup" );
	
	level.player PlayerLinkToBlend( player_rig, "tag_player", .5 );
	delaythread( 5, ::reverse_breach_getup_slowmo );
	delaythread( 7.9, ::reverse_breach_getup_regular_speed ); //was 8.96667
	
	wait( length );//8.46667
	
	level.player AllowAds( true );
	
	SetSavedDvar( "hud_showStance", "1" );
	SetSavedDvar( "compass", "1" );
	setsavedDvar( "g_friendlyNameDist", 15000 );

	//give the player back his gun
	//maps\_shg_common::ForcePlayerWeapon_End();
	reverse_breach_gun delete();
	
	//do this for both movement and camera
	level.player unlink();
	maps\_shg_common::SetUpPlayerForGamePlay();
	player_rig Delete();
	level.player_body Delete();
	
	/* do this if you don't want movement but want camera
	//player_rig lerp_player_view_to_tag( level.player, "tag_player", .5, 1, 50, 50, 25, 5 );
	//level.player PlayerLinkToDelta( player_rig, "tag_player",  1, 50, 50, 25, 5 );
	*/
	
	flag_set( "reverse_breach_player_back_in_business" );
}

setup_reverse_breach_trigger()
{
	trigger_ent = GetEnt( "reverse_breach_trig", "script_noteworthy" );
	trigger_ent SetHintString( &"BERLIN_BREACH_HINT" );// Press and hold^3 &&1 ^7to breach.
	
	flag_wait( "trigger_start_reverse_breach" );

	trigger_ent Delete();
}

reverse_breach_cleanup_weapons()
{
	weapons = GetWeaponArray();
	if ( IsDefined( weapons ) )
	{
		foreach( weapon in weapons )
		{
			weapon delete();
		}
	}
}

reverse_breach_getup_slowmo()
{
	aud_send_msg("reverse_breach_getup_slowmo");
	flag_set( "reverse_breach_getup_slowmo_start" );
	slowmo_setspeed_slow(.5);
	slowmo_setlerptime_in( .3 );
	slowmo_lerp_in();
}

reverse_breach_getup_regular_speed()
{
	aud_send_msg("reverse_breach_getup_regular_speed");
	slowmo_setlerptime_out( .3 );
	slowmo_lerp_out();
}

spawn_reverse_breach_heli()
{
	heli = spawn_vehicle_from_targetname( "enemy_heli_exfil" );
	heli.animname = "heli";
	heli.mgturret[0] hide();
	aud_send_msg("spawn_reverse_breach_heli", heli);
	
	return heli;
}

spawn_reverse_breach_heli_actors()
{
	heli_actors = [];
	
	//spawn_girl
	girl_spawner = getent( "pres_daughter", "targetname" );
	girl_spawner add_spawn_function( ::setup_reverse_breach_heli_actors, "girl" );
	girl = girl_spawner spawn_ai( true );
	level.alena = girl;
	level.alena.animname = "alena";
	
	//spawn guy 1
	/*
	guy_1_spawner = getent( "exfil_rus_1", "script_noteworthy" );
	guy_1_spawner add_spawn_function( ::setup_reverse_breach_heli_actors, "guy_1" );
	guy_1 = guy_1_spawner spawn_ai( true );
	guy_1 gun_remove();
	*/
	
	//spawn guy 2
	guy_2_spawner = getent( "exfil_rus_2", "script_noteworthy" );
	guy_2_spawner SetSpawnerTeam( "neutral" );
	guy_2_spawner add_spawn_function( ::setup_reverse_breach_heli_actors, "guy_2" );
	guy_2 = guy_2_spawner spawn_ai( true );
	guy_2 gun_remove();
	guy_2.team = "neutral";
	
	//define heli actors
	heli_actors = [];
	heli_actors[0] = girl;
	heli_actors[1] = guy_2;
	//heli_actors[2] = guy_1;
	
	return heli_actors;
}

setup_reverse_breach_heli_actors( animname )
{
	self endon( "death" );
	self.ignoreall = true;
	self.ignoreme = true;
	self magic_bullet_shield();
	assert( isDefined( animname ) );
	self.animname = animname;
}

handle_lone_star_getup_and_end( actor, tag )
{
/*in RAM now
	// NOTE:
	// prime the *SECOND* dialogue line since it's longer
	// the first dialogue line is in RAM.
	// we can't prime more than one line of dialogue on the same entity
	
	actor thread dialog_prime( "berlin_cby_welosther" );
*/
	self anim_single_solo( actor, "reverse_breach_getup", tag );
	
	//Sandman: We can't risk it!
	actor thread dialogue_queue("berlin_cby_cantriskit");
	self anim_single_solo( actor, "reverse_breach_end_1", tag );
	
	//Sandman: Overlord - negative precious cargo… We lost her.
	actor thread dialogue_queue("berlin_cby_welosther");
	self anim_single_solo( actor, "reverse_breach_end_2", tag );	
}

dialog_prime( msg )
{
	assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
	alias = level.scr_sound[self.animname][msg];
	self aud_prime_stream( alias );
}

handle_reverse_breach_getup_and_end( actors, tag )
{
	self anim_single( actors, "reverse_breach_getup", tag );
	//play fake heli dust fx on edge of building
	exploder("end_heli_dust");
	self anim_single( actors, "reverse_breach_end", tag );
}

reverse_breach_weapon_pullout(guy)
{
	level.force_weapon = level.reverse_breach_weapon;
	level.old_force_weapon = undefined;
	
	maps\_shg_common::ForcePlayerWeapon_Start();
}

reverse_breach_door_breach(guy)
{
	door = getent( "reverse_breach_door_test", "targetname" );
	anim_ent = getstruct( "reverse_breach_destroyed", "targetname" );
	
	aud_send_msg("reverse_breach_door_explode");
	
	exploder( "breach_please_work" );
	destroyedModel = spawn_anim_model( "breach_door_model", anim_ent.origin);
	destroyedModel.animname = "breach_door_model";

	anim_ent thread anim_single_solo( destroyedModel, "breach" );
	door Delete();
	
	//remove chunks around door
	chunks = getentarray( "reverse_breach_chunk", "targetname" );
	foreach( chunk in chunks )
	{
		if( isDefined( chunk ) )
		{
			chunk delete();
		}
	}
	
	flag_set( "reverse_breach_door_blown" );
	
	level.player playsound( "detpack_explo_main");
	level.player DisableWeapons();
	SetBlur( 3, .1 );
	
	
	//Blow out vision set moment during door bust in
	vision_set_fog_changes("berlin_breach", 0);
	


	level.reverse_breach_enemies_dead = 0;
	level.reverse_breach_enemies_total = 2;
	//spawn and animate enemies
	thread reverse_breach_enemy(0.5, "reverse_breach_enemy_right", "reverse_breach_anim_point", "reverse_breach_enemy_right");
	thread reverse_breach_enemy(0.5, "reverse_breach_enemy_left", "reverse_breach_anim_point", "reverse_breach_enemy_left");
			
	wait(0.5);

	slowmo_setspeed_slow(.3);
	slowmo_setlerptime_in( 0 );
	slowmo_lerp_in();

	//Returning visionset back to normal
	setsaveddvar("sm_sunenable",1);
	setsaveddvar("sm_spotlimit",1);
	
	vision_set_fog_changes("berlin_end", 10);
	
	
	wait(12.0);
	
	if(!flag("reverse_breach_complete"))
		level.player Kill();
		
		
	
	//time is resumed when we draw the pistol
}

breach_fx_setup()
{
	AssertEx( IsDefined( self.script_fxid ), "Breach_fx at " + self.origin + " has no script_fxid" );
	fxid = self.script_fxid;
	ent = createExploder( fxid );
 	ent.v[ "origin" ] = self.origin;
 	ent.v[ "angles" ] = self.angles;
 	ent.v[ "fxid" ] = fxid;
 	ent.v[ "delay" ] = 0;
 	ent.v[ "exploder" ] = "breach_please_work";
 	ent.v[ "soundalias" ] = "nil";
 	ent.v[ "forward" ] = anglestoforward(self.angles);
 	ent.v[ "up" ] = anglestoup(self.angles);
}

reverse_breach_draw_pistol(guy)
{
	//setup beretta model and link to player_body anim hand.
	wait(0.5);
	slowmo_setlerptime_out( .3 );
	slowmo_lerp_out();
	SetBlur( 0, 2 );	
	
	flag_set("breach_weapon_drawn");
}

reverse_breach_enemy(initial_delay, spawner_targetname, anim_org_targetname, anim_name)
{
	wait(initial_delay);
	reverse_breach_enemy = getent( spawner_targetname , "targetname" );
	reverse_breach_enemy_origin = getstruct( anim_org_targetname , "targetname" );
	
	guy = reverse_breach_enemy spawn_ai(true);

	//since the guy just spawned, wait until he is ready before doing stuff
	waittillframeend;
	guy.animname = "generic";
	guy.health = 1;
	guy.allowdeath = true;
	guy maps\_utility::disable_long_death();

	guy thread monitorAware();
	
	reverse_breach_enemy_origin anim_teleport_solo( guy , anim_name );
	reverse_breach_enemy_origin anim_single_solo( guy , anim_name );

	guy waittill("death");
	
	level.reverse_breach_enemies_dead++;
	if(level.reverse_breach_enemies_dead == level.reverse_breach_enemies_total)
		flag_set("reverse_breach_complete");
}

monitorAware()
{
	self endon( "death" );
	
	self.ignoreall = true;
	
	flag_wait("breach_weapon_drawn");
	wait( 1 );
	
	self.ignoreall = false;
	self.accuracy = self.accuracy * 1.5;
	self.favoriteenemy = level.player;
	self SetLookAtEntity( level.player );
	//limit dudes movement
	self set_goal_pos( self.origin );
	self set_goal_radius( 100 );
}

monitor_end_mission()
{
	flag_wait( "reverse_breach_ending_vo_complete" );
	wait 2;
	
	objective_complete( level.last_stand_obj );
	
	wait .75;
	
	black_overlay = get_black_overlay();
	//blinking
	black_overlay exp_fade_overlay( 1, 2 );
	
	wait 1.5;
	
	nextmission();
}

/**************************
UTILS
**************************/

//stole this from paris
// fake death
bloody_death( delay )
{
	self endon( "death" );

	if( !IsSentient( self ) || !IsAlive( self ) )
	{
		return;
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return;
	}

	self.bloody_death = true;

	if( IsDefined( delay ) )
	{
		wait( RandomFloat( delay ) );
	}

	tags = [];
	tags[0] = "j_hip_le";
	tags[1] = "j_hip_ri";
	tags[2] = "j_head";
	tags[3] = "j_spine4";
	tags[4] = "j_elbow_le";
	tags[5] = "j_elbow_ri";
	tags[6] = "j_clavicle_le";
	tags[7] = "j_clavicle_ri";

	for( i = 0; i < 3 + RandomInt( 5 ); i++ )
	{
		random = RandomIntRange( 0, tags.size );
		//vec = self GetTagOrigin( tags[random] );
		self thread bloody_death_fx( tags[random], undefined );
		wait( RandomFloat( 0.1 ) );
	}

	self DoDamage( self.health + 50, self.origin );
}

bloody_death_fx( tag, fxName )
{
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"];
	}

	PlayFxOnTag( fxName, self, tag );
}

delete_pipes_in_volume( volume_targetname )
{
	volume = getent( volume_targetname, "targetname" );
	pipes = getentarray( "pipe_shootable", "targetname" );
	
	assert( isDefined( volume ) );
	assert( isDefined( pipes ) );
	
	foreach( pipe in pipes )
	{
		if( isDefined( pipe ) && pipe isTouching( volume ) )
		{
			pipe delete();
		}
	}
}

kill_player_triggers( flag_msg, endon_msg )
{
	level endon( endon_msg );
	
	flag_wait( flag_msg );
	level.player kill();
}

set_preferredtarget( target )
{
	self endon( "death" );
	self.prefferedtarget = target;
}

get_alive_from_noteworthy( noteworthy, array )
{
	if( !isDefined( array ) )
	{
		array = getentarray( noteworthy, "script_noteworthy" );
	}
	assert( isDefined( array ), "no script noteworthy parameter found in get_alive_from_noteworthy()" );
	assert( isDefined( noteworthy ), "no script noteworthy parameter found in get_alive_from_noteworthy()" );
	
	new_array = [];
	foreach( thing in array )
	{
		if( isDefined( thing ) && isAlive( thing ) && isDefined( thing.script_noteworthy ) )
		{
			if( thing.script_noteworthy == noteworthy )
			{
				new_array[new_array.size] = thing;
			}
		}
	}
	return new_array;
}

trigger_wait_multiple_once_from_targetname(targetname, set_flag)
{
	self endon ("death");
	while( 1 )
	{
		guy = trigger_wait_targetname( targetname );
		
		if( guy == self )
		{
			if( isDefined( set_flag ) )
			{
				flag_set( set_flag );
			}
			break;
		}
	}
}

set_anim_lock()
{
	self endon( "death" );
	if( !isDefined( self.anim_lock ) )
	{
		self init_anim_lock();
	}
	self waittill_anim_lock_clear();
	wait( .05 );
	self.anim_lock = true;
}

clear_anim_lock()
{
	self endon( "death" );
	self.anim_lock = false;
}

init_anim_lock()
{
	self endon( "death" );
	self.anim_lock = false;
}

waittill_anim_lock_clear()
{
	self endon( "death" );
	if( self.anim_lock )
	{
		while( self.anim_lock )
		{
			wait( .05 );
		}
	}
}

corpse_setup( org, deathanim, cleanup_flag )
{
	corpse_drone = self spawn_ai( true );
	corpse_drone gun_remove();
	corpse_drone.animname = "generic";
	sAnim = corpse_drone getanim( deathanim );
	if( !isDefined( org ) )
	{
		org = self;
	}
	org anim_generic_first_frame( corpse_drone, deathanim );
	dummy = maps\_vehicle_aianim::convert_guy_to_drone( corpse_drone );
	dummy setanim( sAnim, 1, .2 );
	dummy notsolid();
	if ( isDefined (cleanup_flag) )
	{
		flag_wait( cleanup_flag ); //TODO: set this flag in script
		dummy delete();
	}
	else
	{
		return dummy;
	}
}

kill_no_react()
{
	if ( !isalive( self ) )
	{
		return;
	}
	self.allowDeath = true;
	self.a.nodeath = true;
	self set_battlechatter( false );
	self kill();
}

self_delete_on_flag_set( delete_flag )
{
	flag_wait( delete_flag );
	self_delete();
}

flag_set_on_death( death_flag )
{
	self waittill ("death");
	if (isDefined (death_flag) && !flag (death_flag))
	{
		flag_set (death_flag);
	}
}

smart_createthreatbiasgroup( bias )
{
	if( !ThreatBiasGroupExists( bias ) )
	{
		CreateThreatBiasGroup( bias );
		return false;
	}
	else
	{
		return true;
	}
}

array_setthreatbiasgroup( bias )
{
	foreach( guy in self )
	{
		if( isDefined( guy ) && isAlive( guy ) )
		{
			guy setthreatbiasgroup( bias );
		}
	}
}

//all arguments are optional
tank_fire_at_targets( targetentarray, wait_min, wait_max, waitflag )
{
	self endon( "death" );
	
	if( isDefined( waitflag ) )
	{
		flag_wait( waitflag );
	}
	
	self notify( "stop_firing" );
	self endon( "stop_firing" );
	level endon( "stop_firing" );
	
	if(!isdefined(targetentarray))
	{
			assert(isdefined(self.script_noteworthy));
			targetentarray = getEntArray(self.script_noteworthy, "script_noteworthy");
	}
	
	assert(isdefined(targetentarray));
	
	targetentarray = array_randomize(targetentarray);
	self setturrettargetent( targetentarray[0] , (randomintrange(-64, 64),randomintrange(-64, 64),randomintrange(-64, 64)));
	
	wait( randomfloatrange( 2, 3 ) ); // wait initially so the turret has time to rotate into the general direction of the targets. TODO: use angles to determine if it's done rotating or not
	
	while(1)
	{
		self fireweapon();
		
		wait( .05 );
		targetentarray = array_randomize(targetentarray);
		self setturrettargetent( targetentarray[0] , (randomintrange(-64, 64),randomintrange(-64, 64),randomintrange(-64, 64)));
		
		if( isDefined( wait_min ) && isDefined( wait_max ) )
			wait( randomfloatrange( wait_min, wait_max ) );
		else
			wait( 3 );
	}
}

tank_fire_at_enemies_in_volume( volume )
{
	self endon("death");
	self endon("stop_random_tank_fire");
	target = undefined;
	
	assert( isDefined( volume ), "no volume defined for tank_fire_at_enemies_in_volume" );
	while(1)
	{		
		if(isdefined(target)&& target.health > 0)
		{
			self setturrettargetent( target , (randomintrange(-64, 64),randomintrange(-64, 64),randomintrange(-16, 100)));
			
			if(SightTracePassed(self.origin + (0,0,100), target.origin + (0,0,40), false, self ))
			{	
				self.tank_think_fire_count++;
				self fireweapon();
				if(self.tank_think_fire_count >= 3)
				{
					//dont try annd kill things that shouldn't die
					if((!isdefined(target.damageShield) || target.damageShield == false) 
						&& (!isdefined(target.magic_bullet_shield) || target.magic_bullet_shield == false))
						{
							target notify("death");
						}
				}
				wait(randomintrange(4,10));//short timer so we can just see the tanks firing
			}
			else
			{
				target = undefined;
				wait(1);
			}	
		}
		else
		{	
			if(!isAlive(self))
				break;
			target = self get_tank_targets_in_volume( volume );
			self.tank_think_fire_count = 0;
			wait(1);
		}
		wait(RandomFloatRange(0.05, .5));
	}
}

get_tank_targets_in_volume( volume )
{
	//guys = getentarray(script_noteworthy_name, "script_noteworthy");
	bad_guys = getaiarray("axis");
	guys = [];
	foreach( guy in bad_guys )
	{
		if( guy isTouching( volume ) )
		{
			guys[guys.size] = guy;
		}
	}
	
	if(isdefined(guys))
	{
		possibletarget = random(guys);
		if( isdefined(possibletarget) && !isSpawner(possibletarget) && possibletarget.health > 0)
		{
			target = possibletarget;
			self notify("new_target");
			
			//self thread draw_tank_target_line(self, target, (1,1,1));
			//target thread show_tank_target(self);
			
			return target;
		}
		else
		{
			return undefined;
		}
	}
	return undefined;
}

fake_javelin( fakeJavLauncher, flightMode )
{	
    newMissile = MagicBullet( "javelin_berlin", fakeJavLauncher.origin, self.origin );
    newMissile thread fake_javelin_earthquake( self ); 	//quake on impact
    newMissile Missile_SetTargetEnt( self );
    if(isDefined(flightmode) && flightMode == "direct")
    {
   	 	newMissile Missile_SetFlightmodeDirect();
  	}
  	else
  	{
  	  newMissile Missile_SetFlightmodeTop();    	//top down kill mode for javelin
  	}
  	return newMissile;
}

fake_javelin_earthquake( targetObj )
{
    dummy = spawn( "script_origin", self.origin );
    dummy linkto( self );
    self waittill( "death" );
    earthquake( 1.2, 1.5, dummy.origin, 1600 );
    wait( 0.05 );
    dummy delete();
}

random_tracers(targetname_a, targetname_b, endon_msg)
{
	level endon(endon_msg);
	west_arr = GetStructArray(targetname_a, "targetname");
	east_arr = GetStructArray(targetname_b, "targetname");
	
	while(1)
	{
		west_arr = array_randomize(west_arr);
		east_arr = array_randomize(east_arr);

		from = west_arr[0];
		to = east_arr[0];
		//east to west
		if(cointoss())
		{
			from = east_arr[0];
			to = west_arr[0];
		}
		
		BulletTracer( from.origin, to.origin, true);
		if(cointoss())
		{
			wait(.1);
			BulletTracer( from.origin, to.origin, true);
			wait(.1);
			BulletTracer( from.origin, to.origin, true);
		}
		wait(randomfloatrange(0.05, .3));
	}	
}

ignore_all_wrapper(endon_flag)
{
	self endon( "death" );
	self.ignoreall = true;
	if( isDefined( endon_flag ) )
	{
		flag_wait( endon_flag );
		self.ignoreall = false;
	}
}

ignore_none_wrapper()
{
	self.ignoreall = false;
}

berlin_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	assert( isdefined( level.flare_fx[ vehicle.vehicletype ] ) );
	assert( isdefined( level.flare_tag[ vehicle.vehicletype ] ) );
	
	assert( fxCount >= flareCount );
	
	everyOther = true;
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx( level.flare_fx[ vehicle.vehicletype ], vehicle getTagOrigin( level.flare_tag[ vehicle.vehicletype ] ) );

		if ( isdefined( vehicle.playercontrolled ) )
		{
			level.stats[ "flares_used" ]++ ;
			vehicle notify( "dropping_flares" );
			if ( everyOther )
				vehicle playSound( "cobra_flare_fire" );
			everyOther = !everyOther;
		}
		
		wait 0.1;
	}
}

berlin_flares_fire( vehicle )
{
	vehicle endon( "death" );
	
	flareTime = 5.0;
	if ( isdefined( vehicle.flare_duration ) )
		flareTime = vehicle.flare_duration;
	
	berlin_flares_fire_burst( vehicle, 8, 1, flareTime );
}

uphill_run()
{
	was_cqb = false;
	while( 1 )
	{
		guy = trigger_wait_targetname( "start_ramp_run" );
		
		if( guy == self )
		{
			break;
		}
	}

	if ( isdefined( self.cqbwalking ) && self.cqbwalking )
	{
			self disable_cqbwalk();
			was_cqb = true;
	}
	if( cointoss() )
		self set_run_anim( "combatcombat_run_fast_rampup_short" );
	else
		self set_run_anim( "combatcombat_run_fast_rampup_short_alt" );
	
	while( 1 )
	{
		guy = trigger_wait_targetname( "end_ramp_run" );
		
		if( guy == self )
		{
			break;
		}
	}
	if(was_cqb == true)
	{
		self enable_cqbwalk();
	}
	self clear_run_anim();
}

AmbientMuzzleFlash(location_targetname, end_message)
{
	level endon(end_message);
	
	structArr = GetStructArray(location_targetname, "targetname");
	end_loc_arr = GetStructArray("tracer_end_loc", "targetname");
	assert(structArr.size > 2);
	shoot_fx = getfx( "m16_muzzleflash" );	
	while(1)
	{
		structArr = array_randomize(structArr);
		loc = structArr[0];
		
		end_loc_arr = array_randomize(end_loc_arr);
		end_loc = end_loc_arr[0];
		
		level.player PlayFX( shoot_fx, loc.origin);
		bullettracer( loc.origin, end_loc.origin, true );
		if(cointoss()) //simulate three round burst
		{
			wait(.1);
			bullettracer( loc.origin, end_loc.origin, true );
			wait(.1);
			bullettracer( loc.origin, end_loc.origin, true );
		}
		wait(randomfloatrange(0.05, 0.2));
	}
}

delete_enemies_in_volume()
{
	self waittill( "trigger" );
	
	volume = GetEnt( self.target, "targetname" );
	enemies = GetAIArray( "axis" );
	count = 0;
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			count ++;
		}
	}
	
	if ( count > 3 )
	{
		return;
	}
	
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) && ( Distance2D( e.origin, level.player.origin ) > 128 ) && ( !player_can_see_ai( e ) ) )
		{
			e notify( "killanimscript" );
			e Delete();
		}
	}
	
	self Delete();
}

/*add_override_shadow_loc_in_special_scope(struct_targetname)
{
	shadow_override = GetStruct( struct_targetname, "targetname" );
	assert(isdefined(shadow_override));
	if(!isdefined(level.variable_scope_shadow_center))
		level.variable_scope_shadow_center = [];
	level.variable_scope_shadow_center[level.variable_scope_shadow_center.size] = shadow_override.origin;
}
*/
turn_off_shadow_override()
{
	level.variable_scope_shadow_center = undefined;
}


introscreen_generic_fade_out( shader, pause_time, fade_in_time, fade_out_time )
{
	if ( !isdefined( fade_in_time ) )
		fade_in_time = 1.5;

	introblack = NewHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack SetShader( shader, 640, 480 );

	if ( IsDefined( fade_out_time ) && fade_out_time > 0 )
	{
		introblack.alpha = 0;
		introblack FadeOverTime( fade_out_time );
		introblack.alpha = 1;
		wait( fade_out_time );
	}

	wait pause_time;

	introblack destroy();
}

twenty_minutes_earlier_feed_lines( lines, interval )
{
	keys = GetArrayKeys( lines );

	for ( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];
		time = ( i * interval ) + 1;
		delayThread( time, ::CenterLineThread, lines[ key ], ( lines.size - i - 1 ), interval, key );
	}
}

CenterLineThread( string, size, interval, index_key )
{
	level notify( "new_introscreen_element" );

	if ( !isdefined( level.intro_offset ) )
		level.intro_offset = 0;
	else
		level.intro_offset++;

	hudelem = NewHudElem();
	hudelem.x = 0;
	hudelem.y = 0;
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.horzAlign = "center";
	hudelem.vertAlign = "middle_adjustable";
	hudelem.sort = 1;// force to draw after the background
	hudelem.foreground = true;
	hudelem SetText( string );
	hudelem.alpha = 0;
	hudelem FadeOverTime( 0.2 );
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 2.4;// was 1.6 and 2.4, larger font change
	hudelem.color = ( 0.8, 1.0, 0.8 );
	hudelem.font = "objective";
	hudelem.glowColor = ( 0.3, 0.6, 0.3 );
	hudelem.glowAlpha = 1;
	duration = Int( ( interval * 1000 ) + 4000 );
	hudelem SetPulseFX( 30, duration, 700 );// something, decay start, decay duration

	thread maps\_introscreen::hudelem_destroy( hudelem );

	if ( !isdefined( index_key ) )
		return;
	if ( !isstring( index_key ) )
		return;
	if ( index_key != "date" )
		return;
}

//roof guy needs to spawn, get to his spot and wait for the trigger for det!

guyOutWindow(noteworthy, flag_detonate, destroy_on_notify)
{
	level endon (destroy_on_notify);
	spawner = GetEnt( noteworthy, "script_noteworthy" );
	guy = spawner spawn_ai();
	if(isdefined(guy))
	{
		guy endon ("death");
		waittillframeend;
		guy.goalradius = 8;
		guy waittill("goal");
		guy.goalradius = 8;
		level flag_wait(flag_detonate);
		guy thread blowOutWindow();
	}
}

blowOutWindow()
{
	explosion_target = GetStruct( self.script_noteworthy, "script_noteworthy" );
	//place the grenade so he will get blown towards it
	forward_vec = VectorNormalize(explosion_target.origin - self.origin);
	
	//behind_vec = (-1,-1,-1) * anglesToForward(guy.angles);
	behind_vec = (-1,-1,0) * forward_vec;
	
	old_val = getDVar("scr_expDeathMayMoveCheck", "on");
	setDVar("scr_expDeathMayMoveCheck", "off");
	MagicGrenadeManual("fraggrenade", self.origin + 24 * behind_vec + (0,0,12), (0,0,0), 0.05);
	self waittill("death");
	wait( .5 );
	setDVar("scr_expDeathMayMoveCheck", old_val);
}

berlin_tank_badplace()
{
	self endon( "death" );
	self endon( "kill_badplace_forever" );
		hasturret = IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ];
	bp_duration = 0.5;
	bp_angle_left = 17;
	bp_angle_right = 17;
	CONST_bp_height = 300;
	for ( ;; )
	{
		if ( !self.script_badplace )
		{
			while ( !self.script_badplace )
				wait 0.5;
		}
		speed = self Vehicle_GetSpeed();
		
		bAlliesStandNearMe = false;
		if ( speed <= 1 )
		{
			bp_radius = 150;
			bAlliesStandNearMe = true;
		}
		else if ( speed < 5 )
			bp_radius = 200;
		else if ( ( speed > 5 ) && ( speed < 8 ) )
			bp_radius = 350;
		else
			bp_radius = 500;

		if ( IsDefined( self.BadPlaceModifier ) )
			bp_radius = ( bp_radius * self.BadPlaceModifier );

		if ( hasturret )
			bp_direction = AnglesToForward( self GetTagAngles( "tag_turret" ) );
		else
			bp_direction = AnglesToForward( self.angles );

		BadPlace_Arc( self.unique_id + "arc", bp_duration, self.origin, bp_radius * 1.9, CONST_bp_height, bp_direction, bp_angle_left, bp_angle_right, "axis", "team3", "allies" );
		if(bAlliesStandNearMe)
		{
			BadPlace_Cylinder( self.unique_id + "cyl", bp_duration, self.origin, 200, CONST_bp_height, "axis", "team3" );
		}
		else
		{
			// have to use unique names for each bad place. if not they will be shared for all vehicles and thats not good. - R
			BadPlace_Cylinder( self.unique_id + "cyl", bp_duration, self.origin, 200, CONST_bp_height, "axis", "team3", "allies" );
		}
		
		wait bp_duration + 0.05;
	}
}

guy_grenade_death()
{
	forward_vec = AnglesToForward(self.angles);
	
	behind_vec = (-1,-1,0) * forward_vec;
	
	old_val = getDVar("scr_expDeathMayMoveCheck", "on");
	setDVar("scr_expDeathMayMoveCheck", "off");
	MagicGrenadeManual("fraggrenade", self.origin + 24 * behind_vec + (0,0,12), (0,0,0), 0.05);
	self waittill("death");
	wait( .5 );
	setDVar("scr_expDeathMayMoveCheck", old_val);
}

spin_chopper_blades()
{
	level endon("stop_chopper_blade");
	blades = GetEntArray( "rotating_heli_blade", "targetname" );
	count = 0;
	foreach(b in blades)
	{
		b childthread handle_spin_forever(count+2);
		count++;
	}
}

handle_spin_forever(speed)
{
	while(1)
	{
		self AddPitch(speed);
		wait(0.05);
	}	
}

fail_mission_on_death( notify_endon )
{
	level endon(notify_endon);
	self waittill("death");
	if(isdefined(self))
	{
		SetDvar( "ui_deadquote", &"BERLIN_ALLY_TANKS_FAIL" );
		missionFailedWrapper();
	}
}

//stolen from paris_ac130
set_neverEnableCQB( value )
{
	self.neverEnableCQB = value;
}

turret_target_on_flag(target_ent_targetname, flag_wait_for)
{
	self endon("death");
	flag_wait(flag_wait_for);
	target = GetEnt( target_ent_targetname, "targetname" );
	self setturrettargetent( target );
}

/#
show_tank_target(tank)
{
	self endon("death");
	tank endon("new_target");
	tank endon("stop_random_tank_fire");
	while(1){
		print3d(self.origin + (0,0,64), "Target");
		wait(.05);
	}
}

draw_tank_target_line( ent1, ent2, color )
{
	self endon("death");
	self endon("new_target");
	self endon("stop_random_tank_fire");
	entalive = true;
	while (entalive)
	{
		if(isdefined(ent1) && isdefined(ent2))
		{
			line( ent1.origin+(0,0,100), ent2.origin+(0,0,40), color );
		}
		else
		{
			entalive = false;
		}
		wait 0.05;
	}
}
#/
