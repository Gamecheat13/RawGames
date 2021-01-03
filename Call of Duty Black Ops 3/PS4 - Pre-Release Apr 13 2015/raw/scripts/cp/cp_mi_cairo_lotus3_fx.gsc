#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	precache_scripted_fx();
}

function precache_scripted_fx()
{
	// Events 10 - 14
	level._effect[ "mobile_shop_fall_explosion" ] = "explosions/fx_exp_lt_moving_shop_fall";
	
	level._effect[ "burn_loop_human_left_arm" ] 	= "fire/fx_fire_ai_human_arm_left_loop";
	level._effect[ "burn_os_human_left_arm" ] 		= "fire/fx_fire_ai_human_arm_left_os";
	level._effect[ "burn_loop_human_right_arm" ] 	= "fire/fx_fire_ai_human_arm_right_loop";
	level._effect[ "burn_os_human_right_arm" ] 		= "fire/fx_fire_ai_human_arm_right_os";
	level._effect[ "burn_loop_human_head" ] 		= "fire/fx_fire_ai_human_head_loop";
	level._effect[ "burn_os_human_head" ] 			= "fire/fx_fire_ai_human_head_os";
	level._effect[ "burn_loop_human_left_leg" ] 	= "fire/fx_fire_ai_human_leg_left_loop";
	level._effect[ "burn_os_human_left_leg" ] 		= "fire/fx_fire_ai_human_leg_left_os";
	level._effect[ "burn_loop_human_right_leg" ] 	= "fire/fx_fire_ai_human_leg_right_loop";
	level._effect[ "burn_os_human_right_leg" ] 		= "fire/fx_fire_ai_human_leg_right_os";
	level._effect[ "burn_loop_human_torso" ] 		= "fire/fx_fire_ai_human_torso_loop";
	level._effect[ "burn_os_human_torso" ] 			= "fire/fx_fire_ai_human_torso_os";
	
	level._effect[ "burn_loop_robot_left_arm" ] 	= "fire/fx_fire_ai_robot_arm_left_loop";
	level._effect[ "burn_os_robot_left_arm" ] 		= "fire/fx_fire_ai_robot_arm_left_os";
	level._effect[ "burn_loop_robot_right_arm" ] 	= "fire/fx_fire_ai_robot_arm_right_loop";
	level._effect[ "burn_os_robot_right_arm" ] 		= "fire/fx_fire_ai_robot_arm_right_os";
	level._effect[ "burn_loop_robot_head" ] 		= "fire/fx_fire_ai_robot_head_loop";
	level._effect[ "burn_os_robot_head" ] 			= "fire/fx_fire_ai_robot_head_os";
	level._effect[ "burn_loop_robot_left_leg" ] 	= "fire/fx_fire_ai_robot_leg_left_loop";
	level._effect[ "burn_os_robot_left_leg" ] 		= "fire/fx_fire_ai_robot_leg_left_os";
	level._effect[ "burn_loop_robot_right_leg" ] 	= "fire/fx_fire_ai_robot_leg_right_loop";
	level._effect[ "burn_os_robot_right_leg" ] 		= "fire/fx_fire_ai_robot_leg_right_os";
	level._effect[ "burn_loop_robot_torso" ] 		= "fire/fx_fire_ai_robot_torso_loop";
	level._effect[ "burn_os_robot_torso" ] 			= "fire/fx_fire_ai_robot_torso_os";
	
	// Events 15 - 16
	level._effect[ "gunship_raps" ] = "zombie/fx_meatball_trail_zmb";
}
