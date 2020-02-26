#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;

init()
{
	PreCacheString( &"ZOMBIE_BUILDING" );
	PreCacheString( &"ZOMBIE_BUILD_PIECE_MISSING" );
	PreCacheString( &"ZOMBIE_BUILD_PIECE_GRAB" );
	
	// Allow Players To Swap Carry Pieces
	//-----------------------------------
	level.gameObjSwapping = true;
	
	zombie_buildables_callbacks = [];

	level.buildablePickUps = [];
	level.buildables_built = [];
	
	init_buildables();
}

init_buildables()
{
	// Weapons
	//--------
	add_zombie_buildable( "riotshield_zm", &"ZOMBIE_BUILD_RIOT" );
	add_zombie_buildable( "jetgun_zm", &"ZOMBIE_BUILD_JETGUN" );
	add_zombie_buildable( "turret", &"ZOMBIE_BUILD_TURRET" );
	
	// Traps
	//------
	add_zombie_buildable( "electric_trap", &"ZOMBIE_BUILD_ELECTRIC_TRAP" );

	// Upgrades
	//---------
	add_zombie_buildable( "cattlecatcher", &"ZOMBIE_BUILD_CATTLE_CATCHER" );
	add_zombie_buildable( "bushatch", &"ZOMBIE_BUILD_BUSHATCH" );
	
	// PowerSwitch
	//------------
	add_zombie_buildable( "powerswitch", &"ZOMBIE_BUILD_POWER_SWITCH" );
	
	// Machines
	//---------
	add_zombie_buildable( "pap", &"ZOMBIE_BUILD_PAP" );
	
	// Misc
	//-----
	add_zombie_buildable( "turbine", &"ZOMBIE_BUILD_TURBINE" );
}

add_zombie_buildable( buildable_name, hint )
{
	if ( !IsDefined( level.zombie_include_buildables ) )
	{
		level.zombie_include_buildables = [];
	}
	
	if( IsDefined( level.zombie_include_buildables ) && !IsDefined( level.zombie_include_buildables[ buildable_name ] ) )
	{
		return;
	}

	PrecacheString( hint );

	buildable_struct = level.zombie_include_buildables[ buildable_name ];

	if( !IsDefined( level.zombie_buildables ) )
	{
		level.zombie_buildables = [];
	}

	buildable_struct.hint = hint;

/#	PrintLn( "ZM >> Looking for buildable - " + buildable_struct.name );	#/

	level.zombie_buildables[ buildable_struct.name ] = buildable_struct;
}

include_zombie_buildable( buiildable_struct )
{
	if ( !IsDefined( level.zombie_include_buildables ) )
	{
		level.zombie_include_buildables = [];
	}

/#	PrintLn( "ZM >> Including buildable - " + buiildable_struct.name );		#/

	level.zombie_include_buildables[ buiildable_struct.name ] = buiildable_struct;
}

create_zombie_buildable_piece( modelName, radius, height, hud_icon )
{
	PreCacheModel( modelName );
	
	if ( IsDefined( hud_icon ) )
	{
		PreCacheShader( hud_icon );
	}
	
	buildable_pieces = [];

	buildable_pieces_structs = getstructarray( self.name + "_" + modelName, "targetname" );

	foreach( index, struct in buildable_pieces_structs )
	{
		buildable_pieces[ modelName ][ index ] = struct;
		buildable_pieces[ modelName ][ index ].hasSpawned = false;
		buildable_pieces[ modelName ][ index ].modelName = modelName;
		buildable_pieces[ modelName ][ index ].hud_icon = hud_icon;
		buildable_pieces[ modelName ][ index ].radius = radius;
		buildable_pieces[ modelName ][ index ].height = height;
	}

	if ( !IsDefined( self.buildablePieces ) )
	{
		self.buildablePieces = [];
	}

	self.buildablePieces = ArrayCombine( self.buildablePieces, buildable_pieces, true, false );
}

buildable_think( buildable_name )
{
	Assert( IsDefined( buildable_name ) );
	Assert( IsDefined( level.zombie_buildables[ buildable_name ] ), "Called buildable_think() without including the buildable - " + buildable_name );

	// Grab Buildable
	//---------------
	buildable = level.zombie_buildables[ buildable_name ];
	
	// Randomize Array Of Piece Locations
	//-----------------------------------
	if ( !isdefined(buildable.buildablePieces) )
		buildable.buildablePieces=[];

	foreach ( buildablePieceModelArray in buildable.buildablePieces )
	{
		buildablePieceModelArray = array_randomize( buildablePieceModelArray );
	}
	
	// Need To Wait For Some Scripts To Be Set Up Before Proceeding, Best Case Notify
	//-------------------------------------------------------------------------------
	flag_wait( "start_zombie_round_logic" );
	
	// Create The Use Object Earlier To Store It On Carry Objects
	//-----------------------------------------------------------
	visuals[ 0 ] = Spawn( "script_model", self.origin );
	visuals[ 0 ] SetModel( "tag_origin" );
	
	self SetInvisibleToAll();
	
	buildableZone = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", self, visuals, ( 0, 0, 32 ) );

	// Create A Carry Objects (One Per Each Type Currently)
	//----------------------------------------------------
	buildablePickUps = [];
	
	foreach( buildablePieceModelArray in buildable.buildablePieces )
	{
		randomIndex = 0;
		if ( buildablePieceModelArray.size > 1 )
		{
			randomIndex = RandomInt( buildablePieceModelArray.size );
		}
		
		trigger = Spawn( "trigger_radius_use", buildablePieceModelArray[ randomIndex ].origin, 0, buildablePieceModelArray[ randomIndex ].radius, buildablePieceModelArray[ randomIndex ].height );
		trigger SetCursorHint( "HINT_NOICON" );
		trigger SetHintString( &"ZOMBIE_BUILD_PIECE_GRAB" );
		trigger TriggerIgnoreTeam();
		trigger EnableLinkTo();

		if ( !IsDefined( buildablePieceModelArray[ randomIndex ].angles ) )
		{
			buildablePieceModelArray[ randomIndex ].angles = ( 0, 0, 0 );
		}

		visuals[ 0 ] = Spawn( "script_model", buildablePieceModelArray[ randomIndex ].origin );
		visuals[ 0 ].angles = buildablePieceModelArray[ randomIndex ].angles;
		visuals[ 0 ] SetModel( buildablePieceModelArray[ randomIndex ].modelName );
		visuals[ 0 ].hud_icon = buildablePieceModelArray[ randomIndex ].hud_icon;

		buildablePickUp = maps\mp\gametypes\_gameobjects::createCarryObject( "neutral", trigger, visuals, ( 0, 0, 32 ) );
		buildablePickUp maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		buildablePickUp.allowWeapons = true;
		buildablePickUp.onPickup = ::onPickup;
		buildablePickUp.onDrop = ::onDrop;
		buildablePickUp.swappable = true;

		buildablePickUp.buildableStruct = buildable;
		buildablepickUp.buildableZone = buildableZone;

		buildablePickUps[ buildablePickUps.size ] = buildablePickUp;
	}
	
	ARRAY_ADD( level.buildablePickUps, buildablePickUps );

	// Create A Use Object On Trigger
	//-------------------------------	
	buildableZone maps\mp\gametypes\_gameobjects::allowUse( "any" );
	buildableZone maps\mp\gametypes\_gameobjects::setUseTime( 3 );
	buildableZone maps\mp\gametypes\_gameobjects::setUseText( &"ZOMBIE_BUILDING" );
	buildableZone maps\mp\gametypes\_gameobjects::setUseHintText( get_buildable_hint( buildable_name ) );
	foreach ( buildablePickUp in buildablePickUps )
	{
		buildableZone maps\mp\gametypes\_gameobjects::setKeyObject( buildablePickUp );
	}
	label = buildableZone maps\mp\gametypes\_gameobjects::getLabel();
	buildableZone.label = label;
	buildableZone.pieces = buildablePickUps.size;
	buildableZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	buildableZone.onBeginUse = ::onBeginUse;
	buildableZone.onEndUse = ::onEndUse;
	buildableZone.onUse = ::onUsePlantObject;
	buildableZone.onCantUse = ::onCantUse;
	buildableZone.dontLinkPlayerToTrigger = true;
	
	buildableZone.buildableStruct = buildable;
	buildable.buildableZone = buildableZone;

	// Wait For Notify When Buildable Has Been Built, Resume Home Script That Called This Function To Bring Purchaseable Online
	//-------------------------------------------------------------------------------------------------------------------------
	buildableZone waittill( "built", player );
	
	PlaySoundAtPosition( "zmb_buildable_complete_npc", player.origin );

	level.buildables_built[ buildable_name ] = true;
	
	level notify( buildable_name + "_built" );

	// Return Player Who Built Last Piece
	//-----------------------------------
	return player;
}

is_buildable()
{
	// No Buildables Set Up In Map
	//----------------------------
	if ( !IsDefined( level.zombie_buildables ) )
	{
		return false;
	}
	
	// WallBuys
	//---------
	if ( IsDefined( self.zombie_weapon_upgrade ) && IsDefined( level.zombie_buildables[ self.zombie_weapon_upgrade ] ) )
	{
		return true;
	}
	
	// Machines
	//---------
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "specialty_weapupgrade" )
	{
		if ( is_true( level.buildables_built[ "pap" ] ) )
		{
			return false;
		}

		return true;
	}

	return false;
}

buildable_crafted()
{
	self.pieces--;
}

buildable_complete()
{
	if ( self.pieces <= 0 )
	{
		return true;
	}

	return false;
}

onPickup( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece recovered by - " + player.name );
	}
	#/

	if ( IsDefined( player ) && IsDefined( self.visuals[ 0 ].hud_icon ) )
	{
		player.buildable_hud_icon = player maps\mp\zombies\_zm_sidequests::create_icon( self.visuals[ 0 ].hud_icon, -225 + 34 );
	}

	if ( IsDefined( self.buildableStruct.onPickup ) )
	{
		self [[ self.buildableStruct.onPickup ]]( player );
	}
	
	if ( IsDefined( self.buildableZone.trigger ) )
	{
		self.buildableZone.trigger SetVisibleToPlayer( player );
	}
}

onDrop( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece dropped by - " + player.name );
	}
	#/

	if ( IsDefined( player.buildable_hud_icon ) )
	{
		player.buildable_hud_icon Destroy();
	}
		
	if ( IsDefined( self.buildableStruct.onDrop ) )
	{
		self [[ self.buildableStruct.onDrop ]]( player );
	}
	
	if ( IsDefined( self.buildableZone.trigger ) )
	{
		self.buildableZone.trigger SetInvisibleToPlayer( player );
	}

	player notify( "event_ended" );
}

onBeginUse( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece begin use by - " + player.name );
	}
	#/
	
	if ( IsDefined( self.buildableStruct.onBeginUse ) )
	{
		self [[ self.buildableStruct.onBeginUse ]]( player );
	}
	
	self.trigger PlayLoopSound( "zmb_buildable_loop_npc" );
}

onEndUse( team, player, result )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece end use by - " + player.name );
	}
	#/

	self.trigger StopLoopSound();

	if ( !IsDefined( player ) )
	{
		return;
	}
	
	if ( IsDefined( self.buildableStruct.onEndUse ) )
	{
		self [[ self.buildableStruct.onEndUse ]]( team, player, result );
	}

	player notify( "event_ended" );
}

onCantUse( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece can't use by - " + player.name );
	}
	#/
	
	if ( IsDefined( self.buildableStruct.onCantUse ) )
	{
		self [[ self.buildableStruct.onCantUse ]]( player );
	}
	
	player IPrintLnBold( &"ZOMBIE_BUILD_PIECE_MISSING" );
}

onUsePlantObject( player )
{
	/#
	if ( IsDefined( player ) && IsDefined( player.name ) )
	{
		PrintLn( "ZM >> Buildable piece crafted by - " + player.name );
	}
	#/
	
	if ( IsDefined( player.buildable_hud_icon ) )
	{
		player.buildable_hud_icon Destroy();
	}
	
	self buildable_crafted();
	
	if ( IsDefined( self.buildableStruct.onUsePlantObject ) )
	{
		self [[ self.buildableStruct.onUsePlantObject ]]( player );
	}

	//* player playSound( "mpl_sd_bomb_plant" );
	player notify ( "bomb_planted" );

	if ( IsDefined( player.carryObject ) )
	{
		player.carryObject thread maps\mp\gametypes\_gameobjects::destroyObject( true );	// Destroy Carry Object, Delete Trigger
	}

	if ( self buildable_complete() )
	{
		self notify( "built", player );
		
		if ( IsDefined( self.trigger ) )
		{
			self.trigger SetVisibleToAll();
		}

		self thread maps\mp\gametypes\_gameobjects::destroyObject( false );	// Destroy Use Object, Keep Trigger For Purchaseable
	}
	else
	{
		if ( IsDefined( self.trigger ) )
		{
			self.trigger SetInvisibleToPlayer( player );
		}
	}
}

get_buildable_hint( buildable_name )
{
	assert( IsDefined( level.zombie_buildables[ buildable_name ] ), buildable_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_buildables[ buildable_name ].hint;
}

delete_on_disconnect( buildable, self_notify, skip_delete )
{
	buildable endon( "death" );
	
	self waittill( "disconnect" );
	
	if ( IsDefined( self_notify ) )
	{
		self notify( self_notify );
	}
	
	if ( !is_true( skip_delete ) )
	{
		if ( IsDefined( buildable ) )
		{
			buildable Delete();
		}
	}
}

get_buildable_pickup( buildableName, modelName )
{
	foreach ( buildablePickUp in level.buildablePickUps )
	{
		if ( buildablePickUp[ 0 ].buildableStruct.name == buildableName && buildablePickUp[ 0 ].visuals[ 0 ].model == modelName )
		{
			return buildablePickUp[ 0 ];
		}
	}
	
	return undefined;
}