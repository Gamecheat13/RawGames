#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;

                                                                                       	                                

#namespace hacker_util;

/*
 * Hacker tool script struct values of interest
 *
 * script_noteworthy:  hackable_*
 *
 * script_int: 		cost
 * script_float: 	time in seconds
 * targetname:		If set, will be filled in with the 'owner' struct or ent of the hackable struct, so that we can get access to any 'useful' 
 *								data in there.
 *								Also, the hacker tool will send a "hacked" notify to that ent or struct on successful hack.
 * radius:  			If set, used for the hacker tool activation radius
 * height:				If set, used for the hacker tool activation radius
 * 
 */
 
function register_pooled_hackable_struct(struct, callback_func, qualifier_func)
{
	level._hacker_pooled = true;
	
	register_hackable_struct(struct, callback_func, qualifier_func);
	
	level._hacker_pooled = undefined;
}

function register_hackable_struct(struct, callback_func, qualifier_func)
{
	
	if(!IsInArray(level._hackable_objects, struct))
	{
		struct._hack_callback_func = callback_func;
		struct._hack_qualifier_func = qualifier_func;
		
		struct.pooled = level._hacker_pooled;
				
		if(isdefined(struct.targetname))
		{
			struct.hacker_target = GetEnt(struct.targetname, "targetname");
		}
		
		level._hackable_objects[level._hackable_objects.size] = struct;
		
		if(isdefined(level._hacker_pooled))
		{
			level._pooled_hackable_objects[level._pooled_hackable_objects.size] = struct;				
		}
		
		struct thread hackable_object_thread();
	}
}

function deregister_hackable_struct(struct)
{
	if(IsInArray(level._hackable_objects, struct))
	{
		new_list = [];
		
		for(i = 0; i < level._hackable_objects.size; i ++)
		{
			if(level._hackable_objects[i] != struct)
			{
				new_list[new_list.size] = level._hackable_objects[i];
			}
			else
			{
				level._hackable_objects[i] notify("hackable_deregistered");
				
				if(isdefined(level._hackable_objects[i]._trigger))
				{
					level._hackable_objects[i]._trigger Delete();
				}
				
				if(isdefined(level._hackable_objects[i].pooled) && level._hackable_objects[i].pooled)
				{
					ArrayRemoveValue(level._hacker_pool, level._hackable_objects[i]);
					ArrayRemoveValue(level._pooled_hackable_objects, level._hackable_objects[i]);
				}

			}	
		}
		
		level._hackable_objects = new_list;
	}
}

function lowreadywatcher(player)
{
	player endon("disconnected");
	self endon("kill_lowreadywatcher");
	self waittill("hackable_deregistered");
	
//	player setlowready(false);
}

function hackable_object_thread()
{
	self endon("hackable_deregistered");

	height = 72;
	radius = 64;
	
	if(isdefined(self.radius))
	{
		radius = self.radius;
	}
	
	if(isdefined(self.height))
	{
		height = self.height;
	}
	
	if(!isdefined(self.pooled))
	{
		trigger = spawn( "trigger_radius_use", self.origin, 0, radius, height);
		trigger UseTriggerRequireLookAt();
		trigger SetCursorHint( "HINT_NOICON" );
		trigger.radius = radius;
		trigger.height = height;
		trigger.beingHacked = false;
		
		self._trigger = trigger;
	}
		
	cost = 0;
	
	if(isdefined(self.script_int))
	{
		cost = self.script_int;
	}
	
	duration = 1.0;
	
	if(isdefined(self.script_float))
	{
		duration = self.script_float;
	}
	
	while(1)
	{
		wait(0.1);
		
		if(!isdefined(self._trigger))
		{
			continue;
		}
		
		players = GetPlayers();
	
		if(isdefined(self._trigger))
		{	
			self._trigger SetHintString("");
			
			if(isdefined(self.entity))
			{
				self.origin = self.entity.origin;
				self._trigger.origin = self.entity.origin;
				
				if(isdefined(self.trigger_offset))
				{
					self._trigger.origin += self.trigger_offset;
				}
			}
		}
		
		for ( i = 0; i < players.size; i++ )
		{

			if ( players[i] can_hack( self ) )
			{
				self set_hack_hint_string();
				break;			
			}
		}
		
		for ( i = 0; i < players.size; i++ )
		{
			hacker = players[i];
			
			if ( !hacker is_hacking( self ) )
			{
				continue;
			}		
		
			if( hacker.score >= cost || cost <= 0)
			{
	
//				hacker setlowready(true);
				
				self thread lowreadywatcher(hacker);
	
				hack_success = hacker hacker_do_hack( self );

				self notify("kill_lowreadywatcher");
				if(isdefined(hacker))
				{
//					hacker setlowready(false);
				}
		
				if(isdefined(hacker) && hack_success)
				{
					if(cost)
					{
						if(cost > 0)
						{
							hacker zm_score::minus_to_player_score( cost ); 
						}
						else
						{
							hacker zm_score::add_to_player_score( cost * -1 );
						}
					}

					hacker notify( "successful_hack" );
					if(isdefined(self._hack_callback_func))
					{
						self thread [[self._hack_callback_func]](hacker);	// may well terminate this thread.
					}
					
				}
			}
			else
			{
				hacker zm_utility::play_sound_on_ent( "no_purchase" );
				hacker zm_audio::create_and_play_dialog( "general", "outofmoney", 1 );
			}
		}
	}
}

function is_hacking( hackable )
{	
	return ( can_hack( hackable ) && self UseButtonPressed() );
}

function hacker_do_hack( hackable )
{
//	assert( self zm_laststand::is_reviving( playerBeingRevived ) );
	// reviveTime used to be set from a Dvar, but this can no longer be tunable:
	// it has to match the length of the third-person revive animations for
	// co-op gameplay to run smoothly.

	timer = 0;
	hacked = false;
	
	hackable._trigger.beingHacked = true;

	if( !isdefined(self.hackerProgressBar) )
	{
		self.hackerProgressBar = self hud::createPrimaryProgressBar();
	}

	if( !isdefined(self.hackerTextHud) )
	{
		self.hackerTextHud = newclientHudElem( self );	
	}
	
	hack_duration = hackable.script_float;

	if(self hasperk( "specialty_fastreload" ))
	{
		hack_duration *= 0.66;
	}
	
	hack_duration = max(1.5, hack_duration);
	
	self thread tidy_on_deregister(hackable);
	self.hackerProgressBar hud::updateBar( 0.01, 1 / hack_duration );

	self.hackerTextHud.alignX = "center";
	self.hackerTextHud.alignY = "middle";
	self.hackerTextHud.horzAlign = "center";
	self.hackerTextHud.vertAlign = "bottom";
	self.hackerTextHud.y = -113;
	if ( IsSplitScreen() )
	{
		self.hackerTextHud.y = -107;
	}
	self.hackerTextHud.foreground = true;
	self.hackerTextHud.font = "default";
	self.hackerTextHud.fontScale = 1.8;
	self.hackerTextHud.alpha = 1;
	self.hackerTextHud.color = ( 1.0, 1.0, 1.0 );
	self.hackerTextHud setText( &"ZOMBIE_HACKING" );
	
	//self playsound( "vox_mcomp_hack_inprogress" );
	self playloopsound( "zmb_progress_bar", .5 );
	
	//chrisp - zombiemode addition for reviving vo
	// cut , but leave the script just in case 
	//self thread say_reviving_vo();
	
	while( self is_hacking ( hackable ) )
	{
		{wait(.05);};					
		timer += 0.05;			

		if ( self laststand::player_is_in_laststand() )
		{
			break;
		}
		
		if( timer >= hack_duration)
		{
			hacked = true;	
			break;
		}
	}
	
	self stoploopsound( .5 );
	if( hacked )
	{
		self playsound( "vox_mcomp_hack_success" );
	}
	else
	{
		self playsound( "vox_mcomp_hack_fail" );
	}
	
	if( isdefined( self.hackerProgressBar ) )
	{
		self.hackerProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.hackerTextHud ) )
	{
		self.hackerTextHud destroy();
	}
	
	hackable set_hack_hint_string();

	if(isdefined(hackable._trigger))
	{
		hackable._trigger.beingHacked = false;
	}
	
	self notify("clean_up_tidy_up");
	
	return hacked;
}

function set_hack_hint_string()
{
	if(isdefined(self._trigger))
	{
		if(isdefined(self.custom_string))
		{
			self._trigger SetHintString(self.custom_string);
		}
		else
		{
			if(!isdefined(self.script_int) || self.script_int <= 0)
			{
				self._trigger SetHintString(&"ZOMBIE_HACK_NO_COST");
			}
			else
			{
				self._trigger SetHintString(&"ZOMBIE_HACK", self.script_int);
			}
		}
	}
}

function can_hack( hackable )
{
	if ( !isAlive( self ) )
	{
		return false;
	}

	if ( self laststand::player_is_in_laststand() )
	{
		return false;
	}
	
	if(!self zm_equipment::hacker_active() )
	{
		return false;
	}
	
	if( !isdefined( hackable._trigger ) )
	{
		return false;
	}

	if( isdefined(hackable.player) )
	{
		if(hackable.player != self)
		{
			return false;
		}
	}

	if(self throwbuttonpressed())
	{
		return false;
	}

	if(self FragButtonPressed())
	{
		return false;
	}

	if(isdefined(hackable._hack_qualifier_func))
	{
		if(!hackable [[hackable._hack_qualifier_func]](self))
		{
			return false;
		}
	}
	
	if( !IsInArray( level._hackable_objects, hackable ) )
	{
		return false;
	}

	radsquared = 32 * 32;
	
	if(isdefined(hackable.radius))
	{
		radsquared = hackable.radius * hackable.radius;
	}	

	origin = hackable.origin;
	
	if(isdefined(hackable.entity))
	{
		origin = hackable.entity.origin;
	}

	if(distance2dsquared(self.origin, origin) > radsquared)
	{
		return false;
	}

	if ( !isdefined(hackable.no_touch_check) && !self IsTouching( hackable._trigger ) )
	{
		return false;
	}
		
	if ( !self is_facing( hackable ) )
	{
		return false;
	}

	if( !isdefined(hackable.no_sight_check) && !SightTracePassed( self.origin + ( 0, 0, 50 ), origin, false, undefined ) )				
	{
		return false;
	}

	if( !isdefined(hackable.no_bullet_trace) && !bullettracepassed(self.origin + (0,0,50), origin, false, undefined) )
	{
		return false;
	}
	
		return true;
}

function hide_hint_when_hackers_active(custom_logic_func, custom_logic_func_param)
{
	invis_to_any = 0;
	
	while(1)
	{
		if(isdefined(custom_logic_func))
		{
			self [[custom_logic_func]](custom_logic_func_param);
		}
		
		if( any_hackers_active() )
		{
			players = GetPlayers();
			
			for(i = 0; i < players.size; i ++)
			{
				if ( players[i] zm_equipment::hacker_active() )
				{
					self SetInvisibleToPlayer( players[i], true );
					invis_to_any = 1;
				}
				else
				{
					self SetInvisibleToPlayer( players[i], false );
				}						
			}
		}
		else
		{
			if(invis_to_any)
			{
				invis_to_any = 0;
				players = GetPlayers();
				
				for(i = 0; i < players.size; i ++)
				{
					self SetInvisibleToPlayer( players[i], false );
				}
			}
		}
		wait(0.1);
	}
}

function any_hackers_active()
{
	players = GetPlayers();
	
	for(i = 0; i < players.size; i ++)
	{
		if(players[i] zm_equipment::hacker_active())
		{
			return true;
		}
	}	
	
	return false;;
}

function register_pooled_hackable(name, callback_func, qualifier_func)
{
	level._hacker_pooled = true;
	
	register_hackable(name, callback_func, qualifier_func);
	
	level._hacker_pooled = undefined;
}

function register_hackable(name, callback_func, qualifier_func)
{
	structs = struct::get_array(name, "script_noteworthy");
	
	if(!isdefined(structs))
	{
		/#
		PrintLn("Error:  register_hackable called on script_noteworthy " + name + " but no such structs exist.");
		#/
		return;	
	}
	
	for(i = 0; i < structs.size; i ++)
	{
		if(!IsInArray(level._hackable_objects, structs[i]))
		{
			structs[i]._hack_callback_func = callback_func;
			structs[i]._hack_qualifier_func = qualifier_func;
			
			structs[i].pooled = level._hacker_pooled;
					
			if(isdefined(structs[i].targetname))
			{
				structs[i].hacker_target = GetEnt(structs[i].targetname, "targetname");
			}
			
			level._hackable_objects[level._hackable_objects.size] = structs[i];
			
			if(isdefined(level._hacker_pooled))
			{
				level._pooled_hackable_objects[level._pooled_hackable_objects.size] = structs[i];				
			}
			
			structs[i] thread hackable_object_thread();
			util::wait_network_frame();
		}
	}
}

function deregister_hackable(noteworthy)
{
	new_list = [];
	
	for(i = 0; i < level._hackable_objects.size; i ++)
	{
		if(!isdefined(level._hackable_objects[i].script_noteworthy) || level._hackable_objects[i].script_noteworthy != noteworthy)
		{
			new_list[new_list.size] = level._hackable_objects[i];
		}
		else
		{
			level._hackable_objects[i] notify("hackable_deregistered");
			
			if(isdefined(level._hackable_objects[i]._trigger))
			{
				level._hackable_objects[i]._trigger Delete();
			}
		}
		
		if(isdefined(level._hackable_objects[i].pooled) && level._hackable_objects[i].pooled)
		{
			ArrayRemoveValue(level._hacker_pool, level._hackable_objects[i]);
		}
	}
	
	level._hackable_objects = new_list;
}

function tidy_on_deregister(hackable)
{
	self endon("clean_up_tidy_up");
	hackable waittill("hackable_deregistered");

	if( isdefined( self.hackerProgressBar ) )
	{
		self.hackerProgressBar hud::destroyElem();
	}
	
	if( isdefined( self.hackerTextHud ) )
	{
		self.hackerTextHud destroy();
	}	

}

function is_facing( facee )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	
	dot_limit = 0.8;
	
	if(isdefined(facee.dot_limit))
	{
		dot_limit = facee.dot_limit;
	}
	
	return ( dotProduct > dot_limit ); // reviver is facing within a ~52-degree cone of the player
}
