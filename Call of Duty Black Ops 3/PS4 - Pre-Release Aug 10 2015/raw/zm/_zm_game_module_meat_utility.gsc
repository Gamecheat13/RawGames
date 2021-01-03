#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_game_module_utility;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_weapon_minigun;

#namespace zm_game_module_meat_utility;

/*------------------------------------
gives 4 grenades to each team member
------------------------------------*/
function award_grenades_for_team(team)
{
	players = GetPlayers();	
	
	for(i=0;i<players.size;i++)
	{
		
		if(!isDefined(players[i]._meat_team) || players[i]._meat_team != team)
		{
			continue;
		}		
		lethal_grenade = players[i] zm_utility::get_player_lethal_grenade();
		players[i] GiveWeapon( lethal_grenade );	
		players[i] SetWeaponAmmoClip( lethal_grenade, 4 );
	}
}

/*------------------------------------
gets all the players on a team 
------------------------------------*/
function get_players_on_meat_team(team)
{
	players = GetPlayers();	
	players_on_team = [];
	for(i=0;i<players.size;i++)
	{
		if(!isDefined(players[i]._meat_team) || players[i]._meat_team != team )
		{
			continue;
		}

		players_on_team[players_on_team.size] = players[i];
	}
	return players_on_team;
}

/*------------------------------------
gets all the players on a team that are 
not in last stand or in spectate mode
------------------------------------*/
function get_alive_players_on_meat_team(team)
{
	players = GetPlayers();	
	players_on_team = [];
	for(i=0;i<players.size;i++)
	{
		if( (!isDefined(players[i]._meat_team)) || (players[i]._meat_team != team) )
		{
			continue;
		}
		if(players[i].sessionstate == "spectator" || players[i] laststand::player_is_in_laststand() )
		{
			continue;
		}
		
		players_on_team[players_on_team.size] = players[i];
	}
	return players_on_team;
}

/*------------------------------------
	player MagicGrenadeType( zm_utility::get_gamemode_var( "item_meat_name" ), org, (0, 0, 0) );

	playsoundatposition("zmb_spawn_powerup", org);
	wait(.1);
	player._spawning_meat = undefined;
}

/*------------------------------------
The minigun hoop
------------------------------------*/
function init_minigun_ring()
{

	if(isDefined(level._minigun_ring))
	{
		return;
	}
	
	ring_pos = struct::get(level._meat_location + "_meat_minigun","script_noteworthy");
	if(!isdefined(ring_pos))
	{
		return;
	}
	
	level._minigun_ring = spawn("script_model",ring_pos.origin);
	level._minigun_ring.angles = ring_pos.angles;
	level._minigun_ring setmodel(ring_pos.script_parameters);
	
	level._minigun_ring_clip = getent(level._meat_location + "_meat_minigun_clip","script_noteworthy");
	level._minigun_ring_clip linkto(level._minigun_ring);
	level._minigun_ring_trig = getent(level._meat_location + "_meat_minigun_trig","targetname");	
	level._minigun_ring_trig enablelinkto();
	level._minigun_ring_trig linkto(level._minigun_ring);	

	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
	minigun_weapon = GetWeapon( "minigun" );
	level._minigun_icon SetModel( minigun_weapon.worldModel );
	level._minigun_icon linkto(level._minigun_ring);
	util::wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
	level thread ring_toss(level._minigun_ring_trig,"minigun");
	level._minigun_ring thread zm_game_module_utility::move_ring(ring_pos);
	level._minigun_ring thread zm_game_module_utility::rotate_ring(true);	
}

function init_ammo_ring()
{

	if(isDefined(level._ammo_ring))
	{
		return;
	}
	name = level._meat_location + "_meat_ammo";
	ring_pos = struct::get(name,"script_noteworthy");
	if(!isdefined(ring_pos))
	{
		return;
	}
	
	level._ammo_ring = spawn("script_model",ring_pos.origin);
	level._ammo_ring.angles = ring_pos.angles;
	level._ammo_ring setmodel(ring_pos.script_parameters);
	
	name = level._meat_location + "_meat_ammo_clip";
	level._ammo_ring_clip = getent(name,"script_noteworthy");
	level._ammo_ring_clip linkto(level._ammo_ring);
	
	name = level._meat_location + "_meat_ammo_trig";
	
	level._ammo_ring_trig = getent(name,"targetname");	
	level._ammo_ring_trig enablelinkto();
	level._ammo_ring_trig linkto(level._ammo_ring);	
	level._ammo_icon = spawn("script_model",level._ammo_ring_trig.origin);
	level._ammo_icon SetModel( "zombie_ammocan" );
	level._ammo_icon linkto(level._ammo_ring);
	util::wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
	level thread ring_toss(level._ammo_ring_trig,"ammo");
	level._ammo_ring thread zm_game_module_utility::move_ring(ring_pos);
	level._ammo_ring thread zm_game_module_utility::rotate_ring(true);
}

function init_splitter_ring()
{
	if(isDefined(level._splitter_ring))
	{
		return;
	}
	ring_pos = struct::get(level._meat_location + "_meat_splitter","script_noteworthy");
	if(!isdefined(ring_pos))
	{
		return;
	}
	
	level._splitter_ring = spawn("script_model",ring_pos.origin);
	level._splitter_ring.angles = ring_pos.angles;
	level._splitter_ring setmodel(ring_pos.script_parameters);
	level._splitter_ring_trig1 = getent(level._meat_location + "_meat_splitter_trig_1","targetname");	
	level._splitter_ring_trig2 = getent(level._meat_location + "_meat_splitter_trig_2","targetname");
	level._splitter_ring_trig1 enablelinkto();
	level._splitter_ring_trig2 enablelinkto();
	level._splitter_ring notsolid();
	level._meat_icon = spawn("script_model",level._splitter_ring.origin);
	item_meat_weapon = zm_utility::get_gamemode_var( "item_meat_name" );
	level._meat_icon setmodel( item_meat_weapon.worldModel );
	level._meat_icon linkto(level._splitter_ring);	
	util::wait_network_frame();
	playfxontag(level._effect["meat_glow"],level._meat_icon,"tag_origin");
	level._splitter_ring_trig1 linkto(level._splitter_ring);
	level._splitter_ring_trig2 linkto(level._splitter_ring);
	level thread ring_toss(level._splitter_ring_trig1,"splitter");
	level thread ring_toss(level._splitter_ring_trig2,"splitter");
	level._splitter_ring thread zm_game_module_utility::move_ring(ring_pos);
}

function ring_toss(trig,type)
{
	level endon("end_game");
	
	while(1)
	{
		if(( isdefined( level._ring_triggered ) && level._ring_triggered ))
		{
			wait(.05);
			continue;
		}
		if( isDefined(level.item_meat) && ( isdefined( level.item_meat.meat_is_moving ) && level.item_meat.meat_is_moving ) )
		{
			if( level.item_meat istouching(trig))
			{
				level thread ring_toss_prize(type,trig);				
				level._ring_triggered = true;
				level thread ring_cooldown();
			}
		}
		wait(.05);
	}
}

function ring_cooldown()
{
	wait(3);
	level._ring_triggered = false;
}

function ring_toss_prize(type,trig)
{
	switch(type)
	{
		case "splitter":
			level thread meat_splitter(trig);
			break;
		case "minigun":
			level thread minigun_prize(trig);
			break;
		case "ammo":
			level thread ammo_prize(trig);
			break;
	}
	
}
function meat_splitter(trig)
{
	level endon("meat_grabbed");
	level endon("meat_kicked");
		
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	exit_trig = getent(trig.target,"targetname");
	exit_struct = struct::get(trig.target,"targetname");
	while(isDefined(level.item_meat) && !level.item_meat istouching(exit_trig) )
	{
		wait(.05);
	}
	while(isDefined(level.item_meat) && level.item_meat istouching(exit_trig))
	{
		wait(.05);
	}
	
	if(!isDefined(level.item_meat))
	{
		return;
	}
	playfx(level._effect["fw_burst"],exit_trig.origin);
	
	flare_dir = VectorNormalize(anglestoforward(exit_struct.angles));
	velocity = VectorScale( flare_dir, RandomIntRange(400, 600));
	
	velocity1 = (velocity[0] + 75, velocity[1] + 75 ,randomintrange(75,125));
	velocity2 = (velocity[0] - 75,velocity[1] - 75 ,randomintrange(75,125));
	velocity3 = (velocity[0] ,velocity[1] ,100);
	level._fake_meats = [];
	level._meat_splitter_activated = true;
	org = exit_trig.origin;
	player = GetPlayers()[0];
	player._spawning_meat = true;		
	player endon("disconnect");
		
	thread split_meat( player, org, velocity1, velocity2, velocity );
	
	level thread zm_audio_announcer::leaderDialog( "meat_ring_splitter", undefined, undefined, true );
	wait(.1);
	while (( isdefined( level.splitting_meat ) && level.splitting_meat ))
		{wait(.05);};
	player._spawning_meat = false;
}

function split_meat( player, org, vel1, vel2, vel3 )
{
	level.splitting_meat = true;
	
//	level.item_meat zmeat::cleanup_meat();	
	util::wait_network_frame();
	
	level._fake_meats[level._fake_meats.size] = player MagicGrenadeType( zm_utility::get_gamemode_var( "item_meat_name" ), org, vel1 );
	util::wait_network_frame();
	level._fake_meats[level._fake_meats.size] = player MagicGrenadeType( zm_utility::get_gamemode_var( "item_meat_name" ), org, vel2 );
	util::wait_network_frame();
	level._fake_meats[level._fake_meats.size] = player MagicGrenadeType( zm_utility::get_gamemode_var( "item_meat_name" ), org, vel3 );
	
	real_meat = array::random(level._fake_meats);
	foreach(meat in level._fake_meats)
	{
		if(real_meat != meat)
		{
			meat._fake_meat = true;
//			meat thread zmeat::delete_on_real_meat_pickup();
		}
		else
		{
			meat._fake_meat = false;
			level.item_meat = meat;
		}
	}
	level.splitting_meat = false;
	
}


function minigun_prize(trig)
{
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	if(!isDefined(level.item_meat))
	{
		return;
	}
	if(( isdefined( level._minigun_toss_cooldown ) && level._minigun_toss_cooldown ))
	{
		return;
	}
	level thread minigun_toss_cooldown();
	if( !zm_utility::is_player_valid(level._last_person_to_throw_meat))
	{
		return;
	} 
	level._last_person_to_throw_meat thread zm_powerups::powerup_vo("minigun");
	level thread zm_powerup_weapon_minigun::minigun_weapon_powerup( level._last_person_to_throw_meat );
	level thread zm_audio_announcer::leaderDialog( "meat_ring_minigun", undefined, undefined, true );
}

function ammo_prize(trig)
{
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	if(!isDefined(level.item_meat))
	{
		return;
	}
	if(( isdefined( level._ammo_toss_cooldown ) && level._ammo_toss_cooldown ))
	{
		return;
	}
	playfx(level._effect["poltergeist"],trig.origin);
	level thread ammo_toss_cooldown();
	level._last_person_to_throw_meat thread zm_powerups::powerup_vo("full_ammo");
	level thread zm_powerup_full_ammo::full_ammo_powerup(undefined,level._last_person_to_throw_meat);
	level thread zm_audio_announcer::leaderDialog( "meat_ring_ammo", undefined, undefined, true );
}


function minigun_toss_cooldown()
{
	level._minigun_toss_cooldown = true;
	if(isDefined(level._minigun_icon))
	{
		level._minigun_icon delete();
		
	}
	util::waittill_any_timeout(120,"meat_end");
	playfx(level._effect["poltergeist"],level._minigun_ring_trig.origin);
	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
	minigun_weapon = GetWeapon( "minigun" );
	level._minigun_icon SetModel( minigun_weapon.worldModel );
	level._minigun_icon linkto(level._minigun_ring);
	util::wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
	level._minigun_toss_cooldown = false;
	
}

function ammo_toss_cooldown()
{
	
	level._ammo_toss_cooldown = true;
	if(isDefined(level._ammo_icon))
	{
		level._ammo_icon delete();
		
	}
	util::waittill_any_timeout(60,"meat_end");
	playfx(level._effect["poltergeist"],level._ammo_ring_trig.origin);
	level._ammo_icon = spawn("script_model",level._ammo_ring_trig.origin);
	level._ammo_icon SetModel( "zombie_ammocan" );
	level._ammo_icon linkto(level._ammo_ring);
	util::wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
	level._ammo_toss_cooldown = false;
	
}


function wait_for_team_death(team)
{
	level endon("meat_end");	
	encounters_team = undefined;	
	while(1)
	{
		wait 1;
		
		while(( isdefined( level._checking_for_save ) && level._checking_for_save ))
		{
			wait(.1);
		}
				
		alive_team_players = get_alive_players_on_meat_team(team);
		if(alive_team_players.size > 0)
		{
			encounters_team = alive_team_players[0]._encounters_team;
			continue;
		}
		break;
	}	
	if(!isDefined(encounters_team))
	{
		return;
	}
	winning_team = "A";
	if(encounters_team  == "A")
	{
		winning_team = "B";
	}	
	level notify("meat_end",winning_team);
}

function check_should_save_player(team)
{
	
	if(!isDefined(level._meat_on_team))
	{
		return false;
	}
	level._checking_for_save = true;
	players = get_players_on_meat_team(team);
	
	for(i=0;i<players.size;i++)
	{
		player = players[i];
		
		if(isDefined(level._last_person_to_throw_meat) && level._last_person_to_throw_meat == player)
		{
			while(( isdefined( level.item_meat.meat_is_moving ) && level.item_meat.meat_is_moving ) || ( isdefined( level._meat_splitter_activated ) && level._meat_splitter_activated ) || ( isdefined( level.item_meat.meat_is_flying ) && level.item_meat.meat_is_flying ))
			{
				if(level._meat_on_team != player._meat_team)
				{
					break;
				}
				if(( isdefined( level.item_meat.meat_is_rolling ) && level.item_meat.meat_is_rolling ) && level._meat_on_team == player._meat_team) //meat is rolling around on the players side, don't wait for it
				{
					break;
				}
				wait(.05);
			}
			if(!isDefined(player) )
			{
				level._checking_for_save = false;
				return false;
			}
			if(!( isdefined( player.last_damage_from_zombie_or_player ) && player.last_damage_from_zombie_or_player ))
			{
				level._checking_for_save = false;
				return false;
			}
			if(level._meat_on_team != player._meat_team && isDefined(level._last_person_to_throw_meat) && level._last_person_to_throw_meat == player) //make sure nobody else touched the meat while we were waiting to be saved
			{
				if(player laststand::player_is_in_laststand() )
				{
					level thread revive_saved_player(player);					
					return true;
				}
			}
		}
	}
	level._checking_for_save = false;
	return false;
}

function watch_save_player()
{
	if(!isDefined(level._meat_on_team))
	{
		return false;
	}
	/*
	/#
	if(GetDvarString("debug_death") != "")
		self.last_damage_from_zombie_or_player = 1;
	#/
	if(!IS_TRUE(self.last_damage_from_zombie_or_player ))
	{
		return false;
	}
	*/
	if(!isDefined(level._last_person_to_throw_meat) || level._last_person_to_throw_meat != self)
	{
		return false;
	}

	level._checking_for_save = true;
		
	while(( isdefined( level.splitting_meat ) && level.splitting_meat ) || 
	      ( isdefined(level.item_meat) && (( isdefined( level.item_meat.meat_is_moving ) && level.item_meat.meat_is_moving ) || ( isdefined( level.item_meat.meat_is_flying ) && level.item_meat.meat_is_flying ))))
	{
		if(level._meat_on_team != self._meat_team)
		{
			break;
		}
		if( isdefined(level.item_meat) && ( isdefined( level.item_meat.meat_is_rolling ) && level.item_meat.meat_is_rolling ) && level._meat_on_team == self._meat_team) //meat is rolling around on the players side, don't wait for it
		{
			break;
		}
		wait(.05);
	}
	if(level._meat_on_team != self._meat_team && isDefined(level._last_person_to_throw_meat) && level._last_person_to_throw_meat == self) //make sure nobody else touched the meat while we were waiting to be saved
	{
		if(self laststand::player_is_in_laststand() )
		{
			level thread revive_saved_player(self);					
			return true;
		}
	}

	level._checking_for_save = false;
	return false;
}


function revive_saved_player(player)
{
	player endon("disconnect");
	
	player iprintlnbold(&"ZOMBIE_PLAYER_SAVED"); //"PLAYER SAVED!"
	player playsound( level.zmb_laugh_alias );
	wait(.25);
	Playfx( level._effect["poltergeist"], player.origin );
	playsoundatposition( "zmb_bolt", player.origin );
	Earthquake( 0.5, 0.75, player.origin, 1000);					
	player thread zm_laststand::auto_revive( player );
	player._saved_by_throw++;
	level._checking_for_save = false;
}

function get_game_module_players(player)
{
	return get_players_on_meat_team(player._meat_team);
}

/*------------------------------------
spawn the meat at the specified origin
------------------------------------*/
function item_meat_spawn(origin)
{
	org = origin;
	player = GetPlayers()[0];
	player._spawning_meat = true;
	player MagicGrenadeType( zm_utility::get_gamemode_var("item_meat_name"), org, (0, 0, 0) );

	playsoundatposition("zmb_spawn_powerup", org);
	wait(.1);
	player._spawning_meat = undefined;
}

function init_item_meat()
{
	item_meat_weapon = GetWeapon( "meat_stink" );
	zm_utility::set_gamemode_var_once( "item_meat_weapon", item_meat_weapon );
	
	level.meat_pickUpSound = item_meat_weapon.pickupSound;
	level.meat_pickUpSoundPlayer = item_meat_weapon.pickupSoundPlayer;
}

function meat_intro( launch_spot )
{
	level flag::wait_till("start_encounters_match_logic");
	wait(3);
	level thread multi_launch( launch_spot );
	launch_meat( launch_spot );
	drop_meat(level._meat_start_point);
	level thread zm_audio_announcer::leaderDialog( "meat_drop", undefined, undefined, true );
}

function launch_meat( launch_spot )
{
	level waittill("launch_meat");
	spots = struct::get_array( launch_spot ,"targetname");
	if ( isdefined(spots) && spots.size > 0)
	{
		spot = array::random(spots);
		meat = spawn("script_model",spot.origin);
		meat setmodel("tag_origin");
		util::wait_network_frame();	
		PlayFXOnTag( level._effect[ "fw_trail" ], meat, "tag_origin" );
		meat playloopsound( "zmb_souls_loop", .75 );
		
		dest =spot;	
	
		while(isDefined(dest) && isDefined(dest.target))
		{
			new_dest = struct::get(dest.target,"targetname");	
			dest = new_dest;
			dist = distance(new_dest.origin,meat.origin);
			time = dist/700;							
			meat MoveTo(new_dest.origin, time);
			meat waittill("movedone");
		}
	 	meat playsound( "zmb_souls_end");
	
		playfx(level._effect["fw_burst"],meat.origin);
		wait(randomfloatrange(.2,.5));
		meat playsound( "zmb_souls_end");
		playfx(level._effect["fw_burst"],meat.origin + (randomintrange(50,150),randomintrange(50,150),randomintrange(-20,20)) );
		wait(randomfloatrange(.5,.75));
		meat playsound( "zmb_souls_end");
		playfx(level._effect["fw_burst"],meat.origin + (randomintrange(-150,-50),randomintrange(-150,50),randomintrange(-20,20)) );
		wait(randomfloatrange(.5,.75));
		meat playsound( "zmb_souls_end");
		playfx(level._effect["fw_burst"],meat.origin);
		
		meat delete();
	}
}


function multi_launch( launch_spot )
{
	spots = struct::get_array( launch_spot ,"targetname");
	
	if ( isdefined(spots) && spots.size > 0)
	{
		for(x=0;x<3;x++)
		{
			for(i=0;i<spots.size;i++)
			{
				delay = randomfloatrange(.1,.25);
				level thread fake_launch(spots[i],delay);
			}
			wait(randomfloatrange(.25,.75));
			if(x > 1) // launch the real meat now
			{
				level notify("launch_meat");
			}
		}
	}
	else
	{
		wait(randomfloatrange(.25,.75));
		level notify("launch_meat");
	}
}

function fake_launch(launch_spot,delay)
{
	wait(delay);
	wait(randomfloatrange(.1,4));
	meat = spawn("script_model",launch_spot.origin + (randomintrange(-60,60),randomintrange(-60,60),0));
	meat setmodel("tag_origin");
	util::wait_network_frame();	
	PlayFXOnTag( level._effect[ "fw_trail_cheap" ], meat, "tag_origin" );
	meat playloopsound( "zmb_souls_loop", .75 );
	
	dest = launch_spot;	

	while(isDefined(dest) && isDefined(dest.target))
	{
		random_offset = (randomintrange(-60,60),randomintrange(-60,60),0);
		new_dest = struct::get(dest.target,"targetname");	
		dest = new_dest;
		dist = distance(new_dest.origin + random_offset,meat.origin);
		time = dist/700;							
		meat MoveTo(new_dest.origin + random_offset, time);
		meat waittill("movedone");
	}
 	meat playsound( "zmb_souls_end");

	playfx(level._effect["fw_pre_burst"],meat.origin);
	meat delete();
}

function drop_meat(drop_spot)
{
	meat = spawn("script_model",drop_spot + (0,0,600));
	meat setmodel("tag_origin");
	dist = distance(meat.origin,drop_spot);
	time = dist/400;	
	wait(2);	// hacks
	meat MoveTo(drop_spot,time);
	util::wait_network_frame();
	playfxontag(level._effect["fw_drop"],meat,"tag_origin");			
	meat waittill("movedone");
	playfx(level._effect["fw_impact"],drop_spot);
	level notify("reset_meat");
	meat delete();
}

