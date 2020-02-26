 /* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	

This is where all the vehicle / ai interactions happen

High level functions

	handle_attached_guys()  // this is the setup for slots of guys on a vehicle threads notify handlers

	run_to_vehicle( vehicle ) // this tells the guy to run to a vehicle and get in

	vehicle_enter( vehicle ) // this puts the guy into the vehicle and tells him to idle
		
		guy_handle( guy, pos ) // this handles the vehicles animation events( stand, attack, duck, turn, unload )
		
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
	
Lets say we want to add a "nose pick" event to the jeep passenger.
		
in _jeep  there is a thread called set_anims() where all sorts of animations and 
stuff are asigned to the positions a guy can ride in.

the element is the position where 0 is always the driver in the jeeps case 1 is the passenger.

in _jeep::set_anims() put add this

positions[ 1 ].nosepick = %jeep_passenger_nosepick;

	
in guy_handle() you have a bunch of pointers like this

	level.vehicle_aianimthread[ "idle" ] = ::guy_idle;
	level.vehicle_aianimthread[ "duck" ] = ::guy_duck;
	level.vehicle_aianimthread[ "stand" ] = ::guy_stand;

add to the list your pointer

	level.vehicle_aianimthread[ "nosepick" ] = ::guy_picknose;

then the event thread would looks something like this:

guy_picknose( guy, pos )
{
	animpos = anim_pos( self, pos );  // first gets the animation struct information for the position of the guy.
	anim_endons( guy ); // is the standard endons for these functions( vehicle dies, guy dies, new anim event happens )
	if( isdefined( animpos.nosepick ) )  // from there you put a check for your animation
		animontag( guy, animpos.sittag, animpos.nosepick );
	thread guy_idle( guy, pos );
}	

 */ 

#include maps\_utility;
#include common_scripts\utility;
#include maps\_turret;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree( "generic_human" );

// self == ai
vehicle_enter( vehicle, tag )
{
	// do stuff that should happen BEFORE _spawner auto spawn logic below this
	assert( !isdefined( self.ridingvehicle ), "ai can't ride two vehicles at the same time" );

	if (IsDefined(tag))
	{
		self.forced_startingposition = anim_pos_from_tag(vehicle, tag);
	}
	
	type = vehicle.vehicletype;
	vehicleanim = vehicle get_aianims();
	maxpos = level.vehicle_aianims[ type ].size;

	 // walkers are special
	if( isdefined( self.script_vehiclewalk ) )
	{
		pos = set_walkerpos( self, level.vehicle_walkercount[ type ] );
		vehicle thread WalkWithVehicle( self, pos );
		return;
	}
	
	vehicle.attachedguys[ vehicle.attachedguys.size ] = self;
	
	 // set the position
	pos = vehicle set_pos( self, maxpos );
	
	if( !isdefined( pos ) )
	{
		return;		
	}
	
	if ( pos == 0 )
		self.drivingVehicle = true;
	
	animpos = anim_pos( vehicle, pos );
	vehicle.usedPositions[ pos ] = true;
	self.pos = pos;
	
	if( isdefined( animpos.delay ) )
	{
		self.delay = animpos.delay;
		if( isdefined( animpos.delayinc ) )
		{
			vehicle.delayer = self.delay;
		}
	}
	
	if( isdefined( animpos.delayinc ) )
	{
		vehicle.delayer += animpos.delayinc;
		self.delay = vehicle.delayer;
	}
	
	self.ridingvehicle = vehicle;
	self.orghealth = self.health;
	self.vehicle_idle = animpos.idle;			 // multiple idle anims

	//Sumeet ( 05/30/08 ) : added key to allow specifying combat_idle anims on vehicle spawners		
	self.vehicle_idle_combat = animpos.idle_combat; 
	self.vehicle_idle_pistol = animpos.idle_pistol;
	self.vehicle_standattack = animpos.standattack;

	self.standing = 0;
	
	self.allowdeath = false;
	if( isdefined( self.deathanim ) && !isdefined( self.magic_bullet_shield ) )
	{
		self.allowdeath = true;
	}
		
	if ( isdefined( animpos.death ) )
	{
		if ( !isdefined( self.magic_bullet_shield ) || self.magic_bullet_shield == 0 )
			vehicle thread guy_death( self, animpos );
	}
	
	if ( !isdefined( self.vehicle_idle ) )
	{
		self.allowdeath = true;// these are the truck guys who are simply attached ai
	}
	

	vehicle.riders[ vehicle.riders.size ] = self;
	
	if ( !isdefined( animpos.explosion_death ) )
	{
		vehicle thread guy_vehicle_death( self );
	}
	

	// do stuff that should happen AFTER _spawner auto spawn logic below this
	if ( self.classname != "script_model" && spawn_failed( self ) )
	{
		return;
	}
	
	org = vehicle gettagorigin( animpos.sittag );
	angles = vehicle gettagAngles( animpos.sittag );
	self linkto( vehicle, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	// If there is a turret weapon at this position, set the use for that turret
	n_turret_index = _get_turret_index_for_tag( animpos.sittag );
	if ( IsDefined( n_turret_index ) )
	{
		if ( IsDefined( vehicle get_turret_weapon_name( n_turret_index ) ) )
		{
			vehicle _vehicle_turret_set_user( self, animpos.sittag );
		}
	}

	 // some guys "holster" their weapons while operating a vehicle( flak88 guys ).
	 // Some of the cod2 animations don't do anything with the weapon tag and
	 // require script to remove the weapon, Ideally we would have guys who are riding
	 // stash their gun to the sides( like in the jeep rider animations of cod2 )
	if( isai( self ) )
	{
		self teleport( org, angles );
		
		self.a.disablelongdeath = true;
		if( isdefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
		{	
			self gun_remove();  // these guys don't ever get their gun back through this script
		}

		if( IsDefined( animpos.vehiclegunner ) )
		{
			self.vehicle_pos = pos;
			self.vehicle = vehicle;
			
			self AnimCustom( ::guy_man_gunner_turret );
			//self thread guy_man_gunner_turret();
		}
		else if( isdefined( animpos.mgturret ) && !( isdefined( vehicle.script_nomg ) && vehicle.script_nomg > 0 ) )
		{
			vehicle thread guy_man_turret( self, pos ); // assumes first turret is the only turret for now
		}
 			
 		// SRS 3/25/08 added ability to specify combat getout anims on the spawner
 		if( IsDefined( self.script_combat_getout )  && self.script_combat_getout )
 		{
 			self.do_combat_getout = true;
 		}
 		
 		// HACK - setting it to 2 will use the pistol variation
 		if( IsDefined( self.script_combat_getout )  && self.script_combat_getout > 1 )
 		{
 			self.do_combat_getout = false;
 			self.do_pistol_getout = true;
 		}
 				
		//Sumeet ( 05/30/08 ) : added key to allow specifying combat_idle anims on vehicle spawners
		if( IsDefined( self.script_combat_idle )  && self.script_combat_idle )
 		{
 			self.do_combat_idle = true;
 		}
			
		// HACK - setting it to 2 will use the pistol variation
 		if( IsDefined( self.script_combat_idle )  && self.script_combat_idle > 1 )
 		{
 			self.do_combat_idle = false;
 			self.do_pistol_idle = true;
 		}
 				
		 // changes death anim based on speed of the vehicles
	}
	else
	{
		if ( isdefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
		{
			detach_models_with_substr( self, "weapon_" ); // drones shouldn't have weapon.
		}
		self.origin = org;
		self.angles = angles;
		
		if( IsDefined( animpos.vehiclegunner ) )
		{
			self.vehicle_pos = pos;
			self.vehicle = vehicle;

			self thread guy_man_gunner_turret();
		}
		else if( isdefined( animpos.mgturret ) && !( isdefined( vehicle.script_nomg ) && vehicle.script_nomg > 0 ) )
		{
			vehicle thread guy_man_turret( self, pos ); // assumes first turret is the only turret for now
		}
		
	}
	
	// reacts to groupedanimevent notify
	if( !IsDefined( animpos.vehiclegunner ) )	// these threads don't handle the gunner position yet
	{
		vehicle thread guy_handle( self, pos );
		vehicle thread guy_idle( self, pos );
	}
	else
	{
		vehicle thread guy_deathhandle( self, pos );
	}
	
	self notify( "enter_vehicle", vehicle );
	
	vehicle thread vehicle_handleunloadevent();
}

guy_array_enter( guysarray, vehicle )
{
	guysarray = maps\_vehicle::sort_by_startingpos( guysarray );

	lastguy = false;
	for( i = 0;i < guysarray.size;i ++ )
	{	
		if( !( i + 1 < guysarray.size ) )
		{
			lastguy = true;
		}
		guysarray[ i ] vehicle_enter( vehicle );
	}
}

handle_attached_guys()
{
	type = self.vehicletype;
	
	if( isdefined( self.script_vehiclewalk ) )
	{
		for( i = 0;i < 6;i ++ ) // any other number of walker tags will break this script
		{
			self.walk_tags[ i ] = ( "tag_walker" + i );
			self.walk_tags_used[ i ] = false;
		}
	}
		
	self.attachedguys = [];
	if( !( isdefined( level.vehicle_aianims ) && isdefined( level.vehicle_aianims[ type ] ) ) )
		return;
		
	maxpos = level.vehicle_aianims[ type ].size;
	
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "ai_wait_go" )
		thread ai_wait_go();
		
	self.runningtovehicle = [];
	self.usedPositions = [];
	self.getinorgs = [];
	self.delayer = 0;
	
	vehicleanim = self get_aianims();
	for( i = 0;i < maxpos;i ++ )
	{
		self.usedPositions[ i ] = false;
		if( isdefined( self.script_nomg ) && self.script_nomg && isdefined( vehicleanim[ i ].bIsgunner ) && vehicleanim[ i ].bIsgunner )
			self.usedpositions[ 1 ] = true; // if this is a gunner position and script no mg is set then don't autoassign a guy to this position
	}
}

load_ai_goddriver( array )
{
	load_ai( array, true );
}

guy_death( guy, animpos  )
{
	waittillframeend; // override _spawner set health
	guy endon ("death");
	guy.allowdeath = false;
	guy.health = 100000;
	guy endon ( "jumping_out" );
	
	while ( 1 )
	{
		guy waittill ( "damage" ); //fragile guy
		if ( !IsDefined( guy.magic_bullet_shield ) || guy.magic_bullet_shield == 0 )
		{
			thread guy_deathimate_me( guy,animpos );
			return;
		}
	}
}

guy_deathimate_me( guy,animpos )
{
	animtimer = gettime()+ ( getanimlength( animpos.death )*1000 );
	angles = guy.angles;
	origin = guy.origin;
	guy = convert_guy_to_drone( guy );
	[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
	detach_models_with_substr( guy, "weapon_" );
	guy linkto ( self, animpos.sittag, (0,0,0),(0,0,0) );
	guy notsolid();
	thread animontag( guy, animpos.sittag, animpos.death );
	if(!isdefined(animpos.death_delayed_ragdoll))
		guy waittillmatch ( "animontagdone" , "start_ragdoll" );
	else
	{
		guy unlink();
		guy startragdoll();
		wait animpos.death_delayed_ragdoll;
		guy delete();
		return;
	}
	guy unlink();
	if( GetDvar( "ragdoll_enable") == "0" )
	{
		guy delete();
		return;
	}
	
	while( gettime() < animtimer && !guy isragdoll() )
	{
		guy startragdoll();
		wait .05;
	}
	if(!guy isragdoll())
		guy delete(); // better gone than doing random crap	
	else
	{
		// OAA: failsafe for script that gets created to be deleted
		wait( 40 );
		guy delete();
	}
}

load_ai( array, bGoddriver )
{
	if(!isdefined(bGoddriver))
		bGoddriver = false;
	
	if ( !isdefined( array ) )
	{
		array = vehicle_get_riders();
	}
	
	array_ent_thread( array, ::get_in_vehicle, bGoddriver );
}

is_rider( guy )
{
	for( i = 0;i < self.riders.size;i ++ )
	{
		if( self.riders[ i ] == guy )
		{
			return true;
		}
	}
	return false;
}

vehicle_get_riders()
{
	// get the AI that are assigned to this vehicle, so either were riding in it or are riding in it
	array = [];

	ai = getaiarray( self.vteam );
	for ( i = 0;i < ai.size;i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_vehicleride ) )
			continue;
			
		if ( guy.script_vehicleride != self.script_vehicleride )
			continue;
		
		array[ array.size ] = guy;
	}

	return array;
}

get_my_vehicleride()
{
	// get the AI that are assigned to this vehicle, so either were riding in it or are riding in it
	array = [];
	
	assert( isdefined( self.script_vehicleride ), "Tried to get my ride but I have no .script_vehicleride" );

	vehicles = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		
		if ( !isdefined( vehicle.script_vehicleride ) )
			continue;
			
		if ( vehicle.script_vehicleride != self.script_vehicleride )
			continue;
		
		array[ array.size ] = vehicle;
	}

	assert( array.size == 1, "Tried to get my ride but there was zero or multiple rides to choose from" );
	return array[ 0 ];
}

get_in_vehicle( guy, bGoddriver )
{
	if ( is_rider( guy ) )
	{
		// this guy is already riding!
		return;
	}
		
	if ( !handle_detached_guys_check() )
	{
		// No more spots available!
		return;
	}
	
	assert( isalive( guy ), "tried to load a vehicle with dead guy, check your AI count to assure spawnability of ai's" );

	//TODO, next game: this is very similar to anim_reach but was done around the same time or before I knew such thing existed.  
	guy run_to_vehicle(self, bGoddriver);
}

handle_detached_guys_check()
{
	if( vehicle_hasavailablespots() )
		return true;

		assertmsg( "script sent too many ai to vehicle( max is: " + level.vehicle_aianims[ self.vehicletype ].size + " )" );
}

vehicle_hasavailablespots()
{
	 // spots available - spots being run to by ai
	 // simple check  This could get a lot more complicated
	if( level.vehicle_aianims[ self.vehicletype ].size - self.runningtovehicle.size )
		return true;
	else
		return false;
}

// AE 5-14-09: cleaned this function up and took out the guy parameter (made it self)
//				this used to be guy_runtovehicle_loaded( guy, vehicle )
run_to_vehicle_loaded( vehicle ) // self == ai
{
	vehicle endon( "death" );
	self waittill_any( "long_death", "death", "enteredvehicle" );
	ArrayRemoveValue( vehicle.runningtovehicle, self );
	if ( !vehicle.runningtovehicle.size && vehicle.riders.size && vehicle.usedpositions[0] )
	{
		vehicle notify( "loaded" );
	}
}

remove_magic_bullet_shield_from_guy_on_unload_or_death( guy ) // self == vehicle
{
	self waittill_any( "unload","death" );
	guy stop_magic_bullet_shield();
}

// AE 5-14-09: cleaned this function up and put in a special case for extra anims
//				this used to be guy_runtovehicle( guy, vehicle, bGoddriver )
// AE 7-21-09: added the new seat_tag parameter to allow us to tell the AI where to go easier
run_to_vehicle( vehicle, bGodDriver, seat_tag ) // self == ai
{
	if(!isdefined(bGodDriver))
	{
		bGodDriver = false;
	}

	// get the vehicle ai anims
	vehicleanim = vehicle get_aianims();
	
	// check for a run to vehicle override function
	if( isdefined( vehicle.runtovehicleoverride ) )
	{
		vehicle thread [[ vehicle.runtovehicleoverride ]]( self );
		return;
	}

	vehicle endon( "death" );
	self endon( "death" );
	
	// put the guy into the running to vehicle array
	vehicle.runningtovehicle[ vehicle.runningtovehicle.size ] = self;

	// this function call will wait for the guy to be loaded and take him out of the running to vehicle array
	self thread run_to_vehicle_loaded( vehicle );

	availablepositions = [];
	chosenorg = undefined;
	origin = 0;
	
	// check for get in animations and simply stuff the guy into the vehicle if non exist
	bIsgettin = false;
	for( i = 0; i < vehicleanim.size; i++ )
	{
		if( isdefined( vehicleanim[ i ].getin ) )
		{
			bIsgettin = true;
			
			// AE 5-14-09: no need to stay in this loop once we hit this once, added the break
			break;
		}
	}

	// if there's no get in anim, we stuff him in anyways ... if we don't have to load animations for this
	if( !bIsgettin )
	{
		self notify( "enteredvehicle" );
		self enter_vehicle(  vehicle );
		return;
	}
	
	// wait for the vehicle to stop
	while( vehicle getspeedmph() > 1 )
	{
		wait .05;
	}

	// get the available positions on the vehicle
	positions = vehicle get_availablepositions();
	
	// check for driver
	if( !vehicle.usedPositions[ 0 ] )
	{
		chosenorg = vehicle vehicle_getInstart( 0 );  // driver first!
		if( bGoddriver )
		{
			assert( !isdefined(self.magic_bullet_shield), "magic_bullet_shield guy told to god mode drive a vehicle, you should simply load_ai without the god function for this guy");
			self thread magic_bullet_shield();
			vehicle thread remove_magic_bullet_shield_from_guy_on_unload_or_death( self );
		}
	}
	// Alex Liu (12-2-08): Fix a bug so the AIs will use pre-defined starting positions when running to vehicle
	else if( isdefined( self.script_startingposition ) )
	{
		position_valid = -1;
		for( i = 0; i < positions.availablepositions.size; i++ )
		{	
			if( positions.availablepositions[i].pos == self.script_startingposition )
			{
				position_valid = i;
			}
		}

		if( position_valid > -1 )
		{
			chosenorg = positions.availablepositions[position_valid];
		}
		else
		{
			if( positions.availablepositions.size )
			{
				chosenorg = getclosest( self.origin, positions.availablepositions );
			}
			else
			{
				chosenorg = undefined;
			}
		}
	}
	// AE 7-21-09: expanded on what Alex is doing with script_startingposition
	//	this will allow you to pass in where you want them to go, if they don't have script_startingposition
	else if( IsDefined(seat_tag))
	{
		// cross reference the seat tag to get the pos number
		for(i = 0; i < vehicleanim.size; i++)
		{
			if(vehicleanim[i].sittag == seat_tag)
			{
				// make sure it's available
				for(j = 0; j < positions.availablepositions.size; j++)
				{	
					if(positions.availablepositions[j].pos == i)
					{
						chosenorg = positions.availablepositions[j];
						break;
					}
				}
				break;
			}
		}
	}
	else if( positions.availablepositions.size )
	{
		// if there are available positions, get the closest to the guy
		chosenorg = getclosest( self.origin, positions.availablepositions );
	}
	else
	{
		// there are no available positions
		chosenorg = undefined;
	}
	
	// if there are no available positions but there are non animated positions, we stuff him in
	if( ( !positions.availablepositions.size ) && ( positions.nonanimatedpositions.size ) )
	{
		self notify( "enteredvehicle" );
		self enter_vehicle(  vehicle );
		return;		
	}		
	else if( !isdefined( chosenorg ) )
	{
		return; // nothing available
	}
			
	self.forced_startingposition = chosenorg.pos;
	 // flag it so no others use it
	vehicle.usedpositions[ chosenorg.pos ] = true;

	// short circuit any _spawner auto destination behavior
	self.script_moveoverride = true;
	self notify( "stop_going_to_node" );
	
	// AE 5-15-09: if there is a waiting anim then we need to play it
	//	the ai is waiting for the player to enter the vehicle
	// AE 7-20-09: added more functionality
	//	there are functions to call before this to set variables (so this isn't always on)
	if(IsDefined(vehicleanim[ chosenorg.pos ].wait_for_notify))
	{
		// make sure there is an animation
		if(IsDefined(vehicleanim[ chosenorg.pos ].waiting))
		{
			// send the ai close to the position
			self set_forcegoal();
			self.goalradius = 64;
			self setgoalpos( chosenorg.origin );
			self waittill( "goal" );
			self unset_forcegoal();

			// now play the waiting anim until the player(s) get on
			self AnimScripted("anim_wait_done", self.origin, self.angles, vehicleanim[ chosenorg.pos ].waiting);
			vehicle waittill( vehicleanim[ chosenorg.pos ].wait_for_notify );
		}
	}
	else if(IsDefined(vehicleanim[ chosenorg.pos ].wait_for_player))
	{
		// make sure there is an animation
		if(IsDefined(vehicleanim[ chosenorg.pos ].waiting))
		{
			// send the ai close to the position
			self set_forcegoal();
			self.goalradius = 64;
			self setgoalpos( chosenorg.origin );
			self waittill( "goal" );
			self unset_forcegoal();

			// now play the waiting anim until the player(s) get on
			self AnimScripted("anim_wait_done", self.origin, self.angles, vehicleanim[ chosenorg.pos ].waiting);
			while(true)
			{
				on_vehicle = 0;
				for(i = 0; i < vehicleanim[ chosenorg.pos ].wait_for_player.size; i++)
				{
					if(vehicleanim[ chosenorg.pos ].wait_for_player[i] is_on_vehicle(vehicle))
					{
						on_vehicle++;
					}
				}

				if(on_vehicle == vehicleanim[ chosenorg.pos ].wait_for_player.size)
				{
					break;
				}

				wait(0.05);
			}
		}
	}

	self set_forcegoal();
	self.goalradius = 16;
	self setgoalpos( chosenorg.origin );
	self waittill( "goal" );
	self unset_forcegoal();
	
	self.allowdeath = false;  // they will get the allowdeath back when they get out or get it turned on if there is a death animation.

	if( isdefined( chosenorg ) )
	{
		if( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinanim ) )
		{
			vehicle = vehicle getanimatemodel();
			vehicle thread setanimrestart_once( vehicleanim[ chosenorg.pos ].vehicle_getinanim, vehicleanim[ chosenorg.pos ].vehicle_getinanim_clear );
		}
		
		if( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsoundtag ) )
		{
			origin = vehicle gettagorigin( vehicleanim[ chosenorg.pos ].vehicle_getinsoundtag );
		}
		else 
		{
			origin = vehicle.origin;
		}

		if( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsound ) )
		{
			sound = vehicleanim[ chosenorg.pos ].vehicle_getinsound;
		}
		else
		{
			sound = "veh_truck_door_open";
		}

		vehicle thread maps\_utility::play_sound_in_space( sound, origin );
		
//		if ( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsound ) )
//		{
//			animatemodel = vehicle getanimatemodel();
//			animatemodel thread play_sound_on_entity( vehicleanim[ chosenorg.pos ].vehicle_getinsound );
//		}
		vehicle animontag( self, vehicleanim[ chosenorg.pos ].sittag, vehicleanim[ chosenorg.pos ].getin );
	}
	self notify( "enteredvehicle" );
	self enter_vehicle(  vehicle );
}

anim_pos( vehicle, pos )
{
	return( vehicle get_aianims()[ pos ]);
}

anim_pos_from_tag(vehicle, tag)
{
	vehicleanims = level.vehicle_aianims[ vehicle.vehicletype ];

	keys = GetArrayKeys(vehicleanims);
	for (i = 0; i < keys.size; i++)
	{
		pos = keys[i];
		if (IsDefined(vehicleanims[pos].sittag) && vehicleanims[pos].sittag == tag)
		{
			return pos;
		}
	}
}

guy_deathhandle( guy, pos )
{
// 	self endon( "death" );
	guy waittill( "death" );
	if ( !isdefined( self ) )
		return;
	ArrayRemoveValue( self.riders, guy );
	self.usedPositions[ pos ] = false;	
}

setup_aianimthreads()
{
	if( !isdefined( level.vehicle_aianimthread ) )
		level.vehicle_aianimthread = [];
		
	if ( !isdefined( level.vehicle_aianimcheck ) )
		level.vehicle_aianimcheck = [];
		
	level.vehicle_aianimthread[ "idle" ] = ::guy_idle;
	level.vehicle_aianimthread[ "duck" ] = ::guy_duck;
	
	level.vehicle_aianimthread[ "duck_once" ] = ::guy_duck_once;
	level.vehicle_aianimcheck[ "duck_once" ] = ::guy_duck_once_check;

	level.vehicle_aianimthread[ "weave" ] = ::guy_weave;
	level.vehicle_aianimcheck[ "weave" ] = ::guy_weave_check;
	
	level.vehicle_aianimthread[ "stand" ] = ::guy_stand;

	level.vehicle_aianimthread[ "turn_right" ] = ::guy_turn_right;
	level.vehicle_aianimcheck[ "turn_right" ] = ::guy_turn_right_check;
	
	level.vehicle_aianimthread[ "turn_left" ] = ::guy_turn_left;
	level.vehicle_aianimcheck[ "turn_left" ] = ::guy_turn_right_check;
	
	level.vehicle_aianimthread[ "turn_hardright" ] = ::guy_turn_hardright;

	level.vehicle_aianimthread[ "turn_hardleft" ] = ::guy_turn_hardleft;
	level.vehicle_aianimthread[ "turret_fire" ] = ::guy_turret_fire;
	level.vehicle_aianimthread[ "turret_turnleft" ] = ::guy_turret_turnleft;
	level.vehicle_aianimthread[ "turret_turnright" ] = ::guy_turret_turnright;
	level.vehicle_aianimthread[ "unload" ] = ::guy_unload;
	level.vehicle_aianimthread[ "reaction" ] = ::guy_turret_turnright;

	// Added drive reaction and death_fire anim threads (Alex Liu 6-1-08)
	level.vehicle_aianimthread[ "drive_reaction" ] = ::guy_drive_reaction;
	level.vehicle_aianimcheck[ "drive_reaction" ] = ::guy_drive_reaction_check;
	level.vehicle_aianimthread[ "death_fire" ] = ::guy_death_fire;
	level.vehicle_aianimcheck[ "death_fire" ] = ::guy_death_fire_check;

	// AE 2-17-09: added animations for moving into the driver seat
	level.vehicle_aianimthread["move_to_driver"] = ::guy_move_to_driver;
}

guy_handle( guy, pos )
{
	
	guy.vehicle_idling = true;
	guy.queued_anim_threads = [];
	thread guy_deathhandle( guy, pos );
	thread guy_queue_anim( guy, pos );
	guy endon( "death" );
	guy endon( "jumpedout" );
	while( 1 )
	{
		//TODO NEXT GAME.. This shouldn't wait, should be a function but will likely be rewritten anyway to follow the anim_single conventions
		self waittill( "groupedanimevent", other );
		if ( isdefined( level.vehicle_aianimcheck[ other ] ) && ! [[ level.vehicle_aianimcheck[ other ] ]]( guy, pos ) )
			continue;// ignore this if they have a check function and this anim doesn't exist
			
		if ( isdefined( self.groupedanim_pos ) )
		{
			if(pos != self.groupedanim_pos)
				continue;
			waittillframeend;
			self.groupedanim_pos = undefined; // set before the groupedanimevent call.
		}

		if( isdefined( level.vehicle_aianimthread[ other ] ) )
		{
			if ( isdefined( self.queueanim ) && self.queueanim )
			{
				add_anim_queue( guy, level.vehicle_aianimthread[ other ] );
				waittillframeend;// allows all of the guys to queue their anims if necessary.
				self.queueanim = false;
			}
			else
			{
				guy notify( "newanim" );
				guy.queued_anim_threads = [];// sorry que, this animation is more important.
				thread [[ level.vehicle_aianimthread[ other ] ]]( guy, pos );
			}
		}
		else
		{
			/#println( "leaaaaaaaaaaaaaak", other );#/
		}
	}
}


// attempt at fixing pops by using a que. I tried this once in CoD1 once, maybe I can make it work now.
add_anim_queue( guy, sthread )
{
	guy.queued_anim_threads[ guy.queued_anim_threads.size ] = sthread;
	 
}

guy_queue_anim( guy, pos )
{
	guy endon( "death" );
	self endon( "death" );
	lastanimframe = gettime() - 100;
	while ( 1 )
	{
		if ( guy.queued_anim_threads.size )
		{
			if ( gettime() != lastanimframe )
				guy waittill( "anim_on_tag_done" );
			if ( !guy.queued_anim_threads.size )
				continue;// there has been an interuption
			guy notify( "newanim" );
			thread [[ guy.queued_anim_threads[ 0 ] ]]( guy, pos );
			ArrayRemoveValue( guy.queued_anim_threads, guy.queued_anim_threads[ 0 ] );
			wait .05;
		}
		else
		{
// 			wait .05;// maybe wait on some notify.
			guy waittill( "anim_on_tag_done" );
			lastanimframe = gettime();
		}
	}
	
}

// old kubelwagons..
guy_stand( guy, pos )
{
	animpos = anim_pos( self, pos );
	vehicleanim = self get_aianims();
	if( !isdefined( animpos.standup ) )
		return;
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animontag( guy, animpos.sittag, animpos.standup );
	guy_stand_attack( guy, pos );
}

guy_stand_attack( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	guy.standing = 1;
	while( 1 )
	{
		timer2 = gettime() + 2000;
		while( gettime() < timer2 && isdefined( guy.enemy ) )
			animontag( guy, animpos.sittag, guy.vehicle_standattack, undefined, undefined, "firing" );
		rnum = randomint( 5 ) + 10;
		for( i = 0;i < rnum;i ++ )
			animontag( guy, animpos.sittag, animpos.standidle );
	}
}

guy_stand_down( guy, pos )
{
	animpos = anim_pos( self, pos );
	if( !isdefined( animpos.standdown ) )
	{
		thread guy_stand_attack( guy, pos );
		return;
	}
	animontag( guy, animpos.sittag, animpos.standdown );
	guy.standing = 0;
	thread guy_idle( guy, pos );
}

driver_idle_speed( driver, pos )
{
	driver endon( "newanim" );
	self endon( "death" );
	driver endon( "death" );

	animpos = anim_pos( self, pos );
	while( 1 )
	{
		if( self getspeedmph() == 0 )
			driver.vehicle_idle = animpos.idle_animstop;
		else
			driver.vehicle_idle = animpos.idle_anim;
		wait .25;	
	}	
}

guy_reaction( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	if( isdefined( animpos.reaction ) )
		animontag( guy, animpos.sittag, animpos.reaction );
	thread guy_idle( guy, pos );
}

guy_turret_turnleft( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	while( 1 )
		animontag( guy, animpos.sittag, guy.turret_turnleft );
}

guy_turret_turnright( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	while( 1 )
		animontag( guy, animpos.sittag, guy.turret_turnleft );
}

guy_turret_fire( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	if( isdefined( animpos.turret_fire ) )
		animontag( guy, animpos.sittag, animpos.turret_fire );
	thread guy_idle( guy, pos );
}

guy_idle( guy, pos, ignoredeath )
{
	guy endon( "newanim" );
	if( !isdefined(ignoredeath))
	self endon( "death" );
	guy endon( "death" );
	guy.vehicle_idling = true;
	guy notify( "gotime" );

	if( !isdefined( guy.vehicle_idle ) )
	{
//		if ( isdefined( level.whackamolethread ) )
//			thread [[ level.whackamolethread ]]( guy );
		return; // truck guys just stand there linked.. hack for Halftrack guys
	}
	animpos = anim_pos( self, pos );
	if( isdefined( animpos.mgturret ) )
		return; // mggunners don't idle.
	if ( isdefined( animpos.hideidle ) && animpos.hideidle )
		guy hide();
	if( isdefined( animpos.idle_animstop ) && isdefined( animpos.idle_anim ) )  // idle alternates between stopping and going
		thread driver_idle_speed( guy, pos );
	while( 1 )
	{
		guy notify( "idle" );
		if( isdefined( guy.vehicle_idle_override ) )
			animontag( guy, animpos.sittag, guy.vehicle_idle_override );
		else if( isdefined( animpos.idleoccurrence ) )  // kubelwagons have random idles like guy driver pointing forward
		{
			theanim = randomoccurrance( guy, animpos.idleoccurrence );
			animontag( guy, animpos.sittag, guy.vehicle_idle[ theanim ] );
		}
		else if( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_idle ) )
			animontag( guy, animpos.sittag, animpos.player_idle );
		else	 // jeeps just have one idle
		{
			// animate the vehicle with this guy.( IE: driver with stearing wheel )
			if ( isdefined( animpos.vehicle_idle ) )
				self thread setanimrestart_once( animpos.vehicle_idle );
		
			//Sumeet ( 05/30/08 ) : added key to allow specifying combat_idle anims on vehicle spawners
			if( IsDefined( guy ) )
			if ( isdefined( guy.do_combat_idle ) && guy.do_combat_idle && isdefined( guy.vehicle_idle_combat ) )
			{
				animontag( guy, animpos.sittag, guy.vehicle_idle_combat );
			}
			else if( IS_TRUE( guy.do_pistol_idle ) && isdefined( guy.vehicle_idle_pistol ) )
			{
				animontag( guy, animpos.sittag, guy.vehicle_idle_pistol );
			}
			else
			{					
				animontag( guy, animpos.sittag, guy.vehicle_idle );
			}
		}
	}
}

randomoccurrance( guy, occurrences )
{
	range = [];
	totaloccurrance = 0;
	for( i = 0;i < occurrences.size;i ++ )
	{
		totaloccurrance += occurrences[ i ];
		range[ i ] = totaloccurrance;
	}
	pick = randomint( totaloccurrance );
	for( i = 0;i < occurrences.size;i ++ )
		if( pick < range[ i ] )
			return i;
}


guy_duck_once_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).duck_once );
}

guy_duck_once( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.duck_once ) )
	{
		if ( isdefined( animpos.vehicle_duck_once ) )
			self thread setanimrestart_once( animpos.vehicle_duck_once );
		animontag( guy, animpos.sittag, animpos.duck_once );
	}
	thread guy_idle( guy, pos );
}

guy_weave_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).weave );
}

guy_weave( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.weave ) )
	{
		if ( isdefined( animpos.vehicle_weave ) )
			self thread setanimrestart_once( animpos.vehicle_weave );
		animontag( guy, animpos.sittag, animpos.weave );
	}
	thread guy_idle( guy, pos );
}

guy_duck( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	if( isdefined( animpos.duckin ) )
		animontag( guy, animpos.sittag, animpos.duckin );
	thread guy_duck_idle( guy, pos );
}

guy_duck_idle( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	theanim = randomoccurrance( guy, animpos.duckidleoccurrence );
	while( 1 )
		animontag( guy, animpos.sittag, animpos.duckidle[ theanim ] );
}

guy_duck_out( guy, pos )
{
	animpos = anim_pos( self, pos );
	if( isdefined( animpos.ducking ) && guy.ducking )
	{
		animontag( guy, animpos.sittag, animpos.duckout );
		guy.ducking = false;
	}
	thread guy_idle( guy, pos );
}

guy_unload_que( guy )
{
	self endon( "death" );
	ARRAY_ADD( self.unloadque, guy );
	guy waittill_any( "death", "jumpedout" );
	ArrayRemoveValue( self.unloadque, guy );
	if( !self.unloadque.size )
	{
		self notify( "unloaded" );
		self.unload_group = "default";
	}
}

riders_unloadable( unload_group )
{
	if( ! self.riders.size )
		return false;
	for ( i = 0; i < self.riders.size; i++ )
	{
		assert( isdefined( self.riders[i].pos ) );
		if( check_unloadgroup( self.riders[i].pos, unload_group ) )
			return true;
	}
	return false;
}


check_unloadgroup( pos, unload_group )
{
	if( ! isdefined( unload_group ) )
		unload_group = self.unload_group;
		
	type = self.vehicletype;
	if( !isdefined( level.vehicle_unloadgroups[ type ] ) )
		return true; // just unloads everybody 
		
	if ( !isdefined( level.vehicle_unloadgroups[ type ][ unload_group ] ) )
	{
		/#
		println( "Invalid Unload group on node at origin: " + self.currentnode.origin + " with group:( \"" + unload_group + "\" )" );
		println( "Unloading everybody" );
		#/
		return true;
	}

	group = level.vehicle_unloadgroups[ type ][ unload_group ];
	for( i = 0;i < group.size;i ++ )
		if( pos == group[ i ] )
			return true;
	return false;
}


getoutrig_model_idle( model, tag, animation )
{
	self endon( "unload" );
	while( 1 )
	{
		animontag( model, tag, animation );
	}
}

getoutrig_model( animpos, model, tag, animation, bIdletillunload )
{
	type = self.vehicletype;
	if( bIdletillunload )
	{
		thread getoutrig_model_idle( model, tag , level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].idleanim );
		self waittill( "unload" );
	}
		
	ARRAY_ADD( self.unloadque, model );
	
	self thread getoutrig_abort( model, tag, animation );
	
	if ( !isdefined( self.crashing ) )
		animontag( model, tag, animation );

	model unlink();
	
	// looks like somebody deleted the helicopter while that animation was playing.  and errored so I'm throwing in this defensive fix!.
	if( !isdefined( self ) )
	{
		model delete();
		return;
	}
	
	assert( isdefined( self.unloadque ) );
	
	ArrayRemoveValue( self.unloadque, model );
	if ( !self.unloadque.size )
		self notify( "unloaded" );
	
	self.getoutrig[ animpos.getoutrig ] = undefined;
		wait 10;
	model delete();  // possibly do something to delete when the player is not looking at it.	
}
		
getoutrig_disable_abort_notify_after_riders_out()
{
	wait .05;
	while( isalive( self ) && self.unloadque.size > 2 )
		wait .05; // 1 unloadque will be there for the rope.
	if( ! isalive( self ) || ( isdefined(self.crashing) && self.crashing ) )
		return;
	self notify ( "getoutrig_disable_abort" );
}


getoutrig_abort_while_deploying()
{
	self endon ("end_getoutrig_abort_while_deploying");
	while ( !isdefined( self.crashing ) )
		wait 0.05;
	array_delete( self.riders );
	self notify ("crashed_while_deploying");
}


getoutrig_abort( model, tag, animation )
{

	totalAnimTime = getanimlength( animation );
	ropesFallAnimTime = totalAnimTime - 1.0;
	if(self.vehicletype == "mi17")
		ropesFallAnimTime = totalAnimTime - .5; //go go ghetto numbers
		
	const ropesDeployedAnimTime = 2.5;
	
	assert( totalAnimTime > ropesDeployedAnimTime );
	assert( ropesFallAnimTime - ropesDeployedAnimTime > 0 );
	
	self endon( "getoutrig_disable_abort" );
	
	thread getoutrig_disable_abort_notify_after_riders_out();
//	self thread notify_delay( "getoutrig_disable_abort", ropesFallAnimTime - ropesDeployedAnimTime );

	thread 	getoutrig_abort_while_deploying();
	
	waittill_notify_or_timeout( "crashed_while_deploying" , ropesDeployedAnimTime );
	
	self notify ("end_getoutrig_abort_while_deploying");
	
	// ropes are deployed, wait for a chopper death if it isn't dead already
	while ( !isdefined( self.crashing ) )
		wait 0.05;
	
	// make the rope fall by jumping to the end of it's animation where it falls
	thread animontag( model, tag, animation );
	waittillframeend;
	model setanimtime( animation, ropesFallAnimTime / totalAnimTime );
	
	// all the guys on the rope must fall off too
	for ( i = 0 ; i < self.riders.size ; i++ )
	{
		if ( !isdefined( self.riders[ i ] ) )
			continue;
		if ( !isdefined( self.riders[ i ].ragdoll_getout_death ) )
			continue;
		if ( self.riders[ i ].ragdoll_getout_death != 1 )
			continue;
		if ( !isdefined( self.riders[ i ].ridingvehicle ) )
			continue;
		// thread animontag_ragdoll_death( self.riders[ i ] );
		self.riders[i] damage_notify_wrapper( 100, self.riders[i].ridingvehicle );
	}
}

setanimrestart_once( vehicle_anim, bClearAnim )
{
	self endon( "death" );
	self endon( "dont_clear_anim" );
	if ( !isdefined( bClearAnim ) )
		bClearAnim = true;
	cycletime = getanimlength( vehicle_anim );
	self SetAnimRestart( vehicle_anim );
	wait cycletime;
	if ( bClearAnim )
	self clearanim( vehicle_anim, 0 );
}


getout_rigspawn( animatemodel, pos , bIdletillunload )
{
	if( !isdefined( bIdletillunload ) )
		bIdletillunload = true;
	
	type = self.vehicletype;
	animpos = anim_pos( self, pos );
			
	if ( isdefined( self.attach_model_override ) && isdefined( self.attach_model_override[ animpos.getoutrig ] ) )
		overrridegetoutrig = true;
	else
		overrridegetoutrig = false;
	
	if ( !isdefined( animpos.getoutrig ) || isdefined( self.getoutrig[ animpos.getoutrig ] ) || overrridegetoutrig )
		return; // already one in place
	
	origin =  animatemodel gettagorigin( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag );
	angles =  animatemodel gettagangles( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag );

	self.getoutriganimating[ animpos.getoutrig ] = true;

	getoutrig_model = spawn( "script_model", origin );
	getoutrig_model.angles = angles;
	getoutrig_model.origin = origin;
	getoutrig_model setmodel( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].model );

	self.getoutrig[ animpos.getoutrig ] = getoutrig_model;// flag this model as out
	                                        
	getoutrig_model UseAnimTree( #animtree );
//	getoutrig_model UseAnimTree( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].animtree );
	
	getoutrig_model SetForceNoCull();

	getoutrig_model linkto( animatemodel, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );								
	thread getoutrig_model( animpos, getoutrig_model, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag , 
	                        						  level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].dropanim, 
	                        						  bIdletillunload													  
						  );
	return getoutrig_model;
}

check_sound_tag_dupe( soundtag )
{
	// long day. this is probably 10 times more complicated than it needs to be.
	
	if( !isdefined( self.sound_tag_dupe ) )
		self.sound_tag_dupe = [];
		
	duped = false;
	
	if( !isdefined( self.sound_tag_dupe[ soundtag ] ) )
		self.sound_tag_dupe[ soundtag ] = true;
	else
		duped = true;
	
	thread check_sound_tag_dupe_reset( soundtag );
	
	return duped;
}

check_sound_tag_dupe_reset( soundtag )
{
	wait .05;
	if( ! isdefined( self ) )
		return;
	self.sound_tag_dupe[ soundtag ] = false;
	
	keys = getarraykeys(self.sound_tag_dupe);
	
	for ( i = 0; i < keys.size; i++ )
		if( self.sound_tag_dupe[ keys[i] ] )
			return;
			
	self.sound_tag_dupe = undefined;
	
}



guy_unload( guy, pos )
{
	animpos = anim_pos( self, pos );
	type = self.vehicletype;
	
	// check to see if this guy is in the unload group if not then go to idle and ignore the unload call
	if( !check_unloadgroup( pos ) )
	{
		 thread guy_idle( guy, pos );
		 return;
	}
	
	// no getout for this guy.
	if ( !isdefined( animpos.getout ) )
	{
		thread guy_idle( guy, pos );
		return;
	}
	
	if ( isdefined( animpos.hideidle ) && animpos.hideidle )
	{
		guy show();// bleh. hacking out nonexitant idle animations on seaknight
	}
	
	self thread guy_unload_que( guy );
	
	self endon( "death" );
	
	if ( IsAI( guy ) && IsAlive( guy ) )
	{
		guy endon( "death" );
	}
	
	animatemodel = getanimatemodel();
	

	if( IsDefined( self.script_combat_getout ) && self.script_combat_getout > 1 )
	{
		if ( IsDefined( animpos.vehicle_getoutanim_pistol ) )
		{		
			animatemodel thread setanimrestart_once( animpos.vehicle_getoutanim_pistol, animpos.vehicle_getoutanim_clear );
			self notify( "open_door_climbout" );
			sound_tag_dupped = false;
	
			if ( IsDefined( animpos.vehicle_getoutsoundtag ) )
			{
				sound_tag_dupped = check_sound_tag_dupe( animpos.vehicle_getoutsoundtag );
				origin = animatemodel gettagorigin( animpos.vehicle_getoutsoundtag );
			}
			else
			{
				origin = animatemodel.origin;
			}
			
			sound = ( IsDefined( animpos.vehicle_getoutsound ) ? animpos.vehicle_getoutsound : "veh_truck_door_open" );
			
			if ( !sound_tag_dupped )
			{
				self thread maps\_utility::play_sound_in_space( sound, origin );
			}
		
			sound_tag_dupped = undefined;
		}
	}
	else if ( IsDefined( animpos.vehicle_getoutanim ) )
	{		
		animatemodel thread setanimrestart_once( animpos.vehicle_getoutanim, animpos.vehicle_getoutanim_clear );
		self notify( "open_door_climbout" );
		sound_tag_dupped = false;

		if ( IsDefined( animpos.vehicle_getoutsoundtag ) )
		{
			sound_tag_dupped = check_sound_tag_dupe( animpos.vehicle_getoutsoundtag );
			origin = animatemodel gettagorigin( animpos.vehicle_getoutsoundtag );
		}
		else
		{
			origin = animatemodel.origin;
		}
		
		sound = ( IsDefined( animpos.vehicle_getoutsound ) ? animpos.vehicle_getoutsound : "veh_truck_door_open" );
		
		if ( !sound_tag_dupped )
		{
			self thread maps\_utility::play_sound_in_space( sound, origin );
		}
		
		sound_tag_dupped = undefined;
	}
	
	delay = 0;
	
	if ( IsDefined( animpos.getout_timed_anim ) )
	{
		delay += getanimlength( animpos.getout_timed_anim );
	}
	
	if ( IsDefined( animpos.delay ) )
	{
		delay += animpos.delay;
	}
	
	if ( IsDefined( guy.delay ) )
	{
		delay += guy.delay;
	}
	
	if ( delay > 0 )
	{
		thread guy_idle( guy, pos );
		wait delay;
	}
	
	 // handle those guys who are standing when a vehicle unloads
	hascombatjumpout = IsDefined( animpos.getout_combat );
	hasPistolJumpout = IsDefined( animpos.getout_pistol );
	if( !hascombatjumpout && guy.standing )
	{
		guy_stand_down( guy, pos );
	}
	else if ( !hascombatjumpout && !guy.vehicle_idling && isdefined( guy.vehicle_idle ) )
	{
		guy waittill( "idle" );
	}
		
	guy.deathanim = undefined;
	
	guy notify( "newanim" );
	
	if ( IsAI( guy ) )
	{
		guy pushplayer( true );
	}

	 // some vehicles don't require an unload animation like the flak88 where all the guys are animating on the ground
	 // some guys don't unload at all and stick to the vehicle till death!
	
	bNoanimUnload = false;
	if ( IsDefined( animpos.bNoanimUnload ) )
	{
		bNoanimUnload = true;
	}
	else if ( !IsDefined( animpos.getout ) || 
				( !IsDefined( self.script_unloadmgguy ) && ( IsDefined( animpos.bIsgunner ) && animpos.bIsgunner ) ) || 
				IsDefined( self.script_keepdriver ) && pos == 0 )
	{
		self thread guy_idle( guy, pos );
		return;
	}
	
	if ( guy should_give_orghealth() )
	{
		guy.health = guy.orghealth;
	}

	guy.orghealth = undefined;
	if ( IsAI( guy ) && IsAlive( guy ) )
	{
		guy endon( "death" );
	}

	guy.allowdeath = false;// nobody should die during the transition
	
	 // some exits all happen at a special tag the halftrack guys all use the same tag to exit but a different tag to sit at.
	if ( isdefined( animpos.exittag ) )
	{
		tag = animpos.exittag;
	}
	else
	{
		tag = animpos.sittag;
	}
		
	if ( hascombatjumpout && guy.standing )
	{
		animation = animpos.getout_combat;
	}
	else if ( hascombatjumpout && IsDefined( guy.do_combat_getout ) && ( guy.do_combat_getout ))
	{
		animation = animpos.getout_combat;
	}
	else if ( hasPistolJumpout && IS_TRUE( guy.do_pistol_getout ) )
	{
		animation = animpos.getout_pistol;
	}
	else if ( IsDefined( guy.get_out_override ) )
	{
		animation = guy.get_out_override;
	}
	else if( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout ) )
	{
		animation = animpos.player_getout;
	}
	else
	{
		animation = animpos.getout;
	}
	
	_vehicle_turret_clear_user( guy, animpos.sittag );
	
	if ( !bNoanimUnload )
	{
		self thread guy_unlink_on_death( guy );
		
		 // throw out the rope before unloading
		if ( IsDefined( animpos.getoutrig ) )
		{
			if ( !IsDefined( self.getoutrig[ animpos.getoutrig ] ) )
			{
				thread guy_idle( guy, pos ); // idle while rope is deploying
				getoutrig_model = self getout_rigspawn( animatemodel, guy.pos, false );
				 // animontag( getoutrig_model, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag , level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].idleanim );
			}			
		}

		if ( IsDefined( animpos.getoutsnd ) )
		{
			guy thread play_sound_on_tag( animpos.getoutsnd, "J_Wrist_RI", true );
		}
	
		if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound ) )
		{
			guy thread play_sound_on_entity( animpos.player_getout_sound );
		}

		if ( IsDefined( animpos.getoutloopsnd ) )
		{
			guy thread play_loop_sound_on_tag( animpos.getoutloopsnd );
		}

		if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_loop ) )
		{
			get_players()[0] thread play_loop_sound_on_entity( animpos.player_getout_sound_loop );
		}

		guy notify( "newanim" );
		guy notify( "jumping_out");
		
		if ( IS_HELICOPTER( guy.ridingvehicle ) )
		{
			guy.b_rappelling = true;
		}
		
		// testing, default to this while unloading. should fix drones that die on an exploding vehicle.
		guy.ragdoll_getout_death = true;
		
		if ( IsDefined( animpos.ragdoll_getout_death ) )
		{
			guy.ragdoll_getout_death = true;
			if ( IsDefined( animpos.ragdoll_fall_anim ) )
			{
				guy.ragdoll_fall_anim = animpos.ragdoll_fall_anim;
			}
		}
		
		animontag( guy, tag, animation );
		//this is for a secondary bm21 exit animation
		if ( IsDefined( animpos.getout_secondary ) )
		{
			secondaryunloadtag = tag;
			if ( IsDefined( animpos.getout_secondary_tag ) )
			{
				secondaryunloadtag = animpos.getout_secondary_tag;
			}
			
			animontag( guy, secondaryunloadtag, animpos.getout_secondary);
		}
		
		 // end all the loop sounds
		if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_loop ) )
		{
			get_players()[0] thread stop_loop_sound_on_entity( animpos.player_getout_sound_loop );
		}

		if ( IsDefined( animpos.getoutloopsnd ) )
		{
			guy thread stop_loop_sound_on_entity( animpos.getoutloopsnd );
		}

		if ( IsDefined( guy.playerpiggyback ) && IsDefined( animpos.player_getout_sound_end ) )
		{
			get_players()[0] thread play_sound_on_entity( animpos.player_getout_sound_end );
		}
	}
	
	ArrayRemoveValue( self.riders, guy );
	self.usedPositions[ pos ] = false;
	guy.ridingvehicle = undefined;
	guy.drivingVehicle = undefined;
	
	guy notify( "exit_vehicle" );
	guy.b_rappelling = false;
	
	if ( !IsAlive( self ) && !IsDefined( animpos.unload_ondeath ) )
	{
		guy Delete();
		return;
	}

	guy Unlink();
	if ( !IsDefined( guy.magic_bullet_shield ) )
	{
		guy.allowdeath = true;// nobody should die during the transition
	}
	
	if ( !IsAI( guy ) ) 
	{
		// drones have to delete for now
		guy Delete();
		return;
	}
	else
	{
		if ( IS_EQUAL( guy.script_noteworthy, "delete_on_unload" ) )
		{
			guy Delete();
			return;
		}
	}
	
	if ( IS_TRUE( animpos.getout_delete ) )
	{
		guy delete();
		return;	
	}	
	
	if ( IsAlive( guy ) )
	{
		guy.a.disablelongdeath = false;
		guy.forced_startingposition = undefined;
		guy notify( "jumpedout" );
//		guy unlink();
		
		if ( IsDefined( animpos.getoutstance ) )
		{
			guy.desired_anim_pose = animpos.getoutstance;	
			guy AllowedStances( "crouch" );
			guy thread animscripts\utility::UpdateAnimPose();
			guy AllowedStances( "stand", "crouch", "prone" );
		}

		guy PushPlayer( false );
		
		// if he doesn't target a node make his new goal position his current position
		qSetGoalPos = false;

		if ( guy has_color() )
		{
			qSetGoalPos = false;
		}
		else if ( !IsDefined( guy.target ) && !IsDefined( guy.script_spawner_targets ) )
		{
			qSetGoalPos = true;
		}
		else if ( !IsDefined( guy.script_spawner_targets ) )
		{
			// change to support script_origins or make mymapents update nodes
			targetedNodes = getNodeArray( guy.target, "targetname" );
			
			if ( targetedNodes.size == 0 )
			{
				qSetGoalPos = true;
			}
		}
		
		if ( qSetGoalPos )
		{
			if ( !IsDefined( guy.script_goalradius ) )
			{
				guy.goalradius = 600;
			}

			guy SetGoalPos( guy.origin );
		}
	}
}

animontag( guy, tag , animation, notetracks, sthreads, flag )
{
	guy notify( "animontag_thread" );
	guy endon( "animontag_thread" );
	
	if( !isdefined( flag ) )
		flag = "animontagdone";
	
	if( isdefined( self.modeldummy ) )
		animatemodel = self.modeldummy;
	else
		animatemodel = self;
	if( !isdefined( tag ) )
	{
		org = guy.origin;
		angles = guy.angles;
	}
	else
	{
		org = animatemodel gettagOrigin( tag );
		angles = animatemodel gettagAngles( tag );
	}
	
	if( isdefined( guy.ragdoll_getout_death ) )
		level thread animontag_ragdoll_death( guy, self );
	
	guy animscripted( flag, org, angles, animation );
	
	 // todo: make doNotetracks work on ai
	if( isai( guy ) )
		thread DoNoteTracks( guy, animatemodel, flag );
	
	if( isdefined( notetracks ) )
	{
		for( i = 0;i < notetracks.size;i ++ )
		{
			guy waittillmatch( flag, notetracks[ i ] );
			guy thread [[ sthreads[ i ] ]]();
		}
	}
	
	guy waittillmatch( flag, "end" );
	guy notify( "anim_on_tag_done" );
	
	guy.ragdoll_getout_death = undefined;
}

animontag_ragdoll_death_watch_for_damage()
{
	self endon( "anim_on_tag_done" );

	while(1)
	{
		self waittill( "damage", damage, attacker, damageDirection, damagePoint, damageMod );

		self notify( "vehicle_damage", damage, attacker, damageDirection, damagePoint, damageMod );
	}
}

animontag_ragdoll_death_watch_for_damage_notdone()
{
	self endon( "anim_on_tag_done" );

	while(1)
	{
		self waittill( "damage_notdone", damage, attacker, damageDirection, damagePoint, damageMod );

		self notify( "vehicle_damage", damage, attacker, damageDirection, damagePoint, damageMod );
	}
}

animontag_ragdoll_death( guy, vehicle )
{
	 // thread draw_line_from_ent_to_ent_until_notify( level.player, guy, 1, 0, 0, guy, "anim_on_tag_done" );
	if ( isdefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
		return;
	if( !isAI( guy ) )
		guy setCanDamage( true );
	
	guy endon( "anim_on_tag_done" );
	
	// if in delayed death, the AI may not be getting damage notifies anymore
	// but will still get the notdone one, so let's make sure we don't lose it
	guy thread animontag_ragdoll_death_watch_for_damage();
	guy thread animontag_ragdoll_death_watch_for_damage_notdone();
	
	damage = undefined;
	attacker = undefined;
	damageDirection = undefined;
	damagePoint = undefined;
	damageMod = undefined;
	explosiveDamage = false;
	vehicleallreadydead = vehicle.health <= 0;
	while ( true )
	{
		if(!vehicleallreadydead && !( isdefined( vehicle ) && vehicle.health > 0)  )
			break;

		/*/#recordEntText( "DAMAGE WAIT", guy, level.color_debug["orange"], "Script" );#/*/
		
		guy waittill( "vehicle_damage", damage, attacker, damageDirection, damagePoint, damageMod );

		explosiveDamage = isExplosiveDamageMOD( damageMod );

		/*/#recordEntText( "DAMAGE", guy, level.color_debug["orange"], "Script" );#/*/

		if( !isdefined( damage ) )
			continue;
		if ( damage < 1 )
			continue;
		if( !isdefined( attacker ) )
			continue;
		if( isdefined( guy.ridingvehicle ) && attacker == guy.ridingvehicle )
			break;
		if ( IsPlayer(attacker) && (explosiveDamage || !IsDefined(guy.allow_ragdoll_getout_death) || guy.allow_ragdoll_getout_death) )
			break;
	}
	
	if( !isdefined(guy) )
		return;  // guy was deleted between "damage" and the "fastrope_fall" notetrack.
	
	guy.deathanim = undefined;
	guy.deathFunction = undefined;
	guy.anim_disablePain = true;
	
	if ( isdefined( guy.ragdoll_fall_anim ) )
	{
		// only do fall animation if the guy is high enough to not fall through the ground
		moveDelta = getmovedelta( guy.ragdoll_fall_anim, 0, 1 );
		groundPos = physicstrace( guy.origin + ( 0, 0, 16 ), guy.origin - ( 0, 0, 10000 ) );
		
		distanceFromGround = distance( guy.origin + ( 0, 0, 16 ), groundPos );
		if ( abs( moveDelta[ 2 ] + 16 ) <=  abs( distanceFromGround ) )
		{
			guy thread play_sound_on_entity( "generic_death_falling" );
			guy animscripted( "fastrope_fall", guy.origin, guy.angles, guy.ragdoll_fall_anim );
			guy waittillmatch( "fastrope_fall", "start_ragdoll" );
		}
	}
	if( !isdefined(guy) )
		return;  // guy was deleted between "damage" and the "fastrope_fall" notetrack.
	guy.deathanim = undefined;
	guy.deathFunction = undefined;
	guy.anim_disablePain = true;
	guy doDamage( guy.health + 100, attacker.origin, attacker );

	/*/#recordEntText( "DODAMAGE", guy, level.color_debug["orange"], "Script" );#/*/

	if( explosiveDamage )
	{
		guy stopanimscripted();
		//guy SetContents(0); // no collision
		guy.delayedDeath = false;
		guy.allowDeath = true;
		/*/#recordEntText( "ALLOWDEATH = TRUE", guy, level.color_debug["orange"], "Script" );#/*/
		guy.noGibDeathAnim = true;

		// his health may be down to 1 if he'd gotten shot already
		// and it'll interfere with the damage call below
		guy.health = guy.maxHealth;

		guy doDamage( guy.health + 100, damagePoint, attacker, -1, "explosive" );
	}
	else
	{
		/*/#recordEntText( "START RAGDOLL", guy, level.color_debug["orange"], "Script" );#/*/
		guy animscripts\utility::do_ragdoll_death();
	}
}

isExplosiveDamageMOD( mod )
{
	if( !IsDefined( mod ) )
		return false;
	
	if( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
		return true;

	return false;
}

 // applies endons to donotetracks
DoNoteTracks( guy, vehicle, flag )
{
	guy endon( "newanim" );
	vehicle endon( "death" );
	guy endon( "death" );
	guy animscripts\shared::DoNoteTracks( flag );
}

animatemoveintoplace( guy, org, angles, movetospotanim )
{
	guy animscripted( "movetospot", org, angles, movetospotanim );
	guy waittillmatch( "movetospot", "end" );
}

guy_vehicle_death( guy )
{
	animpos = anim_pos( self, guy.pos );
	
	if ( isdefined( animpos.getout ) )
	{
		self endon( "unload" );
	}
	
	guy endon( "death" );
	self endon( "forcedremoval" );// pile on teh hacks.  I need to clean this up  next game and make the vehicles simply sort through the riders and figure it out rather than thread each guy like this.
	self waittill( "death" ); 

	if ( isdefined( animpos.unload_ondeath ) && isdefined( self ) )
	{
		thread guy_idle( guy, guy.pos, true ); // hack, idle gets canceled out by the death;
	 	wait animpos.unload_ondeath;
 		self.groupedanim_pos = guy.pos;
		self notify( "groupedanimevent", "unload" );
		return;
	}
	
	if ( isdefined( guy ) )
	{
		origin = guy.origin;
		guy Delete();
		
		[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
	}
}

guy_turn_right_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).turn_right );
}

guy_turn_right( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	
	if ( isdefined( animpos.vehicle_turn_right ) )
	{
		thread setanimrestart_once( animpos.vehicle_turn_right );
	}
	
	animontag( guy, animpos.sittag, animpos.turn_right );
	thread guy_idle( guy, pos );
}
	
guy_turn_left( guy, pos )
	{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	
	if ( isdefined( animpos.vehicle_turn_left ) )
	{
		self thread setanimrestart_once( animpos.vehicle_turn_left );
	}
	
	animontag( guy, animpos.sittag, animpos.turn_left );
	thread guy_idle( guy, pos );
}

guy_turn_left_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).turn_left );
}


guy_turn_hardright( guy, pos )
{
	animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
	if( isdefined( animpos.idle_hardright ) )
		guy.vehicle_idle_override = animpos.idle_hardright;
}

guy_turn_hardleft( guy, pos )
{
	animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
	if( isdefined( animpos.idle_hardleft ) )
		guy.vehicle_idle_override = animpos.idle_hardleft;
}

guy_drive_reaction( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	animontag( guy, animpos.sittag, animpos.drive_reaction );
	thread guy_idle( guy, pos );
}

guy_drive_reaction_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).drive_reaction );
}

guy_death_fire( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	animontag( guy, animpos.sittag, animpos.death_fire );
	thread guy_idle( guy, pos );
}

guy_death_fire_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).death_fire );
}

// AE 1/23/09: added this to show animation when going from passenger to driver
guy_move_to_driver(guy, pos) // self == the vehicle
{
	guy endon("newanim");
	self endon("death");
	guy endon("death");

	//// set to the driver position on the vehicle
	//guy Unlink();

	pos = 0; // make them the next driver
	animpos = anim_pos(self, pos);

	guy.pos = 0;
	guy.drivingvehicle = true;
	guy.vehicle_idle = animpos.idle; //%crew_jeep1_driver_drive_idle;
	guy.ridingvehicle = self;
	guy.orghealth = guy.health;

	ArrayRemoveValue(self.attachedguys, self.attachedguys[1]);
	self.attachedguys[0] = guy;

	if(IsDefined(animpos.move_to_driver))
	{
		//guy LinkTo(self, animpos.sittag);
		//wait(0.05);
		animontag(guy, animpos.sittag, animpos.move_to_driver);
		//guy waittill("anim_on_tag_done");
		guy Unlink();
		//wait(0.05);
		guy LinkTo(self, animpos.sittag);
	}

	wait(0.05);
	thread guy_idle(guy, pos);
	// send a notify to let everyone know the guy has moved to the driver seat
	guy notify("moved_to_driver");
}	

ai_wait_go()
{
	self endon( "death" );
	self waittill( "loaded" );
	self maps\_vehicle::gopath();
}

set_pos( guy, maxpos ) // self == vehicle
{
	pos = undefined;
	script_startingposition = isdefined(guy.script_startingposition);
	
	if( isdefined( guy.forced_startingposition ) )
	{
		pos = guy.forced_startingposition;
		assert( (( pos < maxpos ) && ( pos >= 0 ) ), "script_startingposition on a vehicle rider must be between " + maxpos + " and 0" );
		return pos;
	}
	
	if ( script_startingposition && !self.usedpositions[ guy.script_startingposition ] )
	{
		pos = guy.script_startingposition;
		assert( (( pos < maxpos ) && ( pos >= 0 ) ), "script_startingposition on a vehicle rider must be between " + maxpos + " and 0" );
	}
	else
	{
		if( script_startingposition )
		{
			/#println("vehicle rider with script_startingposition: "+guy.script_startingposition+" and script_vehicleride: "+self.script_vehicleride+" that's been taken" );#/
			assertmsg("startingposition conflict, see console");
		}
		
		// skip the drivers/pilots if requested
		lowestPassengerIndex = 0;
		if( IS_TRUE( self.vehicle_passengersOnly ) && IsDefined( self.vehicle_numDrivers ) )
			lowestPassengerIndex = self.vehicle_numDrivers;
		
		 // if there isn't one then set it to the lowest unused spot
		for( j = lowestPassengerIndex; j < self.usedPositions.size; j++ )
		{
			if( self.usedPositions[ j ] == true )
				continue;
			pos = j;
			break;
		}
	}
	
	return pos;
}

guy_man_gunner_turret()
{
	self notify( "animontag_thread" );
	self endon( "animontag_thread" );
	self endon( "death" );
	self.vehicle endon( "death" );

	const aimBlendTime = .05;
	const animLimit = 60;

	animpos = anim_pos( self.vehicle, self.vehicle_pos );

	for( ;; )
	{
		// don't let code override the tag linkto
		if ( IsAI(self) )
		{
			self AnimMode( "point relative" );

			org = self.vehicle gettagorigin( animpos.sittag );

			org2 = self.vehicle gettagorigin( "tag_gunner_turret1" );

			/#
				recordLine( self.vehicle.origin, org, (1,0,0), "Script", self );
				recordLine( self.vehicle.origin, org2, (0,1,0), "Script", self );
			#/
		}

		self ClearAnim( %root, aimBlendTime );
		
		firing = self.vehicle IsGunnerFiring( animpos.vehiclegunner - 1 );
		
		baseAnim = ( IsDefined( animpos.fire ) && firing  ? animpos.fire : animpos.idle );
		upAnim = ( IsDefined( animpos.fireup ) && firing  ? animpos.fireup : animpos.aimup );
		downAnim = ( IsDefined( animpos.firedown ) && firing  ? animpos.firedown : animpos.aimdown );		
		
		vehicle_baseAnim = ( IsDefined( animpos.vehicle_fire ) && firing  ? animpos.vehicle_fire : animpos.vehicle_idle );
		vehicle_upAnim = ( IsDefined( animpos.vehicle_fireup ) && firing  ? animpos.vehicle_fireup : animpos.vehicle_aimup );
		vehicle_downAnim = ( IsDefined( animpos.vehicle_firedown ) && firing  ? animpos.vehicle_firedown : animpos.vehicle_aimdown );				
		
		self SetAnim( baseAnim, 1.0 );
		
		if ( IsDefined( vehicle_baseAnim ) )
			self.vehicle SetAnim( vehicle_baseAnim, 1.0 );

		pitchDelta = self.vehicle GetGunnerAnimPitch( animpos.vehiclegunner - 1 );
		if ( pitchDelta >= 0 )
		{
			if( pitchDelta > animLimit )
			{
				pitchDelta = animLimit;
			}
			weight = pitchDelta / animLimit;
			self setAnimLimited( upanim, weight, aimBlendTime );			
			self setAnimLimited( baseAnim, 1.0 - weight, aimBlendTime );
			
//			if ( IsDefined( vehicle_baseAnim ) && IsDefined( vehicle_downAnim ) )
//			{
//				self setAnimLimited( vehicle_downAnim, weight, aimBlendTime );			
//				self setAnimLimited( vehicle_baseAnim, 1.0 - weight, aimBlendTime );				
//			}
		}
		else if ( pitchDelta < 0 )
		{
			if( pitchDelta < 0-animLimit )
			{
				pitchDelta = 0-animLimit;
			}
			weight = 0-(pitchDelta / animLimit);
			self setAnimLimited( downanim, weight, aimBlendTime );
			self setAnimLimited( baseAnim, 1.0 - weight, aimBlendTime );
			
//			if ( IsDefined( vehicle_baseAnim ) && IsDefined( vehicle_upAnim ) )
//			{
//				self setAnimLimited( vehicle_upAnim, weight, aimBlendTime );
//				self setAnimLimited( vehicle_baseAnim, 1.0 - weight, aimBlendTime );
//			}			
		}
		wait .05;
	}
}

guy_man_turret( guy , pos )
{
	animpos = anim_pos( self, pos );
	turret = self.mgturret[ animpos.mgturret ];
	turret setdefaultdroppitch( 0 );
	wait( 0.1 );
	turret endon( "death" );
	guy endon( "death" );
	//level thread maps\_mgturret::mg42_setdifficulty( turret, getdifficulty() );
	turret setmode( "auto_ai" );
	turret setturretignoregoals( true );

	// Alex Liu (5-14-08) Give the MG guy an identifier, so he can be pinpointed later in script
	guy.script_on_vehicle_turret = 1;
		
	while( 1 )
	{
		if( !isdefined( guy getturret() ) )
			guy useturret( turret );
		wait 1;
	}
}

guy_unlink_on_death( guy )
{
	guy endon( "jumpedout" );
	guy waittill( "death" );
	if( isdefined( guy ) )
		guy unlink();
}

blowup_riders()
{
	self array_ent_thread( self.riders, ::guy_blowup );
}

guy_blowup( guy )
{
	if( !IsDefined( guy ) || !IsDefined( guy.pos ) )
		return;  // the fast ropes are a rider with no .pos assigned.
	pos = guy.pos;
	anim_pos = anim_pos( self, pos );
	if ( !isdefined( anim_pos.explosion_death ) )
		return;
	
	[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", guy.origin );

	deathanim = anim_pos.explosion_death;
	if ( isdefined( guy.explosion_death_override ) )
	{
		deathanim = guy.explosion_death_override;
	}
// 	guy.allowdeath = true;
	angles = self.angles;
	origin = guy.origin;
	
	// I think there's a better way to to dthis but I'm lazy
	if ( isdefined( anim_pos.explosion_death_offset ) )
	{
		origin += VectorScale( anglestoforward( angles ), anim_pos.explosion_death_offset[ 0 ] );
		origin += VectorScale( anglestoright( angles ), anim_pos.explosion_death_offset[ 1 ] );
		origin += VectorScale( anglestoup( angles ), anim_pos.explosion_death_offset[ 2 ] );
	}
	guy = convert_guy_to_drone( guy );
	detach_models_with_substr( guy, "weapon_" );
	guy notsolid();
	guy.origin = origin;
	guy.angles = angles;
	
	guy stopanimscripted();
	guy animscripted( "deathanim", origin, angles, deathanim );
	fraction = .3;
	if ( isdefined( anim_pos.explosion_death_ragdollfraction ) )
		fraction = anim_pos.explosion_death_ragdollfraction;
	animlength = getanimlength( anim_pos.explosion_death );
	timer = gettime() + ( animlength * 1000 );
	wait animlength * fraction;
	
	force = (0,0,1);
	org = guy.origin;
		
	if( GetDvar( "ragdoll_enable") == "0" )
	{
		guy delete();
		return;
	}

	
	while ( ! guy isragdoll() && gettime() < timer )
	{
		org = guy.origin;
		wait .05;
		force = guy.origin-org;
		guy startragdoll();
		
	}
	wait .05;
	force = VectorScale( force,20000 );
	for ( i = 0; i < 3; i++ )
	{
		if ( isdefined( guy ) )
			org = guy.origin;
//		PhysicsJolt( org, 250, 250, force );
		wait( 0.05 );
	}
	if ( !guy isragdoll() )
	{
		guy delete();
	}
	else
	{
		// OAA: failsafe for script that gets created to be deleted
		wait( 40 );
		guy delete();
	}

}

// maybe I should make a utility out of this?. could be slow
convert_guy_to_drone( guy, bKeepguy )
{
	if ( !isdefined( bKeepguy ) )
		bKeepguy = false;
	model = spawn( "script_model", guy.origin );
	model.angles = guy.angles;
	model setmodel( guy.model );
	size = guy getattachsize();
	for ( i = 0;i < size;i++ )
	{
		model attach( guy getattachmodelname( i ), guy getattachtagname( i ) );
// 		struct.attachedtags[ i ] = guy getattachtagname( i );
	}
	model useanimtree( #animtree );
	if ( isdefined( guy.team ) )
		model.team = guy.team;
	if ( !bKeepguy )
		guy delete();
	model makefakeai();
	return model;
}

vehicle_animate( animation, animtree )
{
	self UseAnimTree( animtree );
	self setAnim( animation );	
}

vehicle_getInstart( pos )
{
	animpos = anim_pos( self, pos );
	return vehicle_getanimstart( animpos.getin, animpos.sittag, pos );
}


//TODO: anim_reach is the new and cool way.
vehicle_getanimstart( animation, tag, pos )
{
	struct = spawnstruct();

	origin = undefined;
	angles = undefined;
	assert( isdefined( animation ) );
	org = self gettagorigin( tag );
	ang = self gettagangles( tag );
	origin = getstartorigin( org, ang, animation );
	angles = getstartangles( org, ang, animation );

	struct.origin = origin;
	struct.angles = angles;
	struct.pos = pos;
	return struct;
}

get_availablepositions()
{
	vehicleanim = get_aianims();
	availablepositions = [];
	nonanimatedpositions = [];
	for( i = 0;i < self.usedPositions.size;i ++ )
	{
		if( !self.usedPositions[ i ] )
		{
			if( isdefined( vehicleanim[ i ].getin ) )
			{
				availablepositions[ availablepositions.size ] = vehicle_getInstart( i );
			}
			else
			{
				nonanimatedpositions[ nonanimatedpositions.size ] = i;
			}
		}
	}
		
	struct = spawnstruct();
	struct.availablepositions = availablepositions;
	struct.nonanimatedpositions = nonanimatedpositions;
	return struct;
}

set_walkerpos( guy, maxpos )
{
	pos = undefined;
	if( isdefined( guy.script_startingposition ) )
	{
		pos = guy.script_startingposition;
		assert( (( pos < maxpos ) && ( pos >= 0 ) ), "script_startingposition on a vehicle rider must be between " + maxpos + " and 0" );
	}
	else
	{
		 // if there isn't one then set it to the lowest unused spot
		pos = -1;
		for( j = 0;j < self.walk_tags_used.size;j ++ )
		{
			if( self.walk_tags_used[ j ] == true )
				continue;
			pos = j;
			self.walk_tags_used[ j ] = true;			
			break;
		}
		assert( pos >= 0, "Vehicle ran out of walking spots. This is usually caused by making more than 6 AI walk with a vehicle." );
	}
	return pos;
}

WalkWithVehicle( guy, pos )
{
	// CODER_MOD - JamesS make sure we have a walkers array first
	if( !IsDefined(self.walkers) )
		self.walkers = [];
		
	self.walkers[ self.walkers.size ] = guy;
	if( !isdefined( guy.FollowMode ) )
		guy.FollowMode = "close";
	guy.WalkingVehicle = self;
	if( guy.FollowMode == "close" )
	{
		guy.vehiclewalkmember = pos;
		level thread vehiclewalker_freespot_ondeath( guy );
	}
	guy notify( "stop friendly think" );
	guy vehiclewalker_updateGoalPos( self, "once" );
	guy thread vehiclewalker_removeonunload( self );
	guy thread vehiclewalker_updateGoalPos( self );
	guy thread vehiclewalker_teamUnderAttack();
}

vehiclewalker_removeonunload( vehicle )
{
	vehicle endon( "death" );
	vehicle waittill( "unload" );
	ArrayRemoveValue( vehicle.walkers, self );
}

 // Makes guys walking on the right side of a vehicle shift to the left side
 // of the vehicle until all spots available on the left side are filled up
shiftSides( side )
{
	if( !isdefined( side ) )
		return;
	if( ( side != "left" ) && ( side != "right" ) )
	{
		/#
		iprintln( "Valid sides are 'left' and 'right' only" );
		#/
		return;
	}
		
	 // find out if this guy is still part of a tank...
	if( !isdefined( self.WalkingVehicle ) )
		return;
	
	 // see if this guy is already on the requested side...
	if( self.WalkingVehicle.walk_tags[ self.vehiclewalkmember ].side == side )
		return;
	
	 // move this guy to the next available spot on the new side of the tank
	for( i = 0;i < self.WalkingVehicle.walk_tags.size;i ++ )
	{
		if( self.WalkingVehicle.walk_tags[ i ].side != side )
			continue;
		if( self.WalkingVehicle.walk_tags_used[ i ] == false )
		{
			if( self.WalkingVehicle getspeedMPH() > 0 )
			{
				 // tank is moving to make the AI get to the other side by walking behind the tank
				self notify( "stop updating goalpos" );
				self setgoalpos( self.WalkingVehicle.backpos.origin );
				self.WalkingVehicle.walk_tags_used[ self.vehiclewalkmember ] = false;
				self.vehiclewalkmember = i;
				self.WalkingVehicle.walk_tags_used[ self.vehiclewalkmember ] = true;
				self waittill( "goal" );
				self thread vehiclewalker_updateGoalPos( self.WalkingVehicle );
			}
			else
				self.vehiclewalkmember = i;
			return;
		}
		/#
		iprintln( "TANKAI: Guy couldn't move to the " + side + " side of the tank because no positions on that side are free" );
		#/
	}
}

vehiclewalker_freespot_ondeath( guy )
{
	guy waittill( "death" );
	if( !isdefined( guy.WalkingVehicle ) )
		return;
	guy.WalkingVehicle.walk_tags_used[ guy.vehiclewalkmember ] = false;
}

vehiclewalker_teamUnderAttack()
{
	self endon( "death" );
	for( ;; )
	{
		self waittill( "damage", amount, attacker );
		if( !isdefined( attacker ) )
			continue;
		if( ( !isdefined( attacker.team ) ) || ( isplayer( attacker ) ) )
			continue;
		
		if( ( isdefined( self.RidingTank ) ) && ( isdefined( self.RidingTank.allowUnloadIfAttacked ) ) && ( self.RidingTank.allowUnloadIfAttacked == false ) )
			continue;
		if( ( isdefined( self.WalkingVehicle ) ) && ( isdefined( self.WalkingVehicle.allowUnloadIfAttacked ) ) && ( self.WalkingVehicle.allowUnloadIfAttacked == false ) )
			continue;
		
		self.WalkingVehicle.teamUnderAttack = true;
		self.WalkingVehicle notify( "unload" );
		return;
	}
}

GetNewNodePositionAheadofVehicle( guy )
{
	minimumDistance = 300 + ( 50 * ( self getspeedMPH() ) );
	 // get the next node in front of the tank
	nextNode = undefined;
	if( !isdefined( self.CurrentNode.target ) )
		return self.origin;
	
	nextNode = getVehicleNode( self.CurrentNode.target, "targetname" );
	
	if( !isdefined( nextNode ) )
	{
		if( isdefined( guy.NodeAfterVehicleWalk ) )
			return guy.NodeAfterVehicleWalk.origin;
		else
			return self.origin;
	}
	
	 // Is this position far enough from the tank?
	if( distancesquared( self.origin, nextNode.origin ) >= (minimumDistance*minimumDistance) )
		return nextNode.origin;
	
	for( ;; )
	{
		 // Is this position far enough from the tank?
		if( distancesquared( self.origin, nextNode.origin ) >= (minimumDistance*minimumDistance) )
			return nextNode.origin;
		if( !isdefined( nextNode.target ) )
			break;
		nextNode = getVehicleNode( nextNode.target, "targetname" );
	}
	
	if( isdefined( guy.NodeAfterVehicleWalk ) )
		return guy.NodeAfterVehicleWalk.origin;
	else
		return self.origin;
}

vehiclewalker_updateGoalPos( tank, option )
{
	self endon( "death" );
	tank endon( "death" );
	self endon( "stop updating goalpos" );
	self endon( "unload" );
	for( ;; )
	{
		if( self.FollowMode == "cover nodes" )
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 300;
			self.walkdist = 64;
			position = tank GetNewNodePositionAheadofVehicle( self );
		}
		else // followmode = "close"
		{
			self.oldgoalradius = self.goalradius;
			self.goalradius = 2;
			self.walkdist = 64;
			position = tank gettagOrigin( tank.walk_tags[ self.vehiclewalkmember ] );
		}
		
		 // SETS THE GOAL POSITION ONLY ONCE IF THAT OPTION IS SPECIFIED
		if( ( isdefined( option ) ) && ( option == "once" ) )
		{
			trace = bulletTrace( ( position + ( 0, 0, 100 ) ), ( position - ( 0, 0, 500 ) ), false, undefined );
			if( self.FollowMode == "close" )
				self teleport( trace[ "position" ] );
			self setGoalPos( trace[ "position" ] );
			return;
		}
		 // -- -- -- -- -- -- -- -- 
		
		tankSpeed = tank getspeedmph();
		if( tankSpeed > 0 )
		{
			trace = bulletTrace( ( position + ( 0, 0, 100 ) ), ( position - ( 0, 0, 500 ) ), false, undefined );
			self setGoalPos( trace[ "position" ] );
		}
		wait 0.5;
	}
}

getanimatemodel()
{
	if( isdefined( self.modeldummy ) )
		return self.modeldummy;
	else
		return self;	
}

animpos_override_standattack( type, pos, animation )
{
	level.vehicle_aianims[ type ][ pos ].vehicle_standattack = animation;
}

detach_models_with_substr( guy, substr )
{
	size = guy getattachsize();
	modelstodetach = [];
	tagsstodetach = [];
	const index = 0;
	for ( i = 0;i < size;i++ )
	{
		modelname = guy getattachmodelname( i );
		tagname = guy getattachtagname( i );
		if ( issubstr( modelname, substr ) )
		{
			modelstodetach[ index ] = modelname;
			tagsstodetach[ index ] = tagname;
		}
	}
	for ( i = 0; i < modelstodetach.size; i++ )
		guy detach( modelstodetach[ i ], tagsstodetach[ i ] );
}

should_give_orghealth()
{
	if ( !isai( self ) )
		return false;
	if ( !isdefined( self.orghealth ) )
		return false;
	return !isdefined( self.magic_bullet_shield );
}

get_aianims()
{
	vehicleanims = level.vehicle_aianims[ self.vehicletype ];

	// Override any global animations with animations for this specific vehicle
	if (IsDefined(self.vehicle_aianims))
	{
		keys = GetArrayKeys(vehicleanims);

		for (i = 0; i < keys.size; i++)
		{
			key = keys[i];
			if (IsDefined(self.vehicle_aianims[key]))
			{
				override = self.vehicle_aianims[key];

				if (IsDefined(override.idle))
				{
					vehicleanims[key].idle = override.idle;
				}

				if (IsDefined(override.getout))
				{
					vehicleanims[key].getout = override.getout;
				}

				if (IsDefined(override.getin))
				{
					vehicleanims[key].getin = override.getin;
				}

				if (IsDefined(override.waiting))
				{
					vehicleanims[key].waiting = override.waiting;
				}
			}
		}
	}

	return vehicleanims;
}

override_anim(action, tag, animation)
{
	pos = anim_pos_from_tag(self, tag);
	assert(IsDefined(pos), "_vehicle_aianim::override_anim - No valid position set up for tag '" + tag + "' on vehicle of type '" + self.vehicletype + "'.");

	if (!IsDefined(self.vehicle_aianims) || !IsDefined(self.vehicle_aianims[pos]))
	{
		self.vehicle_aianims[pos] = SpawnStruct();
	}

	switch (action)
	{
	case "getin":
		self.vehicle_aianims[pos].getin = animation;
		break;
	case "idle":
		self.vehicle_aianims[pos].idle = animation;
		break;
	case "getout":
		self.vehicle_aianims[pos].getout = animation;
		break;
	default: AssertMsg("_vehicle_aianim::override_anim - '" + action + "' action is not supported for overriding the animation.");
	}

}