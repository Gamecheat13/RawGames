#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.juggSettings = [];

	level.juggSettings[ "juggernaut" ] = spawnStruct();
	level.juggSettings[ "juggernaut" ].splashUsedName =			"used_juggernaut";
	level.juggSettings[ "juggernaut" ].overlay =				"goggles_overlay";

	level.juggSettings[ "juggernaut_recon" ] = spawnStruct();
	level.juggSettings[ "juggernaut_recon" ].splashUsedName =	"used_juggernaut";
	level.juggSettings[ "juggernaut_recon" ].overlay =			"goggles_overlay";

	level.juggSettings[ "juggernaut_maniac" ] = spawnStruct();
	level.juggSettings[ "juggernaut_maniac" ].splashUsedName =	"used_juggernaut";
	level.juggSettings[ "juggernaut_maniac" ].overlay =			"goggles_overlay";
	}

giveJuggernaut( juggType ) // self == player
{
	self endon( "death" );
	self endon( "disconnect" );

	// added this wait here because i think the disabling the weapons and re-enabling while getting the crate, 
	//	needs a little time or else we sometimes won't have a weapon in front of us after we get juggernaut
	wait(0.05); 

	//	remove light armor if equipped
	if ( isDefined( self.hasLightArmor ) && self.hasLightArmor == true )
		maps\mp\perks\_perkfunctions::removeLightArmor( self.previousMaxHealth );	

	//	remove explosive bullets if equipped
	if ( self _hasPerk( "specialty_explosivebullets" ) )
		self _unsetPerk( "specialty_explosivebullets" );

	// give 100% health to fix some issues
	//	first was if you are being damaged and pick up juggernaut then you could die very quickly as juggernaut, seems weird in practice
	self.health = self.maxHealth;

	switch( juggType )
	{
	case "juggernaut":
		self.isJuggernaut = true;
		self.juggMoveSpeedScaler = .65;	// for unset perk juiced
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], juggType, false, false );
		self.moveSpeedScaler = .65;
		self givePerk( "specialty_radarjuggernaut", false );
		break;
	case "juggernaut_recon":
		self.isJuggernautRecon = true;
		self.juggMoveSpeedScaler = .75;	// for unset perk juiced
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], juggType, false, false );
		self.moveSpeedScaler = .75;	

		portable_radar = spawn( "script_model", self.origin );
		portable_radar.team = self.team;

		portable_radar makePortableRadar( self );
		self.personalRadar = portable_radar;

		self thread radarMover( portable_radar );
		self givePerk( "specialty_radarjuggernaut", false );
		break;
	case "juggernaut_maniac":
		self.isJuggernautManiac = true;
		self.juggMoveSpeedScaler = 1.15;	// for unset perk juiced
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], juggType, false, false );
		//self maps\mp\killstreaks\_killstreaks::giveAllPerks();
		//self _unsetPerk( "specialty_lightweight" );
		//self _unsetPerk( "specialty_combat_speed" );
		//self givePerk( "specialty_delaymine", false );
		//self givePerk( "specialty_regenfaster", false );
		self givePerk( "specialty_extendedmelee", false );
		self givePerk( "specialty_blindeye", false );
		self givePerk( "specialty_coldblooded", false );
		self givePerk( "specialty_detectexplosive", false );
		self givePerk( "specialty_marathon", false );
		self givePerk( "specialty_explosivedamage", false );
		self givePerk( "specialty_fastermelee", false );
		//self givePerk( "specialty_radarjuggernaut", false );
		self.moveSpeedScaler = 1.15; // this needs to happen last because some perks change speed
		break;
	}

	self maps\mp\gametypes\_weapons::updateMoveSpeedScale();

	self disableWeaponPickup();

	if ( !getDvarInt( "camera_thirdPerson" ) && IsDefined( level.juggSettings[ juggType ].overlay ) )
	{
		self.juggernautOverlay = newClientHudElem( self );
		self.juggernautOverlay.x = 0;
		self.juggernautOverlay.y = 0;
		self.juggernautOverlay.alignX = "left";
		self.juggernautOverlay.alignY = "top";
		self.juggernautOverlay.horzAlign = "fullscreen";
		self.juggernautOverlay.vertAlign = "fullscreen";
		self.juggernautOverlay SetShader( level.juggSettings[ juggType ].overlay, 640, 480 );
		self.juggernautOverlay.sort = -10;
		self.juggernautOverlay.archived = true;
		self.juggernautOverlay.hidein3rdperson = true;
	}

	self thread juggernautSounds();

	self thread teamPlayerCardSplash( level.juggSettings[ juggType ].splashUsedName, self );	
	
	// if we are using the specialist strike package then we need to clear it, or else players will think they have the perks while jugg
	if( self.streakType == "specialist" )
	{
		self thread maps\mp\killstreaks\_killstreaks::clearKillstreaks();
	}
	//	- giveLoadout() nukes action slot 4 (killstreak weapon)
	//	- it's usually restored after activating a killstreak but 
	//	  equipping juggernaut out of a box isn't part of killstreak activation flow
	//	- restore action slot 4 by re-updating killstreaks
	else
	{
		self thread maps\mp\killstreaks\_killstreaks::updateKillstreaks( true );
	}

	self thread juggRemover();

	//	- model change happens at the end of giveLoadout(), removing any attached models
	//	- re-apply flag if we were carrying one
	if ( isDefined( self.carryFlag ) )
	{
		wait( 0.05 );
		self attach( self.carryFlag, "J_spine4", true );
	}

	level notify( "juggernaut_equipped", self );

	self maps\mp\_matchdata::logKillstreakEvent( "juggernaut", self.origin );
}

juggernautSounds()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "jugg_removed" );

	for ( ;; )
	{
		wait ( 3.0 );
		self playSound( "juggernaut_breathing_sound" );
	}
}

radarMover( portableRadar )
{
	level endon("game_ended");
	self endon( "disconnect" );
	self endon( "jugg_removed" );
	self endon( "jugdar_removed" );

	for( ;; )
	{
		portableRadar MoveTo( self.origin, .05 );
		wait (0.05);
	}
}


juggRemover()
{
	level endon("game_ended");
	self endon( "disconnect" );
	self endon( "jugg_removed" );

	self thread juggRemoveOnGameEnded();
	self thread radarRemoveOnDisconnect();
	self waittill_any( "death", "joined_team", "joined_spectators", "lost_juggernaut" );

	self enableWeaponPickup();
	self.isJuggernaut = false;
	self.isJuggernautDef = false;
	self.isJuggernautGL = false;
	self.isJuggernautRecon = false;
	self.isJuggernautManiac = false;
	if ( isDefined( self.juggernautOverlay ) )
		self.juggernautOverlay destroy();

	self unsetPerk( "specialty_radarjuggernaut", true );

	if ( isDefined( self.personalRadar ) )
	{
		self notify( "jugdar_removed" );
		level maps\mp\gametypes\_portable_radar::deletePortableRadar( self.personalRadar );
		self.personalRadar = undefined;	
	}

	self notify( "jugg_removed" );
}

juggRemoveOnGameEnded()
{
	self endon( "disconnect" );
	self endon( "jugg_removed" );

	level waittill( "game_ended" );

	if( IsDefined( self.juggernautOverlay ) )
		self.juggernautOverlay destroy();
}

radarRemoveOnDisconnect()
{
	self endon( "jugg_removed" );
	level endon( "game_ended" );

	personalRadar = self.personalRadar;
	self waittill( "disconnect" );

	if ( isDefined( personalRadar ) )
	{
		level maps\mp\gametypes\_portable_radar::deletePortableRadar( personalRadar );
	}
}

setJuggManiac()
{
	self SetModel( "fullbody_juggernaut_c_mp" );
	self SetViewmodel( "viewhands_juggernaut_ally" );
	self SetClothType("cloth");}