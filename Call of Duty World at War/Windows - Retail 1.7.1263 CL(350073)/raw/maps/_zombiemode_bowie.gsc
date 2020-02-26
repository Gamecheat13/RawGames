#include maps\_utility;
#include common_scripts\utility;
#include maps\_zombiemode_utility;

bowie_init()
{
	PrecacheItem( "zombie_bowie_flourish" );
	bowie_triggers = GetEntArray( "bowie_upgrade", "targetname" );
	for( i = 0; i < bowie_triggers.size; i++ )
	{
		knife_model = GetEnt( bowie_triggers[i].target, "targetname" );
		knife_model hide();
		bowie_triggers[i] thread bowie_think();
		bowie_triggers[i] SetHintString( &"ZOMBIE_WEAPON_BOWIE_BUY" ); 
		bowie_triggers[i] setCursorHint( "HINT_NOICON" ); 
		bowie_triggers[i] UseTriggerRequireLookAt();
	}
}

bowie_think()
{
	if( isDefined( level.bowie_cost ) )
	{
		cost = level.bowie_cost;
	}
	else
	{
		cost = 3000;
	}
	
	self.first_time_triggered = false; 
	
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo

		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}

		if(isdefined(player.is_drinking))
		{
			wait(0.1);
			continue;
		}
		
		if( player isSwitchingWeapons() )
		{
			wait(0.1);
			continue;
		}

		if( player GetCurrentWeapon() == "mine_bouncing_betty" )
		{
			wait(0.1);
			continue;
		}
		
		if (player maps\_laststand::player_is_in_laststand() )
		{
			wait(0.1);
			continue;
		}

		player_has_bowie = player HasPerk( "specialty_altmelee" ); 

		if( !player_has_bowie )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
					//					model show(); 
					model thread bowie_show( player ); 
					self.first_time_triggered = true; 
				}

				player maps\_zombiemode_score::minus_to_player_score( cost ); 

				bbPrint( "zombie_uses: playername %s playerscore %d round %d cost %d name %s x %f y %f z %f type weapon",
						player.playername, player.score, level.round_number, cost, "bowie_knife", self.origin );

				player give_bowie(); 
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
				player thread maps\nazi_zombie_sumpf_blockers::play_no_money_purchase_dialog();
			}
		}
	}
}

give_bowie()
{
	self SetPerk( "specialty_altmelee" );
	
	self.has_altmelee = true;	
	index = maps\_zombiemode_weapons::get_player_index(self);
	plr = "plr_" + index + "_";
	
	gun = self do_bowie_flourish_begin();
	self thread play_bowie_pickup_dialog(plr);
	self.is_drinking = 1;
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );

	// restore player controls and movement
	self do_bowie_flourish_end( gun );
	self.is_drinking = undefined;
}

do_bowie_flourish_begin()
{
	self DisableOffhandWeapons();
	self DisableWeaponCycling();

	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self AllowMelee( false );
	
	wait( 0.05 );
	
	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	gun = self GetCurrentWeapon();
	weapon = "zombie_bowie_flourish";

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

do_bowie_flourish_end( gun )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "syrette" );

	self EnableOffhandWeapons();
	self EnableWeaponCycling();

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "zombie_bowie_flourish";

	// TODO: race condition?
	if ( self maps\_laststand::player_is_in_laststand() )
	{
		self TakeWeapon(weapon);
		return;
	}

	self TakeWeapon(weapon);

	if ( gun != "none" && gun != "mine_bouncing_betty" )
	{
		self SwitchToWeapon( gun );
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}
	
	self waittill( "weapon_change_complete" );
}

bowie_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1]; 

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin +( AnglesToForward( ( 0, yaw, 0 ) ) * 8 ); 

	wait( 0.05 ); 
	self Show(); 

	play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}

play_bowie_pickup_dialog(player_index)
{
	waittime = 0.05;
	if(!IsDefined (self.vox_bowie))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_bowie");
		self.vox_bowie = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_bowie[self.vox_bowie.size] = "vox_bowie_" + i;
		}
		self.vox_bowie_available = self.vox_bowie;
	}
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	sound_to_play = random(self.vox_bowie_available);
	self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
	self.vox_bowie_available = array_remove(self.vox_bowie_available,sound_to_play);
	
	if (self.vox_bowie_available.size < 1 )
	{
		self.vox_bowie_available = self.vox_bowie;
	}
}
