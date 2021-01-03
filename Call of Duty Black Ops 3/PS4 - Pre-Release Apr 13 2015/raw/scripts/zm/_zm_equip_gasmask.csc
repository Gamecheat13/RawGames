#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;
#using scripts\zm\_zm_equipment;

#namespace zm_equip_gasmask;

function autoexec __init__sytem__() {     system::register("zm_equip_gasmask",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "player", "toggle_gasmask_overlay", 1, 1, "int", &gasmask_overlay_handler, !true, true );

	callback::on_localclient_connect( &player_init );
}

function init_filter_indices()
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

function map_material_helper( player, materialname )
{
	
	if(!isdefined(level.filter_matid))
	{
		level.filter_matid = [];
	}
	
	if(isdefined(level.filter_matid[materialname]))
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

function init_filter_hazmat( player )
{
	init_filter_indices();
	map_material_helper( player, "zom_generic_filter_hazmat_moon" );
	map_material_helper( player, "zom_generic_overlay_hazmat_1" );
//	map_material_helper( player, "generic_overlay_hazmat_2" );
//	map_material_helper( player, "generic_overlay_hazmat_3" );
//	map_material_helper( player, "generic_overlay_hazmat_4" );
}

function set_filter_hazmat_opacity( player, filterid, overlayid, opacity )
{
	player set_filter_pass_constant( filterid, 0, 0, opacity );
	player set_overlay_constant( overlayid, 0, opacity );
}
	
function enable_filter_hazmat( player, filterid, overlayid, opacity )
{
	player set_filter_pass_material( filterid, 0, level.filter_matid["zom_generic_filter_hazmat_moon"] );
	player set_filter_pass_enabled( filterid, 0, true );
	player set_overlay_material( overlayid, level.filter_matid["zom_generic_overlay_hazmat_1"], 1 ); 
	player set_overlay_enabled( overlayid, true );
	set_filter_hazmat_opacity( player, filterid, overlayid, opacity );
}

function disable_filter_hazmat( player, filterid, overlayid )
{
	player set_filter_pass_enabled( filterid, 0, false );
	player set_overlay_enabled( overlayid, false );
}

function gasmask_overlay_handler( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayers()[ localClientNum ];
	if ( player GetEntityNumber() != self GetEntityNumber() )
	{
		return;	
	}
	
	if ( IsSpectating( self GetLocalClientNumber() ) )
	{
		return;	
	}

	if ( ( isdefined( bNewEnt ) && bNewEnt ) )
	{
		return;
	}
	
	if ( newVal )
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

function player_init()
{
	init_filter_hazmat( self ); 
}

function playsounds_gasmask( on )
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

