#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;

init()
{
	PrecacheModel( "veh_t6_drone_pegasus" );
	PrecacheItem( "remote_mortar_mp" );
	PrecacheItem( "remote_mortar_missile_mp" );
	
	level.remote_mortar_fx["laserTarget"] = loadfx( "weapon/remote_mortar/fx_rmt_mortar_laser_loop" );
	level.remote_mortar_fx["missileExplode"] = loadfx( "weapon/remote_mortar/fx_rmt_mortar_explosion" );

	registerKillstreak( "remote_mortar_mp", "remote_mortar_mp", "killstreak_remote_mortar", "remote_mortar_used", ::remote_mortar_killstreak, true );
	registerKillstreakAltWeapon( "remote_mortar_mp", "remote_mortar_missile_mp" );
	registerKillstreakStrings( "remote_mortar_mp", &"KILLSTREAK_EARNED_REMOTE_MORTAR", &"KILLSTREAK_REMOTE_MORTAR_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MORTAR_INBOUND" );
	registerKillstreakDialog( "remote_mortar_mp", "mpl_killstreak_rmortar_strt", "kls_reaper_used", "", "kls_reaper_enemy", "", "kls_reaper_ready" );
	registerKillstreakDevDvar( "remote_mortar_mp", "scr_givemortarremote" );
	
	set_dvar_float_if_unset( "scr_remote_mortar_lifetime", 40.0 );
	
	level.remore_mortar_infrared_vision = "remote_mortar_infrared";
	level.remore_mortar_enhanced_vision = "remote_mortar_enhanced";
}

remote_mortar_killstreak( hardpointType )
{
	assert( hardpointType == "remote_mortar_mp" );

	self setUsingRemote( hardpointType );
	self freezeControlsWrapper( true );
	self DisableWeaponCycling();
		
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self notify( "remote_mortar_unlock" );
			self clearUsingRemote();
			self EnableWeaponCycling();
		}

		return false;
	}	

	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "remote_mortar_mp", self.team, false, true ) )
	{
			self clearUsingRemote();
			self EnableWeaponCycling();
			self notify( "remote_mortar_unlock" );
			return false;
	}

	self.killstreak_waitamount = ( GetDvarFloat( "scr_remote_mortar_lifetime" ) * 1000 );

	remote = self remote_mortar_spawn();
	remote thread remote_killstreak_abort();
	remote thread remote_killstreak_game_end();
	remote thread remote_damage_think();
	
	remote playloopsound( "veh_pegasus_drone_loop", 1 );

	self player_linkto_remote( remote );

	self freezeControlsWrapper( false );

	self thread player_aim_think( remote );
	self thread player_fire_think( remote );
	
	self thread visionSwitch( 1.0 );
	
	level waittill( "remote_unlinked" );
	
	if ( isdefined( remote ) )
		remote stoploopsound( 4 );

	self ClearClientFlag( level.const_flag_operatingreaper );
	self clearUsingRemote();

	return true;
}

remote_killstreak_abort()
{
	level endon( "remote_end" );
	assert( IsDefined( self.owner ) );
	assert( IsPlayer( self.owner ) );

	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );
	self thread remote_killstreak_end( true );
}

remote_killstreak_game_end()
{
	level endon( "remote_end" );
	assert( IsDefined( self.owner ) );
	assert( IsPlayer( self.owner ) );

	level waittill( "game_ended" );
	self thread remote_killstreak_end();
}

remote_mortar_spawn()
{
	self SetClientFlag( level.const_flag_operatingreaper );

	remote = SpawnPlane( self, "script_model", level.UAVRig GetTagOrigin( "tag_origin" ) );
	assert( IsDefined( remote ) );

	remote SetModel( "veh_t6_drone_pegasus" );
	remote.targetname = "remote_mortar";

	remote SetOwner( self );
	remote SetTeam( self.team );
	remote.team = self.team;
	remote.owner = self;

	//	same height and radius as the AC130 with random angle and counter rotation
	zOffset = 6300;
	angle = randomInt( 360 );
	radiusOffset = 6100;
	xOffset = cos( angle ) * radiusOffset;
	yOffset = sin( angle ) * radiusOffset;
	angleVector = vectorNormalize( (xOffset,yOffset,zOffset) );
	angleVector = ( angleVector * 6100 );
	remote LinkTo( level.UAVRig, "tag_origin", angleVector, (0,angle-90,10) );	

	// laser fx
//	remote.fx = SpawnFx( level.remote_mortar_fx["laserTarget"], (0,0,0) );	
	remote.fx = Spawn( "script_model", (0,0,0) );
	remote.fx SetModel( "tag_origin" );

	// the owner is going to have this fx created and updated
	remote.fx SetInvisibleToPlayer( remote.owner, true );

	// visibility
	remote remote_mortar_visibility();

	return remote;
}

remote_mortar_visibility()
{
	players = GET_PLAYERS();

	foreach( player in players )
	{
		if ( player == self.owner )
		{
			self SetInvisibleToPlayer( player );
			continue;
		}

		if ( level.teambased && self.team == player.team )
		{
			self SetInvisibleToPlayer( player );
			continue;
		}

		self SetVisibleToPlayer( player );
	}
}

remote_killstreak_end( abort )
{
	level notify( "remote_end" );

	if ( !IsDefined( abort ) )
	{
		abort = false;
	}

	if ( !IsDefined( self.owner ) )
	{
		abort = true;
	}

	if ( IsDefined( self.owner ) )
	{
		self.owner Unlink();
		self.owner.killstreak_waitamount = undefined;	

		self.owner EnableWeaponCycling();
	}

	level notify( "remote_unlinked" );

	maps\mp\killstreaks\_killstreakrules::killstreakStop( "remote_mortar_mp", self.team );
	
	if ( isdefined( self.owner ) )
	{
		self.owner SetInfraredVision( false );
		self.owner UseServerVisionset( false );
	}

	if ( isdefined(self.fx) )
		self.fx delete();
	
	self remote_leave();
}

player_linkto_remote( remote )
{
	self PlayerLinkWeaponViewToDelta( remote, "tag_player", 1.0, 40, 40, 25, 40 );
	self player_center_view();
}

player_center_view( org )
{
	wait(0.05);
	
	lookVec = VectorToAngles( level.UAVRig.origin - self GetEye() );
	self SetPlayerAngles( lookVec  );
}

player_aim_think( remote )
{	
	level endon( "remote_end" );

	wait( 0.25 );
	
	PlayFxOnTag( level.remote_mortar_fx[ "laserTarget" ], remote.fx, "tag_origin" );
	
	while ( true )
	{
		origin = self GetEye();
		forward = AnglesToForward( self GetPlayerAngles() );
		endpoint = origin + forward * 15000;

		trace = BulletTrace( origin, endpoint, false, remote );
		remote.fx.origin = trace[ "position" ];
		remote.fx.angles = VectortoAngles(trace[ "normal" ]);
//		triggerFX( remote.fx );

		wait( 0.05 );
	}
}
	
player_fire_think( remote )
{
	level endon( "remote_end" );
	
	end_time = GetTime() + self.killstreak_waitamount;

	while( GetTime() < end_time )
	{
		if ( !self AttackButtonPressed() )
		{
			wait( 0.05 );
			continue;
		}
			
		self playLocalSound( "reaper_fire" );
		self PlayRumbleOnEntity( "damage_heavy" );

		origin = self GetEye();
		Earthquake( 0.3, 0.5, origin, 256 );

		angles = self GetPlayerAngles();
		forward = AnglesToForward( angles );
		right = AnglesToRight( angles );

		offset = origin + ( forward * 100 ) + ( right * -100 );			
					
		missile = MagicBullet( "remote_mortar_missile_mp", offset, remote.fx.origin, self, remote.fx );
		
		missile thread remote_missile_life(remote);
		
		missile waittill( "death" );
	}

	remote thread remote_killstreak_end();
}

remote_missile_life( remote )
{
	self endon( "death" );
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 6 );
	
	playFX( level.remote_mortar_fx["missileExplode"], self.origin );
	self delete();
}

remote_damage_think()
{	
	level endon( "remote_end" );
	
	self.health = 999999; // keep it from dying anywhere in code
	maxHealth = 1500; 
	damageTaken = 0; 

	self SetCanDamage( true );
	Target_Set( self, ( 0, 0, 30 ) );
	
	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partname, weapon );		
		self.health = 999999;

		if( IsPlayer( attacker ) )
		{					
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false, "" );

			if ( attacker HasPerk( "specialty_armorpiercing" ) )
			{
				if( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" )
				{
					damage += int( damage * level.cac_armorpiercing_data );
				}
			}
		}

		if( IsDefined( weapon ) )
		{
			if ( maps\mp\gametypes\_weapons::isLauncherWeapon( weapon ) )
			{
					damage = maxHealth + 1;
			}
		}

		if ( damage <= 0 )
		{
			continue;
		}
		
		self.owner PlayLocalSound( "reaper_damaged" );
					
		damageTaken += damage;
		if ( damageTaken >= maxHealth )
		{
			thread maps\mp\gametypes\_globallogic_score::givePlayerScore( "helicopterkill", attacker );

			level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_REMOTE_MORTAR", attacker ); 

			self thread remote_killstreak_end();
			return;
		}			
	}	
}

remote_leave()
{
	level endon( "game_ended" );
	self  endon( "death" );
	
//	self notify( "remote_done" );			

	self unlink();
	destPoint = self.origin + ( AnglesToForward( self.angles ) * 20000 );
	self moveTo( destPoint, 30 );
	PlayFXOnTag( level.fx_spyplane_afterburner , self, "tag_origin" );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 3 );

	self moveTo( destPoint, 4, 4, 0.0 );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 4 );		
	
	self delete();
}

visionSwitch( delay )
{
	self endon( "disconnect" );
	level endon( "remote_end" );
	
	wait( delay	);

	inverted = false;
	
	self SetInfraredVision( false );
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.remore_mortar_enhanced_vision, 1 );

	for (;;)
	{
		if ( self UseButtonPressed() )
		{
			if ( !inverted )
			{
				self SetInfraredVision( true );
				self SetVisionSetForPlayer( level.remore_mortar_infrared_vision, 0.5 );
			}
			else
			{
				self SetInfraredVision( false );
				self SetVisionSetForPlayer( level.remore_mortar_enhanced_vision, 0.5 );
			}

			inverted = !inverted;
			
			// wait for the button to release:
			while ( self UseButtonPressed() )
				wait( 0.05 );
		}
		wait( 0.05 );
	}
}
