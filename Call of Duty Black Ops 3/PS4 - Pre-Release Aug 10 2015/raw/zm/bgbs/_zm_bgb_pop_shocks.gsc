#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_lightning_chain;
#using scripts\zm\_zm_utility;

    

                                                                 
                                                                                                                               

#using scripts\shared\ai\systems\gib;

#namespace zm_bgb_pop_shocks;


function autoexec __init__sytem__() {     system::register("zm_bgb_pop_shocks",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}
	
	bgb::register( "zm_bgb_pop_shocks", "event", &event, undefined, undefined, undefined );
	bgb::register_actor_damage_override( "zm_bgb_pop_shocks", &actor_damage_override );
	bgb::register_vehicle_damage_override( "zm_bgb_pop_shocks", &vehicle_damage_override );
}

function event()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "bgb_update" );

	// give the player all the perks in the map
	self.bgb_remaining_hits = 5;

	while( self.bgb_remaining_hits > 0 )
	{
		wait 0.1;
	}

	self bgb::do_one_shot_use();
}

function actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if( meansofdeath === "MOD_MELEE" )
	{
		attacker electric_strike( self );
		attacker.bgb_remaining_hits--;
	}
	
	return damage;
}

function vehicle_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( sMeansOfDeath === "MOD_MELEE" )
	{
		eAttacker electric_strike( self );
		eAttacker.bgb_remaining_hits--;
	}
	
	return iDamage;
}

// self = player
function electric_strike( target )
{
	zombie_list = GetAITeamArray( level.zombie_team );
	foreach( ai in zombie_list )
	{
		if ( !IsDefined( ai ) || !IsAlive( ai ) )
		{
			continue;
		}

		test_origin = ai getcentroid();
		dist_sq = DistanceSquared( target.origin, test_origin );
		if ( dist_sq < 16384 )
		{
			self thread electrocute_actor( ai );
		}
	}
}

// self = player
function electrocute_actor( ai )
{
	self endon( "disconnect" );

	if( !IsDefined( ai ) || !IsAlive( ai ) )
	{
		// guy died on us 
		return;
	}

	if( !isdefined(self.tesla_enemies_hit) )
	{
		self.tesla_enemies_hit = 1;
	}

	create_lightning_params();
	ai.tesla_death = false;
	ai thread arc_damage_init( self );
	ai thread tesla_death();
}

function create_lightning_params()
{
	level.zm_bgb_pop_shocks_lightning_params = lightning_chain::create_lightning_chain_params( 5 );
	level.zm_bgb_pop_shocks_lightning_params.head_gib_chance = 100;
	level.zm_bgb_pop_shocks_lightning_params.network_death_choke = 4;
	level.zm_bgb_pop_shocks_lightning_params.should_kill_enemies = false;
}

// self = ai
function arc_damage_init( player )
{
	player endon( "disconnect" );

	if( ( isdefined( self.zombie_tesla_hit ) && self.zombie_tesla_hit )  )
		return;

	self lightning_chain::arc_damage_ent( player, 1, level.zm_bgb_pop_shocks_lightning_params );
}

// self = ai
function tesla_death()
{
	self endon( "death" );
	self thread zombie_explodes_on_swipe( true );
	wait( 2 );
	self dodamage( self.health+1, self.origin );
}

// self = ai
function zombie_explodes_on_swipe( random_gibs )
{
	self waittill( "death" );
	if ( isdefined(self) && IsActor(self) )
	{
		if( (!random_gibs) || (randomint(100) < 50) )
			gibserverutils::gibhead( self );
		if( (!random_gibs) || (randomint(100) < 50) )
			gibserverutils::gibleftarm( self );
		if( (!random_gibs) || (randomint(100) < 50) )
			gibserverutils::gibrightarm( self );
		if( (!random_gibs) || (randomint(100) < 50) )
			gibserverutils::giblegs( self );
	}
}
