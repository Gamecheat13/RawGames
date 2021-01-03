#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\rat_shared;
#using scripts\shared\array_shared;

#using scripts\zm\_zm_devgui;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

/#
#namespace rat;

function autoexec __init__sytem__() {     system::register("rat",&__init__,undefined,undefined);    }
	
function __init__()
{
	rat_shared::init();
	
	// Set up common function for the shared rat script commands to call
	level.rat.common.gethostplayer = &util::getHostPlayer;
	rat_shared::addRATScriptCmd( "testderriesenavmesh", &DerRieseZombieSpawnNavmeshTest );
}

function DerRieseZombieSpawnNavmeshTest( params, inRat = true )
{
	if( inRat )
	{
		wait( 10 );
	}
	enemy = zm_devgui::devgui_zombie_spawn();
	enemy.is_rat_test = true;
	failed_spawn_origin = [];
	failed_node_origin = [];
	failed_attack_spot_spawn_origin = [];
	failed_attack_spot = [];
	size = 0;
	failed_attack_spot_size = 0;
	wait ( 0.2 );
	foreach( zone in level.zones)
	{
		foreach( loc in zone.a_loc_types[ "zombie_location" ] )
		{
			angles = (0,0,0);
			enemy ForceTeleport(loc.origin, angles );
			
			wait( 0.2 );
			
			node = undefined;
			
			for( j=0; j<level.exterior_goals.size; j++ )
            {
	        	if( IsDefined(level.exterior_goals[j].script_string) && level.exterior_goals[j].script_string == loc.script_string )
	            {
  	            	node = level.exterior_goals[j];
	            }
            }

			
			if( isdefined(node) )
			{
				isPath = enemy SetGoal( node.origin );
				if ( !isPath )
				{
					failed_spawn_origin[size] = loc.origin;
					failed_node_origin[size] = node.origin;
					size++;
				}
				wait( 0.2 );
				for( j = 0; j < node.attack_spots.size; j++ )
				{
					isAttackPath = enemy SetGoal( node.attack_spots[j] );
					if( !isAttackPath )
					{
						failed_attack_spot_spawn_origin[failed_attack_spot_size] = loc.origin;
						failed_attack_spot[failed_attack_spot_size] = node.attack_spots[j];
						failed_attack_spot_size++;
					}
					wait( 0.2 );
				}
			}
		}
	}
	if( inRat )
	{
		errMsg = "Failed Spawn Locations:";
		for( i = 0; i < size; i++ )
			errMsg += "(spawn: " + failed_spawn_origin[i] + ", node: " + failed_node_origin[i] + ") ";
		for( i = 0; i < failed_attack_spot_size; i++ )
			errMsg += "(spawn: " + failed_attack_spot_spawn_origin[i] + ", attack spot: " + failed_attack_spot[i] + ") ";
		if (size > 0 || failed_attack_spot_size > 0 )
			RatReportCommandResult( params._id, 0, errMsg);
		else
			RatReportCommandResult( params._id, 1);
	}
}

#/