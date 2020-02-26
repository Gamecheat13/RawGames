#include clientscripts\mp\_utility; 
#include clientscripts\mp\_fx;
#include clientscripts\mp\zombies\_zm_utility;

init_filter_indices()
{
	if ( isdefined( level.genericfilterinitialized ) ) // only need to do this once...
		return;
		
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.genericfilterinitialized = true;
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.filter_matcount = 4; // First two slots are reserved for the regular and infrared ADS scope filters
	
	// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

	level.targetid_none		 = 0;
	level.targerid_small0	 = 1;
	level.targerid_small1	 = 2;
	level.targerid_scene	 = 3;
	level.targerid_postsun	 = 4;
	level.targerid_smallblur = 5;
}


map_material_helper( player, materialname )
{
	
	if(!IsDefined(level.filter_matid))
	{
		level.filter_matid = [];
	}
	
	if(IsDefined(level.filter_matid[materialname]))
	{
		player map_material( level.filter_matid[materialname], materialname );
	}	
	else
	{
		level.filter_matid[materialname] = level.filter_matcount;
		player map_material( level.filter_matcount, materialname );
		level.filter_matcount++;
	}
	
}

//-----------------------------------------------------------------------------
//
// Filter ( Hazmat )
//
//-----------------------------------------------------------------------------

init_filter_hazmat( player )
{
	init_filter_indices();
	map_material_helper( player, "zom_generic_filter_hazmat_moon" );
	map_material_helper( player, "zom_generic_overlay_hazmat_1" );
//	map_material_helper( player, "generic_overlay_hazmat_2" );
//	map_material_helper( player, "generic_overlay_hazmat_3" );
//	map_material_helper( player, "generic_overlay_hazmat_4" );
}

set_filter_hazmat_opacity( player, filterid, overlayid, opacity )
{
	player set_filter_pass_constant( filterid, 0, 0, opacity );
	player set_overlay_constant( overlayid, 0, opacity );
}
	
enable_filter_hazmat( player, filterid, overlayid, opacity )
{
	player set_filter_pass_material( filterid, 0, level.filter_matid["zom_generic_filter_hazmat_moon"] );
	player set_filter_pass_enabled( filterid, 0, true );
	player set_overlay_material( overlayid, level.filter_matid["zom_generic_overlay_hazmat_1"], 1 ); 
	player set_overlay_enabled( overlayid, true );
	set_filter_hazmat_opacity( player, filterid, overlayid, opacity );
}

disable_filter_hazmat( player, filterid, overlayid )
{
	player set_filter_pass_enabled( filterid, 0, false );
	player set_overlay_enabled( overlayid, false );
}


init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_equipment::is_equipment_included( "equip_gasmask_zm" ) )
	{
		return;
	}


	level._CF_PLAYER_GASMASK_OVERLAY_REMOVE = 8;
	level._CF_PLAYER_GASMASK_OVERLAY = 9;
	
	register_clientflag_callback("player",level._CF_PLAYER_GASMASK_OVERLAY_REMOVE, ::gasmask_overlay_remove_handler);
	register_clientflag_callback("player",level._CF_PLAYER_GASMASK_OVERLAY, ::gasmask_overlay_handler);


	level thread player_init();
}

gasmask_overlay_remove_handler(lcn, set, newEnt)
{
	player = GetLocalPlayers()[ lcn ];
	if ( player GetEntityNumber() != self GetEntityNumber() )
	{
		return;	
	}
	
	if ( IsSpectating( self GetLocalClientNumber() ) )
	{
		return;	
	}

	if ( set )
	{
		disable_filter_hazmat( self, 0, 0 );
		self thread playsounds_gasmask( 0 );
	}
}

gasmask_overlay_handler(lcn, set, newEnt)
{
	player = GetLocalPlayers()[ lcn ];
	if ( player GetEntityNumber() != self GetEntityNumber() )
	{
		return;	
	}
	
	if ( IsSpectating( self GetLocalClientNumber() ) )
	{
		return;	
	}

	if ( IsDefined( newEnt ) && newEnt )
	{
		return;
	}
	
	if ( set )
	{	
		enable_filter_hazmat( self, 0, 0, 1.0 );
		self thread playsounds_gasmask( 1 );
	}
	else
	{
		disable_filter_hazmat( self, 0, 0 );
		self thread playsounds_gasmask( 0 );
	}
}

player_init()
{
	waitforallclients( );

	wait(1.0);
	
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		init_filter_hazmat( players[i] ); 
	}
}

playsounds_gasmask( on )
{
	if( !isdefined( self.gasmask_audio_ent ) )
	{
		self.gasmask_audio_ent = spawn( 0, (0,0,0), "script_origin" );
	}
	
	if( on )
	{
		//playsound( 0, "evt_gasmask_on", (0,0,0) );
		self.gasmask_audio_ent playloopsound( "evt_gasmask_loop", .5 );
		
		if( isdefined( level._audio_zombie_gasmask_func ) )
		{
			level thread [[level._audio_zombie_gasmask_func]]( on );
		}
	}
	else
	{
		playsound( 0, "evt_gasmask_off", (0,0,0) );
		self.gasmask_audio_ent stoploopsound( .5 );
		self.gasmask_audio_ent delete();
		self.gasmask_audio_ent = undefined;
		
		if( isdefined( level._audio_zombie_gasmask_func ) )
		{
			level thread [[level._audio_zombie_gasmask_func]]( on );
		}
	}
}

