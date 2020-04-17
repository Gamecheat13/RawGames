#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
 
init()
{
	level.teamPrefix["allies"] = "Brit";
	level.teamPrefix["axis"] = "Terr";
	
	level.isTeamSpeaking["allies"] = false;
	level.isTeamSpeaking["axis"] = false;
	
	level.speakers["allies"] = [];
	level.speakers["axis"] = [];
	
	level.bcSounds = [];
	level.bcSounds["reload"] = "reload";
	level.bcSounds["frag_out"] = "frag";
	level.bcSounds["flash_out"] = "flash";
	level.bcSounds["smoke_out"] = "smoke";
	level.bcSounds["tear_out"] = "tear";
	level.bcSounds["conc_out"] = "conc";
	level.bcSounds["c4_plant"] = "inform_attack_throwc4";
	level.bcSounds["pipebomb_plant"] = "US_Tmp_stm_plantc4";
	level.bcSounds["claymore_plant"] = "inform_attack_plantclaymore";
	level.bcSounds["proxmine_plant"] = "prox";
	level.bcSounds["ied_plant"] = "BOMB_ARM";
	level.bcSounds["kill"] = "kill";	// called from _globallogic.gsc (sayLocalSoundDelayed)

	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_team" );
	}
}


onJoinedSpectators()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_spectators" );
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
		self thread claymoreTracking();
		self thread proxmineTracking();
		self thread reloadTracking();
		self thread grenadeTracking();
	}
}


claymoreTracking()
{
	while(1)
	{
		self waittill( "begin_firing" );
		weaponName = self getCurrentWeapon();
		if ( weaponName == "claymore_mp" )
			level thread sayLocalSound( self, "claymore_plant" );
	}
}


proxmineTracking()
{
	while(1)
	{
		self waittill( "begin_firing" );
		weaponName = self getCurrentWeapon();
		if ( weaponName == "proxmine_mp" )
			level thread sayLocalSound( self, "proxmine_plant" );
	}
}


reloadTracking()
{
	for( ;; )
	{
		self waittill ( "reload_start" );
		level thread sayLocalSound( self, "reload" );
	}
}


grenadeTracking()
{
	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		
		if ( weaponName == "frag_grenade_mp" )
			level thread sayLocalSound( self, "frag_out" );
		else if ( weaponName == "flash_grenade_mp" )
			level thread sayLocalSound( self, "flash_out" );
		else if ( weaponName == "concussion_grenade_mp" )
			level thread sayLocalSound( self, "conc_out" );
		else if ( weaponName == "smoke_grenade_mp" )
			level thread sayLocalSound( self, "smoke_out" );
		else if ( weaponName == "tear_grenade_mp" )
			level thread sayLocalSound( self, "tear_out" );
		else if ( weaponName == "c4_mp" )
			level thread sayLocalSound( self, "c4_plant" );
		else if ( weaponName == "proxmine_mp" )
			level thread sayLocalSound( self, "proxmine_plant" );
	}
}


sayLocalSoundDelayed( player, soundType, delay )
{
	player endon ( "death" );
	player endon ( "disconnect" );
	
	wait ( delay );
	
	sayLocalSound( player, soundType );
}


sayLocalSound( player, soundType )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	if ( isSpeakerInRange( player ) )
		return;
		
	soundAlias = "MPB_" + level.teamPrefix[player.pers["team"]] + "_" + level.bcSounds[soundType];
	player thread doSound( soundAlias );
}


doSound( soundAlias )
{
	team = self.pers["team"];
	level addSpeaker( self, team );
	self playSoundToTeam( soundAlias, team, self );
	self thread timeHack( soundAlias ); // workaround because soundalias notify isn't happening
	self waittill_any_mp( soundAlias, "death", "disconnect" );
	level removeSpeaker( self, team );
}


timeHack( soundAlias )
{
	self endon ( "death" );
	self endon ( "disconnect" );

	wait ( 2.0 );
	self notify ( soundAlias );
}


isSpeakerInRange( player )
{
	player endon ( "death" );
	player endon ( "disconnect" );

	distSq = 1000 * 1000;

	for ( index = 0; index < level.speakers[player.pers["team"]].size; index++ )
	{
		teammate = level.speakers[player.pers["team"]][index];
		if ( teammate == player )
			return true;
			
		if ( distancesquared( teammate.origin, player.origin ) < distSq )
			return true;
	}

	return false;
}


addSpeaker( player, team )
{
	level.speakers[team][level.speakers[team].size] = player;
}


// this is lazy... fix up later by tracking ID's and doing array slot swapping
removeSpeaker( player, team )
{
	newSpeakers = [];
	for ( index = 0; index < level.speakers[team].size; index++ )
	{
		if ( level.speakers[team][index] == player )
			continue;
			
		newSpeakers[newSpeakers.size] = level.speakers[team][index]; 
	}
	
	level.speakers[team] = newSpeakers;
}
