#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_util;
#using scripts\shared\stealth;
#using scripts\shared\stealth_status;
#using scripts\shared\stealth_event;
#using scripts\cp\_objectives;
#using scripts\shared\flag_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace stealth_interact;

#precache( "string", "STEALTH_ASSASSINATE" );
#precache( "string", "STEALTH_HIDE_TUTORIAL_ACTIONS" );
#precache( "string", "STEALTH_HIDE_ACTIONS" );
#precache( "string", "STEALTH_WHISTLE" );
	
/*
	STEALTH - World Interaction Features
*/

// ============================================================================
// ==                                                                        ==
// ==  Stealth Melee Assassinate                                             ==
// ==                                                                        ==
// ============================================================================

function melee_setup( )
{
	while ( 1 ) 
	{
		playerList = GetPlayers();
		foreach ( player in playerList ) 
		{
			if ( isDefined( player.stealth ) && !isDefined( player.stealth.melee ) )
			{
				player.stealth.melee = true;
				player thread melee_monitor_status();
				player thread melee_monitor_execute();
			}
		}
		
		{wait(.05);};
	}
}

function melee_monitor_status() // self = player
{
	self endon("disconnect");
	self endon("stop_stealth");
				
	while ( isDefined( level.stealth ) )
	{
		potentialVictim = undefined;
		potentialVictimDistSq = -1;
		fwdSelf = AnglesToForward( self GetPlayerAngles() );
		
		if ( !(isDefined( self._o_scene ) && self._o_scene._str_state == "play") )
		{
			// Get closest enemy within limited range in front of the player who is facing away from player	
			foreach ( enemy in level.stealth.enemies[self.team] )
			{
				if ( isActor( enemy ) && isAlive( enemy ) )
				{
					distSq = DistanceSquared( enemy.origin, self.origin );
					if ( distSq < 100 * 100 )
					{
						dirEnemy = VectorNormalize( enemy.origin - self.origin );
						if ( VectorDot( fwdSelf, dirEnemy ) > 0.7 )
						{
							fwdEnemy = AnglesToForward( enemy.angles );
							if ( VectorDot( fwdSelf, fwdEnemy ) > 0.7 )
							{
								if ( !isDefined( potentialVictim ) || potentialVictimDistSq > distSq )
								{
									potentialVictim = enemy;
									potentialVictimDistSq = distSq;
								}
							}
						}
					}
				}
			}
		}

		if ( isDefined( potentialVictim ) && !isDefined( self GetLinkedEnt() ) )
		{
			self AllowMelee( false );

			if ( !isDefined( self.stealth.player_assassinate_help_active ) )
			{
				// display "[{+melee}] to Assassinate" on the screen
				self thread util::screen_message_create_client( &"STEALTH_ASSASSINATE", undefined, undefined, 125, 0 );
				self.stealth.player_assassinate_help_active = true;
			}
			
			if ( self MeleeButtonPressed() )
				self notify( "stealth_melee", potentialVictim );
		}
		else
		{
			self AllowMelee( true );

			if ( ( isdefined( self.stealth.player_assassinate_help_active ) && self.stealth.player_assassinate_help_active ) )
			{
				self.stealth.player_assassinate_help_active = undefined;
				self util::screen_message_delete_client();
			}
		}
		
		{wait(.05);};
	}	

	self AllowMelee( true );

	if ( ( isdefined( self.stealth.player_assassinate_help_active ) && self.stealth.player_assassinate_help_active ) )
	{
		self.stealth.player_assassinate_help_active = undefined;
		self util::screen_message_delete_client();
	}
}

function melee_monitor_execute() // self = player
{
	self endon("disconnect");
	self endon("stop_stealth");
				
	while ( 1 )
	{
		self waittill( "stealth_melee", victim );

		if ( ( isdefined( self.stealth.player_assassinate_help_active ) && self.stealth.player_assassinate_help_active ) )
		{
			self.stealth.player_assassinate_help_active = undefined;
			self util::screen_message_delete_client();
		}
		
		if ( !isDefined( victim ) || !isAlive( victim ) || !isActor( victim ) )
			continue;

		victim stealth::agent_stop();
		
		victim ai::set_ignoreall( true );

		scene_root = SpawnStruct();
		scene_root.origin = self.origin;
		scene_root.angles = self.angles;

		victim stealth_event::broadcast_to_team( victim.team, victim.origin, 150, 100, true, "witness_combat", self, "witnessed_melee" );

		scene_root scene::play( "cin_ven_gen_stealthkill_a", array( self, victim ) );
		
		if ( isAlive( victim ) && isActor( victim ) )
			victim DoDamage( victim.health, self.origin, self, self, victim.origin, "MOD_MELEE_ASSASSINATE" );

		scene_root = undefined;
	}
}

// ============================================================================
// ==                                                                        ==
// ==  Hide Spots                                                            ==
// ==                                                                        ==
// ============================================================================

/@
"Name: hide_spot_setup( <name>, <key> )"
"Summary: Sets up hiding spot triggers in your map"
"Module: Stealth"
"Example: stealth::hide_spot_setup( "hide_spot_use_trigger", "targetname" );"
"SPMP: singleplayer"
@/
function hide_spot_setup( name, key )
{
	hide_spot_use_triggers = GetEntArray( name, key );
	array::thread_all( hide_spot_use_triggers, &hide_spot_trigger_wait );
}

function hide_spot_trigger_wait()
{
	self endon( "death" );
	
	if ( isdefined( self.script_noteworthy ) )
		self.type = self.script_noteworthy;
	
	if( IsDefined( self.script_parameters ) && ( self.script_parameters == "1" || self.script_parameters == "2" || self.script_parameters == "3" || self.script_parameters == "4" ) )
	{
		self MakeUnusable();
		
		while( !level flag::get( "hide_spot_enter_allowed" ) )
		{
			wait(0.05);
			continue;
		}
	}
	
	self SetHintString( &"STEALTH_HIDE" );
	self.targets = getentarray( self.target, "targetname" );
	
	foreach ( target in self.targets )
	{
		if ( isdefined( target.script_noteworthy ) && target.script_noteworthy == "player_link_spot" )
			self.player_link_spot = target;
		
		if ( isdefined( target.script_noteworthy ) && target.script_noteworthy == "player_exit_spot" )
		{
			self.player_exit_spot = target;
		}

		if ( isdefined( target.script_noteworthy ) && target.script_noteworthy == "door_left" )
			self.door_left = target;
		
		if ( isdefined( target.script_noteworthy ) && target.script_noteworthy == "door_right" )
			self.door_right = target;
		
		if ( isdefined( target.script_noteworthy ) && target.script_noteworthy == "shutter_scripted_node" )
		{
			self.scripted_node = target;
			self.scripted_node scene::init( "cin_ven_hideyhole_window_vign_enter" );
		}
		
		self.distraction_node = GetNearestNode( self.origin );
	}
	
	while( 1 )
	{
		self trigger::wait_till();
		
		if( IsDefined( self.objective_target ) )
		{
			//objectives::complete( "cp_standard_breadcrumb", self.objective_target );
			objectives::complete( "obj_hide_tutorial", self.objective_target );
			
			if( IsDefined( level.hide_tutorial_counter ) )
			{
			   	level.hide_tutorial_counter ++;
			   	
			   	if( level.hide_tutorial_counter >= level.players.size )
			   	{
			   		level flag::set( "all_players_hiding" );
			   	}
			}	   
		}
		
		self MakeUnusable();
		
		if ( self.type == "door_left" || self.type == "door_right" )
		{
			self thread rotate_object( "in", 0.75 );
			
			self.who PlayerLinkToBlend( self.player_link_spot, "tag_origin", 1.5 );
			self.who disableweapons();
			self.who enableinvulnerability();
			self.who util::freeze_player_controls( true );
			self.who allowprone( false );
			self.who allowcrouch( false );
			self.who setstance( "stand" );
			wait 1.5;
			self thread rotate_object( "out", 0.25 );
			self.who PlayerLinkToDelta( self.player_link_spot, "tag_origin", 1.0, 35, 35, 10, 10 );
		}
		
		else if ( self.type == "shutter" )
		{
			self.scripted_node scene::play( "cin_ven_hideyhole_window_vign_enter", self.who );
			
			self.scripted_node thread scene::play ( "cin_ven_hideyhole_window_vign_idle", self.who );
		}
		
		if( IsDefined( self.script_parameters ) && ( self.script_parameters == "1" || self.script_parameters == "2" || self.script_parameters == "3" || self.script_parameters == "4" ) )
		{
			if( !level flag::get( "hide_spot_exit_allowed" ) )
			{
				self.who thread util::screen_message_create_client( &"STEALTH_HIDE_TUTORIAL_ACTIONS", undefined, undefined, 125, 0 );
			}
			else
			{
				self.who thread util::screen_message_create_client( &"STEALTH_HIDE_ACTIONS", undefined, undefined, 125, 0 );
			}
		}
		else
		{
			self.who thread util::screen_message_create_client( &"STEALTH_HIDE_ACTIONS", undefined, undefined, 125, 0 );
		}
		
		while ( 1 )
		{
			if( IsDefined( self.script_parameters ) && ( self.script_parameters == "1" || self.script_parameters == "2" || self.script_parameters == "3" || self.script_parameters == "4" ) )
			{
				if( level flag::get( "hide_spot_exit_allowed" ) )
				{
					if( !IsDefined( self.who.regular_hide_hint ) )
					{
						self.who util::screen_message_delete_client();
						self.who thread util::screen_message_create_client( &"STEALTH_HIDE_ACTIONS", undefined, undefined, 125, 0 );
						self.who.regular_hide_hint = true;
					}
				}
			}

			if ( self.who meleebuttonpressed() )
			{
				//if a guy is here, do the melee kill
				if ( isNodeOccupied( self.distraction_node ) )
				{
					enemy = getNodeOwner( self.distraction_node );
					
					if ( Distance2DSquared( enemy.origin, self.distraction_node.origin ) < ( 32 * 32 ) )
					{
						if ( isdefined( enemy ) && isalive( enemy ) )
						{
							self.who util::screen_message_delete_client();
							
							enemy stealth_status::clean_icon();
							
							if ( self.type == "door_left" || self.type == "door_right" )
							{
								self thread rotate_object( "out", 0.25 );
								self.who PlayerLinkToBlend( self.player_exit_spot, "tag_origin", 0.5 );
								wait 0.5;
								enemy_linker = util::spawn_model( "tag_origin", enemy.origin, enemy.angles );
								enemy linkto( enemy_linker, "tag_origin" );
								enemy_linker moveto( self.player_link_spot.origin, 0.5 );
								enemy_linker rotateto( self.player_link_spot.angles, 0.5 );
								self.who PlayerLinkToBlend( self.player_link_spot, "tag_origin", 0.5 );
								wait 0.5;
							}
							
							else if ( self.type == "shutter" )
							{
								self.scripted_node scene::play( "cin_ven_hideyhole_window_vign_kill", array( self.who, enemy ) );
							}
							
							if( IsDefined( self.script_parameters ) && ( self.script_parameters == "1" || self.script_parameters == "2" || self.script_parameters == "3" || self.script_parameters == "4" ) )
							{
								//if( !level flag::get( "hide_spot_exit_allowed" ) )
								//{
									self.who PlayerLinkToDelta( self.player_link_spot, "tag_origin", 1.0, 35, 35, 10, 10 );
									self thread rotate_object( "in", 0.5 );
									self.who thread util::screen_message_create_client( &"STEALTH_HIDE_ACTIONS", undefined, undefined, 125, 0 );
									wait(0.05);
									continue;
								//}
							}
							
							if ( self.type != "shutter" )
							{
								wait( 0.25 );
								self.who PlayerLinkToBlend( self.player_exit_spot, "tag_origin", 0.75 );
								wait 0.75;
								self thread rotate_object( "in", 0.5 );
								self.who Unlink();
								self.who enableweapons();
								self.who disableinvulnerability();
								self.who util::freeze_player_controls( false );
								self.who allowprone( true );
								self.who allowcrouch( true );
							}
							
							self Delete();//delete the trigger so you can't use it again
						}
					}
				}
			}
			else if ( self.who usebuttonpressed() )
			{
				if ( isNodeOccupied( self.distraction_node ) )
				{
					wait( 0.05 );
					continue;
				}
				
				PlaySoundAtPosition( "uin_stealth_whistle", self.who GetEye() );
				
				//call a guy to investigate
				enemy = distract_enemy( self.who );
				
				if ( isdefined( enemy ) )
				{
					self thread enemy_investigate( enemy );
				}
				
			}
			else if ( self.who stancebuttonpressed() )
			{
				if( IsDefined( self.script_parameters ) && ( self.script_parameters == "1" || self.script_parameters == "2" || self.script_parameters == "3" || self.script_parameters == "4" ) )
				{
					if( !level flag::get( "hide_spot_exit_allowed" ) )
					{
						wait(0.05);
						continue;
					}
				}
				
				self.who util::screen_message_delete_client();
				
				if ( self.type == "door_left" || self.type == "door_right" )
				{
					self thread rotate_object( "out", 1.0 );
					self.who PlayerLinkToBlend( self.player_exit_spot, "tag_origin", 1.5 );
					wait 1.5;
					self thread rotate_object( "in", 0.25 );
					self.who Unlink();
					self.who enableweapons();
					self.who disableinvulnerability();
					self.who util::freeze_player_controls( false );
					self.who allowprone( true );
					self.who allowcrouch( true );
					break;
				}
				
				else if ( self.type == "shutter" )
				{
					self.scripted_node scene::play( "cin_ven_hideyhole_window_vign_exit", self.who );
					break;
				}
			}
			
			wait 0.05;
		}
		
		self MakeUsable();
	}
}

function distract_enemy( player )
{
	enemies = getAiTeamArray( "axis" );
	
	if ( isdefined( enemies ) && enemies.size > 0 )
	{
		enemiesRemove = [];
		foreach ( enemy in enemies )
		{
			if ( isdefined( enemy.distracted ) && enemy.distracted == true )
				enemiesRemove[enemiesRemove.size] = enemy;
		}
		
		if ( enemiesRemove.size > 0 )
			enemies = array::exclude( enemies, enemiesRemove );
		
		if ( isdefined( enemies ) && enemies.size > 0 )
		{
			enemies = ArraySort( enemies, player.origin );
			
			if ( isdefined( enemies[ 0 ] ) )
				return enemies[ 0 ];
		}
	}
}

function enemy_investigate( enemy )
{
	self endon( "death" );
	enemy endon( "death" );
	
	enemy notify( "stop_patrolling" );
	
	enemy.distracted = true;
	enemy setgoalentity( self.distraction_node, true, 16, 16 );
	enemy util::waittill_any_timeout( 10, "goal" );
	enemy setgoal( enemy.origin );
	wait 6.0;
	enemy thread ai::patrol( enemy.patroller_start_node );
	enemy.distracted = undefined;
}

function rotate_object( direction, speed )
{
	switch ( self.type ) 
	{
		case "shutter":
			if ( direction == "in" )
			{
				self.shutter_right rotateyaw( -90, speed );
				self.shutter_left rotateyaw( 90, speed );
			}
			
			else if ( direction == "out" )
			{
				self.shutter_right rotateyaw( 90, speed );
				self.shutter_left rotateyaw( -90, speed );
			}
			break;
			
		case "door_left":
			if ( direction == "in" )
			{
				self.door_left rotateyaw( 90, speed );
			}
			
			else if ( direction == "out" )
			{
				self.door_left rotateyaw( -90, speed );
			}
			break;
			
		case "door_right":
			if ( direction == "in" )
			{
				self.door_right rotateyaw( -90, speed );
			}
			
			else if ( direction == "out" )
			{
				self.door_right rotateyaw( 90, speed );
			}
			break;
	}

}




// ============================================================================
// ==                                                                        ==
// ==  Whistle Call                                                          ==
// ==                                                                        ==
// ============================================================================

// TODO:  Make it so you can't keep distracting the same enemy over and over 
// 			again, maybe if you whistle again while an enemy is already 
// 			investigating, have him become more alert?

// TODO:  Make it so you can't call a bunch of enemies in the same area over and over

// TODO:  Hmm, how should more than 1 player in a whistle trigger be handled?  
// 			Seems bad to just not let other players whistle, but i don't want 
// 			the players to call 1-4 enemies into the same foliage area?  
// 			Might need to set up somethign if an enemy is investigating a 
// 			whistle in an area, no other guys will investigate within x units 
// 			of that spot until he's gon back to normal?

/@
"Name: whistle_setup( <name>, <key> )"
"Summary: Sets up whistle points in your map"
"Module: Stealth"
"Example: stealth::whistle_setup( "whistle_trigger", "targetname" );"
"SPMP: singleplayer"
@/
function whistle_setup( name, key )
{
	whistle_triggers = GetEntArray( name, key );
	array::thread_all( whistle_triggers, &whistle_trigger_wait );
}

function whistle_trigger_wait()
{
	self endon( "death" );
	
	while( 1 )
	{
		self trigger::wait_till();
		
		if ( isdefined( self.who ) && isplayer( self.who ) )
		{
			if ( !isdefined( self.who.stealth.touching_whistle_trigger ) )
				self.who thread whistle_trigger_watcher( self );
			else
				continue;
		}
		
		wait 0.5;
	}
}

function whistle_trigger_watcher( trigger ) // self = player
{
	self endon( "death_or_disconnect" );
		
	self.stealth.touching_whistle_trigger = true;
	
	self thread whistle_help();
	
	// As long as the player is still touching the trigger after the initial trigger,
	//  wait until they untouch it before killing the whistle monitoring
	while( isDefined( trigger ) && self istouching( trigger ) )
	{
		{wait(.05);};

		self.stealth.player_whistle_enabled = false;

		if ( self stealth::weapon_can_be_reloaded() )
			continue;
		
		// get potential enemy
		enemy = self stealth::get_closest_enemy_in_view( 600, 45 );
		if ( !isdefined( enemy ) )
			continue;
		
		// get nearest point on nav mesh
		location = GetClosestPointOnNavMesh( self.origin, 256, 20 );
		if ( !isdefined( location ) )
			continue;			
	
		self.stealth.player_whistle_enabled = true;
		
		if ( self ReloadButtonPressed() )
		{
			//play whistle sound on player
			PlaySoundAtPosition( "uin_stealth_whistle", self GetEye() );
			
			// investigate the whistle if we have a valid enemy and location
			if ( isdefined( enemy ) && isdefined( location ) )
				enemy notify( "alert", "low_alert", location, self, "heard_whistle" );
			
			// just so you don't spam it
			self.stealth.player_whistle_enabled = false;
			wait 2.0;
		}
	}
	
	self.stealth.player_whistle_enabled = undefined;
	self.stealth.touching_whistle_trigger = undefined;
}

function whistle_help( ) // self = player
{
	assert( isPlayer( self ) );
	
	self notify("player_whistle_help");
	self endon("player_whistle_help");
	
	self endon("death");
	self endon("disconnect");
	
	if ( !isdefined( self.stealth.player_whistle_enabled ) )
		self.stealth.player_whistle_enabled = false;
	self.stealth.player_whistle_help_active = false;
	
	while ( isDefined( self.stealth.player_whistle_enabled ) )
	{
		if ( !self.stealth.player_whistle_enabled && self.stealth.player_whistle_help_active )
		{
			self util::screen_message_delete_client();
			self.stealth.player_whistle_help_active = false;
		}
		else if ( self.stealth.player_whistle_enabled && !self.stealth.player_whistle_help_active )
		{
			// display "[{+activate}] to Distract Enemy" on the screen
			self thread util::screen_message_create_client( &"STEALTH_WHISTLE", undefined, undefined, 125, 0 );
			self.stealth.player_whistle_help_active = true;
		}
		
		{wait(.05);};
	}

	self.stealth.player_whistle_help_active = undefined;
	
	self util::screen_message_delete_client();
}

