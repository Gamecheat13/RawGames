#include common_scripts\utility;
#include maps\_utility;

// TODO List:
// - Create notes in here, on how to add new versions for different tanks, as well as generic notes.
// - Get 3rd person player anims, and implement them.
// - Investigate whether or not we can lerp the player onto a moving tank. We will need to be able to use the tank while it's in motion.
// - Add grenade explosion timer during throwback.
// - Recenter turret when mounted.
// - Viewmodel grenade not lining up. Should be using,

build_tank_mantle( model, type )
{
	switch( model )
	{
		// Alex Liu 6-17-08 Added special half destroyed king tiger
		case "vehicle_ger_tracked_king_tiger_d_inter":
		case "vehicle_ger_tracked_king_tiger":
			level.vehicle_mantlefx[model]["implode"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_implode" );
			level.vehicle_mantlefx[model]["cookoff"] 	= LoadFx( "vehicle/vexplosion/fx_vexplode_tiger_turret_cookoff" );
			level.vehicle_mantlefx[model]["smoke"] 		= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_billow" );
			level.vehicle_mantlefx[model]["smolder"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_smolder" );
			break;
		case "vehicle_ger_tracked_king_tiger_winter":
			level.vehicle_mantlefx[model]["implode"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_implode" );
			level.vehicle_mantlefx[model]["cookoff"] 	= LoadFx( "vehicle/vexplosion/fx_vexplode_tiger_turret_cookoff" );
			level.vehicle_mantlefx[model]["smoke"] 		= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_billow" );
			level.vehicle_mantlefx[model]["smolder"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_smolder" );
			break;
		// dpg 5/28/08 added for special half-destroyed shinhoto model
		case "vehicle_jap_tracked_type97shinhoto":
		case "vehicle_jap_tracked_type97_d_intermediate":
			level.vehicle_mantlefx[model]["implode"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_t97_implode" );
			level.vehicle_mantlefx[model]["cookoff"] 	= LoadFx( "vehicle/vexplosion/fx_vexplode_turret_cookoff_t97" );
			level.vehicle_mantlefx[model]["smoke"] 		= LoadFx( "vehicle/vfire/fx_vsmoke_t97_billow" );
			level.vehicle_mantlefx[model]["smolder"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_t97_smolder" );
			break;
		default:
			ASSERTMSG( "build_tank_mantle(): The tank model " + model + " is not supported" );
	}
}

init_models( hands, grenade )
{
	PrecacheModel( hands );
	level.scr_model["tank_mantle_hands"] = hands;
	
	level.tankmantle_grenade = grenade;
	PrecacheModel( GetWeaponModel( level.tankmantle_grenade, 0, true ) );
}

init()
{
	self.mantleenabled = true;
	self.tankmantle_tossbacks_remaining = 1;
	self.being_mantled = 0;
	self.cook_off_chance = 50; // Alex Liu 6-21-08: Allows adjustible cookoff chances
	
	self thread tank_mantle_think();
}

tank_mantle_think()
{
	self endon( "death" );

	while( 1 )
	{
		self waittill( "trigger", other, side );

		if( side == "invalid" )
		{
			continue;
		}

		if( IsDefined( side ) && IsPlayer( other ) )
		{
			self.mantleenabled = false;
			other tank_mantle( self, side );

			// The player succesffully mounted the tank.
			if( IsDefined( self.mantled ) && self.mantled )
			{
				return;
			}
		}

		self.mantleenabled = true;
	}
}

// Self is the player
tank_mantle( tank, side )
{
	AssertEx( IsDefined( level.tankmantle_grenade ), "_tankmantle::tank_mantle() -> level.tankmantle_grenade is not set, set this to the player's default grenade weapon for the level." );

	self.ignoreme = true;
	self EnableInvulnerability();

	self notify ("tank_mantle_begin");

	// Alex Liu 6-17-08 A notify for the tank as well
	tank notify ("tank_mantle_begin");

	tank.being_mantled = 1;
	
	tank thread recenter_turret();

	self.ignoreme = true;
	self DisableWeapons();
	
	tank_mantle_stance_wrapper("mantle begin");
	self ShellShock( "tank_mantle", 8 ); 

	// Get the animations needed to mantle.
	mantle_anim = get_mantle_anim( tank, side );
//	tank_anim = get_tank_anim( type );

	org = GetStartOrigin( tank.origin, tank.angles, mantle_anim );
	angles = GetStartAngles( tank.origin, tank.angles, mantle_anim );

	hands = spawn_anim_model( "tank_mantle_hands" );
	hands Hide();
	hands.origin = org;
	hands.angles = angles;
	hands SetVisibleToPlayer( self );

	//self lerp_player_view_to_tag( hands, "tag_player", 0.5, 1, 20, 20, 10, 10 );
	////////////////////////
		// LinkTo Settings: 
		tag = "tag_player"; 
		lerp_time = 0.5; 
		fraction = 1; 
		right_arc = 20; 
		left_arc = 20; 
		top_arc = 10; 
		bottom_arc = 10; 
		ground_trace = false;
		
//		if( ( tank getspeedMPH() ) > 0 ) 
//		{ 
//		   hands LinkTo( tank ); 
//		   self lerp_player_view_to_moving_position_oldstyle( hands, "tag_player", lerp_time, fraction, right_arc, left_arc, top_arc, bottom_arc ); 
//		} 
//		else 
		{ 
		   hands LinkTo( tank ); 
		   self lerp_player_view_to_tag( hands, "tag_player", lerp_time, fraction, right_arc, left_arc, top_arc, bottom_arc ); 
		}
	////////////
	
	hands Show();

	hands AnimScripted( "mantle_anim", tank.origin, tank.angles, mantle_anim );
	tank open_hatch( side );
	hands do_notetracks( tank, "mantle_anim", side );

	self Unlink();
	hands Delete();

	self.ignoreme = false;
	self EnableWeapons();

	tank_mantle_stance_wrapper("mantle end");
	
	//PlaySoundAtPosition( "implosion", tank.origin );
	// dpg 3/20/08, added tossback check
	if( RandomInt( 100 ) > 20 || !tank.tankmantle_tossbacks_remaining ) // 80% chance or if a grenade has already been tossed back
	{
		tank thread tank_mantle_death( self );			
	}
	else
	{
		tank thread throwback_grenade( side );
	}

	self DisableInvulnerability();
	tank.turretlocked = false;
	tank.being_mantled = 0;
}

recenter_turret()
{
	self endon( "death_finished" );

	turret_origin = self GetTagOrigin( "turret_recoil" );
	z_offset = turret_origin[2] - self.origin[2];

	temp = Spawn( "script_origin", self.origin );
	temp thread temp_target_think( self );	

	forward = AnglesToForward( self.angles + ( 0, 0, 0 ) );
	origin = self.origin + ( 0, 0, z_offset ) + vectorscale( forward, 500 );

	temp.origin = origin;
	temp LinkTo( self );

 	self SetTurretTargetEnt( temp );
	self.turretlocked = true;
	self.turretrotscale = 3;

	self waittill( "turret_on_target" );

	temp Delete();
}

temp_target_think( tank )
{
	self endon( "death" );
	tank waittill( "death_finished" );
	self Delete();
}

tank_mantle_death( attacker )
{
	self.mantled = true;

	tank_model = self.model;

	wait( 2 );

	// Implosion FX
	PlayFX( level.vehicle_mantlefx[tank_model]["implode"], self.origin, AnglesToForward( self.angles ) );
	self PlaySound( "implosion" );
	RadiusDamage( self.origin, 1, self.health + 10, self.health );

	if( !isdefined( self.cook_off_chance ) )
	{
		self.cook_off_chance = 50;
	}
	
	// CODER MOD: TOMMY K - 07/08/08
	if( IsPlayer( attacker ) )
	{
		// CODER MOD: TOMMY K - 07/30/08
		arcademode_assignpoints( "arcademode_score_tankmantle", attacker );
	}
	
	if( RandomInt( 100 ) > self.cook_off_chance ) 
	{
		// Smoke FX
		PlayFX( level.vehicle_mantlefx[tank_model]["smoke"], self.origin, AnglesToForward( self.angles ) );	
	
		wait( 20 );
	
		PlayFX( level.vehicle_mantlefx[tank_model]["smolder"], self.origin, AnglesToForward( self.angles ) );
	}
	else
	{
		wait( 3 + RandomFloat( 3 ) );

		PlayFX( level.vehicle_mantlefx[tank_model]["cookoff"], self.origin, AnglesToForward( self.angles ) );
	}
}

throwback_grenade( side )
{
	self endon( "death_finished" );

	self.tankmantle_tossbacks_remaining--;	

	wait( 1.5 + RandomFloat( 0.5 ) );

	start_pos = self GetTagOrigin( "hatch_open" ) + ( 0, 0, 6 );

	if( side == "left" )
	{
		forward = AnglesToRight( self.angles + ( 0, 180, 0 ) );
	}
	else if( side == "right" )
	{
		forward = AnglesToRight( self.angles );
	}
	else // back
	{
		forward = AnglesToForward( self.angles + ( 0, 180, 0 ) );
	}

	target_pos = self.origin + vectorscale( forward, 120 );

	///////// Math
	gravity = GetDvarInt( "g_gravity" );
	gravity = gravity * -1;

	dist = Distance( start_pos, target_pos );
	time = 1;

	delta = target_pos - start_pos;
	drop = 0.5 * gravity * ( time * time );
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time );
	/////////

	self open_hatch( "openclose" );

	self MagicGrenadeType( level.tankmantle_grenade, start_pos, velocity, 3 );
}

do_notetracks( tank, msg, side )
{
	self endon( "death_finished" );
	self endon( "death" );

	grenade_model = GetWeaponModel( level.tankmantle_grenade, 0, true );
	AssertEx( grenade_model != "", "Could not find the Model for Weapon: " + level.tankmantle_grenade );

	while( 1 )
	{
		self waittill( msg, notetrack );
		
		if( notetrack == "end" )
		{
			return;
		}

		switch( notetrack )
		{
			case "pull":
				break;
				
			case "tinktink":
				tank PlaySound( "gren_drop_bounce" );
				tank thread scream_sounds();
				break;

			case "open":
				tank PlaySound( "hatch_open" );
				break;

			case "close":
				tank PlaySound( "hatch_close" );
				break;

			case "attach":
				self Attach( grenade_model, "tag_weapon" );
				break;

			case "detach":
				self Detach( grenade_model, "tag_weapon" );
				break;
		}
	}
}

scream_sounds()
{
	self endon( "death" );

	nums = [];
	nums[0] = 1;
	nums[1] = 2;

	nums = array_randomize( nums );

	self PlaySound( "scream_" + nums[0] );
	wait( 1.5 + RandomFloat( 1 ) );
	self PlaySound( "scream_" + nums[1] );
}

#using_animtree( "player" );
get_mantle_anim( tank, side )
{
	level.scr_animtree["tank_mantle_hands"] = #animtree;

	mantle_anims = [];
	switch( tank.model )
	{
		case "vehicle_ger_tracked_king_tiger":
		// Alex Liu 6-17-08 Added special half destroyed tiger
		case "vehicle_ger_tracked_king_tiger_d_inter":
		case "vehicle_ger_tracked_king_tiger_winter":
			mantle_anims["left"] 	= %int_mantle_king_tiger_left;
			mantle_anims["right"] 	= %int_mantle_king_tiger_right;
			mantle_anims["back"] 	= %int_mantle_king_tiger_rear;
			break;
		// dpg 5/28/08 added for special half-destroyed shinhoto model
		case "vehicle_jap_tracked_type97_d_intermediate":
		case "vehicle_jap_tracked_type97shinhoto":
			mantle_anims["left"] 	= %int_mantle_chiha_left;
			mantle_anims["right"] = %int_mantle_chiha_right;
			mantle_anims["back"] 	= %int_mantle_chiha_rear;
			break;
		default:
			ASSERTMSG( "get_mantle_anim(): This tank model is not supported" );
	}

	return mantle_anims[side];
}
//
//get_king_tiger_anim( side )
//{
//	mantle_anim = undefined;
//
//	switch( side )
//	{
//		case "right":
//			mantle_anim = %int_mantle_king_tiger_right;
//			break;
//
//		case "left":
//			mantle_anim = %int_mantle_king_tiger_left;
//			break;
//
//		case "back":
//			mantle_anim = %int_mantle_king_tiger_rear;
//			break;
//	}
//
//	return mantle_anim;
//}

#using_animtree( "tank" );
open_hatch( side )
{
	self UseAnimTree( #animtree );

	hatch_anims = [];
	switch( self.model )
	{
		case "vehicle_ger_tracked_king_tiger":
		// Alex Liu 6-17-08 Added special half destroyed tiger
		case "vehicle_ger_tracked_king_tiger_d_inter":
		case "vehicle_ger_tracked_king_tiger_winter":
			hatch_anims["right"] 	= %o_mantle_king_tiger_right;
			hatch_anims["left"] 	= %o_mantle_king_tiger_left;
			hatch_anims["back"] 	= %o_mantle_king_tiger_rear;
			break;
		// dpg 5/28/08 added for special half-destroyed shinhoto model
		case "vehicle_jap_tracked_type97_d_intermediate":
		case "vehicle_jap_tracked_type97shinhoto":
			hatch_anims["right"] 		= %o_mantle_chiha_right;
			hatch_anims["left"] 		= %o_mantle_chiha_left;
			hatch_anims["back"] 		= %o_mantle_chiha_rear;
			hatch_anims["openclose"] 	= %o_mantle_chiha_hatch_openclose;
			break;
		default:
			ASSERTMSG( "open_hatch(): This tank model is not supported" );
	}

	if( !isdefined( hatch_anims[side] ) )
	{
		return;	
	}
	
	self SetFlaggedAnimKnobAllRestart( "hatch_open", hatch_anims[side], %root, 1.0, 0.2, 1.0 );
}

tank_mantle_stance_wrapper(state)
{
	if (state == "mantle begin")
	{
		self allowcrouch( false );
		self allowprone( false );
	}
	else if (state == "mantle end")
	{
		self allowcrouch( true );
		self allowprone( true );
	}
	else
	{
		println ("Invalid mantle state!");
	}
}