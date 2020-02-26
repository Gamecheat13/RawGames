#include common_scripts\utility;
#include maps\_utility;
#include maps\oki3_util;
#include maps\_music;

main()
{
	level thread init_courtyard_destruction();
	level thread courtyard_north_spawners();
	level thread courtyard_objectives();
	level thread underground_bigroom_1();
	level thread underground_bigroom_2();
	level thread building_l_spawners();
	level thread underground_spawners_1();
	level thread underground_spawners_2();
	level thread underground_exit_spawners();
	level thread courtyard_too();
	level thread courtyard_castle_spawners();
	level thread init_courtyard_envfx();
	level thread air_support_objective();
	level thread fake_surrender_guys();
	level thread setup_surrender_dialogue();
	level thread courtyard_dialog_think();
	level thread downstairs_dialog();
	level thread courtyard_upstairs_dialog();
	level thread airstrike_radio_dialogue();
	
	
	//setting up the turret this way makes it so the AI won't jump off the MG
//	turret = getent("courtyard_mg2","targetname");
//	turret setturretignoregoals( true );
}

downstairs_dialog()
{

	trigger_wait("dialog_downstairs","targetname");
	level.sarge do_dialogue("downstairs");
	battlechatter_off("axis");
	battlechatter_off("allies");
	
}

courtyard_upstairs_dialog()
{
	
	trigger_wait("spawn_above_guys","targetname");
	simple_spawn("courtyard_hole2_guys");
	wait(3);
	if(randomint(100)>50)
	{
		level.sarge do_dialogue("above_us");
	}
	else
	{
		level.sarge do_dialogue("up_above");
	}
}

courtyard_objectives()
{
	
	objective_add(6,"current",&"OKI3_OBJ1");
	objective_position(6,(8203, -2236, 157));
	getent("planter_door_end","targetname") notify("trigger");
	
	trigger_Wait("stairs_down_objective","targetname");

	objective_position(6,(8424, -6856, 122));
	
	trigger_wait("secure_courtyard_drop_objective","targetname");
	objective_add(6,"current",&"OKI3_OBJ7",(7321, -5726, 139));
	//level thread courtyard_mg_stuff();
	
	level thread monitor_volume_for_enemies("drop_volume","drop_secured","enter_courtyard");
	level waittill("drop_secured");

	objective_state(6,"done");
	objective_add(7,"current",&"OKI3_OBJ8_A");
	
	//getent("enter_courtyard","targetname") notify("trigger");
	
	house_guys_playerseek();	
}


/*------------------------------------
guys who may be in the house after the player enters the courtyard will rush out 
------------------------------------*/
house_guys_playerseek()
{
	guys = getentarray("house_guys","targetname");
	for(i=0;i<guys.size;i++)
	{
		guys[i] SetGoalEntity( get_closest_player(guys[i] .origin) ); 
		guys[i] thread rush_player();
	}	
}

/*------------------------------------
Gives the players the airstsrike
------------------------------------*/
give_air_strike()
{
	
	self endon("death");
	self endon("disconnect");
	
	wait(45);

	self giveweapon("air_support");		
	level.rocket_barrage_allowed = true;
	self SetActionSlot( 4, "weapon", "air_support" );	
	self setweaponammostock("air_support",0);
	self SetWeaponAmmoClip( "air_support", 1 );
	
	self thread monitor_radio_usage();
	self thread air_strike_user_notify();	
	level notify("_airsupport");
}


/*------------------------------------
monitor the radio usage so that only one 
player can use the air support at a time
------------------------------------*/
monitor_radio_usage()
{
	self endon("death");
	self endon("disconnect");
	
	while(1)
	{
		self waittill("weapon_change");
		if(self getcurrentweapon() == "air_support")
		{
			available = is_radio_available(self);
			if(!available)
			{
				self thread hud_radio_in_use();
				self maps\oki3_dpad_asset::air_support_switch_back();
				self notify("end rocket barrage targeting");	
				self maps\oki3_dpad_asset::delete_spotting_target();
			}
		}		
		wait_network_frame();		
	}
}

/*------------------------------------
show some text if the radio is used
------------------------------------*/
hud_radio_in_use()
{
	self endon("death");
	self endon("disconnect");
	
	text = &"OKI3_RADIO_INUSE";
	
	self setup_client_hintelem();
	self.hintelem setText(text);
	wait(3.5);
	self.hintelem settext("");
	
}



/*------------------------------------
handles the objectives while the player
is calling in the airstrikes
------------------------------------*/
air_support_objective()
{
	level waittill("_airsupport");
	
	//battlechatter_off("allies");
	level.last_hero do_dialogue("available" + randomint(4));	
	
	wait(.5);		
	level.last_hero do_dialogue("call_in_planes");
	wait(.5);
	level.last_hero do_dialogue("kingdom_come");	
	//battlechatter_on("allies");
	
	objective_add(9,"current",&"OKI3_OBJ8",(7858, -2737.5, 558.5));
	objective_icon(9,"hud_icon_airstrike");
	wait(1);	
	level thread air_support_nag();	
}


/*------------------------------------
takes care of the nag dialogue which 
tells the player to call in the airstrikes
------------------------------------*/
air_support_nag()
{
	guy = undefined;	
	dialog = [];
	
	if(isalive(level.polonsky))
	{
		guy = level.polonsky;
	}
	if(isAlive(level.sarge))
	{
		guy = level.sarge;
	}
	
	if(guy == level.polonsky)
	{	
		dialog[0] = "airstrike_now";
		dialog[1] = "do_it_planes";
		dialog[2] = "need_airstrike";
	}
	
	else if(guy == level.sarge)
	{
		dialog[0] = "airstrike_now";
		dialog[1] = "call_planes_miller";
		dialog[2] = "need_airstrike";
	}
		
	//nag the player to strike the northern buildings
	tick = 0;
	while(!isDefined(level.north_buildings_targeted))
	{
		wait(.5);
		tick++;
		if(tick >30 && !isDefined(level.no_nag_dialogue))
		{
			guy do_dialogue( dialog[randomint(dialog.size)]);
			if(randomint(100)>50)
			{
				if(randomint(100) >50)
				{
					guy do_dialogue( "to_north");
				}
				else
				{
					guy do_dialogue( "north_ofhere");
				}
			}
			tick = 0;
		}
	}
		
	//nag the player to take out the castle building
	while(1)
	{
		if(isDefined(level.nag_castle))
		{
			break;
		}
		wait(1);
	}	
	
	tick = 0;
	while(!isDefined(level.castle_targeted))
	{
		wait(.5);
		tick++;
		if(tick >30 && !isDefined(level.no_nag_dialogue))
		{
			guy thread do_dialogue( dialog[randomint(dialog.size)]);
			
			if(randomint(100)>50)
			{
				if(randomint(100) >50)
				{
					guy do_dialogue( "to_east");
				}
				else
				{
					guy do_dialogue( "east_ofhere");
				}
			}
			
			tick = 0;
		}
	}
	level notify("stop_grenades");
	wait(5);
	
//	players = get_players();
//	if(players.count > 1)
//	{
		level thread magic_grenades_from_hell();
//	}
	
	//and another to finish it off
	wait(15);
	
	tick = 0;		
	while(!isDefined(level.castle_targeted_2))
	{
		wait(.5);
		tick++;
		if(tick >30 && !isDefined(level.no_nag_dialogue))
		{
			guy thread do_dialogue( dialog[randomint(dialog.size)]);
			tick = 0;
		}
	}	
	level notify("stop_grenades");
	
	while(!isDefined(level.castle_destroyed))
	{
		wait_network_frame();
	}
	
	
	objective_state(7,"done");	
	objective_state(10,"done");
	
	final_banzai_charge();
	
	//turn off the throwable mortars after the objectives are done
	getent("use_mortars_courtyard","targetname") trigger_off();
	getent("use_mortars_courtyard","targetname") notify ("stop_thinking");
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if(players[i]  getcurrentweapon() == "mortar_round")
		{
			players[i] takeweapon("mortar_round");
			primaryWeapons = players[i] GetWeaponsListPrimaries();
			if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
			{
				players[i] SwitchToWeapon( primaryWeapons[0] );
			}
		}
		if(!isDefined(players[i].magic_bullet_shield))
		{
			players[i] thread magic_bullet_shield();
		}
		players[i] takeweapon("fraggrenade");
		players[i] takeweapon("type97_frag");
		players[i] takeweapon("m8_white_smoke");
	}	
	
	wait(2);
	guy do_dialogue("dam");	
	wait(1);	

	if(guy == level.polonsky)
	{
		//TUEY Set Music State to END_LEVEL_POLONSKY
		setmusicstate("END_LEVEL_POLONSKY");
	}
	if(guy == level.sarge)
	{
		//TUEY Set Music State to END_LEVEL_ROEBUCK
		setmusicstate("END_LEVEL_ROEBUCK");
	}

	guy do_dialogue("we_did_it");
	wait(1);
	guy do_dialogue("its_over");
	wait(1);
		
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(2);
	}
	thread maps\oki3_util::disable_player_weapons();
	wait(2);	
	//clean up any stragglers just in case
	axis = getaiarray("axis");
	for(i=0;i<axis.size;i++)
	{
		axis[i] delete();
	}
	//setsaveddvar("miniscoreboardhide","1");
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread player_prevent_bleedout();
		players[i] thread outro_delete_grenade();
		players[i] setclientdvar("miniscoreboardhide","1");
		players[i] setclientdvar("compass","0");
		players[i] SetClientDvar( "hud_showStance", "0" ); 
		players[i] SetClientDvar( "ammoCounterHide", "1" );		
		players[i] DisableOffhandWeapons();
		players[i] thread hud_fade_in(1.5);		
	}
	
	//start the outro
	thread maps\oki3_anim::oki3_outro_2();
	//level thread maps\oki3_anim::play_outro_dialogue();
	//make sure nobody can die , or blow stuff up during the outro
	wait(.15);
	level notify("do_outro");
}


clean_middle_ai()
{
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if( isAlive(ai[i]) && ai[i].origin[1] < 6318.5)
		{
			ai[i] thread random_death(3,10);
		}
	}
	
}

/*------------------------------------
after the castle is blown up, any remaining guys go into banzai mode
------------------------------------*/
final_banzai_charge()
{
	level notify("stop_castle_spawners");	
	level notify("stop_upper");
	level notify("stop_back");
	level notify("b1_spawners");
	
	wait(3);	
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		ai[i] thread bloody_death(true,randomint(4));
	}
	wait(2);
}

//
//get_ai_in_area(tl,br)
//{
//	ai = getaiarray("axis");
//	
//	for(i=0;i<ai.size;i++)
//	{
//		guy = ai[i];
//		
//		//guy should not be alive anyways if he is outside of this area
//		if( guy.origin[0] < tl[0] || guy.origin[1] > tl[1] || guy.origin[0] > br[0] || guy.origin[1] < br[1])
//		{
//			guy delete();
//		}
//		else
//		{
//			guy.banzai_no_wait = 1;
//			guy thread maps\_banzai::banzai_force();
//		}		
//	}
//	
//	while(1)
//	{
//		wait(1);
//		ai = getaiarray("axis");
//		if(ai.size < 1)
//		{
//			break;
//		}		
//	}	
//}

/*------------------------------------
override the wind settings for the courtyard
so that the smoke drifts innwards towards the 
area where the players are
------------------------------------*/
init_courtyard_envfx()
{

	exploder(1100);
	exploder(500);	
	
	ent1 = spawn("script_model",(7137, -3138, 91));
	ent2 = spawn("script_model",(8767 ,-5283, 45));
	ent1 setmodel("tag_origin");
	ent2 setmodel("tag_origin");
	ent1.angles =(277.5, 90 ,-6.81);
	ent2.angles =(277.5, 90, -6.81023);
	
	forward = anglestoforward(ent1.angles);	
	forward2 = anglestoforward(ent2.angles);
	playfxontag(level._effect["after_mortars"],ent1,"tag_origin" );
	playfxontag(level._effect["after_mortars"],ent2,"tag_origin" );

}


/*------------------------------------
For fx artist to see damage states on the courtyard
buildings
------------------------------------*/
dvar_watcher()
{
	/#
	
	while(1)
	{
		if(getdvarint("oki3_courtyard") == 1 )
		{
			
			if(getdvarint("show_1") == 1)
			{
				show_damaged(1,1);
				hide_intact(1);
			}
			else
			{
				hide_damaged(1);
				show_intact(1);
			}	
			
			if(getdvarint("show_2") == 1)
			{
				show_damaged(2,1);
				hide_intact(2);
			}
			else
			{
				hide_damaged(2);
				show_intact(2);
			}
			if(getdvarint("show_3") == 1)
			{
				show_damaged(3,1);
				hide_intact(3);
			}
			else
			{
				hide_damaged(3);
				show_intact(3);
			}
			
			if(getdvarint("show_4") == 1)
			{
				show_damaged(4,1);
				hide_intact(4);
				hide_damaged(4,2);
			}
			else if(getdvarint("show_4") == 2)
			{
				hide_intact(4);
				hide_damaged(4,1);
				show_damaged(4,2);
			}
			else if(getdvarint("show_4") == 3)
			{
				hide_intact(4);
				hide_damaged(4,1);
				hide_damaged(4,2);
				show_damaged(4,3);
			}
			else
			{
				show_intact(4);
				hide_damaged(4,1);
				hide_damaged(4,2);
				hide_damaged(4,3);
			}
			
			if(getdvarint("show_5") == 1)
			{
				show_damaged(5,1);
				hide_intact(5);
			}
			else
			{
				hide_damaged(5);
				show_intact(5);
			}
			
			if(getdvarint("show_6") == 1)
			{
				show_damaged(6,1);
				hide_intact(6);
			}
			else
			{
				hide_damaged(6);
				show_intact(6);
			}
			
			if(getdvarint("show_7") == 1)
			{
				show_damaged(7,1);
				hide_intact(7);
			}
			else
			{
				hide_damaged(7);
				show_intact(7);
			}
			
			if(getdvarint("show_11") == 1)
			{
				show_damaged(11,1);
				hide_intact(11);
			}
			else
			{
				hide_damaged(11);
				show_intact(11);
			}
			
			if(getdvarint("show_12") == 1)
			{
				show_damaged(12,1);
				hide_intact(12);
			}
			else
			{
				hide_damaged(12);
				show_intact(12);
			}	
			
			if(getdvarint("show_front_anim") == 1)
			{
				level thread show_fall();
			}
			
			if(getdvarint("mortar_1") == 0)
			{
				level thread show_bunker_damage(0);
			}
			else if( getdvarint("mortar_1") == 1)
			{
				level thread show_bunker_damage(1);
			}
			else if( getdvarint("mortar_1") == 2)
			{
				level thread show_bunker_damage(2);
			}
			if(getdvarint("mghut") == 0)
			{
				level thread hide_mghut_dmg();
			}
			else if( getdvarint("mghut") == 1)
			{
				level thread show_mghut_dmg();
			}
			

		}
		wait(1);
	}
	#/

}


hide_mghut_dmg()
{
	
	mg_intact = getent("mortarpit_mghut_intact","targetname") ;
	mg_damage1 = getent("mortarpit_mghut_wrecked","targetname");
	
	mg_damage1 hide();
	mg_damage1 notsolid();
	
	//chunks
	chunks = [];
	chunks[0] = getent("mortarpit_mghut_wrecked_chunk_1","script_noteworthy");
	chunks[1] = getent("mortarpit_mghut_wrecked_chunk_2","script_noteworthy");
	chunks[2] = getent("mortarpit_mghut_wrecked_chunk_3","script_noteworthy");
	chunks[3] = getent("mortarpit_mghut_wrecked_chunk_4","script_noteworthy");
	chunks[4] = getent("mortarpit_mghut_wrecked_chunk_5","script_noteworthy");
	chunks[5] = getent("mortarpit_mghut_wrecked_chunk_6","script_noteworthy");
	
	for(i=0;i<chunks.size;i++)
	{
		chunks[i] hide();
	}
	
	curtains = getent("event1_mg_curtains","targetname");
	mg = getent("auto4051","targetname");
	mg_intact show();
	
}

show_mghut_dmg()
{
	
	mg_intact = getent("mortarpit_mghut_intact","targetname") ;
	mg_damage1 = getent("mortarpit_mghut_wrecked","targetname");
	
	mg_intact hide();
	mg_damage1 show();
	
	//chunks
	chunks = [];
	chunks[0] = getent("mortarpit_mghut_wrecked_chunk_1","script_noteworthy");
	chunks[1] = getent("mortarpit_mghut_wrecked_chunk_2","script_noteworthy");
	chunks[2] = getent("mortarpit_mghut_wrecked_chunk_3","script_noteworthy");
	chunks[3] = getent("mortarpit_mghut_wrecked_chunk_4","script_noteworthy");
	chunks[4] = getent("mortarpit_mghut_wrecked_chunk_5","script_noteworthy");
	chunks[5] = getent("mortarpit_mghut_wrecked_chunk_6","script_noteworthy");
	
	for(i=0;i<chunks.size;i++)
	{
		chunks[i] hide();
	}
	
	curtains = getent("event1_mg_curtains","targetname");
	mg = getent("auto4051","targetname");
	curtains show();
	mg show();
	
}



show_bunker_damage(num)
{
	
	intact = getent("mortar_house_intact","targetname") ;

	damage2 = getent("mortar_house_damage_2","targetname");
	damage3 = getent("mortar_house_damage_3","targetname");	

	bits = getent("mortar_house_damage_delete","targetname");

	
	//clipper = getent("mortar_house_clip","targetname");
	//trig = getent("mortar_house_dmg","targetname");	
	
	dmg2 = false;
	dmg3 = false;
	switch(num)
	{
		case 0:
			damage2 hide();
			damage3 hide();
			intact show();
			break;
		
		case 1:
			damage2 show();
			damage3 hide();
			intact hide();
			break;
		case 2:
			damage2 hide();
			damage3 show();
			intact hide();
			level thread show_bunker_explode();	
	}
}

show_bunker_explode()
{
	if(!isDefined(level.is_exploding))
	{
		level.is_exploding = true;
		//d_bits = getent("mortar_house_damage_delete","targetname");
		if(!isDefined(level.anim_setup_complete))
		{
			maps\oki3::setup_mortarhut_anim();
			level.anim_setup_complete = true;
		}
		
		//level.mortarhut_pieces maps\_anim::anim_single_solo(level.mortarhut_pieces,"explode");
		level.mortarhut_pieces SetFlaggedAnimKnobRestart( "pit_explodes", level.scr_anim["mortarpit_bunker"]["explode"], 1.0, 0.05, 1.0 );
		
		bigbits = getentarray("bigbits","script_noteworthy");
		loose_boards = getentarray("loose_boards","script_noteworthy");
	
		
		//level.mortarhut_pieces delete();
		
		//d_bits hide();	
		wait(10);
		level.is_exploding = undefined;
	}
}



show_fall()
{
	if(!isDefined(level.is_falling))
	{
		level.is_falling = true;
		castle_front_fall();
		wait(10);
		level.is_falling = undefined;
	}
}

init_courtyard_destruction()
{
	
	
	level thread courtyard_dragon_falls();
	
	//hide damage states	
	hide_damaged(1,1);
	hide_damaged(2,1);
	hide_damaged(3,1);
	hide_damaged(4,1);
	hide_damaged(4,2);
	hide_damaged(4,3);
	
	hide_damaged(5,1);
	hide_damaged(6,1);
	hide_damaged(7,1);	
	hide_damaged(11,1);
	hide_damaged(12,1);
	
	
	//show non damaged states
	show_intact(1);
	show_intact(2);
	show_intact(3);	
	show_intact(4,1);
	show_intact(5,1);
	show_intact(6);

	show_intact(7);	
	show_intact(11);
	show_intact(12);
	
}
/*------------------------------------
guys reinforce from the north side of the courtyard
------------------------------------*/
courtyard_north_spawners()
{
		
	getent("start_final_defend","script_noteworthy") waittill("trigger");
	
	//they throw smoke before they attack	
	level thread courtyard_prespawn_smoke(850,900,"nw_smoke");
	wait(7);
	
	//TUEY sets music state to "COURTYARD_A
	setmusicstate("COURTYARD_A");
	
	//modifies the behavior of squad manager to use waves and additional squads...probably overly complex but it works
	level thread squad_manager_think("nf_spawn","north_front_spawners","b1_spawners","building1_front_spawners_threshold","building1_front_spawners",true,true,true);
	level thread squad_manager_think("nb_spawn","north_back_spawners","b1_spawners","building1_back_spawners_threshold","building1_back_spawners",true,true);
		
	//guys come out of building1/11
	level thread maps\oki3_squad_manager::manage_spawners("building1_back_spawners",2,4,"b1_spawners",.5, ::spawnfunc_rear_support,5,undefined,"nb_spawn");
	level thread maps\oki3_squad_manager::manage_spawners("building1_front_spawners",3,7,"b1_spawners",.5, ::spawnfunc_front_line,7,undefined,"nf_spawn");
	
	//spawns a wave of banzai guys behind the smoke to kick off the event
	wait(5);
	playsoundatposition("japanese_yell_left",(6742,-3871,130));
	playsoundatposition("japanese_yell_right",(8671, -3960, 54.7)); 
	wait(1);
	thread spawn_banzai_wave((7216,-4500,50));
	level notify("do_dialog","generic_fight0",level.last_hero);
	
	//this thread watches guys on the front line, and will 
	//peel off groups of guys to banzai charge the players
	level thread front_line_spawner_think();
	
	//handles the dialogue regarding targets being hit/missed
	level thread airstrike_radio_dialogue();
	
	//gives each player the airstrike weapon
	players = get_players();
	array_thread(players,::give_air_strike);
	
	//wait some time then spawn in the MG guy
	wait(15);
	simple_spawn("north_MG_gunner",::north_mg_gunner);
	
	//make sure the magic grenades are stopped
	level notify("stop_grenades");
	//more guys come out of the northern buildings
	wait(5);
	level thread maps\oki3_squad_manager::manage_spawners("building2_back_spawners",2,4,"b1_spawners",.5, ::spawnfunc_rear_support,5);
	level thread maps\oki3_squad_manager::manage_spawners("building2_front_spawners",3,6,"b1_spawners",.5, ::spawnfunc_front_line,7);
	level thread maps\oki3_squad_manager::manage_spawners("building2_back_sniper",1,1,"b1_spawners",1,undefined,5);
	
	// magic grenades rain down on the players if they don't complete their objective in a timely manner
	//only do this in co-op	to prevent exploiting arcademode
//	players = get_players();
//	if(players.count > 1)
//	{
		level thread magic_grenades_from_hell();
//	}
	
	//wait till the building is destroyed	, update objectives and shut down spanwers
	level waittill("building1_destroyed");
	level notify("b1_spawners");
	objective_state(8,"done");
	objective_state(9,"done");
	objective_add(10,"current",&"OKI3_OBJ9",(9223.5, -4690, 742));
	objective_icon(10,"hud_icon_airstrike");
	autosave_by_name("building1_destroyed");
			
}

courtyard_dialog_think()
{
	level endon("stop_dialog");
	
	while(1)
	{
		level waittill("do_dialog",dialog,guy);
		//battlechatter_off();
		guy do_dialogue(dialog);
		wait(.25);
		//battlechatter_on();		
	}
}


banzai_wave_spawner_think(location,ender)//location,ender,wave_min,wave_max,time_min,time_max)
{
	level endon(ender);
	
	org1 = [];
	org2 = [];
	wave_loc = undefined;
	switch(location)
	{
		case "north":
			
			//org1[org1.size] = (7611,-4831,104);
			//org2[org2.size] = (7227, -4857, 44);
			org1[org1.size] = (7536, -4984, 104);
			org2[org2.size] = (7128, -5040, 104);
						
			wave_loc = (7216,-4500,50);
			break;	
		
		case "south":
			org1[org1.size] = (7866, -5227, 57);
			org2[org2.size] = (8209, -5859, 47.3);
			org1[org1.size] = (8056, -5337, 38);
			org2[org2.size] = (8347, -5943, 55.3);
			wave_loc = (8504, -5332, 55.8);
			break;
			
	
	}
	
	
	while(1)
	{	
		wait(40);
		rnd = randomint(org1.size);
		ent1 = spawn("script_origin",org1[rnd]);
		ent2 = spawn("script_origin",org2[rnd]);
		
		ent1 MagicGrenadeType( "m8_white_smoke_light",ent1.origin ,(0,0,-1), .05 );
		ent2 MagicGrenadeType( "m8_white_smoke_light",ent2.origin ,(0,0,-1), .2 );
		wait(8);
		thread spawn_banzai_wave(wave_loc);
		wait(8);
		spawn_banzai_wave(wave_loc);
		ent1 delete();
		ent2 delete();
	}
}

north_mg_gunner()
{
	self endon("death");
	
	self setcandamage(false);
	turret = getent("north_MG","targetname");
	turret setturretignoregoals( true );
	
	level waittill("building1_destroyed");
	self setcandamage(true);
	self random_death(.2,.5);	
}


courtyard_castle_spawners()
{
	level waittill("building1_destroyed");
	wait(10);
	level thread courtyard_prespawn_smoke(850,900,"building5_smoke");
	wait(3);	
	getent("defend_south","targetname") notify("trigger");		
	wait(10);
	
	thread spawn_banzai_wave( (8481, -5723, 104) );
	playsoundatposition("japanese_yell_left",(9055,-3704,85));
	playsoundatposition("japanese_yell_right",(8760,-5864,104)); 
	
	//thread banzai_wave_spawner_think("south","stop_castle_spawners");
	
	level thread front_line_spawner_think();
	
	//doors on the castle open
	level thread open_door("se_door1","r",true,"se_door1_trig");
	level thread open_door("se_door2","r",false,"se_door2_trig");
	//level thread open_door("ne_door1","r",false,"ne_door1_trig");
	level thread open_door("ne_door2","r",true,"ne_door2_trig");
	
	
	level thread squad_manager_think("sf_spawn","southeast_front_spawners","stop_castle_spawners","southeast_front_threshold","southeast_front",true,true,true);
	level thread squad_manager_think("sb_spawn","southeast_back_spawners","stop_castle_spawners","southeast_back_threshold","southeast_back",true,true,true);
	
	level thread maps\oki3_squad_manager::manage_spawners("southeast_front",8,10,"stop_castle_spawners",.5, ::spawnfunc_front_line,3,undefined,"sf_spawn");
	level thread maps\oki3_squad_manager::manage_spawners("southeast_back",5,9,"stop_back",.5, ::spawnfunc_rear_support,3,undefined,"sb_spawn");
	level thread maps\oki3_squad_manager::manage_spawners("castle_back_sniper",1,2,"stop_castle_spawners",.5,undefined,5);
	
	// magic grenades rain down on the players if they don't complete their objective in a timely manner
	//only do this in co-op	to prevent exploiting arcademode
//	players = get_players();
//	if(players.count > 1)
//	{
		level thread magic_grenades_from_hell();
//	}	
	
	wait(10);
	level notify("nag_castle");
	level.nag_castle = true;
	
}

//spawnfunc_portableguy()
//{
//	self endon("death");
//	
//	self thread magic_bullet_shield();
//	self waittill("goal");
//	wait(1);
//	self stop_magic_bullet_shield();
//}


spawnfunc_rear_support()
{
	self endon("death");
	
	//remove grenade ammo from all guys in the back
	self.grenadeammo = 0;
	
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 128;
	self waittill("goal");
	self.ignoreall = false;
	self.ignoreme = false;
	
}

spawnfunc_front_line()
{
	self endon("death");
	
	
	
	self.script_noteworthy = "front_line_guy";
	self.ignoreall = true;
	self.ignoreme = true;
	self.goalradius = 64;
	self waittill("goal");
	self.ignoreall = false;
	self.ignoreme = false;
	wait(5);
	self.ready_to_charge = true;
}


/*------------------------------------
monitors guys on the front lines. 
When enough of them are ready, 
they will break away and charge the player
------------------------------------*/
front_line_spawner_think()
{	
	
	while(1)
	{
		wait(30);
		count = 0;
		chargers = [];
		guys = getentarray("front_line_guy","script_noteworthy");
		if(guys.size > 2)
		{
			for(i=0;i<guys.size;i++)
			{
				if(isDefined(guys[i].ready_to_charge))
				{
					chargers[count] = guys[i];
					count++;
				}
			}
			
			if(count>3)
			{
				array_thread(chargers,::front_line_charge);
				dialog[0] = "keep_firing";
				dialog[1] = "another_charge";
				dialog[2] = "running_at_us";
				wait(2);				
				level notify("do_dialog",dialog[randomint(dialog.size)],level.last_hero);
			}
		}
								
	}	
}

front_line_charge()
{
	self endon("death");
	
	self.ready_to_charge = undefined;
	self thread maps\_banzai::banzai_force();
}


get_frontline_guys()
{
	guys = getentarray("front_line_guy","script_noteworthy");
	count = 0;
	for(i=0;i<guys.size;i++)
	{
		if(isDefined(guys[i].ready_to_charge))
		{
			guys[i] thread maps\_banzai::banzai_force();
			if(count>3)
			{
				break;
			}
			count++;
		}
	}
	return count;
}




/*------------------------------------
hide a damage state for a building
------------------------------------*/
hide_damaged(building,dmgstate)
{
	
	if(!isDefined(dmgstate))
	{
		dmgstate = "";
	}
	
	ent = getentarray("roof_building_" + building + "_dmg_" + dmgstate,"targetname");
	if(ent.size)
	{
		for(i=0;i<ent.size;i++)
		{
			ent[i] hide();
			ent[i] notsolid();
		}
	}
	else
	{
		ent = getent("roof_building" + building + "_dmg_" + dmgstate,"targetname");	
		if(isDefined(ent))
		{
			ent hide();
			ent notsolid();
		}
		else
		{
			ent = getentarray("roof_building_" + building + "_dmg_" + dmgstate,"targetname");
			if(isDefined(ent.size))
			{
				for(i=0;i<ent.size;i++)
				{
					ent[i] hide();
					ent[i] notsolid();
				}
			}
		}
	}
}


/*------------------------------------
show a damage state for a building
------------------------------------*/
show_damaged(building,dmgstate)
{
	
	if(!isDefined(dmgstate))
	{
		dmgstate = "";
	}
	
	ent = getentarray("roof_building_" + building + "_dmg_" + dmgstate,"targetname");
	if(ent.size)
	{
		for(i=0;i<ent.size;i++)
		{
			ent[i] show();
			ent[i] solid();
		}
	}
	else
	{
		ent = getent("roof_building" + building + "_dmg_" + dmgstate,"targetname");	
		if(isDefined(ent))
		{
			ent show();
			ent solid();
		}
		else
		{
			ent = getent("roof_building_" + building + "_dmg_" + dmgstate,"targetname");
			if(isDefined(ent))
			{
				ent show();
				ent solid();
			}
		}
	}
	
}

/*------------------------------------
hide a non-damaged state for a building
------------------------------------*/
hide_intact(building,dmgstate)
{
	
	if(!isDefined(dmgstate))
	{
		dmgstate = "";
	}
	
	ent = getentarray("roof_building_" + building + "_intact" ,"targetname");
	if(ent.size)
	{
		for(i=0;i<ent.size;i++)
		{
			ent[i] hide();
			ent[i] notsolid();
		}
	}
	else
	{
		ent = getent("roof_building" + building + "_intact","targetname");	
		if(isDefined(ent))
		{
			ent hide();
			ent notsolid();
		}
		else
		{
			ent = getent("roof_building_" + building + "_intact","targetname");	
			if(isDefined(ent))
			{
				ent hide();
				ent notsolid();
			}
			else
			{
				ent = getent("roof_building_" + building + "_" + dmgstate,"targetname");	
				if(isDefined(ent))
				{
					ent hide();
					ent notsolid();
				}
			}
		}
	}
	
}


/*------------------------------------
show the non-damaged building
------------------------------------*/
show_intact(building,dmgstate)
{
	
	if(!isDefined(dmgstate))
	{
		dmgstate = "";
	}
	
	ent = getentarray("roof_building_" + building + "_intact" ,"targetname");
	if(ent.size)
	{
		for(i=0;i<ent.size;i++)
		{
			ent[i] show();
			ent[i] solid();
		}
	}
	else
	{
		ent = getent("roof_building" + building + "_intact","targetname");	
		if(isDefined(ent))
		{
			ent show();
			ent solid();
		}
		else
		{
			ent = getent("roof_building_" + building + "_" + dmgstate,"targetname");	
			if(isDefined(ent))
			{
				ent show();
				ent solid();
			}
		}
	}	
}

/*------------------------------------
smoke canisters are thrown into the area
------------------------------------*/
courtyard_prespawn_smoke(min_force,max_force,orgs)
{
	
	if(!isDefined(min_force))
	{
		min_force = 700;
	}
	
	if(!isDefined(max_force))
	{
		max_force = 800;
	}
	
	//ents = getstruct(org,"targetname");
	ents = getstructarray(orgs,"targetname");

	for(i=0;i<ents.size;i++)
	{
		if(!isDefined(ents[i].original_angles))
		{
			ents[i].original_angles = ents[i].angles;
		}
		//if(isDefined(ents[i].original_angles))
		//{
		//	ents[i].angles = ents[i].original_angles + (0,randomintrange(-10,10),0);
	//	}
		ents[i] thread throw_smoke_from_pos(randomintrange(min_force,max_force));
		wait(randomfloatrange(.5,1.5));
	}	
}

//------------------------------------------------------------
// exploder stuff, 
// TODO ASAP: make this a module/function instead of individual for each building
//---------------------------------------------------------------

destroy_building1()
{
	
	level.north_buildings_targeted = true;
	level notify("stop_grenades");
	level thread destroy_building11();
	level thread courtyard_spawn_bomber_test("building1_spline1",(0,0,150),true);
	
	wait(13);	
	if(!isDefined(level.building1_destroyed))
	{
		earthquake(0.3,randomfloatrange(1.5,3),(7205, -2655, 409),4048);
		exploder(401);
		wait(0.4);
		show_damaged(1,1);
		hide_intact(1);
		playsoundatposition("courtyard_building_explo",(7205, -2655, 409));		
		wait(.9);
		show_damaged(2,1);
		hide_intact(2);
		playsoundatposition("courtyard_building_explo",(7898, -2743, 559.5));
					
		level notify("building1_destroyed");
		level notify("b1_spawners");
		level.building1_destroyed = true;		
	}
	
	trig= getent("courtyard_ne","script_noteworthy");
	trig2 = getent("courtyard_nw","script_noteworthy");
	
	dudes = getaiarray("axis");
	for(i=0;i<dudes.size;i++)
	{
		if( dudes[i] istouching(trig) || dudes[i] istouching(trig2) )
		{
			dudes[i] thread flamedeath();
		}
	}

	//send anyone else that's in the area banzai charging into the area
	trig = getent("courtyard_se","script_noteworthy");
	dudes = getaiarray("axis");
	
	for(i=0;i<dudes.size;i++)
	{
		if(dudes[i] istouching(trig) )
		{
			dudes[i] thread maps\_banzai::banzai_force();
		}
	}	
}


destroy_building11()
{
	
	if(!isDefined(level.building1_destroyed))
	{
		wait (4);
		level thread destroy_building_3();
		level thread courtyard_spawn_bomber_test("building11_spline1",(0,0,150),true);
		wait(13);
					
		earthquake(randomfloatrange(0.14,0.4),randomfloatrange(1.5,3),(6611, -3689, 327),4048);
		//playfx(level._effect["courtyard_ambient_roof"],(6611, -3689, 327));
		stop_exploder(1100);
		exploder(1101);
		playsoundatposition("courtyard_building_explo",(6611, -3689, 327));
		wait(0.3);
		show_damaged(11,1);
		hide_intact(11);
		
		wait(0.38);		
		show_damaged(12,1);
		hide_intact(12);
		
		wait(2);
		level notify("dragon falls");	
		wait(3);		
	}
}


destroy_building_3()
{
	
	if(!isDefined(level.building3_destroyed))
	{
		wait(1);
		level thread courtyard_spawn_bomber_test("building3_spline1",(0,0,350),true);
		wait(13);
		
		earthquake(randomfloatrange(0.14,0.4),randomfloatrange(1.5,3),(9604, -3162.5, 137),4048);
		//playfx(level._effect["courtyard_ambient_roof"],(9672, -2936, 298));
		playsoundatposition("courtyard_building_explo",(9672, -2936, 298));
		exploder(601);
		wait(.4);
		show_damaged(3,1);
		hide_intact(3);
	
	}
	
	
}


destroy_building4()
{
	
	level.castle_targeted = true;
	level thread courtyard_spawn_bomber_test("building4_spline1",(0,0,150),true);
	
	if(!isDefined(level.building4_1_destroyed))
	{
		level thread destroy_building5();
		level thread destroy_building6();			
		level thread destroy_castle_damagestate_2();
		
		wait(13);
		
		
		earthquake(0.45,randomfloatrange(1.5,3),(9800,-4376,968),4048);
		//playfx(level._effect["courtyard_ambient_roof"],(9800,-4376,968));
		stop_exploder(500);
		
		exploder(501);
		wait(.45);
		show_damaged(4,1);
		hide_intact(4,1);
		playsoundatposition("courtyard_building_explo",(9800,-4376,968));		
		
		dragons = getentarray("roof_building_4_dragons","targetname");
		for(i=0;i<dragons.size;i++)
		{
			dragons[i] hide();
		}	
		
		//level thread spawn_banzai_guys();
		
		level.building4_1_destroyed = true;
	}
//	//else if(!isDefined(level.building4_2_destroyed))
//	{
//		level.castle_targeted_1 = true;
//		wait(13);
//
//		stop_exploder(501);
//		exploder(502);
//		playsoundatposition("courtyard_building_explo",(9576 ,-4180, 674));
//		earthquake(randomfloatrange(0.4,0.7),randomfloatrange(1.5,3),(9800,-4376,968),4048);
//		
//		wait(.25);
//		hide_damaged(4,1);
//		show_damaged(4,2);
//		
//		//playfx(level._effect["courtyard_ambient_roof"],(9576 ,-4180, 674));
//		//exploder(102);
//		//playfx(level._effect["a_fire_smoke_med_dist"],(9534, -4386, 668));
//		
//		level.building4_2_destroyed = true;
//
//	}
	else if(!isDefined(level.building4_3_destroyed))
	{
		level notify("stop_castle_spawners");
		level notify("stop_back");
		level notify("stop_upper");
		level.castle_targeted_2 = true;
		wait(13);
		stop_exploder(502);
		exploder(503);
		earthquake(randomfloatrange(0.4,0.7),randomfloatrange(1.5,3),(9800,-4376,968),4048);
		playsoundatposition("courtyard_building_explo",(9576 ,-4180, 574));
		
		wait(.3);
		show_damaged(4,3);
		hide_damaged(4,2);	
		
		level.building4_3_destroyed = true;
		
		//delete the paper windows and stuff
		getent("castle_paperwindows","targetname") delete();		
		getent("ne_door1","targetname") delete();
		getent("ne_door2","targetname") delete();
		wait(2);
				
		castle_front_fall();		
	}	
}

destroy_castle_damagestate_2()
{
		wait(randomintrange(8,10));
		level thread courtyard_spawn_bomber_test("building4_spline1",(0,0,150),true);
				
		level.castle_targeted_1 = true;
		wait(13);

		stop_exploder(501);
		exploder(502);
		playsoundatposition("courtyard_building_explo",(9576 ,-4180, 674));
		earthquake(randomfloatrange(0.4,0.7),randomfloatrange(1.5,3),(9800,-4376,968),4048);
		
		wait(.25);
		hide_damaged(4,1);
		show_damaged(4,2);
		
		level.building4_2_destroyed = true;

}

destroy_building6()
{
	
	wait(randomfloatrange(3,5));
	level thread courtyard_spawn_bomber_test("building6_spline1",(0,0,150),true);
	
	if(!isDefined(level.building6_destroyed))
	{
	
		wait(13);
		
		earthquake(0.5,randomfloatrange(1.5,3),(8335,-6222,506),4048);
		
		show_damaged(6,1);
		hide_intact(6);

		exploder(301);	

		level notify("stop_back");
		level notify("stop_upper");
		level.building6_destroyed = true;
	}
}

destroy_building5()
{
	wait(randomfloatrange(3,5));
	if(!isDefined(level.building5_destroyed))
	{
		level thread courtyard_spawn_bomber_test("building5_spline1",(0,0,150),true);
		
		wait(13);
		
		earthquake(0.46,randomfloatrange(1.5,3),(8335,-6222,506),4048);
		show_damaged(5,1);
		hide_intact(5);
		exploder(201);
		wait(.2);
		exploder(202);		

		level notify("stop_upper");
		level.building5_destroyed = true;
		
	}
}

destroy_building7()
{
	
	level thread courtyard_spawn_bomber_test("building7_spline1",(0,0,150),true);
	
	if(!isDefined(level.building7_destroyed))
	{
	
		wait(13);
		//ent = spawn("script_origin",(7712, -6384, 432));
		//ent playsound("courtyard_building_explo");
		
		earthquake(0.43,randomfloatrange(1,2.5),(7712, -6384, 432),4048);
		playfx(level._effect["courtyard_ambient_roof"], (7712, -6384, 432));	
		exploder(701);
		show_damaged(7,1);
		hide_intact(7);
		
		
	}
}


courtyard_bomb_run(area)
{
	
	level thread courtyard_spawn_bomber_test(area,(0,0,150));
	
}



/*------------------------------------
use the MG in the courtyard
building to take out the guys
------------------------------------*/
courtyard_too()
{
	
	trigger_wait("courtyard_too","targetname");
	
	simple_spawn("too_defenders",::spawnfunc_too_enemy);
	wait(4);
	simple_spawn("too_friends",::spawnfunc_too_friends);
	level thread too_think();
}



too_think()
{
	thread monitor_volume_for_enemies("too_volume","too_cleared");
	thread monitor_too_mg();
	level waittill("too_cleared");
	simple_spawn("too_friends_b",::spawnfunc_too_friends);
	wait(.5);
	
	ai = getentarray("too_friend","script_noteworthy");
	array_thread(ai,::too_advance);	
}

monitor_too_mg()
{
	level endon("stop_too_mg");
	
	mg = getent("auto3946","targetname");
	
	firing = false;
	while(!firing)
	{
		wait(1);
		owner = mg getturretowner();
		if(isDefined(owner))
		{
			if( mg maps\_mgturret::mg_is_firing( owner ) )
			{
				firing = true;
			}
		
		}
	}

	simple_spawn("too_defenders_extra",::spawnfunc_too_enemy);
	
}

too_advance()
{
	
	self setgoalpos( (7280 ,-2032, 112));
	self.goalradius = 32;
	self waittill("goal");
	if(isDefined(self.magic_bullet_shield))
	{
		self stop_magic_bullet_shield();
	}
	self delete();	
}


spawnfunc_too_friends()
{
	self.script_noteworthy = "too_friend";
	self thread magic_bullet_shield();
	
}

spawnfunc_too_enemy()
{
	self endon("death");
	
	self.goalradius = 128;
	self.maxsightdistsqrd = 1500*1500;
	wait(90);
	self setgoalpos( (7280 ,-2032, 112));
	self.goalradius = 32;
	self waittill("goal");
	self delete();
	
}


courtyard_spawn_bomber_test(iplane_spline,offset_vector,noFX)
{
	
	spline_array = getstructarray(iplane_spline,"targetname");
	
	plane_spline = [];
	plane_spline[0] = spline_array[randomint(spline_array.size)];
	
	x = 0;
	while(1)
	{
		if(isDefined(plane_spline[x].target))
		{
			target = getstruct(plane_spline[x].target,"targetname");
			target.origin = target.origin + (0,0,150);
			plane_spline[plane_spline.size] = target;
			x++;
		}
		else
		{
			break;
		}
	}

	if(!IsDefined(offset_vector))
	{
		offset_vector = (0,0,0);
	}
		
	plane1 = SpawnVehicle( "vehicle_p51_mustang", "new_plane", "p51", plane_spline[0].origin, plane_spline[0].angles );
	plane2 = SpawnVehicle( "vehicle_p51_mustang", "new_plane", "p51", plane_spline[0].origin, plane_spline[0].angles );
	
	
	level.plane_bomb_model[ "p51" ] = "aircraft_bomb";

	if(!isDefined(noFX))
	{
		level.plane_bomb_fx[ "p51" ] = level._effect["arty_tile_roof"];
	}
	else
	{
		level.plane_bomb_fx[ "p51" ] = level._effect["null"];
	}
	
	level.plane_bomb_sound[ "p51" ] = "courtyard_building_explo";
	
	maps\_planeweapons::build_bomb_explosions( "p51", randomfloatrange(.3,.5), 3, 5000, 700, 250, 1000 );

	plane1 thread setup_bomber();
	plane2 thread setup_bomber();	
	
	plane1 thread drop_bombs(plane_spline,offset_vector);
	wait(.5);

	offset_vector =(randomintrange(-400,400),randomintrange(-200,200),randomintrange(150,300));
	plane2.origin = plane2.origin + offset_vector;
	plane2 thread drop_bombs(plane_spline,offset_vector);
	
}

drop_bombs(plane_spline,offset_vector)
{
	self playsound("final_bombers");
	self setplanegoalpos(plane_spline[1].origin + offset_vector, plane_spline[2].origin + offset_vector, plane_spline[3].origin + offset_vector, plane_spline[4].origin + offset_vector,plane_spline[5].origin + offset_vector, plane_spline[6].origin + offset_vector, 180);
	wait(12.15);
	self thread	maps\_planeweapons::drop_bombs( 2, .4, 1.2, 500 );
	self waittill("curve_end");	
	self.notrealdeath = true;
	self notify("death");
	self delete();
}

setup_bomber()
{
	
	//self maps\_planeweapons::build_bombs( "p51", "aircraft_bomb");
	self.bomb_count = 2;
	self.vehicletype = "p51";
	self attach_bombs_p51();
	
}

attach_bombs_p51()
{
	self.bomb = [];
	for( i = 0; i < self.bomb_count; i++ )
	{
		self.bomb[i] = Spawn( "script_model", ( self.origin ) );
		self.bomb[i] SetModel( level.plane_bomb_model[ self.vehicletype ] );
		self.bomb[i].dropped = false;
		wait(.5);
		if( i == 0 )
		{
			self.bomb[i] LinkTo( self, "tag_gunLeft", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		else if( i == 1 )
		{
			self.bomb[i] LinkTo( self, "tag_gunRight", ( 0, 0, -4 ), ( -10, 0, 0 ) );
		}
		
	}
}


building_l_spawners()
{
	
	trigger_wait("building_L_spawners","targetname");
	thread spawn_shadow_guys();
	trigger_wait("building_L_friendly","targetname");
	level.sarge do_dialogue("open_fire");
	level.sarge do_dialogue("man_mg");
	battlechatter_on("allies");
	wait(1);
	level.sarge do_dialogue("clear_area2");
}

/*------------------------------------
//ambient guys running behind the paper windows
------------------------------------*/
spawn_shadow_guys()
{

	ent = getent("shadow_guy_test","targetname");
	ent.count = 5;		
	for(i=0;i<6;i++)
	{
		simple_spawn("shadow_guy_test",::spawnfunc_shadow_runners);
		wait(randomfloatrange(.23,.7));
	}	
}

spawnfunc_shadow_runners()
{
	self thread arcademode_shadowguys();
	self endon("death");

	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 16;
	self setgoalpos( (6699.5, -3200, 136) );
	self.goalradius = 16;
	self waittill("goal");
	self delete();
//	while(1)
//	{	
//		self setgoalpos( (6702 ,-3111 ,71) );
//		self.goalradius = 64;
//		self waittill("goal");		
//		self setgoalpos( (6742.5, -3687, 152) );
//		self.goalradius = 64;
//		self waittill("goal");
//	}
}

arcademode_shadowguys()
{
	self waittill("death");
	
	if(isDefined(self.attacker) && isPlayer(self.attacker))
	{
		arcademode_assignpoints( "arcademode_score_generic250", self.attacker );
	}
}


building1_interior_spawners()
{
	trigger_wait("coutyard_building1_trig","targetname");
	wait(2);
	level thread monitor_volume_for_enemies("coutyard_building1_vol",undefined,"coutyard_building1_friendly");
}

underground_spawners_1()
{	
	trigger_wait("courtyard_underground_spawner1","targetname");
	level thread shoot_barrels_dialogue();
	wait(2);		
	level thread monitor_volume_for_enemies("courtyard_underground_spawner_1",undefined,"courtyard_underground_friendly_1");
	level thread clean_middle_ai();
}

shoot_barrels_dialogue()
{
	trigger_Wait("dialog_shoot_barrels","targetname");
	level.sarge do_dialogue("shoot_barrels");
}


underground_spawners_2()
{
	
	trigger_wait("courtyard_underground_spawner2","targetname");
	//simple_spawn("hole_guys_1");
	wait(2);		
	level thread monitor_volume_for_enemies("courtyard_underground_spawner_2",undefined,"courtyard_underground_friendly_2");
	//simple_spawn("auto4366");

	
}

underground_bigroom_1()
{
	trigger_wait("underground_bigroom_spawn","targetname");
	battlechatter_on("axis");
	battlechatter_on("allies");
	
}

underground_bigroom_2()
{
	trigger_wait("underground_bigroom2_friend","targetname");
	wait(5);		
	level thread monitor_volume_for_enemies("underground_volume3",undefined,"underground_volume3_friend");
}


underground_exit_spawners()
{	
	trigger_wait("underground_exit_spawners","targetname");
	level thread exit_dialogue();
	wait(3);		
	level thread monitor_volume_for_enemies("underground_exit_volume",undefined,"underground_exit_friends");

}

exit_dialogue()
{
	wait(4);
	level.polonsky do_dialogue("on_stairs");	
	trigger_wait("underground_exit_friends","targetname");	
	level.sarge do_dialogue("upstairs");
}

//the front facade of the big castle falls inward
#using_animtree("oki3_models");
castle_front_fall()
{
	level notify("stop_air_support");
	front = undefined;
	pieces = getentarray("roof_building_4_front_dragon","targetname");
	
	for(i=0;i<pieces.size;i++)
	{
		if(pieces[i].model == "anim_okinawa_castlefront")
		{
			front = pieces[i];
		}
		else
		{
			pieces[i] delete();
		}
	}
	
	front playsound("courtyard_building_collapse");
	playfx(level._effect["a_shuri_collapse_gate"],front.origin);
	front useanimtree(#animtree);
	front.animname = "castle";	
	PlayRumbleOnPosition( "oki3_castle_fall",front.origin);
	front SetFlaggedAnimKnobRestart( "castle_falls", level.scr_anim["castle"]["front_fall"], 1.0, 0.2, 1.0 );
	exploder(504);
	level.castle_destroyed = true;
}

/*------------------------------------
monitor when the player is on the coutyard MG
------------------------------------*/
monitor_mg_usage()
{
	mg = getent("courtyard_mg","targetname");
	
	while(1)
	{
		owner = undefined;
		while(!isDefined(owner))
		{
			owner = mg getturretowner();
			wait(.1);
		}
		flag_set("mg_mounted");
		while(isDefined(owner))
		{
			owner = mg getturretowner();
			wait(.1);
		}
		
		flag_clear("mg_mounted");
		wait(.1);
	}
	
}


/*------------------------------------
handles removing/restoring the grenades from enemies during the final event
------------------------------------*/
grenade_watcher()
{
	level endon("stop_grenade_watch");
	
	while(1)
	{
		if(flag("mg_mounted"))
		{
			enemy = getaiarray("axis");
			array_thread(enemy,::remove_grenades);
		}
		else
		{
			enemy = getaiarray("axis");
			array_thread(enemy,::restore_grenades);
		}
		wait(.1);
	}	
}

remove_grenades()
{
	self endon("death");
	
	if(isDefined(self.grenadeammo) && self.grenadeammo > 0)
	{
		self.old_grenade_ammo = self.grenadeammo;
		self.grenadeammo = 0;
	}
	
}

restore_grenades()
{
	self endon("death");
	if(isDefined(self.old_grenade_ammo) )
	{
		self.grenadeammo = self.old_grenade_ammo;
	}
}

restore_all_grenades()
{
	level waittill("stop_grenade_watch");
	enemy = getaiarray("axis");
	array_thread(enemy,::restore_grenades);
}


/*------------------------------------
the dragon statue falls to the ground
------------------------------------*/
courtyard_dragon_falls()
{
	wait(2);
	broken_dragon = getent("courtyard_dragon_broken1","targetname");
	broken_dragon connectpaths();
	broken_dragon hide();
	broken_dragon notsolid();
	level waittill("dragon falls");
	
	dragon = getentarray("courtyard_dragon","targetname");
	
	for(i=0;i<dragon.size;i++)
	{
		if(dragon[i].model == "static_okinawa_dragonpost")
		{
			dragon[i] moveto( (7278,-4068,54) ,1);
			dragon[i] rotateto( ( 90,122.462,122.461 ),.8);
			dragon[i] waittill("movedone");
			broken_dragon show();
			dragon[i] hide();
			broken_dragon disconnectpaths();
			broken_dragon solid();			
		}
	}
}

courtyard_mg_stuff()
{
	mg = getent("courtyard_mg2","targetname");
	while(1)
	{
		guy = mg getturretowner();
		if(!isDefined(guy))
		{
			get_closest_2_mg(mg);

		}
		wait(.5);					
	}
}

get_closest_2_mg(mg)
{
	
	ai = getaiarray("axis");
	for(i=0;i<ai.size;i++)
	{
		if(distance(ai[i].origin,mg.origin) < 128)
		{
			ai[i] useturret(mg);
			break;
		}
	}
	
}

fake_surrender_guys()
{
	getent("use_mortars_courtyard","targetname") trigger_off();
	getent("start_final_defend","script_noteworthy") trigger_off();//("trigger");
	trigger_wait("spawn_feigning_guys","targetname");
	getent("enter_courtyard","targetname") trigger_off();//("trigger");
	
	level.sarge thread sarge_waittill_death();
	level.polonsky thread sarge_waittill_death();
	
	//kill all the dudes
	axis = getaiarray("axis");
	for(i=0;i<axis.size;i++)
	{
		axis[i] bloody_death();
	}	
	
	//remove any spawners that aren't needed any longer
	spawners = getspawnerarray();
	count = 0;
	for(i=0;i<spawners.size;i++)
	{
		if(isDefined(spawners[i].script_spiderhole))
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].script_string) && spawners[i].script_string == "delete_me")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "tree_sniper_guys")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "outer_guys")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "auto3757")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "auto3792")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "rear_defenders")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname) && spawners[i].targetname == "banzai_ambush_guys")
		{
			spawners[i] delete();
			count++;
		}
		else if(isDefined(spawners[i].targetname ) && spawners[i].targetname == "auto4353")
		{
			spawners[i] delete();
			count++;			
		}
		else if(isDefined(spawners[i].targetname ) && spawners[i].targetname == "courtyard_hole2_guys")
		{
			spawners[i] delete();
			count++;			
		}
		
	}
	//iprintlnbold(count + " spawners deleted");
	count =0;	
	volumes = getentarray("info_volume","classname");
	rads = getentarray("trigger_radius","classname");
	trigs = getentarray("trigger_multiple","classname");
	mods = getentarray("script_model","classname");
	
	com1 = array_combine(volumes,rads);
	com2 = array_combine(trigs,mods);
	ents = array_combine(com1,com2);	
	
	for(i=0;i<ents.size;i++)
	{
		if(isDefined(ents[i].script_string) && ents[i].script_string == "delete_me")
		{
			ents[i] delete();
			count++;
		}
	}
	
	wait(4);
	//kill all the dudes again just in case
	guys = getaiarray("axis");
	for(i=0;i<guys.size;i++)
	{
		guys[i] bloody_death();
	}	
	
	fakers = simple_spawn("fake_surrender_guy");
	
	for(i=0;i<fakers.size;i++)
	{
		fakers[i].animname = fakers[i].script_noteworthy;
		if(fakers[i].animname == "surrender_2")
		{
			level.fakers_dialog_guy = fakers[i];
		}
		anim_node = getnode("courtyard_anim","targetname");//getnode(fakers[i].script_noteworthy,"script_noteworthy");
		fakers[i] thread fake_surrender(anim_node);
	}	
	
	//test stuff
	split_heros();
	
	//removed for now..interferes with dialogue
	//level thread Feign_Death();
	
	getent("secure_courtyard_drop_objective","targetname") notify("trigger");		
	
	level waittill_either("sarge_saved","polonsky_saved");

	//wait(2.5);
	if(isAlive(level.polonsky) )
	{
		level.last_hero = level.polonsky;
		level.last_hero.goalradius = 4;
		level.last_hero setgoalpos(level.last_hero.origin);
		
		wait(2.5);
		
		//iprintlnbold("polonsky lives!");
		if(!isDefined(level.polonsky.magic_bullet_shield) && IsAlive(level.polonsky))
		{
			level.polonsky thread magic_bullet_shield();
		}
		
		//level.polonsky set_force_color("o");
		setmusicstate("ROEBUCK_DIED");
	}
	
	//player saved sarge
	if(isAlive(level.sarge))
	{
		
		if(isAlive(level.sarge))
		{
			//iprintlnbold("sarge lives!");
			if(!isDefined(level.sarge.magic_bullet_shield))
			{
				level.sarge thread magic_bullet_shield();
			}
			level.last_hero = level.sarge;

			setmusicstate("POLONSKY_DIED");
			
			players = get_players();
			for(i=0;i<players.size;i++)
			{
				players[i] GiveAchievement("OKI3_ACHIEVEMENT_ANGEL");
			}
		}
	}
	
	//player did nothing, animation plays out entirely without interruption
	if(!isDefined(level.polonsky_attacker_shot) && level.last_hero == level.polonsky)
	{
		level thread start_courtyard_ambush(6);
		level.polonsky waittillmatch("single anim","end");
		level.last_hero thread do_death_dialogue(true);
	}
	
	//player shot polonsky's attacker
	else if( isDefined( level.polonsky_attacker_shot) && level.last_hero == level.polonsky )
	{
		
		//-- plays the animation	
		level thread start_courtyard_ambush(0);
		
		goal_node = getnode("courtyard_anim", "targetname");
		startorg = getstartOrigin( goal_node.origin, goal_node.angles, level.scr_anim[level.last_hero.animname]["fake_surrender_trans"] );
		startang = getstartAngles( goal_node.origin, goal_node.angles, level.scr_anim[level.last_hero.animname]["fake_surrender_trans"] );
		
		level.last_hero.goalradius = 32;
		level.last_hero SetGoalPos( startorg, startang );
			
		level.last_hero waittill( "goal" );
		//level.last_hero waittill_notify_or_timeout( "orientdone", 1 );
		level.last_hero thread Do_Death_Dialogue();

		maps\_anim::anim_single_solo( level.last_hero, "fake_surrender_trans", undefined, goal_node );
		
	}
	
	//sarge was saved
	if(level.last_hero == level.sarge)
	{
		level thread start_courtyard_ambush(0);
		goal_node = getnode("courtyard_anim", "targetname");
		startorg = getstartOrigin( goal_node.origin, goal_node.angles, level.scr_anim[level.last_hero.animname]["fake_surrender_trans"] );
		startang = getstartAngles( goal_node.origin, goal_node.angles, level.scr_anim[level.last_hero.animname]["fake_surrender_trans"] );
		
		level.last_hero.goalradius = 32;
		level.last_hero SetGoalPos( startorg, startang );
			
		level.last_hero waittill( "goal" );
		//level.last_hero waittill_notify_or_timeout( "orientdone", 1 );
		level.last_hero thread Do_Death_Dialogue();

		maps\_anim::anim_single_solo( level.last_hero, "fake_surrender_trans", undefined, goal_node );
		level.last_hero.a.pose = "stand";
	}

	level.last_hero set_force_color("o");
	getent("enter_courtyard","targetname") notify("trigger");
	
	level.last_hero.grenadeawareness = 1;
	level.last_hero.ignoreall = false;
	level.last_hero setcandamage(true);
	level.last_hero.goalradius = 512;
	
	warp_players_to_courtyard();
	
	
	autosave_by_name("courtyard_death");
	battlechatter_on("allies");
	battlechatter_on("axis");
	
	
	getent("use_mortars_courtyard","targetname") trigger_on();
	level thread mortar_round_think("courtyard");

}

/*------------------------------------
warp any slacker players to the courtyard
------------------------------------*/
warp_players_to_courtyard()
{
	vol1 = getent("courtyard_player_check","targetname");
	vol2 = getent("drop_volume","targetname");
	spots = getstructarray("courtyard_players","targetname");
	
	players = get_players();
	players_2_warp = [];
	
	for(i=0;i<players.size;i++)
	{
		if(players[i] istouching(vol1) || players[i] istouching(vol2))
		{
			continue;
		}
		else
		{
			players_2_warp[players_2_warp.size] = players[i];
		}
	}

	for(i=0;i<players_2_warp.size;i++)
	{
		players_2_warp[i] thread warp_player(spots[i]);
	}	
}

start_courtyard_ambush(wait_time)
{
	wait(wait_time);
	getent("start_final_defend","script_noteworthy") notify("trigger");
}

sarge_waittill_death()
{	
	while(isDefined(self))
	{
		level.death_org = self.origin;
		wait_network_frame();
	}
}

do_death_dialogue(initial_dialogue)
{
	
	//wait(7.5);
	if( self == level.polonsky)
	{
//		if(!isDefined(level.polonsky_attacker_shot))
//		{
//			self waittillmatch("single anim","end");
//		}
		wait(.5);
		if(!isDefined(initial_dialogue))
		{
			self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["sarge"], 1.0, "dialogue_done" );
			self waittill("dialogue_done");
			self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["killed_sarge"], 1.0, "dialogue_done" );
			self waittill("dialogue_done");		
			wait(2);
		}
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["bastards_killed"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");		
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["sonsabitches"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		wait(12);		
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["gd_sonsabitches"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		wait(14);
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["yhear_me"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["polonsky"]["straight_2_hell"], 1.0, "dialogue_done" );
	}
	else
	{
		wait(.5);	
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["no_polonsky"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["polonsky_down"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		wait(2);
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["those_animals"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["animals"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		wait(12);
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["damn_animals"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		wait(14);
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["aint_overa"], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["sarge"]["aint_overb"], 1.0, "dialogue_done" );

	}
	
}

surrender_guy_dialog_loop()
{
	self endon("death");
	
	while(!isDefined(level.stop_surrender_dialog))
	{
		wait(randomfloatrange(.5,2.5));
		self animscripts\face::SaySpecificDialogue( undefined, level.scr_sound["surrender_2"]["dont_shoot" + randomint(10)], 1.0, "dialogue_done" );
		self waittill("dialogue_done");
	}
	
}
//
//wait_to_kill_sarge()
//{
//	level waittill_multiple("sarge_goal","polonsky_goal","death_trigger");
//	level notify("kill_sarge");
//	
//}

//kill_sarge_trigger()
//{
//	
//	trigger_wait("roebuck_death","targetname");
//	level notify("death_trigger");
//}


feign_death()
{
	//spawner = getentarray("feign_death_guys","targetname");
	guys = simple_spawn("feign_death_guys");
	
	for(i=0;i<guys.size;i++)
	{
		anim_org = getnode("feign_death_org_" + i,"targetname");
		if(!isDefined(anim_org))
		{
			guys[i] delete();
			continue;
		}
		
		if(i==0||i==2)
		{
			guys[i] delete();
		}
		else
		{
			guys[i].animname = "feign_guy" + ( i+1);
			guys[i].pacifistwait = .05;
			guys[i].ignoreme = true;
			guys[i].ignoreall = true;
			guys[i].allowdeath = true;
			//guys[i] thread handle_feigner_death();
			guys[i] thread feigner_getup();
			guys[i] thread maps\_anim::anim_loop_solo(guys[i],"feign",undefined,"stop_feign",anim_org);
		}
	}
	
	level thread feigners_ambush(guys);	
}



feigners_ambush(guys)
{
	level waittill("stop_feign");
	//guys = array_randomize(guys);
	
	//guys nearest the top ambush first
	for(i=0;i<guys.size;i++)
	{
		if(isAlive(guys[i]))
		{
			if(i==5||i==3)
			{
				guys[i] notify("stop_feigning");
			}
		}
	}
	
	wait(7);
	//guys nearest the top ambush first
	for(i=0;i<guys.size;i++)
	{
		if(isAlive(guys[i]))
		{
			guys[i] notify("stop_feigning");
		}
	}
	
}

feigner_getup()
{	
	self.allowdeath = true;
	self endon ("death");
	self.deathanim = level.scr_anim[self.animname]["death"];
	self.drawoncompass = false;
	self.activatecrosshair = false;
	self.ignoreall = true;
	self.ignoreme = true;
	self disableaimassist();
	
	self waittill("stop_feigning");
	wait(randomfloatrange(0.05,1));
	self notify("stop_feign");
	self maps\_anim::anim_single_solo( self,"getup");
	self.ignoreall = false;
	self.pacifist = false;
	self.goalradius = 64;
	self.ignoreme = false;	
	self.drawoncompass = true;
	self.activatecrosshair = true;
	self enableaimassist();	
	self.script_player_chance = 100;
	self.banzai_no_wait = 1;
	self thread maps\_banzai::banzai_force();
	self.deathanim = undefined;

}


handle_feigner_death()
{
	self endon("getup");
	self endon("damage");
	
	self.allowdeath = true;
	self stopanimscripted();	
}


fake_surrender(anim_node)
{
	self.ignoreme = true;
	self.ignoreall = true;
	self.script_noteworthy = "surrender_guy";
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none");

	self thread maps\_anim::anim_loop_solo( self,"surrender_loop",undefined,"stop_surrender",anim_node);
	
}


split_heros()
{
	level.sarge set_force_color("c");
	level.polonsky set_force_color("p");	
}


setup_surrender_dialogue()
{
	trigger_wait("setup_surrender","targetname");	
	thread kick_courtyard_door();
	northdoor = 	getent("building1_door","targetname"); 
	northdoor connectpaths();
	wait_network_frame();
	northdoor delete();	
}

/*------------------------------------
sarge kicks the door open after the 
planters area battle
------------------------------------*/
kick_courtyard_door()
{
	
	//anim_single_solo( guy, anime, tag, entity, tag_entity )
	anim_node = getnode("upstairs_door_kick","targetname");
	anim_node maps\_anim::anim_reach_solo(level.sarge, "door_kick2");
	anim_node maps\_anim::anim_single_solo(level.sarge,"door_kick2");
	
	thread courtyard_death_scene();	
	level.fakers_dialog_guy thread surrender_guy_dialog_loop();
		
	guys = [];
	guys[0] = level.polonsky;
	guys[1] = level.sarge;
	guys[0].animname = "polonsky";
	guys[1].animname = "sarge";
	guys[0].grenadeawareness = 0;
	guys[1].grenadeawareness = 0;
	guys[0].ignoreall = true;
	guys[1].ignoreall = true;
	guys[1] setcandamage(false);
	guys[0] setcandamage(false);
	
	level thread heros_getto_position();
	level waittill_multiple("sarge_ready","polonsky_ready");
	surrender_node = getnode("courtyard_anim","targetname");	
//	surrender_node maps\_anim::anim_reach(guys,"fake_surrender");

	surrender_guys = getentarray("surrender_guy","script_noteworthy");
	for(i=0;i<surrender_guys.size;i++)
	{
		surrender_guys[i] notify("stop_surrender");
		guys[guys.size] = surrender_guys[i];
	}	

	surrender_node thread maps\_anim::anim_single(guys,"fake_surrender");	

	startorg0 = getstartOrigin( surrender_node.origin, surrender_node.angles, level.scr_anim[guys[0].animname]["fake_surrender_trans"] );
	startang0 = getstartAngles( surrender_node.origin, surrender_node.angles, level.scr_anim[guys[0].animname]["fake_surrender_trans"] );
	startorg1 = getstartOrigin( surrender_node.origin, surrender_node.angles, level.scr_anim[guys[1].animname]["fake_surrender_trans"] );
	startang1 = getstartAngles( surrender_node.origin, surrender_node.angles, level.scr_anim[guys[1].animname]["fake_surrender_trans"] );

	//level.last_hero SetGoalPos( startorg, startang );	
	
	guys[0] SetGoalPos( startorg0, startang0 );
	guys[1] SetGoalPos( startorg1, startang1 );
		
	//guys[0].no_banzai_attack = true;
	//guys[1].no_banzai_attack = true;

}

heros_getto_position()
{
	level.sarge thread hero_in_pos();
	level.polonsky thread hero_in_pos();
	
}

hero_in_pos()
{
	surrender_node = getnode("courtyard_anim","targetname");	
	self.goalradius = 32;

	startorg = getstartOrigin( surrender_node.origin, surrender_node.angles, level.scr_anim[self.animname]["fake_surrender"] );
	startang = getstartAngles( surrender_node.origin, surrender_node.angles, level.scr_anim[self.animname]["fake_surrender"] );
	
	self SetGoalPos( startorg, startang );
	
	self waittill("goal");
	self waittill_notify_or_timeout( "orientdone", .25 );
	if(self == level.sarge)
	{
		level notify("sarge_ready");
	}
	else
	{
		level notify("polonsky_ready");
	}
	
}


courtyard_death_scene()
{
	
	wait(1);
	level.polonsky do_dialogue("movement");
	wait(1);
	level.sarge do_dialogue("hold_fire");
	disable_player_weapons();

	//TUEY Sets the music state when going downstairs
	setmusicstate("DEATH_SCENE");	
}



open_courtyard_door(guy)
{
	door = getent("upstairs_door","targetname");
	door playsound("door_kick");
	door connectpaths();
	wait_network_frame();
	door rotateyaw(-105, 1, 0.25, 0.25);
}

#using_animtree("generic_human");
surrender_death(guy)
{
	//too late to save sarge
	level notify("too_late");
	level notify("polonsky_saved");
	
	surrender_node = getnode("courtyard_anim","targetname");	
	guys = [];
	if(!isDefined(level.sarge_dead))
	{	
		level.sarge notify("_disable_reinforcement");
		surrender_guys = getentarray("surrender_guy","script_noteworthy");	
		for(i=0;i<surrender_guys.size;i++)
		{
			
			if( isDefined(surrender_guys[i]) && isDefined(surrender_guys[i].animname) && surrender_guys[i].animname == "surrender_3" && isAlive(surrender_guys[i]))
			{
				surrender_guys[i].deathanim = %ch_oki3_outro_japanese3_dead;
				surrender_guys[i].nodeathragdoll = true;
				surrender_guys[i].allowdeath = false;
				surrender_guys[i].health = 1;
				guys[guys.size] = surrender_guys[i];
			}
			if(isDefined(surrender_guys[i]) && isDefined(surrender_guys[i].animname) && surrender_guys[i].animname == "surrender_2" && isAlive(surrender_guys[i]))
			{	
				surrender_guys[i].allowdeath = false;
				surrender_guys[i].nodeathragdoll = true;
				surrender_guys[i].deathanim = %ch_oki3_outro_japanese2_dead;
				surrender_guys[i].health = 1;
				guys[guys.size] = surrender_guys[i];
			}	
		}
		//guys[guys.size] = level.sarge;
		//level.sarge setcandamage(true);
		//level.sarge stop_magic_bullet_shield();
		org = level.sarge.origin + (0,0,40);
		//level.sarge.health = 1;
		surrender_node thread maps\_anim::anim_single(guys,"fake_surrender_death");
		level.sarge thread play_sarge_death( surrender_node );
		level.sarge magicgrenadetype("fraggrenade",org,(0,0,-1),.05);	
		for(i=0;i<guys.size;i++)
		{
			guys[i].allowdeath = true;
		}	

		level.sarge_dead = true;
		PlaySoundAtPosition(level.scr_sound["sarge"]["sarge_death"],level.death_org); 
	}

}

//Glocke: added to play the death anim in relationship to the anim node
play_sarge_death( animnode )
{
	if( IsDefined(level.sarge_saved) && level.sarge_saved == true)
	{
		return;
	}
	
	self anim_stopanimscripted();
	wait(0.05);
	maps\_anim::anim_single_solo( self, "fake_surrender_death", undefined, animnode );
	self.deathanim = undefined;
	self.nodeathragdoll = true;
	self.allowdeath = true;
	self stop_magic_bullet_shield();
	self SetCanDamage( true );
	self.health = 1;
	self.a.nodeath = true;
	self DoDamage( self.health + 1000, self.origin ); 
}

handle_fake_surrender(guy)
{
	level.polonsky thread do_dialogue("shit");
	level thread enable_player_weapons();
	level thread roebuck_attackers_think();
	level.stop_surrender_dialog = true;
	surrender_guys = getentarray("surrender_guy","script_noteworthy");	
	for(i=0;i<surrender_guys.size;i++)
	{
		if(surrender_guys[i].animname == "surrender_3")
		{
			surrender_guys[i] thread roebuck_attacker1_think();
		}
		if(surrender_guys[i].animname == "surrender_2")
		{	
			surrender_guys[i] thread roebuck_attacker2_think();
		}
		if( surrender_guys[i].animname == "surrender_1")
		{
			surrender_guys[i] thread polonsky_attacker_think();
			surrender_guys[i] thread kill_sarge_if_me_is_killed();
			surrender_guys[i] thread polonsky_attacker_watch();
		}
	}
	level notify("stop_feign");
	//wait(12);
	//getent("start_final_defend","script_noteworthy") notify("trigger");
}

roebuck_attackers_think()
{
	level endon("too_late");
	level endon("attacker_shot");
	
	level waittill_multiple("attacker1","attacker2");
		
	if(!isDefined(level.attacker_shot))
	{
		level.sarge stopanimscripted();
	}
	level.sarge_saved = true;
	level notify("sarge_saved");
}

roebuck_attacker1_think()
{
	level endon("too_late");
	level endon("attacker_shot");
	
	self.health = 5;
	self.allowdeath = true;
	self waittill("death");
	level notify("attacker1");	
}

roebuck_attacker2_think()
{
	level endon("too_late");
	
	self.health = 5;
	self.allowdeath = true;
	self waittill("death");
	level notify("attacker2");
}

#using_animtree("generic_human");
//if sarge is saved, Polonsky dies
polonsky_attacker_think()
{
	level endon("too_late");
	surrender_node = getnode("courtyard_anim","targetname");
	
	self.allowdeath = true;
	self endon("death");
	level waittill("sarge_saved");
	
	if(isDefined(level.sarge_saved))
	{	
		level.polonsky stop_magic_bullet_shield();
		level.polonsky.health = 1;
		self.health = 1;
		level.polonsky.allowdeath = false;
		level.polonsky setcandamage(true);
		level.polonsky.nodeathragdoll = true;
		level.polonsky.deathanim = level.scr_anim["polonsky"]["fake_surrender_death"];
		level.polonsky notify("_disable_reinforcement");
		org = self.origin + (0,0,40);
		self.grenadeammo = 1;
		self.deathanim = %death_explosion_stand_B_v2;
		surrender_node thread maps\_anim::anim_single_solo(level.polonsky,"fake_surrender_death");
		level.polonsky.allowdeath = true;
		self magicgrenadetype("fraggrenade",org,(0,0,-1),.05);
		PlaySoundAtPosition(level.scr_sound["polonsky"]["polonsky_death"],org);

	}
}

polonsky_attacker_watch()
{
	level endon("sarge_saved");
	self endon("death");
	surrender_node = getnode("courtyard_anim","targetname");
	
	level waittill("too_late");
	self.allowdeath = false;	
	self.deathanim =  %ch_oki3_outro_japanese1_dead;
	self.nodeathragdoll = true;
}

kill_sarge_if_me_is_killed()
{
	level endon("too_late");
	
	self waittill("death");
	surrender_node = getnode("courtyard_anim","targetname");	
	guys = [];
	if(!isDefined(level.sarge_dead))
	{	
		level.attacker_shot = true;

		level.sarge notify("_disable_reinforcement");
		surrender_guys = getentarray("surrender_guy","script_noteworthy");	
		for(i=0;i<surrender_guys.size;i++)
		{
			
			if( isDefined(surrender_guys[i]) && isDefined(surrender_guys[i].animname) && surrender_guys[i].animname == "surrender_3" && isAlive(surrender_guys[i]))
			{
				surrender_guys[i].deathanim = %ch_oki3_outro_japanese3_dead;
				surrender_guys[i].nodeathragdoll = true;
				surrender_guys[i].allowdeath = false;
				surrender_guys[i].health = 1;
				guys[guys.size] = surrender_guys[i];
			}
			if(isDefined(surrender_guys[i]) && isDefined(surrender_guys[i].animname) && surrender_guys[i].animname == "surrender_2" && isAlive(surrender_guys[i]))
			{	
				surrender_guys[i].allowdeath = false;
				surrender_guys[i].nodeathragdoll = true;
				surrender_guys[i].deathanim = %ch_oki3_outro_japanese2_dead;
				surrender_guys[i].health = 1;
				guys[guys.size] = surrender_guys[i];
			}	
		}

		org = level.sarge.origin + (0,0,40);
		level.sarge thread play_sarge_death( surrender_node );
		
		surrender_node thread maps\_anim::anim_single(guys,"fake_surrender_death");
		level.sarge magicgrenadetype("fraggrenade",org,(0,0,-1),.05);	
		for(i=0;i<guys.size;i++)
		{
			guys[i].allowdeath = true;
		}	

		level notify("polonsky_saved");
		level.polonsky_saved = true;
		level.sarge_dead = true;
		PlaySoundAtPosition(level.scr_sound["sarge"]["sarge_death"],level.death_org);
		level.polonsky_attacker_shot = true;
		level.polonsky stopanimscripted();
		level.polonsky.a.pose = "stand";
	}
}



spawn_banzai_wave(location,vertical)
{
	
	spawners = GetSpawnerArray();
	spawner = [];
	
	for(i=0;i<spawners.size;i++)
	{
		if(isDefined(spawners[i].targetname ) && spawners[i].targetname == "feign_death_guys")
		{
			spawner[spawner.size] = spawners[i];
		}
	}
	
	wave_size = randomintrange(4,7);
	size = get_frontline_guys();
	
	if(size < wave_size)
	{
		wave_size = wave_size - size;;
	}	
	else if(size >= wave_size)
	{
		wave_size = 0;
	}	
		
	for(i=0;i<wave_size;i++)
	{	
		spawner[i] add_spawn_function(::banzai_wave_spawnfunc);
		spawner[i].origin = location + ( randomintrange(-50,50),randomintrange(-50,50),0);
		spawner[i].count = 1;
		spawner[i].pacifist = false;
	  spawner[i].script_forcespawn = 1;
		spawner[i] stalingradspawn();
		wait(randomfloatrange(.1,.7));
	}
	
}

banzai_wave_spawnfunc()
{
	self endon("death");
	
	//self maps\oki3_anim::banzai_run_anim_setup();
	
	self.banzai_no_wait = 1;
	self maps\_banzai::banzai_force();
	
}

airstrike_radio_dialogue()
{

	level endon("stop_air_support");
	while(1)
	{		
		level waittill("airstrike_used",target);
		switch(target)
		{
			
			case "building_1": 					
				if(isDefined(level.building1_destroyed) && level.building1_destroyed)
				{
					wait(15);	
					level.last_hero thread do_dialogue("miss");
				}
				else
				{
					wait(15);	
					level.last_hero thread do_dialogue("hit");
					level notify ("audio_one_down");

				}
				break;					
				
			case "building_4": 
				wait(15);	
				level.last_hero thread do_dialogue("hit");
				break;		
			
			case "courtyard_ne"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_ne_spline");break;
			case "courtyard_se"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_se_spline");break;
			case "courtyard_nw"://thread maps\oki3_courtyard::courtyard_bomb_run("courtyard_nw_spline");break;
			case "courtyard_sw":
				wait(15);	
				level.last_hero thread do_dialogue("miss");
				break;		
		}			
	}
}


magic_grenades_from_hell(time)
{
	level endon("stop_grenades");
	k =0;
	if(!isDefined(time))
	{
		time = 180;
	}
	while(k< time)
	{
		wait(1);
		k++;
	}	
	
	x =0;
	time = 10;
	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			players[i] MagicGrenadeType("type97_frag", players[i].origin + (0,0,150),(0,0,-150) ,3 );

		}
		wait(time);
		x++;
		if(time - x < 1)
		{
			time = 1;
		}
		else
		{
			time = time - x;
		}				
	}
}