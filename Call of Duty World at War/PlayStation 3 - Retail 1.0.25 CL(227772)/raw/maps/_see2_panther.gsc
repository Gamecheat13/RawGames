// _panther.gsc
// Sets up the behavior for the Panther Tank and variants.

#include maps\_vehicle_aianim;
#include maps\_vehicle;

main(model,type)
{
	build_template( "see2_panther", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_ger_tracked_panther", "vehicle_ger_tracked_panther_d_base" );
	build_deathmodel( "vehicle_ger_tracked_panther_winter", "vehicle_ger_tracked_panther_d_base" );
	build_shoot_shock( "tankblast" );
	//build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	build_exhaust( "vehicle/exhaust/fx_exhaust_panther" );
	//build_deckdust( "dust/abrams_desk_dust" );
	build_deathfx( "vehicle/vexplosion/fx_vexplode_ger_panther", undefined, "explo_metal_rand" );
	build_deathfx( "vehicle/vfire/fx_vfire_ger_panther", "tag_origin", undefined );
	build_deathfx( "vehicle/vfire/fx_vsmoke_ger_panther", "tag_origin", undefined );
	build_deathquake( 0.7, 1.0, 600 );
	build_turret( "panther_coaxial_mg", "tag_turret", "weapon_machinegun_tiger", false );
	build_treadfx();
	build_life( 1000, 999, 1000 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "axis" );
	build_mainturret();
	build_compassicon();
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
	
	precachemodel( "vehicle_ger_tracked_panther_seta_body" );
	precachemodel( "vehicle_ger_tracked_panther_seta_turret" );
	precachemodel( "vehicle_ger_tracked_panther_setb_body" );
	precachemodel( "vehicle_ger_tracked_panther_setb_turret" );
	precachemodel( "vehicle_ger_tracked_panther_setc_body" );
	precachemodel( "vehicle_ger_tracked_panther_setc_turret" );
}

// Anthing specific to this vehicle, used globally.
init_local()
{
	//self thread keep_track_of_guys_hitting_me();
	//self thread reward_assist_points();
}

keep_track_of_guys_hitting_me()
{
	self endon("death");
	self.hit_by_player_array = [];
	
	self.hit_by_player_array[0] = false;
	self.hit_by_player_array[1] = false;
	self.hit_by_player_array[2] = false;
	self.hit_by_player_array[3] = false;
	
	player_hit_me = undefined;
	
	while(1)
	{
		self waittill("damage", amount, attacker );
		
		self.last_thing_to_hit_me = attacker;
		
		if( IsPlayer( attacker ) )
		{
			player_hit_me = attacker;
		}
		else if( IsDefined(attacker.classname) && attacker.classname == "script_vehicle" )
		{
			veh_owner = attacker GetVehicleOwner();
			
			if(IsDefined(veh_owner) && IsPlayer(veh_owner))
			{
				player_hit_me = attacker;
			}
		}
		
		if(IsDefined(player_hit_me))
		{
			players = maps\_utility::get_players();
			for( i=0; i < players.size; i++ )
			{
				if(players[i] == player_hit_me)
				{
					self.hit_by_player_array[i] = true;
				}
			}
			
			player_hit_me = undefined;
		}
	}
}

reward_assist_points()
{
	self waittill("death");
	
	players = maps\_utility::get_players();
	
	for(i = 0; i < players.size; i++)
	{
		if(self.hit_by_player_array[i] && self.last_thing_to_hit_me != players[i])
		{
			maps\_utility::arcademode_assignpoints("arcademode_score_bombplant",		players[i] );
		}
	}
}


// Animtion set up for vehicle anims
#using_animtree ("tank");
set_vehicle_anims(positions)
{
	return positions;
}


// Animation set up for AI on the tank
// 2/21/07 - THESE ARE TEMP ANIMS
#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i=0;i<10;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_guy1";
	positions[1].sittag = "tag_guy2";
	positions[2].sittag = "tag_guy3";
	positions[3].sittag = "tag_guy4";
	positions[4].sittag = "tag_guy5";
	positions[5].sittag = "tag_guy6";
	positions[6].sittag = "tag_guy7";
	positions[7].sittag = "tag_guy8";
	positions[8].sittag = "tag_guy9";
	positions[9].sittag = "tag_guy10";
//	
//	positions[0].idle = %humvee_passenger_idle_R;
//	positions[1].idle = %humvee_passenger_idle_R;
//	positions[2].idle = %humvee_passenger_idle_R;
//	positions[3].idle = %humvee_passenger_idle_R;
//	positions[4].idle = %humvee_passenger_idle_R;
//	positions[5].idle = %humvee_passenger_idle_R;
//	positions[6].idle = %humvee_passenger_idle_R;
//	positions[7].idle = %humvee_passenger_idle_R;
//	positions[8].idle = %humvee_passenger_idle_R;
//	positions[9].idle = %humvee_passenger_idle_R;
//						
//	positions[0].getout = %humvee_passenger_out_R;
//	positions[1].getout = %humvee_passenger_out_R;
//	positions[2].getout = %humvee_passenger_out_R;
//	positions[3].getout = %humvee_passenger_out_R;
//	positions[4].getout = %humvee_passenger_out_R;
//	positions[5].getout = %humvee_passenger_out_R;
//	positions[6].getout = %humvee_passenger_out_R;
//	positions[7].getout = %humvee_passenger_out_R;
//	positions[8].getout = %humvee_passenger_out_R;
//	positions[9].getout = %humvee_passenger_out_R;
//	
//	positions[0].getin = %humvee_passenger_in_R;
//	positions[1].getin = %humvee_passenger_in_R;
//	positions[2].getin = %humvee_passenger_in_R;
//	positions[3].getin = %humvee_passenger_in_R;
//	positions[4].getin = %humvee_passenger_in_R;
//	positions[5].getin = %humvee_passenger_in_R;
//	positions[6].getin = %humvee_passenger_in_R;
//	positions[7].getin = %humvee_passenger_in_R;
//	positions[8].getin = %humvee_passenger_in_R;
//	positions[9].getin = %humvee_passenger_in_R;
//	
	return positions;
}

