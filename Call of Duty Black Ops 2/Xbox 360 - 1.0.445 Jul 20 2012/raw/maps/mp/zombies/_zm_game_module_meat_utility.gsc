#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

/*------------------------------------
gives 4 grenades to each team member
------------------------------------*/
award_grenades_for_team(team)
{
	players = GET_PLAYERS();	
	
	for(i=0;i<players.size;i++)
	{
		
		if(!isDefined(players[i]._meat_team) || players[i]._meat_team != team)
		{
			continue;
		}		
		lethal_grenade = players[i] get_player_lethal_grenade();
		players[i] GiveWeapon( lethal_grenade );	
		players[i] SetWeaponAmmoClip( lethal_grenade, 4 );
	}
}

/*------------------------------------
gets all the players on a team 
------------------------------------*/
get_players_on_meat_team(team)
{
	players = GET_PLAYERS();	
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
get_alive_players_on_meat_team(team)
{
	players = GET_PLAYERS();	
	players_on_team = [];
	for(i=0;i<players.size;i++)
	{
		if( (!isDefined(players[i]._meat_team)) || (players[i]._meat_team != team) )
		{
			continue;
		}
		if(players[i].sessionstate == "spectator" || players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			continue;
		}
		
		players_on_team[players_on_team.size] = players[i];
	}
	return players_on_team;
}

/*------------------------------------
spawn the meat at the specified origin
------------------------------------*/
item_meat_spawn(origin)
{
	org = origin;
	player = GET_PLAYERS()[0];
	player._spawning_meat = true;
	player MagicGrenadeType( level.item_meat_name, org, (0, 0, 0) );

	playsoundatposition("zmb_spawn_powerup", org);
	wait(.1);
	player._spawning_meat = undefined;
}

/*------------------------------------
The minigun hoop
------------------------------------*/
init_minigun_ring()
{

	if(isDefined(level._minigun_ring))
	{
		return;
	}
	ring_pos = getstruct(level._meat_location + "_meat_minigun","script_noteworthy");
	level._minigun_ring = spawn("script_model",ring_pos.origin);
	level._minigun_ring.angles = ring_pos.angles;
	level._minigun_ring setmodel(ring_pos.script_parameters);
	
	level._minigun_ring_clip = getent(level._meat_location + "_meat_minigun_clip","script_noteworthy");
	level._minigun_ring_clip linkto(level._minigun_ring);
	level._minigun_ring_trig = getent(level._meat_location + "_meat_minigun_trig","targetname");	
	level._minigun_ring_trig enablelinkto();
	level._minigun_ring_trig linkto(level._minigun_ring);	

	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
	level._minigun_icon SetModel( GetWeaponModel("minigun_zm" ) );
	level._minigun_icon linkto(level._minigun_ring);
	wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
	level thread ring_toss(level._minigun_ring_trig,"minigun");
	level._minigun_ring thread move_ring(ring_pos);
	level._minigun_ring thread rotate_ring(true);	
}

init_ammo_ring()
{

	if(isDefined(level._ammo_ring))
	{
		return;
	}
	name = level._meat_location + "_meat_ammo";
	ring_pos = getstruct(name,"script_noteworthy");
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
	wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
	level thread ring_toss(level._ammo_ring_trig,"ammo");
	level._ammo_ring thread move_ring(ring_pos);
	level._ammo_ring thread rotate_ring(true);
}

init_splitter_ring()
{
	if(isDefined(level._splitter_ring))
	{
		return;
	}
	ring_pos = getstruct(level._meat_location + "_meat_splitter","script_noteworthy");
	level._splitter_ring = spawn("script_model",ring_pos.origin);
	level._splitter_ring.angles = ring_pos.angles;
	level._splitter_ring setmodel(ring_pos.script_parameters);
	level._splitter_ring_trig1 = getent(level._meat_location + "_meat_splitter_trig_1","targetname");	
	level._splitter_ring_trig2 = getent(level._meat_location + "_meat_splitter_trig_2","targetname");
	level._splitter_ring_trig1 enablelinkto();
	level._splitter_ring_trig2 enablelinkto();
	level._splitter_ring notsolid();
	level._meat_icon = spawn("script_model",level._splitter_ring.origin);
	level._meat_icon setmodel(getweaponmodel(level.item_meat_name));
	level._meat_icon linkto(level._splitter_ring);	
	wait_network_frame();
	playfxontag(level._effect["meat_glow"],level._meat_icon,"tag_origin");
	level._splitter_ring_trig1 linkto(level._splitter_ring);
	level._splitter_ring_trig2 linkto(level._splitter_ring);
	level thread ring_toss(level._splitter_ring_trig1,"splitter");
	level thread ring_toss(level._splitter_ring_trig2,"splitter");
	level._splitter_ring thread move_ring(ring_pos);
}



move_ring(ring)
{
	positions = getstructarray(ring.target,"targetname");
	positions = array_randomize(positions);
	level endon("end_race");
	
	while(1)
	{
		foreach(position in positions)
		{
			self moveto(position.origin,randomintrange(30,45));
			self waittill("movedone");
		}
	}
}

rotate_ring(forward)
{
	level endon("end_game");
	dir = -360;
	if(forward)
	{
		dir = 360;
	}
	while(1)
	{
		self rotateyaw(dir,9);
		wait(9);
	}
}

ring_toss(trig,type)
{
	level endon("end_game");
	
	while(1)
	{
		if(is_true(level._ring_triggered))
		{
			wait(.05);
			continue;
		}
		if( isDefined(level.item_meat) && is_true(level.item_meat.meat_is_moving) )
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

ring_cooldown()
{
	wait(3);
	level._ring_triggered = false;
}

ring_toss_prize(type,trig)
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
meat_splitter(trig)
{
	level endon("meat_grabbed");
	level endon("meat_kicked");
		
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	exit_trig = getent(trig.target,"targetname");
	exit_struct = getstruct(trig.target,"targetname");
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
	level.item_meat delete();	
	wait_network_frame();
	player = GET_PLAYERS()[0];
	player._spawning_meat = true;		
	player endon("disconnect");
		
	level._fake_meats[level._fake_meats.size] = player MagicGrenadeType( level.item_meat_name, org, velocity1);
	wait_network_frame();
	level._fake_meats[level._fake_meats.size] = player MagicGrenadeType( level.item_meat_name, org, velocity2 );
	wait_network_frame();
	level._fake_meats[level._fake_meats.size]= player MagicGrenadeType( level.item_meat_name, org, velocity );
	
	real_meat = random(level._fake_meats);
	real_meat._fake_meat = false;
	foreach(meat in level._fake_meats)
	{
		if(real_meat != meat)
		{
			meat._fake_meat = true;
		}
		meat thread maps\mp\zombies\_zm_game_module_meat::delete_on_real_meat_pickup();
	}	
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_ring_splitter", undefined, undefined, true );
	wait(.1);
	player._spawning_meat = false;
}

minigun_prize(trig)
{
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	if(!isDefined(level.item_meat))
	{
		return;
	}
	if(is_true(level._minigun_toss_cooldown))
	{
		return;
	}
	level thread minigun_toss_cooldown();
	if( !is_player_valid(level._last_person_to_throw_meat))
	{
		return;
	} 
	level._last_person_to_throw_meat thread maps\mp\zombies\_zm_powerups::powerup_vo("minigun");
	level thread maps\mp\zombies\_zm_powerups::minigun_weapon_powerup( level._last_person_to_throw_meat );
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_ring_minigun", undefined, undefined, true );
}

ammo_prize(trig)
{
	while(isDefined(level.item_meat) && level.item_meat istouching(trig))
	{
		wait(.05);
	}
	if(!isDefined(level.item_meat))
	{
		return;
	}
	if(is_true(level._ammo_toss_cooldown))
	{
		return;
	}
	playfx(level._effect["poltergeist"],trig.origin);
	level thread ammo_toss_cooldown();
	level._last_person_to_throw_meat thread maps\mp\zombies\_zm_powerups::powerup_vo("full_ammo");
	level thread maps\mp\zombies\_zm_powerups::full_ammo_powerup(undefined,level._last_person_to_throw_meat);
	level thread maps\mp\zombies\_zm_audio_announcer::leaderDialog( "meat_ring_ammo", undefined, undefined, true );
}


minigun_toss_cooldown()
{
	level._minigun_toss_cooldown = true;
	if(isDefined(level._minigun_icon))
	{
		level._minigun_icon delete();
		
	}
	waittill_any_or_timeout(120,"meat_end");
	playfx(level._effect["poltergeist"],level._minigun_ring_trig.origin);
	level._minigun_icon = spawn("script_model",level._minigun_ring_trig.origin);
	level._minigun_icon SetModel( GetWeaponModel("minigun_zm" ) );
	level._minigun_icon linkto(level._minigun_ring);
	wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._minigun_icon,"tag_origin");
	level._minigun_toss_cooldown = false;
	
}

ammo_toss_cooldown()
{
	
	level._ammo_toss_cooldown = true;
	if(isDefined(level._ammo_icon))
	{
		level._ammo_icon delete();
		
	}
	waittill_any_or_timeout(60,"meat_end");
	playfx(level._effect["poltergeist"],level._ammo_ring_trig.origin);
	level._ammo_icon = spawn("script_model",level._ammo_ring_trig.origin);
	level._ammo_icon SetModel( "zombie_ammocan" );
	level._ammo_icon linkto(level._ammo_ring);
	wait_network_frame();
	playfxontag( level._effect["powerup_on"],level._ammo_icon,"tag_origin");
	level._ammo_toss_cooldown = false;
	
}


wait_for_team_death(team)
{
	level endon("meat_end");	
	encounters_team = undefined;	
	while(1)
	{
		wait 1;
		
		while(is_true(level._checking_for_save))
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

check_should_save_player(team)
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
			while(is_true(level.item_meat.meat_is_moving) || is_true(level._meat_splitter_activated) || is_true(level.item_meat.meat_is_flying))
			{
				if(level._meat_on_team != player._meat_team)
				{
					break;
				}
				if(is_true(level.item_meat.meat_is_rolling) && level._meat_on_team == player._meat_team) //meat is rolling around on the players side, don't wait for it
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
			if(!is_true(player.last_damage_from_zombie_or_player ))
			{
				level._checking_for_save = false;
				return false;
			}
			if(level._meat_on_team != player._meat_team && isDefined(level._last_person_to_throw_meat) && level._last_person_to_throw_meat == player) //make sure nobody else touched the meat while we were waiting to be saved
			{
				if(player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
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

revive_saved_player(player)
{
	player endon("disconnect");
	
	iprintlnbold("PLAYER SAVED!");
	player playsound("zmb_laugh_child");
	wait(.25);
	Playfx( level._effect["poltergeist"], player.origin );
	playsoundatposition( "zmb_bolt", player.origin );
	Earthquake( 0.5, 0.75, player.origin, 1000);					
	player thread maps\mp\zombies\_zm_laststand::auto_revive( player );
	player._saved_by_throw++;
	level._checking_for_save = false;
}

get_game_module_players(player)
{
	return get_players_on_meat_team(player._meat_team);
}
