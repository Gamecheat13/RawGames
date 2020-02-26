#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init()
{
	// powerup Vars
	set_zombie_var( "zombie_insta_kill", 				0 );
	set_zombie_var( "zombie_point_scalar", 				1 );
	set_zombie_var( "zombie_drop_item", 				0 );
	set_zombie_var( "zombie_timer_offset", 				350 );	// hud offsets
	set_zombie_var( "zombie_timer_offset_interval", 	30 );
	set_zombie_var( "zombie_powerup_insta_kill_on", 	false );
	set_zombie_var( "zombie_powerup_point_doubler_on", 	false );
	set_zombie_var( "zombie_powerup_point_doubler_time", 30 );	// length of point doubler
	set_zombie_var( "zombie_powerup_insta_kill_time", 	30 );	// length of insta kill
	set_zombie_var( "zombie_powerup_drop_increment", 	2000 );	// lower this to make drop happen more often
	set_zombie_var( "zombie_powerup_drop_max_per_round", 4 );	// lower this to make drop happen more often

	// powerups
	level._effect["powerup_on"] 				= loadfx( "misc/fx_zombie_powerup_on" );
	level._effect["powerup_grabbed"] 			= loadfx( "misc/fx_zombie_powerup_grab" );
	level._effect["powerup_grabbed_wave"] 		= loadfx( "misc/fx_zombie_powerup_wave" );
	
	init_powerups();
	
	thread watch_for_drop();
}

init_powerups()
{
	// Random Drops
	add_zombie_powerup( "nuke", 		"zombie_bomb",		&"ZOMBIE_POWERUP_NUKE", 			"misc/fx_zombie_mini_nuke" );
//	add_zombie_powerup( "nuke", 		"zombie_bomb",		&"ZOMBIE_POWERUP_NUKE", 			"misc/fx_zombie_mini_nuke_hotness" );
	add_zombie_powerup( "insta_kill", 	"zombie_skull",		&"ZOMBIE_POWERUP_INSTA_KILL" );
	add_zombie_powerup( "double_points","zombie_x2_icon",	&"ZOMBIE_POWERUP_DOUBLE_POINTS" );
	add_zombie_powerup( "full_ammo",  	"zombie_ammocan",	&"ZOMBIE_POWERUP_MAX_AMMO");

	// Randomize the order
	randomize_powerups();

	level.zombie_powerup_index = 0;
	randomize_powerups();
}  

randomize_powerups()
{
	level.zombie_powerup_array = array_randomize( level.zombie_powerup_array );
}

get_next_powerup()
{
	if( level.zombie_powerup_index >= level.zombie_powerup_array.size )
	{
		level.zombie_powerup_index = 0;
		randomize_powerups();
	}

	powerup = level.zombie_powerup_array[level.zombie_powerup_index];
	level.zombie_powerup_index++;

	return powerup;
}

watch_for_drop()
{
	players = get_players();
	score_to_drop = ( players.size * level.zombie_vars["zombie_score_start"] ) + level.zombie_vars["zombie_powerup_drop_increment"];
	
	while (1)
	{
		players = get_players();
		
		curr_total_score = 0;

		for (i = 0; i < players.size; i++)
		{
			curr_total_score += players[i].score_total;
		}
		
		if (curr_total_score > score_to_drop )
		{
			level.zombie_vars["zombie_powerup_drop_increment"] *= 1.14;
			score_to_drop = curr_total_score + level.zombie_vars["zombie_powerup_drop_increment"];
			level.zombie_vars["zombie_drop_item"] = 1;
		}
		
		wait( 0.5 );
	}
}

add_zombie_powerup( powerup_name, model_name, hint, fx )
{
	if( IsDefined( level.zombie_include_powerups ) && !IsDefined( level.zombie_include_powerups[powerup_name] ) )
	{
		return;
	}

	PrecacheModel( model_name );
	PrecacheString( hint );

	struct = SpawnStruct();
	
	if( !IsDefined( level.zombie_powerups ) )
	{
		level.zombie_powerups = [];
	}

	if( !IsDefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}

	struct.powerup_name = powerup_name;
	struct.model_name = model_name;
	struct.weapon_classname = "script_model";
	struct.hint = hint;

	if( IsDefined( fx ) )
	{
		struct.fx = LoadFx( fx );
	}

	level.zombie_powerups[powerup_name] = struct;
	level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
}

include_zombie_powerup( powerup_name )
{
	if( !IsDefined( level.zombie_include_powerups ) )
	{
		level.zombie_include_powerups = [];
	}

	level.zombie_include_powerups[powerup_name] = true;
}

powerup_round_start()
{
	level.powerup_drop_count = 0;
}

powerup_drop(drop_point)
{
	rand_drop = randomint(100);

	if( level.powerup_drop_count == level.zombie_vars["zombie_powerup_drop_max_per_round"] )
	{
		println( "^3POWERUP DROP EXCEEDED THE MAX PER ROUND!" );
		return;
	}
	
	// some guys randomly drop, but most of the time they check for the drop flag
	if (rand_drop > 2)
	{
		if (!level.zombie_vars["zombie_drop_item"])
		{
			return;
		}

		debug = "score";
	}
	else
	{
		debug = "random";
	}	

	// never drop unless in the playable area
	playable_area = getentarray("playable_area","targetname");
	
	powerup = spawn ("script_model", drop_point + (0,0,40));
	
	for (i = 0; i < playable_area.size; i++)
	{
		if (!powerup istouching(playable_area[i]))
		{
			powerup delete();
			return;
		}
	}	

	powerup powerup_setup();
	level.powerup_drop_count++;

	print_powerup_drop( powerup.powerup_name, debug );
	
	powerup thread powerup_timeout();
	powerup thread powerup_wobble();
	powerup thread powerup_grab();
	
	level.zombie_vars["zombie_drop_item"] = 0;


	//powerup = powerup_setup(); 
	
	
	// if is !is touching trig
	// return
	
	// spawn the model, do a ground trace and place above
	// start the movement logic, spawn the fx
	// start the time out logic
	// start the grab logic
}

powerup_setup()
{
	powerup = get_next_powerup();

	struct = level.zombie_powerups[powerup];
	self SetModel( struct.model_name );

	//TUEY Spawn Powerup
	playsoundatposition("spawn_powerup", self.origin);

	self.powerup_name 	= struct.powerup_name;
	self.hint 			= struct.hint;

	if( IsDefined( struct.fx ) )
	{
		self.fx = struct.fx;
	}

	self PlayLoopSound("spawn_powerup_loop");
}

powerup_grab()
{
	self endon ("powerup_timedout");
	self endon ("powerup_grabbed");
	
	while (isdefined(self))
	{
		players = get_players();
		
		for (i = 0; i < players.size; i++)
		{
			if (distance (players[i].origin, self.origin) < 64)
			{
				playfx (level._effect["powerup_grabbed"], self.origin);
				playfx (level._effect["powerup_grabbed_wave"], self.origin);	

				if( IsDefined( level.zombie_powerup_grab_func ) )
				{
					level thread [[level.zombie_powerup_grab_func]]();
				}
				else
				{
					switch (self.powerup_name)
					{
						case "nuke":
							level thread nuke_powerup( self );
							break;
						case "full_ammo":
							level thread full_ammo_powerup( self );
							break;
						case "double_points":
							level thread double_points_powerup( self );
							break;
						case "insta_kill":
							level thread insta_kill_powerup( self );
							break;							
						default:
							println ("Unrecognized poweup.");
						break;
					}
				}

				wait( 0.1 );

				playsoundatposition("powerup_grabbed", self.origin);
				self stoploopsound();
				
				self delete();
				self notify ("powerup_grabbed");
			}
		}
		wait 0.1;
	}	
}

powerup_wobble()
{
	self endon ("powerup_grabbed");
	self endon ("powerup_timedout");
	
	if (isdefined(self))
	{
		playfxontag (level._effect["powerup_on"], self, "tag_origin");
	}
	
	while (isdefined(self))
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
		yaw = self.angles[1] + yaw;
		self rotateto ((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		wait randomfloat (waittime - 0.1);
	}
}

powerup_timeout()
{
	self endon ("powerup_grabbed");
	
	wait 15;
	
	for (i = 0; i < 40; i++)
	{
		// hide and show
		if (i % 2)
		{
			self hide();
		}
		else
		{
			self show();
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

	self notify ("powerup_timedout");
	self delete();
}

// kill them all!
nuke_powerup( drop_item )
{
	zombies = getaiarray("axis");

	PlayFx( drop_item.fx, drop_item.origin );
//	players = get_players();
//	array_thread (players, ::nuke_flash);
	level thread nuke_flash();

	zombies = get_array_of_closest( drop_item.origin, zombies );
	for (i = 0; i < zombies.size; i++)
	{
		wait (randomfloatrange(0.1, 0.7));
		if( !IsDefined( zombies[i] ) )
		{
			continue;
		}

		if( i < 5 )
		{
			zombies[i] thread animscripts\death::flame_death_fx();
		}

		zombies[i] maps\_zombiemode_spawner::zombie_head_gib();

		zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		playsoundatposition("nuked", zombies[i].origin);
	}
}

nuke_flash()
{
	playsoundatposition("nuke_flash", (0,0,0));

	fadetowhite = newhudelem();
	
	fadetowhite.x = 0; 
	fadetowhite.y = 0; 
	fadetowhite.alpha = 0; 
		
	fadetowhite.horzAlign = "fullscreen"; 
	fadetowhite.vertAlign = "fullscreen"; 
	fadetowhite.foreground = true; 
	fadetowhite SetShader( "white", 640, 480 ); 

	// Fade into white
	fadetowhite FadeOverTime( 0.2 ); 
	fadetowhite.alpha = 0.8; 
		
	wait 0.5;
	fadetowhite FadeOverTime( 1.0 ); 
	fadetowhite.alpha = 0; 
	
	wait 1.1;
	fadetowhite destroy();
}

// double the points
double_points_powerup( drop_item )
{
	level notify ("powerup points scaled");
	level endon ("powerup points scaled");
	
//	players = get_players();	
//	array_thread(level,::point_doubler_on_hud, drop_item);
	level thread point_doubler_on_hud( drop_item );
		
	level.zombie_vars["zombie_point_scalar"] *= 2;
	
	wait 30;
	
	level.zombie_vars["zombie_point_scalar"] = 1;
}

full_ammo_powerup( drop_item )
{
	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		primaryWeapons = players[i] GetWeaponsListPrimaries(); 
	
		for( x = 0; x < primaryWeapons.size; x++ )
		{
			players[i] GiveMaxAmmo( primaryWeapons[x] );
		}
	}
//	array_thread (players, ::full_ammo_on_hud, drop_item);
	level thread full_ammo_on_hud( drop_item );
}

insta_kill_powerup( drop_item )
{
	level notify( "powerup instakill" );
	level endon( "powerup instakill" );
	
//	players = get_players();	
//	array_thread (players, ::insta_kill_on_hud, drop_item);
	level thread insta_kill_on_hud( drop_item );
	
	level.zombie_vars["zombie_insta_kill"] = 1;
	wait( 30 );
	level.zombie_vars["zombie_insta_kill"] = 0;
}

check_for_instakill( player )
{
	if( IsDefined( player ) && IsAlive( player ) && level.zombie_vars["zombie_insta_kill"])
	{
		self maps\_zombiemode_spawner::zombie_head_gib();
		self DoDamage( self.health + 666, self.origin, player );
	}
}

insta_kill_on_hud( drop_item )
{
	self endon ("disconnect");
		
	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_insta_kill_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
		return;
	}

	level.zombie_vars["zombie_powerup_insta_kill_on"] = true;
		
	// set up the hudelem
	hudelem = maps\_hud_util::createFontString( "objective", 2 );
	hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] + level.zombie_vars["zombie_timer_offset_interval"]);
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	hudelem.label = drop_item.hint;
	
	// set time remaining for insta kill
	hudelem thread time_remaning_on_insta_kill_powerup();		
	
	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

time_remaning_on_insta_kill_powerup()
{
	self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );
	
	temp_enta = spawn("script_origin", (0,0,0));
	temp_enta playloopsound("insta_kill_loop");	

/*
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		players[i] playloopsound ("insta_kill_loop");
	}
*/
	

	// time it down!
	while ( level.zombie_vars["zombie_powerup_insta_kill_time"] >= 0)
	{
		wait 1;
		level.zombie_vars["zombie_powerup_insta_kill_time"] = level.zombie_vars["zombie_powerup_insta_kill_time"] - 1;
		self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );	
	}

	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound (2);
		players[i] playsound("insta_kill");
	}
	
	temp_enta stoploopsound(2);
	// turn off the timer
	level.zombie_vars["zombie_powerup_insta_kill_on"] = false;

	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	self destroy();
	temp_enta delete();
}

point_doubler_on_hud( drop_item )
{
	self endon ("disconnect");
	
	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_point_doubler_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
		return;
	}

	level.zombie_vars["zombie_powerup_point_doubler_on"] = true;

	// set up the hudelem
	hudelem = maps\_hud_util::createFontString( "objective", 2 );
	hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] );
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime( 0.5 );
	hudelem.alpha = 1;
	hudelem.label = drop_item.hint;
	
	// set time remaining for point doubler
	hudelem thread time_remaining_on_point_doubler_powerup();		
	
	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

time_remaining_on_point_doubler_powerup()
{
	self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );
	
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent playloopsound ("double_point_loop");

	// time it down!
	while ( level.zombie_vars["zombie_powerup_point_doubler_time"] >= 0)
	{
		wait 1;
		level.zombie_vars["zombie_powerup_point_doubler_time"] = level.zombie_vars["zombie_powerup_point_doubler_time"] - 1;
		self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );	
	}

	// turn off the timer
	level.zombie_vars["zombie_powerup_point_doubler_on"] = false;
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound("double_point_loop", 2);
		players[i] playsound("points_loop_off");
	}
	temp_ent stoploopsound(2);


	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	self destroy();
	temp_ent delete();
}

full_ammo_on_hud( drop_item )
{
	self endon ("disconnect");

	// set up the hudelem
	hudelem = maps\_hud_util::createFontString( "objective", 2 );
	hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	hudelem.label = drop_item.hint;
	
	// set time remaining for insta kill
	hudelem thread full_ammo_move_hud();		
	
	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

full_ammo_move_hud()
{

	players = get_players();
	
	for (i = 0; i < players.size; i++)
	{
		players[i] playsound ("full_ammo");
	}

	wait 0.5;
	move_fade_time = 1.5;
	
	self FadeOverTime( move_fade_time ); 
	self MoveOverTime( move_fade_time );
	self.y = 270;
	self.alpha = 0;
	
	wait move_fade_time;
	
	self destroy();
}

//
// DEBUG
//

print_powerup_drop( powerup, type )
{
/#
	if( !IsDefined( level.powerup_drop_time ) )
	{
		level.powerup_drop_time = 0;
		level.powerup_random_count = 0;
		level.powerup_score_count = 0;
	}

	time = ( GetTime() - level.powerup_drop_time ) * 0.001;
	level.powerup_drop_time = GetTime();

	if( type == "random" )
	{
		level.powerup_random_count++;
	}
	else
	{
		level.powerup_score_count++;
	}

	println( "========== POWER UP DROPPED ==========" );
	println( "DROPPED: " + powerup );
	println( "HOW IT DROPPED: " + type );
	println( "--------------------" );
	println( "Drop Time: " + time );
	println( "Random Powerup Count: " + level.powerup_random_count );
	println( "Random Powerup Count: " + level.powerup_score_count );
	println( "======================================" );
#/
}