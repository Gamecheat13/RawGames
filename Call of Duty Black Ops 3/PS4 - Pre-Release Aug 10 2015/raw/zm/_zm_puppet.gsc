#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace zm_puppet;

/#
function wait_for_puppet_pickup()
{
	self endon("death");
	self.isCurrentlyPuppet = false;
	while(1)
	{
		if( ( isdefined( self.isPuppet ) && self.isPuppet ) && !self.isCurrentlyPuppet )
		{
			self notify( "stop_zombie_goto_entrance" );
			self.isCurrentlyPuppet = true;
			
		}
		if( !( isdefined( self.isPuppet ) && self.isPuppet ) && self.isCurrentlyPuppet )
		{
			//self notify( "stop_zombie_goto_entrance" );
			self.isCurrentlyPuppet = false;
			
		}
		if( ( isdefined( self.isPuppet ) && self.isPuppet ) && zm_utility::check_point_in_playable_area( self.origin ) && ! IsDefined( self.completed_emerging_into_playable_area ) )
		{
			self zm_spawner::zombie_complete_emerging_into_playable_area();
			self.barricade_enter = false;
		}
		
		player = GetPlayers()[0];
		if(IsDefined(player) && player buttonpressed ("BUTTON_A"))
		{
			if( self.isCurrentlyPuppet )
			{		
				if( zm_utility::check_point_in_playable_area( self.goalpos ) && !zm_utility::check_point_in_playable_area( self.origin ))
				{
					self.backedUpGoal = self.goalpos;
					self thread zm_spawner::zombie_goto_entrance( self.backupNode, false );
				
				}
				if( !zm_utility::check_point_in_playable_area( self.goalpos ) && IsDefined( self.backupNode ) && self.goalpos != self.backupNode.origin )
				{
					self notify( "stop_zombie_goto_entrance" );
				
				}
			}
		}
		
		{wait(.05);};
	}
}
#/
