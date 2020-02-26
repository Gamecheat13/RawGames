#include common_scripts\utility;
#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;
#include maps\_vehicle_aianim;

//#include maps\jeepride;
#include maps\_anim;

#using_animtree( "generic_human" );   

orientmodehack_axis( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	guy endon( "death" );
	// set the orient mode to face the player every frame. lets  see what this does
	
	while ( 1 )
	{
// 		guy setpotentialthreat( vectortoangles( level.player.origin - guy.origin )[ 1 ] );                
		guy orientmode( "face angle", vectortoangles( level.player.origin - guy.origin )[ 1 ] );
		wait .05;
	}
}

player_fudge_move_rotate_to( dest, destang, moverate, org )
{
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 1;
	org unlink();
	dist = distance( level.player.origin, dest );
	movetime = dist / moverate;
	
	accel = movetime * .05;
	decel = movetime * .05;
	org moveto( dest, movetime, accel, decel );
	org rotateto( destang, movetime, accel, decel );
	wait movetime;
	level.player unlink();
}

attacknow()
{
	self waittill( "trigger", eVehicle );
	eVehicle.attacknow = true;
	eVehicle notify( "attacknow" );
}

player_link_update( influence )
{
	if ( !isdefined( influence ) )
		influence = level.playerlinkinfluence;
	level.player playerlinkto( level.playerlinkmodel, "polySurface1", influence );
}

fake_position( model, pos )
{
	if ( !isdefined( self.riders ) )
		return;
	model hide();
	while ( !self.riders.size )
		wait .05;
	
	if ( pos == 999 )
	{
		level.player unlink();
		level.playerlinkmodel = model;
		level.player playerlinkto( level.playerlinkmodel, "polySurface1", level.playerlinkinfluence );
		return;
	}

	if ( pos == 888 )
	{
		self.rpgguyspot = model;
		return;
	}
	
	if ( pos == 532 )
	{
		model thread rpg_spot( self );
		return;
	}
	
	if ( pos == 533 )
	{
		model hide();
		self.rpgguyspotsecondary = model;
		return;
	}
	
	rider = undefined;
	for ( i = 0 ; i < self.riders.size ; i++ )
		if ( self.riders[ i ].pos == pos )
			rider = self.riders[ i ];
			
	if ( !isdefined( rider ) )
		return;
	rider unlink();
	tag = "polySurface1";
	rider linkto( model, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );	
	if ( !isai( rider ) )
		rider thread rider_droneai( model, tag );
	else
	{
		guy_force_remove_from_vehicle( self, rider );
		self thread whackamole( rider );
	}

}

in_GetWeaponsList( weaponname )
{
	weaponlist = level.player GetWeaponsList();
	for ( i = 0; i < weaponlist.size; i++ )
		if ( weaponname == weaponlist[ i ] )
			return true;
	
	return false;
}

rpg_spot( vehicle )
{
	self hide();
	level waittill( "newrpg" );
	matchedweapon = false;
	weaponname = "rpg";
	weapon = spawn( "weapon_" + weaponname, self.origin, 1 );// 1 = suspended
	weapon.angles = self.angles;
	weapon linkto( self );
	self.jeepride_linked_weapon = self;// so I can delete it later
	list = [];
	while ( !in_GetWeaponsList( weaponname )  )
	{
// 		list = level.player GetWeaponsList();
		wait .05;// while the player doesn't have the weapon that's on the box in his inventory
	}
// 	weapon = undefined;
// 	for ( i = 0; i < list.size; i++ )
// 	{
// 		weapon = getent( "weapon_" + list[ i ], "classname" );
// 		if ( isdefined( weapon ) )
// 			break;
// 	}
// 	assert( isdefined( weapon ) );
// 	weapon unlink();
// 	weapon.origin = vehicle.rpgguyspotsecondary.origin;
// 	weapon.angles = vehicle.rpgguyspotsecondary.angles;
// 	weapon linkto( self );
// 	
	level.player givemaxammo( weaponname );
	flag_set( "rpg_taken" );
	firstrun = false;
}

local_drone_animontag( guy, tag, animation, bIspose, bBreakonattack )
{
	if ( isdefined( bBreakonattack ) && bBreakonattack )
		self endon( "attacknow" );
	if ( !isdefined( bIspose ) )
		bIspose = false;
	org = self gettagOrigin( tag );
	angles = self gettagAngles( tag );
	flag = "animontag";
	guy animscripted( flag, org, angles, animation );
	if ( !bIspose )
		guy waittillmatch( flag, "end" );
	else
		wait .05;
	guy notify( "droneanimfinished" );
}

rider_drone_toai( rider, model, tag, animation )
{
	ai = makerealai( rider );
	ai linkto( model, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

	model thread local_drone_animontag( ai, tag, animation );

	ai.desired_anim_pose = "crouch";	
	ai allowedstances( "crouch" );
	ai thread animscripts\utility::UpdateAnimPose();
	ai allowedstances( "stand", "crouch" );

	self thread whackamole( ai );
}

rider_droneai( model, tag )
{
// 	simple stuff.  have them randomly play a bunch of random animations untill a point designated to convert the whole group into whackamole guys
	if ( !( isdefined( self.script_noteworthy ) && self.script_noteworthy == "whackamole_guy" ) )
		return;
	vehicle = self.ridingvehicle;

	self endon( "death" );
	script_stance = "coverstand";
	
	animarray = [];
	animgroup = "coverstand";
	animarray[ animgroup ] = [];
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch01;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch02;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch03;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch04;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch05;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle;

	animgroup = "crouch";
	animarray[ animgroup ] = [];
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %crouch_aim_straight;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %exposed_crouch_reload;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %exposed_crouch_reload;

	animuparray = [];
	animgroup = "coverstand_up";
	animuparray[ animgroup ] = [];
	animuparray[ animgroup ][ animuparray[ animgroup ].size ] = %coverstand_hide_2_aim;

	animgroup = "crouch_up";
	animuparray[ animgroup ] = [];
	animuparray[ animgroup ][ animuparray[ animgroup ].size ] = %crouch2stand;
	
	animdownarray = [];
	animgroup = "crouch_down";
	animdownarray[ animgroup ] = [];
	animdownarray[ animgroup ][ animdownarray[ animgroup ].size ] = %stand2crouch_attack;

	animgroup = "crouch_down";
	animdownarray[ animgroup ] = [];
	animdownarray[ animgroup ][ animdownarray[ animgroup ].size ] = %stand2crouch_attack;
	
	vehicle endon( "death" );
	vehicle.attacknow = false;// set by trigger.
	
	index = 0;
	delaythread( .05, ::guy_force_remove_from_vehicle, vehicle, self );
// 	self.ridingvehicle = vehicle;// bleh hacks
	
	while ( ! vehicle.attacknow )
	{
		keys = getarraykeys( animarray );
		index = randomint( keys.size );
		animgroup = keys[ index ];

		index = randomint( animarray[ animgroup ].size );
		model local_drone_animontag( self, tag, animarray[ animgroup ][ index ], undefined, true );
	}
	
// 	animgroup = animgroup + "_up";
	// need to find 

	// stand up
// 	model local_drone_animontag( self, tag, animuparray[ animgroup ][ 0 ] );
	vehicle thread rider_drone_toai( self, model, tag, animarray[ animgroup ][ index ] );
}


apply_truckjunk_loc( eVehicle, truckjunk )
{
// 	eVehicle.truckjunk = [];
	for ( i = 0 ; i < truckjunk.size ; i++ )
	{
		model = eVehicle.truckjunk[ i ];
		if ( isdefined( truckjunk[ i ].script_startingposition ) )
			eVehicle thread fake_position( model, truckjunk[ i ].script_startingposition );
		if ( isdefined( truckjunk[ i ].script_noteworthy ) && truckjunk[ i ].script_noteworthy == "loosejunk" )
			model thread loosejunk( eVehicle );
	}
}

process_vehicles_spawned()
{
	while ( 1 )
	{
		eVehicle = waittill_vehiclespawn_spawner_id( self.spawner_id );
		if ( eVehicle.script_team == "allies" )
			eVehicle thread riders_godon();
		
		eVehicle thread tire_deflate();
		
		eVehicle thread godon();// all vehicles get godmode untill I tell them it's ok to die
		if ( isdefined( level.vehicle_truckjunk[ self.spawner_id ] ) )
			apply_truckjunk_loc( eVehicle, level.vehicle_truckjunk[ self.spawner_id ] );
			
		eVehicle thread kill_stupid_vehicle_threads();
		eVehicle thread freeOnEnd();
	}	
}


kill_stupid_vehicle_threads()
{
	waittillframeend;
	maps\_vehicle::vehicle_kill_badplace_forever();
	maps\_vehicle::vehicle_kill_rumble_forever();
// 	maps\_vehicle::vehicle_kill_treads_forever();
	maps\_vehicle::vehicle_kill_disconnect_paths_forever();
}

player_death()
{
	level.player waittill( "death" );
	array_thread( getentarray( "script_vehicle", "classname" ), ::deadplayer_stop );
}

deadplayer_stop()
{
	if ( ishelicopter() )
		return;
	self setspeed( 0, 25 );
}

spawners_setup()
{
	self waittill( "spawned", other );
	waittillframeend;
	other add_death_function( ::remember_weaponsondeath );
	if ( level.flag[ "end_ride" ] )
		return;
	if ( isdefined( other.a.rockets ) && other.a.rockets && other.weapon == "stinger_speedy" )
	{
		other thread rocket_handle();
	}
	
	other endon( "death" );
	other.dropweapon = false;
// 	other waittill( "jumpedout" );
// 	wait 4;
// 	other delete();
}

sethindtarget( eVehicle )
{
	self orientmode( "face angle", vectortoangles( eVehicle.origin - self.origin )[ 1 ] );
	attractorent = spawn( "script_origin", eVehicle gettagorigin( "tag_light_belly" ) );
	attractorent linkto( eVehicle );
	eVehicle.flaretargetents = array_add( eVehicle.flaretargetents, attractorent );
// 	thread	draw_line_from_ent_to_ent_until_notify( self, attractorent, 1, 1, 1, self, "never" );
	self clearentitytarget();
	self setentitytarget( attractorent );
	self.hindenemy = eVehicle;
}

attractorent_link( eVehicle )
{

}

rocket_handle()
{
	self endon( "death" );
	wait 1;
	if ( !isdefined( self.ridingvehicle ) )
		return;
	vehicle = self.ridingvehicle;
	self.rocketattachpos = self.pos;
	guy_force_remove_from_vehicle( vehicle, self );
	self allowedstances( "crouch", "stand" );
	
	if ( !isdefined( vehicle.rocketmen ) )
		vehicle.rocketmen = [];
	vehicle.rocketmen[ vehicle.rocketmen.size ] = self;
	
	self.a.rockets = 400;// hackery to keep them firing rockets.
	rocketcount = self.a.rockets;
	while ( 1 )
	{
		while ( self.a.rockets == rocketcount )
			wait .05;
		level notify( "rpg_guy_shot" );	// lets Hind know to drop flares
		self clearentitytarget();
		assert( isdefined( self.hindenemy ) );
		self thread animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
		wait 3;
		self sethindtarget( self.hindenemy );
		rocketcount = self.a.rockets;
	}
}

orien_hack()
{
	self endon( "death" );
	while ( 1 )
	{
		self OrientMode( "face direction", level.player.origin - self.origin );
		wait .05;
	}
}

magic_missileguy_magiccrouch()
{
	// hide the guy while he crouches
	self endon( "death" );
	self hide();
	self.desired_anim_pose = "crouch";
	self allowedstances( "crouch" );
	self thread animscripts\utility::UpdateAnimPose();
	wait 1.5;
	self show();
	self.desired_anim_pose = "stand";
	self allowedstances( "stand" );
	self thread animscripts\utility::UpdateAnimPose();
	wait 3;
	self notify( "missileready" );
}

magic_missileguy_spawner()
{
	targetnode = getvehiclenode( self.target, "targetname" );
	targetnode waittill( "trigger", vehicle );
	if ( isdefined( vehicle.magic_missile_guy ) )
		return;
			
	linkent = vehicle.rpgguyspot;
	self.origin = linkent.origin;
	self.angles = vectortoangles( level.player geteye() - self.origin );
// 	guy = self stalingradspawn();
	guy = dronespawn( self );
	tag = "polySurface1";
	guy linkto( linkent, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	vehicle.magic_missile_guy = guy;
// 	guy thread orien_hack();
// 	guy thread magic_missileguy_magiccrouch();
// 	guy waittill( "missileready" );
	targetent = spawn( "script_model", level.player geteye() );
	targetent.origin = level.player geteye() + vector_multiply( anglestoforward( self.angles ), 64 ) ;
 	targetent hide();
	targetent setmodel( "fx" );
	targetent linkto( level.playersride );
	guy thread magic_missileguy_death( vehicle, targetent );
// 	guy setEntityTarget( targetent );
	guy thread magic_missileguy_rpg( vehicle, linkent, tag, targetent );
}

magic_missileguy_death( vehicle, targetent )
{
	self setcandamage( true );
	self.health = 4000;
	vehicle endon( "death" );
// 	accumdam = 0;
	health = 100;
	while ( 1 )
	{
		self waittill( "damage", amount, attacker );
		if ( attacker == level.player )
			break;
// 			accumdam += amount;
// 		if ( accumdam > health )
// 			break;
		self.health = 4000;
	}
	level notify( "kill_confirm" );

	self dodamage( self.health + 10, self.origin );
	self unlink();
	self stopanimscripted();
	animation = %death_stand_dropinplace;
	self animscripted("death_stand_dropinplac",self.origin,self.angles,%death_stand_dropinplace);
	self thread ragdoll_or_death_duringanimation( animation );
}

ragdoll_or_death_duringanimation( animation )
{
	fraction = .2;
	animlength = getanimlength( animation );
	timer = gettime() + ( animlength * 1000 );
	wait animlength * .2;
	while ( ! self isragdoll() && gettime() < timer )
	{
		self startragdoll();
		wait .05;
	}
	if ( !self isragdoll() )
		self delete();
}


magic_missileguy_rpg( vehicle, animatemodel, tag, targetent )
{
	vehicle endon( "death" );
	self endon( "death" );
	crouchaim = %crouch_aim_straight;
	toaim = %crouch2stand;
	aim = %RPG_stand_aim_5;
	tocrouch = %stand2crouch_attack;

	fire_aim_idle_time = 3000;	
	fire_crouch_idle_time = 1500;
	
	animatemodel local_drone_animontag( self, tag, crouchaim );

	while ( 1 )
	{
		level.price anim_single_queue( level.price, "jeepride_pri_takehimout" );

		// aim for a bit;
		timer = timer_set( fire_aim_idle_time );
		while ( ! timer_past( timer ) )
			animatemodel local_drone_animontag( self, tag, aim, true );
		
		// fire!
		thread fake_rpg_shot( targetent, vehicle );
		
		// go to crouch
		animatemodel local_drone_animontag( self, tag, tocrouch );
		
		timer = timer_set( fire_crouch_idle_time );
		while ( ! timer_past( timer ) )
			animatemodel local_drone_animontag( self, tag, crouchaim );
			
		// go to stand aiming again
		animatemodel local_drone_animontag( self, tag, toaim );
	}
}

fake_rpg_shot( targetent, vehicle )
{
	barrelpos = self gettagorigin( "tag_flash" );
	barrelang = self gettagangles( "tag_flash" );
	fxent = spawn( "script_model", barrelpos );
	fxent.angles = barrelang;
	fxent setmodel( "projectile_rpg7" );
	PlayFXOnTag( level._effect[ "rpg_flash" ], fxent, "TAG_FX" );
	thread play_sound_in_space( "weap_rpg_fire_npc", fxent.origin );
	fxent PlayLoopSound( "weap_rpg_fire_npc" );
	movespeed = 2400;
	fire_vect = vectornormalize( targetent.origin - barrelpos );
	fire_org = barrelpos + vector_multiply( fire_vect, 5000 );
	PlayFXOnTag( level._effect[ "rpg_trail" ], fxent, "TAG_FX" );
	lastdest = barrelpos;
	fxent notsolid();
	fxent thread movewithrate( fire_org, barrelang, movespeed );
	engagedist = 450;
	
	while ( 1 )
	{
		wait .05;
		trace = BulletTrace( lastdest, fxent.origin, false, vehicle );
		if ( fxent.movefinished )
		{
			fxent delete();
			return;
		}
		if ( trace[ "fraction" ] != 1 
			 && distance( barrelpos, fxent.origin ) > engagedist )
			break;
		lastdest = fxent.origin;
	}
	playfx( level._effect[ "rpg_explode" ], fxent.origin );
	radiusdamage( fxent.origin, 400, 150, 26 );
	wait .01;
	fxent delete();	
}

timer_set( timer )
{
	return gettime() + timer;
}

timer_past( timer )
{
	if ( gettime() > timer )
		return true;
	return false;
}

physicslaunch_loc( centroid, strength, vec_sampledelay )
{
	if ( !isdefined( vec_sampledelay ) )
		vec_sampledelay = .1;
	orgbefore = self.origin;
	wait vec_sampledelay;
	throwvec = vectornormalize( self.origin - orgbefore );
	upvect = anglestoup( self.angles );
	self unlink();
	self physicslaunch( self.origin + vector_multiply( upvect, centroid ), vector_multiply( throwvec, strength ) );
}

can_cannon()
{
	level.cannonpower = 100;
	precachemodel( "com_trashcan_metal" );
	while ( 1 )
	{
		if ( level.player usebuttonpressed() )
			fire_can();
		wait .05;
	}
}

fire_can()
{
	can = spawn( "script_model", level.player geteye() );
	can setmodel( "com_trashcan_metal" );
	throw_vect = vector_multiply( vectornormalize( anglestoforward( level.player getplayerangles() ) ), level.cannonpower );
	can physicslaunch( can.origin + ( 0, 0, 17 ), throw_vect + ( 0, 0, 17 ) );
	wait .05;
	
}

no_godmoderiders()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		for ( i = 0 ; i < other.riders.size ; i++ )
			if ( issentient( other.riders[ i ] ) && isdefined( other.riders[ i ].magic_bullet_shield ) )
				other.riders[ i ] thread stop_magic_bullet_shield();
		if ( isdefined( other.rocketmen ) )
			for ( i = 0; i < other.rocketmen.size; i++ )
				if ( issentient( other.rocketmen[ i ] ) && isdefined( other.rocketmen[ i ].magic_bullet_shield ) )
				{
					other.rocketmen[ i ] thread stop_magic_bullet_shield();
					other.rocketmen[ i ] delete();// try just deleting them here.
				}

	}
}

all_allies_targetme()
{
	self waittill( "trigger", eVehicle );
	if ( !isdefined( eVehicle.flaretargetents ) )
		eVehicle.flaretargetents = [];
	ai = getaiarray( "allies" );
	for ( i = 0 ; i < ai.size ; i++ )
	{
		if ( !( ai[ i ].a.rockets > 10 ) )
			continue;
		ai[ i ] thread sethindtarget( eVehicle );
	}
	
	eVehicle endon( "death" );
	while ( 1 )
	{
		level waittill( "rpg_guy_shot" );
		thread vehicle_dropflare( eVehicle );
	}
}

vehicle_dropflare( eVehicle )
{
	eVehicle endon( "death" );
	wait randomfloatrange( 1, 2 );
	level thread jeepride_flares_fire_burst( eVehicle, 8, 6, 5.0 );
	eVehicle array_levelthread( eVehicle.flaretargetents, ::vehicle_drop_single_flare );
}

vehicle_drop_single_flare( attractorent )
{
	self.flaretargetents = array_remove( self.flaretargetents, attractorent );
	attractorent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( self );
	attractorent movegravity( vec, 8 );
	wait 4;
	attractorent delete();
	
}

hind_lock_on_player_on()
{
	level.lock_on_player = true;
	level endon( "lock_on_player_off" );
	// this is a once off gag. hacks away.
	level.lock_on_player_ent.script_shotcount = 1;
	while ( 1 )
	{
		while ( level.lock_on_player_ent.script_attackmetype == "missile" )
			wait .05;
		wait 2;
		level.lock_on_player_ent.script_shotcount = 1;
		level.lock_on_player_ent.script_attackmetype = "missile";
	}
}

hind_lock_on_player_off()
{
	level notify( "lock_on_player_off" );
	level.lock_on_player = false;
}

stinger_me( bPlayerlock )
{
	level endon( "clear_all_vehicles_but_heros" );
	self waittill( "trigger", eVehicle );
	if ( !isdefined( bPlayerlock ) )
		bPlayerlock = true;
		
		
	
	player_link_update( 0.1 );

	if( bPlayerlock )
		wait 4;

	level notify( "newrpg" );// sets RPG on box	
	
	if ( bPlayerlock )
		thread hind_lock_on_player_on();

	ent = spawn( "script_model", eVehicle.origin );
	ent linkto( eVehicle, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	flag_wait( "rpg_taken" );
	
	ammo = level.player GetWeaponAmmoStock( "rpg" );
	while ( level.player GetWeaponAmmoStock( "rpg" ) == ammo && ammo )
		wait .05;
		
	if ( bPlayerlock )
		hind_lock_on_player_off();

	player_link_update();// resets the link

	if ( !isdefined( eVehicle ) )
		return;
	eVehicle endon( "death" );
		
	if ( !ammo )
		return;

	level thread jeepride_flares_fire_burst( eVehicle, 8, 6, 5.0 );
	wait 0.5;
	ent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( eVehicle );
	ent movegravity( vec, 8 );

}

jeepride_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
// 		copied from maps\hunted which was copied from maps\_helicopter_globals
// 		had to change it a litle since I couldn't redirect the missile in my case.
// 		I simplified even more because I don't need any of that stuff that those scripts do

	vehicle endon( "death" );
	assert( isdefined( level.flare_fx[ vehicle.vehicletype ] ) );
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx( level.flare_fx[ vehicle.vehicletype ], vehicle getTagOrigin( "tag_light_belly" ) );
		wait 0.05;
	}
}

do_or_die()
{
	self waittill( "trigger" );
	if ( !level.lock_on_player )
		return;
		
	playfx( level._effect[ "rpg_explode" ], level.player.origin );
	level.playervehicle play_sound_in_space( "explo_metal_rand", level.player geteye(), true );
	
	level.player enableHealthShield( false );
	radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
	level.player enableHealthShield( true );
}

loosejunk( eVehicle )
{
	self.health = 700;
	self setcandamage( true );
	eVehicle endon( "junk_throw" );
	while ( 1 )
	{
// 		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
			self waittill( "damage", damage, attacker, direction_vec, point );
			
			if ( attacker != level.player && self.health > 100 )
				continue;
			self unlink();
			forward = anglestoforward( eVehicle.angles );
			offsetthrow = vector_multiply( vectornormalize( point - self.origin ), randomfloat( 2 ) );// little bit of a spin but not a lot based on where the thing was hit
			self.origin += vector_multiply( forward, 32 );// move it forward a little because physics launch is a bit slow.  may 
			forwardthrow = vector_multiply( forward, 18000 );

			self physicslaunch( self.origin + offsetthrow, vector_multiply( direction_vec, 10 ) + ( 0, 0, 20 ) + forwardthrow );
			return;
	}
}

junk_to_dummy( model )
{
	if ( !isdefined( self.truckjunk ) )
		return;
	for ( i = 0 ; i < self.truckjunk.size ; i++ )
	{
		self.truckjunk[ i ] unlink();
		self.truckjunk[ i ] linkto( model );
	}
}

junk_throw()
{
	if ( !isdefined( self.truckjunk ) )
		return;
	if ( self == level.playersride )
		return;
	self notify( "junk_throw" );
	for ( i = 0 ; i < self.truckjunk.size ; i++ )
	{
		if ( isdefined( self.truckjunk[ i ].script_startingposition ) || self.truckjunk[ i ].model == "axis" )
		{
			self.truckjunk[ i ] thread delayThread( 2, ::deleteme );
			continue;
		}
		center_height = 17;
		strength = 80000;
		delay = randomfloat( .7 );
		if ( self.truckjunk[ i ].model == "com_barrel_blue"
		 || self.truckjunk[ i ].model == "com_barrel_black"
		 || self.truckjunk[ i ].model == "com_plasticcase_beige_big" 
		 )
		{
			strength = 660000;
			center_height = 23;
			delay = randomfloat( 1 );
		}
		else if ( self.truckjunk[ i ].model == "me_corrugated_metal2x4" )
		{
			strength = 1000;
			center_height = 0;
		}
		self.truckjunk[ i ] delaythread( delay, ::physicslaunch_loc, center_height, strength );
	}
}

riders_godon()
{
	bKillfreevehicle = false;
	for ( i = 0 ; i < self.riders.size ; i++ )
		if ( issentient( self.riders[ i ] ) )
		{
			bKillfreevehicle = true;
			if ( !isdefined( self.riders[ i ].magic_bullet_shield ) || !self.riders[ i ].magic_bullet_shield )
				self.riders[ i ] thread magic_bullet_shield();
		}
	
	if ( !bKillfreevehicle )
		return;
	wait .2;
	self notify( "no_free_on_end" );
}

monitorvehiclecounts()
{
	while ( 1 )
	{
		if ( getentarray( "script_vehicle", "classname" ).size > 60 )
		{
			vehicle_dump();
			assertmsg( "too many vehicles" );
		}
		wait .05;
	}
}

destructible_assistance()
{
 	self waittill( "trigger", eVehicle );
 	eVehicle maps\_vehicle::godoff();
	eVehicle notify( 	"stop_friendlyfire_shield" );
	eVehicle.health = 1;
  if ( ! eVehicle isDestructible() )
  {
  	eVehicle notify( "death" );
	}
	else
	{
		eVehicle notify( "damage", 5000, level.player, ( 1, 1, 1 ), eVehicle.origin, "mod_explosive", eVehicle.model, undefined );
		
	}
}

killthrow()
{
	if ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
		return;
	if ( isdefined( self.pos ) )
	if ( self.pos == 0 || self.pos == 1 )
	{
		self delete();
		return;
	}
	self dodamage( 8000, self.origin ); 
}

heli_focusonplayer()
{
	self waittill( "trigger", other );
	other setlookatent( level.playersride );
	other setTurretTargetEnt( level.playersride );
}

heli_mg_burst( eTarget )
{
	shots = randomintrange( 25, 45 );
	for ( i = 0; i < shots; i++ )
	{
		self setVehWeapon( "hind_turret" );
		self fireWeapon( "tag_flash" );
		wait 0.05;
		if ( eTarget.script_attackmetype != "mg_burst" || playerinhelitargetsights_orrandom( eTarget ) )
			break;
	}
	wait randomfloatrange( .5, 1 );
}

playerinhelitargetsights_orrandom( eTarget )
{
	inrange = distance( eTarget.origin, level.player.origin ) < 32;
	if ( !inrange && randomint( 25 ) > 18 )
		inrange = true;
	if ( inrange )
		eTarget.script_attackmetype = ( "missile" );
	return inrange;
}

shootnearest_non_hero_friend()
{
	ai = getaiarray( "allies" );
	newai = [];
	for ( i = 0; i < ai.size; i++ )
		if ( !isdefined( ai[ i ].magic_bullet_shield ) || !ai[ i ].magic_bullet_shield )
			newai[ newai.size ] = ai[ i ];
			
	if ( !newai.size )
		return;
	nearest = getClosest( level.player.origin, newai );
	shootspotoncewithmissile( nearest gettagorigin( "J_Head" ) );
}

shootspotoncewithmissile( origin )
{
	spot = spawn( "script_model", origin );
	spot.oldmissiletype = false;
	spot.script_attackmetype = "missile";
	spot.shotcount = 1;
	self thread shootEnemyTarget( spot );
	spot waittill( "shot_at" );
	spot delete();
}

shootEnemyTarget( eTarget, delay )
{
	if ( !isdefined( delay ) )
		delay = 0;
	self endon( "death" );
	self endon( "mg_off" );
	eTarget endon( "death" );
	self endon( "gunner_new_target" );
	self setTurretTargetEnt( eTarget );
	wait delay;
	script_attackmetype = "mg";
	originaltarget = eTarget;
	offshooting = false;
	while ( self.health > 0 )
	{
		if ( level.lock_on_player )
		{
			self setTurretTargetEnt( eTarget );
			eTarget = level.lock_on_player_ent;
		}
		else if ( isdefined( eTarget.offshoot_ent ) ) 
		{
			eTarget = eTarget.offshoot_ent;
			offshooting = true;
		}
		else
		{
			eTarget = originaltarget;
		}
		if ( isdefined( eTarget.script_attackmetype ) )
			script_attackmetype = eTarget.script_attackmetype;
		if ( script_attackmetype == "none" )
			wait .05;
		else if ( script_attackmetype == "mg" )
		{
			self setVehWeapon( "hind_turret" );
			self fireWeapon( "tag_flash" );
			wait 0.05;
		}
		else if ( script_attackmetype == "mg_burst" )
		{
			heli_mg_burst( eTarget );
		}
		else if ( 
							script_attackmetype == "missile" 
							 || script_attackmetype == "missile_old" 
							 || script_attackmetype == "missile_bridgebuster" 
						 )
		{
			missiletype = "hind_FFAR_jeepride";
			if ( script_attackmetype == "missile_bridgebuster" )
				missiletype = "hunted_crash_missile";
				
			if ( script_attackmetype == "missile_old" )
				eTarget.oldmissiletype = true;
				
			self setVehWeapon( missiletype );
			script_shotcount = 6;
			
			if ( isdefined( eTarget.script_shotcount ) )
				script_shotcount = eTarget.script_shotcount;
			self fire_missile( missiletype, script_shotcount, eTarget, .2 );
			eTarget notify( "shot_at" );

			eTarget.script_attackmetype = "mg";
			
			if ( script_attackmetype == "missile_bridgebuster" )
				eTarget.script_attackmetype = "none";
			
			if ( offshooting )
			{
				eTarget = originaltarget;
				offshooting = false;
				
			}
		}
		else
		{
			println( "attackmetype: " + script_attackmetype );
			assertmsg( "check attackmetype" );
		}
	}
}

missile_offshoot()
{
	target = getstruct( self.target, "targetname" );
	self.script_attackmetype = "missile";
	target.offshoot_ent = self;
	self.oldmissiletype = false;
	self.script_shotcount = 1;
	self hide();
}

sound_emitter()
{
	links = get_links();
	trigger = undefined;
	sound = self.script_noteworthy;
	assert( isdefined( sound ) );
	for ( i = 0 ; i < links.size ; i++ )
	{
		trigger = getvehiclenode( links[ i ], "script_linkname" );
		if ( !isdefined( trigger ) )
			continue;
		trigger thread sound_emitter_single( sound );
	}
	self delete();
}

sound_emitter_single( sound )
{
	self waittill( "trigger", vehicle );
	vehicle thread play_sound_on_entity( sound );
}

ambient_setter()
{
	trigger = getvehiclenode( self.target, "targetname" );
	self hide();
	assert( isdefined( trigger ) );
	ambient = self.ambient;
	trigger waittill( "trigger" );
// 	level thread maps\_ambient::activateAmbient( ambient );
	type = ambient;
	level.player setReverb( level.ambient_reverb[ type ][ "priority" ], level.ambient_reverb[ type ][ "roomtype" ], level.ambient_reverb[ type ][ "drylevel" ], level.ambient_reverb[ type ][ "wetlevel" ], level.ambient_reverb[ type ][ "fadetime" ] );
}


whackamole_unload( guy )
{
	self endon( "death" );
	guy endon( "death" );
	self waittill( "unload" );
	guy.desired_anim_pose = undefined;
	guy allowedstances( "crouch", "stand", "prone" );
	guy unlink();
	
}

whackamole( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	self endon( "unload" );
	guy endon( "death" );
	
	if ( !isdefined( self.whackamolecount ) )
		self.whackamolecount = 0;
	if ( !isdefined( self.whackamoleguys ) )
		self.whackamoleguys = [];
		
	guy.whackamole_on = false;	
	if ( !isai( guy ) )
		return;
	thread whackamole_death( guy );
	thread whackamole_unload( guy );
	
	if ( guy.team == "allies" )
	{
		guy.desired_anim_pose = "crouch";	
		guy allowedstances( "crouch" );
		guy thread animscripts\utility::UpdateAnimPose();
		return;
	}
	
	thread orientmodehack_axis( guy );
	
	whackamole_off( guy );
	while ( 1 )
	{
		while ( self.whackamolecount > 2 )
			wait .05;
		whackamole_on( guy );
		wait randomfloatrange( 3, 7 );
		whackamole_off( guy );
		wait randomfloatrange( 3, 5 );
	}
}

whackamole_on( guy )
{

	guy.whackamole_on = true;
	guy.desired_anim_pose = "stand";	
	guy allowedstances( "stand" );
	guy.ignoreall = false;
	guy thread animscripts\utility::UpdateAnimPose();	
	self.whackamolecount++ ;
}

whackamole_off( guy )
{
	self endon( "death" );
	guy endon( "death" );
	guy.whackamole_on = false;
	guy.desired_anim_pose = "crouch";	
	guy.ignoreall = true;
	guy allowedstances( "crouch" );
	guy thread animscripts\utility::UpdateAnimPose();
	guy.bulletsInClip = 0;// make him reload.
	self.whackamolecount -- ;
}

whackamole_death( guy )
{
	if ( guy.team == "allies" )
		return;// allies don't die
	self.whackamoleguys[ self.whackamoleguys.size ] = guy;
	self endon( "death" );
	guy waittill( "death" );
	thread whackamole_dialog();
	self.whackamoleguys = array_remove( self.whackamoleguys, guy );
	self.whackamolecount -- ;

	if ( !isdefined( guy ) )
		return;
	
	guy waittillmatch( "deathanim", "start_ragdoll" );	
	guy unlink();
	guy thread ragdollragdollragdollragdollragdollragdoll();// damnit work you
	
	thread dropspeedbump( guy.origin, self );

}

whackamole_dialog()
{
	if ( !isdefined( level.whackamole_lastspeak ) )
		level.whackamole_lastspeak = gettime() + 3005;
	if ( gettime() < level.whackamole_lastspeak + 10000 )
		return;
	level.whackamole_lastspeak = gettime();
	level notify( "kill_confirm" );

}

dialog_killconfirm()
{
	dialog = [];
	dialog[ dialog.size ] = "jeepride_grg_killfirm";   
	dialog[ dialog.size ] = "jeepride_grg_niceshootin";
	dialog[ dialog.size ] = "jeepride_grg_success";
	dialog[ dialog.size ] = "jeepride_grg_thatsahit";
	dialog[ dialog.size ] = "jeepride_grg_devastation";
	for ( i = 0; i < dialog.size; i++ )
	{
		level waittill( "kill_confirm" );
		level.griggs anim_single_queue( level.griggs, dialog[ i ] );
	}
}

ghetto_tag()
{
		if ( !isdefined( level.ghettotag ) )
			level.ghettotag = [];
		target = getent( self.target, "targetname" );
		assert( isdefined( target ) );
		assert( isdefined( target.model ) );
		if ( !isdefined( level.ghettotag[ target.model ] ) )
			level.ghettotag[ target.model ] = [];
		level.ghettotag[ target.model ][ level.ghettotag[ target.model ].size ] = ghetto_tag_create( target );
		
}

trigger_sparks_on()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread maps\jeepride_fx::apply_ghettotag();
			
	}
}

trigger_sparks_off()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread remove_ghettotag();
			
	}
}

remove_ghettotag()
{
	if ( !isdefined( self.ghettotags ) )
		return;
	array_thread( self.ghettotags, ::deleteme );
	if ( !isdefined( self ) )
		return;
	self.ghettotags = [];
}

// helicopter fires at a moving invisible object, object is made to sync with players ride making things dramatic.
attack_dummy_path()
{
	
// 	path = setup_throwchain( self );
	path = setup_throwchain_dummy_path( self );
	delay = 0;
	if ( isdefined( self.script_delay ) )
		delay = self.script_delay;// nasty.
	trigger = getent( self.script_linkto, "script_linkname" );
	trigger waittill( "trigger", helicopter );

	model = spawn( "script_model", path[ 0 ].origin );
	model setmodel( "fx" );

	if ( getdvar( "jeepride_showhelitargets" ) == "off" )
	 	model hide();
	 	
	model notsolid();
	model.oldmissiletype = false;
	helicopter endon( "gunner_new_target" );
	helicopter endon( "death" );
	helicopter clearlookatent();
	helicopter setlookatent( model );
	
	// I'm ghetto hacking this.  only handles hind in Jeepride. doin what I need to do to do th e stuff.  get out of my sandbox!
	helicopter thread shootEnemyTarget( model, delay );
	ghetto_animate_through_chain( path, model, 500, true );
	helicopter clearlookatent();
	model delete();
}

rpgers_to_dummy( dummy )
{
	if ( !isdefined( self.rocketmen ) )
		return;
	for ( i = 0; i < self.rocketmen.size; i++ )
	{
		assert( isdefined( self.rocketmen[ i ].rocketattachpos ) );
		animpos = anim_pos( self, self.rocketmen[ i ].rocketattachpos );
		self.rocketmen[ i ] unlink();
		self.rocketmen[ i ] linkto( dummy, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

fliptruck_ghettoanimate()
{
	throwchain = setup_throwchain( self );
	vehiclenode =  getvehiclenode( self.script_linkto, "script_linkname" );
	previous_vehiclenode = getvehiclenode( vehiclenode.targetname, "target" );
	assert( isdefined( previous_vehiclenode ) );
	previous_vehiclenode waittill( "trigger", truck );
	time = gettime();
	prevorg = truck.origin;
	vehiclenode waittill( "trigger", truck );
	timediff = ( gettime() - time ) / 1000;
	dist = distance( prevorg, truck.origin );
	rate = dist / timediff;

	// todo copy collmap and apply it to the dummy for better physics.
	
	
	
	dummy = truck maps\_vehicle::vehicle_to_dummy();
	truck junk_to_dummy( dummy );
	truck rpgers_to_dummy( dummy );
	truck notify ("kill_treads_forever");
	if ( truck == level.playersride )
	{
		level.player unlink();
		level.player playerlinktodelta( level.playerlinkmodel, "polySurface1", level.playerlinkinfluence );
	}
	
	if(isdefined( level.fxplay_model ))
		truck thread junk_throw();
	dummy notsolid();
	
	array_thread( truck.riders, ::killthrow );
	if ( isdefined( truck.whackamoleguys ) )
		array_thread( truck.whackamoleguys, ::killthrow );
		
	if ( isdefined( truck.magic_missile_guy ) )
		truck.magic_missile_guy thread killthrow();
	waittillframeend;// lets vehicle script remove the guy
	if ( ! animated_crash( dummy, rate, truck ) )
		truck ghetto_animate_through_chain( throwchain, dummy, rate );

	truck remove_ghettotag();
}

animated_crash( dummy, rate, nondummy )
{
	if ( 
		 ! isdefined( self.script_parameters ) || 
		  ! isdefined( level.jeepride_crash_anim ) || 
		 ! isdefined( level.jeepride_crash_anim[ self.script_parameters ] ) 
		 )
			return false;
			
	if ( isdefined( level.jeepride_crash_model[ self.script_parameters ] ) )
	{
		angles = dummy.angles;
		origin = dummy.origin;
		dummy = spawn( "script_model", origin );
		dummy.angles = angles;
		olddummy = dummy;
		dummy setmodel( level.jeepride_crash_model[ self.script_parameters ] );
		
		assert( isdefined( level.jeepride_crash_animtree[ self.script_parameters ] ) );
		dummy useanimtree( level.jeepride_crash_animtree[ self.script_parameters ] );
		
		olddummy move_ghettotags_here( dummy );
		nondummy delete();// kills the vehicle and the dummy
	}
		
	dummy movewithrate( self.origin, self.angles, rate );
	flagName = "crashanim";
	dummy thread animated_crashtracks( flagName );
// 	dummy animscripted( flagName, node.origin, node.angles, level.jeepride_crash_anim[ node.script_noteworthy ] );
	dummy animscripted( flagName, self.origin, self.angles, level.jeepride_crash_anim[ self.script_parameters ] );
	dummy waittillmatch( flagName, "end" );
	return true;
}

animated_crashtracks( flagName )
{
	crash_tracks_func = [];
	crash_tracks_func[ "slide" ] = ::crashtrack_note_slide;
	crash_tracks_func[ "breakwall" ] = ::crashtrack_note_breakwall;
	crash_tracks_func[ "splash" ] = ::crashtrack_note_splash;
	
	for ( ;; )
	{
		self waittill( flagName, note );
		if ( isdefined( crash_tracks_func[ note ] ) )
			[[ crash_tracks_func[ note ] ]]();
		if ( note == "end" )
			break;
	}
}

crashtrack_note_slide()
{
	self playsound( "vehicle_skid_long" );
}

crashtrack_note_breakwall()
{
	PlayFX( level._effect[ "truck_busts_pillar" ], self gettagorigin( "tag_wheel_front_left" ), anglestoforward( self.angles ), anglestoup( self.angles ) );
	exploder( 4 );
}

crashtrack_note_splash()
{
	exploder( 2 );
}



fire_missile( weaponName, iShots, eTarget, fDelay )
{
	self endon( "death" );
	self endon( "gunner_new_target" );
	
	if ( level.lock_on_player )
		eTarget = level.lock_on_player_ent;
	
	eTarget endon( "death" );
	if ( !isdefined( iShots ) )
		iShots = 1;
	assert( self.health > 0 );
	
	if ( self.vehicletype == "hind" )
	{
		tags[ 0 ] = "tag_missile_left";
		tags[ 1 ] = "tag_missile_right";
	}
	else
	{
		tags[ 0 ] = "tag_store_L_2_a";
		tags[ 1 ] = "tag_store_R_2_a";		
		tags[ 2 ] = "tag_store_L_2_b";
		tags[ 3 ] = "tag_store_R_2_b";
		tags[ 4 ] = "tag_store_L_2_c";
		tags[ 5 ] = "tag_store_R_2_c";
		tags[ 6 ] = "tag_store_L_2_d";
		tags[ 7 ] = "tag_store_R_2_d";
	}
	
	
	weaponShootTime = weaponfiretime( weaponName );
	assert( isdefined( weaponShootTime ) );
	self setVehWeapon( weaponName );
	nextMissileTag = -1;
	originaltarget = eTarget;
	
	for ( i = 0 ; i < iShots ; i++ )
	{
		if ( level.lock_on_player )
			eTarget = level.lock_on_player_ent;
		else
			eTarget = originaltarget;
		nextMissileTag++ ;
		if ( nextMissileTag >= tags.size )
			nextMissileTag = 0;
		eMissile = self fireWeapon( tags[ nextMissileTag ] );
		if ( weaponname == "hunted_crash_missile" )
			eMissile thread maps\jeepride::blown_bridge( eTarget ); 
		if ( !isdefined( eMissile ) )
			continue;// TODO: I should find out why.  there's no apparent reason. maybe I'm firing too many?
			
		if ( isdefined( eTarget.vehicletype ) && eTarget.vehicletype == "hind" )
			eMissile missile_settarget( eTarget, ( 0, 0, -56 ) );
		else if ( eTarget.oldmissiletype )
			eMissile missile_settarget( eTarget, ( 80, 20, -200 ) );
		else
			eMissile missile_settarget( eTarget );
		if ( i < iShots - 1 )
			wait weaponShootTime;
		if ( isdefined( fDelay ) )
			wait( fDelay );
	}
}

// view_magnet()
// {
// 		org_ent = spawn( "script_origin", level.player.origin );
// 		self waittill( "trigger", other );
// 		level notify( "new_magnet" );
// 		level endon( "new_magnet" );
// 		org_ent thread magnet_endon();
// 		
// 		org_ent.origin = level.player geteye();
// 		org_ent.angles = level.player getplayerangles();
// 		
// 		dest_angle = vectortoangles( vectornormalize( ( other.origin + ( 0, 0, 48 ) ) - org_ent.origin ) );
// 		
// 		waittime = .5;
// 		org_ent rotateto( dest_angle, waittime, .2, .2 );
// 		incs = int( waittime / .05 );	
// 		for ( i = 0 ; i < incs ; i++ )
// 		{
// 				level.player setplayerangles( org_ent.angles );
// 				wait .05;
// 		}
// }


script_playerlink_org()
{
	if ( isdefined( level.player.script_linker_model ) )
		return level.player.script_linker_model;
	level.player.script_linker_model = spawn( "script_model", level.player.origin );
	level.player.script_linker_model setmodel( "axis" );
	return level.player.script_linker_model; 
}

view_turn( dest_origin, bLink )
{
	bLink = true;
	playerlinkorg = script_playerlink_org();
	playerlinkorg.angles = level.player getplayerangles();
	org_ent = spawn( "script_origin", level.player.origin );
	org_ent.origin = level.player geteye();
	org_ent.angles = level.player getplayerangles();
	level.player PlayerLinkToAbsolute( playerlinkorg, "polySurface1" );
	
	dest_angle = vectortoangles( vectornormalize( dest_origin  - org_ent.origin ) );
	
	waittime = .5;
	playerlinkorg rotateto( dest_angle, waittime, .2, .2 );
// 	incs = int( waittime / .05 );	
// 	for ( i = 0 ; i < incs ; i++ )
// 	{
// 		playerlinkorg rotateto( ;
// 		wait .05;
// 	}	
}

delaythread_loc( delay, sthread, param1, param2, param3, param4 )
{
	delay *= 1000;
	
	if ( level.startdelay != 0 && level.startdelay  > delay )
		return;// this event has passed in the wip start point.
	while ( gettime() + level.startdelay < delay )
		wait .05;
	if ( isdefined( param4 ) )
		thread [[ sthread ]]( param1, param2, param3, param4 );
	else if ( isdefined( param3 ) )
		thread [[ sthread ]]( param1, param2, param3 );
	else if ( isdefined( param2 ) )
		thread [[ sthread ]]( param1, param2 );
	else if ( isdefined( param1 ) )
		thread [[ sthread ]]( param1 );
	else
		thread [[ sthread ]]();
}

// magnet_endon()
// {
// 	level waittill( "new_magnet" );
// 	self delete();
// }

jeepride_start_dumphandle()
{
	button1 = "h";
	button2 = "CTRL";
	while ( 1 )
	{
		while ( ! twobuttonspressed( button1, button2 )  )
			wait .05;
			while ( !jeepride_start_dump() )
				wait.05;
		while ( twobuttonspressed( button1, button2 ) )
			wait .05;
	}
}

get_vehicles_with_spawners()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	spawned_vehicles = [];
	for ( i = 0;i < vehicles.size;i++ )
		if ( isdefined( vehicles[ i ].spawner_id ) && isdefined( vehicles[ i ].currentnode ) )
			spawned_vehicles[ spawned_vehicles.size ] = vehicles[ i ];
	return spawned_vehicles;		
}

jeepride_start_dump( startname )
{
	
	if ( !isdefined( startname ) )
		startname = "wip";
	spawned_vehicles = [];
 /#
	freezeframed_vehicles = get_vehicles_with_spawners();
	
	// freezeframe the vehicles because fileprint requires some frames.
	for ( i = 0;i < freezeframed_vehicles.size;i++ )
	{
		struct = spawnstruct();
		struct.vehicletype = freezeframed_vehicles[ i ].vehicletype;
		struct.origin = freezeframed_vehicles[ i ].origin;
		struct.angles = freezeframed_vehicles[ i ].angles;
		struct.currentnode = freezeframed_vehicles[ i ].currentnode;
		struct.detouringpath = freezeframed_vehicles[ i ].detouringpath;
		struct.target = freezeframed_vehicles[ i ].target;
		struct.targetname = freezeframed_vehicles[ i ].targetname;
		struct.script_forceyaw = freezeframed_vehicles[ i ].script_forceyaw;// remove me when models are rigged
		struct.spawner_id = freezeframed_vehicles[ i ].spawner_id;
		struct.speedmph = freezeframed_vehicles[ i ] getspeedmph();
		struct.ghettomodel_obj = freezeframed_vehicles[ i ].ghettomodel_obj;
		struct.script_angles = freezeframed_vehicles[ i ].script_angles;
		spawned_vehicles[ i ] = struct;
	}

	// break if detouring oddlike
	for ( i = 0;i < spawned_vehicles.size;i++ )
	{
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		targetnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		if ( !isdefined( targetnode ) )
			continue;
		if ( isdefined( targetnode.detoured ) )
			return false;
	}	
	starttime = string( gettime() + level.startdelay );

	// starts a map with a header and a blank worldspawn
	fileprint_map_start( level.script + "_dumpstart_" + startname );
	
	if ( !isdefined( level.start_dump_index ) )
		level.start_dump_index = 0;

	for ( i = 0;i < spawned_vehicles.size;i++ )
	{
		if ( spawned_vehicles[ i ] ishelicopter() )
			continue;// no helicopters in quickstarts yet.  I'm too scared of them. I should be able to use some sort of setspeed immediate but they won't be as close to accurate I don't think.
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		level.start_dump_index++ ;
		target = "dumpstart_node_target_" + level.start_dump_index;
		// vectors print as( 0, 0, 0 ) where they need to be converted to "0 0 0" for radiant to know what's up
		origin = fileprint_radiant_vec( spawned_vehicles[ i ].origin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "script_delay", starttime );
			fileprint_map_keypairprint( "spawnflags", "1" );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", "dumpstart_node" );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			fileprint_map_keypairprint( "target", target );
			fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			if ( isdefined( spawned_vehicles[ i ].ghettotags ) )
				fileprint_map_keypairprint( "script_ghettotag", "1" );
			fileprint_map_keypairprint( "lookahead", ".2" );// static lookahead for the short duration of the path shouldn't put it too out of sync
			fileprint_map_keypairprint( "speed", spawned_vehicles[ i ].speedmph  );
			fileprint_map_keypairprint( "script_noteworthy", startname );
		fileprint_map_entity_end();

		// project a node towards the next node in the chain for an onramp
		if ( isdefined( spawned_vehicles[ i ].detouringpath ) )
			nextnode = spawned_vehicles[ i ].detouringpath;
		else
			nextnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		origin = spawned_vehicles[ i ].origin;
		vect = vectornormalize( nextnode.origin - origin );
		nextorigin = origin + vector_multiply( vect, distance( origin, nextnode.origin ) / 5 ); 
// 		nextorigin = nextnode.origin; 

		origin = fileprint_radiant_vec( nextorigin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", target );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			// fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			fileprint_map_keypairprint( "script_noteworthy", nextnode.targetname );
		fileprint_map_entity_end();
		
	}
	fileprint_end();
#/ 
	iprintlnbold( "start: " + startname + " dumped!" );
	return true;
}

origintostring( origin )
{
	string = "" + origin[ 0 ] + " " + origin[ 1 ] + " " + origin[ 2 ] + "";
	return string;
}

sync_vehicle()
{
	spawner = level.vehicle_spawners[ self.spawner_id ];
	
	node = self;
	targetnode = getvehiclenode( self.target, "targetname" );
	
	vehicle = vehicle_spawn( spawner );

	vehicle notify( "newpath" );
	vehicle.origin = self.origin + ( 0, 0, 555 );
	vehicle.angles = self.angles;
	vehicle attachpath( node );
	vehicle startpath();
	if ( isdefined( node.script_ghettotag ) )
		vehicle maps\jeepride_fx::apply_ghettotag();
	if ( isdefined( node.script_delay ) )
		level.startdelay = node.script_delay;
	detournode = getvehiclenode( targetnode.script_noteworthy, "targetname" );
	vehicle setswitchnode( targetnode, detournode );
	vehicle.attachedpath = detournode;
	vehicle thread vehicle_paths();
}



hillbump()
{
	// gag script for simulating bumps going down the hill
	self waittill( "trigger", other );
	other notify( "newjolt" );
	other endon( "newjolt" );
	other endon( "death" );
	level.playersride PlayRumbleOnEntity( "tank_rumble" );
	
	thread play_sound_in_space( "jeepride_grassride_thud", level.player.origin, 1 );
	
	for ( i = 0;i < 6 ;i++ )
	{
		other joltbody( ( other.origin + ( 23, 33, 64 ) ), 0.6 );
		if ( other == level.playersride )
			earthquake( .15, 1, level.player.origin, 1000 );
		wait .2 + randomfloat( .2 );
		thread play_sound_in_space( "jeepride_grassride_through", level.player.origin, 1 );
	}
}

bridge_uaz_crash()
{
	node = getvehiclenode( "bridge_uaz_crash", "script_noteworthy" );
	node waittill( "trigger", other );
	other joltbody( other.origin + vector_multiply( anglestoforward( other.angles ), 48 ), 16 );
	thread play_sound_in_space( "jeepride_sideswipe", other.origin, 1 );
	Earthquake( .7, 2, other.origin, 2000 );
}

sideswipe()
{
	// sideswipes from other cars to players car bumping 
	self waittill( "trigger", other );

	other notify( "newjolt" );
	level.playersride notify( "newjolt" );

	other endon( "newjolt" );
	level.playersride endon( "newjolt" );
	
	other joltbody( ( level.playersride.origin + ( 0, 0, 64 ) ), 16 );
	level.playersride joltbody( ( other.origin + ( 0, 0, 64 ) ), 16 );
	dist = distance( other.origin, level.playersride.origin );
	sndorg = vector_multiply( vectornormalize( other.origin - level.playersride.origin ), dist / 2 ) + level.playersride.origin + ( 0, 0, 48 );
	thread play_sound_in_space( "jeepride_sideswipe", sndorg, 1 );
// 	iprintlnbold( "sideswipe" );
	earthquake( .45, 1, level.player.origin, 1000 );
	
	// 	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	level.player PlayRumbleOnEntity( "tank_rumble" );
}

jolter()
{
	// sideswipes from other cars to players car bumping 
	self waittill( "trigger", other );
	other joltbody( ( self.origin + ( 32, 32, 64 ) ), 3.5 );
}


#using_animtree( "generic_human" );   

deleteme()
{
	self delete();
}

speedbumps_setup()
{
	level.speedbumpcurrent = 0;
	level.speedbumps = getentarray( "speedbump", "targetname" );
}

dropspeedbump( origin, ignoreent )
{
	if ( level.flag[ "end_ride" ] )
		return;
	level.speedbumpcurrent++ ;
	if ( level.speedbumpcurrent >= level.speedbumps.size )
		level.speedbumpcurrent = 0;
	groundpos = bullettrace( origin + ( 0, 0, -32 ), ( origin + ( 0, 0, -100000 ) ), 0, ignoreent )[ "position" ];
// 	thread	draw_arrow_time( groundpos, groundpos + ( 0, 0, 25 ), ( 1, 1, 1 ), 5 );
	wait .5;// give time for truck they are riding to go.
	level.speedbumps[ level.speedbumpcurrent ].origin = groundpos + ( 0, 0, 4 );
}

// assure ragdoll. somehow ragdoll fails to initialize. 
// I suspect the unlink() and ragdoll at the same time isn't working.
ragdollragdollragdollragdollragdollragdoll() 
{
	self endon( "death" ); 
	while ( isdefined( self ) )
	{
		assert( !isdefined( self.magic_bullet_shield ) );
		assert( !ishero() );
		wait .05;
		self startragdoll();
	}
}

fx_wait_set( time, origin, angles, effectID, tag )
{
	tag = "polySurface1";// using axis model . may use other models later on
	// delay was suffering some roundoff issues I believe. storing and comparing gettime is more accurate that setting a delay on each effect
	if ( time < level.startdelay )
		return; 
	while ( gettime() + level.startdelay < time )
		wait .05;
	setfxplayer();
	level.fxplay_model.origin = origin;
	level.fxplay_model.angles = angles;
	playfxontag( level._effect[ effectID ], level.fxplay_model, tag );
}

createfxplayers( amount )
{
	level.Fxplay_model_array = [];
	level.Fxplay_index = 0;
	level.Fxplay_indexmax = amount;
	for ( i = 0 ; i < amount ; i++ )
	{
		model = spawn( "script_model", ( 0, 0, 0 ) );
		model setmodel( "axis" );
		model hide();
		level.Fxplay_model_array[ i ] = model;
	}
	return setfxplayer();
}

setfxplayer()
{
	level.fxplay_model = level.Fxplay_model_array[ level.Fxplay_index ];
	level.Fxplay_index++ ;
	if ( level.Fxplay_index >= level.Fxplay_indexmax )
		level.Fxplay_index = 0;
}


exploder_hack()
{
	if ( !isdefined( self.target ) )
		return;
	exploder = self.script_exploder;
	trigger = undefined;
	targets = getentarray( self.target, "targetname" );
	for ( i = 0; i < targets.size; i++ )
	{
		if ( targets[ i ].classname == "trigger_damage" )
			trigger = targets[ i ];
		break;
	}
	if ( !isdefined( trigger ) )
		return;
	trigger waittill( "trigger" );
	exploder_loc( exploder );
}

exploder_loc( exploder, bFast )
{
	if ( isdefined( bFast ) && bFast )
		level.exploder_fast[ exploder ] = true;
		
	level notify( "exploded_" + exploder );
	exploder( exploder );
}



exploder_animate()
{
	if ( !isdefined( self.target ) )
		return;
	assert( isdefined( self.script_exploder ) || isdefined( self.script_prefab_exploder ) );
	exploder = self.script_exploder;
	if ( !isdefined( exploder ) )
		exploder = self.script_prefab_exploder;
	exploder_linktargets();
	target = getstruct( self.target, "targetname" );
	if ( !isdefined( target ) )
		return;
	self.target = undefined;
	throwchain = setup_throwchain( target ); 
	
	level waittill( "exploded_" + exploder );
	linkent = spawn( "script_model", target.origin );
	assert( isdefined( target.angles ) );
	linkent.angles = target.angles;
	self linkto( linkent );
	
	exploder_showlinks();

// 	ghetto_animate_through_chain( throwchain, dummy, rate, nodelay, bFast )
	bFast = false;
	if ( isdefined( level.exploder_fast[ exploder ] ) && level.exploder_fast[ exploder ] )
		bFast = true;
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "movekiller" )
		self thread enable_move_killer();
	ghetto_animate_through_chain( throwchain, linkent, undefined, undefined, bFast );
	self disable_move_killer();
}

disable_move_killer()
{
	self notify( "stop_move_killer" );	
}

enable_move_killer()
{
	self endon( "stop_move_killer" );	
	
	while ( 1 )
	{
		if ( level.player istouching( self ) )
		{
			level.player enableHealthShield( false );
			radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
			level.player enableHealthShield( true );
		}
		wait .05;
	}
}

exploder_showlinks()
{
	if ( ! self.linkedtargets.size )
		return;
		
	for ( i = 0; i < self.linkedtargets.size; i++ )
	{
		self.linkedtargets[ i ] show();
	}
}


exploder_linktargets()
{
	targets = getentarray( self.target, "targetname" );
	for ( i = 0; i < targets.size; i++ )
	{
		if ( targets[ i ].classname != "script_model" )
			continue;  
		targets[ i ] linkto( self );
		targets[ i ] hide();
	}
	self.linkedtargets = targets;
}


smokey_transition( intime, outtime, fullalphatime )
{
// 		overlay = newHudElem();
// 		overlay.x = 10;
// 		overlay.y = 0;
// 		overlay.alignx = "center";
// 		overlay.aligny = "middle";
// 		overlay.horzAlign = "center";
// 		overlay.vertAlign = "middle";
// 		scale = 40;
// 		overlay setshader( "jeepride_smoke_transition_overlay", scale, scale );
  						
// 	throwdown grid of solid particles.						
		spacing = 100;
		gridsize = 2;
		sort = 1;
		
		startref = ( ( gridsize - 1 ) / 2 * spacing * - 1 );
		for ( i = 0; i < gridsize ; i++ )
		for ( j = 0; j < gridsize ; j++ )
		{
			xpos = startref + i * spacing;
			ypos = startref + j * spacing;
			thread smoke_transition_elem( xpos, ypos, intime, outtime, fullalphatime, 1, sort );
			sort++ ;
		}

		// grid of transparentparticles.
		spacing = 90;
		gridsize = 3;
		
		startref = ( ( gridsize - 1 ) / 2 * spacing * - 1 );
		for ( i = 0; i < gridsize ; i++ )
		for ( j = 0; j < gridsize ; j++ )
		{
			xpos = startref + i * spacing;
			ypos = startref + j * spacing;
			thread smoke_transition_elem( xpos, ypos, intime, outtime, fullalphatime, randomfloatrange( .1, .8 ), sort );
			sort++ ;
		}


}

smoke_transition_elem( x, y, intime, outtime, fullalphatime, startalpha, sort )
{
	
		overlay = newHudElem();
		overlay.sort = sort;
		overlay.x = x;
		overlay.y = y;

		xdir = 1;
		ydir = 1;
		if ( overlay.x > 0 )
			xdir = -1;
		if ( overlay.y > 0 )
			ydir = -1;
		movementx = randomintrange( 200, 1200 ) * xdir;
		movementy = randomint( 200, 1200 ) * ydir;
		initscale = randomfloatrange( 2, 4 );
		scale = randomintrange( 400, 1000 );
		overlay setshader( "jeepride_smoke_transition_overlay", scale, scale );
		
		overlay.alignX = "center";
		overlay.alignY = "middle";
// 		overlay.horzAlign = "fullscreen";
// 		overlay.vertAlign = "fullscreen";
		overlay.horzAlign = "center";
		overlay.vertAlign = "middle";
		overlay.alpha = 0;
		overlay.foreground = true;
		overlay MoveOverTime( intime + outtime + fullalphatime );
		overlay.x += movementx;
		overlay.y += movementy;
		destscale = randomfloatrange( 4, 6 );
		scale = int( scale * destscale );
		if ( scale > 1000 )
			scale = 1000;
		overlay scaleovertime( intime + outtime + fullalphatime, scale, scale );	
		overlay fadeovertime( intime );
		overlay.alpha = startalpha;
		wait intime + fullalphatime;
		overlay fadeovertime( outtime );
		overlay.alpha = 0;
		wait outtime;
		overlay destroy();
		
}

// clears the model angles value for variable savings.
setup_throwchain_dummy_path( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	while ( isdefined( pathpoint ) )
	{
		chain[ arraycount ] = pathpoint; 
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 
		if ( isdefined( pathpoint.target ) )
			pathpoint = getstructarray( pathpoint.target, "targetname" )[ 0 ];
		else
			break; 
	}
	for ( i = 0; i < pathpoints.size; i++ )
		pathpoints[ i ] setup_throwchain_dummy_path_clearjunkvars();

	return pathpoints;	
}

setup_throwchain_dummy_path_clearjunkvars()
{
	self.angles = undefined;
	self.model = undefined;
// 	level.struct_remove[ level.struct_remove.size ] = self;
}

setup_throwchain( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	while ( isdefined( pathpoint ) )
	{
		if ( !isdefined( pathpoint.angles ) )
			pathpoint.angles = ( 0, 0, 0 );
		chain[ arraycount ] = pathpoint; 
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 
		if ( isdefined( pathpoint.target ) )
			pathpoint = getstructarray( pathpoint.target, "targetname" )[ 0 ];
		else
			break;
	}
	for ( i = 0; i < pathpoints.size; i++ )
		pathpoints[ i ] setup_throwchain_clearjunkvars();
	return pathpoints;
}

setup_throwchain_clearjunkvars()
{
	self.model = undefined;
}

ghetto_animate_through_chain( throwchain, dummy, rate, nodelay, bFast )
{
	if ( !isdefined( bFast ) )
		bFast = false;
	if ( !isdefined( nodelay ) )
		nodelay = false;
	dummy endon( "death" );
	if ( !isdefined( rate ) )
		rate = 500;
	gravity = false;
	if ( bFast )
		nodelay = 1;
	for ( i = 0 ; i < throwchain.size - 1 ; i++ )
	{
		script_accel_fraction = 0;
		script_decel_fraction = 0;
		org = throwchain[ i ];
		dest = throwchain[ i + 1 ];
		dir = 0;
		
		if ( isdefined( org.speed ) )
			rate = org.speed;
		
		endrate = rate;
		
		if ( isdefined( org.script_attackmetype ) )
			dummy.script_attackmetype = org.script_attackmetype;
		else
			dummy.script_attackmetype = undefined;
			
		if ( isdefined( org.offshoot_ent ) )
			dummy.offshoot_ent = org.offshoot_ent;
			
		if ( isdefined( org.script_shotcount ) )
			dummy.script_shotcount = org.script_shotcount;
			
		if ( isdefined( org.script_exploder ) )
			thread exploder_loc( org.script_exploder );
		else if ( isdefined( org.script_prefab_exploder ) )
			thread exploder_loc( org.script_prefab_exploder );


		if ( isdefined( org.script_flag_wait ) )
			flag_wait( org.script_flag_wait );
			
		if ( ! nodelay )
		if ( isdefined( org.script_delay ) )
			wait org.script_delay;
		if ( isdefined( org.script_sound ) )
		{
			if ( isdefined( org.script_parameters ) && org.script_paramters == "in_space" )
				dummy thread play_sound_in_space( org.script_sound, org.origin );
			else
				dummy thread play_sound_on_entity( org.script_sound );
			
		}
		
		if ( isdefined( org.script_noteworthy ) )
		{
			if ( org.script_noteworthy == "gravity" )
				gravity = true;
			
		}
		if ( isdefined( org.script_accel_fraction ) )
			script_accel_fraction = org.script_accel_fraction;
		if ( isdefined( org.script_decel_fraction ) )
			script_decel_fraction = org.script_decel_fraction;
			
// 		println( "speed of ghettoanimated: " + rate );

		angles = ( 0, 0, 0 );
		
		if ( isdefined( dest.angles ) )
			angles = dest.angles;

		if ( bFast )
		{
			dummy.origin = dest.origin;
			dummy.angles = angles;
		}
		else
			dummy movewithrate( dest.origin, angles, rate, endrate, gravity, script_accel_fraction, script_decel_fraction );

		if ( isdefined( dest.script_disconnectpaths ) )
			self script_disconnectpaths( dest.script_disconnectpaths );

		if ( isdefined( dest.script_noteworthy ) )
		{
			level notify( dest.script_noteworthy );
			if ( dest.script_noteworthy == "delete" )
			{
				self delete();
				return;
			}
		}
		
		if ( isdefined( dest.script_flag_set ) )
			flag_set( dest.script_flag_set );
		
	}
}

script_disconnectpaths( script_disconnectpaths )
{
	if ( self.classname == "script_model" )
		return;
	if ( script_disconnectpaths )
	{
		self connectpaths();
		self disconnectpaths();
	}
	else
		self connectpaths();
}

bridge_bumper()
{
	bridgebumper = spawn( "script_origin", level.player.origin );
	bridgebumper linkto( level.player );
	
	while ( 1 )
	{
		level waittill( "bridge_bump" );
		bridgebumper PlayRumbleOnEntity( "tank_rumble" );
		earthquake( .15, 1, level.player.origin, 1000 );
	}
}
	
movewithrate( dest, destang, moverate, endrate, gravity, accelfraction, decelfraction )
{
	self notify( "newmove" );
	self endon( "newmove" );
	if ( !isdefined( gravity ) )
		gravity = false;
	if ( !isdefined( accelfraction ) )
		accelfraction = 0;
	if ( !isdefined( decelfraction ) )
		decelfraction = 0;
	if ( !isdefined( endrate ) )
		endrate = moverate;
	self.movefinished = false;
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 200;

	dist = distance( self.origin, dest );
	movetime = dist / moverate;
	movevec = vectornormalize( dest - self.origin );

	accel = 0;
	decel = 0;

	if ( accelfraction > 0 )
		accel = movetime * accelfraction;
	if ( decelfraction > 0 )
		decel = movetime * decelfraction;
		
	if ( gravity )
	{
		assert( isdefined( self.velocity ) );
		self movegravity( self.velocity, movetime );
	}
	else
		self moveto( dest, movetime, accel, decel );
		
		
	self rotateto( destang, movetime, accel, decel );
	wait movetime;

	if ( !isdefined( self ) )
		return; 
	self.velocity = vector_multiply( movevec, dist / movetime );
	self.movefinished = true;
}

clear_all_vehicles_but_heros_and_hind()
{
	level notify( "clear_all_vehicles_but_heros" );
	vehicles = getentarray( "script_vehicle", "classname" );
	guystoremove = [];
	for ( i = 0; i < vehicles.size; i++ )
	{
		if ( vehicles[ i ].vehicletype == "hind" )
		{
			self notify( "gunner_new_target" );// clears his firing
			continue;
		}
		riders = vehicles[ i ].riders;
		guystoremove = [];
		for ( j = 0; j < riders.size; j++ )
		{
			if ( riders[ j ] ishero() )
			{
				guystoremove[ guystoremove.size ] = riders[ j ];
				continue;
			}
			if ( isdefined( riders[ j ].magic_bullet_shield ) && riders[ j ].magic_bullet_shield )
				riders[ j ] stop_magic_bullet_shield();
			riders[ j ] delete();
		}
		for ( j = 0; j < guystoremove.size; j++ )
			guy_force_remove_from_vehicle( vehicles[ i ], guystoremove[ j ] );
		vehicles[ i ] vehicle_clear_truckjunk();
		vehicles[ i ] delete();
	}
}

vehicle_clear_truckjunk()
{
	junk = self.truckjunk;
	if ( isdefined( self.jeepride_linked_weapon ) )
		self.jeepride_linked_weapon delete();
	if ( !isdefined( junk ) )
		return;
	array_thread( self.truckjunk, ::deleteme );
	
}

guy_force_remove_from_vehicle( vehicle, guy, origin )
{
	
	vehicle notify( "forcedremoval" );
	vehicle.riders = array_remove( vehicle.riders, guy );
	vehicle.usedPositions[ guy.pos ] = false;
	guy notify( "jumpedout" );
	guy notify( "newanim" );
	if ( isai( guy ) )
		guy allowedstances( "stand", "crouch", "prone" );
	guy.ridingvehicle = undefined;
	guy.drivingVehicle = undefined;
	guy.pos = undefined;
}

startgen()
{
	assert( isdefined( self.script_parameters ) );
	self waittill( "trigger" );
	while ( !jeepride_start_dump( self.script_parameters ) )
		wait.05;
}

ClearEnemy_loc()
{
	self ClearEnemy();
}

tire_deflate()
{
	if ( self.vehicletype != "bm21_troops" )
		return;
	if( flag("end_ride") )	
		return;
	level endon ("end_ride");
	level.tiredefeffectcount = 0;
	self endon ("death");
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		
		if ( !isdefined( tagName ) || !isdefined( modelName ) )
			return;
			
		if ( attacker == level.player && issubstr( tagname, "_wheel" ) )
			thread tire_deflater( direction_vec, point, tagName );
// 	 	iprintlnbold( "hit_tag: " + tagName );
// 	 	iprintlnbold( "hit_model: " + modelName );

	}
}

tire_deflater( direction_vec, point, tagName )
{
	if ( level.tiredefeffectcount > 1 )
		return;
	level.tiredefeffectcount++ ;
	model = spawn( "script_model", point );
	model setmodel( "axis" );
	model hide();
	model playsound( "mtl_steam_pipe_hit" );
// 	model linkto( self, tagName, point - self gettagorigin( tagName ), vectortoangles( direction_vec ) - self gettagangles( tagName )  );
	model linkto( self, tagName, ( 32, 0, 0 ), ( 0, 0, 0 )  );
	self joltbody( ( self.origin + ( 23, 33, 64 ) ), 1 );

	PlayFXOnTag( level._effect[ "tire_deflate" ], model, "polySurface1" );
	wait 3;
	level.tiredefeffectcount -- ;
	model delete();
}


nodisconnectpaths()
{
	self waittill( "trigger", other );
	other.dontDisconnectPaths = true;
}


// ganked from ICBM

vehicle_turret_think()
{
	self endon( "death" );
	self endon( "c4_detonation" );
	self endon( "stop_thinking" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = [];

	aExcluders[ 0 ] = level.price;
	aExcluders[ 1 ] = level.griggs;
	aExcluders[ 2 ] = level.gaz;

	currentTargetLoc = undefined;
	
	// if ( getdvar( "debug_bmp" ) == "1" )
		// self thread vehicle_debug();

	while ( true )
	{
		wait( 0.05 );
		/* -- -- -- -- -- -- -- -- -- -- -- - 
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		if ( ( isdefined( eTarget ) ) && ( eTarget == level.player ) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			if ( !sightTracePassed )
			{
				// self clearTurretTarget();
				eTarget = self vehicle_get_target( aExcluders );
			}
		}

		/* -- -- -- -- -- -- -- -- -- -- -- - 
		ROTATE TURRET TO CURRENT TARGET
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		if ( isalive( eTarget ) )
		{
			targetLoc = eTarget.origin + ( 0, 0, 32 );
			self setTurretTargetVec( targetLoc );
			
			if ( getdvar( "debug_bmp" ) == "1" )
				thread draw_line_until_notify( self.origin + ( 0, 0, 32 ), targetLoc, 1, 0, 0, self, "stop_drawing_line" );
			
			fRand = ( randomfloatrange( 2, 3 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/* -- -- -- -- -- -- -- -- -- -- -- - 
			FIRE MAIN CANNON OR MG
			 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
			if ( isalive( eTarget ) )
			{
				if ( distancesquared( eTarget.origin, self.origin ) <= level.bmpMGrangeSquared )
				{
					if ( !self.mgturret[ 0 ] isfiringturret() )
						self thread maps\_vehicle::mgon();
					
					wait( .5 );
					if ( !self.mgturret[ 0 ] isfiringturret() )
					{
						self thread maps\_vehicle::mgoff();
						if ( !self.turretFiring )
							self thread vehicle_fire_main_cannon();			
					}
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if ( !self.turretFiring )
						self thread vehicle_fire_main_cannon();	
				}				
			}
		}

		// wait( randomfloatrange( 2, 5 ) );
		if ( getdvar( "debug_bmp" ) == "1" )
			self notify( "stop_drawing_line" );
	}
}

vehicle_fire_main_cannon( iBurstNumber )
{
	self endon( "death" );
	self endon( "c4_detonation" );
	// self notify( "firing_cannon" );
	// self endon( "firing_cannon" );
	
	iFireTime = weaponfiretime( "bmp_turret" );
	assert( isdefined( iFireTime ) );
	
	if ( !isdefined( iBurstNumber ) )
		iBurstNumber = randomintrange( 3, 8 );
	
	self.turretFiring = true;
	i = 0;
	while ( i < iBurstNumber )
	{
		i++ ;
		wait( iFireTime );
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_get_target( aExcluders )
{
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false, aExcluders );
	return eTarget;
}

vehicle_badplacer()
{
	target = getvehiclenode( self.target, "targetname" );
	target waittill( "trigger", other );
	radius = 500;
	if ( isdefined( self.radius ) )
		radius = self.radius;
	duration = 3;
	if ( isdefined( self.script_offtime ) )
		duration = self.script_offtime;
	
	BadPlace_Cylinder( "badplacer_" + target.targetname, duration, self.origin, radius, 300, "allies", "axis" );
	
}

path_array_setup_loc( pathpoint )
{
	get_func = ::get_from_entity;
	arraycount = 0;
	pathpoints = [];
	while ( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 

		if ( isdefined( pathpoint.target ) )
			pathpoint = [[ get_func ]]( pathpoint.target );
		else
			break; 
	}
	return pathpoints;
}

stop_looping_deathfx()
{
	deathfx_ent() delete();
}


guy_hidetoback_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).hidetoback );
}

guy_hidetoback_startingback( guy, pos )
{
	animpos = anim_pos( self, pos );
		
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	assert( isdefined( animpos.hidetoback ) );
	animontag( guy, animpos.sittag, animpos.hidetoback );
	thread guy_back_attack( guy, pos );
}


guy_back_attack( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.back_attack ) );
	while ( 1 )
		animontag( guy, animpos.sittag, animpos.back_attack );
}

guy_backtohide_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).backtohide );
}


guy_hide_starting_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.backtohide ) );
		
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_back( guy, pos );	
}

guy_hide_startingleft( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	if ( !isdefined( animpos.backtohide ) )
		return guy_idle( guy, pos );
	
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_left( guy, pos );	
		
}

guy_backtohide( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.backtohide ) );
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_idle( guy, pos );
}


guy_hide_attack_back_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).hide_attack_back );	
}

guy_hide_attack_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.hide_attack_back ) );
		
	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_back_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_back_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_back[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_back );
	}		
}

guy_hide_attack_forward_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).hide_attack_forward );	
}

guy_hide_attack_forward( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_forward ) );

	while ( 1 )
		animontag( guy, animpos.sittag, animpos.hide_attack_forward );
}

guy_hide_attack_left( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_left ) );

	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_left_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_left[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_left );
	}
}

guy_hide_attack_left_standing( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_left_standing ) );
	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_standing_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_left_standing_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_left_standing[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_left_standing );
	}
}

remember_weaponsondeath( other )
{
	if ( !isdefined( self.weapon ) )
		return;
	weapon = [];
	weapon[ 0 ] = "weapon_" + self.weapon;
	
	level.potentialweaponitems = array_merge( level.potentialweaponitems, weapon );
}

remove_all_weapons()
{
	// maybe this should be a made better and into a utility function. as it is here it's a bit too hackeryish.
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_fraggrenade" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_brick_bomb" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_claymore" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_flash_grenade" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_smoke_grenade_american" );
	
	weapontoremove = undefined;
	for ( i = 0; i < level.potentialweaponitems.size; i++ )
	{
		weapontoremove = getentarray( level.potentialweaponitems[ i ], "classname" );
		if ( !weapontoremove.size )
			continue;
		array_levelthread( weapontoremove, ::deleteent );
	}
}

add_death_function( func, param1, param2, param3 )
{
	array = [];
	array[ "func" ] = func;
	array[ "params" ] = 0;
	
	if ( isdefined( param1 ) )
	{
		array[ "param1" ] = param1;
		array[ "params" ]++ ;
	}
	if ( isdefined( param2 ) )
	{
		array[ "param2" ] = param2;
		array[ "params" ]++ ;
	}
	if ( isdefined( param3 ) )
	{
		array[ "param3" ] = param3;
		array[ "params" ]++ ;
	}
	self.deathFuncs[ self.deathFuncs.size ] = array;
}

#using_animtree( "vehicles" );   
freeOnEnd()
{
	if ( level.flag[ "end_ride" ] )
		return;
	self endon( "end_ride" );
	self endon( "no_free_on_end" );
	self waittill( "reached_end_node" );
	self freevehicle();
	self clearanim( %root, 0.5 );
	if ( isdefined( self.modeldummyon ) && self.modeldummyon )
		self hide();
}

detach_models_with_substr( guy, substr )
{
	size = guy getattachsize();
	modelstodetach = [];
	tagsstodetach = [];
	index = 0;
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

hidemeuntilflag()
{
	assert( isdefined( self.script_flag_wait ) );
	self waittill( "trigger", other );
	for ( i = 0; i < other.riders.size; i++ )
		other.riders[ i ] hide();
	other hide();
	flag_wait( self.script_flag_wait );
	other show();
	for ( i = 0; i < other.riders.size; i++ )
		other.riders[ i ] show();
		
		
}

ishero()
{
	return( self == level.price || self == level.griggs || self == level.gaz );
}

crazy_bmp()
{
	self waittill ("trigger",other);
	level.crazy_bmp = other;
	other thread vehicle_turret_think();

}

explode_player()
{
	
}