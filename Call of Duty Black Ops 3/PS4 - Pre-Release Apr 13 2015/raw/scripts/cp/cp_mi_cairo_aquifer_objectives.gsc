#using scripts\codescripts\struct;

#using scripts\shared\scene_shared;
#using scripts\shared\array_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\_dialog;
#using scripts\cp\_hacking;
#using scripts\cp\sidemissions\_sm_ui;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_util;
#using scripts\cp\_skipto;
#using scripts\cp\_debug;
#using scripts\cp\_dialog;

#using scripts\cp\cp_mi_cairo_aquifer_utility;
#using scripts\cp\cp_mi_cairo_aquifer_interior;
#using scripts\cp\cp_mi_cairo_aquifer_boss;
#using scripts\cp\cp_mi_cairo_aquifer_fx;
#using scripts\cp\cp_mi_cairo_aquifer_sound;
#using scripts\shared\vehicle_shared;
#using scripts\shared\flag_shared;
#using scripts\cp\cp_mi_cairo_aquifer_aitest;
#using scripts\cp\_objectives;
#using scripts\shared\hud_util_shared;

#using scripts\cp\sidemissions\_sm_ui_worldspace;

#namespace aquifer_obj;





function handle_intro_dialog()
{
	level waittill( "begin_intro_dialog" );
	
	wait 1;
	
 	dialog::remote( "hend_command_this_is_vip_0", 0.5 );//Command, this is Viper Wing on final approach to AO. Coming in fast and low.
    dialog::remote( "comm_roger_that_viper_win_0", 0.5 );//Roger that Viper Wing, Allied forces have engaged the NRC at target location.
    dialog::remote( "hend_do_we_have_positive_0", 10.0 );//Do we have positive ID on HVTs Hyperion and Prometheus?
    dialog::remote( "comm_affirmative_viper_wi_0", 0.5 );//Affirmative Viper Wing, positive ID on Aquifer, precise location unknown.
    
    level waittill( "disengage_autopilot" );
    
    dialog::remote( "hend_disengaging_autopilo_0", 0.5 );//Disengaging Autopilot.
    
    
}



function skipto_level_long_fly_in_init(str_objective, b_starting )
{
	thread aquifer_util::exterior_ambiance();
	
	objectives::set("cp_level_aquifer_locate_aquifer");
	
	thread handle_intro_dialog();
	
    level waittill( "disengage_autopilot" );
	
    objectives::complete("cp_level_aquifer_locate_aquifer");
    
	skipto::objective_completed( str_objective );
}

function skipto_level_long_fly_in_done( str_objective, b_starting, b_direct, player )
{

}

function skipto_level_short_fly_in_init(str_objective, b_starting )
{
	thread aquifer_util::exterior_ambiance();
}

function skipto_level_short_fly_in_done( str_objective, b_starting, b_direct, player )
{

}

function skipto_post_intro_init( str_objective, b_starting )
{
	level flag::wait_till("player_active_in_level");
	
	thread aquifer_util::exterior_ambiance();
	aquifer_util::init_heightmap_intro_state();
	
//	level flag::wait_till("start_aquifer_objectives");
	wait 1;
	skipto::objective_completed( str_objective );
}

function skipto_post_intro_done( str_objective, b_starting, b_direct, player )
{
	if( b_starting )
		return;

}

/#

function debug_objs(txt)
{
	self endon("death");
	color = (1,1,1);
	size = 12;

	while(1)
	{
		
		print3d( self.origin, txt, color, 1, size );
		{wait(.05);};

	}
}


#/

function complete_obj_when_ent_dies( obj_id, obj, ent,notify_send )
{
	ent waittill("death");
	
	objectives_complete( obj_id, obj );
	level notify( notify_send );
	obj Delete();
	
}
	

/#
function debug_kill_tanks()
{
	wait 8;	
	
	numo = level.quad_tank_objectives.size;
	for(i=0;i<numo;i++)
	{
		wait (20/ numo);
		level.quad_tank_objectives[i] Delete();
		//objectives_complete("cp_level_aquifer_destroyme",level.quad_tank_objectives[i]);
		
	}

}

#/
	
function defenses_vo()
{
	
    dialog::remote("hend_alright_squad_we_ne_0", 2);//Alright squad, we need to knock out those air defenses so Egyptian forces can board the Aquifer!
	
//    txt = [];
//	txt[txt.size]="Example dogfight action.";
//	txt[txt.size]="See video: Aquifer_Dogfighto.mov";
//	txt[txt.size]="Hold L2 to lockon to ground and air enemies.";
//	level thread debug::debug_info_screen(txt, 5, undefined, undefined, undefined, undefined, undefined, false );


    
    wait 10;
    if( level.obj_curr_dead == 0)
		dialog::remote("hend_hit_those_anti_air_f_0");//Hit those anti-air forces or we're not going to last long up here!
	
}

function spawner_exists( tname )
{
	ent = GetEnt( tname,"targetname");
	if(IsDefined(ent) && IsSpawner(ent))
		return true;
	
	return false;
	

}

function common_defenses_init( base_name, obj_main, obj_inworld, notify_send  )
{
	level.quad_tank_objectives = [];
	
	count = 1; 
	
	while(spawner_exists( base_name + count ))
	{
		t = spawner::simple_spawn_single( base_name + count );
		level.quad_tank_objectives[ level.quad_tank_objectives.size ] =t;
		t.trophy_disables = 4;
		count++;
	}
	
	if(level.quad_tank_objectives.size == 0)
	{
		wait 0.5;
		level notify("common_defense_objectives_complete");
		return;
	}
		
/#
//	thread debug_kill_tanks();

#/		
	level.obj_curr_dead = 0;
	
	obj2 = [];
	for( i=0 ; i<level.quad_tank_objectives.size ; i++)
	{
//		obj2[i] = SpawnStruct();
//		obj2[i].origin = level.quad_tank_objectives[i].origin;
//		obj2[i].angles = level.quad_tank_objectives[i].angles;
		
		obj2[ i ] = util::spawn_model( "tag_origin", level.quad_tank_objectives[ i ].origin, level.quad_tank_objectives[ i ].angles );
		obj2[ i ] linkto( level.quad_tank_objectives[ i ] );
	}

	objectives_set(obj_main);
	objectives_set(obj_inworld, obj2 );
	
		

	for( i=0 ; i<level.quad_tank_objectives.size ; i++)
	{
		thread complete_obj_when_ent_dies( obj_inworld, obj2[i], level.quad_tank_objectives[i],notify_send);
	}
	

	wait 0.05;// give them all chance to spawn in.
			
	num_targets = level.quad_tank_objectives.size;
	while( level.obj_curr_dead < num_targets )
	{
		level waittill( notify_send );
		level.obj_curr_dead++;
		
		if( level.obj_curr_dead == 1)
		{
			level thread dialog::remote("hend_one_down_0");//One down.
		}
		else if(num_targets - level.obj_curr_dead == 1)
		{
			level thread dialog::remote("hend_only_one_left_0");//Only one left.
		}
		            
	}
	
	level notify("common_defense_objectives_complete");

	
}

function skipto_defenses_init2( str_objective, b_starting )
{
	level flag::wait_till("player_active_in_level");
	//aquifer_util::init_heightmap_breach_state();
	aquifer_util::init_heightmap_obj3_state();
	
	thread aquifer_util::exterior_ambiance();
	
	notify_send= "target_down";
	thread common_defenses_init( "quadtank_zone03_", "cp_level_aquifer_destroy_defenses2", "cp_level_aquifer_destroyme", notify_send );
	
	egyptians_hacking(); // blocking.
	
//	level waittill("common_defense_objectives_complete");
	objectives_complete("cp_level_aquifer_destroy_defenses2");

	skipto::objective_completed(str_objective);

}

function egyptians_hacking()
{
	level.hack_upload_range =4096;
	sq= level.hack_upload_range * level.hack_upload_range;


	
	notify_send= "trigger_hacked";
	
	wait 3;
	
	thread common_hacking_init( "hack_zone03_", "cp_level_aquifer_hack_terminals2", "cp_level_aquifer_hackme", notify_send );
	wait 0.05;
	objectives::hide("cp_level_aquifer_hack_terminals2");
	
	//wait until at least one player gets near the egyptians.
	my_trig = level.hacking_trigs[0];
	my_loc = level.hacking_trigs[0].origin;
	player = undefined;
	done= false;
	while(!done)
	{
		wait 0.2;
		foreach(player in level.players)
		{
			if( DistanceSquared( player.origin, my_loc ) < sq)
			{
				done = true;
				my_trig notify( "trigger_hack",player );
				break;
			}
			
		}
	}
	
	IPrintLnBold("FORCE HACKED TRIG");
	IPrintLn("FORCE HACKED TRIG");
	
	level waittill("common_hacking_objectives_complete");

}
	

function skipto_defenses_done2(str_objective, b_starting, b_direct, player)
{
	
}
function skipto_defenses_init3( str_objective, b_starting )
{
	level flag::wait_till("player_active_in_level");
	aquifer_util::init_heightmap_breach_state();
	thread aquifer_util::exterior_ambiance();
	
	notify_send= "target_down";
	thread common_defenses_init( "quadtank_zone02_", "cp_level_aquifer_destroy_defenses3", "cp_level_aquifer_destroyme", notify_send );
	
	level waittill("common_defense_objectives_complete");
	objectives_complete("cp_level_aquifer_destroy_defenses3");

	
	
	skipto::objective_completed(str_objective);
	
}
function skipto_defenses_done3(str_objective, b_starting, b_direct, player)
{
	
}
function skipto_hack_init2( str_objective, b_starting )
{
	level flag::wait_till("player_active_in_level");
	level.fast_hack = false;
	
//	aquifer_util::init_heightmap_breach_state();
	aquifer_util::init_heightmap_obj3_state();

	thread aquifer_util::exterior_ambiance();

	skipto::objective_completed(str_objective);	

	//objectives_complete("cp_level_aquifer_hack_terminals2");
}
function skipto_hack_done2(str_objective, b_starting, b_direct, player)
{
	
}
function skipto_hack_init3( str_objective, b_starting )
{
	
	level flag::wait_till("player_active_in_level");
	level.fast_hack = true;
	level.hack_upload_range =384;
	
//	aquifer_util::init_heightmap_obj3_state();
	aquifer_util::init_heightmap_breach_state();

	thread aquifer_util::exterior_ambiance();

	notify_send= "trigger_hacked";
	thread common_hacking_init( "hack_zone02_", "cp_level_aquifer_hack_terminals3", "cp_level_aquifer_hackme", notify_send );
	
	level waittill("common_hacking_objectives_complete");
	skipto::objective_completed(str_objective);	

	
	dialog::remote("hend_nice_work_interfaci_0");//Nice work. Interfacing to command, keep it up.
	wait 1;
	dialog::remote("hend_command_we_re_fully_0");//Command, we're fully patched in.
	dialog::remote("comm_running_through_the_0");//Running through the feed now... hold for further orders.
	objectives_complete("cp_level_aquifer_hack_terminals3");
	
}
function skipto_hack_done3(str_objective, b_starting, b_direct, player)
{
	
	
}
	
	
function skipto_defenses_init( str_objective, b_starting )
{
	
	level flag::wait_till("player_active_in_level");
	thread defenses_vo();
	
	
	aquifer_util::init_heightmap_intro_state();
	thread aquifer_util::exterior_ambiance();

	notify_send= "target_down";
	thread common_defenses_init( "quadtank_obj_", "cp_level_aquifer_destroy_defenses", "cp_level_aquifer_destroyme", notify_send );
	
	
	
	level waittill("common_defense_objectives_complete");

	
	objectives_complete("cp_level_aquifer_destroy_defenses");
	
	dialog::remote("hend_good_job_they_re_al_0");//Good job. They're all down.
	dialog::remote("comm_viper_wing_this_is_0");//Viper Wing, this is Command. Egyptian forces have a possible ID on Hyperion's location, we need you to hack into the rig's network and confirm.
	dialog::remote("hend_solid_copy_command_0");//Solid copy, Command. We're on it.
	dialog::remote("hend_you_heard_him_we_ne_0");//You heard him, we need to drop to the rig and patch into the hardline.
	dialog::remote("hend_command_is_uploading_0");//Command is uploading positional data now...

	skipto::objective_completed(str_objective);
	
	
}

function skipto_defenses_done(str_objective, b_starting, b_direct, player)
{
	if( b_starting )
		return;

	
	

}

function team_within_radius_to_ent(team, ent, radius)
{
	if( !isdefined( ent ) )
		return;
	guys =[];
	if(team == "allies")
		guys = level.players;
	else
		guys = GetAITeamArray( team );
	
	ret = [];
	
	if(!isdefined(radius))
		radius =256;
	guys = ArraySort( guys, ent.origin, true,16,radius );
	
	foreach( dude in guys )
	{
		if( !isdefined( dude ) || !IsAlive( dude ) )
		{
		   	continue;
		}
		
		if( isVehicle( dude ) )
		{
			continue;
		}
//		
//		if( IS_ROBOT( dude ) )
//		{
//			continue;
//		}
		
		ret[ ret.size] = dude;
	}
	
	return ret;
}

function hack_countdown_worldspace()
{
	outer = 1024;
	
	o_3d_message = new cFakeWorldspaceMessage();
	
	if ( ( level.hack_upload_range * 2 ) > outer )
		outer = outer +( level.hack_upload_range * 2 );
		
	[[ o_3d_message ]]->init( self.origin + ( 0, 0, 72 ), outer );
	[[ o_3d_message ]]->set_parent( self );
	o_3d_message.m_n_range_inner = level.hack_upload_range * 2;

	o_3d_message.my_line_id = [[o_3d_message]]->add_line( &"CP_MI_CAIRO_AQUIFER_DEFEND_TIMER", 2.0, true, &fake_obj_callback );
	return o_3d_message;

}

function fake_obj_callback(e_player, s_elem)
{
	if(self.counting_paused)
	{
		s_elem.label = &"CP_MI_CAIRO_AQUIFER_DEFEND_TIMER_STOP";
	}
	else
	{
		s_elem.label = &"CP_MI_CAIRO_AQUIFER_DEFEND_TIMER";
		s_elem SetValue( self.faker_time );
	}

}


function defend_hack_objective( obj_id, obj, ent,notify_send )
{
	init_time = 30000;
	remaining_time = init_time;
	start_time = GetTime();

	if( level.fast_hack )
		remaining_time = 0;
	
	team_check = "allies"; //change to axis for opposite way of handling countdown.
	last_num_nearby = -1;
	
	faker= ent hack_countdown_worldspace();
	ent.faker_time = 30000/100;
	ent.counting_paused = true;
	while(remaining_time >0 )
	{
		color = ( 0, 0, 1 );
		pause_count = false;
		//See if we have axis around the hacking trigger, and pause the countdown if we do (can always highlight the ones blocking the countdown too).
		nearest_guys = team_within_radius_to_ent( team_check, ent, level.hack_upload_range );
		if ( team_check == "allies" )
		{
			if( nearest_guys.size == 0 )
			{
				color =(1,0,0);
				ent.counting_paused = true;
				
			}
			else
			{
				remaining_time-= (50 * nearest_guys.size);
				ent.counting_paused = false;
			}
		}
		else
		{
			if( nearest_guys.size > 0 )
			{
				color =(1,0,0);
			}
			else
				remaining_time-= 50;
		}
		out = remaining_time / 1000;
		ent.faker_time = out;
//		/#
//			print3d( ent.origin, out, color, 1, 1, 1 );
//	
//		#/
			
			
		if(last_num_nearby != nearest_guys.size)
		{
			last_num_nearby = nearest_guys.size;
			if(last_num_nearby == 0)
			{
				IPrintLnBold("DNI UPLINK ON HOLD! No players within range.");
			
			}
			else
			{
				IPrintLnBold("DNI UPLINK RESUMING AT " + nearest_guys.size + " X SPEED.");
			}
		}
		{wait(.05);};

	
	}
	[[faker]]->uninitialize();
	ent Delete();
	
}

function complete_obj_when_hacked( obj_id, obj, ent,notify_send )
{
	ent hacking::trigger_wait();
	flag_name = obj.targetname + "_started";
	if( flag::exists( flag_name ) )
		flag::set(flag_name);
	//Once the hacking is complete, we need to wait for the defend countdown time, and then (potentially) the player to retrieve the device.
	objectives::hide_for_target( obj_id, obj );
	defend_hack_objective( obj_id, obj, ent,notify_send );
	flag_name = obj.targetname + "_finished";
	if( flag::exists( flag_name ) )
		flag::set(flag_name);
	
	objectives_complete( obj_id, obj );
	level notify( notify_send );
	
}



function setup_hacking( base_name )
{
	trigs = [];
	curr_trig = 1;
	while(1)
	{
		trig = getent( base_name + curr_trig,"targetname" );
		if(!isdefined(trig))
			break;
		
		trig thread hacking::init_hack_trigger(5);
		trig SetHintString( &"CP_MI_CAIRO_AQUIFER_HOLD_HACK" );
		trigs[trigs.size] = trig;
		curr_trig++;
	}
	
	return trigs;
}

function common_hacking_init( base_name, obj_main, obj_inworld, notify_send )
{
	level.hacking_trigs = setup_hacking( base_name );
	
	if(level.hacking_trigs.size == 0)
	{
		wait 0.5;
		level notify("common_hacking_objectives_complete");
		return;
	}
	
	
	obj2 = [];
	for( i=0 ; i<level.hacking_trigs.size ; i++)
	{
		obj2[i] = SpawnStruct();
		obj2[i].origin = level.hacking_trigs[i].origin;
		obj2[i].targetname = level.hacking_trigs[i].targetname;
		obj2[i].angles = (0,0,0);
	}

	
	thread objectives_set(obj_main);
	thread objectives_set(obj_inworld, obj2);
	
	for( i=0 ; i<level.hacking_trigs.size ; i++)
	{
		thread complete_obj_when_hacked( obj_inworld, obj2[i], level.hacking_trigs[i],notify_send);
	}
		
		
	num_targets = level.hacking_trigs.size;
	curr_dead = 0;
	while( curr_dead < num_targets )
	{
		level waittill( notify_send );
		curr_dead++;
		if(curr_dead == 1)
		{
			level thread dialog::remote("hend_one_down_keep_movin_0");//One down. Keep moving.
			
		}
		//IPrintLnBold("hacked targets " + curr_dead + " of " + num_targets );
		            
	}

	
	level notify("common_hacking_objectives_complete");
	thread objectives_complete(obj_main);

	
}


function skipto_hack_init( str_objective, b_starting )
{
	level flag::wait_till("player_active_in_level");
	aquifer_util::init_heightmap_intro_state();
	level.hack_upload_range =384;

	thread aquifer_util::exterior_ambiance();
	level thread dialog::remote("hend_there_they_are_get_0",3);//There they are – get down there and stay alert!

	notify_send= "trigger_hacked";
	thread common_hacking_init( "exterior_hack_trig_", "cp_level_aquifer_hack_terminals", "cp_level_aquifer_hackme", notify_send );
	
	level waittill("common_hacking_objectives_complete");
//	
//    txt = [];
//	txt[txt.size]="This playable area will be one of several that";
//	txt[txt.size]="players will have to tackle before being directed";
//	txt[txt.size]="to take on Hyperion.";
//	level thread debug::debug_info_screen(txt, 5, undefined, undefined, undefined, undefined, undefined, false );

	
	skipto::objective_completed(str_objective);	
	objectives_complete("cp_level_aquifer_hack_terminals");
}

function skipto_hack_done(str_objective, b_starting, b_direct, player)
{
	if( b_starting )
		return;


}


function skipto_water_room_init( str_objective, b_starting )
{

	trig = getent( "water_room_breach_trigger", "targetname" );
	struct = struct::get( trig.target,"targetname");
	
	objectives_set( "cp_level_aquifer_hyperions_breach",struct);
	
	level flag::wait_till( "water_room_breach" );
	objectives_complete( "cp_level_aquifer_hyperions_breach", struct );
	
	trig = getent( "water_room_trigger", "targetname" );
	struct = struct::get( trig.target,"targetname");
	
	objectives_set( "cp_level_aquifer_hyperions_trail",struct);
	
	level flag::wait_till( "water_room_checkpoint" );
	objectives_complete( "cp_level_aquifer_hyperions_trail", struct );
	skipto::objective_completed( str_objective );
	
}

function skipto_water_room_done(str_objective, b_starting, b_direct, player)
{
	if( b_starting )
		return;


}

function skipto_breach_init( str_objective, b_starting )
{
	if(!b_starting)
	{
		dialog::remote("comm_viper_wing_positiv_0",3);//Viper Wing – positive locks on the HVTs.  Colonel Ahmed is acquiring Prometheus. Engage Hyperion.
    	dialog::remote("comm_nrc_forces_have_hype_0");//NRC forces have Hyperion in custody. They're moving towards the East Hangar.
    	dialog::remote("hend_understood_command_0");//Understood, Command. Moving to intercept.
	}
	else
	{
		level flag::set("on_hangar_exterior");
	}

	SpawnHendricksIfNeeded("hendricks_pre_breach");
	thread pre_breach_scene();
	                                    
		
    level flag::set( "breach_hangar_active");
    
	loc = struct::get("breach_hangar_obj_loc","targetname");
	thread objectives_set("cp_level_aquifer_breach_meetup",loc);   

	level flag::wait_till_timeout(30,"on_hangar_exterior");
	level flag::set("on_hangar_exterior");

		
	
//	dialog::remote("hend_squad_on_me_0");//Squad, on me.
//    dialog::remote("hend_command_give_us_sec_0");//Command, give us security cam feed.
//    dialog::remote("hend_damn_it_they_re_at_0");//Damn it, they're at the Hangar, we're going to have to take a shortcut.
//	
   

	
//	wait 4;
//	skipto::objective_completed(str_objective);
	
	
}	

function skipto_breach_done (str_objective, b_starting, b_direct, player)
{
	if( b_starting )
		return;

	level.hendricks = SpawnHendricksIfNeeded("hendricks_hangar");
	
	enemies = spawn_breach_enemies("breach_enemies");
	promethius = spawner::simple_spawn("promethius_hangar");
	level.prometheus = promethius[0];
	
	thread breach_vo();
	
	struct = GetEnt("breach_scene_origin", "targetname");
	
	actors = array(level.hendricks, level.prometheus);
	actors = ArrayCombine(actors, enemies, true, true);
	
	thread handle_breach_slomo();
//	thread early_kill_hack();
	level flag::clear("start_pre_breach");
	struct scene::play("cin_aqu_04_20_breach_1st_rappel_main", actors);
	
	level notify("breach_done");
	/*
	skipto::teleport_players( "breach_hangar_teleport", undefined );
		
	txt = [];
	txt[txt.size]="Rappel breach and Hyperion escape";
	txt[txt.size]="See video: Aquifer_Hyperion_Escape.mov";
	
	level thread debug::debug_info_screen(txt,6);
*/

	util::magic_bullet_shield(level.hendricks);
		
	loc = struct::get("breach_hangar_obj_loc","targetname");
	thread objectives_complete("cp_level_aquifer_breach_meetup",loc);
	level flag::set("inside_aquifer");
}

function early_kill_hack()
{
	wait 10;
	
	scene::skipto_end("cin_aqu_04_20_breach_1st_rappel_main");
}

function handle_breach_slomo()
{
//	wait 6.06666;
//	SetSlowMotion(1.0, 0.3, 0.3);

	level.hendricks waittill("slomo_1");
	SetSlowMotion(1.0, 0.4, 0.3);
	level.hendricks waittill("slomo_2");
	SetSlowMotion(0.4, 0.3, 0.3);
	
	level.hendricks waittill("gunup");
	
	level waittill("breach_done");
	SetSlowMotion(0.5, 1, 0.2);
}

function spawn_breach_enemies(name)
{
	enemies = [];
	
	spawners = GetEntArray(name, "script_noteworthy");
	foreach (spawner in spawners)
	{
		guy = spawner spawner::spawn(true, spawner.targetname);
		enemies[enemies.size] = guy;
	}
	
	return enemies;
}

function show_enemies_underfloor()
{
	trig = GetEnt("pre_breach_zone", "targetname");
	
	while ( level flag::get("start_pre_breach") )
	{
		trig waittill("trigger", who);
		
		if ( !( isdefined( who.looking_through_floor ) && who.looking_through_floor ) )
		{
			if ( IsPlayer(who) )
			{
				who.looking_through_floor = true;
				who clientfield::set_to_player( "vtol_highlight_ai", 1 );
			}
		}
	}
	
	foreach (player in level.players)
	{
		player clientfield::set_to_player( "vtol_highlight_ai", 0 );
	}
}
	
	
function pre_breach_scene()
{
	level flag::wait_till("start_pre_breach");
/*	
	enemies = spawn_breach_enemies("pre_breach_enemies");
	prometheus = spawner::simple_spawn("pre_promethius_hangar");
	
	camera_guy = spawner::simple_spawn("camera_guy");
	
	actors = [];
	actors[0] = prometheus[0];
	actors = ArrayCombine(actors, enemies, true, true);
	
	thread show_enemies_underfloor();
*/
	thread pre_breach_vo();
	
	struct = GetEnt("breach_scene_origin", "targetname");
	struct scene::play("cin_aqu_04_10_prebreach_vign_walkin_main");

}

function pre_breach_vo()
{
	sm_ui::temp_vo("Hendricks: Command, give us security cam feed.");
	sm_ui::temp_vo("Hendricks: Damn it, they're at the hangar, we're going to have to take a shortcut.");
	
/*	
    level.hendricks dialog::say("hend_command_patch_the_se_0");//Command patch the security cam into the DNI.
    wait 1;
    level.hendricks dialog::say("hend_there_they_are_time_0");//There they are. Time to give us an opening.
*/    
}
	

function breach_vo()
{
    level.hendricks dialog::say("hend_remember_we_need_hy_0");//Remember, we need Hyperion alive, watch those shots!
    level.hendricks dialog::say("hend_ready_go_0");//Ready!...   Go!
}

function skipto_post_breach_init (str_objective, b_starting)
{
	level flag::wait_till("inside_aquifer");
	
	thread cp_mi_cairo_aquifer_interior::post_breach_setup();
	
	level flag::wait_till("inroom");
	
	skipto::objective_completed(str_objective);	

}

function skipto_post_breach_done (str_objective, b_starting, b_direct, player)
{
	level flag::wait_till("inroom");

	if(!b_starting)
		objectives::complete("cp_level_aquifer_follow_hendricks");
}

function skipto_boss_init(str_objective, b_starting )
{
	level flag::set("inside_aquifer");
	
	level.hendricks = aquifer_obj::SpawnHendricksIfNeeded("hendricks_boss");
	
	level flag::wait_till("inroom");
	objectives::set("cp_level_aquifer_hyperion_capture");
	cp_mi_cairo_aquifer_boss::start_boss();

	
	level flag::wait_till( "hyperion_start_tree_scene");
	objectives::complete("cp_level_aquifer_hyperion_capture");
	// hack/fix below
	//level flag::wait_till_timeout(200, "hyperion_start_tree_scene");  
	//cp_mi_cairo_aquifer_boss::end_battle();
	//level flag::set( "hyperion_start_tree_scene");
	// end hack/fix
	
	skipto::objective_completed(str_objective);	
	
}

function skipto_boss_done( str_objective, b_starting, b_direct, player )
{

}


function skipto_hideout_init( str_objective, b_starting )
{
	level flag::set( "hyperion_start_tree_scene");
	aquifer_util::toggle_interior_doors(false);

	SpawnHendricksIfNeeded("hendricks_hideout");

	trigger::use("hendricks_leave_sniper_room", "targetname");
	
//	skipto::teleport_players( str_objective, undefined );
	loc = struct::get("hideout_obj_struct","targetname");
	
	thread objectives_set("cp_level_aquifer_hideout",loc);
	
	thread cp_mi_cairo_aquifer_interior::handle_hideout();
}

function skipto_hideout_done(str_objective, b_starting, b_direct, player)
{
	if( b_starting )
		return;
	
	loc = struct::get("hideout_obj_struct","targetname");
	thread objectives_complete("cp_level_aquifer_hideout",loc);
	
	if(isdefined(level.hendricks) && isdefined(level.hendrix_follow_obj))
	{
		objectives::show_for_target(level.hendrix_follow_obj,level.hendricks);
	}
	trigger::use("leave_hideout", "targetname");
}

function skipto_exfil_init( str_objective, b_starting )
{
	level flag::set( "hyperion_start_tree_scene");
	aquifer_util::toggle_interior_doors(false);

	level.hendricks = SpawnHendricksIfNeeded("escape_hendricks");
	
	loc = struct::get("exfil_obj_struct","targetname");
	thread objectives_set("cp_level_aquifer_exfil",loc);
	level flag::wait_till_clear( "hold_for_debug_splash" );

	level flag::wait_till( "start_exfil_igc" );

	loc = struct::get("exfil_obj_struct","targetname");
	thread objectives_complete("cp_level_aquifer_exfil",loc);
	
	struct = GetEnt("breach_scene_origin", "targetname");
	struct scene::play("cin_aqu_07_20_outro_1st_finale_main", level.hendricks);
	skipto::objective_completed(str_objective);

}	

function skipto_exfil_done (str_objective, b_starting, b_direct, player)
{
	
	if( b_starting )
		return;

//	ExitLevel(true);
	skipto::teleport_players( "breach_hangar_teleport", undefined );
	/#
	txt = [];
	txt[txt.size]=" ";
	debug::debug_info_screen(txt,6);
#/

}


function objectives_set( obj_id, list)
{
	objectives::set(obj_id,list);
}


function objectives_complete( obj_id, list)
{
	objectives::complete(obj_id,list);
}

function SpawnHendricksIfNeeded(spawner_name)
{
	if ( !IsDefined(level.hendricks) || !IsAlive(level.hendricks) )
	{
		s = GetEnt(spawner_name, "targetname");
		level.hendricks = s spawner::spawn(true);
	}
	
	return level.hendricks;
}
