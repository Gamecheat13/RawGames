#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_spawn_manager;

#namespace spawn_manager;

// --------------------------------------------------------------------------------
// ---- Debuging functions ----
// --------------------------------------------------------------------------------

/#

function spawn_manager_debug()
{
	for(;;)
	{
		if ( GetDvarString( "ai_debugSpawnManager" ) != "1" )
		{
			wait( 0.1 );
			continue;
		}

		managers = get_spawn_manager_array();
	
		managerActiveCount = 0;
		managerPotentialSpawnCount = 0;
		level.debugActiveManagers = [];
			
		for(i=0; i<managers.size; i++)
		{
			if( isdefined( managers[i] ) && isdefined( managers[i].enable ) )
			{
				// A spawn manager will be added to the debugActiveManagers if,
				// 1. Its currently enabled
				// 2. Disabled but active - It is disabled after enabling it before ( will be drawn in different color. )
				// 2nd case is true if self.enable is false but self.spawners is defined.
			
				if( ( managers[i].enable ) || ( !managers[i].enable && isdefined( managers[i].spawners ) ) )
				{
					if( ( managers[i].count < 0 ) || ( managers[i].count > managers[i].spawnCount ) )
					{
						// Only increament these counters for enabled spawn managers
						if( ( managers[i].enable ) && isdefined(managers[i].sm_active_count))
						{
							managerActiveCount += 1;
							managerPotentialSpawnCount += managers[i].sm_active_count;
						}
	
						level.debugActiveManagers[level.debugActiveManagers.size] = managers[i];
					}
				}
			}
		}
		
		// Draw the information on the screen
		spawn_manager_debug_hud_update( level.spawn_manager_active_ai,
									level.spawn_manager_total_count,
									level.spawn_manager_max_ai,
									managerActiveCount,
									managerPotentialSpawnCount
								   );

		{wait(.05);};
	}
}

function spawn_manager_debug_hud_update( active_ai, spawn_ai, max_ai, active_managers, potential_ai )
{
	if ( GetDvarString( "ai_debugSpawnManager" ) == "1" )
	{
		if(!isdefined(level.spawn_manager_debug_hud_title))
		{
			level.spawn_manager_debug_hud_title = NewHudElem();
			level.spawn_manager_debug_hud_title.alignX = "left";
			level.spawn_manager_debug_hud_title.x = 2;
			level.spawn_manager_debug_hud_title.y = 40;
			level.spawn_manager_debug_hud_title.fontScale = 1.5;
			level.spawn_manager_debug_hud_title.color = (1,1,1);
			//level.spawn_manager_debug_hud_title.font = "bigfixed";
		}

		if( !isdefined( level.spawn_manager_debug_hud ) )
		{
			level.spawn_manager_debug_hud = [];
		}

		level.spawn_manager_debug_hud_title SetText("SPAWN MANAGER: Total AI: "+spawn_ai+"  Active AI: "+active_ai+"/"+potential_ai+"  Max AI: "+max_ai+"  Active Managers: "+active_managers);

		for(i=0; i<level.debugActiveManagers.size; i++)
		{
			if( !isdefined( level.spawn_manager_debug_hud[i] ) )
			{
				level.spawn_manager_debug_hud[i] = NewHudElem();
				level.spawn_manager_debug_hud[i].alignX = "left";
				level.spawn_manager_debug_hud[i].x = 0;
				level.spawn_manager_debug_hud[i].fontScale = 1;
				level.spawn_manager_debug_hud[i].y = level.spawn_manager_debug_hud_title.y +(i+1) * 15;
			}

			// If level.current_debug_spawn_manager is defined then color that one differently
			if( isdefined( level.current_debug_spawn_manager ) && ( level.debugActiveManagers[i] ==  level.current_debug_spawn_manager ) )
			{
				if( !level.debugActiveManagers[i].enable ) // selected and disabled
				{
					level.spawn_manager_debug_hud[i].color = (0,0.4,0); // dark green
				}
				else // selected and enabled
				{
					level.spawn_manager_debug_hud[i].color = (0,1,0);	// green
				}
			}
			else if( level.debugActiveManagers[i].enable ) // enabled
			{
				level.spawn_manager_debug_hud[i].color = (1,1,1); // white
			}
			else // disabled but active
			{
				level.spawn_manager_debug_hud[i].color = (0.4,0.4,.4); // gray
			}

			
			text = "["+level.debugActiveManagers[i].sm_id+"]";
			text += "  Spawend AI Count: "+level.debugActiveManagers[i].spawnCount;
			text += "  Active Count: "+level.debugActiveManagers[i].activeAI.size+"/("+level.debugActiveManagers[i].sm_active_count_min+","+level.debugActiveManagers[i].sm_active_count_max+")";
			text += "  Spawners: "+level.debugActiveManagers[i].allSpawners.size;
			
			if( IsDefined( level.debugActiveManagers[i].sm_group_size ) )
				text +=	"  Group Size: "+level.debugActiveManagers[i].sm_group_size+"("+level.debugActiveManagers[i].sm_group_size_min+","+level.debugActiveManagers[i].sm_group_size_max+")";
				
			level.spawn_manager_debug_hud[i] SetText( text );
													
		}

		// After re-arrangement, we might have to delete extra hud elements
		if( level.debugActiveManagers.size < level.spawn_manager_debug_hud.size )
		{
			for( i = level.debugActiveManagers.size; i<level.spawn_manager_debug_hud.size; i++ )
			{
				if( isdefined( level.spawn_manager_debug_hud[i] ) )
				{
					level.spawn_manager_debug_hud[i] Destroy();
				}
			}
		}

	}
	
	// delete the hud elements so far allocated if debugging is turned off or there are no active managers
	if( ( GetDvarString( "ai_debugSpawnManager" ) != "1" ) )
	{
		// Clean-up Destroy the HUDs if created earlier
		if( isdefined( level.spawn_manager_debug_hud_title ) )
		{
			level.spawn_manager_debug_hud_title Destroy();
		}
	
		if( isdefined( level.spawn_manager_debug_hud ) )
		{
			for(i=0; i<level.spawn_manager_debug_hud.size; i++)
			{
				if( isdefined( level.spawn_manager_debug_hud ) && isdefined( level.spawn_manager_debug_hud[i] ) )
				{
					level.spawn_manager_debug_hud[i] Destroy();
				}
			}
			
			level.spawn_manager_debug_hud = undefined;
		}
	}
}


function on_player_connect()
{
	level thread spawn_manager_debug_spawn_manager();
}

// Reads debug dvars that set key value pairs for the specified spawn manager,
// allows tweaking one spawn manager at a time.
function spawn_manager_debug_spawn_manager()
{
	level notify("spawn_manager_debug_spawn_manager");
	level endon("spawn_manager_debug_spawn_manager");
	
	level.current_debug_spawn_manager = undefined;
	level.current_debug_spawn_manager_targetname = undefined;
	
	level.test_player = GetPlayers()[0];
	current_spawn_manager_index = -1;
	old_spawn_manager_index = undefined;

	while(1)
	{

		if( GetDvarString( "ai_debugSpawnManager" ) != "1" )
		{

			// destroy hud elements if they are allocated before.
			destroy_tweak_hud_elements();
			
			{wait(.05);};
			continue;
		}

		if( isdefined( level.debugActiveManagers ) && ( level.debugActiveManagers.size > 0 ) )
		{
			// First time getting in here, if there is a spawn manager active it will be set at 0'th index
			// in level.activeManagers array.
			if( current_spawn_manager_index == -1 )
			{
				current_spawn_manager_index = 0;
				old_spawn_manager_index = 0;
			}
				
			// Check shoulder button to see if player is in current spawn manager selection mode.
			if( level.test_player buttonPressed("BUTTON_LSHLDR") )
			{
				// save the old index to check if it was changed.
				old_spawn_manager_index = current_spawn_manager_index;

				// Decrement if DPAD_UP was pressed.
				if( level.test_player buttonPressed("DPAD_UP") )
				{
					current_spawn_manager_index--;
	
					if( current_spawn_manager_index < 0 )
					{
						current_spawn_manager_index = 0;
					}
				}
				
				// Increament if DPAD_DOWN was pressed.
				if( level.test_player buttonPressed("DPAD_DOWN") )
				{
					current_spawn_manager_index++;
	
					if( current_spawn_manager_index > level.debugActiveManagers.size - 1 )
					{
						current_spawn_manager_index = level.debugActiveManagers.size - 1;
					}
				}
			}

			// Find the selected spawn manager in the list
			if( isdefined( current_spawn_manager_index ) && current_spawn_manager_index != -1 )
			{
				if( isdefined( level.current_debug_spawn_manager ) && isdefined( level.debugActiveManagers[current_spawn_manager_index] ) )
				{
					if( isdefined ( old_spawn_manager_index )  && ( old_spawn_manager_index == current_spawn_manager_index ) )
					{
						// Even if current_spawn_manager_index didnt change, new spawn manager may be activated,
						// in that case we will need to reorder and find new value for current_spawn_manager_index to keep the old one seleted.
						if( level.debugActiveManagers[current_spawn_manager_index].targetname != level.current_debug_spawn_manager_targetname )
						{
							// Find a new index
							for(i=0; i<level.debugActiveManagers.size; i++)
							{
								if( level.debugActiveManagers[i].targetname == level.current_debug_spawn_manager_targetname )
								{
									// update the current_spawn_manager_index and old_spawn_manager_index
									current_spawn_manager_index = i;
									old_spawn_manager_index = i;
								}
							}
						}
					}
				}

				if( isdefined( level.debugActiveManagers[current_spawn_manager_index] ) )
				{
					level.current_debug_spawn_manager = level.debugActiveManagers[current_spawn_manager_index];
					level.current_debug_spawn_manager_targetname = level.debugActiveManagers[current_spawn_manager_index].targetname;
				}
			}
	
			// If found a spawn manager then read new k/v's and update it.
			if( isdefined( level.current_debug_spawn_manager ) )
			{
				level.current_debug_spawn_manager spawn_manager_debug_spawn_manager_values_dpad();
			}
		}
		else
		{
			// destroy hud elements if they are allocated before.
			destroy_tweak_hud_elements();
		}
		
		wait(0.25);
	}
}



function spawn_manager_debug_spawner_values()
{
	while(1)
	{
		if ( GetDvarString( "ai_debugSpawnManager" ) != "1" )
		{
			wait( 0.1 );
			continue;
		}

		if( isdefined( level.current_debug_spawn_manager ) )
		{
			spawn_manager = level.current_debug_spawn_manager;

			if( isdefined( spawn_manager.spawners ))
			{
				for( i = 0; i< spawn_manager.spawners.size; i++ )
				{
					current_spawner = spawn_manager.spawners[i];
					
					if( isdefined( current_spawner) && ( current_spawner.count > 0 ) )
					{
						spawnerFree = current_spawner.sm_active_count - current_spawner.activeAI.size;
						
						// print it on the top
						print3d( ( current_spawner.origin +( 0, 0, 65 ) ), "count:" + current_spawner.count , (0, 1, 0), 1, 1.25, 2 );
						print3d( ( current_spawner.origin +( 0, 0, 85 ) ), "sm_active_count:" + current_spawner.activeAI.size + "/" + spawnerFree + "/" + current_spawner.sm_active_count , (0, 1, 0), 1, 1.25, 2 );
		
					}
				}
			}
			
			{wait(.05);};
		}
		
		{wait(.05);};
	}
}


function ent_print(text)
{
	self endon( "death" );
	
	while( 1 )
	{
		print3d( ( self.origin +( 0, 0, 65 ) ), text, ( 0.48, 9.4, 0.76 ), 1, 1 );
		{wait(.05);};
	}
	
}


// This function lets the scripter tweak some spawn manager values on the fly.
function spawn_manager_debug_spawn_manager_values_dpad()
{

	// create huds for
	// 1. sm_active_count
	// 2. sm_group_size
	// 3. sm_spawner_count

	if( !isdefined( level.current_debug_index ) )
		level.current_debug_index = 0;

	// debug hud
	if( !isdefined( level.spawn_manager_debug_hud2 ) )
	{
		level.spawn_manager_debug_hud2 = NewHudElem();
		level.spawn_manager_debug_hud2.alignX = "left";
		level.spawn_manager_debug_hud2.x = 10;
		level.spawn_manager_debug_hud2.y = 150;
		level.spawn_manager_debug_hud2.fontScale = 1.25;
		level.spawn_manager_debug_hud2.color = (1,0,0);
	}
	
	// sm_active_count title index 0
	if( !isdefined( level.sm_active_count_title ) )
	{
		level.sm_active_count_title = NewHudElem();
		level.sm_active_count_title.alignX = "left";
		level.sm_active_count_title.x = 10;
		level.sm_active_count_title.y = 165;
		level.sm_active_count_title.color = (1,1,1);
	}

	// sm_active_count_min index 1
	if( !isdefined( level.sm_active_count_min_hud ) )
	{
		level.sm_active_count_min_hud = NewHudElem();
		level.sm_active_count_min_hud.alignX = "left";
		level.sm_active_count_min_hud.x = 10;
		level.sm_active_count_min_hud.y = 180;
		level.sm_active_count_min_hud.color = (1,1,1);
	}

	// sm_active_count_max index 2
	if( !isdefined( level.sm_active_count_max_hud ) )
	{
		level.sm_active_count_max_hud = NewHudElem();
		level.sm_active_count_max_hud.alignX = "left";
		level.sm_active_count_max_hud.x = 10;
		level.sm_active_count_max_hud.y = 195;
		level.sm_active_count_max_hud.color = (1,1,1);
	}

	// sm_group_size_min index 3
	if( !isdefined( level.sm_group_size_min_hud) )
	{
		level.sm_group_size_min_hud = NewHudElem();
		level.sm_group_size_min_hud.alignX = "left";
		level.sm_group_size_min_hud.x = 10;
		level.sm_group_size_min_hud.y = 210;
		level.sm_group_size_min_hud.color = (1,1,1);
	}

	// sm_group_size_max index 4
	if( !isdefined( level.sm_group_size_max_hud ) )
	{
		level.sm_group_size_max_hud = NewHudElem();
		level.sm_group_size_max_hud.alignX = "left";
		level.sm_group_size_max_hud.x = 10;
		level.sm_group_size_max_hud.y = 225;
		level.sm_group_size_max_hud.color = (1,1,1);
	}

	// sm_spawner_count title index 5
	if( !isdefined( level.sm_spawner_count_title) )
	{
		level.sm_spawner_count_title = NewHudElem();
		level.sm_spawner_count_title.alignX = "left";
		level.sm_spawner_count_title.x = 10;
		level.sm_spawner_count_title.y = 240;
		level.sm_spawner_count_title.color = (1,1,1);
	}
	
	// sm_spawner_count_min index 5
	if( !isdefined( level.sm_spawner_count_min_hud) )
	{
		level.sm_spawner_count_min_hud = NewHudElem();
		level.sm_spawner_count_min_hud.alignX = "left";
		level.sm_spawner_count_min_hud.x = 10;
		level.sm_spawner_count_min_hud.y = 255;
		level.sm_spawner_count_min_hud.color = (1,1,1);
	}

	// sm_spawner_count_max index 5
	if( !isdefined( level.sm_spawner_count_max_hud) )
	{
		level.sm_spawner_count_max_hud = NewHudElem();
		level.sm_spawner_count_max_hud.alignX = "left";
		level.sm_spawner_count_max_hud.x = 10;
		level.sm_spawner_count_max_hud.y = 270;
		level.sm_spawner_count_max_hud.color = (1,1,1);
	}
	
	if( level.test_player buttonPressed("BUTTON_LTRIG") )
	{
		if( level.test_player buttonPressed("DPAD_DOWN") )
		{
			level.current_debug_index++;

			if( level.current_debug_index > 7 )
				level.current_debug_index = 7;
		}
		
		if( level.test_player buttonPressed("DPAD_UP") )
		{
			level.current_debug_index--;
			
			if( level.current_debug_index < 0 )
				level.current_debug_index = 0;
		}
	}

	// update the selection
	set_debug_hud_colors();

	increase_value = false;
	decrease_value = false;
	
	// decide to increase or decrese / or dont change, based on the input
	if( level.test_player buttonPressed("BUTTON_LTRIG") )
	{
		if( level.test_player buttonPressed("DPAD_LEFT") )
		{
			decrease_value = true;
		}
			
		if( level.test_player buttonPressed("DPAD_RIGHT") )
		{
			increase_value = true;
		}
	}
	
	should_run_set_up = false;

	// select the proper k/v based on the level.current_debug_index and modify it.
	if( increase_value || decrease_value )
	{
		if( increase_value )
			add = 1;
		else
			add = -1;
		
		switch( level.current_debug_index )
		{
			case 0:
			{
				// sm_active_count
				if( self.sm_active_count + add > self.sm_active_count_max )
				{
					self.sm_active_count_max = self.sm_active_count + add;
				}
				
				if( self.sm_active_count + add < self.sm_active_count_min )
				{
					if( self.sm_active_count + add > 0)
					{
						self.sm_active_count_min = self.sm_active_count + add;
					}
				}

				should_run_set_up = true;
				self.sm_active_count += add;
				break;
			}
			case 1:
			{
				// sm_active_count_min
				if(self.sm_active_count_min + add < self.sm_group_size_max)
				{
					modify_debug_hud2("sm_active_count_min cant be smaller than sm_group_size_max, modify sm_group_size_max and try again.");
					break;
				}
	
				if(self.sm_active_count_min + add > self.sm_active_count_max)
				{
					modify_debug_hud2("sm_active_count_min cant be greater than sm_active_count_max, modify sm_active_count_max and try again.");
					break;
				}
				
				should_run_set_up = true;
				self.sm_active_count_min += add;
				break;
			}
			case 2:
			{
				// sm_active_count_max
				if(self.sm_active_count_max + add < self.sm_active_count_min)
				{
					modify_debug_hud2("sm_active_count_max cant be smaller than sm_active_count_min, modify sm_active_count_min and try again.");
					break;
				}

				should_run_set_up = true;
				self.sm_active_count_max += add;
				break;
			}
			case 3:
			{
				// sm_group_size_min
				if(self.sm_group_size_min + add > self.sm_group_size_max)
				{
					modify_debug_hud2("sm_group_size_min cant be greater than sm_group_size_max, modify sm_group_size_max and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_group_size_min += add;
				break;
			}
			case 4:
			{
				// sm_group_size_max
				if(self.sm_group_size_max + add < self.sm_group_size_min )
				{
					modify_debug_hud2("sm_group_size_max cant be smaller than sm_group_size_min, modify sm_group_size_min and try again.");
					break;
				}

				if(self.sm_group_size_max + add > self.sm_active_count )
				{
					modify_debug_hud2("sm_group_size_max cant be greater than sm_active_count, modify sm_active_count and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_group_size_max += add;
				break;
			}
			case 5:
			{
				// sm_spawner_count
				if(self.sm_spawner_count + add > self.allSpawners.size )
				{
					modify_debug_hud2("sm_spawner_count cant be greater than max possible available spawners, add more spawners in the map and try again.");
					break;
				}

				if(self.sm_spawner_count + add <= 0 )
				{
					modify_debug_hud2("sm_spawner_count cant be less than 0.");
					break;
				}
				
				if(self.sm_spawner_count + add < self.sm_spawner_count_min )
				{
					if( self.sm_spawner_count + add > 0)
					{
						self.sm_spawner_count_min = self.sm_spawner_count + add;
					}
					
				}

				if(self.sm_spawner_count + add > self.sm_spawner_count_max )
				{
					self.sm_spawner_count_max = self.sm_spawner_count + add;
				}
								
				should_run_set_up = true;
				self.sm_spawner_count += add;
				break;
			}
			case 6:
			{
				// sm_spawner_count_min
				if(self.sm_spawner_count_min + add > self.sm_spawner_count_max )
				{
					modify_debug_hud2("sm_spawner_count_min cant be greater than sm_spawner_count_max, modify sm_spawner_count_max and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_spawner_count_min += add;
				break;
			}
			case 7:
			{
				// sm_spawner_count_max
				if(self.sm_spawner_count_max + add < self.sm_spawner_count_min )
				{
					modify_debug_hud2("sm_spawner_count_max cant be smaller than sm_spawner_count_min, modify sm_spawner_count_min and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_spawner_count_max += add;
				break;
			}

		}
	}

	// Run the basic set up to use the new values
	if( should_run_set_up )
	{
		level.current_debug_spawn_manager spawn_manager_debug_setup();
	}

	// draw stuff on the screen
	if( isdefined( self ) )
	{
		level.sm_active_count_min_hud SetText( "sm_active_count_min: " + self.sm_active_count_min );
		level.sm_active_count_max_hud SetText( "sm_active_count_max: " + self.sm_active_count_max );
		
		level.sm_group_size_min_hud SetText( "sm_group_count_min: " + self.sm_group_size_min );
		level.sm_group_size_max_hud SetText( "sm_group_count_max: " + self.sm_group_size_max );

		if( IsDefined( self.sm_spawner_count ) )
		{
			level.sm_spawner_count_title SetText( "sm_spawner_count: " + self.sm_spawner_count );
			level.sm_spawner_count_min_hud SetText( "sm_spawner_count_min: " + self.sm_spawner_count_min );
			level.sm_spawner_count_max_hud SetText( "sm_spawner_count_max: " + self.sm_spawner_count_max );
		}	
	}
}



function set_debug_hud_colors()
{
	switch( level.current_debug_index )
	{
		case 0:
		{
			level.sm_active_count_title.color = (0,1,0);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 1:
		{
			level.sm_active_count_title.color = ( 1,1,1 );
			level.sm_active_count_min_hud.color = (0,1,0);
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 2:
		{
			level.sm_active_count_title.color = ( 1,1,1 );
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = (0,1,0);
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 3:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = (0,1,0);
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );

			break;
		}
		case 4:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = (0,1,0);
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 5:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = (0,1,0);
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 6:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = (1,1,1);
			level.sm_spawner_count_min_hud.color = ( 0,1,0 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 7:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 0,1,0 );
			
			break;
		}
	}
}


function spawn_manager_debug_setup()
{
	//-----------------------------------------------------------------------------------------------
	// sm_spawner_count - The number of spawners that spawn manager will randomly select from the full
	// set of the available spawners, defaults to number of spawners in the spawn manager.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if( isdefined( level.current_debug_index ) && ( level.current_debug_index != 5 ) )
	{
		self.sm_spawner_count = RandomIntRange( self.sm_spawner_count_min, self.sm_spawner_count_max + 1 );
	}

	//-----------------------------------------------------------------------------------------------
	// sm_active_count - Total number of AI that can be active from this spawner,
	// defaults to number of spawners in the spawn manager.
	// supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	// select the random between min and max only if they are changed
	if( isdefined( level.current_debug_index ) && ( level.current_debug_index != 0 ) )
	{
		self.sm_active_count = RandomIntRange(self.sm_active_count_min, self.sm_active_count_max+1);
	}
		
	// Grab all the spawners and store it on spawn manager entity.
	self.spawners = self spawn_manager_get_spawners();

	// Sanity Checks if needed
	Assert(self.count >= self.count_min);
	Assert(self.count <= self.count_max);

	Assert(self.sm_active_count >= self.sm_active_count_min);
	Assert(self.sm_active_count <= self.sm_active_count_max);

	// sm_group_size min and max should be less than sm_active_cpunt
	Assert(self.sm_group_size_max <= self.sm_active_count);
	Assert(self.sm_group_size_min <= self.sm_active_count);
}


function modify_debug_hud2(text)
{
	self notify("modified");

	{wait(.05);};

	level.spawn_manager_debug_hud2 SetText( text );
	level.spawn_manager_debug_hud2 thread moniter_debug_hud2();
}

// waits certain amount of time and then erases the error message,
// this thread is killed if the message is updated, and new thread starts.
function moniter_debug_hud2()
{
	self endon("modified");

	wait(10);
	level.spawn_manager_debug_hud2 SetText("");
}


function destroy_tweak_hud_elements()
{
	if( isdefined( level.sm_active_count_title ) )
	{
		level.sm_active_count_title Destroy();
	}

	if( isdefined( level.sm_active_count_min_hud ) )
	{

		level.sm_active_count_min_hud Destroy();
	}
	
	if( isdefined( level.sm_active_count_max_hud ) )
	{
		level.sm_active_count_max_hud Destroy();
	}


	if( isdefined( level.sm_group_size_min_hud ) )
	{
		level.sm_group_size_min_hud Destroy();

	}

	if( isdefined( level.sm_group_size_max_hud ) )
	{

		level.sm_group_size_max_hud Destroy();
	}

	if( isdefined( level.sm_spawner_count_title ) )
	{

		level.sm_spawner_count_title Destroy();
	}

	if( isdefined( level.sm_spawner_count_min_hud ) )
	{

		level.sm_spawner_count_min_hud Destroy();
	}

	if( isdefined( level.sm_spawner_count_max_hud ) )
	{

		level.sm_spawner_count_max_hud Destroy();
	}
}

#/
