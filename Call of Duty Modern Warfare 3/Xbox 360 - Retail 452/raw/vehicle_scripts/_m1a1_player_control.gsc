#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_helicopter_globals;
#include maps\hamburg_tank_ai;

FOV_ON_MINIGUN = 55;
ORIGIN_ZERO = ( 0, 0, 0 );

init_tankcommander_code( tank )
{
	if( !isdefined( tank.inited ) )
	{
		create_lock( "troop_targeting_tank" );
		create_lock( "rpg_troop_targeting_tank" );
		tank.inited = true;
	}
	if ( IsDefined( level.on_tank_protect_player_func ) )
		level.destructible_protection_func = level.on_tank_protect_player_func;
	thread Init_player_tank( tank );
}

is_lock_created( msg  )
{
	Assert( IsDefined( msg ) );
	
	if ( !IsDefined( level.lock ) )
		return false;
		
	return IsDefined( level.lock[ msg ] );
}

init_player_tank( tank )
{
	level.player DisableWeapons();
	level.player AllowCrouch( true );
	level.player AllowProne( false );
	level.player AllowStand( true );
	level.player AllowSprint( false );
	level.player AllowJump( false );
	
	tank.turret_30cal = tank.mgturret[ 0 ];
	tank.turret_30cal.damageIsFromPlayer = true;
	tank.damageIsFromPlayer = true;
    tank tank_turret_mini();
	tank tank_minigun_player_link();
	tank tank_spawn_crew();
	tank tank_player_refresh_link();
	level.player SetPlayerAngles( tank GetTagAngles( "tag_playerride" ) );
	tank thread tank_rumble();
	tank minigun_mount();
}

tank_link_inside_spotlight_on()
{
	PlayFXOnTag( getfx( "inside_tank_light" ),  self.fake_internal_spotlight, "tag_origin" );
}

tank_link_inside_spotlight_off()
{
	StopFXOnTag( getfx( "inside_tank_light" ),  self.fake_internal_spotlight, "tag_origin" );
}

tank_refresh_stuff_link()
{
	tank_minigun_linkto();
}

tank_player_refresh_link()
{
	tank_refresh_stuff_link();
	tank_minigun_player_link();
		
}

tank_dead_kill_player()
{
	self waittill ( "death" );
	level.player endon( "death" );
	level.player DisableInvulnerability();
	level.player DoDamage( level.player.health + 200, level.player.origin );
}


tank_spawn_crew()
{
	if( isdefined( self.drones_crew ) )
		return;
	
    self.drones_crew = [];
    
    self.drones_crew[ 0 ] = spawn_targetname( "tank_crew_2", true );
    self.drones_crew[ 1 ] = spawn_targetname( "tank_crew_1", true );
    
    foreach( crew_member in self.drones_crew )
    	crew_member.dontdeleteme = true;
    	
	tank_link_crew();
}

tank_link_crew()
{
    foreach ( drone in self.drones_crew )
    {
    	if( isdefined( drone.ridingvehicle ) )
    		continue;
    	drone.team = self.script_team;
		drone.voice = "american";
		drone.health = 10000;
    	//drone thread maps\_drone::drone_give_soul();
    	drone SetCanDamage( false );
	    self thread guy_enter_vehicle( drone );
    	
    }
}

tank_aim_arrow_invalid()
{
	if ( !self.aim_arrow_valid )
		return;
	self.aim_arrow_valid = false;
}

tank_aim_arrow_valid()
{
	if ( self.aim_arrow_valid )
		return;
	self.aim_arrow_valid = true;
}

trace_to_forward( forward_dist )
{
	if ( !IsDefined( forward_dist ) )
		forward_dist = 50000;
	pos = level.player GetEye();
	angles = level.player GetPlayerAngles();
	forward = AnglesToForward( angles );
	pos = pos + ( forward * 250 );
	target_pos = pos + ( forward * forward_dist );
	return BulletTrace( pos, target_pos, true, self );
}

is_point_touching_volumes( volumes, point )
{
	ent = spawn_tag_origin();
	ent.origin = point;
	touching = false;
	foreach( volume in volumes )
	{
		if ( ent IsTouching( volume ) )
		{
			touching = true;
			break;
		}
	}
	ent Delete();
	return touching;
}


troops_near_position( position )
{
	ai = GetAIArray( "axis" );
	foreach ( ai in ai )
	{
		if ( DistanceSquared( ai.origin, position ) < 1000000 ) // 1000
			return true;
	}
	return false;
}

tank_rumble()
{
	self endon ( "tank_unmount_player" );

	min_rumble = 0.08;
	max_rumble = 0.15;
	diff_rumble = max_rumble - min_rumble;
	max_speed = 1 / 50;
	self endon ( "death" );
	while ( true )
	{
		percent = self.veh_speed * max_speed;
		rumble = min_rumble + ( diff_rumble * percent );
		rumble = clamp( rumble, min_rumble, max_rumble );

		time = RandomFloatRange( 0.15, 0.25 );
		Earthquake( rumble, time, self.origin, 256 );
		wait( time );
	}
}

launch_smoke( destination )
{
	self thread smoke_launcher_sound();
	if ( !IsDefined( destination ) )
		destination = trace_to_forward( 1000 )[ "position" ];
	tags =	[ 
			["tag_canister_left", 1000 ],
			["tag_canister_left", 0 ],
			["tag_canister_right", -1000]
			];
	
	rightvec = VectorToAngles( destination - self GetCentroid() );
	rightvec = vectornormalize ( anglestoright( rightvec ) );
	
	foreach( tag in tags )
		thread launch_smoke_from_tag( tag[ 0 ], destination + ( rightvec * tag[ 1 ] ) );

	return destination;
}

launch_smoke_from_tag( tag, destination )
{
	org = self GetTagOrigin( tag );
	angle = self GetTagAngles( tag );

	PlayFXOnTag( level._effect[ "smoke_start" ], self, tag );

	fake_grenade = Spawn( "script_model", org );
	fake_grenade SetModel( "projectile_m203grenade" );
	fake_grenade.origin = org;
	fake_grenade.angles = VectorToAngles( vectornormalize( destination - org ) );
	
	PlayFXOnTag( level._effect[ "rpg_trail" ], fake_grenade, "tag_origin" );

	fake_grenade move_with_rate( destination, fake_grenade.angles, 12000 );

	StopFXOnTag( level._effect[ "rpg_trail" ], fake_grenade, "tag_origin" );
	
	PlayFX( level._effect[ "smoke_screen_flash" ], destination, AnglesToForward( fake_grenade.angles ) );
//	PlayFX( level._effect[ "smoke_screen" ], destination, AnglesToForward( fake_grenade.angles ) );
	
	if( ent_flag_exist( "fired_smoke_screen" ) )  // friendly tank doesn't need flag
		ent_flag_set( "fired_smoke_screen" );
	fake_grenade Delete();
}

smoke_launcher_sound()
{
	Sdelay = RandomFloatRange( 0.1, 0.2 );
	org1 = self GetTagOrigin( "antenna1_jnt" );
	org2 = self GetTagOrigin( "antenna2_jnt" );
	thread play_sound_in_space( "weap_m203_fire_npc", org1 );
	wait( Sdelay );
	thread play_sound_in_space( "weap_m203_fire_npc", org2 );
}

tank_turret_mini()
{
	if( isdefined( self.turret_mini ) )
	{
		
		self.turret_mini thread maps\_minigun_viewmodel::show_hands( "viewhands_player_delta" ); 
		self.turret_mini thread maps\_minigun_viewmodel::set_idle(); 
		return;
	}
		
	self.turret_mini = SpawnTurret( "misc_turret", self GetTagOrigin( "tag_turret_mg_r" ), "minigun_m1a1_player_tc" );
	self.turret_mini SetModel( "weapon_m1a1_minigun" );	
	self.turret_mini SetBottomArc( 50 );
	self.turret_mini SetTopArc( 20 );
	self.turret_mini SetDefaultDropPitch( 10 );
	
	tank_minigun_linkto();

	self.turret_mini MakeUnusable();
	
	level.player DisableTurretDismount();
	thread maps\_minigun_viewmodel::player_viewhands_minigun( self.turret_mini, "viewhands_player_delta" ); // link mini guns hand to gun
	self.turret_mini maps\_minigun_viewmodel::hide_hands( "viewhands_player_delta" );
}

tank_minigun_linkto()
{
	self.turret_mini.angles = self GetTagAngles( "tag_turret_mg_r" );
	dummy = get_dummy();
	offset = ( 0, 0, 0 );
	self.turret_mini LinkTo ( get_dummy(), "tag_turret_mg_r", ( 0, 0, 0 ), offset );
	self.turret_mini Show();
}

tank_minigun_player_link()
{
	level.player LerpFOV( FOV_ON_MINIGUN, 1.15 );
	
	viewpercent_fraction = 0;
	if( is_dummy() )
		viewpercent_fraction = 0.5;
		
	// Note: The view arc clamps here overwrite the turret view arc clamps
    level.player PlayerLinkToDelta( get_dummy(), "tag_guy0", viewpercent_fraction, 180, 180, 40, 30, false );
}

get_viewmodel_thing()
{
	if ( IsDefined( self.view_model_thing ) )
		return;
	anim_model = spawn_anim_model( "m1a1_player_hands" );
	self.view_model_thing = anim_model;
}

transition_viewmodel_anim( anime, tag, blend_time, from_special_sequence )
{
	if ( !IsDefined( tag ) )
		tag = "tag_guy0";
	if ( !IsDefined( blend_time ) )
		blend_time =  0.2;
		
	dummy = get_dummy();
	
	get_viewmodel_thing();
	
	self.view_model_thing LinkTo( dummy, tag, ORIGIN_ZERO, ORIGIN_ZERO );
	
	if ( !IsDefined( from_special_sequence ) )
		self.view_model_thing Show();
	
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );

	level.player PlayerLinkToBlend( self.view_model_thing, "tag_player", blend_time, 0, 0 );
	
	//delaythread( 0.05, ::set_anim_rate, self.view_model_thing, anime , 1.25 );
	dummy anim_single_solo( self.view_model_thing, anime, tag );
	self.view_model_thing hide();
	
}

set_anim_rate( character, anime, rate )
{
	animation = character getanim( anime );
	character SetFlaggedAnim( "single anim", animation, 1, 0, rate );

}

minigun_mount()
{
	tank_minigun_player_link();
	
	level.player notify ( "noTankHealthOverlay" );
	level.player thread maps\_gameskill::healthOverlay();

	thread minigun_do_player_threat();
	
	AmbientStop();
	
	thread maps\_utility::set_ambient( "tank_gunner" );
	
	self.turret_mini UseBy( level.player );
	level.player DisableTurretDismount();
	
	self thread turret_attack_think_hamburg();
	
}

turret_useby_updating_base()
{
	angles = level.player GetPlayerAngles();
	self turret_update_base();
	self UseBy( level.player );
	level.player SetPlayerAngles( angles );
}

_EnableInvulnerability()
{
	level notify ("stop_protect_player_for_a_bit" );
	self EnableInvulnerability();
}


precache_tank()
{	
	PreCacheTurret( "player_view_controller" ); // this is the turret the player uses
	PreCacheModel( "viewhands_player_delta" ); // these are used with the mini gun
	PreCacheModel( "tag_turret" );
	PreCacheModel( "projectile_m203grenade" ); // used with fake smoke screen
	PreCacheRumble( "hamburg_tank_fire" );
	PreCacheItem( "m1a1_turret_player" );
	
	PreCacheModel( "vehicle_m1a1_abrams_tread_stop" );
	PreCacheModel( "vehicle_m1a1_abrams_viewmodel_tread_stop" );
	
	PreCacheTurret( "minigun_m1a1_player_tc" );
	
	if ( !IsDefined( level._effect ) )
		level._effect = [];
		
	level._effect[ "abrams_exhaust" ]			     = LoadFX( "distortion/abrams_exhaust" );
	level._effect[ "smoke_start" ]			     	 = LoadFX( "muzzleflashes/tiger_flash" );
	level._effect[ "smoke_screen" ]			     	 = LoadFX( "smoke/hamburg_cover_smoke_runner" );
	level._effect[ "smoke_screen_flash" ]			     	 = LoadFX( "smoke/smoke_screen_flash" );
	level._effect[ "abrams_player_damage" ] = LoadFX( "fire/tank_fire_turret_abrams" ); // this plays around the player when the players tank is dieing.  script fudged to orient it.

	player_anims();
	
	maps\_minigun_viewmodel::anim_minigun_hands();
	
	level.scr_model[ "suburban_hands" ] 									= "viewhands_delta";

}


get_rpg_guys()
{
	ai = GetAIArray( "axis" );
	rpg_guys = [];
	foreach ( guy in ai )
	{
		if ( IsSubStr( guy.classname, "RPG" ) )
			rpg_guys[ rpg_guys.size ] = guy;
	}
	return rpg_guys;
}


minigun_do_player_threat()
{
	level notify ( "player_threat_style_update" );
	level endon ( "player_threat_style_update" );
	
	self endon ( "tank_unmount_player" );
	

	while ( true )
	{
		wait 0.15;
		if( self ent_flag( "stunned_tank" ) )
			continue;
		all_rpg_guys = get_rpg_guys();
		non_rpg_guys = array_remove_array( GetAIArray( "axis" ), all_rpg_guys );
		
		guys = [];
		foreach ( guy in non_rpg_guys )
			if ( !IsDefined( guy.targetting_tank_player ) )
				guys[ guys.size ] = guy;
		
		singled_out = get_closest_to_player_view( guys, level.player, true );
		
		if ( !IsDefined( singled_out ) )
			singled_out = getclosest( self.origin, guys );

		if ( !IsDefined( singled_out ) )
			continue;
			
		thread guy_stops_and_fire_at_player( singled_out );
		
		timer = GetTime() + 1750;
		
		while ( IsAlive( singled_out ) && GetTime() < timer  )
			wait 0.05;
	}
}

guy_stops_and_fire_at_player( guy )
{
	guy endon ( "death" );
	guy.targetting_tank_player = true;
	self endon ( "death" );
	while ( true )
	{
		ent_flag_waitopen( "stunned_tank" );
		
		lock( "troop_targeting_tank" );
		tracepassed = SightTracePassed( guy GetEye(), level.player_tank GetCentroid(), false, level.player_tank );
		unlock( "troop_targeting_tank" );
		
		if ( tracepassed )
			break;
		
		wait 0.05;
	}

	guy.baseaccuracy = 1.0;
	guy.accuracy = 1.0;
	//guy set_goal_pos( guy.origin );
	minigun_threat_ent = Spawn( "script_origin", self.origin );

	guy SetEntityTarget( minigun_threat_ent );
	
	movetime = 5;
	threat_offset = ( 0, 0, -70 );

	waittime = 0.05;
	increments = movetime / waittime;
	
	offset_inc = threat_offset * ( 1 / increments );
	offset_inc *= -1;
	guy thread guy_stops_and_fire_at_player_death( minigun_threat_ent );
	
	for ( i = 0; i < increments; i++ )
	{
		ent_flag_waitopen( "stunned_tank" );
		threat_offset += offset_inc;
		
		minigun_threat_ent.origin = level.player GetEye() + threat_offset;
		wait waittime;
	}
	
	childthread guy_shoot_handle( guy, minigun_threat_ent );
	
	while ( true )
	{
		ent_flag_waitopen( "stunned_tank" );
		minigun_threat_ent.origin = level.player GetEye();
		wait waittime;
	}
}

guy_shoot_handle( guy, minigun_threat_ent )
{
	while ( true )
	{
		guy waittill ( "shooting" );
		lock( "troop_targeting_tank" );
		trace = BulletTrace( minigun_threat_ent.origin, guy GetEye(), false, guy );

		if ( RandomInt( 100 ) > 60 )
		{
			if ( trace[ "fraction" ] == 1.0 )
			{
				visibility = GetFXVisibility( minigun_threat_ent.origin, guy GetEye() );
				if ( visibility > 0.8 )
					level.player DoDamage( RandomIntRange( 50, 80 ), guy.origin, guy );
			}
		}
		
		unlock( "troop_targeting_tank" );
		wait 0.05; // not sure why this triggered infinite loop
	}
}


guy_stops_and_fire_at_player_death( minigun_threat_ent )
{
	self waittill ( "death" );
	minigun_threat_ent Delete();
}

turret_update_base()
{
	thread turret_update_base_thread();
}


//this is hack to make player origin move..
turret_update_base_thread()
{
	self notify ( "turret_update_base_thread" );
	self endon ( "turret_update_base_thread" );
	self endon ( "death" );
	while( true )
	{
		h = level.player GetPlayerViewHeight();
		o = level.player GetEye();
		self SetTurretDismountOrg( set_z( o, o[ 2 ] -h ) );
		wait 0.05;
	}
}

tank_unmount_player()
{
	self notify ( "tank_unmount_player" );
	
	if ( IsDefined( self.turret_mini ) )
	{
		level.player EnableTurretDismount();
		self.turret_mini turret_useby_updating_base();
	}
	level.player vision_set_changes( "hamburg", 0.1 );

	if ( IsDefined( self.damageorg ) )
		self.damageorg delete();
		
	setdvar( "ui_deadquote", "" );
}

tank_unmount_player_to_foot()
{
	tank_unmount_player();
	reset_player_stuff_after_tank();
}

reset_player_stuff_after_tank()
{
	level.player EnableWeapons();
	level.player AllowStand( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowSprint( true );
	level.player AllowJump( true );
	level.player LerpFOV( 65, 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
	level.player Unlink();
	
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "m1a1_player_hands" ] =#animtree;
	level.scr_model[ "m1a1_player_hands" ] = "viewhands_player_delta";
	level.scr_anim[ "m1a1_player_hands" ][ "crash_bump" ] = %hamburg_tank_crash_player;
	scripted_anims();	
}

#using_animtree( "vehicles" );
scripted_anims()
{
	level.scr_animtree[ "m1a1_player_minigun" ] =#animtree;
	level.scr_model[ "m1a1_player_minigun" ] = "weapon_m1a1_minigun";
	level.scr_anim[ "m1a1_player_minigun" ][ "crash_bump" ] = %hamburg_tank_crash_minigun;
}

set_dummy_to_my_angles()
{
	dummy = self get_dummy();
	angle = GetTurretYaw();
	forward_fraction = 0;
	if( angle != 0 )
		forward_fraction = angle / 360 ;
	dummy SetAnim( %abrams_turret_L, 1, 0, 0 );
	dummy SetAnimTime( %abrams_turret_L, forward_fraction );
} 


GetTurretYaw( spot )
{
	//math is hard
	turretYaw = VectorToYaw( AnglesToForward( self GetTagAngles( "tag_turret" ) ) );
	yaw = self.angles[ 1 ] - turretYaw;
	yaw = AngleClamp180( yaw );
	if( yaw < 0 )
		yaw = 180 + ( 180 - abs( yaw ) );
	return yaw;
}
