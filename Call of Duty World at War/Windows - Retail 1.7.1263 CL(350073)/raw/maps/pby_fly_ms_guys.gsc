#include maps\_utility;

#using_animtree ("generic_human");

ms_guys_init()
{
	//println("scriptprint - extra drone anims created");
	
	level.drone_anims[ "stand" ][ "idle" ]		= %drone_stand_idle;
	level.drone_anims[ "stand" ][ "run" ]			= %drone_stand_run;
	level.drone_anims[ "stand" ][ "reload" ]	= %exposed_crouch_reload;
	
	level.drone_anims[ "stand" ][ "death" ] = [];
	level.drone_anims[ "stand" ][ "death" ][0]	= %drone_stand_death;
	level.drone_anims[ "stand" ][ "death" ][1]	= %death_explosion_up10;
	level.drone_anims[ "stand" ][ "death" ][2]	= %death_explosion_back13;
	level.drone_anims[ "stand" ][ "death" ][3]	= %death_explosion_forward13;
	level.drone_anims[ "stand" ][ "death" ][4]	= %death_explosion_left11;
	level.drone_anims[ "stand" ][ "death" ][5]	= %death_explosion_right13;
	
	//-- explosions particular to pby ships
	level.drone_anims[ "stand" ][ "death" ][6]  = %ch_pby_explosion_back;
	level.drone_anims[ "stand" ][ "death" ][7]  = %ch_pby_explosion_front;
	level.drone_anims[ "stand" ][ "death" ][8]  = %ch_pby_explosion_right;
	level.drone_anims[ "stand" ][ "death" ][9]  = %ch_pby_explosion_left;
}

/*
spawn_merchant_ship_soldier(startpoint, startangles, animname, name)
{
	if(true)
	{
		return;
	}
	
	me = spawn("script_model", startpoint);
	me.angles = startangles;
	
	me character\char_jap_makpel_rifle::main();		
	me UseAnimTree(#animtree);
	me.a = spawnstruct();
	me.animname = animname;
	
	if (!isdefined(name))
	{
		me.targetname = "drone";
	}
	else
	{
		me.targetname = name;
	}

	me.targetname = "drone";
	me makeFakeAI();
	me.team = "axis";
	me.fakeDeath = true;
	me.health = 100;
	me SetCanDamage(true);
	//me.drone_run_cycle = level.drone_run_cycle["run_fast"]; //-- Find an animation for this
	//me thread maps\_drones::drones_clear_variables();
	//structarray_add(level.drones[guy.team],guy);
	//level notify ("new_drone");
		
	level thread ms_soldier_deaththread(me);
	
	return me;
}
*/

ms_soldier_deaththread()
{
	//println("scriptprint - custom death thread running");
	
	if(!IsDefined(level.drone_death_queue))
	{
		ASSERT(false, "The drone death manager has not been inited");
	}
	
	drone = self;
	damage_type = self;
	damage_ori = self;
	death_index = 0;
	
	// Wait until the drone reaches 0 health
	while( isdefined( drone ) )
	{
		drone waittill( "damage", amount, attacker, damage_dir, damage_ori, damage_type);
		if ( drone.health <= 0 )
			break;
	}
	
	println(damage_type);
	
	if(damage_type == "MOD_PROJECTILE" || damage_type == "MOD_PROJECTILE_SPLASH")
	{
		drone.special_death_fx = "drone_burst";
	}
	
	
	if(damage_type == "MOD_EXPLOSIVE")
	{
		ref_point = [];
		ref_point[0] = drone.origin + ( AnglesToForward(drone.angles) * 5 ); 	//front
		ref_point[1] = drone.origin + ( AnglesToForward(drone.angles) * -5 ); //rear
		ref_point[2] = drone.origin + ( AnglesToRight(drone.angles) * -5 ); 	//left
		ref_point[3] = drone.origin + ( AnglesToRight(drone.angles) * 5 );  	//right
		
		closest_point = ref_point[0];
		index = 0;
		
		for(i = 1 ; i < ref_point.size; i++)
		{
			if(Distance(ref_point[i], damage_ori) < Distance(closest_point, damage_ori))
			{
				closest_point = ref_point[i];
				index = i;
			}
		}
		
		//Figure out if the drone is falling off of a ship or not
		new_point = 0;
		trace = 0;
		
		switch(index) //index 0/forward, 1/back, 2/left, 3,right
		{
			case 0:
				new_point = drone.origin + (AnglesToForward(drone.angles) * 264);
				drone.angles = VectorToAngles(damage_ori - drone.origin);		
			break;
			case 1:
				new_point = drone.origin + (AnglesToForward(drone.angles) * -264);
				drone.angles = VectorToAngles(drone.origin - damage_ori);		
			break;
			case 2:
				new_point = drone.origin + (AnglesToRight(drone.angles) * -264);
				drone.angles = VectorToAngles(damage_ori - drone.origin) - (0, 90, 0);		
			break;
			case 3:
				new_point = drone.origin + (AnglesToRight(drone.angles) * 264);
				drone.angles = VectorToAngles(damage_ori - drone.origin) + (0, 90, 0);		
			break;
		}
		trace = BulletTrace(new_point, new_point - (0,0,2000), true, undefined);
		
		//-- stopped here to go to lunch, you want to check the traces vertical position and then decide which animation to play
		if(trace["position"][2] < (new_point[2] - 32))
		{
			switch(index)
			{
				case 0:
					index = 4;
				break;
				case 1:
					index = 5;
				break;
				case 2:
					index = 6;
				break;
				case 3:
					index = 7;
				break;
			}
		}
		
		//-- decide which death anim to play
		switch(index)
		{
			case 0:
				death_index = 2;	// [3]	= %death_explosion_forward13;
			break;
			case 1:
				death_index = 3;	// [2]	= %death_explosion_back13;
			break;
			case 2:
				death_index = 5; 	// [4]	= %death_explosion_left11;
			break;
			case 3:
				death_index = 4;	// [5]	= %death_explosion_right13;
			break;
			case 4:
				death_index = 6; //front
			break;
			case 5:
				death_index = 7; //back
			break;
			case 6:
				death_index = 8; //left
			break;
			case 7:
				death_index = 9; //right
			break;
		}
		
		if(IsDefined(drone.combust))
		{
			drone thread torch_ai(0.1);
		}
	}
	else
	{
		death_index = 0;
	}
		
	// Make drone die
	drone notify( "death" );
	drone stopAnimScripted();
	
	if(IsDefined(drone.special_death_fx))
	{
		drone.special_death_fx = "drone_burst";
		PlayFXOnTag(level._effect[drone.special_death_fx], drone, "J_SpineLower");
	}
	
	drone.need_notetrack = true;
	drone maps\_drone::drone_play_anim( level.drone_anims[ "stand" ][ "death"][death_index] );
	
	
	drone add_me_to_the_death_queue();
	/*
	wait 10;
	
	if ( isdefined( drone ) )
		drone delete();
	*/
}

add_me_to_the_death_queue()
{
	level.drone_death_queue[level.drone_death_queue.size] = self;
	level notify("drone_manager_process");
}

init_drone_manager()
{
	MAX_DEAD_DRONES = 10;
	level.drone_death_queue = [];
	
	while(1)
	{
		level waittill("drone_manager_process");
		
		if(level.drone_death_queue.size > MAX_DEAD_DRONES)
		{
			while( level.drone_death_queue.size > MAX_DEAD_DRONES )
			{
				removed_guy = level.drone_death_queue[0];
				new_drone_queue = [];
				
				for( i = 1 ; i < (level.drone_death_queue.size); i++)
				{
					new_drone_queue[i-1] = level.drone_death_queue[i];
				}
				
				if(IsDefined(removed_guy))
				{
					removed_guy Delete();
				}
				level.drone_death_queue = new_drone_queue;
			}
		}
		//else
		//{
			//-- we are ok on the number of dead drones
		//}
	}
}

//southwest_drones = level thread ms_soldier_run_and_rail("boat_1_door_drone_south", "boat_1_path_south_drone_west", "boat_1_southwest_rail");
ms_soldier_run_and_rail( spawner_name, path_name, cover_name, amount_of_cover)
{
	spawner = GetStruct(spawner_name, "targetname");
	path = GetStruct(path_name, "targetname");
	cover_array = [];
	
	for(i = 0; i < amount_of_cover; i++)
	{
		cover_array[i] = GetStruct(cover_name + "_" + i, "targetname");
	}
	
	drones_spawned = [];
	
	for( i = 0; i < cover_array.size; i++)
	{
		drones_spawned[i] = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , spawner);
		drones_spawned[i] maps\_drone::drone_move_to_ent(path);
		drones_spawned[i] thread ms_soldier_cover_shoot(cover_array[i], "goal");
		
		wait(1);
	}
	
	return drones_spawned;
}

ms_soldier_cover_shoot(cover_ent, notify_str)
{
	if(IsDefined(notify_str))
	{
		self waittill(notify_str);
	}
	
	self maps\_drone::drone_move_to_ent(cover_ent);
	self waittill("goal");
	
	self thread maps\_drone::drone_fire_at_target(level.plane_a);
}


ms_soldier_triple_25_idle()
{
	//-- This borrows directly from _triple25.gsc
	self endon ( "death" );
	self thread maps\_anim::anim_loop_solo( self, "fire_loop");	
}

#using_animtree( "generic_human" );

ms_soldier_triple_25_add_gunners()
{
	offset_up = 10;
	offset_right = 34;
	offset_forward = 0;
	
	//-- gunner 1 Tower
	temp = self GetTagOrigin("tag_gunner_turret1"); //Tower
	temp_angles = self GetTagAngles("tag_gunner_turret1");
	temp = temp + (AnglesToForward(temp_angles) * offset_forward) + (AnglesToRight(temp_angles) * offset_right) + (AnglesToUp(temp_angles) * offset_up);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_tower_right_pos = Spawn("script_origin", temp);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_tower_right = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , gunner_tower_right_pos);
	gunner_tower_right.animname = "triple25_gunner1";
	gunner_tower_right useAnimTree( #animtree );
	gunner_tower_right LinkTo(self, "tag_gunner_turret1");
	gunner_tower_right thread maps\_anim::anim_loop_solo( gunner_tower_right, "fire_loop");	
	gunner_tower_right thread reset_position(temp);
	
	//-- gunner 2 Tower
	temp = self GetTagOrigin("tag_gunner_turret1"); //Tower
	temp_angles = self GetTagAngles("tag_gunner_turret1");
	temp_offset = (AnglesToForward(temp_angles) * offset_forward) + (AnglesToRight(temp_angles) * offset_right * -1) + (AnglesToUp(temp_angles) * offset_up);
	temp = temp + temp_offset;
	maps\pby_fly::pby_ok_to_spawn();
	gunner_tower_left_pos = Spawn("script_origin", temp);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_tower_left = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , gunner_tower_left_pos);
	gunner_tower_left.animname = "triple25_gunner2";
	gunner_tower_left useAnimTree( #animtree );
	gunner_tower_left LinkTo(self, "tag_gunner_turret1");
	gunner_tower_left thread maps\_anim::anim_loop_solo( gunner_tower_left, "fire_loop");	
	gunner_tower_left thread reset_position(temp);
	
	//-- gunner 1 Deck
	temp = self GetTagOrigin("tag_gunner_turret2"); //Deck
	temp_angles = self GetTagAngles("tag_gunner_turret2");
	temp = temp + (AnglesToForward(temp_angles) * offset_forward) + (AnglesToRight(temp_angles) * offset_right) + (AnglesToUp(temp_angles) * offset_up);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_deck_right_pos = Spawn("script_origin", temp);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_deck_right = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , gunner_deck_right_pos);
	gunner_deck_right.animname = "triple25_gunner1";
	gunner_deck_right useAnimTree( #animtree );
	gunner_deck_right LinkTo(self, "tag_gunner_turret2");
	gunner_deck_right thread maps\_anim::anim_loop_solo( gunner_deck_right, "fire_loop");	
	gunner_deck_right thread reset_position(temp);
	
	//-- gunner 2 Deck
	temp = self GetTagOrigin("tag_gunner_turret2"); //Deck
	temp_angles = self GetTagAngles("tag_gunner_turret2");
	temp = temp + (AnglesToForward(temp_angles) * offset_forward) + (AnglesToRight(temp_angles) * offset_right * -1) + (AnglesToUp(temp_angles) * offset_up);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_deck_left_pos = Spawn("script_origin", temp);
	maps\pby_fly::pby_ok_to_spawn();
	gunner_deck_left = maps\_drone::drone_scripted_spawn( "actor_axis_jap_reg_type99rifle" , gunner_deck_left_pos);
	gunner_deck_left.animname = "triple25_gunner2";
	gunner_deck_left useAnimTree( #animtree );
	gunner_deck_left LinkTo(self, "tag_gunner_turret2");
	gunner_deck_left thread maps\_anim::anim_loop_solo( gunner_deck_left, "fire_loop");	
	gunner_deck_left thread reset_position(temp);
}

reset_position( position )
{
	self endon("death");
	
	while(1)
	{
		self.origin = position;
		wait(0.05);
	}
}

kill_all_ms_guys()
{
	drones = [];
	drones = GetEntArray("drone", "targetname");
	for(i=0; i < drones.size; i++)
	{
		if(!IsDefined(drones[i].driver))
		{
			drones[i] DoDamage( 1000, drones[i].origin);
		
			if(IsDefined(drones[i].boat))
			{
				if(!IsDefined(drones[i].script_string))
				{
					drones[i] LinkTo(level.boats[drones[i].boat], "aft_break_jnt");
				}
				else if(drones[i].script_string == "bow")
				{
					drones[i] LinkTo(level.boats[drones[i].boat], "bow_break_jnt");
				}
				else
				{
					//-- contains both conning tower and aft drones
					drones[i] LinkTo(level.boats[drones[i].boat], "aft_break_jnt");
				}
			}
		}
	}
}

delete_all_ms_guys()
{
	drones = [];
	drones = GetEntArray("drone", "targetname");
	for(i = 0; i < drones.size; i++)
	{
		if(!IsDefined(drones[i].driver))
		{
			drones[i] Delete();
		}
	}
}

// Lights the given AI on fire - borrowed from Makin
torch_ai( delay )
{
	tagArray = [];
	tagArray[tagArray.size] = "J_Wrist_RI";
	tagArray[tagArray.size] = "J_Wrist_LE";
	tagArray[tagArray.size] = "J_Elbow_LE";
	tagArray[tagArray.size] = "J_Elbow_RI";
	tagArray[tagArray.size] = "J_Knee_RI";
	tagArray[tagArray.size] = "J_Knee_LE";
	tagArray[tagArray.size] = "J_Ankle_RI";
	tagArray[tagArray.size] = "J_Ankle_LE";

	tagArray = maps\_utility::array_randomize( tagArray );
	for( i = 0; i < 3; i++ )
	{
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[i] );

		if( IsDefined( delay ) )
		{
			wait( delay );
		}
	}

	PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
}