/*
 * Created by ScriptDevelop.
 * User: dmendelsohn
 * Date: 2/18/2015
 * Time: 6:19 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 * 
 * 	Debug functionality shared across all game modes.
 */

#using scripts\shared\array_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       




#namespace debug;

/#
function autoexec __init__sytem__() {     system::register("debug",&__init__,undefined,undefined);    }
#/

/#
function __init__()
{
	thread debug_draw_tuning_sphere();
}


// Draws a sphere out to a specified distance in front of the player.
// Lets designers visualize how far away specific distances are.
function debug_draw_tuning_sphere()
{
	// How big the measured radius actually is.
	n_sphere_radius = 0.0;
	
	// Where we draw the text label and "bobber" sphere.
	v_text_position = (0,0,0);
	
	// How much to scale up the text based on distance.
	n_text_scale = 1.0;
	
	
	
	while(true)
	{
		// Only check every once a second to see if we should draw the debug sphere.
		n_sphere_radius = GetDvarFloat("debug_measure_sphere_radius", 0.0);
		
		// If we should be drawing the sphere, do it every frame.
		while (n_sphere_radius >= 1.0)
		{
			players = GetPlayers();
			n_sphere_radius = GetDvarFloat("debug_measure_sphere_radius", 0.0);
			
			// Draw the outer ring
			Circle(players[0].origin, n_sphere_radius, (1, 0, 0), false, true, 16);
			
			// Adjust the text and bobber size gradually so they can be read at distance.
			n_text_scale = Sqrt(n_sphere_radius*2.5)/2;
			
			// Draw the bobber sphere
			vForward = Anglestoforward(players[0].angles);
			v_text_position = players[0].origin + (vForward * n_sphere_radius);
			sides = Int(10 * ( 1 + Int(n_text_scale) % 100 ));
			sphere( v_text_position, n_text_scale, (1,0,0), 1, true, sides, 16 );
			
			// Print the distance
			print3d(v_text_position +(0, 0, 20), n_sphere_radius, (1, 0, 0), 1, n_text_scale/14, 16);
			
			{wait(.05);};
		}
		
		wait(1);
	}
}

#/
	