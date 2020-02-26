#include maps\_utility;
#include common_scripts\utility;

preload()
{
	PrecacheModel( "veh_iw_drone_ugv_talon" );
	PrecacheModel( "veh_iw_drone_ugv_talon_gun" );
	
	level._turret_explode_fx = loadfx( "explosions/fx_exp_equipment_lg" );
	level._turret_disable_fx = loadfx ("weapon/grenade/fx_spark_disabled_weapon_lg");
	
	maps\sp_killstreaks\_killstreaks::registerKillstreak("talon_sp", "talon_sp", "killstreak_talon", "talon_used", ::useTalonKillstreak );
	maps\sp_killstreaks\_killstreaks::registerKillstreakStrings("talon_sp", &"KILLSTREAK_EARNED_TALON", &"KILLSTREAK_TALON_NOT_AVAILABLE");
//	maps\sp_killstreaks\_killstreaks::registerKillstreakDialog("autoturret_sp", "mpl_killstreak_auto_turret", "kls_turret_used", "","kls_turret_enemy", "", "kls_turret_drop");
//	maps\sp_killstreaks\_killstreaks::registerKillstreakDevDvar("autoturret_sp", "scr_giveautoturret");
	level.killStreakIcons["talon_sp"] = "hud_ks_talon";
	
}



//AUTO_TURRET_TIMEOUT = 90.0;
///////////////////////////////////////////////////////
//		talon Initialization Functions
///////////////////////////////////////////////////////
init()
{
	level.talon_headicon_offset = [];
	level.talon_headicon_offset["default"] = (0, 0, 70); 
}



///////////////////////////////////////////////////////
//		Talon Supply Drop Functions
///////////////////////////////////////////////////////
useKillstreakTalonDrop(hardpointType)
{
/*	if( self maps\sp_killstreaks\_supplydrop::isSupplyDropGrenadeAllowed(hardpointType) == false )
		return false;

	self thread maps\sp_killstreaks\_supplydrop::refCountDecChopperOnDisconnect();
	
	result = self maps\sp_killstreaks\_supplydrop::useSupplyDropMarker();
	
	self notify( "supply_drop_marker_done" );

	if ( !IsDefined(result) || !result )
	{
		return false;
	}

	return result;
*/
	return false;
}

useTalonKillstreak( hardpointType )
{
	if ( self maps\sp_killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;

	if ( self maps\sp_killstreaks\_killstreakrules::killstreakStart( hardpointType, self.team ) == false )
		return false;

	self thread useTalon( hardpointType );

	return true;
}


useTalon( hardpointType )
{

	//self maps\sp_killstreaks\_killstreaks::printKillstreakStartText( hardpointType, self, self.team );
	level.globalKillstreaksCalled++;
	//self AddWeaponStat( hardpointType, "used", 1 );

	//Setup the talon for carrying
	talon = spawn( "script_model" , (0,0,0) );
	talon SetModel( "veh_iw_drone_ugv_talon" );
	talon Attach( "veh_iw_drone_ugv_talon_gun", "tag_turret_attach", true);
		
	talon.hasBeenPlanted 	= false;	
	talon.hardPointWeapon  	= hardpointType;
	//Watch talon placement
	self thread updateTurretPlacement( talon );
	self thread watchTurretPlacement( talon );

	self waittill_any("talon_placed","talon_deactivated");
	self SetScriptHintString("" );
}

updateTurretPlacement( talon )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "talon_placed" );
	self endon( "talon_deactivated" );

	self SetCursorHint( "HINT_NOICON" );
	while( 1 )
	{
		position = self.origin;
		
		// TODO: do a trace so it doesn't go inside of walls
		forward = AnglesToForward( self.angles );
		position = position + VectorScale( forward, 100 );
		
		talon.origin = position;
		talon.angles = self.angles;// + (0,180,0);

		talon.canBePlaced = !(talon talonInHurtTrigger()) & !(talon talonInNoPlacementTrigger());
		self SetScriptHintString(&"KILLSTREAK_USE_TALON" );

		wait(0.05);
	}
}

watchTurretPlacement( talon )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "talon_placed" );
	self endon( "talon_deactivated" );

	while(1)
	{
		if( !talon.hasBeenPlanted && self [[level.ActionSlotPressed]]() )
		{
			self maps\sp_killstreaks\_killstreaks::giveKillstreak( talon.hardPointWeapon );
			talon Delete();
			self notify("talon_deactivated");
			break;
		}
	
		if( (self attackbuttonpressed() || self UseButtonPressed() ) && talon.canBePlaced )
		{
			self placeTalon( talon.origin );
			talon Delete();
			self notify ("talon_placed");
		}

		wait(0.05);
	}
}



//'Self' is the talon. Function checks to see if talon is in minefield or hurt trigger.
//level.fatal_triggers is defined in the init function.
talonInHurtTrigger()
{
	return false;
}

talonInNoPlacementTrigger()
{
	
	return false;

}


placeTalon(spawn_origin)
{
	const name = "ally_talon";
	
	talon_spawner = get_vehicle_spawner( name );
	assert( isdefined( talon_spawner ), "Invalid talon spawner targetname: " + name );
			
	if ( isdefined( spawn_origin ) )
		talon_spawner.origin = spawn_origin;

	talon = maps\_vehicle::spawn_vehicle_from_targetname( name );
	assert( isdefined( talon ), "talon failed to spawn." );
	
	talon.vteam = self.team;
	talon.hasBeenPlanted = true;
	
	offset = level.talon_headicon_offset[ "default" ];
	talon maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon( talon.team, self, offset, undefined, false, 1 ); //passing in player, player is used to create the client hud elm
	
	talon thread onDeath();
	
	
	return talon;
}

onDeath()
{
	self waittill("death");
	self maps\sp_killstreaks\_entityheadicons::destroyEntityHeadIcons();

}