#include maps\_utility;





flag_initialize(message, dont_clear)
{
	if (!isDefined(level.flag))
	{
		level.flag = [];
		level.flags_lock = [];
	}

	if (!IsDefined(dont_clear))
	{
		dont_clear = false;
	}

	
	if ((!IsDefined(level.flag[message])) || !dont_clear)
	{
		level.flag[message] = false;
	}

	/#
		level.flags_lock[message] = false;	
	#/
}




shake_building(duration, scale)
{
	if (!isDefined(scale))
	{
		scale = .3;
	}
	
	
	
		level.gettler_building_shake = scale;
		
		flag_set("shaking");
		

		Earthquake(scale, duration, level.player.origin, 1000 );
		level.player PlaySound("GET_Random_Rumble");
		wait (duration / 10);

		level notify("fx_falling_debris");

		
		if (IsDefined(level.destruction_chunks[level.active_floor]))
		{
			destruct_array = level.destruction_chunks[level.active_floor];
			if (IsDefined(destruct_array))
			{
				destruct_array = get_array_of_closest(level.player.origin, destruct_array, [], 3);

				for (i = 0; i < destruct_array.size; i++)
				{
					
					if (IsDefined(destruct_array[i]) && player_can_see(destruct_array[i]))
					{
						level.destruction_chunks[level.active_floor] = array_remove(level.destruction_chunks[level.active_floor], destruct_array[i]);
						trigger_destruction(destruct_array[i]);
						break;
					}
				}
			}
		}

		wait ((duration * 9) / 10);
		
		flag_clear("shaking");
		level.shake_time = GetTime();
		level.gettler_building_shake = 0;
		
	
}

trigger_destruction(obj, trig)
{
	flag = undefined;
	if (IsDefined(trig) && IsDefined(trig.script_flag))
	{
		flag = trig.script_flag;
	}

	if (IsDefined(trig))
	{
		trig waittill("trigger");
	}

	origin = obj.origin;
	level thread shake_building(1, .5);
	wait .5;
	
	
	if (!IsDefined(obj.script_fxid))
	{
		Playfx(level._effect["gettler_falling_debris01"], origin); 
	}

	
	
	
	if (IsDefined(obj.script_exploder))
	{
		exploder(obj.script_exploder);
	}

	
	radius = 70;
	if (IsDefined(obj.script_radius))
	{
		radius = obj.script_radius;
	}

	damage = 10;
	if (IsDefined(obj.script_damage))
	{
		damage = obj.script_damage;
	}

	level thread destruction_sound(origin);

	RadiusDamage(origin, radius, damage / 2, damage, level.player, "MOD_FORCE_EXPLOSION"); 

	if (IsDefined(flag))
	{
		flag_set(flag);
	}
}

destruction_sound(origin)
{
	sound_ent = Spawn("script_origin", origin);
	if (IsDefined(sound_ent))
	{
		sound_ent PlaySound("GET_wall_break", "sounddone");
		sound_ent waittill("sounddone");
		sound_ent delete();
	}
}

tilt_building(tilt, time, tilt_back, new_angles)
{
	
	
	
	
	
	
	

	

	
	flag_waitopen("tilting");
	
	flag_set("_sea_viewbob");
	flag_set("tilting");

	
	
	
	
	
	if (!IsDefined(time))
	{
		time = 10;
	}
	
	level.tilting = true;
	old_tilt = level._sea_world_rotation;
	level._sea_world_rotation = tilt;
	
	
	level thread maps\gettler_util::shake_building(time, .2);
	
	
	wait time;
	
	if (IsDefined(tilt_back) && tilt_back)
	{
		
		time = time / 3;
		level._sea_world_rotation = old_tilt;
		wait 2;
		
		level thread maps\gettler_util::shake_building(time, .2);
	}
	else if (IsDefined(new_angles))
	{
		
		time = time / 3;
		level._sea_world_rotation = new_angles;
		wait 2;
		
		level thread maps\gettler_util::shake_building(time, .2);
	}
	
	flag_clear("tilting");
	
}

tilt_building_scripted(angles, time, tilt_back, new_angles)
{
	super_tilt = flag("super_tilt");
	if (super_tilt)
	{
		maps\gettler::stop_super_tilt();
	}

	
	
	level._sea_swaytime = time;
	
	level._sea_rotate_ground_override = vector_multiply(angles, -1);
	
	level waittill("sway");
	
	level._sea_rotate_ground_override = undefined;
	level._sea_swaytime = undefined;

	
	if (super_tilt)
	{
		level thread maps\gettler::super_tilt();
	}
}





































path(start_node)
{
	self notify("stop_going_to_node");
	self endon("death");

	start = start_node.targetname;
	if (!IsDefined(start_node))
	{
		assertex(IsDefined(self.target), "can't follow ai path without a target.");
		next_node = self.target;
		start = self.target;
	}
	else
	{
		next_node = undefined;
	}

	node = start_node;
	while (IsDefined(next_node) || IsDefined(start_node))
	{
		if (!IsDefined(start_node))	
		{
			next_node_array = GetNodeArray(next_node,"targetname");
			if (next_node_array.size > 0)
			{
				node = next_node_array[RandomInt(next_node_array.size)];
			}
			else
			{
				break;
			}
		}
		else
		{
			start_node = undefined;		
		}

		
		
		
		
		
		
		
		

		self.pause_path = false;
		self SetGoalNode(node);
		self waittill("goal");

		tokens = maps\_load::create_flags_and_return_tokens(node.script_flag_true);
		Print3d(node.origin, "waiting for something");
		maps\_load::wait_for_flag(tokens);

		waittillframeend;
		while (self.pause_path)
		{
			wait .05;
		}

		node script_delay();
		if (!IsDefined(node.target))
		{
			break;
		}

		next_node = node.target;
	}

	if (IsDefined(node.script_delete) && node.script_delete)
	{
		self delete();
	}
}

gettler_player_stick()
{
	level.player.stick = Spawn("script_origin", level.player.origin);
	level.player.stick.angles = level.player.angles;
	level.player LinkTo(level.player.stick);
}

gettler_player_unstick()
{
	level.player Unlink();
	level.player.stick delete();
}







show_label(label, type, time)
{
	if (!IsDefined(label))
	{
		label = self.targetname;
	}

	if (!IsDefined(type))
	{
		type = "main";
	}

	if (!IsDefined(self.label))
	{
		self.label = [];
	}

	if (label == "none")
	{
		self hide_label(type);
	}
	else
	{
		if ((!IsDefined(self.label[type])) || (self.label[type] == "none"))	
		{
			self.label[type] = label;
			self thread t_show_label(type);
		}
		else	
		{
			self.label[type] = label;
		}
	}
	
	if (IsDefined(time))
	{
		self thread t_hide_label(type, time);
	}
}


t_show_label(type)
{
	self endon("hide_label^" + type);
	self endon("death");

	while (true)
	{
		
		color = (0, .6, .6);
		pos = self.origin;
		scale = 1.0;

		if (type != "main")
		{
			if (type == "state")
			{
				pos = self.origin + (0, 0, 64);
				color = (.5, 0, 0);
				scale = .8;
			}
			else if (type == "talk")
			{
				pos = self.origin + (0, 0, 90);
				color = (1, 1, 1);
				scale = 2;
			}
			else
			{
				assertmsg("not a valid label type.");
			}
		}

		Print3d(pos, self.label[type], color, 1, scale, 1);
		wait(.05);
	}
}

t_hide_label(type, time)
{
	self endon("death");
	wait(time);
	hide_label(type);
}




hide_label(type)
{
	if (!IsDefined(self.label))
	{
		self.label = [];
	}

	if (!IsDefined(type))
	{
		type = "main";
	}

	self notify("hide_label^" + type);
	self.label[type] = "none";
}

player_moveto(dest, moverate, stick)
{
	
	if(!isdefined(moverate))
		moverate = 200;

	gettler_player_stick();

	dist = distance(level.player.origin, dest.origin);
	movetime = dist/moverate;

	level.player.stick moveto(dest.origin, dist/moverate, .05, .05);
	level.player.stick rotateto(dest.angles, dist/moverate, .05, .05);

	wait movetime;

	if (!IsDefined(stick) || !stick)
	{
		player_unstick();
	}
}


birds()
{

	
	trigs = getentarray( "birds", "script_noteworthy" );
	for( i = 0; i < trigs.size; i++ )
	{
		trigs[i] thread birds_effect();
	}
}

birds_effect()
{
	self waittill( "trigger" );

	org = getent( self.target, "targetname" );

	playfx(level._effect["bird_flock"], org.origin );

	
}

radius_damage(org, range, max_damage, min_damage)
{
	
	
	
	
	
	
	
	
	
	
	RadiusDamage(org, range, max_damage, min_damage);
	
	
	
}

dialog(sound, say_what, talk_time)
{
	

	
	if (!IsDefined(talk_time))
	{
		talk_time = 3;
	}

	self show_label(say_what, "talk", talk_time);
	

	wait talk_time;
}

fade_to_black()
{
	level.hud_black.alpha = 0;
	level.hud_black fadeOverTime(3); 
	level.hud_black.alpha = 1;
}

fade_to_white()
{
	level.hud_white.alpha = 0;
	level.hud_white fadeOverTime(3); 
	level.hud_white.alpha = 1;
}

physics_impulse(origin, radius, delay)
{
	if (IsDefined(delay))
	{
		wait delay;
	}

	
	level thread shake_building(1, .5);
	PhysicsExplosionCylinder(origin, radius, radius / 2, .5);
}

fail_mission_on_ai_death()
{
	while( true )
	{
		bFriendlyFire = false;

		
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		
		if( !IsDefined(sAttacker) )
			continue;

		
		if( sAttacker == level.player )
		{
			bFriendlyFire = true;
		}
		else if( IsDefined( sAttacker.classname ) && ( sAttacker.classname == "script_vehicle" ) )
		{
			entOwner = sAttacker GetVehicleOwner();
			if( IsDefined( entOwner ) && ( entOwner == level.player ) )
				bFriendlyFire = true;
		}

		if( bFriendlyFire )
		{
			
			missionFailedWrapper();
		}
	}
}

force_move_ent( vOrigin )
{
	mover = Spawn( "script_origin", self.origin );
	self LinkTo( mover );
	mover MoveTo( vOrigin, 0.05 );
	wait( 0.05 );
	self Unlink();
}

attach_suit_case( strNotify )
{
	
	
	
	
	

	self Attach("p_msc_suitcase_vesper", "TAG_WEAPON_RIGHT");

	
	if( IsDefined( strNotify ) )
	{
		self waittill( strNotify );
		self Detach("p_msc_suitcase_vesper", "TAG_WEAPON_RIGHT");
	}
	
	
	
	
	
	
	

	
}

vesper_elev_anim_loop()
{
	while( IsDefined(level.vesper) )
	{
		PlayCutScene( "GBF_Vesper_Elevator_Cycle", "elev_cycle_done" );
		level waittill( "elev_cycle_done" );
	}
}

get_active_enemy()
{
	aiArray = GetAIArray( "axis" );
	
	if( aiArray.size < 1 )
	{
		return undefined;
	}
	else
	{
		iCount = RandomIntRange( 0, aiArray.size );
		return aiArray[iCount];
	}
}


vesper_elevator_dialog()
{
	if( !IsDefined(level.vesper) )
	{
		return;
	}

	
	level.vesper endon( "stop_vesper_dialogue" );

	while( IsDefined( level.vesper ) )
	{
		switch( RandomInt(14) )
		{
			case 0:
				level.vesper playsound("VESP_GettG_073B");
				break;

			case 1:
				level.vesper playsound("VESP_GettG_075A");
				break;

			case 2:
				level.vesper playsound("VESP_GettG_076A");
				break;

			case 3:
				level.vesper playsound("VESP_GettG_077A");
				break;

			case 4:
				level.vesper playsound("VESP_GettG_078A");
				break;

			case 5:
				level.vesper playsound("VESP_GettG_079A");
				break;

			case 6:
				level.vesper playsound("VESP_GettG_081A");
				break;

			case 7:
				
				
				

			case 8:
				level.vesper playsound("VESP_GettG_083A");
				break;

			case 9:
				level.vesper playsound("VESP_GettG_084A");
				break;

			case 10:
				level.vesper playsound("VESP_GettG_085A");
				break;

			case 11:
				level.vesper playsound("VESP_GettG_086A");
				break;

			case 12:
				
				

			case 13:
				level.vesper playsound("VESP_GettG_088A");
				break;
		}

		wait( RandomIntRange( 15, 45 ) );
	}
}


walk_run_walk_to_node( sNode, fTime )
{
	if( !IsDefined(self) )
	{
		return;
	}

	entNode = GetNode( sNode, "targetname" );

	self SetScriptSpeed("walk");

	self SetGoalNode( entNode );

	self thread time_to_run( fTime );

	self waittill( "goal" );

	self SetScriptSpeed("walk");
}

time_to_run( fTime )
{
	self endon( "goal" );

	wait(fTime);

	self SetScriptSpeed("Run");
}




move_escape_boat_to_end_node()
{
	

	escape_boat = GetEnt("veh_boat_vesper_escape", "targetname");
	escape_boat delete();

	end_node = GetVehicleNode("auto755", "targetname");
	escape_boat = SpawnVehicle("v_boat_motor_b", "veh_boat_vesper_escape", "motor_boat", end_node.origin, end_node.angles);
	escape_boat thread maps\gettler_load::boat_float();

	wait 1;

	if (IsDefined(level.escape_boat_thug))
	{
		level.escape_boat_thug Delete();
	}
	
	if (IsDefined(level.escape_boat_vesper))
	{
		level.escape_boat_vesper Delete();
	}
}