/* zombie_moon_sq.csc
 *
 * Purpose : 	Client side sidequest logic for zombie_moon.
 *		
 * 
 * Author : 	Dan L
 * 
 */

#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_weapons;


rocket_test()
{
	return;
}

dte_watcher()
{
	level waittill("dte");
	
	level._dte_done = true;
	
	for(lcn = 0; lcn < level._ctt_num_players; lcn ++)
	{
		//T6todo self thread clientscripts\mp\zombies\_zm::zombie_vision_set_apply( level._dte_vision_set, level._dte_vision_set_priority, 0.1, lcn);
	}
	
	wait( 3.0 );
	
	for(lcn = 0; lcn < level._ctt_num_players; lcn ++)
	{
		//T6todo self thread clientscripts\mp\zombies\_zm::zombie_vision_set_remove( level._dte_vision_set, 6.0, lcn );	
	}
	
	waitrealtime(5.9);
	
	for(i = 0; i < getlocalplayers().size; i ++)
	{
		player = getlocalplayers()[i];
		
		if(!IsDefined(player._previous_vision))
		{
			player._previous_vision = "zme";
		}
		
		player clientscripts\mp\zm_moon_fx::moon_vision_set( "dte", player._previous_vision, i, 1.0);
	}
}

ctt_cleanup()
{
	
	waitforallclients();
	level._ctt_num_players = getlocalplayers().size;
		
	level._ctt_targets = [];

	while(1)
	{
		level waittill("ctto");
		level._ctt_targets = [];
	}
}

dest_debug(dest)
{
	while(1)
	{
		Print3D(dest, "+", (255,0,0), 30);
		wait(1);
	}	
}

vision_wobble()
{
	SetDvarfloat("r_poisonFX_debug_amount", 0);
	SetDvar("r_poisonFX_debug_enable", 1);
	SetDvarfloat("r_poisonFX_pulse", 2);
	SetDvarfloat("r_poisonFX_warpX", -.3);
	SetDvarfloat("r_poisonFX_warpY", .15);
	SetDvarfloat("r_poisonFX_dvisionA", 0);
	SetDvarfloat("r_poisonFX_dvisionX", 0);
	SetDvarfloat("r_poisonFX_dvisionY", 0);
	SetDvarfloat("r_poisonFX_blurMin", 0);
	SetDvarfloat("r_poisonFX_blurMax", 3);

	delta = 0.064;
	amount = 1;
	SetDvarfloat("r_poisonFX_debug_amount", amount);
	
	waitrealtime(3);
	
	while(amount > 0)
	{
		amount = Max(amount  - delta, 0);
		
		SetDvarfloat("r_poisonFX_debug_amount", amount);
		wait(0.016);
	}
	
	SetDvarfloat("r_poisonFX_debug_amount", 0);
	SetDvar("r_poisonFX_debug_enable", 0);		
}

soul_swap(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	
	if(IsDefined(newEnt) && newEnt)
	{
		return;
	}
	
	if(!set)
	{
		return;
	}	
	
	if(level._ctt_num_players == 1)	// Non split screen, only.
	{
		level thread vision_wobble();
	}
	
	for(i = 0; i < level._ctt_num_players; i ++)
	{
		e = spawn(i, self.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		
		//GS soul release sound -- IF statement per Laufer's instructions
		if (i == 0)
		{
			e playsound (0, "evt_soul_release");
		}
		
		e thread ctt_trail_runner(i, "soul_swap_trail", level._sam.origin + (0,0,24));			

		e = spawn(i, level._sam.origin + (0,0,24), "script_model");
		e SetModel("tag_origin");
		
		//GS soul release sound -- IF statement per Laufer's instructions
		if (i == 0)
		{
			e playsound (0, "evt_soul_release");
		}
		
		e thread ctt_trail_runner(i, "soul_swap_trail", self.origin + (0,0,24));			

	}
	
}

ctt_trail_runner(localClientNum, fx_name, dest)
{
	//level thread dest_debug(dest);
	PlayFXOnTag( localClientNum, level._effect[ fx_name ], self, "tag_origin" );
	
	self MoveTo(dest, 0.5);
	self waittill("movedone");
	
	//gs adding sound of soul hitting ceiling
	playsound (0, "evt_soul_impact" , dest);
	self Delete();
	
}

zombie_release_soul(localClientNum, set, newEnt)
{
	if(localClientNum != 0)
	{
		return;
	}
	
	closest = undefined;
	min_dist = 9999 * 9999;
	
	for(i = 0; i < level._ctt_targets.size; i ++)
	{
		dist = DistanceSquared(self.origin, level._ctt_targets[i].origin);
		if( dist < min_dist)
		{
			min_dist = dist;
			closest = level._ctt_targets[i];
		}
	}
	
	if(IsDefined(closest))
	{
		PrintLn("Zap from " + self.origin + " to " + closest.origin);
		for(i = 0; i < level._ctt_num_players; i ++)
		{
			e = spawn(i, self.origin + (0,0,24), "script_model");
			e SetModel("tag_origin");
			
			//GS soul release sound -- IF statement per Laufer's instructions
			if (i == 0)
			{
				e playsound (0, "evt_soul_release");
			}
			
			e thread ctt_trail_runner(i, "fx_weak_sauce_trail", closest.origin - (0,0,12));			
		}
	}
	else
	{
		PrintLn("Want to zap - but nothing close.");
	}
	
}

build_ctt_targets(tank_names, second_names)
{
	ret_array = [];
	
	tanks = getstructarray(tank_names, "targetname");
	
	PrintLn("*** build_ctt_targets");
	
	for(i = 0; i < tanks.size; i ++)
	{
		tank = tanks[i];
		capacitor = getstruct(tank.target, "targetname");

		ret_array[ret_array.size] = capacitor;
	}
	
	if(IsDefined(second_names))
	{
		tanks = getstructarray(second_names, "targetname");

		for(i = 0; i < tanks.size; i ++)
		{
			tank = tanks[i];
			capacitor = getstruct(tank.target, "targetname");
	
			ret_array[ret_array.size] = capacitor;
		}
	}
	
	return(ret_array);
}

cp_init()
{
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("cp", lcn);
	}
	
	targs = getstructarray("sq_cp_final", "targetname");
	
	for(i = 0; i < targs.size; i ++)
	{
		targ = targs[i];
		
		for(j = 0; j < level._ctt_num_players; j ++)
		{
			e = spawn(j, targ.origin, "script_model");
			e SetModel(targ.model);
			if(IsDefined(targ.angles))
			{
				e.angles = targ.angles;
			}
			e playsound( 0, "evt_clank" );
		}
	}
}

wp_init()
{
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("wp", lcn);
	}
	
	targ = getstruct("sq_wire_final", "targetname");
	
	for(j = 0; j < level._ctt_num_players; j ++)
	{
		e = spawn(j, targ.origin, "script_model");
		e SetModel(targ.model);
		e playsound( 0, "evt_start_old_computer" );
		if(IsDefined(targ.angles))
		{
			e.angles = targ.angles;
		}
	}
}

sam_rise_and_bob(struct)
{
	endpos = getstruct(struct.target, "targetname");
	
	self MoveTo(endpos.origin, 3.0);
	
	self waittill("movedone");
	
	start_z = self.origin;
	
	amplitude = 7;
	frequency = 75;
	
	t = 0.0;
	
	level._sam = self;
	
	while(1)
	{
		normalized_wave_height = Sin(frequency * t);

		wave_height_z = amplitude * normalized_wave_height;

		self.origin = start_z + (0, 0, wave_height_z);

		t += 0.016;
		wait(0.016);
	}
	
}

sam_init()
{
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("sm", lcn);
	}
	
	targ = getstruct("sq_sam", "targetname");
	
	for(j = 0; j < level._ctt_num_players; j ++)
	{
		e = spawn(j, targ.origin, "script_model");
		e SetModel(targ.model);
		if(IsDefined(targ.angles))
		{
			e.angles = targ.angles;
		}
		
		playfx( j, level._effect["lght_marker_flare"], targ.origin);
		
		e thread sam_rise_and_bob(targ);
		e playloopsound( "evt_samantha_reveal_loop", 1 );
	}
}

bob_vg()
{

	self endon("death");
	
	start_z = self.origin;
	
	amplitude = 2;
	frequency = 100;
	
	t = 0.0;
	
	while(1)
	{
		normalized_wave_height = Sin(frequency * t);

		wave_height_z = amplitude * normalized_wave_height;

		self.origin = start_z + (0, 0, wave_height_z);

		t += 0.016;
		wait(0.016);
	}
	
}



vg_init()
{
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("vg", lcn);
	}
	
	targ = getstruct("sq_charge_vg_pos", "targetname");
	
	ents = [];
	
	for(j = 0; j < level._ctt_num_players; j ++)
	{
		e = spawn(j, targ.origin, "script_model");
		e SetModel(targ.model);
		if(IsDefined(targ.angles))
		{
			e.angles = targ.angles;
		}
		
		e thread bob_vg();
		
		ents[ents.size] = e;
	}
	
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("vg", lcn);
	}

	// Play charge FX on ents
	
	for(i = 0; i < ents.size; i ++)
	{
		PlayFXOnTag(i, level._effect["vrill_glow"], ents[i], "tag_origin");
	}
	
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("vg", lcn);
	}

	// Delete Ents

	for(j = 0; j < ents.size; j ++)
	{
		ents[j] Delete();
	}

	ents = [];

	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("vg", lcn);
	}


	// Place VG in final place in plinth, and play fx.	

	targ = getstruct("sq_vg_final", "targetname");
	
	ents = [];
	
	for(j = 0; j < level._ctt_num_players; j ++)
	{
		e = spawn(j, targ.origin, "script_model");
		e SetModel(targ.model);
		if(IsDefined(targ.angles))
		{
			e.angles = targ.angles;
		}
		
		ents[ents.size] = e;
	}

	for(i = 0; i < ents.size; i ++)
	{
		PlayFXOnTag(i, level._effect["vrill_glow"], ents[i], "tag_origin");
	}

	level._override_eye_fx = "blue_eyes";
	
}

ctt1_init()
{
	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("ctt1", lcn);
	}
	
	level._ctt_targets = build_ctt_targets("sq_first_tank");
}

ctt2_init()
{

	lcn = -1;
	
	while(lcn != 0)
	{
		level waittill("ctt2", lcn);
	}

	level._ctt_targets = build_ctt_targets("sq_second_tank", "sq_first_tank");
	
}

sr_rumble()
{
	level waittill("p_r");	
	level thread do_sr_rumble();
}

do_sr_rumble()
{
	level endon("s_r");
	dist = 750*750;	
	
	struct = getstruct("pyramid_walls_retract", "targetname");
	
	while(1)
	{
	
		for(i=0;i<level.localPlayers.size;i++)
		{
			player = getlocalplayers()[i];
			
			if(!isDefined(player))
			{
				continue;
			}
			
			if(distancesquared(struct.origin,player.origin) < dist)
			{
				player playrumbleonentity(i,"slide_rumble");
			}
		}
		wait(randomfloatrange(.05,.15));
	}
}
			
			
			
sam_vo_rumble()
{
	while(1)
	{
		level waittill("st1",lcn);	
		if( IsDefined( lcn ) && lcn != 0 )
		{
			continue;
		}
		level thread do_sam_vo_rumble();
	}
}

do_sam_vo_rumble()
{
	level endon("sp1");
		
	while(1)
	{
	
		for(i=0;i<level.localPlayers.size;i++)
		{
			player = getlocalplayers()[i];
			
			if(!isDefined(player))
			{
				continue;
			}
			
			player earthquake(randomfloatrange(.2,.25),5,player.origin,100);
			player playrumbleonentity(i,"slide_rumble");

		}
		wait(randomfloatrange(.1,.15));
	}
}



r_r()
{

	level waittill("R_R");	

	level thread do_rr_rumble();
	wait(4.5);
	level notify("_stop_rr");

}

do_rr_rumble()
{
	level endon("_stop_rr");
		
	while(1)
	{
	
		for(i=0;i<level.localPlayers.size;i++)
		{
			player = getlocalplayers()[i];
			
			if(!isDefined(player))
			{
				continue;
			}
			
			player earthquake(randomfloatrange(.15,.2),5,player.origin,100);
			player playrumbleonentity(i,"slide_rumble");

		}
		wait(randomfloatrange(.1,.15));
	}
}

r_l()
{

	level waittill("R_L");	

	level thread do_rl_rumble();
	wait(6);
	level notify("_stop_rl");

}

do_rl_rumble()
{
	level endon("_stop_rl");
		
	while(1)
	{
	
		for(i=0;i<level.localPlayers.size;i++)
		{
			player = getlocalplayers()[i];
			
			if(!isDefined(player))
			{
				continue;
			}
			
			player earthquake(randomfloatrange(.26,.31),5,player.origin,100);
			player playrumbleonentity(i,"damage_light");

		}
		wait(randomfloatrange(.1,.15));
	}
}


d_e()
{

	level waittill("dte");	
	wait(3.5);
	level thread do_de_rumble();
	wait(4);
	level notify("_stop_de");

}

do_de_rumble()
{
	level endon("_stop_de");
	
	for(i=0;i<level.localPlayers.size;i++)
	{
		player = getlocalplayers()[i];
		
		if(!isDefined(player))
		{
			continue;
		}
		
		player earthquake(randomfloatrange(.4,.45),5,player.origin,100);
		player playrumbleonentity(i,"damage_heavy");
	}
	
	wait(.2);
	
	while(1)
	{
	
		for(i=0;i<level.localPlayers.size;i++)
		{
			player = getlocalplayers()[i];
			
			if(!isDefined(player))
			{
				continue;
			}
			
			player earthquake(randomfloatrange(.35,.4),5,player.origin,100);
			player playrumbleonentity(i,"damage_light");

		}
		wait(randomfloatrange(.1,.15));
	}
}