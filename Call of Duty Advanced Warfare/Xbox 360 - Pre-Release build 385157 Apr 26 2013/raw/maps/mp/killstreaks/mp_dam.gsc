#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	level.killstreakFuncs[ "mp_dam" ] = maps\mp\killstreaks\mp_dam::tryUseDamKillstreak;
	
	SetDvarIfUninitialized( "scr_dam_killstreak_duration", 30 );
	
	PreCacheItem( "killstreak_dam_mp" );
	
	level.HUDItem = [];
	
	
	
	//Getting the railgun attach points. Adding them with distinct GetEnt() calls to ensure the array is populated in a particular order.
	level.railgun_attachpoints = [];
	
	railgun_script_origin = GetEnt( "railgun_attachpoint0", "targetname" );
	Assert( IsDefined( railgun_script_origin ) );
	level.railgun_attachpoints[ level.railgun_attachpoints.size ] = spawn_tag_origin();
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].origin = railgun_script_origin.origin;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].angles = railgun_script_origin.angles;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].thermal_vision = "ac130_thermal_mp";
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].enhanced_vision = "ac130_enhanced_mp";
	
	railgun_script_origin = GetEnt( "railgun_attachpoint1", "targetname" );
	Assert( IsDefined( railgun_script_origin ) );
	level.railgun_attachpoints[ level.railgun_attachpoints.size ] = spawn_tag_origin();
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].origin = railgun_script_origin.origin;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].angles = railgun_script_origin.angles;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].thermal_vision = "ac130_thermal_mp";
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].enhanced_vision = "ac130_enhanced_mp";
	
	railgun_script_origin = GetEnt( "railgun_attachpoint2", "targetname" );
	Assert( IsDefined( railgun_script_origin ) );
	level.railgun_attachpoints[ level.railgun_attachpoints.size ] = spawn_tag_origin();
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].origin = railgun_script_origin.origin;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].angles = railgun_script_origin.angles;
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].thermal_vision = "ac130_thermal_mp";
	level.railgun_attachpoints[ level.railgun_attachpoints.size - 1].enhanced_vision = "ac130_enhanced_mp";
	
	
	
	//Getting the railgun script_brushmodels. Adding them with distinct GetEnt() calls to ensure the array is populated in a particular order.
	level.railgun_cannons = [];
	level.railgun_swivels = [];
	
	level.railgun_cannons[ level.railgun_cannons.size ] = GetEnt( "railgun_cannon0", "targetname" );
	level.railgun_swivels[ level.railgun_swivels.size ] = GetEnt( "railgun_swivel0", "targetname" );
	
	level.railgun_cannons[ level.railgun_cannons.size ] = GetEnt( "railgun_cannon1", "targetname" );
	level.railgun_swivels[ level.railgun_swivels.size ] = GetEnt( "railgun_swivel1", "targetname" );
	
	level.railgun_cannons[ level.railgun_cannons.size ] = GetEnt( "railgun_cannon2", "targetname" );
	level.railgun_swivels[ level.railgun_swivels.size ] = GetEnt( "railgun_swivel2", "targetname" );
}


/*
=============
///ScriptDocBegin
"Name: tryUseDamKillstreak( <lifeId> )"
"Summary: the killstreak function added to level.killstreakFuncs[]."
"Module: Entity"
"CallOn: a player"
"MandatoryArg: <lifeId>: "
"Example: "
"SPMP: MP"
///ScriptDocEnd
=============
*/
tryUseDamKillstreak( lifeId )
{
	if ( isDefined( level.mp_dam_player ) )
	{
		self iPrintLnBold( &"MP_DAM_IN_USE" );
		return false;
	}
	
	if ( self isUsingRemote() )
	{
		return false;
	}
	
	if ( self isAirDenied() )
	{
		return false;
	}
	
	if ( self isEMPed() )
	{
		return false;
	}
	
	self setUsingRemote( "mp_dam" );
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak();
	if ( result != "success" )
	{
		if ( result != "disconnect" )
			self clearUsingRemote();

		return false;
	}
	
	result = setMPDamPlayer( self );
	
	// this needs to get set after we say the player is using it because this could get set to true and then they leave the game
	// this fixes a bug where a player calls it, leaves before getting fully in it and then no one else can call it because it thinks it's being used
	if( IsDefined( result ) && result )
	{
		self maps\mp\_matchdata::logKillstreakEvent( "mp_dam", self.origin );
	}
	else
	{
		self clearUsingRemote();
	}
	
	return result;
}


/*
=============
///ScriptDocBegin
"Name: setMPDamPlayer( <player> )"
"Summary: kicks off most of the script that controls mp_dam map killstreak functionality."
"Module: Entity"
"CallOn: NA"
"MandatoryArg: <player>: the player who is using the mp_dam map killstreak."
"Example: result = setMPDamPlayer( self );"
"SPMP: MP"
///ScriptDocEnd
=============
*/
setMPDamPlayer( player )
{
	self endon ( "mp_dam_player_removed" );
	
	if( IsDefined( level.mp_dam_player ) )
		return false;
	
	level.mp_dam_player = player;
	
	//The player will be attached to the 0th turret to start.
	player.current_railgun = 0;
	
	player openMenu( "ac130timer" );
	
	thread teamPlayerCardSplash( "used_mp_dam", player );
	
	// with the way we do visionsets we need to wait for the clearRideIntro() is done before we set thermal
	player thread waitSetThermal( 1.0 );

	if ( getDvarInt( "camera_thirdPerson" ) )
		player setThirdPersonDOF( false );
	
	//Taking the killstreak weapon (laptop)
	killstreakWeapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( "mp_dam" );
	player TakeWeapon( killstreakWeapon );
	player GiveWeapon( "mp_dam_railgun" );
	player SwitchToWeaponImmediate( "mp_dam_railgun" );
	
	player thread overlay( player );
	player thread shotFired();
	player thread attachPlayer();
	
	player thread rotateRailgun();
	
	player thread createMPDamHUDElems();
	
	player thread removeMPDamPlayerAfterTime( GetDvarInt( "scr_dam_killstreak_duration", 30 ) * player.killStreakScaler );
	player thread removeMPDamPlayerOnDisconnect();
	player thread removeMPDamPlayerOnChangeTeams();
	player thread removeMPDamPlayerOnSpectate();
	player thread removeMPDamPlayerOnGameCleanup();
	player thread removeMPDamPlayerOnCommand();
	
	return true;
}


/*
=============
///ScriptDocBegin
"Name: createMPDamHUDElems()"
"Summary: create additional hud elements for the mp_dam map killstreak."
"Module: Entity"
"CallOn: the player using the mp_dam map killstreak"
"Example: player thread createMPDamHUDElems()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
createMPDamHUDElems()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon ( "mp_dam_player_removed" );
	
	
	self thread createMPDamKillstreakClock();
	
	
	level.HUDItem[ "hud_reticle" ] = NewClientHudElem( self );
	level.HUDItem[ "hud_reticle" ].x = -15;
	level.HUDItem[ "hud_reticle" ].y = -15;
	level.HUDItem[ "hud_reticle" ].sort = 6;
	level.HUDItem[ "hud_reticle" ].horzalign = "center";
	level.HUDItem[ "hud_reticle" ].vertalign = "middle";
	level.HUDItem[ "hud_reticle" ] SetShader( "charged_shot_reticle", 30, 30 );
	
	
	
	//Toggle FLIR button instructions
	level.HUDItem[ "toggle_flir" ] = NewClientHudElem( self );
	level.HUDItem[ "toggle_flir" ].x = 150;
	level.HUDItem[ "toggle_flir" ].y = 150;
	level.HUDItem[ "toggle_flir" ].alignX = "left";
	level.HUDItem[ "toggle_flir" ].alignY = "middle";
	level.HUDItem[ "toggle_flir" ].horzAlign = "center";
	level.HUDItem[ "toggle_flir" ].vertAlign = "middle";
	level.HUDItem[ "toggle_flir" ].fontScale = 2.0;
	level.HUDItem[ "toggle_flir" ] SetText( "^3[{+activate}]^7 Toggle FLIR" );		//TODO: replace with localized string.
	level.HUDItem[ "toggle_flir" ].alpha = 1.0;
	
	
	
	//Early exit button instructions
	level.HUDItem[ "exit_early" ] = NewClientHudElem( self );
	level.HUDItem[ "exit_early" ].x = 150;
	level.HUDItem[ "exit_early" ].y = 170;
	level.HUDItem[ "exit_early" ].alignX = "left";
	level.HUDItem[ "exit_early" ].alignY = "middle";
	level.HUDItem[ "exit_early" ].horzAlign = "center";
	level.HUDItem[ "exit_early" ].vertAlign = "middle";
	level.HUDItem[ "exit_early" ].fontScale = 2.0;
	level.HUDItem[ "exit_early" ] SetText( "Hold A to exit" );		//TODO: replace with localized string with proper button icon.
	level.HUDItem[ "exit_early" ].alpha = 1.0;
	
	
	
	//Turret switch button instructions
	level.HUDItem[ "turret_change" ] = NewClientHudElem( self );
	level.HUDItem[ "turret_change" ].x = 150;
	level.HUDItem[ "turret_change" ].y = -130;
	level.HUDItem[ "turret_change" ].alignX = "left";
	level.HUDItem[ "turret_change" ].alignY = "middle";
	level.HUDItem[ "turret_change" ].horzAlign = "center";
	level.HUDItem[ "turret_change" ].vertAlign = "middle";
	level.HUDItem[ "turret_change" ].fontScale = 2.0;
	level.HUDItem[ "turret_change" ] SetText( "Press Y to switch turret" );		//TODO: replace with localized string with proper button icon.
	level.HUDItem[ "turret_change" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "status_message" ] = NewClientHudElem( self );
	level.HUDItem[ "status_message" ].x = 0;
	level.HUDItem[ "status_message" ].y = -160;
	level.HUDItem[ "status_message" ].alignX = "center";
	level.HUDItem[ "status_message" ].alignY = "middle";
	level.HUDItem[ "status_message" ].horzAlign = "center";
	level.HUDItem[ "status_message" ].vertAlign = "middle";
	level.HUDItem[ "status_message" ].fontScale = 1.0;
	level.HUDItem[ "status_message" ] SetText( "Energy Redirection In Progress" );		//TODO: replace with localized string.
	level.HUDItem[ "status_message" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "pitch_meter_bar" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_bar" ].x = 170;
	level.HUDItem[ "pitch_meter_bar" ].y = -75;
	level.HUDItem[ "pitch_meter_bar" ].sort = 6;
	level.HUDItem[ "pitch_meter_bar" ].horzalign = "center";
	level.HUDItem[ "pitch_meter_bar" ].vertalign = "middle";
	level.HUDItem[ "pitch_meter_bar" ] SetShader( "hudcolorbar", 10, 150 );		//TODO: hudcolorbar already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "pitch_meter_arrow" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_arrow" ].x = 150;
	level.HUDItem[ "pitch_meter_arrow" ].y = -85;
	level.HUDItem[ "pitch_meter_arrow" ].sort = 6;
	level.HUDItem[ "pitch_meter_arrow" ].horzalign = "center";
	level.HUDItem[ "pitch_meter_arrow" ].vertalign = "middle";
	level.HUDItem[ "pitch_meter_arrow" ] SetShader( "hud_killstreak_dpad_arrow_right", 20, 20 );		//TODO: hud_killstreak_dpad_arrow_right already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "pitch_meter_label" ] = NewClientHudElem( self );
	level.HUDItem[ "pitch_meter_label" ].x = 190;
	level.HUDItem[ "pitch_meter_label" ].y = 0;
	level.HUDItem[ "pitch_meter_label" ].alignX = "left";
	level.HUDItem[ "pitch_meter_label" ].alignY = "middle";
	level.HUDItem[ "pitch_meter_label" ].horzAlign = "center";
	level.HUDItem[ "pitch_meter_label" ].vertAlign = "middle";
	level.HUDItem[ "pitch_meter_label" ].fontScale = 2.0;
	level.HUDItem[ "pitch_meter_label" ] SetText( "PITCH" );		//TODO: replace with localized string.
	level.HUDItem[ "pitch_meter_label" ].alpha = 1.0;
	
	
	
	level.HUDItem[ "yaw_meter_bar" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_bar" ].x = -75;
	level.HUDItem[ "yaw_meter_bar" ].y = 170;
	level.HUDItem[ "yaw_meter_bar" ].sort = 6;
	level.HUDItem[ "yaw_meter_bar" ].horzalign = "center";
	level.HUDItem[ "yaw_meter_bar" ].vertalign = "middle";
	level.HUDItem[ "yaw_meter_bar" ] SetShader( "hudcolorbar", 150, 10 );		//TODO: hudcolorbar already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "yaw_meter_arrow" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_arrow" ].x = -85;
	level.HUDItem[ "yaw_meter_arrow" ].y = 150;
	level.HUDItem[ "yaw_meter_arrow" ].sort = 6;
	level.HUDItem[ "yaw_meter_arrow" ].horzalign = "center";
	level.HUDItem[ "yaw_meter_arrow" ].vertalign = "middle";
	level.HUDItem[ "yaw_meter_arrow" ] SetShader( "hud_killstreak_dpad_arrow_down", 20, 20 );		//TODO: hud_killstreak_dpad_arrow_down already lives in common_mp_materials.csv. Replace it with something new.
	
	level.HUDItem[ "yaw_meter_label" ] = NewClientHudElem( self );
	level.HUDItem[ "yaw_meter_label" ].x = 0;
	level.HUDItem[ "yaw_meter_label" ].y = 180;
	level.HUDItem[ "yaw_meter_label" ].alignX = "center";
	level.HUDItem[ "yaw_meter_label" ].alignY = "top";
	level.HUDItem[ "yaw_meter_label" ].horzAlign = "center";
	level.HUDItem[ "yaw_meter_label" ].vertAlign = "middle";
	level.HUDItem[ "yaw_meter_label" ].fontScale = 2.0;
	level.HUDItem[ "yaw_meter_label" ] SetText( "YAW" );		//TODO: replace with localized string.
	level.HUDItem[ "yaw_meter_label" ].alpha = 1.0;
	
	
	
	//Laser ground position.
	level.HUDItem[ "laser_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_pos_label" ].x = -170;
	level.HUDItem[ "laser_pos_label" ].y = -90;
	level.HUDItem[ "laser_pos_label" ].alignX = "right";
	level.HUDItem[ "laser_pos_label" ].alignY = "middle";
	level.HUDItem[ "laser_pos_label" ].horzAlign = "center";
	level.HUDItem[ "laser_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "laser_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "laser_pos_label" ] SetText( "Focus" );		//TODO: replace with localized string.
	level.HUDItem[ "laser_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posx" ].x = -170;
	level.HUDItem[ "laser_posx" ].y = -80;
	level.HUDItem[ "laser_posx" ].alignX = "right";
	level.HUDItem[ "laser_posx" ].alignY = "middle";
	level.HUDItem[ "laser_posx" ].horzAlign = "center";
	level.HUDItem[ "laser_posx" ].vertAlign = "middle";
	level.HUDItem[ "laser_posx" ].fontScale = 1.0;
	level.HUDItem[ "laser_posx" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posy" ].x = -170;
	level.HUDItem[ "laser_posy" ].y = -70;
	level.HUDItem[ "laser_posy" ].alignX = "right";
	level.HUDItem[ "laser_posy" ].alignY = "middle";
	level.HUDItem[ "laser_posy" ].horzAlign = "center";
	level.HUDItem[ "laser_posy" ].vertAlign = "middle";
	level.HUDItem[ "laser_posy" ].fontScale = 1.0;
	level.HUDItem[ "laser_posy" ].alpha = 1.0;
	
	level.HUDItem[ "laser_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "laser_posz" ].x = -170;
	level.HUDItem[ "laser_posz" ].y = -60;
	level.HUDItem[ "laser_posz" ].alignX = "right";
	level.HUDItem[ "laser_posz" ].alignY = "middle";
	level.HUDItem[ "laser_posz" ].horzAlign = "center";
	level.HUDItem[ "laser_posz" ].vertAlign = "middle";
	level.HUDItem[ "laser_posz" ].fontScale = 1.0;
	level.HUDItem[ "laser_posz" ].alpha = 1.0;
	
	
	
	// aiming position
	level.HUDItem[ "aim_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_pos_label" ].x = -170;
	level.HUDItem[ "aim_pos_label" ].y = -25;
	level.HUDItem[ "aim_pos_label" ].alignX = "right";
	level.HUDItem[ "aim_pos_label" ].alignY = "middle";
	level.HUDItem[ "aim_pos_label" ].horzAlign = "center";
	level.HUDItem[ "aim_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "aim_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "aim_pos_label" ] SetText( "Target" );		//TODO: replace with localized string.
	level.HUDItem[ "aim_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posx" ].x = -170;
	level.HUDItem[ "aim_posx" ].y = -15;
	level.HUDItem[ "aim_posx" ].alignX = "right";
	level.HUDItem[ "aim_posx" ].alignY = "middle";
	level.HUDItem[ "aim_posx" ].horzAlign = "center";
	level.HUDItem[ "aim_posx" ].vertAlign = "middle";
	level.HUDItem[ "aim_posx" ].fontScale = 1.0;
	level.HUDItem[ "aim_posx" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posy" ].x = -170;
	level.HUDItem[ "aim_posy" ].y = -5;
	level.HUDItem[ "aim_posy" ].alignX = "right";
	level.HUDItem[ "aim_posy" ].alignY = "middle";
	level.HUDItem[ "aim_posy" ].horzAlign = "center";
	level.HUDItem[ "aim_posy" ].vertAlign = "middle";
	level.HUDItem[ "aim_posy" ].fontScale = 1.0;
	level.HUDItem[ "aim_posy" ].alpha = 1.0;
	
	level.HUDItem[ "aim_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "aim_posz" ].x = -170;
	level.HUDItem[ "aim_posz" ].y = 5;
	level.HUDItem[ "aim_posz" ].alignX = "right";
	level.HUDItem[ "aim_posz" ].alignY = "middle";
	level.HUDItem[ "aim_posz" ].horzAlign = "center";
	level.HUDItem[ "aim_posz" ].vertAlign = "middle";
	level.HUDItem[ "aim_posz" ].fontScale = 1.0;
	level.HUDItem[ "aim_posz" ].alpha = 1.0;
	
	
	
	// player position
	level.HUDItem[ "player_pos_label" ] = NewClientHudElem( self );
	level.HUDItem[ "player_pos_label" ].x = -170;
	level.HUDItem[ "player_pos_label" ].y = 50;
	level.HUDItem[ "player_pos_label" ].alignX = "right";
	level.HUDItem[ "player_pos_label" ].alignY = "middle";
	level.HUDItem[ "player_pos_label" ].horzAlign = "center";
	level.HUDItem[ "player_pos_label" ].vertAlign = "middle";
	level.HUDItem[ "player_pos_label" ].fontScale = 1.0;
	level.HUDItem[ "player_pos_label" ] SetText( "Operator" );		//TODO: replace with localized string.
	level.HUDItem[ "player_pos_label" ].alpha = 1.0;
	
	level.HUDItem[ "player_posx" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posx" ].x = -170;
	level.HUDItem[ "player_posx" ].y = 60;
	level.HUDItem[ "player_posx" ].alignX = "right";
	level.HUDItem[ "player_posx" ].alignY = "middle";
	level.HUDItem[ "player_posx" ].horzAlign = "center";
	level.HUDItem[ "player_posx" ].vertAlign = "middle";
	level.HUDItem[ "player_posx" ].fontScale = 1.0;
	level.HUDItem[ "player_posx" ].alpha = 1.0;

	level.HUDItem[ "player_posy" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posy" ].x = -170;
	level.HUDItem[ "player_posy" ].y = 70;
	level.HUDItem[ "player_posy" ].alignX = "right";
	level.HUDItem[ "player_posy" ].alignY = "middle";
	level.HUDItem[ "player_posy" ].horzAlign = "center";
	level.HUDItem[ "player_posy" ].vertAlign = "middle";
	level.HUDItem[ "player_posy" ].fontScale = 1.0;
	level.HUDItem[ "player_posy" ].alpha = 1.0;
	
	level.HUDItem[ "player_posz" ] = NewClientHudElem( self );
	level.HUDItem[ "player_posz" ].x = -170;
	level.HUDItem[ "player_posz" ].y = 80;
	level.HUDItem[ "player_posz" ].alignX = "right";
	level.HUDItem[ "player_posz" ].alignY = "middle";
	level.HUDItem[ "player_posz" ].horzAlign = "center";
	level.HUDItem[ "player_posz" ].vertAlign = "middle";
	level.HUDItem[ "player_posz" ].fontScale = 1.0;
	level.HUDItem[ "player_posz" ].alpha = 1.0;
	
	level.HUDItem[ "player_posx" ] SetValue( abs( self.origin[0] ) );
	level.HUDItem[ "player_posy" ] SetValue( abs( self.origin[1] ) );
	level.HUDItem[ "player_posz" ] SetValue( abs( self.origin[2] ) );
	
	
	
	wait 0.05;
	
	while (1)
	{
//		level.HUDItem[ "aim_posx" ] SetValue( self.cam_view_ground_point.origin[0] );
//		level.HUDItem[ "aim_posy" ] SetValue( self.cam_view_ground_point.origin[1] );
//		level.HUDItem[ "aim_posz" ] SetValue( self.cam_view_ground_point.origin[2] );
		
		wait(0.05);
	}
}


/*
=============
///ScriptDocBegin
"Name: createMPDamKillstreakClock()"
"Summary: HUD clock for mp_dam map-based killstreak duration."
"Module: Entity"
"CallOn: the player using the mp_dam map-based killstreak."
"Example: player thread createMPDamKillstreakClock()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
createMPDamKillstreakClock()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon ( "mp_dam_player_removed" );
	
	self.dam_clock = maps\mp\gametypes\_hud_util::createTimer( "hudsmall", 0.9 );
	self.dam_clock maps\mp\gametypes\_hud_util::setPoint( "CENTER", "CENTER", 0, -145 );
	self.dam_clock setTimer( GetDvarFloat( "scr_dam_killstreak_duration", 30.0 ) );
	self.dam_clock.color = ( 1.0, 1.0, 1.0 );
	self.dam_clock.archived = false;
	self.dam_clock.foreground = true;
	
	self thread destroyMPDamKillstreakClock();
}


/*
=============
///ScriptDocBegin
"Name: destroyMPDamKillstreakClock()"
"Summary: cleans up the timer for the mp_dam map-based killstreak HUD."
"Module: Entity"
"CallOn: the player using the mp_dam map-based killstreak."
"Example: player thread destroyMPDamKillstreakClock()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
destroyMPDamKillstreakClock()
{
	self waittill( "mp_dam_player_removed" );
	
	if ( IsDefined( self.dam_clock ) )
	{
		self.dam_clock Destroy();
	}
}


waitSetThermal( delay )
{
	self endon( "disconnect" );
	level endon( "mp_dam_player_removed" );

	wait( delay	);

	self VisionSetThermalForPlayer( game["thermal_vision"], 0 );
	self ThermalVisionFOFOverlayOn();
	self thread thermalVision();
}


/*
=============
///ScriptDocBegin
"Name: removeMPDamPlayerOnCommand()"
"Summary: removes the dam killstreak player if the player holds down the exit button"
"Module: Entity"
"CallOn: the player controlling the dam map killstreak"
"Example: player thread removeMPDamPlayerOnCommand()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
removeMPDamPlayerOnCommand()
{
	self endon ( "mp_dam_player_removed" );
	
	while ( true )
	{
		button_hold_time = 0;
		while ( self JumpButtonPressed() )
		{
			button_hold_time += 0.05;
			if ( button_hold_time > 0.75 )
			{
				level thread removeMPDamPlayer( self, false );
				return;
			}
			wait(0.05);
		}
		wait(0.05);
	}
}


removeMPDamPlayerOnGameCleanup()
{
	self endon ( "mp_dam_player_removed" );
	
	level waittill ( "game_cleanup" );

	level thread removeMPDamPlayer( self, false );
}


removeMPDamPlayerOnDeath()
{
	self endon ( "mp_dam_player_removed" );
	
	self waittill ( "death" );

	level thread removeMPDamPlayer( self, false );
}


removeMPDamPlayerOnDisconnect()
{
	self endon ( "mp_dam_player_removed" );

	self waittill ( "disconnect" );

	level thread removeMPDamPlayer( self, true );
}


removeMPDamPlayerOnChangeTeams()
{
	self endon ( "mp_dam_player_removed" );

	self waittill ( "joined_team" );

	level thread removeMPDamPlayer( self, false);
}


removeMPDamPlayerOnSpectate()
{
	self endon ( "mp_dam_player_removed" );

	self waittill_any ( "joined_spectators", "spawned" );

	level thread removeMPDamPlayer( self, false);
}


removeMPDamPlayerAfterTime( removeDelay )
{
	self endon ( "mp_dam_player_removed" );
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( removeDelay );
	
	level thread removeMPDamPlayer( self, false );
}


removeMPDamPlayer( player, disconnected )
{
	player notify ( "mp_dam_player_removed" );
	level notify ( "mp_dam_player_removed" );
	
	waittillframeend;
	
	if ( !disconnected )
	{
		//Take the railgun.
		player TakeWeapon( "mp_dam_railgun" );
		
		player clearUsingRemote();
		
		player show();
		player unlink();
		
		player ThermalVisionOff();
		player ThermalVisionFOFOverlayOff();
		player VisionSetThermalForPlayer( level.railgun_attachpoints[ player.current_railgun ].thermal_vision, 0 );
		player.lastVisionSetThermal = level.railgun_attachpoints[ player.current_railgun ].thermal_vision;
		player setBlurForPlayer( 0, 0 );

		if ( getDvarInt( "camera_thirdPerson" ) )
			player setThirdPersonDOF( true );

		if ( isDefined( player.darkScreenOverlay ) )
			player.darkScreenOverlay destroy();	

		keys = getArrayKeys( level.HUDItem );
		
		foreach ( key in keys )
		{
			level.HUDItem[key] destroy();
			level.HUDItem[key] = undefined;
		}
	}
	
	// TODO: this might already be undefined if the player disconnected... need a better solution.
	// we could set it to "true" or something... but we'll have to check places it is used for potential issues with that.
	level.mp_dam_player = undefined;

	wait ( 30.0 );
}


overlay( player )
{
	level.HUDItem[ "thermal_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "thermal_vision" ].x = 200;
	level.HUDItem[ "thermal_vision" ].y = 0;
	level.HUDItem[ "thermal_vision" ].alignX = "left";
	level.HUDItem[ "thermal_vision" ].alignY = "top";
	level.HUDItem[ "thermal_vision" ].horzAlign = "left";
	level.HUDItem[ "thermal_vision" ].vertAlign = "top";
	level.HUDItem[ "thermal_vision" ].fontScale = 2.5;
	level.HUDItem[ "thermal_vision" ] SetText( &"AC130_HUD_FLIR" );
	level.HUDItem[ "thermal_vision" ].alpha = 1.0;

	level.HUDItem[ "enhanced_vision" ] = NewClientHudElem( player );
	level.HUDItem[ "enhanced_vision" ].x = -200;
	level.HUDItem[ "enhanced_vision" ].y = 0;
	level.HUDItem[ "enhanced_vision" ].alignX = "right";
	level.HUDItem[ "enhanced_vision" ].alignY = "top";
	level.HUDItem[ "enhanced_vision" ].horzAlign = "right";
	level.HUDItem[ "enhanced_vision" ].vertAlign = "top";
	level.HUDItem[ "enhanced_vision" ].fontScale = 2.5;
	level.HUDItem[ "enhanced_vision" ] SetText( &"AC130_HUD_OPTICS" );
	level.HUDItem[ "enhanced_vision" ].alpha = 1.0;
	
	player setBlurForPlayer( 1.2, 0 );
}


attachPlayer()
{
	self endon ( "mp_dam_player_removed" );
	
	self PlayerLinkWeaponviewToDelta( level.railgun_attachpoints[ self.current_railgun ], "tag_player", 1.0, 80, 70, 100, 20 );
	self setPlayerAngles( level.railgun_attachpoints[ self.current_railgun ] getTagAngles( "tag_player" ) );
	
	self NotifyOnPlayerCommand( "switch_turret", "weapnext" );
	
	while( 1 )
	{
		self waittill( "switch_turret" );
		
		self.current_railgun++;
		if ( self.current_railgun > 2 )
		{
			self.current_railgun = 0;
		}
		
		self Unlink();
		self PlayerLinkWeaponViewToDelta( level.railgun_attachpoints[ self.current_railgun ], "tag_player", 1.0, 80, 70, 100, 20 );
		self setPlayerAngles( level.railgun_attachpoints[ self.current_railgun ] getTagAngles( "tag_player" ) );
		
		wait( 0.05 );
	}
}


thermalVision()
{
	self endon ( "mp_dam_player_removed" );
	
	if ( getIntProperty( "ac130_thermal_enabled", 1 ) == 0 )
		return;
	
	inverted = false;
	
	self ThermalVisionOff();
	self VisionSetThermalForPlayer( level.railgun_attachpoints[ self.current_railgun ].enhanced_vision, 1 );
	self.lastVisionSetThermal = level.railgun_attachpoints[ self.current_railgun ].enhanced_vision;
	level.HUDItem["thermal_vision"].alpha = 0.25;
	level.HUDItem["enhanced_vision"].alpha = 1.0;

	self notifyOnPlayerCommand( "switch thermal", "+usereload" );
	self notifyOnPlayerCommand( "switch thermal", "+activate" );

	for (;;)
	{
		self waittill ( "switch thermal" );
		
		if ( !inverted )
		{
			self ThermalVisionOn();
			self VisionSetThermalForPlayer( level.railgun_attachpoints[ self.current_railgun ].thermal_vision, 0.62 );
			self.lastVisionSetThermal = level.railgun_attachpoints[ self.current_railgun ].thermal_vision;
			level.HUDItem["thermal_vision"].alpha = 1.0;
			level.HUDItem["enhanced_vision"].alpha = 0.25;
		}
		else
		{
			self ThermalVisionOff();
			self VisionSetThermalForPlayer( level.railgun_attachpoints[ self.current_railgun ].enhanced_vision, 0.51 );
			self.lastVisionSetThermal = level.railgun_attachpoints[ self.current_railgun ].enhanced_vision;
			level.HUDItem["thermal_vision"].alpha = 0.25;
			level.HUDItem["enhanced_vision"].alpha = 1.0;
		}

		inverted = !inverted;
	}
}


shotFired()
{
	self endon ( "mp_dam_player_removed" );
	
	for (;;)
	{
		self waittill( "projectile_impact", weaponName, position, radius );
		
		if ( weaponName == "mp_dam_railgun" )
		{
			earthquake( 0.4, 1.0, position, 3500 );
			self thread shotFiredDarkScreenOverlay();
		}
		
		if ( getIntProperty( "ac130_ragdoll_deaths", 0 ) )
			thread shotFiredPhysicsSphere( position, weaponName );
		
		wait 0.05;
	}
}


shotFiredPhysicsSphere( center, weapon )
{
	wait( 0.1 );
	physicsExplosionSphere( center, level.physicsSphereRadius[ weapon ], level.physicsSphereRadius[ weapon ] / 2, level.physicsSphereForce[ weapon ] );
}


shotFiredDarkScreenOverlay()
{
	self endon( "mp_dam_player_removed" );
	self notify( "darkScreenOverlay" );
	self endon( "darkScreenOverlay" );
	
	if ( !isdefined( self.darkScreenOverlay ) )
	{
		self.darkScreenOverlay = NewClientHudElem( self );
		self.darkScreenOverlay.x = 0;
		self.darkScreenOverlay.y = 0;
		self.darkScreenOverlay.alignX = "left";
		self.darkScreenOverlay.alignY = "top";
		self.darkScreenOverlay.horzAlign = "fullscreen";
		self.darkScreenOverlay.vertAlign = "fullscreen";
		self.darkScreenOverlay setshader ( "black", 640, 480 );
		self.darkScreenOverlay.sort = -10;
		self.darkScreenOverlay.alpha = 0.0;
	}
	
	self.darkScreenOverlay.alpha = 0.0;
	self.darkScreenOverlay fadeOverTime( 0.2 );
	self.darkScreenOverlay.alpha = 0.6;
	wait 0.4;
	self.darkScreenOverlay fadeOverTime( 0.8 );
	self.darkScreenOverlay.alpha = 0.0;
}


/*
=============
///ScriptDocBegin
"Name: rotateRailgun()"
"Summary: rotates the railgun and script_origin based on the user's viewangle"
"Module: Entity"
"CallOn: a player"
"Example: thread player rotateRailgun()"
"SPMP: MP"
///ScriptDocEnd
=============
*/
rotateRailgun()
{
	self endon( "mp_dam_player_removed" );
	
	while ( 1 )
	{
		//Rotating the railgun
		level.railgun_cannons[ self.current_railgun ].angles = self GetPlayerAngles();
		//Rotating the railgun swivel
		temp_angle_vec = ( 0, level.railgun_cannons[ self.current_railgun ].angles[1], 0 );
		level.railgun_swivels[ self.current_railgun ].angles = temp_angle_vec;
		
		//Moving the script_origin to which the player is attached. It moves with the railgun.
		forward = AnglesToForward( level.railgun_cannons[ self.current_railgun ].angles );
		normal_forward = VectorNormalize( forward );
		level.railgun_attachpoints[ self.current_railgun ].origin = level.railgun_cannons[ self.current_railgun ].origin + normal_forward * 350;
		
		wait( 0.05 );
	}
}
