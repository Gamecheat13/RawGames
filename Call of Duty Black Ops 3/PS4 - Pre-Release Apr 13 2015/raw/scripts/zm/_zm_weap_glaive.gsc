    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;

#using scripts\shared\ai\zombie_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_glaive;

#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_utility;

#precache( "fx", "zombie/fx_sword_slam_elec_3p_zod_zmb" );
#precache( "fx", "zombie/fx_tesla_shock_zmb" );
#precache( "fx", "zombie/fx_tesla_shock_eyes_zmb" );
#precache( "fx", "blood/fx_blood_neck_spray_zmb" );
#precache( "fx", "impacts/fx_flesh_hit_knife_lg_zmb" );


#precache( "string", "ZM_ZOD_SWORD_DEBUG_PRINT" );

#namespace zm_weap_glaive;

function autoexec __init__sytem__() {     system::register("zm_weap_glaive",&__init__,undefined,undefined);    }
	


 // (100 * 100)





 // dot product greater than this to count, 45 degrees off of straight ahead to either side

//#define GLAIVE_DAMAGE_LOCATIONS 		array( "left_arm_upper", "left_arm_lower", "left_hand", "right_arm_upper", "right_arm_lower", "right_hand", "left_leg_upper", "left_leg_lower", "left_foot", "right_leg_upper", "right_leg_lower", "right_foot" )

	
function __init__()
{
	clientfield::register( "toplayer", "slam_fx", 1, 1, "counter" );
	clientfield::register( "toplayer", "swipe_fx", 1, 1, "counter" );

	level._effect["glaive_explosion"]		= "zombie/fx_sword_slam_elec_3p_zod_zmb";
	level._effect["glaive_shock"]			= "zombie/fx_tesla_shock_zmb";
	level._effect["glaive_shock_eyes"]		= "zombie/fx_tesla_shock_eyes_zmb";
	level._effect["glaive_blood_spurt"]		= "impacts/fx_flesh_hit_knife_lg_zmb";

	
	level.glaive_excalibur_aoe_range = 240;
	level.glaive_excalibur_aoe_range_sq = level.glaive_excalibur_aoe_range * level.glaive_excalibur_aoe_range;

	level.glaive_excalibur_cone_range = 100;
	level.glaive_excalibur_cone_range_sq = level.glaive_excalibur_cone_range * level.glaive_excalibur_cone_range;

	level.glaive_chop_cone_range = 120;
	level.glaive_chop_cone_range_sq = level.glaive_chop_cone_range * level.glaive_chop_cone_range;

	callback::on_connect( &watch_sword_equipped );
	
	for( i = 0; i < 4; i++ )
	{
		zombie_utility::add_zombie_gib_weapon_callback( "glaive_apothicon" + "_" + i, &gib_check, &gib_head_check );
		zombie_utility::add_zombie_gib_weapon_callback( "glaive_keeper" + "_" + i, &gib_check, &gib_head_check );
		zm_utility::register_hero_weapon_for_level( "glaive_apothicon" + "_" + i );
		zm_utility::register_hero_weapon_for_level( "glaive_keeper" + "_" + i );
	}
	
	level.glaive_damage_locations = array( "left_arm_upper", "left_arm_lower", "left_hand", "right_arm_upper", "right_arm_lower", "right_hand" ); 
	
	level thread watch_round_start_sword();

}

// each player character gets its own sword (functionally identical, differ in name and possibly minor texture difference in inscription)
// this function returns the correct weapon entry for the sword that matches the player character identity
// self = player
// n_upgrade_level = 1 for the base sword (Apothicon), 2 for the upgraded sword (Keeper)
function get_correct_sword_for_player_character_at_level( n_upgrade_level )
{
	str_wpnname = undefined;
	
	// is this the apothicon or keeper sword?
	if( n_upgrade_level == 1 )
	{
		str_wpnname = "glaive_apothicon";
	}
	else
	{
		str_wpnname = "glaive_keeper";
	}
	
	// complete the weapon name string, using the character index
	str_wpnname = str_wpnname + "_" + self.characterIndex;
	
	wpn = GetWeapon( str_wpnname );
	
	return wpn;
}

function private display_usage_meter()
{
/#
	self endon( "disconnect" );
	
	wpn_excalibur = self get_correct_sword_for_player_character_at_level( 1 );
	wpn_autokill = self get_correct_sword_for_player_character_at_level( 2 );

	self.usage_meter_text = NewClientHudElem( self );
	self.usage_meter_text.elemType = "font";
	self.usage_meter_text.font = "objective";
	self.usage_meter_text.fontscale = 1.8;
	self.usage_meter_text.horzAlign = "left";
	self.usage_meter_text.vertAlign = "top";
	self.usage_meter_text.alignX = "left";
	self.usage_meter_text.alignY = "top";
	self.usage_meter_text.x = 15;
	self.usage_meter_text.y = 55;
	self.usage_meter_text.sort = 2;

	self.usage_meter_text.color = ( 0, 1, 0 );
	self.usage_meter_text.alpha = 1;

	self.usage_meter_text.hidewheninmenu = true;

	last_power = 0;
	while ( true )
	{
		if ( !self HasWeapon( wpn_autokill ) && !self HasWeapon( wpn_excalibur ) )
		{
			last_power = 0;
			self.usage_meter_text fadeOverTime( 1 );
			self.usage_meter_text.alpha = 0;

			wait( 1 );
			continue;
		}

		power = Int( self GadgetPowerChange( 0, 0 ) );

		if ( last_power == power )
		{
			// do nothing
		}
		else if ( 100 <= power )
		{
			self.usage_meter_text.color = ( 0, 1, 0 );
		}
		else if ( last_power <= power )
		{
			self.usage_meter_text.color = ( 0, 0, 1 );
		}
		else if ( 3 <= last_power - power )
		{
			self.usage_meter_text.color = ( 1, 0, 0 );
		}
		else
		{
			self.usage_meter_text fadeOverTime( 1 );
			self.usage_meter_text.color = ( 1, 1, 0 );
		}

		self.usage_meter_text.alpha = 1;
		self.usage_meter_text SetText( &"ZM_ZOD_SWORD_DEBUG_PRINT", power );

		last_power = power;
		wait( 0.05 );
	}
#/
}

function private watch_round_change()
{
	/*self endon( "disconnect" );

	wpn_excalibur = self get_correct_sword_for_player_character_at_level( 1 );
	wpn_autokill = self get_correct_sword_for_player_character_at_level( 2 );


	while ( true )
	{
		level waittill( "start_of_round" );

		if ( self HasWeapon( wpn_autokill ) )
		{
			self GadgetPowerChange( 0, 100 );
		}
		else if ( self HasWeapon( wpn_excalibur ) )
		{
			self GadgetPowerChange( 0, 100 );
		}
	}
	*/
}

function private watch_sword_equipped()
{
	self endon( "disconnect" );

	self thread display_usage_meter();
	self thread watch_round_change();

	wpn_excalibur = self get_correct_sword_for_player_character_at_level( 1 );
	wpn_autokill = self get_correct_sword_for_player_character_at_level( 2 );
	

	SetDvar( "cg_thirdPersonMode", 0 );
	SetDvar( "cg_thirdpersonRange", 128 );
	SetDvar( "cg_thirdPersonAngle", -10 );
	SetDvar( "cg_thirdPersonSideOffset", 20 );
	SetDvar( "cg_thirdPersonCamLerpScale", 0.4 );	
	self.sword_allowed = true;
	
	while ( true )
	{
		self waittill( "weapon_change", wpn_cur, wpn_prev );
		self.usingsword = false;
		self.wpn_prev = wpn_prev;
		
		if( self.sword_allowed )
		{
			if ( wpn_cur == wpn_autokill )
			{
				self.current_sword = wpn_autokill;
				self GadgetPowerChange( 0, 100 );
				self.usingsword = true;
				self thread sword_power_hud(); 
				self thread arc_attack_think( wpn_cur );
				self thread autokill_think( wpn_autokill, wpn_prev );
			}
			else if ( wpn_cur == wpn_excalibur )
			{
				self.current_sword = wpn_excalibur;
				self GadgetPowerChange( 0, 100 );
				self.usingsword = true;
				self thread sword_power_hud(); 
				self thread arc_attack_think( wpn_excalibur, wpn_cur );
				self thread excalibur_think( wpn_excalibur );
			}
		}
		else
		{
			self disabled_sword();
		}
	}
}

function private gib_check( damage_percent )
{
	self.override_damagelocation = "none";
	if ( damage_percent > 99.8 )
		self.override_damagelocation = "neck";
	//else if ( self.damagelocation == "none" )
	//	self.damagelocation = array::random(level.glaive_damage_locations);
		
	return true; 
}

function private gib_head_check( damage_location )
{
	if ( ( self.override_damagelocation === "neck" ) )
		return true; 
	if ( !IsDefined(damage_location) )
		return false; 
	if ( damage_location == "head" )
		return true; 
	if ( damage_location == "helmet" )
		return true; 
	if ( damage_location == "neck" )
		return true; 
	return false; 
}

function private excalibur_think( wpn_excalibur )
{
	self endon( "weapon_change" );
	self endon( "disconnect" );
	self endon( "bled_out" );

	while ( true )
	{
		self waittill( "weapon_melee_power_left", weapon );

		if ( weapon == wpn_excalibur )
		{
			//self GadgetPowerChange( 0, -30 );
			self clientfield::increment_to_player( "slam_fx" );
			//Playfx( level._effect["glaive_explosion"], self.origin, self.angles );
			self playsound( "wpn_sword_explode" );
			self thread do_excalibur( wpn_excalibur );
			//self clientfield::set_to_player( "slam_fx", 0 );
		}
	}
}

function private do_excalibur( wpn_excalibur )
{
	view_pos = self GetWeaponMuzzlePoint();
	forward_view_angles = self GetWeaponForwardDir();

	zombie_list = GetAITeamArray( level.zombie_team );
	foreach( ai in zombie_list )
	{
		if ( !IsDefined( ai ) || !IsAlive( ai ) )
		{
			continue;
		}

		test_origin = ai getcentroid();
		dist_sq = DistanceSquared( view_pos, test_origin );
		if ( dist_sq < level.glaive_excalibur_aoe_range_sq )
		{
			self thread electrocute_actor( ai, wpn_excalibur );
			continue;
		}

		if ( dist_sq > level.glaive_excalibur_cone_range_sq )
		{
			continue;
		}

		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if ( 0.707 > dot )
		{
			continue;
		}

		if ( 0 == ai DamageConeTrace( view_pos, self ) )
		{
			// guy can't actually be hit from where we are
			continue;
		}

		self thread electrocute_actor( ai, wpn_excalibur );
	}
}

// self == player
//
function electrocute_actor( ai, wpn_excalibur )
{
	self endon( "disconnect" );

	if( !IsDefined( ai ) || !IsAlive( ai ) )
	{
		// guy died on us 
		return;
	}

	ai electric_death_fx();
	ai DoDamage( 13638, self.origin, self, self, "none", "MOD_UNKNOWN", 0, wpn_excalibur );
}

function chop_actor( ai )
{
	self endon( "disconnect" );

	if( !IsDefined( ai ) || !IsAlive( ai ) )
	{
		// guy died on us 
		return;
	}

	ai blood_death_fx();
	ai DoDamage( 13638, self.origin, self, self, "none", "MOD_UNKNOWN", 0 );
}

function private blood_death_fx()
{
	tag = "J_Neck";
	fx = "glaive_blood_spurt";
	
	if ( self.archetype == "zombie" )
	{
		zm_net::network_safe_play_fx_on_tag( "chop_death_fx", 2, level._effect[fx], self, tag );
		//self playsound( "wpn_imp_tesla" );
	
		self.a.gib_ref = array::random( array( "guts", "right_arm", "left_arm", "head" ) );
		self thread zombie_death::do_gib();
	}
}

function private electric_death_fx()
{
	tag = "J_SpineUpper";
	fx = "glaive_shock";

	if ( self.archetype == "zombie" )
	{
		zm_net::network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect[fx], self, tag );
	}
	self playsound( "wpn_imp_tesla" );
}

function chop_zombies()
{
	view_pos = self GetWeaponMuzzlePoint();
	forward_view_angles = self GetWeaponForwardDir();
	

	zombie_list = GetAITeamArray( level.zombie_team );
	foreach( ai in zombie_list )
	{
		if ( !IsDefined( ai ) || !IsAlive( ai ) )
		{
			continue;
		}
	
		test_origin = ai getcentroid();
		dist_sq = DistanceSquared( view_pos, test_origin );
		if ( dist_sq > level.glaive_chop_cone_range_sq )
		{
			continue;
		}
	
		normal = VectorNormalize( test_origin - view_pos );
		dot = VectorDot( forward_view_angles, normal );
		if (dot <= 0.0 )
		{
			continue;
		}
	
		if ( 0 == ai DamageConeTrace( view_pos, self ) )
		{
			// guy can't actually be hit from where we are
			continue;
		}
	
		self thread chop_actor( ai );
	}
}

/*
//self == level - rumbles, screenshakes and flagsets
function swordarc_notetrack( str_notetrack )
{
	self waittill( str_notetrack );
	self thread chop_zombies();
}

function swordarc_swipe( player )
{
	self thread swordarc_notetrack( "sword_slash_1" );
	self thread swordarc_notetrack( "sword_slash_2" );
}
*/

function swordarc_swipe( player )
{
	player clientfield::increment_to_player( "swipe_fx" );
	player thread chop_zombies();
	wait( 0.3 );
	player thread chop_zombies();
	wait( 0.5 );
	player thread chop_zombies();
}

function private arc_attack_think( weapon, wpn_name )
{
	self endon( "weapon_change" );
	self endon( "disconnect" );
	self endon( "bled_out" );

	while ( true )
	{
		self util::waittill_any( "weapon_melee", "weapon_melee_charge" );
		
		weapon thread swordarc_swipe( self );
	}
}	
	

// self == player
//
function private autokill_think( wpn_autokill, wpn_prev )
{
	self endon( "weapon_change" );
	self endon( "disconnect" );
	self endon( "bled_out" );

	while ( true )
	{
		self waittill( "weapon_melee_power", weapon );

		if ( weapon == wpn_autokill )
		{
			self thread send_autokill_sword( wpn_autokill, wpn_prev );
			self playsound( "wpn_sword2_fire" );
		}
	}
}

function private send_autokill_sword( wpn_autokill, wpn_prev )
{	
	a_sp_glaive = GetSpawnerArray( "glaive_spawner", "script_noteworthy" );
	sp_glaive = a_sp_glaive[0];
	sp_glaive.count = 1;
	vh_glaive = sp_glaive SpawnFromSpawner( "player_glaive_" + self.characterIndex, true );
	if ( isdefined( vh_glaive ) )
	{
		vh_glaive vehicle::lights_on();
		
		vh_glaive.origin = self.origin + 80 * AnglesToForward( self.angles ) + (0,0,50);
		vh_glaive.angles = self GetPlayerAngles();
		vh_glaive.owner = self;
		vh_glaive.weapon = wpn_autokill;
		vh_glaive._glaive_settings_lifetime = math::clamp( Int( self GadgetPowerChange( 0, 0 ) / 2 ), 10, 60 );

		self TakeWeapon( wpn_autokill );
		self SwitchToWeapon( wpn_prev );
		
		vh_glaive util::waittill_any( "returned_to_owner", "disconnect" );

		if ( IsDefined( self ) )
		{
			util::wait_network_frame();
			self zm_weapons::weapon_give( wpn_autokill, undefined, undefined, true );
			self playsound( "wpn_sword2_return" );
		}
		
		vh_glaive Delete();
	}
}








function watch_round_start_sword()
{
	level waittill( "start_of_round" ); // skip the first round
	while ( 1 )
	{
		level waittill( "start_of_round" );
		foreach( player in GetPlayers() )
		{
			if ( ( isdefined( player.usingsword ) && player.usingsword ) )
			{
				player.sword_power = 1.0;
			}
			player.sword_allowed = true;
			if( isdefined(player.current_sword) )
			{
				//Give the player the sword to use
				//player zm_weapons::weapon_give( player.current_sword, false, false, true );
				player GiveWeapon( player.current_sword );
				player GadgetPowerChange( 0, 100 );
				player zm_equipment::show_hint_text( &"ZM_ZOD_SWORD_HINT", 2 );
			}

		}
	}
}


function disabled_sword()
{
	wpn_excalibur = self get_correct_sword_for_player_character_at_level( 1 );
	wpn_autokill = self get_correct_sword_for_player_character_at_level( 2 );
	/#
	if( ( isdefined( self.swordpreserve ) && self.swordpreserve ) )
	{
		self.sword_allowed = true;
		return;
	}
	#/
		
	self.sword_allowed = false;
	if ( self HasWeapon( wpn_autokill ) )
	{
		if( isdefined(self.wpn_prev) )
		{
			self SwitchToWeapon( self.wpn_prev );
			self.wpn_prev = undefined;
		}
		self GadgetPowerChange( 0, 100 );
		self TakeWeapon( wpn_autokill );
	}
	else if ( self HasWeapon( wpn_excalibur ) )
	{
		if( isdefined(self.wpn_prev) )
		{
			self SwitchToWeapon( self.wpn_prev );
			self.wpn_prev = undefined;
		}
		self GadgetPowerChange( 0, 100 );
		self TakeWeapon( wpn_excalibur );
	}
	self.sword_power = 0.0;
}


function sword_power_hud()
{
	self endon("disconnect");

	//wpn_excalibur = self get_correct_sword_for_player_character_at_level( 1 );
	//wpn_autokill = self get_correct_sword_for_player_character_at_level( 2 );

	tempY = level.primaryProgressBarY;
	level.primaryProgressBarY = 180;
	self.swordpowerbar = hud::createPrimaryProgressBar();
	level.primaryProgressBarY = tempY;
	self.sword_power = 1.0;
	
	while( IsDefined( self ) && ( isdefined( self.usingsword ) && self.usingsword ) && (self.sword_power>0) )
	{
		//self.sword_power = self GadgetPowerChange( 0, 0 )/100.0;
		self.sword_power -= ( ( 1.0 - 0.0 ) / ( 20.0 * 25 ) );
		/#
		if( ( isdefined( self.swordpreserve ) && self.swordpreserve ) )
		{
			self.sword_power = 1.0;
		}
		#/		
		self.swordpowerbar hud::updateBar( self.sword_power );
		self GadgetPowerChange( 0, -( ( 1.0 - 0.0 ) / ( 20.0 * 25 ) )*100 );
		{wait(.05);};
	}
	
	//Waittill next round
	self disabled_sword();

	if ( IsDefined( self ) && IsDefined(self.swordpowerbar) )
	{
		self.swordpowerbar hud::destroyElem();
	}
}
