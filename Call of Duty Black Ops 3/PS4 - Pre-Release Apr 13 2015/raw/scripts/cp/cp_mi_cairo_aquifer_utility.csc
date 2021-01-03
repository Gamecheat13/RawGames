#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\duplicaterender_mgr;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                           






#precache( "client_fx", "ui/fx_ui_flagbase_blue" );
#precache( "client_fx", "ui/fx_ui_flagbase_orng" );

#namespace aquifer_util;

function autoexec __init__sytem__() {     system::register("aquifer_util",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
	
	duplicate_render::set_dr_filter_framebuffer( "vtol_enemy_highlighting", 90, "vtol_enemy_highlighting_on", "", 0, "mc/hud_outline_model_reveal_enemy" );
	duplicate_render::set_dr_filter_framebuffer( "vtol_friendly_highlighting", 90, "vtol_friendly_highlighting_on", "", 0, "mc/hud_outline_model_reveal_friendly" );
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "toplayer", "vtol_set_landing_zone_ent", 1, 10, "int", &callback_vtol_landing_zone_set_ent, !true, !true );
	clientfield::register( "toplayer", "vtol_landing_zone_update", 1, 2, "int", &callback_vtol_landing_zone_valid, !true, !true );
	clientfield::register( "toplayer", "vtol_highlight_ai", 1, 1, "int", &callback_vtol_highlight_ai, !true, !true );
}

function callback_vtol_landing_zone_set_ent( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self.landing_zone_ent = GetEntByNum( localClientNum, newVal );
}

function callback_vtol_landing_zone_valid( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal != oldVal && IsDefined( self.landing_zone_ent ) )
	{
		self.landing_zone_ent fx_delete_type( localClientNum, "vtol_landing_zone" );
		
		switch ( newVal )
		{
			case 1:
				self.landing_zone_ent fx_play_on_tag( localClientNum, "vtol_landing_zone", "ui/fx_ui_flagbase_blue", "tag_origin" );
				break;
				
			case 2:
				self.landing_zone_ent fx_play_on_tag( localClientNum, "vtol_landing_zone", "ui/fx_ui_flagbase_orng", "tag_origin" );
				break;
		}
	}
}

function callback_vtol_highlight_ai( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal != oldVal )
	{
		switch ( newVal )
		{
			case 0:
				self thread vtol_highlight_all_ai( localClientNum, false );
				break;
				
			case 1:
				self thread vtol_highlight_all_ai( localClientNum, true );
				break;
		}
	}
}

function vtol_highlight_all_ai( localClientNum, bHighlight )
{

	self notify( "vtol_highlight_all_ai" );
	self endon( "vtol_highlight_all_ai" );

	// Make sure we're doing this for a local player.

	if( !self islocalplayer() )
	{
		return;
	}

	if ( !bHighlight )
	{
		a_all_entities = GetEntArray( localClientNum );

	 	foreach( entity in a_all_entities )
	 	{
	 		if ( entity flag::exists( "vtol_enemy_highlighting_on" ) && entity flagsys::get( "vtol_enemy_highlighting_on" ) )
	 		{
		 		entity duplicate_render::change_dr_flags( undefined, "vtol_enemy_highlighting_on" );
	 		}
	 		else if ( entity flag::exists( "vtol_friendly_highlighting_on" ) && entity flagsys::get( "vtol_friendly_highlighting_on" ) )
	 		{
		 		entity duplicate_render::change_dr_flags( undefined, "vtol_friendly_highlighting_on" );
	 		}
	 	}
	}
	else
	{
		while ( 1 )
		{
			a_all_entities = GetEntArray( localClientNum );
		
		 	foreach( entity in a_all_entities )
		 	{
			    // do not outline non-entities
		 		if ( !isdefined( entity ) )
		 		{
		 			continue;
		 		}
		
				// do not outline myself
			    if ( entity == self )
		 		{
		 			continue;
		 		}
		
				// do not outline dead entities
				if ( !IsAlive( entity ) )
		 		{
					if ( entity flag::exists( "vtol_enemy_highlighting_on" ) && entity flagsys::get( "vtol_enemy_highlighting_on" ) )
			 		{
						entity duplicate_render::change_dr_flags( undefined, "vtol_enemy_highlighting_on" );
			 		}
					else if ( entity flag::exists( "vtol_friendly_highlighting_on" ) && entity flagsys::get( "vtol_friendly_highlighting_on" ) )
			 		{
						entity duplicate_render::change_dr_flags( undefined, "vtol_friendly_highlighting_on" );
			 		}
		 			continue;
		 		}
		
		  		// do not outline entities without a team
		 		if ( !isdefined( entity.team ) )
				{
			      	continue;
				}
		 		
		 		// do not outline entities that are already outlined
		 		if ( ( entity flag::exists( "vtol_enemy_highlighting_on" ) && entity flagsys::get( "vtol_enemy_highlighting_on" ) ) ||
		 		  ( entity flag::exists( "vtol_friendly_highlighting_on" ) && entity flagsys::get( "vtol_friendly_highlighting_on" ) ) )
		 		{
			 		continue;
		 		}
		
		 		if ( ( !IsDefined( entity.type ) || entity.type != "vehicle" ) )
		 		{
		 			if ( entity.team == "axis" )
		 			{
		 				entity duplicate_render::change_dr_flags( "vtol_enemy_highlighting_on" );
		 			}
		 			else if ( entity.team == "allies" )
					{
					 	entity duplicate_render::change_dr_flags( "vtol_friendly_highlighting_on" );
					}
		 		}
		 	}
		 	
		 	wait 1;
		}
	}
}

// FX UTIL
function fx_clear( localClientNum, str_type, str_fx )
{
	if ( !IsDefined( self.a_fx ) )
	{
		self.a_fx = [];
	}
	
	if ( !IsDefined( self.a_fx[ localClientNum ] ) )
	{
		self.a_fx[ localClientNum ] = [];
	}
	
	if ( !IsDefined( self.a_fx[ localClientNum ][ str_type ] ) )
	{
		self.a_fx[ localClientNum ][ str_type ] = [];
	}
	
	if ( IsDefined( str_fx ) && IsDefined( self.a_fx[ localClientNum ][ str_type ][ str_fx ] ) )
	{
		n_fx_id = self.a_fx[ localClientNum ][ str_type ][ str_fx ];
			
		DeleteFx( localClientNum, n_fx_id, false );
		
		self.a_fx[ localClientNum ][ str_type ][ str_fx ] = undefined;
	}
}

function fx_delete_type( localClientNum, str_type, b_stop_immediately = true )
{
	if ( IsDefined( self.a_fx ) && IsDefined( self.a_fx[ localClientNum ] ) && IsDefined( self.a_fx[ localClientNum ][ str_type ] ) )
	{
		a_keys = GetArrayKeys( self.a_fx[ localClientNum ][ str_type ] );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			DeleteFX( localClientNum, self.a_fx[ localClientNum ][ str_type ][ a_keys[ i ] ], b_stop_immediately );
			
			self.a_fx[ localClientNum ][ str_type ][ a_keys[ i ] ] = undefined;
		}
	}
}

function fx_play_on_tag( localClientNum, str_type, str_fx, str_tag = "tag_origin", b_kill_fx_with_same_type = true )
{
	self fx_clear( localClientNum, str_type, str_fx );  // make sure only one effect of this type is playing at a time
	
	if ( b_kill_fx_with_same_type )
	{
		self fx_delete_type( localClientNum, str_type, false );
	}
	
	n_fx_id = PlayFxOnTag( localClientNum, str_fx, self, str_tag );
	
	self.a_fx[ localClientNum ][ str_type ][ str_fx ] = n_fx_id;
}

function fx_play( localClientNum, str_type, str_fx, b_kill_fx_with_same_type = true, v_pos, v_forward, v_up )
{
	self fx_clear( localClientNum, str_type, str_fx );  // make sure only one effect of this type is playing at a time
	
	if ( b_kill_fx_with_same_type )
	{
		self fx_delete_type( localClientNum, str_type, false );
	}
	
	// code will generate error if v_forward or v_up are passed into PlayFX as undefined
	if ( IsDefined( v_forward ) && IsDefined( v_up ) )
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos, v_forward, v_up );
	}
	else if ( IsDefined( v_forward ) )
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos, v_forward );
	}
	else 
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos );
	}
	
	self.a_fx[ localClientNum ][ str_type ][ str_fx ] = n_fx_id;
}