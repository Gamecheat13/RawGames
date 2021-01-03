#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

    

                                                                 
                                                                                                                               

#namespace zm_bgb_killing_time;


function autoexec __init__sytem__() {     system::register("zm_bgb_killing_time",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_killing_time", "activated", 1, undefined, undefined, &validation, &activation );
	bgb::register_actor_damage_override( "zm_bgb_killing_time", &actor_damage_override );
	
	clientfield::register( "actor",		"zombie_instakill_fx",		1, 1, "int" );
	clientfield::register( "toplayer",	"instakill_upgraded_fx",	1, 1, "int" );
}

function activation()
{
	// this does the slowdown
	self instakill_upgraded_think();
	self bgb::do_one_shot_use();
}

// only allow activation if we aren't already mid-activation
function validation()
{
	foreach( player in level.players )
	{
		if( IsDefined( self.bzm_instakillAIBucket ) )
			return false;
	}
	
	return true;
}

// ----------------------
// On Actor Damage Callback
//-----------------------
function private actor_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	// don't affect non-zombies
	if( self.archetype !== "zombie" )
	{
		return iDamage;
	}

	if( IsPlayer( eAttacker ) && ( isdefined( eAttacker.forceAnhilateOnDeath ) && eAttacker.forceAnhilateOnDeath ) )
	{
		if( ( isdefined( eAttacker.bzm_forceKeepAIAlive ) && eAttacker.bzm_forceKeepAIAlive ) )
		{
			self.health = self.health + iDamage + 1;			
			
			assert( IsDefined( eAttacker.bzm_instakillAIBucket ) );
			       
			if( !IsInArray( eAttacker.bzm_instakillAIBucket, self ) )
			{
				eAttacker.bzm_instakillAIBucket[eAttacker.bzm_instakillAIBucket.size] = self;
			}
		}
		else 
		{
			self clientfield::set("zombie_instakill_fx", 1);
			return (self.health + 1);
		}
	}
	
	return iDamage;
}

function instakill_upgraded_think() // self = player
{
	self endon("death");
	
	assert( !IsDefined( self.bzm_instakillAIBucket ) );
	
	foreach( player in level.players )
	{
		player clientfield::set_to_player("instakill_upgraded_fx", 1);
	}
	
	self.bzm_instakillAIBucket = [];
	self.forceAnhilateOnDeath = true;	
		
	SetSlowMotion( 1, 0.7, 2 );
	
	wait 2; // wait for slow motion to kick in
	
	self.bzm_forceKeepAIAlive	= true;	
	level.bzm_worldPaused	= true;
	SetPauseWorld( true );
	
	wait 20;
		
	self.bzm_forceKeepAIAlive	= false;	
	level.bzm_worldPaused	= false;
	SetPauseWorld( false );
		
	foreach( player in level.players )
	{
		self clientfield::set_to_player("instakill_upgraded_fx", 0);
	}
	
	foreach( ai in self.bzm_instakillAIBucket )
	{
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai ASMSetAnimationRate( 0.1 );
		}
	}
		
	startTime = 0.8;
	
	for( i = self.bzm_instakillAIBucket.size - 1; i >= 0; i-- )
	{	
		ai = self.bzm_instakillAIBucket[i];
		
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai DoDamage( ai.health + 1, self.origin, self );
			startTime = startTime - 0.1;
			
			if( startTime <= 0 )
				startTime = 0;
			
			wait startTime;
		}	
	}

	SetSlowMotion( 0.7, 1, 2 );	
		
	self.bzm_instakillAIBucket = undefined;	
	self.forceAnhilateOnDeath = false;
}
