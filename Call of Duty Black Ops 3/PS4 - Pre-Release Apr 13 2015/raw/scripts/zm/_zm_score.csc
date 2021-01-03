#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace zm_score;

function autoexec __init__sytem__() {     system::register("zm_score",&__init__,undefined,undefined);    }

function __init__()
{
	score_cf_register_info( "damage", 1, 7 );
	score_cf_register_info( "death_normal", 1, 3 );
	score_cf_register_info( "death_torso", 1, 3 );
	score_cf_register_info( "death_neck", 1, 3 );
	score_cf_register_info( "death_head", 1, 3 );
	score_cf_register_info( "death_melee", 1, 3 );

	clientfield::register( "allplayers", "score_cf_double_points_active", 1, 1, "int", undefined, !true, true );
	level thread set_clientfield_code_callback( "score_cf_double_points_active" );
}


function score_cf_register_info( name, version, max_count )
{
	cf_field = "score_cf_" + name;
	clientfield::register( "allplayers", cf_field, version, GetMinBitCountForNum( max_count ), "counter", undefined, !true, !true );
	level thread set_clientfield_code_callback( cf_field );
}

function set_clientfield_code_callback( cf_field )
{
	wait(0.1);        // This won't run - until after all the client field registration has finished.

	SetupClientFieldCodeCallbacks( "allplayers", 1, cf_field );
}
