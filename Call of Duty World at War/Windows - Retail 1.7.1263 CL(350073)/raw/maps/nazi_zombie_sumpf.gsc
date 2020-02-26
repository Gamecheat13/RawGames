#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_music;
#include maps\nazi_zombie_sumpf_perks;
#include maps\nazi_zombie_sumpf_zone_management;
#include maps\nazi_zombie_sumpf_magic_box;
#include maps\nazi_zombie_sumpf_trap_pendulum;
//#include maps\nazi_zombie_sumpf_trap_electric;
//#include maps\nazi_zombie_sumpf_trap_propeller;
//#include maps\nazi_zombie_sumpf_trap_barrel;
#include maps\nazi_zombie_sumpf_bouncing_betties;
#include maps\nazi_zombie_sumpf_zipline;
#include maps\nazi_zombie_sumpf_bridge;
//#include maps\nazi_zombie_sumpf_ammo_box;
#include maps\nazi_zombie_sumpf_blockers;
#include maps\nazi_zombie_sumpf_trap_perk_electric;

main()
{
	// make sure we randomize things in the map once
	level.randomize_perks = false;
	
	// JMA - used to modify the percentages of pulls of ray gun and tesla gun in magic box
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = false;
	
	//Needs to be first for CreateFX
	maps\nazi_zombie_sumpf_fx::main();
	
	// enable for dog rounds
	level.dogs_enabled = true;

	// enable for zombie risers within active player zones
	level.zombie_rise_spawners = [];
	
	// JV contains zombies allowed to be on fire
	level.burning_zombies = [];
	
	// JV volume and bridge for bridge riser blocker
	//level.bridgeriser = undefined;
	//level.brVolume = undefined;

	level.use_zombie_heroes = true;
		
	level thread maps\_callbacksetup::SetupCallbacks();
	
	maps\_zombiemode_weapons::add_zombie_weapon( "mine_bouncing_betty",&"ZOMBIE_WEAPON_SATCHEL_2000", 2000 );		
	maps\_zombiemode_weapons::add_zombie_weapon( "ptrs41_zombie", 						&"ZOMBIE_WEAPON_PTRS41_750", 				750,	"vox_sniper", 5);	
	
	//precachestring(&"ZOMBIE_BETTY_ALREADY_PURCHASED");
	precachestring(&"ZOMBIE_BETTY_HOWTO");
//	precachestring(&"ZOMBIE_AMMO_BOX");
	
	//ESM - red and green lights for the traps
	precachemodel("zombie_zapper_cagelight_red");
	precachemodel("zombie_zapper_cagelight_green");
	precacheshellshock("electrocution");
	
	//JV - shellshock for player zipline damage
	precacheshellshock("death");

	// If you want to modify/add to the weapons table, please copy over the _zombiemode_weapons init_weapons() and paste it here.
	// I recommend putting it in it's own function...
	// If not a MOD, you may need to provide new localized strings to reflect the proper cost.	
	include_weapons();
	include_powerups();

	maps\_zombiemode::main();
   maps\nazi_zombie_sumpf_blockers::init();
	
	//init_sounds();
	init_zombie_sumpf();
	
	level thread toilet_useage();
	level thread radio_one();
	level thread radio_two();
	level thread radio_three();
	level thread radio_eggs();
	level thread battle_radio();
	level thread whisper_radio();
	level thread meteor_trigger();
	level thread book_useage();
	// JMA - make sure tesla gun gets added into magic box after round 5
//	maps\_zombiemode_weapons::add_limited_weapon( "tesla_gun", 0);
	
//	level thread add_tesla_gun();
	
	players = get_players(); 
	
	//initialize killstreak dialog	
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread player_killstreak_timer();
		
		//initialize zombie behind vox 
		players[i] thread player_zombie_awareness();
	}		

}
add_tesla_gun()
{
	while(1)
	{
		level waittill( "between_round_over" );
		if(level.round_number >= 5)
		{
			maps\_zombiemode_weapons::add_limited_weapon( "tesla_gun", 1);
			break;	
		}
	}
}




// Include the weapons that are only inr your level so that the cost/hints are accurate
// Also adds these weapons to the random treasure chest.
include_weapons()
{
	// Pistols
	include_weapon( "zombie_colt" );
	include_weapon( "sw_357" );
	
	// Semi Auto
	include_weapon( "zombie_m1carbine" );
	include_weapon( "zombie_m1garand" );
	include_weapon( "zombie_gewehr43" );
	//include_weapon( "kar98k" );	// replaced with type99_rifle
	include_weapon( "zombie_type99_rifle" );

	// Full Auto
	include_weapon( "zombie_stg44" );
	include_weapon( "zombie_thompson" );
	include_weapon( "zombie_mp40" );
	include_weapon( "zombie_type100_smg" );

	// Bolt Action
	//include_weapon( "springfield" );	// replaced with type99_rifle

	// Scoped
	include_weapon( "ptrs41_zombie" );
	//include_weapon( "kar98k_scoped_zombie" );	// replaced with type99_rifle_scoped
	//include_weapon( "type99_rifle_scoped_zombie" );	//
		
	// Grenade
	include_weapon( "molotov" );
	include_weapon( "stielhandgranate" );

	// Grenade Launcher	
	include_weapon( "m1garand_gl_zombie" );
	include_weapon( "m7_launcher_zombie" );
	
	// Flamethrower
	include_weapon( "m2_flamethrower_zombie" );
	
	// Shotgun
	include_weapon( "zombie_doublebarrel" );
	include_weapon( "zombie_doublebarrel_sawed" );
	include_weapon( "zombie_shotgun" );

	// Heavy MG
	include_weapon( "zombie_bar" );
	include_weapon( "zombie_30cal" );
	include_weapon( "zombie_fg42" );
	include_weapon( "zombie_mg42" );
	include_weapon( "zombie_ppsh" );
	
	// Rocket Launcher
	include_weapon( "panzerschrek_zombie" );

	// Special
	include_weapon( "ray_gun" );
	include_weapon( "tesla_gun" );
	
	//bouncing betties
	include_weapon("mine_bouncing_betty");
	
	// limited weapons
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_colt", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_type99_rifle", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_gewehr43", 0 );
	maps\_zombiemode_weapons::add_limited_weapon( "zombie_m1garand", 0 );
	
	
}

include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
}

include_weapon( weapon_name )
{
	maps\_zombiemode_weapons::include_zombie_weapon( weapon_name );
}

include_powerup( powerup_name )
{
	maps\_zombiemode_powerups::include_zombie_powerup( powerup_name );
}
	
spawn_initial_outside_zombies( name )
{
	// don't spawn in zombies in dog rounds
	if(flag("dog_round"))
		return;
		
	// make sure we spawn zombies only during the round and not between them
	while(get_enemy_count() == 0)
	{
		wait(1);
	}

	spawn_points = [];			
	spawn_points = GetEntArray(name,"targetname");
	
   for( i = 0; i < spawn_points.size; i++)
   {
		ai = spawn_zombie( spawn_points[i] );
		
		// JMA - make sure spawn_zombie doesn't fail
		if( IsDefined( ai ) )
		{
			ai maps\_zombiemode_spawner::zombie_setup_attack_properties();
			ai thread maps\_zombiemode_spawner::find_flesh();
			wait_network_frame();
		}
	}
}	

activate_door_flags(door, key)
{
     purchase_trigs = getEntArray(door, key);

     for( i = 0; i < purchase_trigs.size; i++)
     {
          if( !isDefined( level.flag[purchase_trigs[i].script_flag]))
          {
               flag_init(purchase_trigs[i].script_flag);
          }          
     }     
}

init_zombie_sumpf()
{
	//activate the initial exterior goals for the center bulding
	level.exterior_goals = getstructarray("exterior_goal","targetname");	
	
	for(i=0;i<level.exterior_goals.size;i++)
	{
		level.exterior_goals[i].is_active = 1;
	}

	// Setup the magic box
	thread maps\nazi_zombie_sumpf_magic_box::magic_box_init();	
	
	//managed zones are areas in the map that have associated spawners/goals that are turned on/off 
	//depending on where the players are in the map
	maps\nazi_zombie_sumpf_zone_management::activate_building_zones("center_building_upstairs","targetname");	
	
	// combining upstairs and downstairs into one zone
	level thread maps\nazi_zombie_sumpf_zone_management::combine_center_building_zones();
	
	// JMA - keep track of when the weapon box moves
	level thread maps\nazi_zombie_sumpf_magic_box::magic_box_tracker();		
	
	//ESM - new electricity traps
	level thread maps\nazi_zombie_sumpf_trap_perk_electric::init_elec_trap_trigs();
	
	// JMA - setup zipline deactivated trigger
	zipHintDeactivated = getent("zipline_deactivated_hint_trigger", "targetname");
	zipHintDeactivated sethintstring(&"ZOMBIE_ZIPLINE_DEACTIVATED");
	zipHintDeactivated SetCursorHint("HINT_NOICON");
	
	// JMA - setup log trap clear debris hint string
	penBuyTrigger = getentarray("pendulum_buy_trigger","targetname");
	
	for(i = 0; i < penBuyTrigger.size; i++)
	{		
		penBuyTrigger[i] sethintstring( &"ZOMBIE_CLEAR_DEBRIS" );
		penBuyTrigger[i] setCursorHint( "HINT_NOICON" );
	}
	
	//turning on the lights for the pen trap
	level thread maps\nazi_zombie_sumpf::turnLightRed("pendulum_light");	
	
	// set up the hanging dead guy in the attic
	//level thread hanging_dead_guy();
}


//ESM - added for green light/red light functionality for traps
turnLightGreen(name)
{
	zapper_lights = getentarray(name,"targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	
		if (isDefined(zapper_lights[i].target))
		{
			old_light_effect = getent(zapper_lights[i].target, "targetname");
			light_effect = spawn("script_model",old_light_effect.origin);
			//light_effect = spawn("script_model",zapper_lights[i].origin);
			light_effect setmodel("tag_origin");	
			light_effect.angles = (0,270,0);
			light_effect.targetname = "effect_" + name + i;
			old_light_effect delete();
			zapper_lights[i].target = light_effect.targetname;
			playfxontag(level._effect["zapper_light_ready"],light_effect,"tag_origin");
		}
	}
}

turnLightRed(name)
{
	zapper_lights = getentarray(name,"targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	
		if (isDefined(zapper_lights[i].target))
		{
			old_light_effect = getent(zapper_lights[i].target, "targetname");
			light_effect = spawn("script_model",old_light_effect.origin);
			//light_effect = spawn("script_model",zapper_lights[i].origin);
			light_effect setmodel("tag_origin");	
			light_effect.angles = (0,270,0);
			light_effect.targetname = "effect_" + name + i;
			old_light_effect delete();
			zapper_lights[i].target = light_effect.targetname;
			playfxontag(level._effect["zapper_light_notready"],light_effect,"tag_origin");
		}
	}
}
book_useage()
{
	book_counter = 0;
	book_trig = getent("book_trig", "targetname");
	book_trig SetCursorHint( "HINT_NOICON" );
	book_trig UseTriggerRequireLookAt();

	if(IsDefined(book_trig))
	{
		maniac_l = getent("maniac_l", "targetname");
		maniac_r = getent("maniac_r", "targetname");
		
		book_trig waittill( "trigger", player );
		
		if(IsDefined(maniac_l))
		{
			maniac_l playsound("maniac_l");
			
		}
		if(IsDefined(maniac_r))
		{
			maniac_r playsound("maniac_r");
			
		}
		
	}	
}
	
	
toilet_useage()
{

	toilet_counter = 0;
	toilet_trig = getent("toilet", "targetname");
	toilet_trig SetCursorHint( "HINT_NOICON" );
	toilet_trig UseTriggerRequireLookAt();
	
//	off_the_hook = spawn ("script_origin", toilet_trig.origin);
	toilet_trig playloopsound ("phone_hook");
	
	if (!IsDefined (level.eggs))
	{
		level.eggs = 0;
	}	

	toilet_trig waittill( "trigger", player );
	toilet_trig stoploopsound(0.5);
	toilet_trig playloopsound("phone_dialtone");

	wait(0.5);

	toilet_trig waittill( "trigger", player );
	toilet_trig stoploopsound(0.5);
	toilet_trig playsound("dial_9", "sound_done");
	toilet_trig waittill("sound_done");

	toilet_trig waittill( "trigger", player );
	toilet_trig playsound("dial_1", "sound_done");
	toilet_trig waittill("sound_done");

	toilet_trig waittill( "trigger", player );
	toilet_trig playsound("dial_1");
	wait(0.5);
	toilet_trig playsound("riiing");
	wait(1);
	toilet_trig playsound("riiing");
	wait(1);			
	toilet_trig playsound ("toilet_flush", "sound_done");				
	toilet_trig waittill ("sound_done");				
	playsoundatposition ("cha_ching", toilet_trig.origin);
	level.eggs = 1;
	setmusicstate("eggs");
	
	index = maps\_zombiemode_weapons::get_player_index(player);
	player_index = "plr_" + index + "_";
	if(!IsDefined (self.vox_audio_secret))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_audio_secret");
		self.vox_audio_secret = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_audio_secret[self.vox_audio_secret.size] = "vox_audio_secret_" + i;	
		}
		self.vox_audio_secret_available = self.vox_audio_secret;
	}
	
	
	/#
		player iprintln( "'Dead Air' Achievement Earned" );
	#/

	player giveachievement_wrapper( "DLC2_ZOMBIE_SECRET"); 
	
	sound_to_play = random(self.vox_audio_secret_available);
	self.vox_audio_secret_available = array_remove(self.vox_audio_secret_available,sound_to_play);	
	player maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0);
	
	wait(292);	
	setmusicstate("WAVE_1");
	level.eggs = 0;				
}
play_radio_sounds()
{
	radio_one = getent("radio_one_origin", "targetname");
	radio_two = getent("radio_two_origin", "targetname");
	radio_three = getent("radio_three_origin", "targetname");
	
	pa_system = getent("speaker_in_attic", "targetname");
	
	radio_one stoploopsound(2);
	radio_two stoploopsound(2);
	radio_three stoploopsound(2);
	
	wait(0.05);
	pa_system playsound("secret_message", "message_complete");
	pa_system waittill("message_complete");
	
	radio_one playsound ("static");
	radio_two playsound ("static");
	radio_three playsound ("static");
}
radio_eggs()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}
	while(level.radio_counter < 3)
	{
		wait(2);	
	}
	level thread play_radio_sounds();
	
	
}
battle_radio()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}

	battle_radio_trig = getent ("battle_radio_trigger", "targetname");
	battle_radio_trig UseTriggerRequireLookAt();
	battle_radio_trig SetCursorHint( "HINT_NOICON" );
	battle_radio_origin = getent("battle_radio_origin", "targetname");
	
	battle_radio_trig waittill( "trigger", player);		
	battle_radio_origin playsound ("battle_message");

}
whisper_radio()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}

	whisper_radio_trig = getent ("whisper_radio_trigger", "targetname");
	whisper_radio_trig UseTriggerRequireLookAt();
	whisper_radio_trig SetCursorHint( "HINT_NOICON" );
	whisper_radio_origin = getent("whisper_radio_origin", "targetname");
	
	whisper_radio_trig waittill( "trigger");		
	whisper_radio_origin playsound ("whisper_message");

}
radio_one()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}
	players = getplayers();
	
	radio_one_trig = getent ("radio_one", "targetname");
	radio_one_trig UseTriggerRequireLookAt();
	radio_one_trig SetCursorHint( "HINT_NOICON" );
	radio_one = getent("radio_one_origin", "targetname");
	
	for(i=0;i<players.size;i++)
	{			
		radio_one_trig waittill( "trigger", players);
		
		level.radio_counter = level.radio_counter + 1;
		radio_one playloopsound ("static_loop");

	}	
}
radio_two()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}
	players = getplayers();
	radio_two_trig = getent ("radio_two", "targetname");
	radio_two_trig UseTriggerRequireLookAt();
	radio_two_trig SetCursorHint( "HINT_NOICON" );
	radio_two = getent("radio_two_origin", "targetname");
	
	
	for(i=0;i<players.size;i++)
	{			
		radio_two_trig waittill( "trigger", players);
		level.radio_counter = level.radio_counter + 1;
		radio_two playloopsound ("static_loop");
	
	}	
}
radio_three()
{
	if(!IsDefined (level.radio_counter))
	{
		level.radio_counter = 0;	
	}
	players = getplayers();
	radio_three_trig = getent ("radio_three_trigger", "targetname");
	radio_three_trig UseTriggerRequireLookAt();
	radio_three_trig SetCursorHint( "HINT_NOICON" ); 
	radio_three = getent("radio_three_origin", "targetname");
	for(i=0;i<players.size;i++)
	{			
		radio_three_trig waittill( "trigger", players);
		level.radio_counter = level.radio_counter + 1;			
		radio_three playloopsound ("static_loop");
		
	}	
}

/*hanging_dead_guy()
{
	//grab the hanging dead guy model
	dead_guy = getent("hanging_dead_guy","targetname");

	if(!isdefined(dead_guy))
		return;
		
	dead_guy physicslaunch ( dead_guy.origin, (randomintrange(-20,20),randomintrange(-20,20),randomintrange(-20,20)) );
}*/

meteor_trigger()
{
	level endon("meteor_triggered");
	dmgtrig = GetEnt( "meteor", "targetname" );
	player = getplayers();
	for(i=0;i<player.size;i++)
	{	
		while(1)
		{
			dmgtrig waittill("trigger", player);
			if(distancesquared(player.origin, dmgtrig.origin) < 1096 * 1096)
			{
				player thread meteor_dialog();
				level notify ("meteor_triggered");
			}
			else
			{
				wait(0.1);	
			}
		}
	}	
	
}
meteor_dialog()
{
	index = maps\_zombiemode_weapons::get_player_index(self);
	player_index = "plr_" + index + "_";
	sound_to_play = "vox_gen_meteor_0";
	self maps\_zombiemode_spawner::do_player_playdialog(player_index,sound_to_play, 0.25);
}
player_zombie_awareness()
{
	self endon("disconnect");
	self endon("death");
	players = getplayers();
	while(1)
	{
		wait(1);		
		//zombie = get_closest_ai(self.origin,"axis");
		
		zombs = getaiarray("axis");
		for(i=0;i<zombs.size;i++)
		{
			if(DistanceSquared(zombs[i].origin, self.origin) < 200 * 200)
			{
				if(!isDefined(zombs[i]))
				{
					continue;
				}
				
				dist = 200;				
				switch(zombs[i].zombie_move_speed)
				{
					case "walk": dist = 200;break;
					case "run": dist = 250; break;
					case "sprint": dist = 275;break;
				}				
				if(distance2d(zombs[i].origin,self.origin) < dist)
				{				
					yaw = self animscripts\utility::GetYawToSpot(zombs[i].origin );
					//check to see if he's actually behind the player
					if(yaw < -95 || yaw > 95)
					{
						zombs[i] playsound ("behind_vocals");
					}
				}				
				
			}

		}
		if(players.size > 1)
		{
			//Plays 'teamwork' style dialog if there are more than 1 player...
			close_zombs = 0;
			for(i=0;i<zombs.size;i++)
			{
				if(DistanceSquared(zombs[i].origin, self.origin) < 250 * 250)
				{
					close_zombs ++;
					
				}
			}
			if(close_zombs > 4)
			{
				if(randomintrange(0,20) < 5)
				{
					self thread play_oh_shit_dialog();	
				}
			}
		}
		
	}
}		
play_oh_shit_dialog()
{
	//player = getplayers();	
	index = maps\_zombiemode_weapons::get_player_index(self);
	
	player_index = "plr_" + index + "_";
	if(!IsDefined (self.vox_oh_shit))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_oh_shit");
		self.vox_oh_shit = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_oh_shit[self.vox_oh_shit.size] = "vox_oh_shit_" + i;	
		}
		self.vox_oh_shit_available = self.vox_oh_shit;		
	}	
	sound_to_play = random(self.vox_oh_shit_available);
	
	self.vox_oh_shit_available = array_remove(self.vox_oh_shit_available,sound_to_play);
	
	if (self.vox_oh_shit_available.size < 1 )
	{
		self.vox_oh_shit_available = self.vox_oh_shit;
	}
			
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, 0.25);


}			
		
		

