#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level._effect["cameraspike_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["cameraspike_friendly_light"] = loadfx( "misc/fx_equip_light_green" );
}

createCameraSpikeWatcher()
{
	watcher = self maps\mp\gametypes\_weaponobjects::createUseWeaponObjectWatcher( "camera_spike", "camera_spike_mp", self.team );
	watcher.onSpawn = ::onSpawnCameraSpike;
	watcher.detonate = ::cameraSpikeDetonate;
	watcher.stun = maps\mp\gametypes\_weaponobjects::weaponStun;
	watcher.stunTime = 5;
	watcher.reconModel = "t5_weapon_camera_spike_world_detect";
	watcher.hackable = true;
	watcher.onDamage = ::watchCameraSpikeDamage;
}

onSpawnCameraSpike( watcher, player )
{
	self endon( "death" );
	
	self thread maps\mp\gametypes\_weaponobjects::onSpawnUseWeaponObject( watcher, player );
	
	// If just changing owners (camera head is already set up)
	if ( IsDefined( self.cameraHead ) )
	{
		self.cameraHead maps\mp\gametypes\_weaponobjects::attachReconModel( "t5_weapon_camera_head_world_detect", player );
		self changeOwner( self.prevOwner, player );
		return;
	}

	player.cameraSpike = self;
	player.cameraSpikeToggle = true;
	player toggleCameraSpike( player.cameraSpikeToggle );
	self SetOwner( player );
	self.owner = player;
	self SetTeam( player.team );
	self.prevOwner = player;

	playerAngles = player GetPlayerAngles();
	forward = AnglesToForward( playerAngles );
	eye = player GetEye();
	trace = BulletTrace( eye + VectorScale( forward, 10 ), eye + VectorScale( forward, 10000 ), false, player, false, true );
	
	self.cameraHead = Spawn( "script_model", self GetTagOrigin( "tag_leg_2" ) );
	self.cameraHead SetModel( "t5_weapon_camera_head_world" );
	self.cameraHead.angles = self.angles;
	self.cameraHead linkto( self );
	self.cameraHead maps\mp\gametypes\_weaponobjects::attachReconModel( "t5_weapon_camera_head_world_detect", player );
	self.cameraHead SetOwner( player );
	self.cameraHead.owner = player;
	self.cameraHead SetTeam( player.team );
	self.cameraHead thread watch_camera_head_damage( watcher, self );
	
 	player AddWeaponStat( "camera_spike_mp", "used", 1 );

	self thread watchStun();
	self thread watchToggle( player );
	self thread watchShutdown( player );
	self thread adjustPosition( trace["position"] );
}

adjustPosition( viewTargetPos )
{
	self endon( "death" );
	self waitTillNotMoving();
	if ( IsDefined( self.owner ) )
	{
		if ( self.owner IsOnGround() )
			self.origin = self.owner.origin;
		self thread adjustCameraDirection( viewTargetPos );
	}
}

changeOwner( lastOwner, newOwner )
{
	if ( newOwner == lastOwner )
		return;

	self notify( "owner_changed" );

	lastOwner.cameraSpike = undefined;
	lastOwner.cameraSpikeToggle = false;
	lastOwner toggleCameraSpike( lastOwner.cameraSpikeToggle );

	newOwner.cameraSpike = self;
	newOwner.cameraSpikeToggle = true;
	newOwner toggleCameraSpike( newOwner.cameraSpikeToggle );
	self.prevOwner = newOwner;

	self.cameraHead SetOwner( newOwner );
	self.cameraHead.owner = newOwner;
	self.cameraHead SetTeam( newOwner.team );
	self SetOwner( newOwner );
	self.owner = newOwner;
	self SetTeam( newOwner.team );
}

cameraSpikeDetonate( attacker )
{
	PlayFX( level._equipment_explode_fx, self.origin );
	PlaySoundAtPosition ( "dst_equipment_destroy", self.origin );
	self destroyEnt();
}

destroyEnt()
{
	self delete();
}

adjustCameraDirection( point )
{
	self endon( "death" );
	
	self.cameraHead unlink();
	origin = self GetTagOrigin( "tag_leg_2" );
	direction = point - origin;
	self.cameraHead.origin = origin;
	self.cameraHead.angles = vectortoangles( direction );
	self.cameraHead SetClientFlag( level.const_flag_camera_spike );
	self.cameraHead linkto( self );
}

watchStun()
{
	self endon( "death" );
	self.cameraHead endon( "death" );
	
	for ( ;; )
	{
		self waittill( "stunned" );
		if ( IsDefined( self.cameraHead ) )
		{
			self.cameraHead.stunned = true;
			self.cameraHead SetClientFlag( level.const_flag_stunned );
		}
		
		self waittill( "not_stunned" );
		if ( IsDefined( self.cameraHead ) )
		{
			self.cameraHead.stunned = false;
			self.cameraHead ClearClientFlag( level.const_flag_stunned );
		}
	}
}

watchShutdown( player )
{	
	cameraHead = self.cameraHead;
	self waittill( "death" );
	
	if ( isDefined( cameraHead ) )
		cameraHead delete();
		
	if ( isDefined( player ) && ( !isdefined( player.cameraSpike ) || player.cameraSpike == self ) )
	{
		player.cameraSpikeToggle = false;
		player.cameraSpike = undefined;
		player toggleCameraSpike( player.cameraSpikeToggle );
	}
}

watchToggle( player )
{
	self endon( "death" );
	self endon( "owner_changed" );
	player endon( "disconnect" );
	
	while ( true )
	{
		if ( player ActionSlotOneButtonPressed() && !player IsRemoteControlling() )
		{
			player.cameraSpikeToggle = !player.cameraSpikeToggle;
			player toggleCameraSpike( player.cameraSpikeToggle );
			while ( player ActionSlotOneButtonPressed() )
				wait 0.05;
		}
		wait 0.05;
	}
}

watchCameraSpikeDamage( watcher ) // self == camera spike
{
	self endon( "death" );
	self endon( "hacked" );

	self SetCanDamage( true );
	damageMax = 100;

	if ( !self maps\mp\gametypes\_weaponobjects::isHacked() )
	{
		self.damageTaken = 0;
	}
	
	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weaponName, iDFlags );

		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;		

		if ( level.teamBased && attacker.team == self.owner.team && attacker != self.owner )
			continue;

		// most equipment should be flash/concussion-able, so it'll disable for a short period of time
		// check to see if the equipment has been flashed/concussed and disable it (checking damage < 5 is a bad idea, so check the weapon name)
		// we're currently allowing the owner/teammate to flash their own
		if ( IsDefined( weaponName ) )
		{
			// do damage feedback
			switch( weaponName )
			{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
				if( watcher.stunTime > 0 )
				{
					self thread maps\mp\gametypes\_weaponobjects::stunStart( watcher, watcher.stunTime ); 
				}

				// if we're not on the same team then show damage feedback
				if( level.teambased && self.owner.team != attacker.team )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				}
				// for ffa just make sure the owner isn't the same
				else if( !level.teambased && self.owner != attacker )
				{
					if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
						attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				}
				continue;

			default:
				if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weaponName, attacker ) )
					attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( false );
				break;
			}
		}

		if( isPlayer( attacker ) && level.teambased && isDefined( attacker.team ) && self.owner.team == attacker.team && attacker != self.owner )
			continue;

		if ( IsDefined( weaponName ) && ( weaponName == "emp_grenade_mp" ) )
		{
			watcher thread maps\mp\gametypes\_weaponobjects::waitAndDestroy( self );
			return; 
		}			

		if ( type == "MOD_MELEE" )
		{
			self.damageTaken = damageMax;
		}
		else
		{
			self.damageTaken += damage;
		}

		if( self.damageTaken >= damageMax )
		{
			attacker maps\mp\_properks::shotEquipment( self.owner, iDFlags );
			watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate( self, 0.0, attacker );
		}
	}
}

watch_camera_head_damage( watcher, body ) // self == camera spike head
{
	self endon( "death" );
	body endon( "death" );

	self SetCanDamage( true );

	while( true )
	{
		self.maxhealth = 100000;
		self.health = self.maxhealth;

		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
		body notify( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
	}
}

toggleCameraSpike( enable )
{
	self endon( "disconnect" );
	self SetCameraSpikeActive( enable );
}
