#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\sniper_stealth_logic;
#include maps\sniper;
#include maps\sniper_event4;
#include maps\_music;
#include maps\_debug;

// main function for handeling Snipe_geo

							/////////////////////////////////// AI Spawn functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
setup_spawn_functions()
{
	array_thread(getentarray("E2_block_officerb_guys", "script_noteworthy"), 		:: add_spawn_function, ::E2_blockofficerb_guys_setup);
	array_thread(getentarray("E2_block_halftrack_guys", "script_noteworthy"), 	:: add_spawn_function, ::E2_halftrack_guys_setup);
	array_thread(getentarray("E2_mean_patrollers", "script_noteworthy"),			 	:: add_spawn_function, ::e2_mean_patrollers_setup);
	array_thread(getentarray("E2_mean_patrollers", "targetname"),						 	:: add_spawn_function, ::notify_bb_stealthbreak);
	array_thread(getentarray("halftrack2_riders", "targetname"), 								:: add_spawn_function, ::halftrack2_riders_setup);
	array_thread(getentarray("wounded_fountain_guys", "script_noteworthy"),	    :: wounded_fountain_guys_setup);
	array_thread(getentarray("e1_building_cleaners", "targetname"), 						:: add_spawn_function, ::hunters);
	array_thread(getentarray("charge_player", "script_noteworthy"), 						:: add_spawn_function, ::charge_player_dudes);
	array_thread(getentarray("bb_outside_shooters", "targetname"),		 					:: add_spawn_function, ::burning_building_shooters_setup);
	array_thread(getentarray("e2_flamer1", "targetname"), 								:: add_spawn_function, ::e2_flamer1_setup);
	array_thread(getentarray("alley_dudes1", "targetname"), 										:: add_spawn_function, ::alley_dudes1_setup);
	array_thread(getentarray("alley_dudes1_2", "targetname"), 									:: add_spawn_function, ::alley_dudes1_2_setup);
	array_thread(getentarray("alley_dudes1_3", "targetname"), 									:: add_spawn_function, ::alley_dudes1_3_setup);
	array_thread(getentarray("e3_bb_finder3", "script_noteworthy"), 						:: add_spawn_function, ::dead_on_arrival);
	//array_thread(getentarray("alley_dudes4", "targetname"), 										:: add_spawn_function, ::alleydudes4_setup);
	//array_thread(getentarray("alley_dudes4b", "targetname"), 										:: add_spawn_function, ::alleydudes4_setup);
	array_thread(getentarray("e3_snipercover_b_snipers", "script_noteworthy"), 	:: add_spawn_function, ::e3_snipers_setup);
	array_thread(getentarray("alley_dudes2", "script_noteworthy"), 							:: add_spawn_function, ::alley_dudes2_setup);
	array_thread(getentarray("alley_dudes6", "targetname"), 										:: add_spawn_function, ::alley_dudes2_setup);
	array_thread(getentarray("alley_dudes6_2", "targetname"), 									:: add_spawn_function, ::alley_dudes2_setup);
	array_thread(getentarray("officer_entourage", "targetname"), 								:: add_spawn_function, ::solo_set_pacifist,true);
	array_thread(getentarray("lastguys_shootatu", "targetname"), 								:: add_spawn_function, ::solo_set_pacifist,false);
	array_thread(getentarray("vehicle_riders", "script_noteworthy"), 						:: add_spawn_function, ::vehicle_riders_setup);
	array_thread(getentarray("e3_left_roof_guys", "script_noteworthy"), 				:: add_spawn_function, ::leftroofguys_setup);
	array_thread(getentarray("e3_left_balcony_guys", "script_noteworthy"), 			:: add_spawn_function, ::ignored_by_friendlies);
	array_thread(getentarray("flamer", "script_noteworthy"), 										:: add_spawn_function, ::flamer_setup);
	array_thread(getentarray("alley_dudes3", "targetname"), 										:: add_spawn_function, ::wait_and_kill, 45*level.difficulty);
	array_thread(getentarray("alley_dudes3", "targetname"), 										:: add_spawn_function, ::level_alleyguys_dead_increment, 2);
	array_thread(getentarray("e3_p1_second_floor_guys", "script_noteworthy"), 	:: add_spawn_function, ::floor2_guys_setup);
	array_thread(getentarray("e3_redshirts", "script_noteworthy"), 							:: add_spawn_function, ::e3_redshirts_setup);
	array_thread(getentarray("dudeguys_charge", "script_noteworthy"), 					:: add_spawn_function, ::dudeguys_charge_setup);
	array_thread(getentarray("attack_player_only", "script_noteworthy"), 				:: add_spawn_function, ::player_only_enemy);
	array_thread(getentarray("dudeguys", "targetname"), 												:: add_spawn_function, ::solo_set_pacifist, true);
	array_thread(getentarray("e1_flameguy", "targetname"), 											:: add_spawn_function, ::streetdudes_findyou);
	array_thread(getentarray("e5_stairdudes_flood", "targetname"), 							:: add_spawn_function, ::stairfloods_setup);
	array_thread(getentarray("bodyguard", "script_noteworthy"), 								:: add_spawn_function, ::bodyguard_setup);
	array_thread(getentarray("lead_bodyguard", "script_noteworthy"), 						:: add_spawn_function, ::lead_bodyguard_setup);
	array_thread(getentarray("newbs_charge", "script_noteworthy"), 							:: add_spawn_function, ::newbs_setup);
	array_thread(getentarray("e5_run_underyou_guys", "targetname"), 						:: add_spawn_function, ::e5_holeguys_setup);
	array_thread(getentarray("e3_bb_runner", "script_noteworthy"), 							:: add_spawn_function, ::e3_bb_runner_setup);
	array_thread(getentarray("e4_cqb_guys", "targetname"), 											:: add_spawn_function, ::wait_and_chargeplayer, randomintrange(30,60));
	array_thread(getentarray("actor_axis_ger_ber_wehr_reg_kar98k", "classname"),:: add_spawn_function, ::noscope_line);
	array_thread(getentarray("actor_axis_ger_ber_wehr_reg_mp40", "classname"),	:: add_spawn_function, ::noscope_line);	
	array_thread(getentarray("actor_enemy_dog", "classname"),										:: add_spawn_function, ::noscope_line);								
	array_thread(getentarray("e3_snipercover_3floordudes_left", "targetname"),	:: add_spawn_function, ::player_only_enemy);							
	array_thread(getentarray("e3_allied_squad", "script_noteworthy"),						:: add_spawn_function, ::make_russian_squad);							
	array_thread(getentarray("e3_allied_squad_animate", "script_noteworthy"),		:: add_spawn_function, ::make_russian_squad);							
	array_thread(getentarray("e3_allied_squad_leader", "script_noteworthy"),		:: add_spawn_function, ::make_russian_squad);							
					
							
						
	
	
	getent("flamer_quickdeath", "script_noteworthy") 						 add_spawn_function( ::flamer_setup, randomintrange(10,25));
	
	getent("floor2_mgguy", "script_noteworthy") 						 add_spawn_function( ::floor2_mgguy_setup);
	getent("e2_flamer2", "targetname") 						 		add_spawn_function( ::e2_flamer_setup);
	getent("e2_flamer4", "targetname") 						 			add_spawn_function( ::e2_flamer_setup);
	getent("e2_flamer5", "targetname") 								 add_spawn_function( ::e2_flamer1_setup);
	getent("e2_flamer6", "targetname") 						 	 	add_spawn_function( ::e2_flamer1_setup);
	
	getent("officer2", "script_noteworthy")						 add_spawn_function(::e4_officer_setup);
	getent("sniper1", "script_noteworthy") 					   add_spawn_function(::first_sniper_setup);
	getent("sniper2", "script_noteworthy") 					   add_spawn_function(::first_sniper_setup);
	getent("anim_dude", "script_noteworthy") 				 	 add_spawn_function(::fountain_shooter);
	getent("mydog", "script_noteworthy") 							 add_spawn_function(::dog_setup);
	getent("dog_handler", "script_noteworthy") 		 	   add_spawn_function(::dog_handler_setup);
	getent("sentry_1", "script_noteworthy")    				 add_spawn_function(::sentry_1_setup);
	//getent("E2_block_officerb_findbody_guy", "script_noteworthy") add_spawn_function(::findbody_guy_setup);
	getent("mydog2", "script_noteworthy") 						 add_spawn_function(::mydog2_setup);
	getent("e1_flameguy", "script_noteworthy") 				 add_spawn_function(::e1_flameguy_setup);	
	getent("e3_dudes_chatter1", "script_noteworthy")	 add_spawn_function( ::e3_dudes_chatter1_setup);
	getent("e3_dudes_chatter2", "script_noteworthy")	 add_spawn_function( ::e3_dudes_chatter2_setup);
	getent("e3_patrolguy1", "script_noteworthy")			 add_spawn_function( ::e3_patrolguy1_setup);
	getent("e3_patrolguy2", "script_noteworthy")			 add_spawn_function( ::e3_patrolguy2_setup);
	getent("e3_bb_finder1", "script_noteworthy")			 add_spawn_function( ::e3_bb_finder1_setup);
	getent("e3_bb_finder2", "script_noteworthy")			 add_spawn_function( ::e3_bb_finder2_setup);
	getent("e3_bb_finder3", "script_noteworthy")			 add_spawn_function( ::e3_bb_finder3_setup);
	getent("e3_halftrack_mgguy", "script_noteworthy")	 add_spawn_function( ::e3_halftrack_mg_guy);
	getent("e5_halftrack_mgguy", "script_noteworthy")	 add_spawn_function( ::e5_halftrack_mg_guy);
	
	getent("officer", "script_noteworthy")						 add_spawn_function( ::officer_setup);
	getent("officer_assistant", "script_noteworthy")	 add_spawn_function( ::officer_assistant_setup);
	getent("ftn_walker1", "script_noteworthy")				 add_spawn_function( ::ftn_walker1_setup);
	getent("ftn_walker2", "script_noteworthy")	 			 add_spawn_function( ::ftn_walker2_setup);
	getent("ftn_walker3", "script_noteworthy")	 			 add_spawn_function( ::ftn_walker3_setup);
	getent("ftn_walker4", "script_noteworthy") 					 			 add_spawn_function(::ftn_walker4_setup);
	getent("bb_street_officer", "script_noteworthy")	 add_spawn_function( ::bb_street_setup, 1);
	getent("bb_street_dude1", "script_noteworthy")	 	 add_spawn_function( ::bb_street_setup, 2);
	getent("bb_street_dude2", "script_noteworthy")	 	 add_spawn_function( ::bb_street_setup, 3);
	getent("bb_street_dude1_2", "script_noteworthy")	 	 add_spawn_function( ::bb_street_setup, 2);
	getent("bb_street_dude2_2", "script_noteworthy")	 	 add_spawn_function( ::bb_street_setup, 3);
	getent("dog_handler2", "script_noteworthy")	 			 add_spawn_function( ::dog_handler2_setup);
	getent("by_tank_dude1", "script_noteworthy")			 add_spawn_function( ::by_tank_dude1_setup);
	getent("by_tank_dude2", "script_noteworthy")	 		 add_spawn_function( ::by_tank_dude2_setup);
	getent("by_tank_dude3", "script_noteworthy")			 add_spawn_function(::by_tank_dude3_setup);
	getent("by_tank_dude4", "script_noteworthy") 			 add_spawn_function(::by_tank_dude4_setup);
	getent("horchguy1", "script_noteworthy")					 add_spawn_function(::horchguy1_setup);
	getent("horchguy2", "script_noteworthy") 					 add_spawn_function(::horchguy2_setup);
	//getent("book_h8r", "script_noteworthy") 				 add_spawn_function(::book_h8r_setup);
	getent("ftn_walker_early", "targetname")					 add_spawn_function(::ftn_walker_early_setup);
	getent("officer_driver", "script_noteworthy") 		 add_spawn_function(::driver_setup); 
	getent("officers_sniper", "script_noteworthy")     add_spawn_function(::officers_sniper_setup);
	getent("newbhater", "targetname")      						 add_spawn_function(::newbhater_setup);
	getent("e3_allied_squad_leader", "script_noteworthy")    add_spawn_function(::my_name_is_daletski);
	
	
	guys = getentarray("e3_arguing_dude", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::e3_arguing_setup, i+1);
	}
	
	guys = getentarray("e3_truck_vin_guys", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::e3_arguing_setup2, i+1);
	}
	
	guys = getentarray("rideon_tankguys", "script_noteworthy");
	for (i=0; i < guys.size; i++)
	{
		guys[i] add_spawn_function(::tankriders_setup, i+1);
	}
}

my_name_is_daletski()
{
	self.name = "Sgt. Daletski";
}

noscope_line()
{
	if (flag("did_noscope"))
	{
		return;
	}
	level endon ("said_noscope");
	self waittill ( "damage", damage_amount, attacker, direction_vec, point, type );
	weap = level.player getcurrentweapon() ;
	if ( 	type == "MOD_RIFLE_BULLET" 
				&& attacker == level.player 
				&& 0 > self.health
				&& ( weap == "mosin_rifle_scoped" ||  weap == "ptrs41")
				&& !flag("player_is_ads")			)
	{
		if (level.player AdsButtonPressed() )
		{
			return;
		}
		wait 1;
		dist = distance(level.player.origin, level.hero.origin);
		if (!flag("player_is_ads") && dist < 700)
		{
			if (cointoss() )
			{
				level thread say_dialogue("noscope");
			}
			else
			{
				level thread say_dialogue("noscope");
			}
			flag_set("did_noscope");
			level notify ("said_noscope");
		}
	}
}
		
				

e3_bb_runner_setup()
{
	level thread wait_and_delete(self, 15);
	self.pacifist = true;
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill ("goal");
	
	self delete();
}

floor2_mgguy_setup()
{
	self endon ("death");
	while(!flag("rooftop_battle") )
	{
		chance = 25*level.difficulty;
		toss = randomint(99);
		if (toss >= chance)
		{
			self setthreatbiasgroup("flankers");
		}
		else 
		{
			self setthreatbiasgroup("badguys");
		}
		wait 5;
	}
	self dodamage(self.health*5, (0,0,0) );
}

leftroofguys_setup()
{
	self endon ("death");
	self thread player_only_enemy();
	level.saidhighbalcony = 0;
	wait randomfloatrange(30,50);
	if (level.saidhighbalcony == 0)
	{
		level.saidhighbalcony = 1;
		level thread say_dialogue("more_high_balcony");
	}
}

e5_holeguys_setup()
{
	spot = getstructent("floorhole_target"+randomint(2), "targetname");
	self setentitytarget(spot);
}

bodyguard_setup()
{
	self endon ("death");
	self.pacifist = true;
	node = getnode(self.target, "targetname");
	self setgoalnode(node);
	self waittill ("goal");
	self.animname = "generic";
	animtime = getanimlength(level.scr_anim[self.animname][ "scan"]);
	node thread anim_single_solo(self, "scan");
	level thread wait_and_setflag(animtime, "player_fired_in_e4");
	//node thread anim_loop_solo(self, "lookaround1_loop", undefined, "stoploop");
	flag_wait("player_fired_in_e4");
	wait randomfloat(1);
	node notify ("stoploop");
	self stopanimscripted();
	if (!isdefined(level.thisdudepointed) )
	{
		level.thisdudepointed = 1;
		spot = getstruct(node.script_noteworthy+"_point", "script_noteworthy");
		animspot = spawn("script_origin", self.origin);
		animspot.angles = spot.angles;
		animspot anim_single_solo(self, "point");
		animspot delete();
	}
	newnode = getnode(node.target, "targetname");
	self setgoalnode(newnode);
}
	
lead_bodyguard_setup()
{
	level.leadbodyguard = self;
	self endon ("death");
	self.pacifist = true;
	self.ignoreall = true;
	level thread officer_runto_cover(self);
	node = getnode(self.target, "targetname");
	self.animname = "officers_sniper";
	animnode = getstruct("bodyguard_run_spot", "targetname");
	animnode anim_single_solo(self, "bodyguard_exit");
	flag_set("officer_to_tank");
	self.animname = "generic";
	node anim_reach_solo(self, "motioning_reach");
	node thread anim_loop_solo(self, "motioning", undefined, "stoploop");
	level waittill ("wave_ansel");
	node notify ("stoploop");
	node anim_single_solo(self, "wave_ansel");
	newnode = getnode(node.target, "targetname");
	self setgoalnode(newnode);
	self.ignoreall = false;
}


newbs_deathpoint()
{
	self endon ("death");
	while(1)
	{
		if (self.origin[0] < 5200)
		{
			self thread wait_and_kill(randomfloat(5));
		}
		wait 0.05;
	}
}

newbs_setup()
{
	self thread newbs_deathpoint();
	self endon ("death");
	self setthreatbiasgroup("newbs");
	wait 3;
	self playsound ("russian_battle_crymn"); 
	wait randomfloatrange(2, 7);
	if (!isdefined(level.guythrewtov) && isdefined(self.enemy)  )
	{
		self.animname = "allies";
		self thread anim_single_solo(self,"molotov_toss");
		level.guythrewtov = 1;
	}
	self thread wait_and_kill(randomfloat(12, 20) );
}

newbhater_setup()
{
	self endon ("death");
	self setthreatbiasgroup("newbhater");
	self.ignoreme = true;
	setthreatbias("newbs", "newbhater", 10000);
	waittill_aigroupcleared("newbs");
	while(1)
	{
		self setthreatbiasgroup("ignoreplayer");
		wait 10;
		self setthreatbiasgroup("badguys");
		wait 10;
	}
}


stairfloods_setup()
{
	self setgoalentity(level.player);
	self own_player_hard();
}

own_player_hard()
{
	while(1)
	{
		level.player waittill("damage", amount, attacker);
		if (attacker == self)
		{
			level.player dodamage(40, attacker.origin);
		}
	}
}

officers_sniper_setup()
{
	self solo_set_pacifist(true);
	self.ignoreall = true;
	self.health = 999999;
	self disable_pain();
	level.officers_sniper = self;
	level thread maps\sniper_event4::clear_on_snipers_death();
	self thread maps\sniper_event4::officers_sniper_run();
}
	
	

e2_flamer1_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	self.ignoreall = true;
	self.health = 999;
	node = getnode(self.target, "targetname");
	self.animname = "e2_flamer";
	self setgoalnode(node);
	self waittill ("goal");
	node anim_reach_solo(self, "stand_aim_reach");
	spot1 = spawn ("script_origin", node.origin+(0,0,8) );
	spot1.angles = node.angles;
	spot1 thread anim_loop_solo(self, "stand_aim", undefined, "death");
	ospot = getstruct(node.targetname+"_target", "targetname");
	spot = ospot swap_struct_with_origin();
	
	
	self.goalradius = 32;
	self.pacifist = true;
	self.ignoreall = true;
	
	exploder(ospot.script_noteworthy);
	self.health = 100;
	wait 0.1;
	
	ang = (getstruct("flame_angles", "targetname")).angles;
	org = self gettagorigin("tag_flash");
	//org = org+(0,0,20); // needed to be a little higher
	
	spot2 = spawn ("script_model", org);
	spot2 setmodel("tag_origin");
	spot2.angles = ang;
	spot2 thread e2_flamer_struct_movers();
	self do_fake_flamethrower_fire(5, spot2);
	
	spot2 notify ("death");
	spot delete();
	spot1 delete();
	self setgoalnode(getnode(node.targetname+"_flee", "targetname")) ;
	wait 7;
	self dodamage(self.health*10,(0,0,0));
}

e2_flamer_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	self.ignoreall = true;
	self endon ("death");
	self.health = 999;
	node = getnode(self.target, "targetname");
	//self setgoalnode(node);
	//self waittill ("goal");
	self.animname = "e2_flamer";
	self setgoalnode(node);
	self waittill ("goal");
	node anim_reach_solo(self, "stand_aim_reach");
	spot1 = spawn ("script_origin", node.origin+(0,0,8) );
	spot1.angles = node.angles;
	spot1 thread anim_loop_solo(self, "stand_aim", undefined, "death");
		
	ospot = getstruct(node.targetname+"_target", "targetname");
	spot = ospot swap_struct_with_origin();
	
	self aimatpos(spot.origin);
	
	self.goalradius = 32;
	//self setentitytarget(spot);
	self.pacifist = true;
	self.ignoreall = true;
	if (ospot.script_noteworthy == "4")
	{
		level thread maps\sniper_event2::bookcase_fire();
	}
	exploder(ospot.script_noteworthy);
	self.health = 100;
	//self wait_and_notify(5,"goal");
	//self waittill ("goal");
	wait 0.1;
	ang = (getstruct("flame_angles", "targetname")).angles;
	org = self gettagorigin("tag_flash");
	//org = org+(0,0,20);
	
	spot2 = spawn ("script_model", org);
	spot2 setmodel("tag_origin");
	spot2.angles = ang;
	spot2 thread e2_flamer_struct_movers();
	self do_fake_flamethrower_fire(7,spot2);		// do the fake flamethrower stuff
	
	wait 2;
	spot delete();
	spot1 delete();
	self setgoalnode(getnode(node.targetname+"_flee", "targetname")) ;
	wait 7;
	self dodamage(self.health*10, (0,0,0) );
}

do_fake_flamethrower_fire(times, spot2)
{
	self endon ("death");
	for (i=0; i < times; i++)
	{
		org = self gettagorigin("tag_flash");
		spot2.origin = org;
		playfxontag(level._effect["flamethrower_fire"], spot2, "tag_origin");
		self playsound("weap_flamethrower_start_3p_scripted");
		self playloopsound("weap_flamethrower_fireloop_3p_scripted");
		curtains = getentarray(self.script_noteworthy+"_curtains", "targetname");
		if (isdefined(curtains) && curtains.size > 0)
		{
			array_thread(curtains, ::its_curtains_for_ya);
		}
		wait randomfloatrange(1,2);
		self stoploopsound();
		self playsound("weap_flamethrower_cooldown_3p_scripted");
		wait(1);
		self stoploopsound();
	}
}

notify_bb_stealthbreak()
{	
	if(self.classname == "actor_axis_ger_ber_wehr_reg_flamethrower")
	{
		self thread kill_after_bbison();
	}
	level endon ("bb_escape_ison");
	self.disablearrivals = true;
	self.disableexits=true;
	self waittill ("damage");
	level notify ("stealthbreak");
}

kill_after_bbison()
{
	self endon ("death");
	level waittill ("bb_escape_ison");
	self thread wait_and_kill(7);
}


by_tank_dude1_setup()
{
	level endon ("found_infountain");
	self endon ("death");
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	level thread die_and_notify(self, self.script_noteworthy+"died");
	level thread corpse_adder(self);
	self solo_set_pacifist(true);
	self.animname = "streetdude1";
	
	spot = getstruct("streetnode_fortankguys", "targetname");
	
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;
	self teleport(orient.origin, orient.angles);
	orient delete();
	spot thread anim_loop_solo(self, "idle", undefined, "by_tankdude_1_stoploop");
	self Attach( "anm_okinawa_cigarette_jpn", "tag_inhand" );
	
	wait( 1 ); 
	PlayFxOnTag( level._effect["cigarette"], self, "tag_fx" ); 
	PlayFxOnTag( level._effect["cigarette_glow"], self, "tag_fx" ); 
	
	flag_wait("tank2_dude_spawned");
	wait 0.1;
	friend = grab_ai_by_script_noteworthy("by_tank_dude2", "axis");
	
	level waittill (friend.script_noteworthy+"died");
	spot notify ("by_tankdude_1_stoploop");
	
	spot anim_single_solo(self, "react");
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);
	wait 3;
	level notify ("found_infountain");
}
	
by_tank_dude2_setup()
{
	self thread streetdudes_findyou();
	level thread die_and_notify(self, self.script_noteworthy+"died");
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	level endon ("found_infountain");
	flag_set("tank2_dude_spawned");
	level thread corpse_adder(self);
	self endon ("death");
	self solo_set_pacifist(true);
	self.animname = "streetdude2";
	spot = getstruct("streetnode_fortankguys", "targetname");
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;		self teleport(orient.origin, orient.angles);
	self.deathanim = level.scr_anim[self.animname]["shot"];
	orient delete();
	spot anim_single_solo(self, "intro");
	spot thread anim_loop_solo(self, "loop", undefined, "by_tankdude_2_stoploop");
	friend = grab_ai_by_script_noteworthy("by_tank_dude1", "axis");
	level waittill (friend.script_noteworthy+"died");
	spot notify ("by_tankdude_2_stoploop");

	animtime = getanimlength(level.scr_anim[self.animname][ "react"]);
	spot thread anim_single_solo(self, "react");
	wait 1.5;
	self.deathanim = undefined;
	wait animtime - 1.5;
	
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);
	wait 3;
	level notify ("found_infountain");

}

by_tank_dude3_setup()
{
	level endon ("found_infountain");
	self endon ("death");
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	level thread die_and_notify(self, self.script_noteworthy+"died");
	level thread corpse_adder(self);
	self solo_set_pacifist(true);
	self.animname = "streetdude3";
	
	spot = getstruct("streetnode", "targetname");
	
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;		self teleport(orient.origin, orient.angles);
	self.deathanim = level.scr_anim[self.animname]["shot"];
	orient delete();
	spot anim_single_solo(self, "intro");
	spot thread anim_loop_solo(self, "loop", undefined, "by_tankdude_3_stoploop");
	friend = grab_ai_by_script_noteworthy("by_tank_dude4", "axis");
	level waittill (friend.script_noteworthy+"died");
	spot notify ("by_tankdude_3_stoploop");
	
	animtime = getanimlength(level.scr_anim[self.animname][ "react"]);
	spot thread anim_single_solo(self, "react");
	wait 1.5;
	self.deathanim = undefined;
	wait animtime - 1.5;
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);

	self.deathanim = undefined;
	wait 3;
	level notify ("found_infountain");
}

by_tank_dude4_setup()
{
	level endon ("found_infountain");
	self endon ("death");
		self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	level thread die_and_notify(self, self.script_noteworthy+"died");
	level thread corpse_adder(self);
	self solo_set_pacifist(true);
	self.animname = "streetdude4";
	
	spot = getstruct("streetnode", "targetname");
	
	
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;		self teleport(orient.origin, orient.angles);
	//self.deathanim = level.scr_anim[self.animname]["shot"];
	orient delete();
	spot anim_single_solo(self, "intro");
	spot thread anim_loop_solo(self, "loop", undefined, "by_tankdude_4_stoploop");
	friend = grab_ai_by_script_noteworthy("by_tank_dude3", "axis");
	level waittill (friend.script_noteworthy+"died");
	spot notify ("by_tankdude_4_stoploop");
	
	animtime = getanimlength(level.scr_anim[self.animname][ "react"]);
	spot thread anim_single_solo(self, "react");
	wait 1.5;
	self.deathanim = undefined;
	wait animtime - 1.5;
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);
	wait 3;
	level notify ("found_infountain");
}

horchguy1_setup()
{
	level endon ("found_infountain");
	level thread die_and_notify(self, self.script_noteworthy+"died");
	self endon ("death");
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	self solo_set_pacifist(true);
	level thread corpse_adder(self);
	self.animname = "horchguy1";
	spot = getstruct("anim_chair_spot", "targetname");
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;		self teleport(orient.origin, orient.angles);
	self.nodeathragdoll = true;
	self.deathanim = level.scr_anim[self.animname]["shot"];
	//level thread horchguy1_animate_dead(self, spot);
	orient delete();
	spot anim_single_solo(self, "intro");
	spot thread anim_loop_solo(self, "loop", undefined, "horchguy1_stoploop");
	friend = grab_ai_by_script_noteworthy("horchguy2", "axis");
	level waittill (friend.script_noteworthy+"died");
	spot notify ("horchguy1_stoploop");
	
	animtime = getanimlength(level.scr_anim[self.animname][ "react"]);
	spot thread anim_single_solo(self, "react");
	wait 1.5;
	self.deathanim = undefined;
	wait animtime - 1.5;
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);
	wait 3;
	level notify ("found_infountain");
}


horchguy2_setup()
{
	level endon ("found_infountain");
	self endon ("death");
		self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	level thread die_and_notify(self, self.script_noteworthy+"died");
	self solo_set_pacifist(true);
	level thread corpse_adder(self);
	self.animname = "horchguy2";
	spot = getstruct("anim_chair_spot", "targetname");
	self.animspot = spot;
	orient = spawn ("script_origin", self.origin);
	orient.angles = spot.angles;		self teleport(orient.origin, orient.angles);
	self.nodeathragdoll = true;
	self.deathanim = level.scr_anim[self.animname]["shot"];
	orient delete();
	spot anim_single_solo(self, "intro");
	spot thread anim_loop_solo(self, "loop", undefined, "horchguy2_stoploop");
	friend = grab_ai_by_script_noteworthy("horchguy1", "axis");
	level waittill (friend.script_noteworthy+"died");
	spot notify ("horchguy2_stoploop");
	
	
	animtime = getanimlength(level.scr_anim[self.animname][ "react"]);
	spot thread anim_single_solo(self, "react");
	wait 1.5;
	self.deathanim = undefined;
	wait animtime - 1.5;
	
	self solo_set_pacifist(false);
	self setgoalentity(get_players()[0]);
	wait 3;
	level notify ("found_infountain");
}

floor2_guys_setup()
{
	if (cointoss())
	{
		self thread player_only_enemy();
	}
	self thread wait_and_kill( 45*level.difficulty);
}

dog_handler2_setup()
{
	self thread notify_bb_stealthbreak();
	self endon ("death");
	self thread waittill_and_setflag("death", "dog_found_you");
	level endon ("stealthbreak");
	self thread dog_handler2_wakeup();
	self solo_set_pacifist(true);
	self.animname = "dog_handler2";
	node = getstructent("dog_bark_node", "targetname");
	node thread maps\sniper_event2::delete_after_bb();
	animtime = getanimlength(level.scr_anim[self.animname][ "walk_withdog"]);
	self set_run_anim("walk_tospot");
	node anim_reach_solo(self, "walk_withdog");
	node thread anim_single_solo(self, "walk_withdog");
	
	if (!flag("bb_escape_ison"))
	{
		level thread maps\_autosave::autosave_game_now( "bb_escape" );
	}
	
	wait animtime - 5;
	level notify ("dog_go");
	wait 5;
	self solo_set_pacifist(false);
}

dog_handler2_wakeup()
{
	self endon ("death");
	level waittill ("stealthbreak");
	self stopanimscripted();
	self solo_set_pacifist(false);
}

	
dudeguys_charge_setup()
{
	self.ignoreme = true;
}	

	
e3_redshirts_setup()
{
	self endon("death");
	self.ignoreme = true;
	self disable_pain();
	self.ignoreall = true;
	self waittill ("goal");
	self enable_pain();
	self solo_set_pacifist(false);
	self.health = 300;
	wait 30;
	self dodamage(self.health *10, (0,0,0));
}

bb_street_setup(num)
{
	level endon ("bb_escape_ison");
	self endon ("death");
	self.allowdeath = true;
	self solo_set_pacifist(true);
	self.animname = "street_runners";
	node = getnode(self.target, "targetname");
	animnode = getnode(self.script_noteworthy+"_node", "script_noteworthy");
	animnode anim_reach_solo(self, "run"+num);
	animtime = getanimlength(level.scr_anim[self.animname][ "run"+num] );
	animnode thread anim_single_solo(self, "run"+num);
	self set_run_anim("_stealth_combat_jog");
	wait animtime- 0.08;
	self stopanimscripted();
	self set_run_anim("_stealth_combat_jog");
	self setgoalnode(node);
	self waittill ("goal");
	self dodamage(self.health*10, (0,0,0));
}

alley_dudes1_3_setup()
{
	thread killspawner_onspawn(21);
	self waittill ("death");
	level.alleyguys_dead++;
}

level_alleyguys_dead_increment(amount)
{
	self waittill ("death");
	level.alleyguys_dead = 	level.alleyguys_dead + amount;
}

alley_dudes1_2_setup()
{
	if (isdefined(self.script_noteworthy) && self.script_noteworthy == "flamer")
	{
		self thread alley_dudes1_2_flamer_setup();
	}
	self waittill ("death");
	level.alleyguys_dead++;
}

alley_dudes1_2_flamer_setup()
{
	self endon ("death");
	wait 4;
	level thread say_dialogue("another_flamer");
}

ignored_by_friendlies()
{
	self setthreatbiasgroup("flankers");
	self.ignoreme = true;
}

tankriders_setup(num)
{
	self solo_set_pacifist(true);
	wait 0.5;
	tag = "blah";
	tank = getent("riding_tank", "targetname");
	self.animname = "tankriders";
	if (num==1)
		{
			tag = "tag_passenger10";
		}
		else if (num ==2)
		{
			tag = "tag_passenger8";
		}
		else if (num ==3)
		{
			tag = "tag_passenger4";
		}
		//tank thread drawTagForever(tag, (0.9,0.2,0.2));
		self linkto (tank, tag, (0,0,0) , (0,0,0) );

		tank thread anim_loop_solo(self, "rider"+num, tag, "stoploop", tank);
		//tank setspeed (0,5,5);
		level waittill ("player_wokeup");
		tank notify ("stoploop");
		tank anim_single_solo(self, "lookaround"+num, tag, tank);
		tank thread anim_loop_solo(self, "rider"+num, tag, "stoploop", tank);
		wait 30;
		
		self delete();
		wait randomfloat(3);
		
		if (isdefined(tank))
		{
			tank vehicle_deleteme();
		}
}

ftn_walker3_setup()
{
	self solo_set_pacifist(true);
	self endon ("death");
	wait 2;
	spot = getstruct("ftn_walker4_spot", "targetname");
	self.animname = "ftn_walker";
	spot anim_single_solo(self, "dude4");
	self.animname = "ftn_walker_last";
	self anim_single_solo(self, "walk");
	
	self delete();
}

ftn_walker1_setup()
{
	self solo_set_pacifist(true);
	self endon ("death");
	self.animname = "ftn_walker_cross";
	wait 10;
	spot = getstruct("ftn_walker1_spot", "targetname");
	spot anim_single_solo(self, "walk");
	self.animname = "ftn_walker_last";
	self anim_single_solo(self, "walk");
	
	self delete();
}

ftn_walker_early_setup()
{
	self solo_set_pacifist(true);
	self endon ("death");
	self.animname = "ftn_walker_side";
	spot = getstruct("ftn_walker2_spot", "targetname");
	spot anim_single_solo(self, "walk");
	self.animname = "ftn_walker_last";
	self anim_single_solo(self, "walk");
	
	self delete();
}


ftn_walker2_setup()
{
	self solo_set_pacifist(true);
	self endon ("death");
	self.animname = "ftn_walker_side";
	wait 11.5;
	spot = getstruct("ftn_walker2_spot", "targetname");
	spot anim_single_solo(self, "walk");
	self.animname = "ftn_walker_last";
	self anim_single_solo(self, "walk");
	
	self delete();
}

ftn_walker4_setup()
{
	self solo_set_pacifist(true);
	self endon ("death");
	self.animname = "ftn_walker_last";
	wait 12;
	spot = getstruct("ftn_walker3_spot", "targetname");
	self set_run_anim("patrolwalk");
	//spot anim_reach_solo(self, "walk");
	spot anim_single_solo(self, "walk");
	//self.animname = "ftn_walker_last";
	//self anim_single_solo(self, "walk");
	
	self delete();
}

flamer_setup(time)
{
	self endon ("death");
	self disable_pain();
	self.ignoreme = true;
	self.health = 10000;
	if (!isdefined(time))
	{
		self thread wait_and_kill(60);
	}
	else 
	{
		self thread wait_and_kill(time);
	}
	self thread flamer_blow();
}

flamer_blow()
{
	while(1)
	{	
		self waittill ("damage", amount, attacker);
		if (isplayer(attacker))
		{
			break;
		}
	}
	if (isalive(self))
	{
		self enable_pain();
	}

	earthquake (0.2, 0.2, self.origin, 1500);
	playfx (level._effect["flameguy_explode"], self.origin+(0,0,50) );
	self.health = 50;
	allies = getaiarray("allies");
	allies[0] magicgrenade(self.origin+(-20,-25,20), self.origin, 0.01);	
	allies[0] magicgrenade(self.origin+(-25,-30,10), self.origin, 0.01);
	spot = self.origin;
	allies = getaiarray("allies");

	wait 0.1;
	if (isdefined(self) && isdefined(self.health) && self.health > 0)
	{
		self dodamage(self.health*10, self.origin);
	}
	wait 0.1;
	allies = getaiarray("allies");
	allies[0] MagicGrenadeType( "molotov", spot+(0,0,5), spot+(0,0,-1), 0.01);
}

other_flamers_setup()
{
	self waittill ("damage");
	self thread flamer_blow();
}	
	
e3_arguing_setup(num)
{
	self endon ("death");
	self.goalradius = 24;
	self solo_set_pacifist(true);
	self.animname = "officer_guard"+num;
	node = getstruct("e3_argue_spot", "targetname");
	//node thread delete_origins_afterfight();
	node anim_loop_solo(self, "talking_loop", undefined, "death");
}

e3_arguing_setup2(num)
{
	self endon ("death");
	self.goalradius = 24;
	self solo_set_pacifist(true);
	self.animname = "officer_guard"+num;
	node = getstruct("truckanim_ref_point", "targetname");
	//node thread delete_origins_afterfight();
	node anim_loop_solo(self, "talking_loop", undefined, "death");
}


e4_officer_setup()
{
	level.officer = self;
	level.officer.deathanim = undefined;
	level.officer.deathanim = level.scr_anim[ "officer" ][ "amsel_shot" ];
	
	level.officer animscripts\shared::placeweaponOn(level.officer.weapon, "none");
	thread officer_dead(self);
	self thread kill_bodyguard();
	self.health = 9999999;
	self disable_pain();
	self set_force_cover("hide");
	self.pacifist = true;
	self.ignoreall = true;
	self.ignoreme = true;
	self.animname = "officer";
	level notify ("setup_line_protection");
	node = getstruct("bodyguard_run_spot", "targetname");
	
	node thread anim_single_solo(self, "bodyguard_exit");
	flag_wait("officer_to_tank");
	level.officer stopanimscripted();
	level notify ("officer_2tank_safely");
	if (level.difficulty > 2)
	{
		flag_set("player_fired_in_e4");
	}
	self thread maps\sniper_event4::officer_run();	
	self thread hit_officer_again();
}

hit_officer_again()
{
	level endon ("officer_shot_incar");
	self waittill ("damage");
	wait 0.1;
	if (isdefined(self) && isdefined(self.health ) && self.health > 0)
	{
		level thread say_dialogue("grazed_him");
	}
}

officer_runto_cover(guy)
{
	level endon ("officer_2tank_safely");
	wait 0.1;
	guy waittill ("death");
	flag_set("officer_to_tank");
}

vehicle_riders_setup()
{
	self endon ("death");
	self.ignoreall = true;
	self solo_set_pacifist(true);
	wait 30;
	
	self delete();
}

driver_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	self.ignoreall = true;
	self.ignoreme = true;
	self animscripts\shared::placeweaponOn(self.weapon, "none");

	wait 0.5;
	horch = getent("horch", "targetname");
	self.health = 999999999;
	tag = "tag_driver";
	level.driver = self;
	level.driver.deathanim = level.scr_anim[ "driver" ][ "driver_death_loop" ];
	level.driver linkto(horch, tag,(0,0,0), (0,0,0) );
	level.driver.animname = "driver";
	horch thread anim_loop_solo(level.driver, "driver_under_fire", tag, "stoploop_driver", horch);
	node = getvehiclenode("stop_to_pickup_officer_node", "script_noteworthy");
	level thread maps\sniper_event4::driver_shot();
	node waittill ("trigger");
	horch setspeed (0,10000,10000);
	flag_set("car_ready_4_officer");
	level thread maps\sniper_event4::horch_come();
}

#using_animtree("vehicles");
horch_anim()
{
	node = getstruct("guards_talk_spot_original", "targetname");
	horch = getent("officer_horch", "targetname");
	horch.animname = "horch";
	horch stopanimscripted();
	node anim_single_solo(horch, "horch_drive");



}

officer_assistant_setup()
{
	self solo_set_pacifist(true);
	wait 0.5;
	horch = getent("officer_horch", "targetname");
	horch	playsound("drive_up"); 
	//thread horch_anim();
	tag = "tag_driver";
	org = horch gettagorigin (tag);
	ang = horch gettagangles (tag);
	spot = spawn("script_model", org);
	spot.angles = ang;
	
	spot linkto(horch, tag);
	self linkto(horch,tag);
	
	magic_org =  (488.808, 1732.27, 39.8829);	// the vehicle is leaning up on the sidewalk so using these to offset the origin

	//self thread horch_movetag(spot, tag, magic_org);
	
	self.animname = "assistant";
	animtime = getanimlength(level.scr_anim[self.animname][ "assistant_ride"]);
	self thread anim_single_solo(self, "assistant_ride"); 
	self animscripts\shared::placeweaponOn(self.weapon, "none");
	wait animtime -2.5;
	flag_set("takebullets");
	wait 2.5;
	
	self delete();
}

horch_movetag(spot, tag, magic_org)
{
	horch = getent("officer_horch", "targetname");
	node = getvehiclenode("car_inplace", "script_noteworthy");
	node waittill ("trigger");
	spot setmodel("tag_origin");
	


	wait 3;
	org = horch gettagorigin (tag);
	ang = horch gettagangles (tag);

	magic_ang =  (359.658, 359.2, 0.35109);

	spot unlink();
	self unlink();
	//spot.origin = org;
	//spot.angles	= magic_ang;
	self linkto (spot, "tag_origin");
	spot.origin = ( org[0], org[1], magic_org[2] );
	spot.angles	= magic_ang;
}



officer_setup()
{
	spot = getstruct("guards_talk_spot_original", "targetname");
	self solo_set_pacifist(true);
	wait 0.5;
	horch = getent("officer_horch", "targetname");
	horch.animname = "horch";
	spot thread anim_single_solo(horch, "horch_drive");
	
	tag = "tag_passenger";
	org = horch gettagorigin (tag);
	ang = horch gettagangles (tag);
	spot = spawn("script_model", org);
	
	spot linkto(horch, tag);
	self linkto(horch,tag);
	
	magic_org =  (514.5, 1741.42, 39.7239);	
	//self thread horch_movetag(spot, tag, magic_org);
		
	self.animname = "officer";
	self animscripts\shared::placeweaponOn(self.weapon, "none");
	self anim_single_solo(self, "officer_ride"); 
	spot delete();
	self delete();
}


alley_dudes2_setup()
{
	self waittill ("death", attacker);
	if (isplayer(attacker))
	{
		level.guys_onground_killed ++;
	}
	level.alleyguys_dead++;
}


e4_halftrack_guy_setup()
{
	self endon ("death");
	spot = getent("douchespot", "targetname");
	self setentitytarget(spot);
	if (level.difficulty < 2)
	{
		self thread wait_and_kill(120);
	}
}

e3_halftrack_mg_guy()
{
	self endon ("death");
	self thread mg_guy_reminder();
	if (level.difficulty == 1)
	{
		return;
	}
	self setthreatbiasgroup("badguys");
	self.ignoreme = true;
	while(level.difficulty == 2)
	{
		wait 5;
		if (cointoss() )
		{
			self setthreatbiasgroup("ignoreplayer");
			wait 5;
		}
	  self setthreatbiasgroup("badguys");		
	}
}

e5_halftrack_mg_guy()
{
	if (level.difficulty ==1)
	{
		self.pacifist = true;
		self.ignoreall = true;
		return;
	}
	self endon ("death");
	self setthreatbiasgroup("badguys");
	self.ignoreme = true;
	spot = getstructent("e5_halftrack_target", "script_noteworthy");
	while(!flag("officer_isincar") && !flag("officer_last_run") )
	{
		self setthreatbiasgroup("badguys");
		wait 5;
		if (level.difficulty ==2)
		{
			self setentitytarget(spot);
			wait 5;
			self clearentitytarget(spot);
		}
		if (level.difficulty ==1)
		{
			self dodamage(self.health *10, level.player.origin);
		}
	}
	if (level.difficulty ==2)
	{
		self dodamage(self.health *10, level.player.origin);
	}
}

mg_guy_reminder()
{
	self endon ("death");
	wait 10;
	while(1)
	{
		level thread say_dialogue("take_out_ht_mg");
		wait 40;
	}
}

player_only_enemy()
{
	self setthreatbiasgroup("badguys");
}
alleydudes4_setup()
{
	self setthreatbiasgroup("badguys");
}

e3_snipers_setup()
{
	self endon ("death");
	if (cointoss())
	{
		self thread player_only_enemy();
	}
	self thread wait_and_kill(randomintrange(40,70) );
	return;
}

firetest()
{
	self waittillmatch("fireanim", "fire");
	wait 1;
}

		//**TEMP will replace with mocapped vignette
e3_bb_finder1_setup()		// kicker
{
	self.pacifist = true;
	self.ignoreall = true;
	self.animname = "kicker";
	spot = getstructent("alleyguys_node", "targetname");
	spot anim_reach_solo (self, "g_ally_vig");
	level notify ("alley_kicker_inplace");
	animtime = getanimlength(level.scr_anim[self.animname][ "g_ally_vig"]);
	spot thread anim_single_solo (self, "g_ally_vig");
	wait animtime - 2.5;
	//self dodamage(self.health * 10, (0,0,0) );
}

e3_bb_finder2_setup()		// kickers friend
{
	self.pacifist = true;
	self.ignoreall = true;
	self.animname = "kickers_friend";
	spot = getstructent("alleyguys_node", "targetname");
	spot anim_reach_solo (self, "g_ally_vig");
	//flag_wait("alley_leader_animate");
	animtime = getanimlength(level.scr_anim[self.animname][ "g_ally_vig"]);
	spot thread anim_single_solo (self, "g_ally_vig");
	wait animtime - 2.5;
	//self dodamage(self.health * 10, (0,0,0) );
}	

e3_bb_finder3_setup()		// burner friend
{
	self.pacifist = true;
	self.dropweapon = false;
	self.ignoreall = true;
	self.animname = "burner";
	self.nodeathragdoll = true;
		
	spot = getstructent("alleyguys_node", "targetname");
	//spot anim_reach_solo (self, "g_ally_vig");
	animtime = getanimlength(level.scr_anim[self.animname][ "g_ally_vig"]);
	spot thread anim_single_solo (self, "g_ally_vig");
	wait animtime - 1.5;
	//self dodamage(self.health * 10, (0,0,0) );
}



alley_dudes1_setup()
{
	self solo_set_pacifist(true);
	self waittill ("death");
	level.alleyguys_dead++;
}

e3_patrolguy2_setup()
{
	level.tonyflamer = self;
	level endon ("fight!");
	self endon ("death");
	self.pacifist = true;
	self.animname = "generic";
	self set_run_anim("patrol_walk");
	node = getnode(self.target, "targetname");
	self thread flamer_setup(100);
	
	node anim_reach_solo(self, "patrol_turn180");
	animtime = getanimlength(level.scr_anim[self.animname][ "patrol_turn180"]);
	//node anim_single_solo(self, "patrol_turn180");
	//wait animtime - 0.05;
	//self stopanimscripted();
	//self thread anim_single_solo(self, "patrol_walk");
	//wait 0.05;
	//waittillframeend;
	//self stopanimscripted();
	nextnode = getnode(node.target, "targetname");
	nextnode anim_reach_solo(self, "patrol_idle_1_reach");
	wait 1;
	nextnode anim_loop_solo(self, "patrol_idle_1_loop", undefined, "death");
}

e3_patrolguy1_setup()
{
	level endon ("fight!");
	self endon ("death");
	self.pacifist = true;
	wait 0.5;
	self.animname = "generic";
	self set_run_anim("patrol_walk");
	self.old_sightdist = self.maxsightdistsqrd;
	self.maxsightdistsqrd = 262144;
	self thread maps\_patrol::patrol(self.target);
	node = getnode(self.target, "targetname");
	while(1)
	{
		self setgoalnode(node);
		nextnode = getnode(node.target, "targetname");
		self waittill("goal");
		node = nextnode;
	}
}


e3_dudes_chatter1_setup()
{
	self.animname = "e3_smoker1";
	self endon ("death");
	tpoint = getstruct("e3_right_guy_aim", "targetname");
	tpoint anim_loop_solo(self, "smoke_it", undefined, "death");

}
e3_dudes_chatter2_setup()
{
	self.animname = "e3_smoker2";
	self endon ("death");
	tpoint = getstruct("e3_right_guy_aim", "targetname");
	tpoint anim_loop_solo(self, "smoke_it", undefined, "death");
}

burning_building_shooters_setup()
{
	self solo_set_pacifist(true);
	mystring = "bb_shooter_";
	node = getnode(self.target, "targetname");
	
	self waittill ("goal");
	mynum = 0;
	for (i=1; i < 5; i ++)
	{
		if (node.targetname == mystring+"node"+i)
		{
			mynum = i;
		}
	}
	
	ospot = getstruct (mystring+"target"+mynum,"targetname");
	spot = ospot swap_struct_with_origin();
	
	self setentitytarget(spot);
	spot thread movespot_around( (50,0,randomint(10)), (-20,0,randomint(10)), 5); 
	flag_wait("player_on_bb_floor2");
	
	ospot = getstruct(mystring+"target"+mynum+"_floor2","targetname");
	spot2 = ospot swap_struct_with_origin();
	
	self setentitytarget(spot2);
	spot2 thread movespot_around( (50,0,randomint(10)), (-20,0,randomint(10)), 5); 
	spot2 thread maps\sniper_event2::delete_after_bb();
	spot delete();
}

mydog2_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	level waittill ("dog_go");
	trig = getent("playerin_bb_room1_trig", "targetname");
	if (get_players()[0] istouching(trig))
	{
		onode = getstruct("dog_bark_node2", "targetname");
		node = onode swap_struct_with_origin();

	}
	else
	{
		onode = getstruct("dog_bark_node", "targetname");
		node = onode swap_struct_with_origin();
	}
	mynode = getnode("dog_node", "script_noteworthy");
	self.animname = "dog";
	/*
	mynode anim_single_solo(self, "dog_walk");
	for(i=0; i < 7; i++)
	{
		self anim_single_solo(self, "dog_walk");
	}
	*/
	node anim_reach_solo(self, "fence_attack");
	
	animtime = getanimlength(level.scr_anim[self.animname][ "fence_attack"]);
	node thread anim_single_solo(self, "fence_attack");
	wait 0.2;
	flag_set("dog_found_you");
	self.goalradius = 32;
	wait animtime - 0.2;
	
	node delete();
	
	node = getnode("mydog2_lastnode","targetname");
	self setgoalnode(node);
	self waittill ("goal");
}

e1_flameguy_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	node = getnode(self.script_noteworthy+"_node", "targetname");
	self.goalradius = 32;
	self setgoalnode(node);
	wait 0.1;
	self waittill ("goal");
	
	ospot = getstruct(self.script_noteworthy+"_target", "targetname");
	spot = ospot swap_struct_with_origin();
	
	self.goalradius = 32;
	self setentitytarget(spot);
	spot moveto(spot.origin+(0,300,0), 5);
	wait 5;
	spot moveto(spot.origin+(0,-500,0), 5);
	wait 5;
	spot moveto(spot.origin+(0,300,0), 5);
	wait 5;
	spot moveto(spot.origin+(0,-500,0), 5);
	BadPlacesEnable(0);
	wait 5;

	
	node = getnode(self.script_noteworthy+"_end_node", "targetname");
	self.goalradius = 32;
	self.animname = "generic";
	self clearentitytarget();
	self solo_set_pacifist(true);
	wait 0.2;
	//node anim_reach_solo(self, "_stealth_behavior_saw_corpse");
	self setgoalnode(node);
	self waittill ("goal");
	BadPlacesEnable(1);
	spot delete();
	
	self delete();
}



charge_player_dudes()
{
	self endon ("death");
	self thread player_only_enemy();
	while(1)
	{
		self.goalradius = 128;
		self setgoalentity(get_players()[0]);
		wait 3;
	}
}

hunters()
{
	self endon ("death");
	wait 3;
	level.hero.ignoreme = false;
	//self setgoalentity(level.hero);
	level.hero.health = 2000;
	self.target = level.hero.targetname;
}

findbody_guy_setup()
{
	self endon ("death");
	node = getnode(self.script_noteworthy+"_node", "script_noteworthy");
	self.animname = "generic";
	self solo_set_pacifist(true);
	self set_run_anim("patrol_walk");
	self findbody_guy_foundbody(node);
	
	self stopanimscripted();
	self reset_run_anim();
	node = getnode("found_bodies_node", "script_noteworthy");
	node anim_reach_solo(self, "_stealth_find_jog");
	node thread anim_single_solo(self, "_stealth_find_jog");
	wait 2;
	level notify ("corpse_found");
	self thread sniper_stealth_ai_setup();
}

findbody_guy_foundbody(node)
{
	node anim_reach_solo(self, "_stealth_behavior_saw_corpse");
	node anim_single_solo(self, "_stealth_behavior_saw_corpse");
}


E2_halftrack_guys_setup()
{
	self solo_set_pacifist(true);
}


wounded_fountain_guys_setup()
{
	
	self endon ("death");
	self.ignoreme = true;
	self.ignoreall = true;
	self solo_set_pacifist(true);
	node = getstruct("fountain_reznov_align_spot", "targetname");
	self animscripts\shared::placeweaponOn(self.weapon, "none");
	mynum = 0;
	for (i=1; i < 4;i++)
	{
		
		if ("fountain_wounded_"+i == self.targetname)
		{
			mynum = i;
			self.animname = "fountain_woundedguy"+i;
			self.health = 1000;
			self playsound("fountain_guy_breathing_large_"+i);
			
			if ( is_german_build() && i!=3 )
			{
				node thread anim_loop_solo(self, "dead_loop", undefined, "stop_loop"+i);
				self.nodeathragdoll = true;
				self.deathanim = level.scr_anim[self.animname]["stay_dead"];
				flag_set("gunner_shoot_now_k");
				flag_wait("player_by_opening");
				node notify ("stop_loop"+i);
				self dodamage(self.health*10, (0,0,0));
				return;
			}
			if (i==3)
			{
				node thread anim_single_solo(self, "wounded");
				wait 12;
				self stopanimscripted();
				node thread anim_single_solo(self, "wounded");
				level waittill ("shooter_coming");
				self.name = undefined;
				self stopanimscripted();
				animtime = getanimlength(level.scr_anim[self.animname][ "wounded"]);
				node thread anim_single_solo(self, "wounded");
				level waittill ("shooting_time");
				self stopanimscripted();
			}
			else if (i==2)
			{	
				node thread anim_loop_solo(self, "wounded_loop", undefined, "stop_loop"+i);
				self.name = undefined;
				level waittill ("shooting_time");
				node notify ("stop_loop"+i);
			}
			
			else if (i==1)
			{	
				node fake_anim_loop(self, "wounded_loop", "stop_loop"+i);
				self.name = undefined;
				node notify ("stop_loop"+i);
			}

			self stopanimscripted();
			node anim_single_solo(self, "wounded");

			//node thread anim_loop_solo(self, "dead_loop", undefined, "stop_loop"+i);
		}
	}

	self.nodeathragdoll = true;
	self.deathanim = level.scr_anim[self.animname]["stay_dead"];
	node notify ("stop_loop"+mynum);
	self dodamage(self.health*10, (0,0,0));
}

fake_anim_loop(guy, anime, ender)
{

	self endon (ender);
	animtime = getanimlength(level.scr_anim[guy.animname][ anime]);
	level.woundedlooptime = animtime;
	while(!flag("gunner_ready_toshoot") )
	{
		level thread wounded_looptime_count(animtime);
		self anim_single_solo(guy, anime);
	}
	flag_set("gunner_shoot_now_k");
}

wounded_looptime_count(mytime)
{
	level notify ("stop_looptime_count");
	level endon ("stop_looptime_count");
	level.woundedloopcount = 0;
	while(1)
	{
		level.woundedloopcount = level.woundedloopcount + 0.05;
		wait 0.05;
		if (level.woundedloopcount >= mytime)
		{
			break;
		}
	}
}
		
dog_setup()
{
	self endon ("death");
	self.pacifist = true;
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	self.health = 1;
	self.ignoreall = true;
	handler = grab_ai_by_script_noteworthy("dog_handler", "axis");
	if (isdefined(handler))
	{
		handler waittill_either ("death", "alerted");
	}
	self.pacifist = false;
	self.ignoreall = false;
	self set_goal_entity(get_players()[0]);
	
	wait 1;
	//TUEY SetMusic to DOG
	setmusicstate("DOG");
	wait 1;
	level notify ("stop_talking");
	waittillframeend;
	level thread say_dialogue("dog");
	while(1)
	{
		if (self.origin[1]< 750)
		{
			level.player allowstand(true);
			level.e1_timing_feedback = "could_b_quicker";
			level.e1_timing_feedback_time = 5;
			level notify ("dog_on_u");
		}
		wait 0.1;
	}
	
}

dog_handler_setup()
{
	self endon ("death");
	self.allowdeath = true;
	self.goalradius = 24;
	self thread reznov_killed_streetguys(); // makes sure reznov doesn't kill guys and allow player to get cheev
	
	self solo_set_pacifist(true);
	wait 1;
	node = getstruct("streetnode", "targetname");
	self.animname = "dog_handler";
	
	animtime = getanimlength(level.scr_anim[self.animname][ "find_body"]);
	node anim_reach_solo(self, "find_body");
	node thread anim_single_solo(self, "find_body");
	wait 1;
	level thread say_dialogue("straight");
	wait animtime -1;
	self solo_set_pacifist(false);
	self notify ("alerted");
	self set_goal_entity(get_players()[0]);
}
	
fountain_shooter()
{
	self endon ("death");
	self solo_set_pacifist(true);
	node = getvehiclenode("bring_gunner", "script_noteworthy");
	node waittill ("trigger");
	level notify ("shooter_coming");
	thread spawn_walker();
	wait 5;
	flag_set("gunner_ready_toshoot");
	flag_wait("gunner_shoot_now_k");
	level notify ("shooting_time");
	spot = getstruct("fountain_reznov_align_spot", "targetname");
	self.animname = "gunner";

	//spot anim_reach_solo(self, "gun_dudes");
	mylength = getanimlength(level.scr_anim[self.animname][ "gun_dudes"]);
	
	level thread wait_and_setflag(9,"crow_flyaway");
	
	spot thread anim_single_solo(self, "gun_dudes");
	wait mylength -7;
	wait 7;
	
	self delete();
}

spawn_walker()
{
	getent("ftn_walker2", "script_noteworthy") stalingradspawn();
	getent("ftn_walker4", "script_noteworthy") stalingradspawn();
	
}

E2_blockofficerb_guys_setup()
{
	self endon ("death");
	self.animname = "generic";

	mywalk = random_walk();
	self set_run_anim( mywalk );
	self thread sniper_stealth_ai_setup();
	self thread waittill_flag_anddie("kill_fannout_guys");
}

first_sniper_setup()
{
	self.deathanim = level.scr_anim["sniper1"]["sniper_death"]; 
	self.animname = "sniper1";
	level.e2sniper = self;
	//self set_run_anim("sneaky_walk1");
	self endon ("death");
	self.ignoreall = true;
	self set_force_cover("hide");
	thread die_and_notify(self, "e2_sniper_dead");
	self solo_set_pacifist(true);
	self.goalradius = 1;
	self.health = 10000;
	nodes = getnodearray(self.script_noteworthy+"_hide_nodes", "script_noteworthy");
	nodenum = randomintrange(1, nodes.size);
	self.nodenum = nodenum;
	node = getnode(self.script_noteworthy+"_pos_"+nodenum, "targetname");
	self thread maps\_spawner::go_to_node(node);
	level.e2sniper.currentnum = nodenum;
	level.e2sniper.currentnode = node;
	breakloop = 0;
	self waittill ("goal");
	self.goalradius = 1;
	wait 1;
	
	animspot = spawn("script_origin", node.origin+(0,0,8.865));
	animspot thread maps\sniper_event2::animspot_cleaner();
	animspot.angles = node.angles;
	level.e2sniper.animname = "sniperR";
	animspot.origin = node.origin+(0,0,8.865);
	animspot thread anim_loop_solo(level.e2sniper, "idle_R", undefined, "stopidle");
	level.lastanimspot = animspot;	
	
	//self lookat(spot, 0.5);
	self solo_set_pacifist(true);
	hittimes = 2;
	hitmax = level.difficulty;
	while(breakloop ==0)
	{
		self waittill ("damage", amount, attacker);
		players = get_players();
		for (i=0; i < players.size; i++)
		{
			if (attacker==players[i])
			{
				hittimes++;
				if (hittimes > hitmax)
				{
					deathspot = spawn("script_origin", self.origin+(0,0,-10) );
					level thread wait_and_delete(deathspot, 10);
					self stopanimscripted();
					deathspot.angles = (0,270,0);
					self.animname = "sniper1";
					//deathspot thread anim_single_solo("sniper_death");
					self.deathanim = level.scr_anim["sniper1"]["sniper_death"]; 
					deathspot thread anim_single_solo(self, "sniper_death");
					waittillframeend;
					self dodamage(self.health*10, level.player.origin);
				}
				else 
				{
					level thread sniper1_grazed_dialogue();
				}
			}
		}
	}
}

sniper1_grazed_dialogue()
{
	lines = [];
	lines[0] = "winged_him";
	lines[1] = "grazed_him";
	while(1)
	{
		line = lines[randomint(lines.size)];
		if (!isdefined(level.last_grazed_line) || ( isdefined(level.last_grazed_line) && level.last_grazed_line != line) )
		{
			level thread say_dialogue(line);
			level.last_grazed_line = line;
			break;
		}
		wait 0.05;
	}
}

lookout_guy1_setup()
{
	self endon ("death");
	self solo_set_pacifist(true);
	self.animname = "bino_guy";
	node = getnode(self.script_noteworthy+"_node", "targetname");
	wait randomfloat(0.5);
	node anim_loop_solo(self, "bino_loop", undefined, "death");
}

lookout_guy2_setup()
{
	self endon ("death");
	self.animname = "generic";
	node = getnode(self.script_noteworthy+"_node", "targetname");
	node anim_loop_solo(self, "patrol_idle_1_loop", undefined, "death");
}

sentry_1_setup()
{
	self endon ("death");
	self.ignoreall = true;
	self solo_set_pacifist(true);
	self.goalradius = 24;
	self.health = 1;
	onode = getstruct(self.script_noteworthy+"_anim", "targetname");
	node = onode swap_struct_with_origin();
	
	self.animname= "ftn_walker_last";
	//self set_run_anim("walk");
	animtime = getanimlength(level.scr_anim[self.animname][ "walk"]);
	node thread anim_single_solo(self, "walk");
	wait animtime - 0.1;
	//self anim_single_solo(self, "walk");
	node thread wait_and_delete(node, 1);
	
	self delete();

}

e2_mean_patrollers_setup()
{
	level endon ("bb_escape_ison");
	self.animname = "generic";
	self solo_set_pacifist(true);
	wait randomfloat(0.95);
	num = randomintrange(1,4);
	self set_run_anim("_stealth_combat_jog");
	self endon ("death");
	self endon ("enemy");
	self.goalradius = 64;
	name = self.target;
	self waittill ("goal");
	self dodamage(self.health *10, (0,0,0) );

}


halftrack2_riders_setup()
{
	self endon ("death");
	self.goalradius = 24;
	self solo_set_pacifist(true);
}


make_russian_squad()
{
	self setthreatbiasgroup("russian_squad");
}


							///////////////////////////////////End Spawn Function Section\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


