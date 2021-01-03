#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\_flashgrenades;
#using scripts\shared\filter_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace empgrenade;
function autoexec __init__sytem__() {     system::register("empgrenade",&__init__,undefined,undefined);    }		
	
	
function __init__()
{
	clientfield::register( "toplayer", "empd", 1, 1, "int", &onEmpChanged, !true, true );
	clientfield::register( "toplayer", "empd_monitor_distance", 1, 1, "int", &onEmpMonitorDistanceChanged, !true, true );
}

function onEmpChanged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	localPlayer = GetLocalPlayer( localClientNum );
	filter::init_filter_tactical( localPlayer );
	
	if( newVal == 1 )
	{
		filter::enable_filter_tactical( localPlayer, 2 );
		filter::set_filter_tactical_amount( localPlayer, 2, 1.0 );
		playsound( 0, "mpl_plr_emp_activate", (0,0,0) );
		audio::playloopat( "mpl_plr_emp_looper", (0,0,0) );
	}
	else
	{
		filter::disable_filter_tactical( localPlayer, 2 );
		
		if( oldVal != 0 )
			playsound( 0, "mpl_plr_emp_deactivate", (0,0,0) );
		
		audio::stoploopat( "mpl_plr_emp_looper", (0,0,0) );		
	}
}

function onEmpMonitorDistanceChanged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	onEmpChanged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	
	localPlayer = GetLocalPlayer( localClientNum );
	
	if ( newVal == 1 )
	{
		localPlayer MonitorDistance( localClientNum );
	}
	else
	{		
		localPlayer notify( "end_emp_monitor_distance" );
	}
}

function MonitorDistance( localClientNum )
{
	localPlayer = self;

	localPlayer endon( "entityshutdown" );
	localPlayer endon( "end_emp_monitor_distance" );
	localPlayer endon( "team_changed" );

	distance_to_closest_enemy_emp_ui_model = GetUIModel( GetUIModelForController( localClientNum ), "distanceToClosestEnemyEmpKillstreak" );

	new_distance = 0.0;
	
	max_static_value = GetDvarFloat( "ks_emp_fullscreen_maxStaticValue" );
	min_static_value = GetDvarFloat( "ks_emp_fullscreen_minStaticValue" );
	min_radius_max_static = GetDvarFloat( "ks_emp_fullscreen_minRadiusMaxStatic" );
	max_radius_min_static = GetDvarFloat( "ks_emp_fullscreen_maxRadiusMinStatic" );
			
	if ( isdefined( distance_to_closest_enemy_emp_ui_model ) )
	{
		while( true )
		{

/#			// for tuning
			max_static_value = GetDvarFloat( "ks_emp_fullscreen_maxStaticValue" );
			min_static_value = GetDvarFloat( "ks_emp_fullscreen_minStaticValue" );
			min_radius_max_static = GetDvarFloat( "ks_emp_fullscreen_minRadiusMaxStatic" );
			max_radius_min_static = GetDvarFloat( "ks_emp_fullscreen_maxRadiusMinStatic" );
#/	

			// calculate effect factor based on distance
			new_distance = GetUIModelValue( distance_to_closest_enemy_emp_ui_model );
			range = max_radius_min_static - min_radius_max_static;
			current_static_value = max_static_value - ( ( range <= 0.0 ) ? max_static_value : ( ( new_distance - min_radius_max_static ) / range ) );
			current_static_value = math::clamp( current_static_value, min_static_value, max_static_value );
	
			// update filter effects
			filter::set_filter_tactical_amount( localPlayer, 2, current_static_value );

			wait 0.1;
		}
	}
}
