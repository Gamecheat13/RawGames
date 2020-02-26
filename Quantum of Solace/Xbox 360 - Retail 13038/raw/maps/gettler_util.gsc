#include maps\_utility;

//
// flag_initialize - same as flag_init in _utility but with out the assert.  Gettler needs this because it will be included into another level,
// and the gettler script will be run after _load::main(), so we won't be able to initialize flags before _load is called when it inits flags from triggers
//
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

	// If the flag doesn't exist or we don't care if it gets cleared, clear/init it
	if ((!IsDefined(level.flag[message])) || !dont_clear)
	{
		level.flag[message] = false;
	}

	/#
		level.flags_lock[message] = false;	//not sure what this is all about
	#/
}

//
// shake_building - earthquake, slow down the player, trigger destruction, etc.
//
shake_building(duration, scale)
{
	if (!isDefined(scale))
	{
		scale = .3;
	}
	
	//if (scale > level.gettler_building_shake)
	//{
		level.gettler_building_shake = scale;
		
		flag_set("shaking");
		//level._sea_scale = scale;

		Earthquake(scale, duration, level.player.origin, 3000 );
		level.player PlaySound("GET_Random_Rumble");
		wait (duration / 10);

		level notify("fx_falling_debris");

		// trigger destruction exploder //
		if (IsDefined(level.destruction_chunks[level.active_floor]))
		{
			destruct_array = level.destruction_chunks[level.active_floor];
			if (IsDefined(destruct_array))
			{
				destruct_array = get_array_of_closest(level.player.origin, destruct_array, [], 3);

				for (i = 0; i < destruct_array.size; i++)
				{
					// explode the first one we can see, and then remove it from the array
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
		//level._sea_scale = .2;
	//}
}

trigger_destruction(obj, trig)
{
	assertex(IsDefined(obj), "trying to trigger undefined destruction piece.");

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
	
	// Play FX
	if (!IsDefined(obj.script_fxid))
	{
		Playfx(level._effect["gettler_falling_debris01"], origin); // remove and put on individual pieces
	}

	// Play Sound
	//obj PlaySound("GET_destruction");
	// Explode
	if (IsDefined(obj.script_exploder))
	{
		exploder(obj.script_exploder);
	}

	// Trigger dyn ents to fall
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

	RadiusDamage(origin, radius, damage / 2, damage, level.player, "MOD_FORCE_EXPLOSION"); // this should trigger the dyn_ents to fall

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
	//test
	//tilt = vector_multiply(tilt, 5);
	//!test
	//if (!IsDefined(level.tilt_building_init))
	//{
	//	level thread tilt_building_loop();
	//}

	//level._sea_physbob_scale = 1.8;

	level endon("raising_water");	// raising water tilt has priority

	//flag_waitopen("super_tilt");
	flag_waitopen("tilting");
	//flag_clear("_sea_viewbob");
	flag_set("_sea_viewbob");
	flag_set("tilting");

	//level.ground = GetEnt("ground", "targetname");
	//wait .05;
	//level.player PlayerSetGroundReferenceEnt(level.ground);
	wait .05;
	level notify("new_tilt");	
	
	if (!IsDefined(time))
	{
		time = 10;
	}
	
	level.tilting = true;
	old_tilt = level._sea_world_rotation;
	level._sea_world_rotation = tilt;
	
	//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
	level thread maps\gettler_util::shake_building(time, .2);
	
	//level.ground waittill("rotatedone");
	wait time;
	
	if (IsDefined(tilt_back) && tilt_back)
	{
		//iPrintLnBold("tilting back");
		time = time / 3;
		level._sea_world_rotation = old_tilt;
		wait 2;
		//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
		level thread maps\gettler_util::shake_building(time, .2);
	}
	else if (IsDefined(new_angles))
	{
		//iPrintLnBold("tilting to new angles");
		time = time / 3;
		level._sea_world_rotation = new_angles;
		wait 2;
		//level.ground RotateTo(level._sea_world_rotation, time, time * .4, time * .2);
		level thread maps\gettler_util::shake_building(time, .2);
	}
	
	flag_clear("tilting");
	//flag_set("_sea_viewbob");
}

tilt_building_scripted(angles, time, tilt_back, new_angles)
{
	//super_tilt = flag("super_tilt");
	//if (super_tilt)
	//{
	//	maps\gettler::stop_super_tilt();
	//}

	//iPrintLnBold("scripted tilting");
	//level._sea_swaytime = time;
	//level._sea_rotate_ground_override = vector_multiply(angles, -1);
	////wait time;
	//level waittill("sway");
	////level._sea_ground RotateTo(angles, time, time * .5, time * .5);
	//level._sea_rotate_ground_override = undefined;
	//level._sea_swaytime = undefined;

	//level thread tilt_building(angles, time, tilt_back);

	//flag_waitopen("tilting");
	//if (super_tilt)
	//{
	//	level thread maps\gettler::super_tilt();
	//}
}

//tilt_building_loop()
//{
//	level.tilt_building_init = true;
//
//	// debug
//	test_org1 = level._sea_org.origin + (0, 0, 300);
//	test_org2 = level._sea_org.origin + (0, 0, 270);
//	// !debug
//
//	while (true)
//	{
//		dir = vector_multiply(AnglesToUp(level.ground.angles), -1);
//		phys_changeDefaultGravityDir(dir);
//
//
//		// debug
//		gravity_angles = VectorToAngles(dir);
//		gravity_vector = VectorNormalize(dir);
//		Line(test_org1, test_org1 + vector_multiply(gravity_vector, 100), (1.0, 0.0, 0.0), false);
//		Print3d(test_org2, "(" + gravity_angles[0] + "," + gravity_angles[1] + "," + gravity_angles[2] + ")", (1.0, 0.0, 0.0));
//
//		//ground_vector = VectorNormalize(AnglesToForward(level.ground.angles));
//		ground_angles = level.ground.angles;
//		ground_vector = VectorNormalize(AnglesToForward(level.ground.angles));
//		Line(test_org1, test_org1 + vector_multiply(ground_vector, 100), (0.0, 1.0, 0.0), false);
//		Print3d(test_org1, "(" + ground_angles[0] + "," + ground_angles[1] + "," + ground_angles[2] + ")", (0.0, 1.0, 0.0));
//		// !debug
//
//		wait .05;
//	}
//}

//
// path
//

path(start_node)
{
	self notify("stop_going_to_node");// cancel the ugly stuff in _spawner
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
		if (!IsDefined(start_node))	// if we don't have a start node.
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
			start_node = undefined;		// undefine start node because we're done with it.
		}

		//if (IsDefined(node.radius) && (node.radius != 0))
		//{
		//	self.goalradius = node.radius;	// new AI doesn't use this like we used to
		//}
		//else if (IsDefined(self.script_radius))
		//{
		//	self.goalradius = self.script_radius;	// new AI doesn't use this like we used to
		//}

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

//	FUNCTION - show_label -
//	Displays a label in 3d space for an entity.
//
//	arguments:	label	(string) - The label to be displayed (optional)
//							type	(string) - The label type: main, state, etc. (optional)

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
		if ((!IsDefined(self.label[type])) || (self.label[type] == "none"))	// set to "none" in hide_label(), need to start thread again, or this is the first time showing a label of this type.
		{
			self.label[type] = label;
			self thread t_show_label(type);
		}
		else	// thread is already going, just set the label
		{
			self.label[type] = label;
		}
	}
	
	if (IsDefined(time))
	{
		self thread t_hide_label(type, time);
	}
}

//	internal function
t_show_label(type)
{
	self endon("hide_label^" + type);
	self endon("death");

	while (true)
	{
		//type == "main"
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

//	FUNCTION - hide_label -
//	Stop displaying a label shown by using show_label.

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
	//moverate = units/persecond
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

// function for effects, stolen from JChiang
birds()
{

	//grab all bird effect triggers
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

	//sound would be nice
}

radius_damage(org, range, max_damage, min_damage)
{
	//ai = GetAIArray("axis");
	//for (i = 0; i < ai.size; i++)
	//{
	//	if (Distance(ai[i].origin, org) <= range)
	//	{
	//		ai[i] DoDamage(1000, ai[i].origin);
	//		ai[i] StartRagDoll();
	//	}
	//}
	
	RadiusDamage(org, range, max_damage, min_damage);
	
	//PhysicsJolt(org, range + 100, range, max_damage / 150);
	//PhysicsExplosionSphere(org, range + 100, range, max_damage / 150);
}

dialog(sound, say_what, talk_time)
{
	// PlaySound(sound);

	//TODO: temp print out of dialog before we get the sound files - remove later ////////////////////
	if (!IsDefined(talk_time))
	{
		talk_time = 3;
	}

	self show_label(say_what, "talk", talk_time);
	//////////////////////////////////////////////////////////////////////////////////////////////////

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

	//iPrintLnBold("physics impulse");
	level thread shake_building(1, .5);
	wait .5;
	PhysicsExplosionCylinder(origin, radius, radius / 2, 1);
}

fail_mission_on_ai_death()
{
	while( true )
	{
		bFriendlyFire = false;

		// wait for damage
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, iType, sModelName, sAttachTag, sTagName ); 

		// if we dont know who the attacker is we can't do much, so ignore it. This is seldom to happen, but not impossible
		if( !IsDefined(sAttacker) )
			continue;

		// check to see if the death was caused by the player or the players turret
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
			// call mission fail
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
	// spawn suitcase
	//entSuitcase = Spawn( "script_model", self GetTagOrigin( "tag_weapon_right" ) );
	//entSuitcase.angles = self gettagangles( "tag_weapon_right" );
	//entSuitcase SetModel( "p_msc_suitcase_vesper" );
	//entSuitcase LinkTo( self, "tag_weapon_right" );

	self Attach("p_msc_suitcase_vesper", "TAG_WEAPON_RIGHT");

	// wait to del suitcase
	if( IsDefined( strNotify ) )
	{
		self waittill( strNotify );
		self Detach("p_msc_suitcase_vesper", "TAG_WEAPON_RIGHT");
	}
	//else
	//{
	//	while( IsDefined( self ) )
	//	{
	//		wait( 0.25 );
	//	}
	//}

	//entSuitcase Delete();
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
	
	if( aiArray.size < 2 )	// changed to 2.  this is used to grab an AI for battle chatter, so there should be at least 2 or they talk to themselves
	{
		return undefined;
	}
	else
	{
		iCount = RandomIntRange( 0, aiArray.size );
		return aiArray[iCount];
	}
}

// vesper dialog in gettler building
vesper_elevator_dialog()
{
	if( !IsDefined(level.vesper) )
	{
		return;
	}

	level.vesper.playing_elevator_dialog = true;

	// set endon condition
	level.vesper endon( "stop_vesper_dialogue" );

	wait 2;
	while( IsDefined( level.vesper ) )
	{
		switch( RandomInt(11) )
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
				level.vesper playsound("VESP_GettG_083A");
				break;

			case 8:
				level.vesper playsound("VESP_GettG_084A");
				break;

			case 9:
				level.vesper playsound("VESP_GettG_085A");
				break;

			case 10:
				level.vesper playsound("VESP_GettG_088A");
				break;
		}

		wait( RandomIntRange( 15, 45 ) );
	}
}

// walk, run, and walk to node
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

	self waittill_notify_or_timeout("run_now", fTime);
	//wait(fTime);

	self SetScriptSpeed("Run");
}

// this function deletes the escape boat and spawns a new one at the end node
// Its done this way because the boat is animated instead of actually using the vehicle path
// also used for skipto to position the boat
move_escape_boat_to_end_node()
{
	//flag_wait("escape_boat_setup");

	escape_boat = GetEnt("veh_boat_vesper_escape", "targetname");
	escape_boat delete();

	end_node = GetVehicleNode("auto755", "targetname");
	//escape_boat = SpawnVehicle("v_boat_motor_b", "veh_boat_vesper_escape", "motor_boat", end_node.origin, end_node.angles);
	escape_boat = Spawn("script_model", end_node.origin);
	escape_boat SetModel("v_boat_motor_b");
	escape_boat.angles = end_node.angles;
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