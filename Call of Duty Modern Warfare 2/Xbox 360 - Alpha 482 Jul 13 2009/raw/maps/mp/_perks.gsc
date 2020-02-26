#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	thread init_smartArrow();

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self thread watchSmartArrows();
	}
}


init_smartArrow()
{
	precacheItem( "smartarrow_mp" );
	
	level._effect["smartarrow_oor"] = loadFx( "explosions/grenade_flash" );
}


watchSmartArrows()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "grenade_fire", smartArrow, weaponName );

		if ( weaponName != "smartarrow_mp" )
			continue;
			
		if ( !isAlive( self ) )
		{
			smartArrow delete();
			continue;
		}

		playerAngles = self getPlayerAngles();
		reverseAngles = (0-playerAngles[0],playerAngles[1] + 180,0);		

		smartArrow.owner = self;
		smartArrow.activated = false;
		smartArrow.savedAngles = reverseAngles;
		
		smartArrow thread activateOnStick();
		smartArrow thread deleteAtRange( 2000.0 );
		self thread smartArrowUseWaiter( smartArrow );
	}
}



smartArrowUseWaiter( smartArrow )
{
	smartArrow endon ( "death" );
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	smartArrow thread cleanupOnDeath();
	smartArrow thread cleanupOnGameEnded();
	smartArrow thread cleanupOnOwnerDeath();
	smartArrow thread cleanupOnOwnerDisconnect();

	smartArrow waittill ( "activated" );

	if ( !smartArrow initSmartArrowCam() )
		return;

	self _setPerk( "_smartarrow_mp" );

	self thread setAltSceneObj( smartArrow.cam, "tag_origin", 85, true );

	self thread altDetonateThink();

	self waittill ( "detonate" );
	smartArrow detonate();
}



altDetonateThink()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "detonate" );
	level endon( "game_ended" );

	buttonTime = 0;
	for ( ;; )
	{
		if ( self UseButtonPressed() )
		{
			currentWeapon = self getCurrentWeapon();
			
			if ( currentWeapon == "none" )
			{
				wait ( 0.05 );
				continue;
			}
			
			weaponInvType = weaponInventoryType( currentWeapon );	
			if ( weaponInvType != "primary" && weaponInvType != "altmode" )
			{
				wait ( 0.05 );
				continue;
			}			

			buttonTime = 0;
			while ( self UseButtonPressed() )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}

			if ( buttonTime >= 0.5 )
				continue;

			buttonTime = 0;
			while ( !self UseButtonPressed() && buttonTime < 0.5 )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}

			if ( buttonTime >= 0.5 )
				continue;

			self notify( "detonate" );
		}
		wait( 0.05 );
	}
}


cleanupOnDeath()
{
	self waittill ( "death" );
	
	if ( isDefined( self.owner ) )
	{
		currentWeapon = self.owner getCurrentWeapon();
		
		self.owner takeWeapon( "smartarrow_mp" );
		self.owner _unsetPerk( "_smartarrow_mp" );
		
		if ( currentWeapon == "smartarrow_mp" )
			self.owner switchToWeapon( self.owner getLastWeapon() );
	}

	if ( isDefined( self.cam ) )
		self.cam delete();
}


cleanupOnGameEnded()
{
	self endon ( "death" );
	
	level waittill ( "game_ended" );
	self delete();
}


cleanupOnOwnerDeath()
{
	self endon ( "death" );

	self.owner waittill ( "death" );
	self delete();	
}


cleanupOnOwnerDisconnect()
{
	self endon ( "death" );

	self.owner waittill ( "disconnect" );
	self delete();	
}


smartArrowDamage()
{
	self endon ( "death" );
	
	self setCanDamage( true );
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	for ( ;; )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		
		// don't allow people to destroy C4 on their team if FF is off
		if ( isPlayer( attacker ) && !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;
				
		if ( damage < 5 ) // ignore concussion grenades
			continue;
		
		break;
	}

	self detonate();
}


initSmartArrowCam()
{
	trace = bulletTrace( self.origin, self.origin + anglesToForward( self.savedAngles ) * 16, false, undefined );
	targetPos = trace["position"];

	if ( !isDefined( targetPos ) )
		return false;

	self.angles = self.savedAngles;
	
	self.cam = spawn( "script_model", targetPos );	
	self.cam.angles = self.angles;
	self.cam setModel( "tag_origin" );
	
	self.cam linkTo( self, "tag_origin" );
	
	self thread smartArrowDamage();
	
	return true;
}


deleteAtRange( maxRange )
{
	self endon ( "death" );
	self endon ( "activated" );

	while( distance( self.origin, self.owner.origin ) < maxRange )
	{
		wait ( 0.05 );
	}
	
	playFx( level._effect["smartarrow_oor"], self.origin );
	if ( isAlive( self.owner ) )
		self.owner iPrintLnBold( "SmartArrow out of range." );

	self delete();
}


activateOnStick()
{
	self endon( "death" );

	self waittill( "missile_stuck" );
	
	wait 0.05;

	//println( distance( self.owner.origin, self.origin ) );
	
	self notify( "activated" );
	self.activated = true;
}
