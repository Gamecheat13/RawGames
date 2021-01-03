#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_hacker_utility;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

#namespace zm_hackables_boards;

function hack_boards()
{
	windows = struct::get_array( "exterior_goal", "targetname" ); 

	for(i = 0; i < windows.size; i ++)
	{
		window = windows[i];
		
		struct = SpawnStruct();
		
		spot = window;
		
		if(isdefined(window.trigger_location))
		{
			spot = window.trigger_location;
		}
		
		org = zm_utility::groundpos( spot.origin ) + ( 0, 0, 4 );
		
		r = 96;
		h = 96;
		
		if(isdefined(spot.radius))
		{
			r = spot.radius;
		}
		
		if(isdefined(spot.height))
		{
			h = spot.height;
		}
		
		struct.origin = org + (0,0,48);; // window.origin;// + (AnglesToForward(window.angles) * 54);// + (0,0,24);
		struct.radius = r;
		struct.height = h;
		struct.script_float = 2;
		struct.script_int = 0;
		struct.window = window;
		struct.no_bullet_trace = true;
		struct.no_sight_check = true;
		struct.dot_limit = 0.7;
		struct.no_touch_check = true;
		struct.last_hacked_round = 0;
		struct.num_hacks = 0;
		
		hacker_util::register_pooled_hackable_struct(struct,&board_hack,&board_qualifier);		
	}
}

function board_hack(hacker)
{
	hacker_util::deregister_hackable_struct(self);

	num_chunks_checked = 0;
	
	last_repaired_chunk = undefined;
	
	if(self.last_hacked_round != level.round_number)
	{
		self.last_hacked_round = level.round_number;
		self.num_hacks = 0;
	}
	
	self.num_hacks ++;
	
	if(self.num_hacks < 3)
	{
		hacker zm_score::add_to_player_score( 100 );
	}
	else
	{
		cost = Int(min(300, hacker.score));
		
		if(cost)
		{
			hacker zm_score::minus_to_player_score( cost );
		}
	}
	
	while(1)
	{
		if( zm_utility::all_chunks_intact( self.window.barrier_chunks ) )
		{
			break;
		}

		chunk = zm_utility::get_random_destroyed_chunk( self, self.window.barrier_chunks ); 

		if( !isdefined( chunk ) )
			break;

		self.window thread zm_blockers::replace_chunk( self, chunk, undefined, false, true );
		
		last_repaired_chunk = chunk;
		
		if(isdefined(self.clip))
		{
			self.window.clip TriggerEnable( true ); 
			self.window.clip DisconnectPaths();
		}
		else
		{
			zm_blockers::blocker_disconnect_paths(self.window.neg_start, self.window.neg_end);
		}		
		
		util::wait_network_frame();
				
		num_chunks_checked++;
		
		if(num_chunks_checked >= 20)
		{
			break;	// Avoid staying in this while loop forever....
		}
	}
	
	//wait for the last window board to be repaired
	
	while((isdefined(last_repaired_chunk)) && (last_repaired_chunk.state == "mid_repair"))
	{
		wait(.05);
	}

	hacker_util::register_pooled_hackable_struct(self,&board_hack,&board_qualifier);		
}

function board_qualifier(player)
{		
	
	if( zm_utility::all_chunks_intact( self.window.barrier_chunks ) || zm_utility::no_valid_repairable_boards( self, self.window.barrier_chunks ))
	{
		return false;
	}

	return true;
}
