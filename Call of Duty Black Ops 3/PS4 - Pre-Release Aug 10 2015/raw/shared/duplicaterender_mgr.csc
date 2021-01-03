#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	

#using scripts\shared\system_shared;

#namespace duplicate_render;





function autoexec __init__sytem__() {     system::register("duplicate_render",&__init__,undefined,undefined);    }







	







	
function __init__()
{
	if(!isdefined(level.drfilters))level.drfilters=[];
	
	callback::on_spawned( &on_player_spawned );
	
	set_dr_filter_framebuffer( "none_fb", 0, undefined, undefined, 0, 1, 0 );
	set_dr_filter_framebuffer_duplicate( "none_fbd", 0, undefined, undefined, 1, 0, 0 );
	set_dr_filter_offscreen( "none_os", 0, undefined, undefined, 2, 0, 0 );

	set_dr_filter_framebuffer( "enveh_fb", 8, "enemyvehicle_fb", undefined, 0, 4, 1 );
	set_dr_filter_framebuffer( "frveh_fb", 8, "friendlyvehicle_fb", undefined, 0, 1, 1 );

	set_dr_filter_offscreen( "retrv", 5, "retrievable", undefined, 2, "mc/hud_keyline_retrievable", 1 );
	set_dr_filter_offscreen( "unplc", 7, "unplaceable", undefined, 2, "mc/hud_keyline_unplaceable", 1 );
	set_dr_filter_offscreen( "eneqp", 8, "enemyequip", undefined, 2, "mc/hud_keyline_enemyequip", 1 );
	set_dr_filter_offscreen( "enexp", 8, "enemyexplo", undefined, 2, "mc/hud_keyline_enemyequip", 1 );
	set_dr_filter_offscreen( "enveh", 8, "enemyvehicle", undefined, 2, "mc/hud_keyline_enemyequip", 1 );
	set_dr_filter_offscreen( "freqp", 8, "friendlyequip", undefined, 2, "mc/hud_keyline_friendlyequip", 1 );
	set_dr_filter_offscreen( "frexp", 8, "friendlyexplo", undefined, 2, "mc/hud_keyline_friendlyequip", 1 );
	set_dr_filter_offscreen( "frveh", 8, "friendlyvehicle", undefined, 2, "mc/hud_keyline_friendlyequip", 1 );
		
	set_dr_filter_offscreen( "infrared", 9, "infrared_entity", undefined, 2, 2, 1 );
	set_dr_filter_offscreen( "threat_detector_enemy", 10, "threat_detector_enemy", undefined, 2, "mc/hud_keyline_enemyequip", 1 );
	
	set_dr_filter_offscreen( "hthacked", 5, "hacker_tool_hacked", undefined, 2, "mc/mtl_hacker_tool_hacked", 1 );
	set_dr_filter_offscreen( "hthacking", 5, "hacker_tool_hacking", undefined, 2, "mc/mtl_hacker_tool_hacking", 1 );
	set_dr_filter_offscreen( "htbreaching", 5, "hacker_tool_breaching", undefined, 2, "mc/mtl_hacker_tool_breaching", 1 );
	
	set_dr_filter_offscreen( "bcarrier", 9, "ballcarrier", undefined, 2, "mc/hud_keyline_friendlyequip", 1 );
	set_dr_filter_offscreen( "poption", 9, "passoption", undefined, 2, "mc/hud_keyline_friendlyequip", 1 );
	

	level.friendlyContentOutlines		= GetDvarInt( "friendlyContentOutlines", false );
}

function on_player_spawned( local_client_num )
{
	self.currentdrfilter=[];
	self change_dr_flags();
	
	if( !level flagsys::get( "duplicaterender_registry_ready" ) )
	{
		{wait(.016);};//We need a frame once player is valid to set up the materials 
		level flagsys::set( "duplicaterender_registry_ready" );
	}
	
	self thread watch_killcam_reapply_dr( local_client_num );
}

function watch_killcam_reapply_dr( localClientNum )
{
	level notify("watch_killcam_reapply_dr");
	level endon("watch_killcam_reapply_dr");
	level endon("game_ended");
	while(1)
	{
		{wait(.016);};
		if ( isdefined(level.lastPlayer) )
		{
			level.lastPlayer.currentdrfilter=[];
			level.lastPlayer update_dr_filters();
			level.lastPlayer = undefined;
		}
		player_view = getlocalplayer( localClientNum );
		if ( isdefined(player_view) )
		{
			player_view.currentdrfilter=[];
			player_view update_dr_filters();
			level.lastPlayer = player_view;
		}
		level util::waittill_any( "demo_jump", "player_switch", "killcam_begin", "killcam_end" );
	}
}


function set_dr_filter( filterset, name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 )
{
	if(!isdefined(level.drfilters))level.drfilters=[];
	if ( !IsDefined( level.drfilters[ filterset ] ) )
	{
		level.drfilters[filterset]=[];
	}
	if (!IsDefined(level.drfilters[filterset][name]))
	{
		level.drfilters[filterset][name] = spawnstruct(); 
	}
	filter = level.drfilters[filterset][name]; 
	filter.name = name;
	// set priority negative until the materials are registered. This will keep it from being used
	filter.priority = -priority;	
	if (!IsDefined(require_flags))
		filter.require = [];
	else if ( IsArray(require_flags) )
		filter.require = require_flags;	
	else
		filter.require = StrTok( require_flags, "," );
	if (!IsDefined(refuse_flags))
		filter.refuse = [];
	else if ( IsArray(refuse_flags) )
		filter.refuse = refuse_flags;	
	else
		filter.refuse = StrTok( refuse_flags, "," );
	filter.types = [];
	filter.values = [];
	filter.culling = [];
	if (IsDefined(drtype1))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype1;
		filter.values[idx]=drval1;
		filter.culling[idx]=drcull1;
	}
	if (IsDefined(drtype2))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype2;
		filter.values[idx]=drval2;
		filter.culling[idx]=drcull2;
	}
	if (IsDefined(drtype3))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype3;
		filter.values[idx]=drval3;
		filter.culling[idx]=drcull3;
	}

	thread register_filter_materials( filter );
}

function set_dr_filter_framebuffer( name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 )
{
	set_dr_filter( "framebuffer", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 );
}

function set_dr_filter_framebuffer_duplicate( name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 )
{
	set_dr_filter( "framebuffer_duplicate", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 );
}

function set_dr_filter_offscreen( name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 )
{
	set_dr_filter( "offscreen", name, priority, require_flags, refuse_flags, drtype1, drval1, drcull1, drtype2, drval2, drcull2, drtype3, drval3, drcull3 );
}

function register_filter_materials( filter )
{
	playerCount = undefined;
	opts = filter.types.size; 
	for ( i=0; i<opts; i++ )
	{
		value = filter.values[i];
		if ( IsString( value ) )
		{
			if ( !IsDefined(playerCount) )
			{
				while( !isDefined(level.localPlayers) && !isDefined(level.frontendClientConnected) )
				{
					{wait(.016);};
				}
				if( isDefined(level.frontendClientConnected) )
				{
					playerCount = 1;
				}
				else
				{
					util::waitforallclients();
					playerCount = level.localPlayers.size;
				}
			}
			if ( !IsDefined(filter::mapped_material_id( value ) ) )
			{
				for ( localClientNum = 0; localClientNum < playerCount; localClientNum++ )
				{
					filter::map_material_helper_by_localclientnum( localClientNum, value );
				}
			}
		}
	}

	// make it usable	
	filter.priority = abs( filter.priority );	
}

function update_dr_flag( toset, setto=true )
{
	if ( set_dr_flag( toset, setto ) )
	{
		update_dr_filters();
	}
}

function set_dr_flag( toset, setto=true )
{
	Assert( IsDefined(setto) );
	
	if ( IsArray(toset))
	{
		foreach( ts in toset )
		{
			set_dr_flag( ts, setto );
		}
		return;
	}
	
	if ( !IsDefined( self.flag ) || !IsDefined( self.flag[toset] ) )
	{
		self flag::init(toset);
	}
	
	if ( setto == self.flag[toset] )
	{
		return false;
	}
	if ( ( isdefined( setto ) && setto ) )
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
	return true;
}

function clear_dr_flag( toclear )
{
	set_dr_flag( toclear, false );
}
	
function change_dr_flags( toset, toclear )
{
	if ( IsDefined(toset) )
	{
		if( IsString( toset ) )
		{
			toset = StrTok( toset, "," );
		}
		self set_dr_flag(toset);
	}
	if ( IsDefined(toclear) )
	{
		if( IsString( toclear ) )
		{
			toclear = StrTok( toclear, "," );
		}	
		self clear_dr_flag(toclear);
	}
	
	update_dr_filters();
}

function _update_dr_filters()
{
	self notify("update_dr_filters");
	self endon("update_dr_filters");
	self endon("entityshutdown");
	
	waittillframeend;
	
	foreach( key, filterset in level.drfilters )
	{
		filter = self find_dr_filter(filterset);
		if ( isdefined(filter) && (!isdefined(self.currentdrfilter) || !( self.currentdrfilter[key] === filter.name ) ) )
		{
			self apply_filter( filter, key );
		}
	}
}

function update_dr_filters()
{
	self thread _update_dr_filters();
}

function find_dr_filter( filterset = level.drfilters["framebuffer"] )
{
	best = undefined; 
	foreach( filter in filterset )
	{
		if ( self can_use_filter( filter ) )
		{
			if (!IsDefined(best) || filter.priority > best.priority)
			{
				best = filter;
			}
		}
	}
	return best;
}

function can_use_filter( filter )
{
	foreach ( require in filter.require )
	{
		if ( !self flagsys::get( require ))
			return false; 
	}
	foreach ( refuse in filter.refuse )
	{
		if ( self flagsys::get( refuse ))
			return false; 
	}
	return true;
}

function apply_filter( filter, filterset = "framebuffer" )
{
	if ( IsDefined( level.gameEnded ) && level.gameEnded )
		return;
	
	/#
		if ( GetDvarInt( "scr_debug_duplicaterender" ) )
		{
			name = "[entity]";
			if ( self IsPlayer() )
			{
				if (IsDefined(self.name))
					name = "player "+self.name;
			}
			else if (IsDefined(self.model))
			{
				name += "." + self.model; 
			}
			
			msg = "DUPLICATERENDER: Applying filter "+filter.name+" to "+name+" for set "+filterset;
			Println(msg);
			//IPrintlnBold(msg);
		}
	#/
	if (!IsDefined(self.currentdrfilter))
		self.currentdrfilter=[];
	self.currentdrfilter[filterset]=filter.name;
	opts = filter.types.size; 
	for ( i=0; i<opts; i++ )
	{
		type = filter.types[i];
		value = filter.values[i];
		culling = filter.culling[i];
		material = undefined;
		if ( IsString( value ) )
		{
			material = filter::mapped_material_id( value );
			value = 3;
			if (IsDefined(value) && IsDefined(material))
			{
				// right now all duplicate rendering is see through walls
				self addduplicaterenderoption( type, value, material, culling );
			}
			else
			{
				self.currentdrfilter[filterset]=undefined;
			}
		}
		else
		{
			self addduplicaterenderoption( type, value, -1, culling );
		}
	}

	self thread disable_all_filters_on_game_ended();
}

function disable_all_filters_on_game_ended()
{
	self endon("entityshutdown");
	self notify("disable_all_filters_on_game_ended");
	self endon("disable_all_filters_on_game_ended");
	
	level waittill( "game_ended" );
	
	self disableduplicaterendering();
}


//===================================================================================

function set_item_retrievable( on_off )
{
	self update_dr_flag( "retrievable", on_off );
}

function set_item_unplaceable( on_off )
{
	self update_dr_flag( "unplaceable", on_off );
}

function set_item_enemy_equipment( on_off )
{
	self update_dr_flag( "enemyequip", on_off );
}

function set_item_friendly_equipment( on_off )
{
	self update_dr_flag( "friendlyequip", on_off );
}

function set_item_enemy_explosive( on_off )
{
	self update_dr_flag( "enemyexplo", on_off );
}

function set_item_friendly_explosive( on_off )
{
	self update_dr_flag( "friendlyexplo", on_off );
}

function set_item_enemy_vehicle( on_off )
{
	self update_dr_flag( "enemyvehicle", on_off );
}

function set_item_friendly_vehicle( on_off )
{
	self update_dr_flag( "friendlyvehicle", on_off );
}

function set_entity_thermal( on_off )
{
	self update_dr_flag( "infrared_entity", on_off );
}

function set_player_threat_detected( on_off )
{
	self update_dr_flag( "threat_detector_enemy", on_off );
}


function set_hacker_tool_hacked( on_off )
{
	self update_dr_flag( "hacker_tool_hacked", on_off );
}


function set_hacker_tool_hacking( on_off )
{
	self update_dr_flag( "hacker_tool_hacking", on_off );
}


function set_hacker_tool_breaching( on_off )
{
	flags_changed = self set_dr_flag( "hacker_tool_breaching", on_off );
	if ( on_off )
	{
		flags_changed = flags_changed && self set_dr_flag( "enemyvehicle", false );
	}
	else
	{
		if ( isdefined( self.isEnemyVehicle ) && self.isEnemyVehicle == true ) 
		{
			flags_changed = flags_changed && self set_dr_flag( "enemyvehicle", true );
		}
	}
	
	if ( flags_changed )
	{
		update_dr_filters();
	}
}

function show_friendly_outlines( local_client_num )
{
	if ( !( isdefined( level.friendlyContentOutlines ) && level.friendlyContentOutlines ) )
		return false;
				
	return true;
}

