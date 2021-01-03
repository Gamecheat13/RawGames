#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hacker_utility;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

function box_hacks()
{
	boxes = GetEntArray( "treasure_chest_use", "targetname" );
	
	for(i = 0; i < boxes.size; i ++)
	{
		box = boxes[i];
		
		box.box_hacks["respin"] =&init_box_respin;
		box.box_hacks["respin_respin"] =&init_box_respin_respin;
		box.box_hacks["summon_box"] =&init_summon_box;
		
		box.last_hacked_round = 0;
	}
	
	level._zombiemode_chest_joker_chance_override_func =&check_for_free_locations;
	level._zombiemode_custom_box_move_logic =&custom_box_move_logic;
	level._zombiemode_check_firesale_loc_valid_func =&custom_check_firesale_loc_valid_func;
	
	init_summon_hacks();
}

function custom_check_firesale_loc_valid_func()
{
	if(self.last_hacked_round >= level.round_number)
	{
		return false;
	}	
	
	return true;
}


function custom_box_move_logic()
{
	// If there are no recently hacked locations, just move the box as per usual.
	
	num_hacked_locs = 0;
	
	for(i = 0; i < level.chests.size; i ++)
	{
		if(level.chests[i].last_hacked_round >= level.round_number)
		{
			num_hacked_locs ++;
		}
	}
	
	if(num_hacked_locs == 0)
	{
		zm_magicbox::default_box_move_logic();
		return;
	}
	
	// There are hacked locations, so we need to do our own thing.
	
	found_loc = false;
	
	original_spot = level.chest_index;
	
	while(!found_loc)
	{
		level.chest_index++;
		if(original_spot == level.chest_index)
		{
			level.chest_index ++;
		}
		
		level.chest_index = (level.chest_index % level.chests.size);
		
		if(level.chests[level.chest_index].last_hacked_round < level.round_number)
		{
			found_loc = true;
		}
	}
}

function check_for_free_locations(chance)
{
	boxes = level.chests;
	
	stored_chance = chance;
	
	chance = -1;
	
	for(i = 0; i < boxes.size; i ++)
	{
		if(i == level.chest_index)
		{
			continue;
		}
		
		if(boxes[i].last_hacked_round < level.round_number)
		{
			chance = stored_chance;
			break;
		}
	}
	
	return chance;
}

function init_box_respin(chest, player)
{
	self thread box_respin_think(chest, player);
}

function box_respin_think(chest, player)
{
	respin_hack = SpawnStruct();
	respin_hack.origin = self.origin  + (0,0,24);
	respin_hack.radius = 48;
	respin_hack.height = 72;
	respin_hack.script_int = 600;
	respin_hack.script_float = 1.5;
	respin_hack.player = player;
	respin_hack.no_bullet_trace = true;
	respin_hack.chest = chest;
	
	hacker_util::register_pooled_hackable_struct(respin_hack,&respin_box,&hack_box_qualifier);
	
	self.weapon_model util::waittill_either("death", "kill_respin_think_thread");
	
	hacker_util::deregister_hackable_struct(respin_hack);
}

function respin_box_thread(hacker)
{
	if(isdefined(self.chest.chest_origin.weapon_model))
	{
		self.chest.chest_origin.weapon_model notify("kill_respin_think_thread");
	}
	
	self.chest.no_fly_away = true;
	
	self.chest.zbarrier notify("box_hacked_respin");
	self.chest TriggerEnable( false );
	zm_utility::play_sound_at_pos( "open_chest", self.chest.chest_origin.origin );
	zm_utility::play_sound_at_pos( "music_chest", self.chest.chest_origin.origin );
	self.chest.zbarrier thread zm_magicbox::treasure_chest_weapon_spawn(self.chest, hacker, true);
	self.chest.zbarrier waittill( "randomization_done" );
	
	self.chest.no_fly_away = undefined;
	
	if(!level flag::get("moving_chest_now"))
	{
		self.chest TriggerEnable( true );
		self.chest thread zm_magicbox::treasure_chest_timeout();
	}
}

function respin_box(hacker)
{
	self thread respin_box_thread(hacker);
}

function hack_box_qualifier(player)
{
	if(player == self.chest.chest_user && isdefined(self.chest.weapon_out))
	{
		return true;
	}
	
	return false;
}

function init_box_respin_respin(chest, player)
{
	self thread box_respin_respin_think(chest, player);
}


function box_respin_respin_think(chest, player)
{
	respin_hack = SpawnStruct();
	respin_hack.origin = self.origin + (0,0,24);
	respin_hack.radius = 48;
	respin_hack.height = 72;
	respin_hack.script_int = -950;
	respin_hack.script_float = 1.5;
	respin_hack.player = player;
	respin_hack.no_bullet_trace = true;
	respin_hack.chest = chest;
	
	hacker_util::register_pooled_hackable_struct(respin_hack,&respin_respin_box,&hack_box_qualifier);
	
	self.weapon_model util::waittill_either("death", "kill_respin_respin_think_thread");
	
	hacker_util::deregister_hackable_struct(respin_hack);
}

function respin_respin_box(hacker)
{
	
	org = self.chest.chest_origin.origin;
	
	if(isdefined(self.chest.chest_origin.weapon_model))
	{
		self.chest.chest_origin.weapon_model notify("kill_respin_respin_think_thread");
		self.chest.chest_origin.weapon_model notify("kill_weapon_movement");
		
		self.chest.chest_origin.weapon_model moveto(org + (0,0,40), 0.5);
	}
	
	if(isdefined(self.chest.chest_origin.weapon_model_dw))
	{
		self.chest.chest_origin.weapon_model_dw notify("kill_weapon_movement");
		self.chest.chest_origin.weapon_model_dw moveto(org + (0,0,40) - (3,3,3), 0.5);
	}
	
	self.chest.zbarrier notify("box_hacked_rerespin");
	
	self.chest.box_rerespun = true;
	
	self thread fake_weapon_powerup_thread(self.chest.chest_origin.weapon_model, self.chest.chest_origin.weapon_model_dw);
	
}

function fake_weapon_powerup_thread(weapon1, weapon2)
{
	weapon1 endon ("death");

	
	playfxontag (level._effect["powerup_on_solo"], weapon1, "tag_origin");
	
	playsoundatposition("zmb_spawn_powerup", weapon1.origin);
	weapon1 PlayLoopSound("zmb_spawn_powerup_loop");
	
	self thread fake_weapon_powerup_timeout(weapon1, weapon2);
	
	while (isdefined(weapon1))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = RandomInt( 360 );
		if( yaw > 300 )
		{
			yaw = 300;
		}
		else if( yaw < 60 )
		{
			yaw = 60;
		}
		yaw = weapon1.angles[1] + yaw;
		weapon1 rotateto ((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		
		if(isdefined(weapon2))
		{
			weapon2 rotateto ((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		}
		wait randomfloat (waittime - 0.1);
	}
}

function fake_weapon_powerup_timeout(weapon1, weapon2)
{
	weapon1 endon ("death");

	wait 15;

	for (i = 0; i < 40; i++)
	{
		// hide and show
		if (i % 2)
		{
			weapon1 hide();
			if(isdefined(weapon2))
			{
				weapon2 Hide();
			}
		}
		else
		{
			weapon1 show();
			if(isdefined(weapon2))
			{
				weapon2 Hide();
			}
		}

		if (i < 15)
		{
			wait 0.5;
		}
		else if (i < 25)
		{
			wait 0.25;
		}
		else
		{
			wait 0.1;
		}
	}
	
	//self.chest.chest_origin notify("weapon_grabbed");
	self.chest notify( "trigger", level ); 
	
	if(isdefined(weapon1))
	{
		weapon1 Delete();
	}
	
	if(isdefined(weapon2))
	{
		weapon2 Delete();
	}
}

function init_summon_hacks()
{
	chests = GetEntArray( "treasure_chest_use", "targetname" );
	for( i=0; i < chests.size; i++ )
	{
		chest = chests[i];
		
		chest init_summon_box(chest.hidden);
	}	
}


function init_summon_box(create)
{
	if(create)
	{
		if(isdefined(self._summon_hack_struct))
		{
			hacker_util::deregister_hackable_struct(self._summon_hack_struct);
			self._summon_hack_struct = undefined;
		}
		
		struct = SpawnStruct();
	
		struct.origin = self.chest_box.origin + (0,0,24);
		struct.radius = 48;
		struct.height = 72;
		struct.script_int = 1200;
		struct.script_float = 5;
		struct.no_bullet_trace = true;
		struct.chest = self;
	
		self._summon_hack_struct = struct;
	
		hacker_util::register_pooled_hackable_struct(struct,&summon_box,&summon_box_qualifier);
	}
	else
	{
		if(isdefined(self._summon_hack_struct))
		{
			hacker_util::deregister_hackable_struct(self._summon_hack_struct);
			self._summon_hack_struct = undefined;
		}
	}
}

function summon_box_thread(hacker)
{
	self.chest.last_hacked_round = level.round_number + RandomIntRange(2,5);
	
	hacker_util::deregister_hackable_struct(self);

	self.chest thread zm_magicbox::show_chest();

	self.chest notify("kill_chest_think");
		
	self.chest.auto_open = true;
	self.chest.no_charge = true;
	self.chest.no_fly_away = true;
	self.chest.forced_user = hacker;
	
	self.chest thread zm_magicbox::treasure_chest_think();
	
	self.chest.chest_lid waittill( "lid_closed" );
	self.chest.chest_lid waittill( "rotatedone" );
	
	self.chest.forced_user = undefined;
	self.chest.auto_open = undefined;
	self.chest.no_charge = undefined;
	self.chest.no_fly_away = undefined;
	
	self.chest thread zm_magicbox::hide_chest();
//	self.chest thread zm_magicbox::show_rubble();
}

function summon_box(hacker)
{
	self thread summon_box_thread(hacker);
	
	if( isdefined( hacker ) )
	{
		hacker thread zm_audio::create_and_play_dialog( "general", "hack_box" );
	}
}

function summon_box_qualifier(player)
{
	
	if(self.chest.last_hacked_round > level.round_number)
	{
		return false;
	}
	
	if(isdefined(self.chest.zbarrier.chest_moving) && self.chest.zbarrier.chest_moving)
	{
		return false;
	}
	
	return true;
}
