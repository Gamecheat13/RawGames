#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	level thread achievement_moon_sidequest();
	level thread achievement_ground_control();

	level thread onPlayerConnect();
}


onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connecting", player );

		player thread achievement_one_small_hack();
		player thread achievement_one_giant_leap();
		player thread achievement_perks_in_space();
		player thread achievement_fully_armed();
	}
}


achievement_set_interim_sidequest_stat_for_all_players( stat_name )
{
//t6todo	if ( maps\_cheat::is_cheating() || flag( "has_cheated" ) )
	{
		return;
	}

	// don't do stats stuff if it's not an online game
	if ( level.systemLink )
	{
		return; 
	}
	if ( GetDvarInt( "splitscreen_playerCount" ) == GET_PLAYERS().size )
	{
		return;
	}

	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] maps\mp\zombies\_zm_stats::add_global_stat( stat_name, 1 );
	}
}


achievement_moon_sidequest()
{
	level endon( "end_game" );


	level waittill( "moon_sidequest_reveal_achieved" );

	level achievement_set_interim_sidequest_stat_for_all_players( "ZOMBIE_MOON_SIDEQUEST" );
	level giveachievement_wrapper( "DLC5_ZOM_CRYOGENIC_PARTY", true );


	level waittill( "moon_sidequest_swap_achieved" );

	level givegamerpicture_wrapper( "DLC5_SIDEQUEST_LOCAL", true );


	level waittill( "moon_sidequest_big_bang_achieved" );

	level thread maps\mp\zombies\_zm::set_sidequest_completed( "MOON" );

	if ( level.xenon )
	{
		level giveachievement_wrapper( "DLC5_ZOM_BIG_BANG_THEORY", true );
		level givegamerpicture_wrapper( "DLC5_SIDEQUEST_TOTAL", true );
	}
}


achievement_ground_control()
{
	level endon( "end_game" );

	flag_wait( "teleporter_digger_hacked_before_breached" );
	flag_wait( "hangar_digger_hacked_before_breached" );
	flag_wait( "biodome_digger_hacked_before_breached" );
	
/#
//iprintlnbold( "DLC5_ZOM_GROUND_CONTROL achieved" );
#/
	level giveachievement_wrapper( "DLC5_ZOM_GROUND_CONTROL", true );
}


achievement_one_small_hack()
{
	level endon( "end_game" );

	self waittill( "successful_hack" );

/#
//iprintlnbold( "DLC5_ZOM_ONE_SMALL_HACK achieved" );
#/
	self giveachievement_wrapper( "DLC5_ZOM_ONE_SMALL_HACK" );
}


achievement_one_giant_leap()
{
	level endon( "end_game" );

	self waittill( "one_giant_leap" );
/#
	//println( "DLC5_ZOM_ONE_GIANT_LEAP achieved" );
#/
	self giveachievement_wrapper( "DLC5_ZOM_ONE_GIANT_LEAP" );
	
	if (!is_true(level.played_extra_song_a7x))
	{		
		level.music_override = true;
		level thread maps\mp\zombies\_zm_audio::change_zombie_music( "egg_a7x" );
	
		level.played_extra_song_a7x = true;

		//LENGTH OF SONG
		wait(366);	
		level.music_override = false;
	
		if( level.music_round_override == false )
		{
		level thread maps\mp\zombies\_zm_audio::change_zombie_music( "wave_loop" );
		}	
	}
}


achievement_perks_in_space()
{
	level endon( "end_game" );

	self.perks_in_space_list = [];
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		self.perks_in_space_purchased_list[vending_triggers[i].script_noteworthy + "_purchased"] = false;
	}

	while ( true )
	{
		self waittill( "perk_bought", perk );

		self.perks_in_space_purchased_list[perk + "_purchased"] = true;

		keys = GetArrayKeys( self.perks_in_space_purchased_list );
		for ( i = 0; i < keys.size; i++ )
		{
			if ( !self.perks_in_space_purchased_list[keys[i]] )
			{
				break;
			}
		}

		if ( i == self.perks_in_space_purchased_list.size )
		{
/#
//iprintlnbold( "DLC5_ZOM_PERKS_IN_SPACE achieved" );
#/
			self giveachievement_wrapper( "DLC5_ZOM_PERKS_IN_SPACE" );
			return;
		}
	}
}


achievement_fully_armed()
{
	level endon( "end_game" );

	while ( true )
	{
		self waittill( "pap_taken" );

		if ( !self HasPerk( "specialty_additionalprimaryweapon" ) )
		{
			continue;
		}

		primaries = self GetWeaponsListPrimaries();
		if ( !isDefined( primaries ) || primaries.size != 3 )
		{
			continue;
		}

		for ( i = 0; i < primaries.size; i++ )
		{
			if ( !maps\mp\zombies\_zm_weapons::is_weapon_upgraded( primaries[i] ) )
			{
				break;
			}
		}

		if ( i == primaries.size )
		{
/#
//iprintlnbold( "DLC5_ZOM_FULLY_ARMED achieved" );
#/
			self giveachievement_wrapper( "DLC5_ZOM_FULLY_ARMED" );
			return;
		}
	}
}


