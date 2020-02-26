#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include animscripts\utility;

#define WEAPON_IDLE_TIME	3000
#define TURRET_SPAN_LEFT	50
#define TURRET_SPAN_RIGHT	50
#define TURRET_SPAN_UP		60
#define TURRET_SPAN_DOWN	45


#using_animtree("player");

init()
{
	flag_wait( "all_players_connected" );

	if ( is_true( level.horse_playerInit ) )
	{
		return;
	}

	level.horse_playerInit = true;

	if ( !isdefined( level.horse_weaponModel ) )
	{
		level.horse_weaponModel = "t6_wpn_pistol_m1911_view";
	}

	player = get_players()[0];
	player maps\_horse::spawn_player_body();

}

// self == body
player_rearback( rearback_anim )
{
	self endon( "death" );
	self endon( "stop_player_ride" );

	self.rearback = true;

	if ( isdefined( self.currAnimation ) )
	{
		self ClearAnim( self.currAnimation, 0.2 );
	}
	
	self SetAnimLimited( rearback_anim, 1, 0.2, 1 );
	len = GetAnimLength( rearback_anim );
	wait( len );
	self ClearAnim( rearback_anim, 0.2 );
	self.currAnimation = undefined;

	self.rearback = false;
}

// self == player
update_player_ride( horse )
{
	self endon( "stop_player_ride" );
	self.weapon_out = false;
	self.body.currAnimation = undefined;

	self thread update_player_weapon();
	self.body StopAnimScripted();

	//self thread update_player_aiming( horse );

	while ( 1 )
	{
		if ( is_true( self.body.rearback ) )
		{
		}
		else if ( isdefined( self.body.nextAnimation ) )
		{
			if ( isdefined( self.body.currAnimation ) )
			{
				if ( self.body.currAnimation == self.body.nextAnimation )
				{
					wait_network_frame();
					continue;
				}
				else
				{
					self.body ClearAnim( self.body.currAnimation, 0.2 );
					self.body SetAnimLimited( self.body.nextAnimation, 1, 0.2, 1 );
					self.body.currAnimation = self.body.nextAnimation;
				}
			}
			else 
			{
				self.body.currAnimation = self.body.nextAnimation;
				self.body SetAnimLimited( self.body.nextAnimation, 1, 0.2, 1 );
			}
		}
		else if ( isdefined( horse.player_nextAnimation ) )
		{
			self.body.currAnimation = horse.player_nextAnimation;
			self.body SetAnimLimited( horse.player_nextAnimation, 1, 0.2, 1 );
			horse.player_nextAnimation = undefined;
		}

		wait( 0.05 );
	}
}

update_player_aiming( horse )
{
	horse endon( "exit_vehicle" );
	horse endon( "death" );

	test = %int_horse_player_gun_fire;
	test2 = %horse_fire;

	self.horse_fire = %int_horse_player_gun_ads_fire;

	self.body Attach( level.horse_weaponModel, "tag_weapon" );

	self.body SetAnim( %int_horse_player_gun_aim_2, 1.0, 0.0, 1.0 );
	self.body SetAnim( %int_horse_player_gun_aim_4, 1.0, 0.0, 1.0 );
	self.body SetAnim( %int_horse_player_gun_aim_6, 1.0, 0.0, 1.0 );
	self.body SetAnim( %int_horse_player_gun_aim_8, 1.0, 0.0, 1.0 );

	self.body SetAnim( %int_horse_player_gun_aim_5, 1.0, 0.2, 1.0 );

	self SetAnim( %int_horse_player_gun_aim_ads_2, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_ads_4, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_ads_6, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_ads_8, 1.0, 0.0, 1.0 );

	self SetAnim( %int_horse_player_gun_aim_ads_5, 1.0, 0.2, 1.0 );
	//yawWeight = 0.5;
	//pitchWeight = 0.5;
	yawWeight = 0.01;
	pitchWeight = 0.01;
	
	while ( 1 )
	{
		player_angles = self GetPlayerAngles();
		horse_angles = horse.angles;

		yawOffset = AngleClamp180( horse_angles[1] - player_angles[1] );
		pitchOffset = AngleClamp180( horse_angles[0] - player_angles[0] );

		if ( yawOffset > 0 )
		{
			yawOffset = yawOffset / TURRET_SPAN_RIGHT;
		}
		else
		{
			yawOffset = yawOffset / TURRET_SPAN_LEFT;
		}

		if ( pitchOffset > 0 )
		{
			pitchOffset = pitchOffset / TURRET_SPAN_UP;
		}
		else
		{
			pitchOffset = pitchOffset / TURRET_SPAN_DOWN;
		}

		if ( abs( yawOffset ) > 1 )
		{
			yawOffset = sign( yawOffset );
		}

		if ( abs( pitchOffset ) > 1 )
		{
			pitchOffset = sign( pitchOffset );
		}

		if ( self ActionSlotOneButtonPressed() )
		{
			pitchWeight += 0.1;
		}
		if ( self ActionSlotTwoButtonPressed() )
		{
			pitchWeight -= 0.1;
		}
		if ( self ActionSlotThreeButtonPressed() )
		{
			yawWeight -= 0.1;
		}
		if ( self ActionSlotFourButtonPressed() )
		{
			yawWeight += 0.1;
		}

		if ( abs( yawWeight ) > 1 )
		{
			yawWeight = sign( yawWeight );
		}

		if ( abs( pitchWeight ) > 1 )
		{
			pitchWeight = sign( pitchWeight );
		}

		if ( yawOffset > 0 )
		{
			self.body SetAnimLimited( %horse_aim_6, yawOffset, 0.0, 1.0 );
			self.body SetAnimLimited( %horse_aim_4, 0, 0.0, 1.0 );
		}
		else
		{
			weight = abs( yawOffset );
			self.body SetAnimLimited( %horse_aim_4, weight, 0.0, 1.0 );
			self.body SetAnimLimited( %horse_aim_6, 0, 0.0, 1.0 );
		}

		if ( pitchOffset > 0 )
		{
			self.body SetAnimLimited( %horse_aim_8, pitchOffset, 0.0, 1.0 );
			self.body SetAnimLimited( %horse_aim_2, 0, 0.0, 1.0 );
		}
		else
		{
			weight = abs( pitchOffset );
			self.body SetAnimLimited( %horse_aim_2, weight, 0.0, 1.0 );
			self.body SetAnimLimited( %horse_aim_8, 0, 0.0, 1.0 );
		}

		wait( 0.05 );
	}
}

update_player_weapon()
{
	while ( 1 )
	{
		if ( self.weapon_out )
		{
			if ( GetTime() > ( self.weapon_out_time + WEAPON_IDLE_TIME ) )
			{
				self player_weapon_putaway();
			}
		}
		wait_network_frame();
	}
}

player_weapon_pullout()
{
	//self.body SetAnim( %horse_gun_pullout, 1, 0.0, 1 );
	//pullout_anim = %int_horse_player_gun_pullout;
	//self.body SetAnim( pullout_anim, 1, 0.2 );
	//anim_time = GetAnimLength( pullout_anim );
	//wait( anim_time );
	self.weapon_out = true;
	self.weapon_out_time = GetTime();
}

player_weapon_putaway()
{
	//self.body SetAnimLimited( %horse_gun_putaway, 1, 0.2, 1 );
	//wait( 1 );
	self.weapon_out = false;
}