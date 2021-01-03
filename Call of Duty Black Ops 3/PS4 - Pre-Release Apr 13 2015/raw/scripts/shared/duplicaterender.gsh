#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;

#namespace duplicate_render;




function autoexec __init__sytem__() {     system::register("duplicate_render",&__init__,undefined,undefined);    }





	

	
function __init__()
{
	if(!isdefined(level.drfilters))level.drfilters=[];
	
	callback::on_spawned( &on_player_spawned );
	
	set_dr_filter_framebuffer( "none_fb", 0, undefined, undefined, 0, 1 );
	set_dr_filter_offscreen( "none_os", 0, undefined, undefined, 2, 0 );

	set_dr_filter_offscreen( "retrv", 5, "retrievable", undefined, 2, "mc/hud_keyline_retrievable" );
	set_dr_filter_offscreen( "unplc", 7, "unplaceable", undefined, 2, "mc/hud_keyline_unplaceable" );
	set_dr_filter_offscreen( "eneqp", 8, "enemyequip", undefined, 2, "mc/hud_keyline_enemyequip" );
	set_dr_filter_offscreen( "enexp", 8, "enemyexplo", undefined, 2, "mc/hud_keyline_enemyequip" );
	set_dr_filter_offscreen( "enveh", 8, "enemyvehicle", undefined, 2, "mc/hud_keyline_enemyequip" );
		
	set_dr_filter_offscreen( "infrared", 9, "infrared_entity", undefined, 2, 2 );
	set_dr_filter_offscreen( "threat_detector_enemy", 10, "threat_detector_enemy", undefined, 2, "mc/hud_keyline_enemyequip" );
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


function set_dr_filter( filterset, name, priority, require_flags, refuse_flags, drtype1, drval1, drtype2, drval2, drtype3, drval3 )
{
	if(!isdefined(level.drfilters))level.drfilters=[];
	if (!IsDefined(level.drfilters[filterset]))
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
	if (IsDefined(drtype1))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype1;
		filter.values[idx]=drval1;
	}
	if (IsDefined(drtype2))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype2;
		filter.values[idx]=drval2;
	}
	if (IsDefined(drtype1))
	{
		idx = filter.types.size; 
		filter.types[idx]=drtype3;
		filter.values[idx]=drval3;
	}

	thread register_filter_materials( filter );
}

function set_dr_filter_framebuffer( name, priority, require_flags, refuse_flags, drtype1, drval1, drtype2, drval2, drtype3, drval3 )
{
	set_dr_filter( "framebuffer", name, priority, require_flags, refuse_flags, drtype1, drval1, drtype2, drval2, drtype3, drval3 );
}

function set_dr_filter_offscreen( name, priority, require_flags, refuse_flags, drtype1, drval1, drtype2, drval2, drtype3, drval3 )
{
	set_dr_filter( "offscreen", name, priority, require_flags, refuse_flags, drtype1, drval1, drtype2, drval2, drtype3, drval3 );
}

function register_filter_materials( filter )
{
	player = undefined;
	opts = filter.types.size; 
	for ( i=0; i<opts; i++ )
	{
		value = filter.values[i];
		if ( IsString( value ) )
		{
			if ( !IsDefined(player) )
			{
				util::waitforclient( 0 );
				player = GetLocalPlayer(0);
			}
			if ( !IsDefined(filter::mapped_material_id( value ) ) )
			{
				filter::map_material_helper( player, value );
			}
		}
	}

	// make it usable	
	filter.priority = -filter.priority;	
}

function set_dr_flag( toset, setto=true )
{
	if ( IsArray(toset))
	{
		foreach( ts in toset )
		{
			set_dr_flag( ts, setto );
		}
		return;
	}
	if (!self flag::exists(toset))
	{
		self flag::init(toset);
	}
	if ( ( isdefined( setto ) && setto ) )
	{
		self flag::set(toset);
	}
	else
	{
		self flag::clear(toset);
	}
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

function update_dr_filters()
{
	foreach( key, filterset in level.drfilters )
	{
		filter = self find_dr_filter(filterset);
		if ( isdefined(filter) && (!isdefined(self.currentdrfilter) || !( self.currentdrfilter[key] === filter.name ) ) )
		{
			self apply_filter( filter, key );
		}
	}
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
	/#
		if ( GetDvarInt( "scr_debug_duplicaterender" ) )
		{
			name = "[entity]";
			if ( self IsPlayer() )
			{
				if (IsDefined(self.name))
					name = "player "+self.name;
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
		material = undefined;
		if ( IsString( value ) )
		{
			material = filter::mapped_material_id( value );
			value = 3;
			if (IsDefined(value) && IsDefined(material))
			{
				self addduplicaterenderoption( type, value, material );
			}
			else
			{
				self.currentdrfilter[filterset]=undefined;
			}
		}
		else
		{
			self addduplicaterenderoption( type, value );
		}
	}
}

//===================================================================================

function set_item_retrievable( on_off )
{
	self set_dr_flag( "retrievable", on_off );
	self update_dr_filters();
}

function set_item_unplaceable( on_off )
{
	self set_dr_flag( "unplaceable", on_off );
	self update_dr_filters();
}

function set_item_enemy_equipment( on_off )
{
	self set_dr_flag( "enemyequip", on_off );
	self update_dr_filters();
}

function set_item_enemy_explosive( on_off )
{
	self set_dr_flag( "enemyexplo", on_off );
	self update_dr_filters();
}

function set_item_enemy_vehicle( on_off )
{
	self set_dr_flag( "enemyvehicle", on_off );
	self update_dr_filters();
}

function set_entity_thermal( on_off )
{
	self set_dr_flag( "infrared_entity", on_off );
	self update_dr_filters();
}

function set_player_threat_detected( on_off )
{
	self set_dr_flag( "threat_detector_enemy", on_off );
	self update_dr_filters();
}
