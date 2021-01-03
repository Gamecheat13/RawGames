#using scripts\codescripts\struct;

#using scripts\shared\array_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace zm_game_module_utility;

function move_ring(ring)
{
	positions = struct::get_array(ring.target,"targetname");
	positions = array::randomize(positions);
	level endon("end_game");
	
	while(1)
	{
		foreach(position in positions)
		{
			self moveto(position.origin,randomintrange(30,45));
			self waittill("movedone");
		}
	}
}

function rotate_ring(forward)
{
	level endon("end_game");
	dir = -360;
	if(forward)
	{
		dir = 360;
	}
	while(1)
	{
		self rotateyaw(dir,9);
		wait(9);
	}
}
