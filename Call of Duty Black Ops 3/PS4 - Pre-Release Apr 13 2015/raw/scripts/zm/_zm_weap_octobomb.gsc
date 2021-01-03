#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_zm_clone;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;



#precache( "fx", "zombie/fx_cymbal_monkey_light_zmb" );
#precache( "fx", "zombie/fx_monkey_lightning_zmb" );
#precache( "fx", "zombie/fx_bmode_attack_grapple_zod_zmb" );

#using_animtree( "zombie_octobomb" );

function init()
{
	level.weaponZMOctobomb = GetWeapon( "octobomb" );
	zm_weapons::register_zombie_weapon_callback( level.weaponZMOctobomb, &player_give_octobomb );

	if( !octobomb_exists() )
	{
		return;
	}

/#
	level.zombiemode_devgui_octobomb_give = &player_give_octobomb;
#/

	level.octobomb_model = "p7_fxanim_zm_zod_tentacle_bomb";

	level._effect["monkey_glow"] 	= "zombie/fx_cymbal_monkey_light_zmb";
	level._effect["grenade_samantha_steal"] 	= "zombie/fx_monkey_lightning_zmb";

	level.octobombs = [];
}

function player_give_octobomb()
{
	self GiveWeapon( level.weaponZMOctobomb );
	self zm_utility::set_player_tactical_grenade( level.weaponZMOctobomb );
	self thread player_handle_octobomb();
}

function player_handle_octobomb()
{
	self notify( "starting_octobomb_watch" );
	self endon( "disconnect" );
	self endon( "starting_octobomb_watch" );
	
	// Min distance to attract positions
	attract_dist_custom = level.octobomb_attract_dist_custom;
	if( !isDefined( attract_dist_custom ) )
	{
		attract_dist_custom = 45;
	}
		
	num_attractors = level.num_octobomb_attractors;
	if( !isDefined( num_attractors ) )
	{
		num_attractors = 96;
	}
	
	max_attract_dist = level.octobomb_attract_dist;
	if( !isDefined( max_attract_dist ) )
	{
		max_attract_dist = 1536;
	}
	
	while ( true )
	{
		grenade = get_thrown_octobomb();
		if ( isdefined( grenade ) )
		{
			self player_throw_octobomb( grenade, num_attractors, max_attract_dist, attract_dist_custom );
		}
	}
}

function watch_for_dud(model,actor)
{
	self endon("death");
	self waittill("grenade_dud");
	model.dud = 1;
	self playsound( "zmb_vox_monkey_scream" );
	self.octobomb_scream_vox = true;
	wait 3;
	if(isdefined(model))
		model delete();
	if(isdefined(actor))
		actor delete();
	if (isdefined(self.damagearea))
		self.damagearea delete();
	if(isdefined(self))
		self delete();
}

function watch_for_emp(model,actor)
{
	self endon("death");
	if (!zm_utility::should_watch_for_emp())
		return;
	while (1)
	{
		level waittill("emp_detonate",origin,radius);
		if ( DistanceSquared( origin, self.origin) < radius * radius )
		{
			break;
		}
	}
	self.stun_fx = true;
	if (isdefined(level._equipment_emp_destroy_fx))
	{
		PlayFX( level._equipment_emp_destroy_fx, self.origin + ( 0, 0, 5 ) , ( 0, RandomFloat( 360 ), 0 ) );
	}
	wait 0.15;
	self.attract_to_origin = false;
	self zm_utility::deactivate_zombie_point_of_interest();
//	model ClearAnim( %o_monkey_bomb, 0 );
	wait 1;
	self Detonate();	
	wait 1;
	if(isdefined(model))
		model delete();
	if(isdefined(actor))
		actor delete();
	if (isdefined(self.damagearea))
		self.damagearea delete();
	if(isdefined(self))
		self delete();
}


function clone_player_angles(owner)
{
	self endon( "death" );
	owner endon( "death" );
	while (isdefined(self))
	{
		self.angles = owner.angles;
		{wait(.05);};
	}
}


function show_briefly( showtime )
{
	self endon("show_owner");
	if (isdefined(self.show_for_time))
	{
		self.show_for_time = showtime;
		return;
	}
	self.show_for_time = showtime;
	self SetVisibleToAll();
	while ( self.show_for_time > 0 )
	{
		self.show_for_time -= 0.05;
		{wait(.05);};
	}
	self SetVisibleToAllExceptTeam( level.zombie_team );
	self.show_for_time = undefined;
}


function show_owner_on_attack( owner )
{
	owner endon("hide_owner");
	owner endon("show_owner");
	self endon( "explode" );
	self endon( "death" );
	self endon( "grenade_dud" );
	
	owner.show_for_time = undefined;
	
	for( ;; )
	{
		owner waittill( "weapon_fired" );
		owner thread show_briefly(0.5);
	}
}


function hide_owner( owner )
{
	owner notify("hide_owner");
	owner endon("hide_owner");

	owner SetPerk("specialty_immunemms");
	owner.no_burning_sfx = true;	
	owner notify( "stop_flame_sounds" );
	owner SetVisibleToAllExceptTeam( level.zombie_team );

	owner.hide_owner = true;

	if (isdefined(level._effect[ "human_disappears" ]))
		PlayFX( level._effect[ "human_disappears" ], owner.origin );

	self thread show_owner_on_attack( owner );
	
	evt = self util::waittill_any_return( "explode", "death", "grenade_dud");
	/# println( "ZMCLONE: Player visible again because of "+evt ); #/

	owner notify("show_owner");
	
	owner UnsetPerk("specialty_immunemms");
	if (isdefined(level._effect[ "human_disappears" ]))
		PlayFX( level._effect[ "human_disappears" ], owner.origin );
	owner.no_burning_sfx = undefined;
	owner SetVisibleToAll();

	owner.hide_owner = undefined;

	owner Show();
}



function proximity_detonate( owner )
{
	//self endon("death");
	wait 1.5; // so it can't be used as a simple proximity grenade
	if ( !isdefined(self) )
		return;
	
	detonateRadius = 96;
	explosionRadius = detonateRadius * 2;
	
	damagearea = spawn( "trigger_radius", self.origin + (0,0,0 - detonateRadius), 4, detonateRadius, detonateRadius * 1.5 );
	
	damagearea SetExcludeTeamForTrigger( owner.team );

	damagearea enablelinkto();
	damagearea linkto( self );

	self.damagearea = damagearea;

	while ( isdefined(self) )
	{
		damagearea waittill( "trigger", ent );
		
		if ( isdefined( owner ) && ent == owner )
			continue;

		if( isDefined( ent.team ) && ent.team == owner.team )
			continue;
		
		self playsound ("wpn_claymore_alert");
		
		dist = Distance( self.origin, ent.origin );
		
		radiusdamage(self.origin + (0,0,12),explosionRadius,1,1,owner,"MOD_GRENADE_SPLASH",level.weaponZMOctobomb);

		if ( isdefined( owner ) )
			self detonate( owner );
		else
			self detonate( undefined );
		
		break;		
	}
	
	if (isdefined(damagearea))
		damagearea delete();
}


function player_throw_octobomb( grenade, num_attractors, max_attract_dist, attract_dist_custom )
{
	self endon( "disconnect" );
	self endon( "starting_octobomb_watch" );
	
	grenade endon( "death" );
	
	if ( self laststand::player_is_in_laststand() )
	{
		if ( isdefined( grenade.damagearea ) )
		{
			grenade.damagearea Delete();
		}
		
		grenade Delete();
		return;
	}
	
	grenade Ghost();
	grenade.clone_model = util::spawn_model( grenade.model, grenade.origin, grenade.angles );
	grenade.clone_model LinkTo( grenade );
	
	grenade thread octobomb_cleanup();

	info = SpawnStruct();
	info.sound_attractors = [];
	grenade thread monitor_zombie_groans( info );
	
	grenade waittill( "stationary" );

	grenade ResetMissileDetonationTime();
	PlayFxOnTag( level._effect[ "monkey_glow" ], grenade, "tag_origin" );
	
	valid_poi = zm_utility::check_point_in_enabled_zone( grenade.origin, undefined, undefined );

	if ( isdefined( level.check_valid_poi ) )
	{
		valid_poi = grenade [[ level.check_valid_poi ]]( valid_poi );
	}

	if ( valid_poi )
	{
		grenade move_away_from_edges();
		
		grenade.clone_model zm_utility::self_delete();
	
		grenade Ghost();
		grenade.anim_model = util::spawn_model( level.octobomb_model, grenade.origin, grenade.angles );
		grenade.anim_model UseAnimTree( #animtree );
		
		grenade thread animate_octobomb();
		grenade thread do_octobomb_sound( info );
		grenade thread do_tentacle_burst( self );

		level.octobombs[ level.octobombs.size ] = grenade;
	}
	else
	{
		grenade.script_noteworthy = undefined;
		level thread grenade_stolen_by_sam( grenade );
	}
}

function animate_octobomb()
{
	self.anim_model playsound( "wpn_octobomb_explode" );
	self.anim_model playloopsound( "wpn_octobomb_flail_loop" );
	self.anim_model animation::play( "p7_fxanim_zm_zod_tentacle_bomb_start_anim" );
	self.anim_model thread animation::play( "p7_fxanim_zm_zod_tentacle_bomb_loop_anim" );
	
	n_end_anim_length = GetAnimLength( "p7_fxanim_zm_zod_tentacle_bomb_end_anim" );
	n_life_time = ( ( self.weapon.fusetime - ( n_end_anim_length * 1000 ) ) / 1000 );
	
	wait n_life_time;
	
	self.anim_model stoploopsound( 1 );
	self.anim_model playsound( "wpn_octobomb_end" );
	self.anim_model animation::play( "p7_fxanim_zm_zod_tentacle_bomb_end_anim" );
}


function move_away_from_edges()
{
	v_orig = self.origin;
	queryResult = PositionQuery_Source_Navigation(
					self.origin,		// origin
					0,					// min radius
					200,				// max radius
					100,				// half height
					2,					// inner spacing
					50					// radius from edges
				);
					
	if ( queryResult.data.size )
	{
		for ( i = 0; i < 5; i++ )
		{
			point = array::random( queryResult.data );
			
			if ( BulletTracePassed( point.origin + ( 0, 0, 20 ), v_orig + ( 0, 0, 20 ), false, self, self.clone_model, false, false ) )
			{
				self.origin = point.origin;
				break;
			}
		}
	}
}


// if the player throws it to an unplayable area samantha steals it
function grenade_stolen_by_sam( grenade )
{
	if( !IsDefined( grenade ) )
	{
		return;
	}
	
	//ent_grenade notify( "sam_stole_it" );
	
	direction = grenade.origin;
	direction = ( direction[ 1 ], direction[ 0 ], 0 );
 
	if ( direction[ 1 ] < 0 || ( direction[ 0 ]  > 0 && direction[ 1 ]  > 0 ) )
	{
		direction = ( direction[ 0 ], direction[ 1 ] * -1, 0 );
	}
	else if ( direction[ 0 ] < 0 )
	{
		direction = ( direction[ 0 ] * -1, direction[ 1 ], 0 );
	}
	
	// Play laugh sound here, players should connect the laugh with the movement which will tell the story of who is moving it
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( IsAlive( players[ i ] ) )
		{
			players[ i ] PlayLocalSound( level.zmb_laugh_alias );
		}
	}
	
	// play the fx on the model
	PlayFXOnTag( level._effect[ "grenade_samantha_steal" ], grenade, "tag_origin" );
	
	grenade.clone_model Unlink();
	
	// raise the model
	grenade.clone_model MoveZ( 60, 1.0, 0.25, 0.25 );

	// spin it
	grenade.clone_model Vibrate( direction, 1.5,  2.5, 1.0 );
	grenade.clone_model waittill( "movedone" );
	
	if ( isdefined( self.damagearea ) )
	{
		self.damagearea Delete();
	}
	
	grenade.clone_model Delete();
		
	if ( isdefined( grenade ) )
	{
		if ( isdefined( grenade.damagearea ) )
		{
			grenade.damagearea Delete();
		}
		
		grenade Delete();
	}
}

function octobomb_cleanup()
{
	while ( true )
	{
		if ( !isDefined( self ) )
		{
			if ( isdefined( self.clone_model ) )
			{
				self.clone_model Delete();
			}
			
			if ( isdefined( self.anim_model ) )
			{
				self.anim_model Delete();
			}
				
			if ( isdefined( self ) && ( isdefined( self.dud ) && self.dud ) ) // wait for the screams to die out
			{
				wait 6;
			}
			
			if ( isdefined( self.simulacrum ) )
			{
				self.simulacrum delete();
			}
			
			zm_utility::self_delete();
			return;
		}
		
		{wait(.05);};
	}
}

function do_octobomb_sound( info )
{

	self waittill( "explode", position );
	level notify( "grenade_exploded", position, 100, 5000, 450 );

	octobomb_index = -1;
	for ( i = 0; i < level.octobombs.size; i++ )
	{
		if ( !isdefined( level.octobombs[ i ] ) )
		{
			octobomb_index = i;
			break;
		}
	}
	
	if ( octobomb_index >= 0 )
	{
		ArrayRemoveIndex( level.octobombs, octobomb_index );
	}
}



 // how long it takes the octobomb to grow to full size

function do_tentacle_burst( e_player )
{
	self endon( "explode" );
	
	n_time_started = GetTime() / 1000;
	
	while ( true )
	{
		n_time_current = GetTime() / 1000;
		n_time_elapsed = n_time_current - n_time_started;
		
		if ( n_time_elapsed < 1 )
		{
			n_radius = LerpFloat( 0, 70, n_time_elapsed / 1 );
		}

		a_potential_targets = GetAiSpeciesArray( "axis", "all" );
		a_targets = ArraySortClosest( a_potential_targets, self.origin, a_potential_targets.size, 0, n_radius );

		foreach ( target in a_targets )
		{
			if ( IsAlive( target ) )
			{
				target octo_gib();
				target DoDamage( target.health, target.origin, e_player );
				
				wait .05;
				
				PlayFX( "zombie/fx_bmode_attack_grapple_zod_zmb", target GetTagOrigin( "j_spineupper" ) );
				target Delete();
			}
		}
		
		wait 0.2;
	}
}

function octo_gib()
{
	gibserverutils::gibhead( self );
	
	if ( math::cointoss() )
	{
		gibserverutils::gibleftarm( self );
	}
	else
	{
		gibserverutils::gibrightarm( self );
	}
	
	gibserverutils::giblegs( self );
}

function play_delayed_explode_vox()
{
	wait 6.5;
	
	if ( isdefined( self ) )
	{
		self PlaySound( "zmb_vox_monkey_explode" );
	}
}

function get_thrown_octobomb()
{
	self endon( "disconnect" );
	self endon( "starting_octobomb_watch" );
	
	while ( true )
	{
		self waittill( "grenade_fire", grenade, weapon );
		if ( weapon == level.weaponZMOctobomb )
		{
			grenade.use_grenade_special_long_bookmark = true;
			grenade.grenade_multiattack_bookmark_count = 1;
			grenade.weapon = weapon;
			return grenade;
		}
		
		{wait(.05);};
	}
}

function monitor_zombie_groans( info )
{
	self endon( "explode" );
            
	while( true ) 
	{
		if( !isDefined( self ) )
		{
			return;
		}
		
		if( !isDefined( self.attractor_array ) )
		{
			{wait(.05);};
			continue;
		}
		
		for( i = 0; i < self.attractor_array.size; i++ )
		{
			if( !IsInArray( info.sound_attractors, self.attractor_array[i] ) )
			{
				if ( isDefined( self.origin ) && isDefined( self.attractor_array[i].origin ) )
				{
					if( distanceSquared( self.origin, self.attractor_array[i].origin ) < 500 * 500 )
					{
						if ( !isdefined( info.sound_attractors ) ) info.sound_attractors = []; else if ( !IsArray( info.sound_attractors ) ) info.sound_attractors = array( info.sound_attractors ); info.sound_attractors[info.sound_attractors.size]=self.attractor_array[i];;
						self.attractor_array[i] thread play_zombie_groans();
					}
				}
			}
		}
		{wait(.05);};
	}
} 

function play_zombie_groans()
{
	self endon( "death" );
	self endon( "octobomb_blown_up" );
            
	while(1)
	{
		if( isdefined ( self ) )
		{
			self playsound( "zmb_vox_zombie_groan" );
			wait randomfloatrange( 2, 3 );
		}
		else
		{
			return;
		}
	}
}

function octobomb_exists()
{
	return zm_weapons::is_weapon_included( level.weaponZMOctobomb );
}


