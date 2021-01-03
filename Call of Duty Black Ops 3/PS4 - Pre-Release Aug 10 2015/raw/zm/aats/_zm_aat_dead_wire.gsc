#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\gib;
#using scripts\zm\_zm_altbody_beast;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                             	     	                                                                                                                                                                

#using scripts\zm\_zm_utility;

                                                            	

                                                                                                                               

#precache( "material", "t7_hud_zm_aat_dead_wire" );

#namespace zm_aat_dead_wire;

function autoexec __init__sytem__() {     system::register("zm_aat_dead_wire",&__init__,undefined,"aat");    }

function __init__()
{
	if ( !( isdefined( level.aat_in_use ) && level.aat_in_use ) )
	{
		return;
	}

	aat::register( "zm_aat_dead_wire", 0.25, 1, 1, true, &result, "t7_hud_zm_aat_dead_wire", "wpn_aat_dead_wire_plr" );

	clientfield::register( "actor", "zm_aat_dead_wire", 1, 1, "int" ); 
}


function result( death, attacker, mod, weapon )
{
	if ( ( isdefined( self.aat_immune ) && self.aat_immune ) )
	{
		return;
	}
	
	self dead_wire_zombie_zap_chain( 0 );
}

// Checks to see if zombie can be zapped
// self == zombie
function zombie_can_be_zapped()
{
	if ( self.b_is_zapped === true )
	{
		return false;
	}
	
	if( ( isdefined( self.barricade_enter ) && self.barricade_enter ) )
	{
		return false;
	}
	
	if ( ( isdefined( self.is_traversing ) && self.is_traversing ) )
	{
		return false;
	}

	if( !( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) && !IsDefined( self.first_node ) )
	{
		return false;
	}

	if ( ( isdefined( self.is_leaping ) && self.is_leaping ) )
	{
		return false;
	}
	
	return true;
}

// Manages what zombies get hit by electricity arcs
// self == zombie
function dead_wire_zombie_zap_chain( n_index )
{
	self endon( "death" );
	
	// Calculates chance for arc to be fired
	n_arc_chance = 100 - ( 10 * n_index );
	if ( RandomInt( 100 ) > n_arc_chance )
	{
		return;
	}
	
	// Applies FX and slow on self
	self thread dead_wire_zombie_zap();
	
	n_index++;
	// If max number of arcs have been fired, halt
	if ( n_index == 3 )
	{
		return;
	}
	
	wait .25;
	
	a_ai_zombies = array::get_all_closest( self.origin, GetAIArchetypeArray( "zombie" ), undefined, undefined, 80 );
	if ( !isDefined( a_ai_zombies ) )
	{
		return;
	}
	
	a_ai_zombies = array::randomize( a_ai_zombies );
	foreach ( ai_zombie in a_ai_zombies )
	{
		if ( IsAlive( ai_zombie ) )
		{
			if ( ai_zombie zombie_can_be_zapped() )
			{
				ai_zombie thread dead_wire_zombie_zap_chain( n_index );
				break;
			}
		}
	}	
}

// Applies slow and FX on zombie
// self == zombie who is firing electric bolt
function dead_wire_zombie_zap()
{
	self endon( "death" );
	self notify( "lightning_slow_zombie" );
	self endon( "lightning_slow_zombie" );

	self.b_is_zapped = true; // Ensures target is not zapped twice
	
	self PlaySound( "evt_nuke_flash" );
	num = self GetEntityNumber();
	if(!isdefined(self.beast_slow_count))self.beast_slow_count=0;
	self.beast_slow_count++; 
	
	if(!isdefined(self.animation_rate))self.animation_rate=1.0;

	self.slow_time_left = 1;

	self thread lightning_slow_zombie_fx();
	
	while ( IsDefined( self ) && isalive( self ) && self.animation_rate > .03 )
	{
		self.animation_rate -= ( (1.0 - .03) * ( .05 / .5 ) );
		if (self.animation_rate < .03) {     self.animation_rate = .03;    };
		self ASMSetAnimationRate( self.animation_rate );
		self.slow_time_left -= .05; 
		{wait(.05);}; 
	}

	while ( IsDefined( self ) && isalive( self ) && self.slow_time_left > .25 )
	{
		self.slow_time_left -= .05; 
		{wait(.05);};
	}
	
	while ( IsDefined( self ) && isalive( self ) && self.animation_rate < 1.0 )
	{
		self.animation_rate += ( (1.0 - .03) * ( .05 / .25 ) ); 
		if (self.animation_rate > 1.0) {     self.animation_rate = 1.0;    };
		self ASMSetAnimationRate( self.animation_rate );
		self.slow_time_left -= .05;
		{wait(.05);}; 
	}

	self ASMSetAnimationRate( 1.0 );
	self.slow_time_left = 0;
	self.b_is_zapped = false;
	
	if ( IsDefined(self) )
	{
		self.beast_slow_count--;
	}
}

// Resets animation rate so that zombie bodies aren't held upright after the zombie dies
// self == target zombie
function zombie_zapped_monitor()
{
	self waittill ( "death" );
	
	self ASMSetAnimationRate( 1.0 );
}

// Applies and removes lightning FX on zombies
// self == target zombie
function lightning_slow_zombie_fx()
{
	self thread clientfield::set( "zm_aat_dead_wire", 1 );
	
	util::waittill_any_timeout( self.slow_time_left, "death" );
		
	self thread clientfield::set( "zm_aat_dead_wire", 0 );
}

