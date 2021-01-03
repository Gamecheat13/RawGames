#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;
#using scripts\cp\_oed;
#using scripts\shared\vehicles\_quadtank;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                           

                                               	                                                          	              	                                                                                           






#namespace arena_defend;

function autoexec __init__sytem__() {     system::register("arena_defend",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
	
	callback::on_localclient_connect( &on_player_connect );
}

function init_clientfields()
{
	clientfield::register( "world", "arena_defend_hide_sinkhole_models", 1, 1, "int", &callback_hide_sinkhole_models, !true, true );
	
	clientfield::register( "world", "arena_defend_mobile_wall_destroyed_swap", 1, 1, "int", &callback_mobile_wall_destroyed_swap, !true, true );
	
	clientfield::register( "scriptmover", "arena_defend_weak_point_keyline", 1, 1, "int", &callback_arena_defend_keyline, !true, !true );
	
	clientfield::register( "world", "clear_all_dyn_ents", 1, 1, "counter", &callback_clear_all_dyn_ents, !true, !true );
}

function on_player_connect( localClientNum )  // self = player
{
	duplicate_render::set_dr_filter_offscreen( "weakpoint_keyline", 100, "weakpoint_keyline_show_z", "weakpoint_keyline_hide_z", 2, "mc/hud_outline_model_z_white_alpha" );
}

function callback_arena_defend_keyline( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = scriptmover
{
	if ( newVal )
	{
		self duplicate_render::change_dr_flags( "weakpoint_keyline_show_z", "weakpoint_keyline_hide_z" );	 // param 1 = set, param 2 = clear
		self weakpoint_enable( true );
	}
	else
	{
		self duplicate_render::change_dr_flags( "weakpoint_keyline_hide_z", "weakpoint_keyline_show_z" );  // param 1 = set, param 2 = clear
		self weakpoint_enable( false );
	}
}

function callback_hide_sinkhole_models( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = level
{
	// this grabs all the misc models with targetname = 'sinkhole_misc_model' and hides them
	a_misc_model = FindStaticModelIndexArray( "sinkhole_misc_model" );
	
	if ( newVal )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		foreach ( i, model in a_misc_model )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
	}
	else 
	{
		foreach ( model in a_misc_model )
		{
			UnhideStaticModel( model );
		}		
	}
}

function callback_mobile_wall_destroyed_swap( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = level
{
	// this grabs all the misc models that are show/hidden when the mobile wall hits the buildings on the side
	a_misc_model_before = FindStaticModelIndexArray( "mobile_wall_smash_before" );
	a_misc_model_after = FindStaticModelIndexArray( "mobile_wall_smash_after" );
	
	if ( newVal )
	{		
		const MAX_HIDE_PER_CLIENT_FRAME = 25;
		
		//hide the before pieces
		foreach ( i, model in a_misc_model_before )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
		
		//and show the after pieces
		foreach ( i, model in a_misc_model_after )
		{
			UnHideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
	}
	else 
	{		
		//hide the after pieces
		foreach ( i, model in a_misc_model_after )
		{
			HideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}
		
		//and show the before pieces
		foreach ( i, model in a_misc_model_before )
		{
			UnHideStaticModel( model );
			
			if ( ( i % MAX_HIDE_PER_CLIENT_FRAME ) == 0 )  // stagger this for performance; this is hidden during a third person IGC
			{
				{wait(.016);};
			}
		}	
	}
}

//used to clear out all the random parts that could show up after the sinkhole collapse 
function callback_clear_all_dyn_ents( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = level
{
	if ( newVal )
	{
		CleanupSpawnedDynEnts();
	}
}