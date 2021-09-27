#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;
#include maps\_utility_code;

init_common_triggers()
{
	array_thread( getentarray( "death_trigger", "targetname" ), ::death_trigger );
	array_thread( getentarray( "magic_bullet_trigger", "targetname" ), ::magic_bullet_trigger );
}

/*
PLAYER RIG
*/

get_player_rig()
{
	if ( !IsDefined( level.player_rig ) )
	{
		level.player_rig = spawn_anim_model( "player_rig" );
		level.player_rig.origin = level.player.origin;
		level.player_rig.angles = level.player.angles;
	}

	return level.player_rig;
}

link_player_to_arms( r, l, u, d )
{
	
	if ( !IsDefined( r ) )
		r = 30;
	if ( !IsDefined( l ) )
		l = 30;	
	if ( !IsDefined( u ) )
		u = 30;	
	if ( !IsDefined( d ) )
		d = 30;
			
	player_rig = get_player_rig();
	player_rig Show();
	level.player PlayerLinkToAbsolute( player_rig, "tag_player" );
	level.player PlayerLinkToDelta( player_rig, "tag_player", 1, r, l, u, d, true );
}

blend_player_to_arms( time )
{
	if ( !IsDefined( time ) )
		time = 0.7;
	player_rig = get_player_rig();
	player_rig Show();
	level.player PlayerLinkToBlend( player_rig, "tag_player", time );
}

radio_within_proximity( msg, req_distance )
{
	if ( !isdefined( req_distance ) )
		req_distance = 1024;
	
	if ( Distance2d( self.origin, level.player.origin ) <= req_distance )
	{
		radio_dialogue( msg );
	}
}

animation_kills_ai( guy )
{
	if ( !IsAlive( guy ) )
		return;
	
	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
		self stop_magic_bullet_shield();
	guy notify( "animation_killed_me" );
	wait( 0.05 );
	guy.a.nodeath = true;
	guy.allowPain = true;
	guy.allowDeath = true;
	guy Kill();
}

interrupt_anim_on_alert_or_damage( guy )
{
	guy endon( "end_reaction" );
	guy endon( "animation_killed_me" );
	guy waittill_any( "damage", "_stealth_bad_event_listener", "enemy" );
	guy StopAnimScripted();
	self notify( "stop_loop" );
}

interrupt_anim_on_damage( guy )
{
	guy endon( "end_reaction" );
	guy endon( "animation_killed_me" );
	guy waittill( "damage" );
	guy StopAnimScripted();
	self notify( "stop_loop" );
}

follow_path_waitforplayer( start_node, require_player_dist )
{
	self endon( "death" );
	self endon( "stop_path" );

	self notify( "follow_path" );
	self endon( "follow_path" );

	wait 0.1;

	node = start_node;

	getfunc = undefined;
	gotofunc = undefined;

	if ( !IsDefined( require_player_dist ) )
		require_player_dist = 300;

	//only nodes dont have classnames - ents do

	while ( IsDefined( node ) )
	{
		if ( IsDefined( level.struct_class_names[ "targetname" ][ node.targetname ] ) )
		{
			gotofunc = ::follow_path_set_struct;
		}
		else if ( IsDefined( node.classname ) )
		{
			gotofunc = ::follow_path_set_ent;
		}
		else
		{
			gotofunc = ::follow_path_set_node;
		}
		
		if ( IsDefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if ( self.goalradius < 16 )
			self.goalradius = 16;
		if ( IsDefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		original_goalradius = self.goalradius;

		self childthread [[ gotofunc ]]( node );

		if ( isdefined( node.animation ) )
			node waittill( node.animation );
		else
			while ( 1 )
			{
				self waittill( "goal" );
				if ( Distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
					break;
			}

		node notify( "trigger", self );

		// waiting for player
		if ( !IsDefined( node.script_requires_player ) && require_player_dist > 0 )
		{
			while ( IsAlive( level.player ) )
			{
				if ( self wait_for_player( node, require_player_dist ) )
					break;
				if ( IsDefined( node.animation ) )
				{
					self.goalradius = original_goalradius;
					self SetGoalPos( self.origin );
				}
				wait 0.05;
			}
		}

		if ( !IsDefined( node.target ) )
			break;

		node script_delay();

		node = node get_target_ent();
	}

	self notify( "path_end_reached" );
}

wait_for_player( node, dist )
{
	if ( Distance( level.player.origin, node.origin ) < Distance( self.origin, node.origin ) )
		return true;

	vec = undefined;
	//is the player ahead of us?
	vec = AnglesToForward( self.angles );
	vec2 = VectorNormalize( ( level.player.origin - self.origin ) );

	if ( IsDefined( node.target ) )
	{
		temp = get_target_ent( node.target );
		vec = VectorNormalize( temp.origin - node.origin );
	}
	else if ( IsDefined( node.angles ) )
		vec = AnglesToForward( node.angles );
	else
		vec = AnglesToForward( self.angles );

	//i just created a vector which is in the direction i want to
	//go, lets see if the player is closer to our goal than we are				
	if ( VectorDot( vec, vec2 ) > 0 )
		return true;

	//ok so that just checked if he was a mile away but more towards the target
	//than us...but we dont want him to be right on top of us before we start moving
	//so lets also do a distance check to see if he's close behind

	if ( Distance( level.player.origin, self.origin ) < dist )
		return true;

	return false;
}

follow_path_set_node( node )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( node.animation ) )
	{
		node anim_generic_reach( self, node.animation );
		self notify( "starting_anim" );
		node anim_generic_run( self, node.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_node( node );
	}
}

follow_path_set_ent( ent )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( ent.animation ) )
	{
		ent anim_generic_reach( self, ent.animation );
		self notify( "starting_anim" );
		ent anim_generic_run( self, ent.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_ent( ent );
	}
}

follow_path_set_struct( struct )
{
	self notify( "follow_path_new_goal" );
	if ( IsDefined( struct.animation ) )
	{
		struct anim_generic_reach( self, struct.animation );
		self notify( "starting_anim" );
		struct anim_generic_run( self, struct.animation );
		self setGoalPos( self.origin );
	}
	else
	{
		self set_goal_pos( struct.origin );
	}
}

trigger_wait_targetname_multiple( trigTN )
{
	trigs = GetEntArray( trigTN, "targetname" );
	if ( !trigs.size )
	{
		AssertMsg( "no triggers found with targetname: " + trigTN );
		return;
	}
	
	other = undefined;
	
	if ( trigs.size > 1 )
	{
		array_thread( trigs, ::trigger_wait_multiple_think, trigTN );
		level waittill( trigTN, other );
	}
	else
	{
		trigs[ 0 ] waittill( "trigger", other );
	}
	
	return other;
}

distance_2d_squared( a, b )
{
	return LengthSquared( ( a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], 0 ) );
}

trigger_wait_multiple_think( trigTN )
{
	self endon( trigTN );
	
	self waittill( "trigger", other );
	level notify( trigTN, other );
}

// FADE HELPER FUNCS
fade_in( fade_time )
{
	if ( level.MissionFailed )
		return;
	level notify( "now_fade_in" );
		
	black_overlay = get_black_overlay();
	if ( fade_time )
		black_overlay FadeOverTime( fade_time );

	black_overlay.alpha = 0;

	wait( fade_time );
}


fade_out( fade_out_time )
{
	black_overlay = get_black_overlay();
	if ( fade_out_time )
		black_overlay FadeOverTime( fade_out_time );

	black_overlay.alpha = 1;
	wait( fade_out_time );
}

get_black_overlay()
{
	if ( !IsDefined( level.black_overlay ) )
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	level.black_overlay.sort = -1;
	level.black_overlay.foreground = false;
	return level.black_overlay;
}

delete_on_notify( message )
{
	if ( !IsDefined( message ) )
		message = "level_cleanup";
	self endon( "death" );
	level waittill( message );
	
	if ( flag_exist( "_stealth_spotted" ) )
		flag_waitopen( "_stealth_spotted" );

	if ( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		self stop_magic_bullet_shield();
	}
	
	self Delete();
}

flickering_light( light, min, max )
{
	level endon( "level_cleanup" );
	light endon( "stop_flicker" );

	light.linked_models = [];
	light.has_model = false;

	if ( isdefined( light.script_linkTo ) )
	{
		linked_ents = light get_linked_ents();
		light.on_models = [];
		light.off_models = [];
		foreach ( ent in linked_ents )
		{
			if ( ent.script_noteworthy == "off" )
				light.off_models = array_add( light.off_models, ent );
			else
				light.on_models = array_add( light.on_models, ent );
		}
		
		foreach ( model in light.on_models )
		{
			if ( isdefined( model.script_linkTo ) )
			{	
				model_fx = model get_linked_ent();
				model.effect = createOneshotEffect( model_fx.script_fxid );
				
				model.effect.v[ "origin" ] = ( model_fx.origin );
				model.effect.v[ "angles" ] = ( model_fx.angles );
			}
		}
		
		light.has_model = true;
	}

	while ( 1 )
	{
		i = RandomFloatRange( min, max );
		light SetLightIntensity( i );
		if ( i > 0.4 )
			light modelOnState();
		else
			light modelOffState();
		wait( RandomFloatRange( 0.1, 0.2 ) );
	}
}

modelOnState()
{
	if ( !self.has_model )
		return;
	foreach ( m in self.on_models )
	{
		m Show();
		/*
		if ( IsDefined( m.effect ) )
		{
			m.effect restartEffect();
		}
		*/
	}
	foreach ( m in self.off_models )
		m Hide();
}


modelOffState()
{
	if ( !self.has_model )
		return;
	foreach ( m in self.on_models )
	{
		m Hide();
		/*
		if ( IsDefined( m.effect ) )
		{
			m.effect pauseEffect();
		}
		*/
	}
	foreach ( m in self.off_models )
		m Show();
}

moving_light( fire_light, movement )
{
	level endon( "level_cleanup" );
	fire_light endon( "stop_movement" );
	//fire_light           = getent( targetname, "targetname" );
	old_org             = fire_light.origin;
	
	while( 1 )
	{
		waittime = 0.05 + randomint( 4 )/10;
		fire_light MoveTo( old_org - ( randomint( movement ), randomint( movement ), randomint( movement ) ), waittime );
		wait waittime;
	}
}

stealth_shot( target )
{
//	target.favoriteenemy = level.player;
	self endon( "death" );
	target endon( "death" );
	self.fixednode = false;
	self.ignoreAll = false;
	self.favoriteenemy = target;
	self GetEnemyInfo( target );
//	oldcombatmode = self.combatmode;
//	self.combatmode = "ambush";
	target.health = 1;

	wait( 0.3 );
	target.dontattackme = undefined;
	wait( 0.3 );

	start_pos = self GetTagOrigin( "tag_flash" );
	end_pos = target GetTagOrigin( "j_head" );
	trace = BulletTrace( start_pos, end_pos, true );

	while ( !isdefined( self.a.array ) || self.a.array[ "single" ].size <= 0 )
		wait( 0.05 );		

	num = RandomInt( self.a.array[ "single" ].size );
	fireanim = self.a.array[ "single" ][ num ];
	rate = 0.1 / WeaponFireTime( self.weapon );

	self SetFlaggedAnimKnobRestart( "fire_notify", fireanim, 1, 0.05, 1.0 );
	wait( 0.1 );
	start_pos = self GetTagOrigin( "tag_flash" );
	end_pos = target GetTagOrigin( "j_head" );	
//	PlayFxOnTag( getfx( "silencer_flash" ), self, "tag_flash" );
	MagicBullet( self.weapon, start_pos, end_pos );
		
	wait( 0.2 );

	target kill();
//	self.combatmode = oldcombatmode;
}

magic_smoke( targetname, waittime )
{
	structs = getstructarray( targetname, "targetname" );
	ents = [];
	foreach ( s in structs )
	{
		e = spawn_tag_origin();
		e.origin = s.origin;
		if ( isdefined( s.script_delay ) )
			e.script_delay = s.script_delay;
		ents[ ents.size ] = e;
		e thread magic_smoke_individual( "kill_" + targetname, waittime );
	}
	
	level waittill( "kill_" + targetname );
	wait( 0.1 );
	foreach( e in ents )
		e delete();
}

magic_smoke_individual( kill_notify, waittime )
{
	if ( !isdefined( waittime ) )
		waittime = 20;
	if ( isdefined( kill_notify ) )
		level endon( kill_notify );

	self script_delay();

	while( 1 )
	{
		PlayFXOnTag( getfx( "smoke_grenade" ), self, "tag_origin" );
		wait( waittime );
	}
}

_notify( str )
{
	self notify( str );
}

link_door_to_clips( targetname )
{
	door = get_target_ent( targetname );
	linkers = door get_linked_ents();
	foreach ( l in linkers )
	{
		l LinkTo( door );
	}
	return door;
}

volume_waittill_no_axis( targetname, tolerance )
{
	volume = get_target_ent( targetname );
	
	while ( 1 )
	{
		if ( volume_is_empty( volume, tolerance ) )
			break;
		wait ( 0.2 );
	}	
}

volume_is_empty( volume, tolerance )
{
	if ( !isdefined( tolerance ) )
		tolerance = 0;
	
	enemies = GetAIArray( "axis" );
	num = 0;
		
	foreach ( e in enemies )
	{
		if ( e IsTouching( volume ) )
		{
			num += 1;
			if ( num > tolerance )
				return false;
		}
	}
	
	return true;
}

shoulder_door_open( soundalias )
{
	wait( 1.5 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "wood_door_kick" );

	self RotateTo( self.angles + ( 0, 30, 0 ), 0.4, 0, 0.4 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 55, 0 ), 1.2, 0, 0.4 );
}

kick_door_open( soundalias, delay )
{
	if ( isdefined( delay ) )
		wait( delay );
	else
		wait( 0.4 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "wood_door_kick" );

	self RotateTo( self.angles + ( 0, 100, 0 ), 0.3, 0.2, 0.1 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles - ( 0, 5, 0 ), 0.1, 0.0, 0.1 );
	self waittill( "rotatedone" );
	self DisconnectPaths();
}

kick_door_open_reversehinge( soundalias, delay )
{
	if ( isdefined( delay ) )
		wait( delay );
	else
		wait( 0.4 );

	if ( IsDefined( soundalias ) )
		self PlaySound( soundalias );
	else
		self PlaySound( "wood_door_kick" );

	self RotateTo( self.angles - ( 0, 100, 0 ), 0.3, 0.2, 0.1 );
	self ConnectPaths();
	self waittill( "rotatedone" );
	self RotateTo( self.angles + ( 0, 5, 0 ), 0.1, 0.0, 0.1 );
}

kick_double_door_open( door_l, door_r, soundalias, delay, fxnode )
{
	if ( isdefined( delay ) )
		wait( delay );
	else
		wait( 0.5 );

	if ( IsDefined( soundalias ) )
		door_l PlaySound( soundalias );
	else
		door_l PlaySound( "wood_door_kick" );

	if ( isdefined( fxnode ) )
	{
		if ( !isdefined( fxnode.script_fxid ) )
			fxnode.script_fxid = "door_kick";
		if ( !isdefined( fxnode.angles ) )
			fxnode.angles = (0,0,0);
		PlayFX( getfx( fxnode.script_fxid ), fxnode.origin, AnglesToForward( fxnode.angles ) );
	}

	door_l RotateTo( door_l.angles + ( 0, 100, 0 ), 0.4, 0.2, 0.1 );
	door_r RotateTo( door_r.angles - ( 0, 100, 0 ), 0.4, 0.2, 0.1 );
	
	door_l waittill( "rotatedone" );
	
	door_r ConnectPaths();
	door_l ConnectPaths();
	
	door_l RotateTo( door_l.angles - ( 0, 5, 0 ), 0.2, 0.0, 0.1 );
	door_r RotateTo( door_r.angles + ( 0, 5, 0 ), 0.2, 0.0, 0.1 );

	door_l waittill( "rotatedone" );
	
	door_r disconnectPaths();
	door_l disconnectPaths();
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

magic_bullet_trigger()
{
	while( 1 )
	{
		self waittill( "trigger" );
		if ( isdefined( self.script_delay ) )
			self script_delay();
		delay_min = self.script_delay_min;
		delay_max = self.script_delay_max;
		duration = self.script_duration;
		ammo = self.script_noteworthy;
		ammo = strtok( ammo, " " );
		
		p1 = self get_target_ent();
		p2 = p1 get_target_ent();
		r1 = p1.radius;
		r2 = p2.radius;
		
		if ( !isdefined( r1 ) )
			r1 = 0.1;
		if ( !isdefined( r2 ) )
			r2 = 0.1;
			
		time = 0;
		
		grenades = [ "molotov", "fraggrenade", "flashbang" ];
		
		if ( !isdefined( duration ) )
		{
			if ( array_contains( grenades, ammo[ 0 ] ) )
				MagicGrenade( ammo[ 0 ], p1.origin, p2.origin );
			else
				MagicBullet( ammo[ 0 ], p1.origin, p2.origin );
			
			break;
		}
		else
		{
			while( time < duration )
			{
				if ( array_contains( grenades, ammo[ 0 ] ) )
					MagicGrenade( ammo[ RandomIntRange( 0, ammo.size ) ], p1.origin + (RandomFloatRange(-1*r1,r1), RandomFloatRange(-1*r1,r1), RandomFloatRange(-1*r1,r1)), p2.origin + (RandomFloatRange(-1*r2,r2), RandomFloatRange(-1*r2,r2), RandomFloatRange(-1*r2,r2)) );
				else
					MagicBullet( ammo[ RandomIntRange( 0, ammo.size ) ], p1.origin + (RandomFloatRange(-1*r1,r1), RandomFloatRange(-1*r1,r1), RandomFloatRange(-1*r1,r1)), p2.origin + (RandomFloatRange(-1*r2,r2), RandomFloatRange(-1*r2,r2), RandomFloatRange(-1*r2,r2)) );
				waittime = RandomFloatRange( delay_min, delay_max );
				time += waittime;
				wait( waittime );
			}
		}
		
		if ( isdefined( self.script_reuse ) )
			break;
	}
}

play_sound_on_tag_stoppable( alias, tag, ends_on_death, op_notify_string, radio_dialog )
{
	if ( is_dead_sentient() )
		return;

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	
	self.soundplayer = org;
	
	thread delete_on_death_wait_sound( org, "sounddone" );
	if ( IsDefined( tag ) )
		org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}

	/#
	if ( IsDefined( level.player_radio_emitter ) && ( self == level.player_radio_emitter ) )
		PrintLn( "**dialog alias playing radio: " + alias );
	#/

	org PlaySound( alias, "sounddone" );
	if ( IsDefined( ends_on_death ) )
	{
		AssertEx( ends_on_death, "ends_on_death must be true or undefined" );
		if ( !isdefined( wait_for_sounddone_or_death( org ) ) )
			org StopSounds(); // don't call StopSounds (redundantly) when the sound stopped since this can cut off sounds in SO for the non host
		wait( 0.05 );// stopsounds doesnt work if the org is deleted same frame
	}
	else
	{
		org waittill( "sounddone" );
	}
	if ( IsDefined( op_notify_string ) )
		self notify( op_notify_string );
	org Delete();
}

light_on_gun()
{
	PlayFXOnTag( getfx( "flashlight" ), self, "TAG_FLASH" );
}

death_trigger()
{
	level.player endon( "death" );
	self waittill( "trigger" );
	self script_delay();
	level.player DisableInvulnerability();
	level.player kill();
}

spawnfunc_idle()
{
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;
	
	node thread anim_generic_loop( self, self.animation );
}

set_flag_on_spotted( flagname )
{
	level endon( flagname );
	flag_Wait( "_stealth_spotted" );
	flag_set( flagname );
}

set_generic_idle_forever( idle_anim )
{
	thread set_generic_idle_internal( idle_anim );
}

set_generic_idle_internal( idle_anim )
{
	self endon( "death" );
	self endon( "clear_idle_anim" );
	
	while ( 1 )
	{
		self set_generic_idle_anim( idle_anim );

		self waittill( "clearing_specialIdleAnim" );
	}
}
flag_on_damage( script_flag )
{
	self waittill_either( "death", "damage" );
	flag_set( script_flag );
}

anim_generic_reach_and_animate( guy, anime, tag, custommode )
{
	self anim_generic_reach( guy, anime, tag );
	self notify( "starting_anim" );
	guy notify( "starting_anim" );
	if ( isdefined( custommode ) )
		self anim_generic_custom_animmode( guy, custommode, anime, tag );
	else
		self anim_generic( guy, anime, tag );
}

waittill_notify_or_flag( notify_str, flagname )
{
	self endon( notify_str );
	flag_wait( flagname );
}

kill_on_death( ent )
{
	ent waittill( "death" );
	self delete();
}

damage_trigger()
{
	while( 1 ) 
	{
		self waittill( "trigger" );
		self script_delay();
		fwd = AnglesToForward( level.player.angles );
		level.player dodamage( 50, level.player.origin + fwd );
		wait( 1 );
	}
}