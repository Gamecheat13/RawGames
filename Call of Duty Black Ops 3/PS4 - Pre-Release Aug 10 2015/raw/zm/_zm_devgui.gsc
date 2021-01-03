#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_placeable_mine;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_turned;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_rat;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                       	                                

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;

#using scripts\shared\ai\zombie_utility;

#using scripts\shared\ai\systems\blackboard;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           


#namespace zm_devgui;

/#	
function autoexec __init__sytem__() {     system::register("zm_devqui",&__init__,&__main__,undefined);    }	

function __init__()
{
	SetDvar( "zombie_devgui", "" );
	SetDvar( "scr_force_weapon", "" );
	SetDvar( "scr_zombie_round", "1" );
	SetDvar( "scr_zombie_dogs", "1" );
	SetDvar( "scr_spawn_tesla", "" );
	SetDvar( "scr_zombie_variant_type", "-1" );

	level.devgui_add_weapon = &devgui_add_weapon;
	level.devgui_add_ability = &devgui_add_ability;
	
	level thread zombie_devgui_think();

	//thread zombie_devgui_watch_input();

	thread zombie_weapon_devgui_think();
	thread devgui_zombie_healthbar();
	thread devgui_test_chart_think();

	if(GetDvarString( "scr_testScriptRuntimeError") == "" )
	{
		SetDvar( "scr_testScriptRuntimeError", "0" );
	}

	level thread dev::body_customization_devgui( 0 );

	thread testScriptRuntimeError();
	
	callback::on_connect( &player_on_connect );
	
}

function __main__()
{
	level thread zombie_devgui_player_commands();
	level thread zombie_devgui_validation_commands();
	level thread diable_fog_in_noclip();	
	level thread zombie_draw_traversals();
}

function zombie_devgui_player_commands()
{
}

function player_on_connect()
{
	level flag::wait_till( "start_zombie_round_logic" ); 
	wait 1;
	if ( IsDefined(self) )
	{
		zombie_devgui_player_menu( self );
	}
}

function zombie_devgui_player_menu_clear( playername )
{
	rootclear = "devgui_remove \"ZM/Players:1/" +playername+ "\" \n";
	AddDebugCommand( rootclear );
}
	
function zombie_devgui_player_menu( player )
{
	zombie_devgui_player_menu_clear( player.name );
	
	ip1 = (player GetEntityNumber())+1;
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Give Money:1\" \"set zombie_devgui player" +ip1+ "_money\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Invulnerable:2\" \"set zombie_devgui player" +ip1+ "_invul_on\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Vulnerable:3\" \"set zombie_devgui player" +ip1+ "_invul_off\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Toggle Ignored:4\" \"set zombie_devgui player" +ip1+ "_ignore\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Mega Health:5\" \"set zombie_devgui player" +ip1+ "_health\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Down:6\" \"set zombie_devgui player" +ip1+ "_kill\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Revive:7\" \"set zombie_devgui player" +ip1+ "_revive\" \n");
	//AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Turn Player:8\" \"set zombie_devgui player" +ip1+ "_turnplayer\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Debug Pers:9\" \"set zombie_devgui player" +ip1+ "_debug_pers\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Take Money:10\" \"set zombie_devgui player" +ip1+ "_moneydown\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Give 1000XP:11\" \"set zombie_devgui player" +ip1+ "_xp_1000\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +player.name+ ":10" + ip1 + "/Give 10000XP:12\" \"set zombie_devgui player" +ip1+ "_xp_10000\" \n");
	//players[i] thread watch_debug_input(); 
	
	self thread zombie_devgui_player_menu_clear_on_disconnect( player );
	
}

function zombie_devgui_player_menu_clear_on_disconnect( player )
{
	playername = player.name;
	player waittill("disconnect");
	zombie_devgui_player_menu_clear( playername );
}


function zombie_devgui_validation_commands()
{
	SetDvar( "validation_devgui_command", "" );
	
	AddDebugCommand( "devgui_cmd \"ZM/Validation/Spawner\" \"validation_devgui_command spawner\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Validation/Zone Adjacencies\" \"validation_devgui_command zone_adj\"\n" );
	AddDebugCommand( "devgui_cmd \"ZM/Validation/Zombie Pathing\" \"validation_devgui_command pathing\"\n" );
	
	level thread zombie_handle_havok_timer_test();

	while ( true )
	{
		cmd = GetDvarString( "validation_devgui_command" );
		if ( cmd != "")
		{
			switch ( cmd )
			{
				case "spawner":
					zombie_spawner_validation();
					break;
				case "zone_adj":
					if( !isDefined( level.toggle_zone_adjacencies_validation ) )
					{
						level.toggle_zone_adjacencies_validation = 1;
					}
					else
					{
						level.toggle_zone_adjacencies_validation = !level.toggle_zone_adjacencies_validation;
					}
					thread zone_adjacencies_validation();
					break;
				case "pathing":
					thread zombie_pathing_validation();
				default:
					break;
			}
		SetDvar( "validation_devgui_command", "" );
		}
		util::wait_network_frame();
	}
}

function zombie_spawner_validation()
{
	level.validation_errors_count = 0;
	if( !IsDefined( level.toggle_spawner_validation ) )
	{
		level.toggle_spawner_validation = 1;
		zombie_devgui_open_sesame();
		spawner = level.zombie_spawners[0];
		enemy = undefined;
		foreach( zone in level.zones )
		{
			foreach( spawn_point in zone.a_loc_types[ "zombie_location" ] )
			{
				if( zone.a_loc_types[ "wait_location" ].size <= 0 )
	   			{
					level.validation_errors_count++;
	   				thread drawValidation( spawn_point.origin, spawn_point.zone_name );
	   				PrintLn( "ZM SPAWNER : No wait point in zone :" + spawn_point.zone_name );
	   				break;
	   			}
				
				if( !isdefined( enemy ) )
				{
					enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname, spawn_point);
				}
	
				node = undefined;
				
				spawn_point_origin = spawn_point.origin;
				
				if( spawn_point.script_string != "find_flesh" )
				{
					spawn_point_origin = enemy zm_devgui::validate_to_board( spawn_point, spawn_point_origin );
				}
				
				new_spawn_point_origin = GetClosestPointOnNavMesh( spawn_point_origin, 40, 30 );
				
				if( !isdefined( new_spawn_point_origin ) )
				{
					new_spawn_point_origin = GetClosestPointOnNavMesh( spawn_point_origin, 100, 30 );
					if( !isdefined( new_spawn_point_origin ) )
					{
						level.validation_errors_count++;
						thread zm_devgui::drawvalidation( spawn_point_origin );
					}
				}
				
		   		isPath = enemy zm_devgui::validate_to_wait_point(zone, new_spawn_point_origin, spawn_point );
			}
		}
		PrintLn( "ZM SPAWNER : Number of spawner errors : " + level.validation_errors_count );
		level.validation_errors_count = undefined;
	}
	else
	{
		level.toggle_spawner_validation = !level.toggle_spawner_validation;
	}
}

//self is zombie
function validate_to_board( spawn_point, spawn_point_origin_backup )
{
	for( j=0; j<level.exterior_goals.size; j++ )
    {
    	if( IsDefined( level.exterior_goals[j].script_string ) && level.exterior_goals[j].script_string == spawn_point.script_string )
        {
            	node = level.exterior_goals[j];
            	break;
        }
    }

	if( isdefined( node ) )
	{
		isPath = self canpath( spawn_point.origin, node.origin );
		if ( !isPath )
		{
			level.validation_errors_count++;
			thread drawValidation( spawn_point_origin_backup, undefined, undefined, node.origin );
		   	PrintLn( "ZM SPAWNER : Zombie cannot path from spawn point:" + spawn_point_origin_backup + " to boards. Targetname: " + spawn_point.targetname );
		}
		
		nodeForward = anglestoforward( node.angles );				
	   	nodeForward = vectornormalize( nodeForward );
	    spawn_point_origin = node.origin + (nodeForward * 100);
	    
	    return spawn_point_origin;
	}
	return spawn_point_origin_backup;
}

//self is zombie
function validate_to_wait_point( zone, new_spawn_point_origin, spawn_point )
{
	foreach( loc in zone.a_loc_types[ "wait_location" ] )
	{
		if( isdefined( loc ) )
		{
			wait_point = loc.origin;
			if( isdefined( wait_point ) )
			{
		   		new_wait_point = GetClosestPointOnNavMesh( wait_point, 40, 30 );
		   		
		   		if( !isdefined( new_wait_point ) )
				{
					new_wait_point = GetClosestPointOnNavMesh( wait_point, 100, 30 );
				}
					
		   		if( isdefined( new_spawn_point_origin ) && isdefined( new_wait_point ) )
			   	{
		   			isPath = self canpath( new_spawn_point_origin, new_wait_point );
			   		if( isPath )
			   		{
			   			return true;
			   		}
			   		else
			   		{
			   			level.validation_errors_count++;
			   			thread drawValidation( new_spawn_point_origin, undefined, new_wait_point );
		   				PrintLn( "ZM SPAWNER : Zombie cannot path from spawn point:" + new_spawn_point_origin + " to dog point. Targetname: " + spawn_point.targetname );
		   				return false;
			   		}
		   		}
			}
		}
	}
	return false;
}

function drawValidation( origin, zone_name = undefined, nav_mesh_wait_point = undefined, boards_point = undefined)
{
	while(true)
	{
		if( ( isdefined( level.toggle_spawner_validation ) && level.toggle_spawner_validation ) )
		{
			if( !IsDefined( origin ) )
			{
				break;
			}
			
			if( isdefined( zone_name ) )
			{
				circle( origin, 32, ( 1, 0, 0 ) );
				print3d( origin, "No dog point in zone: " + zone_name, ( 1, 1, 1 ), 1, 0.5 );
			}
			else if( isdefined( nav_mesh_wait_point ) )
			{
				circle( origin, 32, ( 0, 0, 1 ) );
				print3d( origin, "Zombie cannot path from spawn point : " + origin, ( 1, 1, 1 ), 1, 0.5 );
				line( origin, nav_mesh_wait_point, ( 1, 0, 0 ) );
				circle( nav_mesh_wait_point, 32, ( 1, 0, 0 ) );
				print3d( nav_mesh_wait_point, "Dog point : " + nav_mesh_wait_point, ( 1, 1, 1 ), 1, 0.5 );
			}
			else if( isdefined( boards_point ) )
			{
				circle( origin, 32, ( 0, 0, 1 ) );
				print3d( origin, "Zombie cannot path from spawn point : " + origin, ( 1, 1, 1 ), 1, 0.5 );
				line( origin, boards_point, ( 1, 0, 0 ) );
				circle( boards_point, 32, ( 1, 0, 0 ) );
				print3d( boards_point, "Board point : " + boards_point, ( 1, 1, 1 ), 1, 0.5 );
			}
			else
			{
				circle( origin, 32, ( 0, 0, 1 ) );
				print3d( origin, "Invalid spawn point : " + origin, ( 1, 1, 1 ), 1, 0.5 );
			}
		}
		wait( 0.05 );
	}
}

function zone_adjacencies_validation()
{
	zombie_devgui_open_sesame();
	while(1)
	{
		if( ( isdefined( level.toggle_zone_adjacencies_validation ) && level.toggle_zone_adjacencies_validation ) )
		{
			if(!isdefined(GetPlayers()[0].zone_name))
			{	
				wait 0.05;
				continue;
			}
			
			str_zone = GetPlayers()[0].zone_name;
			
			keys = GetArrayKeys( level.zones );
			offset = 0;
			foreach( key in keys )
			{
				if( ( key === str_zone ) )
				{
					draw_zone_adjacencies_validation( level.zones[key], 2, key);
					continue;
				}
				if( isdefined(level.zones[ str_zone ].adjacent_zones[ key ] ) )
				{
					if ( level.zones[ str_zone ].adjacent_zones[ key ].is_connected )
					{
						offset = offset + 10;
						draw_zone_adjacencies_validation( level.zones[key], 1, key, level.zones[str_zone], offset );
					}
					else
					{
						draw_zone_adjacencies_validation( level.zones[key], 0, key);
					}
				}
				else
				{
					draw_zone_adjacencies_validation( level.zones[key], 0, key);
				}
			}
		}
		wait 0.05;	
	}
}

//status : 
//2 = current zone
//1 = adjacent zone
//0 = not adjacent zone
function draw_zone_adjacencies_validation( zone, status, name, current_zone = undefined, offset = 0)
{
	if(!isdefined(zone.volumes[0]))
	{
		return;
	}
	
	if( status == 2 )
	{
		circle(zone.volumes[0].origin,30,( 0, 1, 0 ));
		print3d( zone.volumes[0].origin, name, ( 0, 1, 0 ), 1, 0.5 );
	}
	else if( status == 1 )
	{
		circle(zone.volumes[0].origin,30,( 0, 0, 1 ));
		print3d( zone.volumes[0].origin, name, ( 0, 0, 1 ), 1, 0.5 );
		print3d( current_zone.volumes[0].origin + (0,20,-offset), name, ( 0, 0, 1 ), 1, 0.5 );
	}
	else
	{
		circle(zone.volumes[0].origin,30,( 1, 0, 0 ));
		print3d( zone.volumes[0].origin, name, ( 1, 0, 0 ), 1, 0.5 );
	}
}

function zombie_pathing_validation()
{
	if( !isDefined( level.zombie_spawners[0] ) )
	{
		return;
	}
	if( !isDefined( level.zombie_pathing_validation ) )
	{
		level.zombie_pathing_validation = 1;
	}
	zombie_devgui_open_sesame();
	SetDvar( "zombie_default_max", 0 );
	zombie_devgui_goto_round( 20 );
	wait 2;
	spawner = level.zombie_spawners[0];
	slums_station = (808,-1856,544);
	enemy = zombie_utility::spawn_zombie(spawner, spawner.targetname );
	wait 1;
	while( isdefined( enemy ) && enemy.completed_emerging_into_playable_area !== true )
	{
		wait 0.05;
	}
	if ( isdefined( enemy ) )
	{
		enemy forceteleport( slums_station );
		enemy.b_ignore_cleanup = true;
	}
}

function zombie_handle_havok_timer_test()
{
	while ( 1 )
	{
		if ( GetDvarInt( "hkai_timerTestActive" ) != 0 )
		{
			spawnPos = hkaiGetTimerTestPathfindStartPos();
			goalPos = hkaiGetTimerTestPathfindEndPos();
			spawner = level.zombie_spawners[0];
			guy = zombie_utility::spawn_zombie(spawner, spawner.targetname );
			guy forceteleport( spawnPos );
			hkaiSetTimerTestEnt( guy );
			guy.allowdeath = false;
			guy.blockingPain = true;
			guy.ignoreall = true;
			guy.ignoreme = true;
			guy UsePosition( goalPos );
			guy.goalradius = 16;
			//guy SetGoal( goalPos, true );
			wait 5;
			//guy waittill( "goal" );
			guy.allowdeath = true;
			guy kill();
		}

		wait 0.05;
	}
}

function devgui_add_weapon_entry( weapon_name, up, root )
{
	rootslash = "";
	if ( IsDefined(root) && root.size)
		rootslash = root + "/";
	uppath = "/" + up;
	if (up.size < 1)
		uppath = "";
	cmd = "devgui_cmd \"ZM/Weapons/" + rootslash + weapon_name + uppath + "\" \"set zombie_devgui_gun " + weapon_name + "\" \n";
	AddDebugCommand( cmd );
}

function devgui_add_weapon_and_attachments( weapon_name, up, root )
{
	devgui_add_weapon_entry( weapon_name, up, root );
}

function devgui_add_weapon( weapon, upgrade, hint, cost, weaponVO, weaponVOresp, ammo_cost )
{
	if ( zm_utility::is_offhand_weapon(weapon) && !zm_utility::is_melee_weapon(weapon) )
		return;
	if (!isdefined(level.devgui_weapons_added))
		level.devgui_weapons_added=0;
	level.devgui_weapons_added++;
	if ( zm_utility::is_melee_weapon(weapon) )
		devgui_add_weapon_and_attachments( weapon.name, "", "Melee" );
	else
		devgui_add_weapon_and_attachments( weapon.name, "", "" );
}

function zombie_weapon_devgui_think()
{
	level.zombie_devgui_gun=GetDvarString( "zombie_devgui_gun" );
	level.zombie_devgui_att=GetDvarString( "zombie_devgui_attach" );
	for ( ;; )
	{
		wait .25;
		cmd = GetDvarString( "zombie_devgui_gun" );
		if (!isdefined(level.zombie_devgui_gun) || level.zombie_devgui_gun!=cmd)
		{
			level.zombie_devgui_gun=cmd;
			array::thread_all( GetPlayers(), &zombie_devgui_weapon_give, level.zombie_devgui_gun );
		}
		wait .25;
		att = GetDvarString( "zombie_devgui_attach" );
		if (!isdefined(level.zombie_devgui_att) || level.zombie_devgui_att!=att)
		{
			level.zombie_devgui_att=att;
			array::thread_all( GetPlayers(), &zombie_devgui_attachment_give, level.zombie_devgui_att );
		}
	}
}

function zombie_devgui_weapon_give( weapon_name )
{
	weapon = GetWeapon( weapon_name );
	self zm_weapons::weapon_give(weapon, zm_weapons::is_weapon_upgraded( weapon ), false);
}

function zombie_devgui_attachment_give( attachment )
{
	weapon = self GetCurrentWeapon();
	weapon = GetWeapon( weapon.name, attachment );
	
	self zm_weapons::weapon_give( weapon, zm_weapons::is_weapon_upgraded( weapon ), false );
}

function devgui_add_ability( name, upgrade_active_func, stat_name, stat_desired_value, game_end_reset_if_not_achieved )
{
	online_game = SessionModeIsOnlineGame();
	if ( !online_game )
		return;
	if ( !( isdefined( level.devgui_watch_abilities ) && level.devgui_watch_abilities ) )
	{
		cmd = "devgui_cmd \"ZM/Players/Abilities/Disable All\" \"set zombie_devgui_give_ability _disable\" \n";
		AddDebugCommand( cmd );
		cmd = "devgui_cmd \"ZM/Players/Abilities/Enable All\" \"set zombie_devgui_give_ability _enable\" \n";
		AddDebugCommand( cmd );
		level thread zombie_ability_devgui_think();
		level.devgui_watch_abilities=1;
	}
	
	cmd = "devgui_cmd \"ZM/Players/Abilities/" + name + "\" \"set zombie_devgui_give_ability " +name+"\" \n";
	AddDebugCommand( cmd );
	cmd = "devgui_cmd \"ZM/Players/Abilities/Take/" + name + "\" \"set zombie_devgui_take_ability " +name+"\" \n";
	AddDebugCommand( cmd );
	
}



function zombie_devgui_ability_give( name )
{
	pers_upgrade = level.pers_upgrades[name];
	if (IsDefined(pers_upgrade))
	{
		for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
		{
			stat_name = pers_upgrade.stat_names[i];
			stat_value = pers_upgrade.stat_desired_values[i];
			self zm_stats::set_global_stat( stat_name, stat_value );
			self.pers_upgrade_force_test = 1;
		}
	}
}

function zombie_devgui_ability_take( name )
{
	pers_upgrade = level.pers_upgrades[name];
	if (IsDefined(pers_upgrade))
	{
		for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
		{
			stat_name = pers_upgrade.stat_names[i];
			stat_value = 0; //pers_upgrade.stat_desired_values[i] - 1;
			self zm_stats::set_global_stat( stat_name, stat_value );
			self.pers_upgrade_force_test = 1;
		}
	}
}

function zombie_ability_devgui_think()
{
	level.zombie_devgui_give_ability=GetDvarString( "zombie_devgui_give_ability" );
	level.zombie_devgui_take_ability=GetDvarString( "zombie_devgui_take_ability" );
	for ( ;; )
	{
		wait .25;
		cmd = GetDvarString( "zombie_devgui_give_ability" );
		if (!isdefined(level.zombie_devgui_give_ability) || level.zombie_devgui_give_ability!=cmd)
		{
			if ( cmd == "_disable" )
		    {
				level flag::set( "sq_minigame_active" );
		    }
			else if ( cmd == "_enable" )
		    {
				level flag::clear( "sq_minigame_active" );
		    }
			else
			{
				level.zombie_devgui_give_ability=cmd;
				array::thread_all( GetPlayers(), &zombie_devgui_ability_give, level.zombie_devgui_give_ability );
			}
		}
		wait .25;
		cmd = GetDvarString( "zombie_devgui_take_ability" );
		if (!isdefined(level.zombie_devgui_take_ability) || level.zombie_devgui_take_ability!=cmd)
		{
			level.zombie_devgui_take_ability=cmd;
			array::thread_all( GetPlayers(), &zombie_devgui_ability_take, level.zombie_devgui_take_ability );
		}
	}
}



	
function zombie_healthbar(pos,dsquared)
{
	if (DistanceSquared(pos,self.origin) > dsquared)
		return;

	rate = 1;
	if (IsDefined(self.maxhealth))
		rate = self.health/self.maxhealth;
	color = (1-rate,rate,0);
	
	text = "" + int(self.health);
	
	print3d(self.origin + (0,0,0), text, color, 1, 0.5, 1);
}


function devgui_zombie_healthbar()
{
	while (1)
	{
		if ( GetDvarInt( "scr_zombie_healthbars" ) == 1 )
		{
			lp = GetPlayers()[0];
			zombies = GetAiSpeciesArray( "all", "all" ); 
			if ( IsDefined( zombies ) )
			{
				foreach( zombie in zombies )
				{
					zombie zombie_healthbar(lp.origin,(600 * 600));
				}
			}
			
		}
		{wait(.05);};
	}
}


function zombie_devgui_watch_input()
{
	level flag::wait_till( "start_zombie_round_logic" ); 

	wait 1;

	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		players[i] thread watch_debug_input(); 
	}
}


function damage_player()
{
	self DisableInvulnerability();
	self dodamage(self.health/2, self.origin);
}

function kill_player()
{
	self DisableInvulnerability();
	death_from = (RandomFloatRange(-20,20),RandomFloatRange(-20,20),RandomFloatRange(-20,20));
	self dodamage(self.health + 666, self.origin + death_from);
}

function force_drink()
{
	wait 0.01;
	lean = self AllowLean( false );
	ads = self AllowAds( false );
	sprint = self AllowSprint( false );
	crouch = self AllowCrouch( true );
	prone = self AllowProne( false );
	melee = self AllowMelee( false );

	self zm_utility::increment_is_drinking();
	orgweapon = self GetCurrentWeapon(); 
	
	build_weapon = GetWeapon( "zombie_builder" );
	self GiveWeapon( build_weapon );
	self SwitchToWeapon( build_weapon );

	self.build_time = self.useTime;
	self.build_start_time = getTime();

	wait 2;

	self zm_weapons::switch_back_primary_weapon(orgweapon);

	self TakeWeapon( build_weapon );
	if (( isdefined( self.is_drinking ) && self.is_drinking ))
	{
		self zm_utility::decrement_is_drinking();
	}

	self AllowLean( lean );
	self AllowAds( ads );
	self AllowSprint( sprint );
	self AllowProne( prone );		
	self AllowCrouch( crouch );		
	self AllowMelee( melee );
}

function zombie_devgui_dpad_none()
{
	self thread watch_debug_input();
}

function zombie_devgui_dpad_death()
{
	self thread watch_debug_input( &kill_player );
}

function zombie_devgui_dpad_damage()
{
	self thread watch_debug_input( &damage_player );
}

function zombie_devgui_dpad_changeweapon()
{
	self thread watch_debug_input( &force_drink );
}


function watch_debug_input( callback )
{
	self endon("disconnect");
	self notify("watch_debug_input");
	self endon("watch_debug_input");
	level.devgui_dpad_watch = 0;
	if ( isdefined(callback) )
	{
		level.devgui_dpad_watch = 1;
		for(;;)
		{
			if(self ActionSlotTwoButtonPressed())
			{
				self thread [[callback]]();
				while (self ActionSlotTwoButtonPressed())
					{wait(.05);};
			}

			{wait(.05);};	
		}
	}
}



function zombie_devgui_think()
{
	level notify("zombie_devgui_think");
	level endon("zombie_devgui_think");
	
	for ( ;; )
	{
		cmd = GetDvarString( "zombie_devgui" );

		switch ( cmd )
		{
		case "money":
			players = GetPlayers();
			array::thread_all( players, &zombie_devgui_give_money );
			/*if ( players.size > 1 )
			{
				for ( i=0; i<level.team_pool.size; i++ )
				{
					level.team_pool[i].score += 100000;
					level.team_pool[i].old_score += 100000;
					level.team_pool[i] zm_score::set_team_score_hud(); 
				}
			}*/
			break;
		case "player1_money":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_money();	
			break;
		case "player2_money":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_money();	
			break;
		case "player3_money":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_money();	
			break;
		case "player4_money":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_money();	
			break;
		case "moneydown":
			players = GetPlayers();
			array::thread_all( players, &zombie_devgui_take_money );
			/*if ( players.size > 1 )
			{
				for ( i=0; i<level.team_pool.size; i++ )
				{
					level.team_pool[i].score += 100000;
					level.team_pool[i].old_score += 100000;
					level.team_pool[i] zm_score::set_team_score_hud(); 
				}
			}*/
			break;
		case "player1_moneydown":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_take_money();	
			break;
		case "player2_moneydown":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_take_money();	
			break;
		case "player3_moneydown":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_take_money();	
			break;
		case "player4_moneydown":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_take_money();	
			break;
			
		case "player1_xp_1000":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_xp( 1000 );	
			break;
		case "player2_xp_1000":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_xp( 1000 );	
			break;
		case "player3_xp_1000":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_xp( 1000 );	
			break;
		case "player4_xp_1000":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_xp( 1000 );	
			break;
			
		case "player1_xp_10000":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_xp( 10000 );	
			break;
		case "player2_xp_10000":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_xp( 10000 );	
			break;
		case "player3_xp_10000":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_xp( 10000 );	
			break;
		case "player4_xp_10000":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_xp( 10000 );	
			break;

		case "health":
			array::thread_all( GetPlayers(), &zombie_devgui_give_health );	
			break;
		case "player1_health":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_health();	
			break;
		case "player2_health":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_health();	
			break;
		case "player3_health":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_health();	
			break;
		case "player4_health":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_health();	
			break;

		case "ammo":
			array::thread_all( GetPlayers(), &zombie_devgui_toggle_ammo );	
			break;
			
		case "ignore":
			array::thread_all( GetPlayers(), &zombie_devgui_toggle_ignore );	
			break;
		case "player1_ignore":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_toggle_ignore();	
			break;
		case "player2_ignore":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_toggle_ignore();	
			break;
		case "player3_ignore":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_toggle_ignore();	
			break;
		case "player4_ignore":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_toggle_ignore();	
			break;

		case "invul_on":
			zombie_devgui_invulnerable( undefined, true ); 
			break;
		case "invul_off":
			zombie_devgui_invulnerable( undefined, false ); 
			break;
		case "player1_invul_on":
			zombie_devgui_invulnerable( 0, true ); 
			break;
		case "player1_invul_off":
			zombie_devgui_invulnerable( 0, false ); 
			break;
		case "player2_invul_on":
			zombie_devgui_invulnerable( 1, true ); 
			break;
		case "player2_invul_off":
			zombie_devgui_invulnerable( 1, false ); 
			break;
		case "player3_invul_on":
			zombie_devgui_invulnerable( 2, true ); 
			break;
		case "player3_invul_off":
			zombie_devgui_invulnerable( 2, false ); 
			break;
		case "player4_invul_on":
			zombie_devgui_invulnerable( 3, true ); 
			break;
		case "player4_invul_off":
			zombie_devgui_invulnerable( 3, false ); 
			break;

		case "revive_all":
			array::thread_all( GetPlayers(), &zombie_devgui_revive );	
			break;
		case "player1_revive":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_revive();	
			break;
		case "player2_revive":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_revive();	
			break;
		case "player3_revive":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_revive();	
			break;
		case "player4_revive":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_revive();	
			break;
			
		case "player1_kill":
			players = GetPlayers();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_kill();	
			break;
		case "player2_kill":
			players = GetPlayers();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_kill();	
			break;
		case "player3_kill":
			players = GetPlayers();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_kill();	
			break;
		case "player4_kill":
			players = GetPlayers();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_kill();	
			break;
			
		case "spawn_friendly_bot":
			player = util::GetHostPlayer();
			team = player.team;

			devgui_bot_spawn( team );
			break;

		case "specialty_quickrevive":
			level.solo_lives_given = 0;
		case "specialty_armorvest":
		case "specialty_fastreload":
		case "specialty_doubletap2":
		case "specialty_staminup":
		case "specialty_phdflopper":
		case "specialty_deadshot":
		case "specialty_additionalprimaryweapon":
		case "specialty_tombstone":
		case "specialty_whoswho":
		case "specialty_electriccherry":
		case "specialty_vultureaid":
		case "specialty_widowswine":
		case "specialty_showonradar":
		case "specialty_fastmeleerecovery":
			zombie_devgui_give_perk( cmd );
			break;
			
		case "remove_perks":
			zombie_devgui_take_perks( cmd );
			break;

		case "turnplayer":
			zombie_devgui_turn_player();
			break;
		case "player1_turnplayer":
			zombie_devgui_turn_player(0);
			break;
		case "player2_turnplayer":
			zombie_devgui_turn_player(1);
			break;
		case "player3_turnplayer":
			zombie_devgui_turn_player(2);
			break;
		case "player4_turnplayer":
			zombie_devgui_turn_player(3);
			break;

		case "player1_debug_pers":
			zombie_devgui_debug_pers(0);
			break;
		case "player2_debug_pers":
			zombie_devgui_debug_pers(1);
			break;
		case "player3_debug_pers":
			zombie_devgui_debug_pers(2);
			break;
		case "player4_debug_pers":
			zombie_devgui_debug_pers(3);
			break;

		case "nuke":
		case "insta_kill":
		case "double_points":
		case "full_ammo":
		case "carpenter":
		case "fire_sale":
		case "bonfire_sale":
		case "minigun":
		case "free_perk":
		case "tesla":
		case "random_weapon":
		case "bonus_points_player":
		case "bonus_points_team":
		case "lose_points_team":
		case "lose_perk":
		case "empty_clip":
		case "meat_stink":
			zombie_devgui_give_powerup( cmd, true );
			break;

		case "next_nuke":
		case "next_insta_kill":
		case "next_double_points":
		case "next_full_ammo":
		case "next_carpenter":
		case "next_fire_sale":
		case "next_bonfire_sale":
		case "next_minigun":
		case "next_free_perk":
		case "next_tesla":
		case "next_random_weapon":
		case "next_bonus_points_player":
		case "next_bonus_points_team":
		case "next_lose_points_team":
		case "next_lose_perk":
		case "next_empty_clip":
		case "next_meat_stink":
			zombie_devgui_give_powerup( GetSubStr( cmd, 5 ), false );
			break;

		case "round":
			zombie_devgui_goto_round( GetDvarInt( "scr_zombie_round" ) );
			break;
		case "round_next":
			zombie_devgui_goto_round( level.round_number + 1 );
			break;
		case "round_prev":
			zombie_devgui_goto_round( level.round_number - 1 );
			break;

		case "chest_move":
			if ( IsDefined( level.chest_accessed ) )
			{
				//iprintln( "Teddy bear will spawn on next open" );
				level notify( "devgui_chest_end_monitor" );
				level.chest_accessed = 100;
			}
			break;

		case "chest_never_move":
			if ( IsDefined( level.chest_accessed ) )
			{
				//iprintln( "Setting chest to never move" );
				level thread zombie_devgui_chest_never_move();
			}
			break;

		case "chest":
			if( IsDefined( level.zombie_weapons[ GetWeapon( GetDvarString( "scr_force_weapon" ) ) ] ) )
			{
				//iprintln( GetDvarString( "scr_force_weapon" ) + " will spawn on next open" );
			}
			break;

		case "preserve_turbines":
			array::thread_all( GetPlayers(), &zombie_devgui_preserve_turbines );
			break;
		case "healthy_equipment":
			array::thread_all( GetPlayers(), &zombie_devgui_equipment_stays_healthy );
			break;
		case "disown_equipment":
			array::thread_all( GetPlayers(), &zombie_devgui_disown_equipment );
			break;
			

		case "give_claymores":
			array::thread_all( GetPlayers(), &zombie_devgui_give_placeable_mine, GetWeapon("claymore") );
			break;
			
		case "give_bouncingbetties":
			array::thread_all( GetPlayers(), &zombie_devgui_give_placeable_mine, GetWeapon("bouncingbetty") );
			break;

		case "give_frags":
			array::thread_all( GetPlayers(), &zombie_devgui_give_frags );
			break;

		case "give_sticky":
			array::thread_all( GetPlayers(), &zombie_devgui_give_sticky );
			break;

		case "give_monkey":
			array::thread_all( GetPlayers(), &zombie_devgui_give_monkey );
			break;
			
		case "give_emp_bomb":
			array::thread_all( GetPlayers(), &zombie_devgui_give_emp_bomb );
			break;

		case "dog_round":
			zombie_devgui_dog_round( GetDvarInt( "scr_zombie_dogs" ) );
			break;

		case "dog_round_skip":
			zombie_devgui_dog_round_skip();
			break;
			
		case "print_variables":
			zombie_devgui_dump_zombie_vars();
			break;
			
		case "pack_current_weapon":
			zombie_devgui_pack_current_weapon();
			break;

		case "unpack_current_weapon":
			zombie_devgui_unpack_current_weapon();
			break;

		case "reopt_current_weapon":
			zombie_devgui_reopt_current_weapon();
			break;

		case "weapon_take_all_fallback":
			zombie_devgui_take_weapons(true);
			break;

		case "weapon_take_all":
			zombie_devgui_take_weapons(false);
			break;

		case "weapon_take_current":
			zombie_devgui_take_weapon();
			break;

		case "power_on":
			level flag::set( "power_on" );
			level clientfield::set( "zombie_power_on", 0 );
			//DCS: this will set all zone controlling power switch flags.
			power_trigs = GetEntArray( "use_elec_switch", "targetname" );
			foreach(trig in power_trigs)
			{
				if(IsDefined(trig.script_int))
				{
					level flag::set("power_on" + trig.script_int);
					level clientfield::set( "zombie_power_on", trig.script_int );
				}
			}
			break;

		case "power_off":
			level flag::clear( "power_on" );
			level clientfield::set( "zombie_power_off", 0 );
			//DCS: this will clear all zone controlling power switch flags.
			power_trigs = GetEntArray( "use_elec_switch", "targetname" );
			foreach(trig in power_trigs)
			{
				if(IsDefined(trig.script_int))
				{
					level flag::clear("power_on" + trig.script_int);
					level clientfield::set( "zombie_power_off", trig.script_int );
				}
			}			
			break;

		case "zombie_dpad_none":
			array::thread_all( GetPlayers(), &zombie_devgui_dpad_none );
			break;

		case "zombie_dpad_damage":
			array::thread_all( GetPlayers(), &zombie_devgui_dpad_damage );
			break;

		case "zombie_dpad_kill":
			array::thread_all( GetPlayers(), &zombie_devgui_dpad_death );
			break;

		case "zombie_dpad_drink":
			array::thread_all( GetPlayers(), &zombie_devgui_dpad_changeweapon );
			break;

		case "director_easy":
			zombie_devgui_director_easy();
			break;
			
		case "open_sesame":
			zombie_devgui_open_sesame();
			break;

		case "allow_fog":
			zombie_devgui_allow_fog();
			break;

		case "disable_kill_thread_toggle":
			zombie_devgui_disable_kill_thread_toggle();
			break;

		case "check_kill_thread_every_frame_toggle":
			zombie_devgui_check_kill_thread_every_frame_toggle();
			break;
			
		case "kill_thread_test_mode_toggle":
			zombie_devgui_kill_thread_test_mode_toggle();
			break;
			
		case "zombie_failsafe_debug_flush":
			level notify( "zombie_failsafe_debug_flush" );
			break;
		
		case "rat_navmesh":
			level thread rat::DerRieseZombieSpawnNavmeshTest( 0, false );
			break;

		case "spawn":
			devgui_zombie_spawn();
			break;
			
		case "spawn_all":
			devgui_all_spawn();
			break;
		
		case "crawler":
			devgui_make_crawler();
			break;
			
		case "toggle_show_spawn_locations":
			devgui_toggle_show_spawn_locations();
			break;

		case "toggle_show_exterior_goals":
			devgui_toggle_show_exterior_goals();
			break;

		case "draw_traversals":
			zombie_devgui_draw_traversals();
			break;
			
		case "debug_hud":
			array::thread_all( GetPlayers(), &devgui_debug_hud );
			break;
			
		case "":
			break;

		default:
			if ( IsDefined( level.custom_devgui ) )
			{
				if ( IsArray( level.custom_devgui ) )
				{
					foreach( devgui in level.custom_devgui )
					{
						b_found_entry = ( isdefined( [[ devgui ]]( cmd ) ) && [[ devgui ]]( cmd ) );
						if ( b_found_entry )
						{
							break;
						}
					}
				}
				else 
				{
					[[level.custom_devgui]]( cmd );
				}
			}
			else
			{
				//iprintln( "Unknown devgui command: '" + cmd + "'" );
			}
			break;
		}
	
		SetDvar( "zombie_devgui", "" );
		wait( 0.5 );
	}
}

function add_custom_devgui_callback( callback )
{
	if ( IsDefined( level.custom_devgui ) )
	{
		if ( !IsArray( level.custom_devgui ) )
		{
			cdgui = level.custom_devgui; 
			level.custom_devgui = [];
			if ( !isdefined( level.custom_devgui ) ) level.custom_devgui = []; else if ( !IsArray( level.custom_devgui ) ) level.custom_devgui = array( level.custom_devgui ); level.custom_devgui[level.custom_devgui.size]=cdgui;;
		}
	}
	else 
	{
		level.custom_devgui = [];
	}
	if ( !isdefined( level.custom_devgui ) ) level.custom_devgui = []; else if ( !IsArray( level.custom_devgui ) ) level.custom_devgui = array( level.custom_devgui ); level.custom_devgui[level.custom_devgui.size]=callback;;
}


function devgui_all_spawn()
{
	player = util::GetHostPlayer();
	devgui_bot_spawn( player.team );
	wait 0.1;
	devgui_bot_spawn( player.team );
	wait 0.1;
	devgui_bot_spawn( player.team );
	wait 0.1;
	zombie_devgui_goto_round( 8 );
	
}
	
function devgui_toggle_show_spawn_locations()
{
	if( !IsDefined( level.toggle_show_spawn_locations ) )
	{
		level.toggle_show_spawn_locations = 1;
	}
	else
	{
		level.toggle_show_spawn_locations = !level.toggle_show_spawn_locations;
	}
}

function devgui_toggle_show_exterior_goals()
{
	if ( !IsDefined( level.toggle_show_exterior_goals ) )
	{
		level.toggle_show_exterior_goals = 1;
	}
	else
	{
		level.toggle_show_exterior_goals = !level.toggle_show_exterior_goals;
	}
}

function devgui_zombie_spawn()
{
	player = GetPlayers()[0];
	
	//Pick Spawner
	//------------
	spawnerName = undefined;
	spawnerName = "zombie_spawner";	
	
	//Trace to find where the player is looking
	//-----------------------------------------
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );
	
	//Spawn ai and teleport to where the player is looking
	//----------------------------------------------------
	guy = undefined;
	spawners = GetEntArray( spawnerName, "script_noteworthy" );
	spawner = spawners[ 0 ];

	//guy = spawner CodespawnerForceSpawn();

	guy = zombie_utility::spawn_zombie( spawner );	
	if (isdefined(guy))
	{
		guy.script_string = "find_flesh";

		wait 0.5;
		//guy.origin = trace["position"];
		//guy.angles = player.angles + (0,180,0);
		guy forceteleport(trace["position"], player.angles + (0,180,0));
	}
	return guy;
}
function devgui_make_crawler()
{
	zombies = zombie_utility::get_round_enemy_array();
	foreach( zombie in zombies )
	{
		gib_style = [];
		gib_style[ gib_style.size ] = "no_legs";
		gib_style[ gib_style.size ] = "right_leg";
		gib_style[ gib_style.size ] = "left_leg";
		gib_style = zombie_death::randomize_array( gib_style ); //need to move this, or use standard array random

		zombie.a.gib_ref = gib_style[0]; 				
				
		zombie.has_legs = false;
		zombie.missingLegs = true;
		zombie AllowedStances( "crouch" ); 
										
		// reduce collbox so player can jump over
		zombie setPhysParams( 15, 0, 24 );

		zombie AllowPitchAngle( 1 );
		zombie setPitchOrient();
					
		health = zombie.health;
		health = health * 0.1;

		// force gibbing if the zombie is still alive
		zombie thread zombie_death::do_gib();
	}
}
function devgui_bot_spawn( team )
{
	player = util::GetHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	direction_vec = player.origin - trace["position"];
	direction = VectorToAngles( direction_vec );
	
	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		println( "Could not add test client" );
		return;
	}
			
	bot.pers["isBot"] = true;
	bot.equipment_enabled = false;
	bot demo::reset_actor_bookmark_kill_times();
	bot.team = "allies";
	bot._player_entnum = bot GetEntityNumber();
	//bot thread bot_spawn_think( team );

	yaw = direction[1];
	bot thread devgui_bot_spawn_think( trace[ "position" ], yaw );
}

function devgui_bot_spawn_think( origin, yaw )
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self SetOrigin( origin );

		angles = ( 0, yaw, 0 );
		self SetPlayerAngles( angles );
	}
}


function zombie_devgui_open_sesame()
{
	SetDvar("zombie_unlock_all",1);
	
	//turn on the power first
	level flag::set( "power_on" );
	level clientfield::set( "zombie_power_on", 0 );
	//DCS: this will set all zone controlling power switch flags.
	power_trigs = GetEntArray( "use_elec_switch", "targetname" );
	foreach(trig in power_trigs)
	{
		if(IsDefined(trig.script_int))
		{
			level flag::set("power_on" + trig.script_int);
			level clientfield::set( "zombie_power_on", trig.script_int );
		}
	}
			
	//give everyone money
	players = GetPlayers();
	array::thread_all( players, &zombie_devgui_give_money );
	
	//get all the door triggers and trigger them
	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 

	for( i = 0; i < zombie_doors.size; i++ )
	{
		zombie_doors[i] notify("trigger",players[0]);
		
		if ( ( isdefined( zombie_doors[i].power_door_ignore_flag_wait ) && zombie_doors[i].power_door_ignore_flag_wait ) )
		{
			zombie_doors[i] notify( "power_on" );
		}
		
		wait(.05);
	}

	// AIRLOCK DOORS ----------------------------------------------------------------------------- //
	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 

	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		zombie_airlock_doors[i] notify("trigger",players[0]);
		wait(.05);
	}

	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 

	for( i = 0; i < zombie_debris.size; i++ )
	{
		if (isdefined(zombie_debris[i]))
			zombie_debris[i] notify("trigger",players[0]); 
		wait(.05);
	}

	level notify("open_sesame");
	wait( 1 );			
	SetDvar( "zombie_unlock_all", 0 );
}

function any_player_in_noclip()
{
	foreach( player in GetPlayers() )
	{
		if (player IsInMoveMode( "ufo", "noclip" ) )
			return true;
	}
	return false;
}

function diable_fog_in_noclip()
{
	level.fog_disabled_in_noclip = 1;
	level endon("allowfoginnoclip");
	level flag::wait_till( "start_zombie_round_logic" ); 
	while (1)
	{
		while(!any_player_in_noclip() )
			wait 1;
		SetDvar( "scr_fog_disable", "1" );
		SetDvar( "r_fog_disable", "1" );

		if( isdefined( level.culldist ) )
			SetCullDist( 0 );

		while(any_player_in_noclip())
			wait 1;
		SetDvar( "scr_fog_disable", "0" );
		SetDvar( "r_fog_disable", "0" );

		if( isdefined( level.culldist ) )
			SetCullDist( level.culldist );
	}
}

function zombie_devgui_allow_fog()
{
	if ( level.fog_disabled_in_noclip )
	{
		level notify("allowfoginnoclip");
		level.fog_disabled_in_noclip = 0;
		SetDvar( "scr_fog_disable", "0" );
		SetDvar( "r_fog_disable", "0" );
	}
	else
	{
		thread diable_fog_in_noclip();
	}
}


function zombie_devgui_give_money()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;
	
	self zm_score::add_to_player_score( 100000 );
}

function zombie_devgui_take_money()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	if (self.score > 100)
		self zm_score::player_reduce_points( "take_half" );
	else
		self zm_score::player_reduce_points( "take_all" );
}

function zombie_devgui_give_xp( amount )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self AddRankXP( "kill", self.currentweapon, undefined, undefined, 1, ( amount / 50 ) );
}

function zombie_devgui_turn_player( index )
{
	players = GetPlayers();
	if ( !IsDefined(index) || index >= players.size )
	{
		player = players[0];
	}
	else
	{
		player = players[index];
	}

	assert( IsDefined( player ) );
	assert( IsPlayer( player ) );
	assert( IsAlive( player ) );
	
	level.devcheater = 1;
	
	if( player HasPerk( "specialty_playeriszombie" ) )
	{
		println( "Player turned HUMAN" );
		player zm_turned::turn_to_human();
	}
	else
	{
		println( "Player turned ZOMBIE" );
		player zm_turned::turn_to_zombie();
	}
}


function zombie_devgui_debug_pers( index )
{
	players = GetPlayers();
	if ( !IsDefined(index) || index >= players.size )
	{
		player = players[0];
	}
	else
	{
		player = players[index];
	}

	assert( IsDefined( player ) );
	assert( IsPlayer( player ) );
	assert( IsAlive( player ) );
	
	level.devcheater = 1;

	println( "\n\n----------------------------------------------------------------------------------------------" );
	println( "Active Persistent upgrades [count=" + level.pers_upgrades_keys.size + "]" );
	for ( pers_upgrade_index = 0; pers_upgrade_index < level.pers_upgrades_keys.size; pers_upgrade_index++ )
	{
		name = level.pers_upgrades_keys[pers_upgrade_index];
		println( pers_upgrade_index + ">pers_upgrade name = " + name );
	
		pers_upgrade = level.pers_upgrades[name];

		for ( i = 0; i < pers_upgrade.stat_names.size; i++ )
		{
			stat_name = pers_upgrade.stat_names[i];
			stat_desired_value = pers_upgrade.stat_desired_values[i];
			player_current_stat_value = player zm_stats::get_global_stat( stat_name );

			println( "  " + i + ")stat_name = " + stat_name );
			println( "  " + i + ")stat_desired_values = " + stat_desired_value );
			println( "  " + i + ")player_current_stat_value = " + player_current_stat_value );
		}

		//Does player have this upgrade?
		if ( ( isdefined( player.pers_upgrades_awarded[name] ) && player.pers_upgrades_awarded[name] ) )
		{
			println( "PLAYER HAS - " + name );
		}
		else
		{
			println( "PLAYER DOES NOT HAVE - " + name );
		}
	}

	println( "----------------------------------------------------------------------------------------------\n\n" );
}


function zombie_devgui_cool_jetgun()
{
	if ( IsDefined( level.zm_devgui_jetgun_never_overheat ) )
	{
		self thread [[ level.zm_devgui_jetgun_never_overheat ]]();
	}
}

function zombie_devgui_preserve_turbines()
{
	self endon("disconnect");
	self notify("preserve_turbines");
	self endon("preserve_turbines");
	if (!( isdefined( self.preserving_turbines ) && self.preserving_turbines ))
	{
		self.preserving_turbines = 1;
		while (1)
		{
			self.turbine_health = 1200;
			wait 1;
		}
	}
	self.preserving_turbines = 0;
	
}

function zombie_devgui_equipment_stays_healthy()
{
	self endon("disconnect");
	self notify("preserve_equipment");
	self endon("preserve_equipment");
	if (!( isdefined( self.preserving_equipment ) && self.preserving_equipment ))
	{
		self.preserving_equipment = 1;
		while (1)
		{
			self.equipment_damage=[];
			self.shieldDamageTaken=0;
			if (isdefined(level.destructible_equipment))
			{
				foreach( equip in level.destructible_equipment )
				{
					if (isdefined(equip))
					{
						equip.shieldDamageTaken=0;
						equip.damage = 0;
						equip.headchopper_kills = 0;
						equip.springpad_kills = 0;
						equip.subwoofer_kills = 0;
					}
				}
			}
			wait 0.1;
		}
	}
	self.preserving_equipment = 0;
}

function zombie_devgui_disown_equipment()
{
	//self.current_equipment=undefined;
	self.deployed_equipment=[];
	
}




function zombie_devgui_equipment_give( equipment )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	level.devcheater = 1;
	
	if ( zm_equipment::is_included( equipment ) )
		self zm_equipment::buy( equipment );
}


function zombie_devgui_give_placeable_mine( weapon )
{
	self endon("disconnect");
	self notify( "give_planted_grenade_thread" );
	self endon( "give_planted_grenade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;
	
	// Can't give a weapon that the map doesn't have.
	if ( !zm_utility::is_placeable_mine( weapon ) )
	{
		return;
	}

	// Take their weapon.
	if ( isdefined( self zm_utility::get_player_placeable_mine() ) )
	{
		self TakeWeapon( self zm_utility::get_player_placeable_mine() );
	}
	
	self thread zm_placeable_mine::setup_for_player( weapon );
	while( true )
	{
		self GiveMaxAmmo( weapon );
		wait( 1 );
	}
}

function zombie_devgui_give_claymores()
{
	self endon("disconnect");
	self notify( "give_planted_grenade_thread" );
	self endon( "give_planted_grenade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self zm_utility::get_player_placeable_mine() ) )
	{
		self TakeWeapon( self zm_utility::get_player_placeable_mine() );
	}

	wpn_type = zm_placeable_mine::get_first_available();
	if ( wpn_type != level.weaponNone )
	{
		self thread zm_placeable_mine::setup_for_player( wpn_type );
	}
	
	while( true )
	{
		self GiveMaxAmmo( wpn_type );
		wait( 1 );
	}
}

function zombie_devgui_give_lethal( weapon )
{
	self endon("disconnect");
	self notify( "give_lethal_grenade_thread" );
	self endon( "give_lethal_grenade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self zm_utility::get_player_lethal_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_lethal_grenade() );
	}

	self GiveWeapon( weapon );
	self zm_utility::set_player_lethal_grenade( weapon );

	while( true )
	{
		self GiveMaxAmmo( weapon );
		wait( 1 );
	}
}


function zombie_devgui_give_frags()
{
	zombie_devgui_give_lethal( GetWeapon( "frag_grenade" ) );
}

function zombie_devgui_give_sticky()
{
	zombie_devgui_give_lethal( GetWeapon( "sticky_grenade" ) );
}


function zombie_devgui_give_monkey()
{
	self endon("disconnect");
	self notify( "give_tactical_grenade_thread" );
	self endon( "give_tactical_grenade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_cymbal_monkey_give ) )
	{
		self [[ level.zombiemode_devgui_cymbal_monkey_give ]]();
		while( true )
		{
			self GiveMaxAmmo( GetWeapon( "cymbal_monkey" ) );
			wait( 1 );
		}
	}
}

function zombie_devgui_give_emp_bomb()
{
	self endon("disconnect");
	self notify( "give_tactical_grenade_thread" );
	self endon( "give_tactical_grenade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_emp_bomb_give ) )
	{
		self [[ level.zombiemode_devgui_emp_bomb_give ]]();
		while( true )
		{
			self GiveMaxAmmo( GetWeapon( "emp_grenade" ) );
			wait( 1 );
		}
	}
}

function zombie_devgui_invulnerable( playerindex, onoff )
{
	players = GetPlayers();
	if (!isdefined(playerindex))
	{
		for ( i=0; i<players.size; i++ )
			zombie_devgui_invulnerable( i, onoff );
	}
	else
	{
		if ( players.size > playerindex )
		{
			if (onoff)
				players[playerindex] EnableInvulnerability();
			else
				players[playerindex] DisableInvulnerability();
		}
	}
}

function zombie_devgui_kill()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self DisableInvulnerability();
	
	death_from = (RandomFloatRange(-20,20),RandomFloatRange(-20,20),RandomFloatRange(-20,20));
	self dodamage(self.health + 666, self.origin + death_from);
}

function zombie_devgui_toggle_ammo()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self notify("devgui_toggle_ammo");
	self endon("devgui_toggle_ammo");
	
	self.ammo4evah = !( isdefined( self.ammo4evah ) && self.ammo4evah );

	while ( isdefined(self) && self.ammo4evah )
	{
		weapon = self GetCurrentWeapon();
		if ( weapon != level.weaponNone )
		{
			self SetWeaponOverheating( 0,0 );
			max = weapon.maxAmmo;
			if (isdefined(max))
			{
				self SetWeaponAmmoStock( weapon, max );
			}
			
			if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
			{
				self GiveMaxAmmo( self zm_utility::get_player_tactical_grenade() );
			}
			if ( isdefined( self zm_utility::get_player_lethal_grenade() ) )
			{
				self GiveMaxAmmo( self zm_utility::get_player_lethal_grenade() );
			}
		}
		wait 1;
	}
}

function zombie_devgui_toggle_ignore()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	if(!isdefined(self.devgui_ignoreme))self.devgui_ignoreme=0;
	self.devgui_ignoreme = !self.devgui_ignoreme;
	
	if ( self.devgui_ignoreme )
		self zm_utility::increment_ignoreme();
	else
		self zm_utility::decrement_ignoreme();

	if ( self.ignoreme )
		SetDvar( "ai_showFailedPaths", 0 );
}

function zombie_devgui_revive()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self reviveplayer(); 
	self notify( "stop_revive_trigger" );
	if (isdefined(self.revivetrigger) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self AllowJump( true );
	
	self zm_laststand::set_ignoreme( false );
	self.laststand = undefined;
	self notify("player_revived",self);
}

function zombie_devgui_give_health()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	self notify( "devgui_health" );
	self endon( "devgui_health" );
	self endon( "disconnect" );
	self endon( "death" );
		
	level.devcheater = 1;

	while ( 1 )
	{
		self.maxhealth = 100000;
		self.health = 100000;

		self util::waittill_any( "player_revived", "perk_used", "spawned_player" );	
		wait( 2 );
	}
}


function zombie_devgui_give_perk( perk )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
		
	level.devcheater = 1;

	if ( vending_triggers.size < 1 )
	{
		//iprintln( "Map does not contain any perks machines" );
		return;
	}

	foreach( player in GetPlayers() )
	{
		for ( i = 0; i < vending_triggers.size; i++ )
		{
			if ( vending_triggers[i].script_noteworthy == perk )
			{
				vending_triggers[i] notify( "trigger", player );
				break;
			}
		}
		wait 1;
	}

	//iprintln( "Map does not contain perks machine with perk: " + perk );
}

function zombie_devgui_take_perks( cmd )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	perks = [];
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		perk = vending_triggers[i].script_noteworthy;

		if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}

		perks[ perks.size ] = perk;
	}

	foreach( player in GetPlayers() )
	{
		foreach( perk in perks )
		{
			perk_str = perk + "_stop";
			player notify( perk_str );
		}
	}
}

function zombie_devgui_give_powerup( powerup_name, now, origin )
{
	player = GetPlayers()[0];
	found = false;
		
	level.devcheater = 1;

	if ( IsDefined(now) && !now )
	{
		for ( i = 0; i < level.zombie_powerup_array.size; i++ )
		{
			if ( level.zombie_powerup_array[i] == powerup_name )
			{
				level.zombie_powerup_index = i;
				found = true;
				break;
			}
		}
	
		if ( !found )
		{
			//iprintln( "Powerup not found: " + powerup_name );
			return;
		}
		level.zombie_devgui_power = 1;
		level.zombie_vars["zombie_drop_item"] = 1;
		level.powerup_drop_count = 0;
		return; 
	}
	
	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

	// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );
	
	if ( IsDefined(origin) )
		level thread zm_powerups::specific_powerup_drop( powerup_name, origin );
	else 
		level thread zm_powerups::specific_powerup_drop( powerup_name, trace["position"] );
}


function zombie_devgui_give_powerup_player( powerup_name, now )
{
	player = self; 
	
	found = false;
		
	level.devcheater = 1;

	if ( IsDefined(now) && !now )
	{
		for ( i = 0; i < level.zombie_powerup_array.size; i++ )
		{
			if ( level.zombie_powerup_array[i] == powerup_name )
			{
				level.zombie_powerup_index = i;
				found = true;
				break;
			}
		}
	
		if ( !found )
		{
			//iprintln( "Powerup not found: " + powerup_name );
			return;
		}
		level.zombie_devgui_power = 1;
		level.zombie_vars["zombie_drop_item"] = 1;
		level.powerup_drop_count = 0;
		return; 
	}
	
	
	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

	// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );
	level thread zm_powerups::specific_powerup_drop( powerup_name, trace["position"], undefined, undefined, undefined, player );
}



function zombie_devgui_goto_round( target_round )
{
	player = GetPlayers()[0];

	if ( target_round < 1 )
	{
		target_round = 1;
	}
	
	level.devcheater = 1;

	level.zombie_total = 0;
	zombie_utility::ai_calculate_health( target_round );
	level.round_number = target_round - 1;

	level notify( "kill_round" );

	
	//iprintln( "Jumping to round: " + target_round );
	wait( 1 );
	
	// kill all active zombies
	zombies = GetAITeamArray( level.zombie_team );

	if ( IsDefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			if ( ( isdefined( zombies[i].ignore_devgui_death ) && zombies[i].ignore_devgui_death ) )
			{
				continue;
			}
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}
}


function zombie_devgui_monkey_round()
{
	if ( IsDefined( level.next_monkey_round ) )
	{
		zombie_devgui_goto_round( level.next_monkey_round );
	}
}

function zombie_devgui_thief_round()
{
	if ( IsDefined( level.next_thief_round ) )
	{
		zombie_devgui_goto_round( level.next_thief_round );
	}
}

function zombie_devgui_dog_round( num_dogs )
{
	if( !IsDefined( level.dogs_enabled ) || !level.dogs_enabled )
	{
		//iprintln( "Dogs not enabled in this map" );
		return;
	}

	if( !IsDefined( level.dog_rounds_enabled ) || !level.dog_rounds_enabled )
	{
		//iprintln( "Dog rounds not enabled in this map" );
		return;
	}

	if( !IsDefined( level.enemy_dog_spawns ) || level.enemy_dog_spawns.size < 1 )
	{
		//iprintln( "Dog spawners not found in this map" );
		return;
	}
	
	if ( !level flag::get( "dog_round" ) )
	{
		//iprintln( "Spawning " + num_dogs + " dogs" );
		SetDvar( "force_dogs", num_dogs );
	}
	else
	{
		//iprintln( "Removing dogs" );
	}

	zombie_devgui_goto_round( level.round_number + 1 );
}

function zombie_devgui_dog_round_skip()
{
	if ( IsDefined( level.next_dog_round ) )
	{
		zombie_devgui_goto_round( level.next_dog_round );
	}
}

function zombie_devgui_dump_zombie_vars()
{
	if ( !IsDefined( level.zombie_vars ) )
	{
		return;
	}
		

	if( level.zombie_vars.size > 0 )
	{
		//iprintln( "Zombie Variables Sent to Console" );
		println( "#### Zombie Variables ####");
	}
	else
	{
		return;
	}
	
	var_names = GetArrayKeys( level.zombie_vars );
	
	for( i = 0; i < level.zombie_vars.size; i++ )
	{
		key = var_names[i];
		println( key + ":     " + level.zombie_vars[key] );
	}

	println( "##### End Zombie Variables #####");
}

function zombie_devgui_pack_current_weapon()
{
	players = GetPlayers();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() )
		{
			weap = players[i] getcurrentweapon();
			weapon = get_upgrade( weap.rootWeapon );

			if ( ( isdefined( level.aat_in_use ) && level.aat_in_use ) )
			{
				players[i] thread aat::acquire( weapon );
			}

			players[i] TakeWeapon( weap );
			players[i] zm_weapons::give_build_kit_weapon( weapon );
			players[i] GiveStartAmmo( weapon );
			players[i] SwitchToWeapon( weapon );	
		}
	}
}

function zombie_devgui_unpack_current_weapon()
{
	players = GetPlayers();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() )
		{
			weap = players[i] getcurrentweapon();
			weapon = zm_weapons::get_base_weapon( weap );

			players[i] TakeWeapon( weap );
			players[i] zm_weapons::give_build_kit_weapon( weapon );
			players[i] GiveStartAmmo( weapon );
			players[i] SwitchToWeapon( weapon );	
		}
	}
}

function zombie_devgui_reopt_current_weapon()
{
	players = GetPlayers();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() )
		{
			weapon = players[i] getcurrentweapon();

			if (isdefined(players[i].pack_a_punch_weapon_options) )
			{
				players[i].pack_a_punch_weapon_options[weapon] = undefined;
			}
			players[i] TakeWeapon( weapon );
			players[i] zm_weapons::give_build_kit_weapon( weapon );
			players[i] GiveStartAmmo( weapon );
			players[i] SwitchToWeapon( weapon );	
		}
	}
}

function zombie_devgui_take_weapon()
{
	players = GetPlayers();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() )
		{
			players[i] TakeWeapon( players[i] getcurrentweapon() );
			players[i] zm_weapons::switch_back_primary_weapon( undefined );
			
		}
	}
}

function zombie_devgui_take_weapons( give_fallback )
{
	players = GetPlayers();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] laststand::player_is_in_laststand() )
		{
			players[i] TakeAllWeapons();
			if (give_fallback)
				players[i] zm_weapons::give_fallback_weapon();
		}
	}
}


function get_upgrade( weapon )
{
	if( IsDefined(level.zombie_weapons[weapon]) && IsDefined(level.zombie_weapons[weapon].upgrade_name) )
	{
		return zm_weapons::get_upgrade_weapon( weapon, false );
	}
	else
	{
		return zm_weapons::get_upgrade_weapon( weapon, true );
	}
}

function zombie_devgui_director_easy()
{
	if ( IsDefined( level.director_devgui_health ) )
	{
		[[ level.director_devgui_health ]]();
	}
}


function zombie_devgui_chest_never_move()
{
	level notify( "devgui_chest_end_monitor" );
	level endon( "devgui_chest_end_monitor" );

	for ( ;; )
	{
		level.chest_accessed = 0;
		wait( 5 );
	}
}



function zombie_devgui_disable_kill_thread_toggle()
{
	if ( !( isdefined( level.disable_kill_thread ) && level.disable_kill_thread ) )
	{
		level.disable_kill_thread = true;
	}
	else
	{
		level.disable_kill_thread = false;
	}
}


function zombie_devgui_check_kill_thread_every_frame_toggle()
{
	if ( !( isdefined( level.check_kill_thread_every_frame ) && level.check_kill_thread_every_frame ) )
	{
		level.check_kill_thread_every_frame = true;
	}
	else
	{
		level.check_kill_thread_every_frame = false;
	}
}

function zombie_devgui_kill_thread_test_mode_toggle()
{
	if ( !( isdefined( level.kill_thread_test_mode ) && level.kill_thread_test_mode ) )
	{
		level.kill_thread_test_mode = true;
	}
	else
	{
		level.kill_thread_test_mode = false;
	}
}

function showOneSpawnPoint(
	spawn_point,
	color,
	notification,
	height,
	print)
{
	if ( !IsDefined( height ) || height <= 0 )
	{
		height = util::get_player_height();
	}

	if ( !IsDefined( print ) )
	{
		print = spawn_point.classname;
	}

	center = spawn_point.origin;
	forward = anglestoforward(spawn_point.angles);
	right = anglestoright(spawn_point.angles);

	forward = VectorScale(forward, 16);
	right = VectorScale(right, 16);

	a = center + forward - right;
	b = center + forward + right;
	c = center - forward + right;
	d = center - forward - right;
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	thread lineUntilNotified(a, a + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(b, b + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(c, c + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(d, d + (0, 0, height), color, 0, notification);

	a = a + (0, 0, height);
	b = b + (0, 0, height);
	c = c + (0, 0, height);
	d = d + (0, 0, height);
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	center = center + (0, 0, height/2);
	arrow_forward = anglestoforward(spawn_point.angles);
	arrowhead_forward = anglestoforward(spawn_point.angles);
	arrowhead_right = anglestoright(spawn_point.angles);

	arrow_forward = VectorScale(arrow_forward, 32);
	arrowhead_forward = VectorScale(arrowhead_forward, 24);
	arrowhead_right = VectorScale(arrowhead_right, 8);
	
	a = center + arrow_forward;
	b = center + arrowhead_forward - arrowhead_right;
	c = center + arrowhead_forward + arrowhead_right;
	
	thread lineUntilNotified(center, a, color, 0, notification);
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(a, c, color, 0, notification);

	thread print3DUntilNotified(spawn_point.origin + (0, 0, height), print, color, 1, 1, notification);
	
	return;
}

function print3DUntilNotified(origin, text, color, alpha, scale, notification)
{
	level endon(notification);
	
	for(;;)
	{
		print3d(origin, text, color, alpha, scale);
		wait .05;
	}
}

function lineUntilNotified(start, end, color, depthTest, notification)
{
	level endon(notification);
	
	for(;;)
	{
		line(start, end, color, depthTest);
		wait .05;
	}
}


function devgui_debug_hud()
{
	// refill grenades
	if ( isdefined( self zm_utility::get_player_lethal_grenade() ) )
		self GiveMaxAmmo( self zm_utility::get_player_lethal_grenade() );
	
	//claymores
	wpn_type = zm_placeable_mine::get_first_available();
	if ( wpn_type != level.weaponNone )
	{
		self thread zm_placeable_mine::setup_for_player( wpn_type );
	}
	
	// monkeys
	if ( IsDefined( level.zombiemode_devgui_cymbal_monkey_give ) )
	{
		if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
			self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
		self [[ level.zombiemode_devgui_cymbal_monkey_give ]]();
	}
	else if ( isdefined( self zm_utility::get_player_tactical_grenade() ) )
	{
		self GiveMaxAmmo( self zm_utility::get_player_tactical_grenade() );
	}

	// equipment
	if (IsDefined(level.zombie_include_equipment ) && !IsDefined(self zm_equipment::get_player_equipment()))
	{
		equipment = GetArrayKeys( level.zombie_include_equipment );
	
		if (isdefined(equipment[0]))
		{
			self zombie_devgui_equipment_give( equipment[0] );
		}
	}

	//perks
	for (i =0; i<10; i++)
	{
		zombie_devgui_give_powerup( "free_perk", true, self.origin );
		wait 0.25;		
	}

	// on screen powerups
	zombie_devgui_give_powerup( "insta_kill", true, self.origin );
		wait 0.25;		
	zombie_devgui_give_powerup( "double_points", true, self.origin );
		wait 0.25;		
	zombie_devgui_give_powerup( "fire_sale", true, self.origin );
		wait 0.25;		
	zombie_devgui_give_powerup( "minigun", true, self.origin );
		wait 0.25;		
	zombie_devgui_give_powerup( "bonfire_sale", true, self.origin );
		wait 0.25;		
}


function devgui_test_chart_think()
{
	{wait(.05);}; // wait to get 0 initially

	old_val = GetDvarInt( "scr_debug_test_chart" );

	for ( ;; )
	{
		val = GetDvarInt( "scr_debug_test_chart" );

		if ( old_val != val )
		{
			if ( IsDefined( level.test_chart_model ) )
			{
				level.test_chart_model delete();
				level.test_chart_model = undefined;
			}

			if ( val )
			{
				player = GetPlayers()[0];

				direction = player GetPlayerAngles();
				direction_vec = AnglesToForward( (0, direction[1], 0) ); // only want the player's yaw

				scale = 120;
				direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

				level.test_chart_model = Spawn( "script_model", player GetEye() + direction_vec );
				level.test_chart_model SetModel( "test_chart_model" );
				level.test_chart_model.angles = (0, direction[1], 0) + (0, 90, 0); // only want the yaw
			}
		}

		old_val = val;
		{wait(.05);};
	}
}

function zombie_devgui_draw_traversals()
{
	if ( !IsDefined( level.toggle_draw_traversals ) )
	{
		level.toggle_draw_traversals = 1;
	}
	else
	{
		level.toggle_draw_traversals = !level.toggle_draw_traversals;
	}
}

function wait_for_zombie( crawler )
{
	nodes = GetAllNodes();

	while ( 1 )
	{
		ai = GetActorArray();
		zombie = ai[0];
		if ( IsDefined( zombie ) )
		{
			if ( ( isdefined( crawler ) && crawler ) )
			{
				if ( !( isdefined( zombie.missingLegs ) && zombie.missingLegs ) )
				{
					wait( 0.25 );
					continue;
				}
			}

			foreach( node in nodes )
			{
				if ( node.type == "Begin" || node.type == "End" || node.type == "BAD NODE" )
				{
					if ( IsDefined( node.animscript ) )
					{
						Blackboard::SetBlackBoardAttribute( zombie, "_stance", "stand" );
						Blackboard::SetBlackBoardAttribute( zombie, "_traversal_type", node.animscript );

						anim_results = zombie ASTSearch( IString( "traverse@zombie" ) );
						if ( !IsDefined( anim_results[ "animation" ] ) )
						{
							if ( ( isdefined( zombie.missingLegs ) && zombie.missingLegs ) )
							{
								node.bad_crawler_traverse = true;
							}
							else
							{
								node.bad_traverse = true;
							}
						}
					}
				}
			}
			break;
		}
		wait( 0.25 );
	}
}

function zombie_draw_traversals()
{
	level thread wait_for_zombie();
	level thread wait_for_zombie( true );

	nodes = GetAllNodes();

	while ( 1 )
	{
		if ( ( isdefined( level.toggle_draw_traversals ) && level.toggle_draw_traversals ) )
		{
			foreach( node in nodes )
			{
				if ( IsDefined( node.animscript ) )
				{
					txt_color = ( 0, 0.8, 0.6 );
					circle_color = ( 1, 1, 1 );

					if ( ( isdefined( node.bad_traverse ) && node.bad_traverse ) )
					{
						txt_color = ( 1, 0, 0 );
						circle_color = ( 1, 0, 0 );
					}

					circle( node.origin, 16, circle_color );
					print3d( node.origin, node.animscript, txt_color, 1, 0.5 );

					if ( ( isdefined( node.bad_crawler_traverse ) && node.bad_crawler_traverse ) )
					{
						print3d( node.origin + ( 0, 0, -12 ), "missing crawler version", ( 1, 0, 0 ), 1, 0.5 );
					}
				}
			}
		}

		{wait(.05);};
	}
}

function testScriptRuntimeErrorAssert()
{
	wait(1);

	assert( 0 );
}

function testScriptRuntimeError2()
{
	myundefined = "test";
	if( myundefined == 1 )
		println( "undefined in testScriptRuntimeError2\n" );
}

function testScriptRuntimeError1()
{
	testScriptRuntimeError2();
}

function testScriptRuntimeError()
{
	wait 5;
	for(;;)
	{
		if(GetDvarString( "scr_testScriptRuntimeError") != "0" )
			break;
		wait 1;
	}
	
	myerror = GetDvarString( "scr_testScriptRuntimeError" );
	
	SetDvar( "scr_testScriptRuntimeError", "0" );

	if( myerror == "assert" )
		testScriptRuntimeErrorAssert();
	else
		testScriptRuntimeError1();

	thread testScriptRuntimeError();
}



#/
