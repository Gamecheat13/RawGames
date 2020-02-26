#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;

#define SCREECHER_JUMP_DIST	(240*240)

init()
{
//	level._effect["sonic_spawn"] = LoadFX( "maps/zombie_temple/fx_ztem_sonic_zombie_spawn" );

	precacheShader( "fullscreen_claw_left" );
	precacheShader( "fullscreen_claw_right" );
	precacheShader( "fullscreen_claw_bottom" );

	precacheModel( "fx_axis_createfx" );

	level._effect["screecher_spawn_a"] = LoadFX( "maps/zombie/fx_zmb_screech_hand_dirt_burst" );
	level._effect["screecher_spawn_b"] = LoadFX( "maps/zombie/fx_zmb_screech_body_dirt_billowing" );
	level._effect["screecher_spawn_c"] = LoadFX( "maps/zombie/fx_zmb_screech_body_dirt_falling" );

/*
	fx/maps/zombie/fx_zmb_screech_hand_dirt_burst			//- Effects as they initially burst out of dirt.
	fx/maps/zombie/fx_zmb_screech_body_dirt_billowing		//– Effects as they are climbing out.
	fx/maps/zombie/fx_zmb_screech_body_dirt_falling			//– Effects that fall from them as they initially start walking towards player. 
*/

	level.screecher_spawners = GetEntArray( "screecher_zombie_spawner", "script_noteworthy" );
	array_thread( level.screecher_spawners, ::add_spawn_function, maps\mp\zombies\_zm_ai_screecher::screecher_prespawn );
	//array_thread( level.screecher_spawners, ::add_spawn_function, maps\mp\zombies\_zm_spawner::zombie_spawn_init);

	level.zombie_ai_limit_screecher = 2;
	//level.zombie_ai_limit_screecher = 1;
	//level.zombie_screecher_total = 0;

	level thread screecher_spawning_logic();

	/#
	level thread screecher_debug();
	#/
}

/#
screecher_debug()
{
	//level.screecher_debug = true;
	//level.screecher_nofx = true;
}
#/

get_screecher_enemy_count()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );

	for( i = 0; i < enemies.size; i++ )
	{
		if ( !is_true( enemies[i].isscreecher ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			ARRAY_ADD( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies.size;
}

screecher_spawning_logic()
{
	level endon( "intermission" );
	if( level.intermission )
	{
		return;
	}

/#
	if ( GetDvarInt( "zombie_cheat" ) == 2 || GetDvarInt( "zombie_cheat" ) >= 4 ) 
	{
		return;
	}
#/

	if( level.screecher_spawners.size < 1 )
	{
		ASSERTMSG( "No active spawners in the map.  Check to see if the zone is active and if it's pointing to spawners." ); 
		return; 
	}

	//level.zombie_screecher_total = level.zombie_ai_limit_screecher;

	while( 1 )
	{	
		//Wait till we have valid rise locations
		while( !IsDefined( level.zombie_screecher_locations ) || (level.zombie_screecher_locations.size<=0) )
		{
			wait( 0.1 );
		}
		
		while( get_screecher_enemy_count() >= level.zombie_ai_limit_screecher )// || level.zombie_screecher_total <= 0 )
		{
			wait( 0.1 );
		}

		while( GetDVarInt( "scr_screecher_ignore_player" ) )
		{
			wait( 0.1 );
		}
		
		// added ability to pause zombie spawning
		if ( !flag("spawn_zombies" ) )
		{
			flag_wait( "spawn_zombies" );
		}
		
		if( !IsDefined( level.zombie_screecher_locations ) || (level.zombie_screecher_locations.size<=0) )
		{
			continue;
		}

		spawn_point = level.zombie_screecher_locations[RandomInt( level.zombie_screecher_locations.size )]; 

		//Check to see if any players are actually in the screecher spawning zone
		valid_players_in_screecher_zone = 0;
		while( valid_players_in_screecher_zone<=0 )
		{
			players = GetPlayers();
			valid_players_in_screecher_zone = 0;
			for( p = 0; p < players.size; p++ )
			{
				if ( is_player_valid( players[p] ) && player_in_screecher_zone(players[p]) && !isdefined( players[p].screecher ) )
				{
					valid_players_in_screecher_zone++;
				}
			}
			wait( 0.1 );
		}

		if(IsDefined(level.screecher_spawners))
		{
			spawner = random(level.screecher_spawners);		
			ai = spawn_zombie( spawner,spawner.targetname,spawn_point); 
 		}		
		 
		if( IsDefined( ai ) )
		{
			//level.zombie_screecher_total--;
		//	ai thread maps\mp\zombies\_zm::round_spawn_failsafe();
			//count++; 
		}

		wait( level.zombie_vars["zombie_spawn_delay"] ); 
		wait_network_frame();
	}
}



player_in_screecher_zone( player )
{
	if ( IsDefined( level.is_player_in_screecher_zone ) )
	{
		return [[ level.is_player_in_screecher_zone ]]( player );
	}

	return true;
}

screecher_get_closest_valid_player( origin, ignore_player )
{
	valid_player_found = false; 
	
	players = GET_PLAYERS();	

	if( is_true( level._zombie_using_humangun ) )
	{
		players = ArrayCombine( players, level._zombie_human_array, false, false );
	}
	

	if( IsDefined( ignore_player ) )
	{
		//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
		for(i = 0; i < ignore_player.size; i++ )
		{
			ArrayRemoveValue( players, ignore_player[i] );
		}
		//PI_CHANGE_END
	}

	while( !valid_player_found )
	{
		// find the closest player
		if( is_true(level.calc_closest_player_using_paths) )
		{
			player = get_closest_player_using_paths( origin, players );
		}
		else
		{
			player = GetClosest( origin, players );
		} 

		if( !isdefined( player ) )
		{
			return undefined; 
		}
		
		if( is_true( level._zombie_using_humangun ) && IsAI( player ) )
		{
			return player;
		}

		screecher_claimed = isdefined( player.screecher ) && player.screecher != self;
		
		// make sure they're not a zombie or in last stand
		if( !is_player_valid( player, true ) || !player_in_screecher_zone(player) || screecher_claimed )
		{
			ArrayRemoveValue( players, player ); 
			continue; 
		}
		return player; 
	}
}


zombie_pathing_home()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	level endon( "intermission" );

	//send ai to a point
	self SetGoalPos( self.startinglocation );
	self waittill_any( "goal", "bad_path", "death" );

	self PlaySound( "zmb_vocals_sonic_scream" );
	PlayFX( level._effect["screecher_spawn_b"], self.origin, (0,0,1) );
	
	// don't drop powerups when cleaning up zombies
	self.no_powerups = true;

	// add a zombie back into the mix
	//level.zombie_screecher_total++;

	//self dodamage(self.health + 666, self.origin);
	self Delete();
}


// the seeker logic for zombies
screecher_find_flesh()
{
	self endon( "death" ); 
	level endon( "intermission" );
	self endon( "stop_find_flesh" );

	if( level.intermission )
	{
		return;
	}
	
	self.helitarget = true;
	self.ignoreme = false; // don't let attack dogs give chase until the zombie is in the playable area
	self.noDodgeMove = true; // WW (0107/2011) - script_forcegoal KVP overwites this variable which allows zombies to push the player in laststand

	//PI_CHANGE - 7/2/2009 JV Changing this to an array for the meantime until we get a more substantial fix 
	//for ignoring multiple players - Reenabling change 274916 (from DLC3)
	self.ignore_player = [];

	self zombie_history( "find flesh -> start" );
	//wait( 0.1 );

	self.goalradius = 32;
	while( 1 )
	{
		//zombie_poi = self get_zombie_point_of_interest( self.origin );	
		self.favoriteenemy = screecher_get_closest_valid_player( self.origin );
		if( isdefined( self.favoriteenemy ) && self.state != "runaway" )
		{
			self thread zombie_pathing();
		}
		else
		{
			self thread zombie_pathing_home();
		}
		self.zombie_path_timer = GetTime() + ( RandomFloatRange( 1, 3 ) * 1000 );// + path_timer_extension;
		while( GetTime() < self.zombie_path_timer ) 
		{
			wait( 0.1 );
		}
		self notify( "path_timer_done" );

		self zombie_history( "find flesh -> bottom of loop" );

		debug_print( "Zombie is re-acquiring enemy, ending breadcrumb search" );
		self notify( "zombie_acquire_enemy" );
	}
}

screecher_prespawn()
{
	self endon( "death" ); 
	level endon( "intermission" );
	//self endon( "stop_find_flesh" );

	//Setup screecher specific stuff here...
	//aitype is "zm_zombie_transit_screecher"
	self.startinglocation = self.origin;
	self.animname = "screecher_zombie";
	self.audio_type = "screecher";
	self.has_legs = true;
	self.no_gib = 1;
	self.isscreecher = true;
	self.ignore_enemy_count = true;				//does not get taken into account for round progression
	self.cant_melee = true;


	if( IsDefined( level.zombie_screecher_locations ) && level.zombie_screecher_locations.size > 0 )
	{
		spots = level.zombie_screecher_locations;
		spot = random(spots);
		if( !isdefined(spot.angles) )
		{
			spot.angles = ( 0.0, 0.0, 0.0 );
		}
		self forceteleport(spot.origin, spot.angles);	// we should get this working for MP
	}

	self set_zombie_run_cycle( "super_sprint" );

	// jump over screechers
	self setPhysParams( 15, 0, 24 );
	

	self.zombie_init_done = true;
	self notify( "zombie_init_done" );

	self AnimMode( "normal" );
	self OrientMode( "face enemy" );
	self.forceMovementScriptState = false;

	self maps\mp\zombies\_zm_spawner::zombie_setup_attack_properties();
	self maps\mp\zombies\_zm_spawner::zombie_complete_emerging_into_playable_area();
	self.startinglocation = self.origin;

	self PlaySound( "zmb_vocals_screecher_spawn" );
	self thread play_screecher_fx();

	self thread play_screecher_breathing_audio();
	self thread screecher_rise();
	self thread screecher_cleanup();

	self.anchor = Spawn( "script_origin", self.origin );

	self.attack_time = 0;
	self.attack_delay = 1000;
	self.attack_delay_base = 1000;
	self.attack_delay_offset = 500;

	self.meleeDamage = 5;

	self.ignore_nuke = true;
	self.ignore_inert = true;
}

play_screecher_fx()
{
	/#
	if ( is_true( level.screecher_nofx ) )
	{
		return;
	}
	#/

	PlayFX( level._effect["screecher_spawn_a"], self.origin, (0,0,1) );
	PlayFX( level._effect["screecher_spawn_b"], self.origin, (0,0,1) );
	self waittill("risen");
	PlayFX( level._effect["screecher_spawn_c"], self.origin, (0,0,1) );
}

play_screecher_breathing_audio()
{
	self playloopsound( "zmb_vocals_screecher_breath" );
	
	while( 1 )
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			if( !isdefined( self ) )
				return;
			
			if( distance( self.origin, players[i].origin ) <= 200 )
			{
				self playsound( "zmb_vocals_screecher_jump" );
				return;
			}
		}
		wait(.1);
	}
}

//-------------------------------------------------------------------
// rise out of the ground before tracking player
//-------------------------------------------------------------------
screecher_rise()
{
	self endon( "death" );

	/#
	screecher_print( "rise" );
	#/

	self AnimScripted( self.origin, self.angles, "zm_rise" );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "rise_anim" );

	self notify( "risen" );

	self thread screecher_zombie_think();

	/#
	//self thread screecher_debug_axis();
	#/
}

//-------------------------------------------------------------------
// main update loop
//-------------------------------------------------------------------
screecher_zombie_think()
{
	self endon( "death" );

	min_dist = 96;
	max_dist = 144;
	height_tolerance = 32;
	
	self.state = "chase_init";
	self.isAttacking = false;
	self.nextSpecial = GetTime();

	for (;;)
	{
		switch( self.state )
		{
		case "chase_init":
			self screecher_chase();
			break;

		case "chase_update":
			self screecher_chase_update();
			break;

		case "attacking":
			self screecher_attacking();
			break;

		}
		wait_network_frame();
	}
}

screecher_chase()
{
	/#
	screecher_print( "chase_init" );
	#/

	self thread screecher_find_flesh();

	self.state = "chase_update";
}

//-------------------------------------------------------------------
// get close enough to attack
//-------------------------------------------------------------------
screecher_chase_update()
{
	if ( isdefined( self.favoriteenemy ) )
	{
		dist = Distance2DSquared( self.origin, self.favoriteenemy.origin );
		if ( dist < SCREECHER_JUMP_DIST )
		{
			self screecher_attack();
		}
	}
}

//-------------------------------------------------------------------
// jump up and grab the player's head
//-------------------------------------------------------------------
screecher_attack()
{
	self endon( "death" );

	/#
		screecher_print( "attack" );
	#/

	player = self.favoriteenemy;

	if ( isdefined( player.screecher ) )
	{
		return;
	}
	else
	{
		player.screecher = self;
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	self animmode( "nogravity" );

	// jump
	self SetAnimStateFromASD( "zm_jump_up" );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "jump_up_anim" );

	// fly toward player
	self SetAnimStateFromASD( "zm_jump_loop" );

	self.anchor.angles = self.angles;
	self linkto( self.anchor );

	anim_id_back = self GetAnimFromASD( "zm_jump_land_success_fromback", 0 );
	anim_id_front = self GetAnimFromASD( "zm_jump_land_success_fromfront", 0 );

	goal_pos_back = GetStartOrigin( player.origin, player.angles, anim_id_back );
	goal_pos_front = GetStartOrigin( player.origin, player.angles, anim_id_front );

	dist_back = Distance2DSquared( self.origin, goal_pos_back );
	dist_front = Distance2DSquared( self.origin, goal_pos_front );

	goal_pos = goal_pos_back;
	goal_ang = GetStartAngles( player.origin, player.angles, anim_id_back );
	asd_state = "zm_jump_land_success_fromback";

	if ( dist_front < dist_back )
	{
		goal_pos = goal_pos_front;
		goal_ang = GetStartAngles( player.origin, player.angles, anim_id_front );
		asd_state = "zm_jump_land_success_fromfront";
	}

	goal_time = 0.12;

	self.anchor MoveTo( goal_pos, goal_time );
	self.anchor waittill( "movedone" );

	self SetPlayerCollision( 0 );

	self linkto( self.favoriteenemy, "tag_origin" );

	// land on player's head
	self AnimScripted( self.favoriteenemy.origin, self.favoriteenemy.angles, asd_state );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "jump_land_success_anim" );

	org = self.favoriteenemy gettagorigin( "j_head" );
	angles = self.favoriteenemy gettagangles( "j_head" );
	self ForceTeleport( org, angles );

	self linkto( self.favoriteenemy, "j_head" );

	// attack loop
	self AnimScripted( self.origin, self.angles, "zm_headpull" );

	self.linked_ent = self.favoriteenemy;
	self.linked_ent SetMoveSpeedScale( 0.5 );

	self screecher_start_attack();
}

screecher_start_attack()
{

	player = self.favoriteenemy;
	if ( is_player_valid( player ) )
	{
		self.state = "attacking";
		self.attack_time = GetTime();

		player.screecher_weapon = player GetCurrentWeapon();
		player GiveWeapon( "screecher_arms_zm" );
		player SwitchToWeapon( "screecher_arms_zm" );
		player increment_is_drinking();
	}
	else
	{
		self screecher_runaway( player );
	}
}

//-------------------------------------------------------------------
// check for safe zone, do some damage over time
//-------------------------------------------------------------------
screecher_attacking()
{
	player = self.favoriteenemy;

	if ( !isdefined( player ) || !player_in_screecher_zone( player ) )
	{
		self screecher_runaway( player );
	}

	if ( self.attack_time < GetTime() )
	{
		//player DoDamage( 5, self.origin, self );
		self.attack_delay = self.attack_delay_base + RandomInt( self.attack_delay_offset );
		self.attack_time = GetTime() + self.attack_delay;

		self thread claw_fx( player, self.attack_delay * .001 );
		self playsound ("zmb_vocals_screecher_attack");
	}
}

//-------------------------------------------------------------------
// player is safe, go back to spawn point
//-------------------------------------------------------------------
screecher_runaway( player )
{
	self endon( "death" );

	/#
		screecher_print( "runaway" );
	#/

	self.state = "runaway";

	if ( isdefined( player ) )
	{
		player TakeWeapon( "screecher_arms_zm" );

		if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !is_true( player.intermission ) )
		{
			player decrement_is_drinking();
		}

		if ( player.screecher_weapon != "none" && is_player_valid( player ) )
		{
			player SwitchToWeapon( player.screecher_weapon );
		}
		else
		{
			primaryWeapons = player GetWeaponsListPrimaries();
			if ( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
			{
				player SwitchToWeapon( primaryWeapons[0] );
			}
		}
		player.screecher_weapon = undefined;
	}

	if ( isdefined( level.screecher_should_burrow ) )
	{
		if ( self [[ level.screecher_should_burrow ]]( player ) )
		{
			self.burrow = true;
		}
	}

	self SetGoalPos( self.origin );

	self Solid();
	self animmode( "normal" );

	// detach from head
	self unlink();

	if ( isdefined( self.linked_ent ) )
	{
		self.linked_ent.screecher = undefined;
		self.linked_ent SetMoveSpeedScale( 1 );
		self.linked_ent = undefined;
	}

	self animcustom( ::screecher_jump_down );
}

screecher_jump_down()
{
	self endon( "death" );

	self SetAnimStateFromASD( "zm_headpull_success" );
	maps\mp\animscripts\zm_shared::DoNoteTracks( "headpull_success_anim" );

	if ( is_true( self.burrow ) )
	{
		//iprintln( "should burrow" );
		self SetGoalPos( self.origin );
		wait( 1 );
		self Delete();
		return;
	}

	self thread screecher_find_flesh();
}

//-------------------------------------------------------------------
// create hud for fx
//-------------------------------------------------------------------
create_claw_fx_hud( player )
{
	self.claw_fx = NewClientHudelem( player );
	self.claw_fx.horzAlign = "fullscreen";
	self.claw_fx.vertAlign = "fullscreen";
}

choose_claw_fx()
{
	direction = [];
	direction[ direction.size ] = "fullscreen_claw_left";
	direction[ direction.size ] = "fullscreen_claw_right";
	direction[ direction.size ] = "fullscreen_claw_bottom";
	direction = array_randomize( direction );

	self.claw_fx SetShader( direction[0], 640, 480 );
	self.claw_fx.alpha = 1;
}

//-------------------------------------------------------------------
// play fx and camera shake
//-------------------------------------------------------------------
claw_fx( player, timeout )
{
	self endon( "death" );

	claw_timeout = 0.25;

	if ( !isdefined( self.claw_fx ) )
	{
		self create_claw_fx_hud( player );
	}

	self choose_claw_fx();

	self.claw_fx FadeOverTime( claw_timeout );
	self.claw_fx.alpha = 0;

	Earthquake( RandomFloatRange( 0.4, 0.5 ), claw_timeout, player.origin, 250 );
	player SetBlur( 4, 0.1 );
	player thread claw_remove_blur( claw_timeout );
}

claw_remove_blur( timeout )
{
	self endon( "death" );

	wait( timeout );
	self SetBlur( 0, timeout );
}

//-------------------------------------------------------------------
// remove any spawned ents
//-------------------------------------------------------------------
screecher_cleanup()
{
	self waittill( "death" );

	/#
	screecher_print( "cleanup" );
	#/

	player = self.linked_ent;
	
	if ( isdefined( player ) )
	{
		player playsound ("zmb_vocals_screecher_death");
		player SetMoveSpeedScale( 1 );
		player SetBlur( 0, 0.1 );

		if ( isdefined( player.screecher_weapon ) )
		{
			player TakeWeapon( "screecher_arms_zm" );

			if ( !player maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !is_true( player.intermission ) )
			{
				player decrement_is_drinking();
			}

			if ( player.screecher_weapon != "none" && is_player_valid( player ) )
			{
				player SwitchToWeapon( player.screecher_weapon );
			}
			else
			{
				primaryWeapons = player GetWeaponsListPrimaries();
				if ( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
				{
					player SwitchToWeapon( primaryWeapons[0] );
				}
			}
			player.screecher_weapon = undefined;
		}
	}

	if ( isdefined( self.claw_fx ) )
	{
		self.claw_fx Destroy();
	}

	self.anchor delete();
}

/#
screecher_debug_axis()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( isdefined( self.favoriteenemy ) )
		{
			player = self.favoriteenemy;

			anim_id = self GetAnimFromASD( "zm_jump_land_success", 0 );
			org = getstartorigin( player.origin, player.angles, anim_id );
			angles = getstartangles( player.origin, player.angles, anim_id );

			//org = player.origin;
			//angles = player.angles;

			if ( !isdefined( player.bone_fxaxis ) )
			{
				player.bone_fxaxis = spawn( "script_model", org );
				player.bone_fxaxis SetModel( "fx_axis_createfx" );
				//recordEnt( player.bone_fxaxis );
			}

			if ( isdefined( player.bone_fxaxis ) )
			{
				player.bone_fxaxis.origin = org;
				player.bone_fxaxis.angles = angles;
			}
		}

		wait_network_frame();
	}
}
#/

/#
screecher_print( str )
{
	if ( is_true( level.screecher_debug ) )
	{
		iprintln( "screecher: " + str );
		if ( isdefined( self.debug_msg ) )
		{
			self.debug_msg[ self.debug_msg.size ] = str;
		}
		else
		{
			self.debug_msg = [];
			self.debug_msg[ self.debug_msg.size ] = str;
		}
	}
}
#/
