#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth;
#using scripts\shared\clientfield_shared;
#using scripts\cp\_oed;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace stealth_tagging;

/*
	STEALTH - Tagging

 	// FIXME: if we want to keep this the tag detection should be client side
*/

/@
"Name: init()"
"Summary: Initialize tagging on a Player or AI
"Module: Stealth"
"CallOn: A Player entity or Actor entity"
"Example: player stealth_tagging::init();"
"SPMP: singleplayer"
@/
function init( )
{
	/* dedwards 2/26/2015 - stealth_tagging disabled for now
	 
	assert( isDefined( self.stealth ) );

	DEFAULT( self.stealth.tagging, SpawnStruct() );
			
	if ( isPlayer( self ) )
	{
		self.stealth.tagging.range = 3000;
		self.stealth.tagging.tag_fovcos = Cos( 3 );
		self.stealth.tagging.tag_time = 1.0;
		self.stealth.tagging.tag_times = [];
		
		self thread tagging_thread();
	}
	else if ( isActor( self ) )
	{
		self clientfield::set( "tagged", 0 );
	}
	*/
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( self stealth_tagging::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return isDefined( self.stealth ) && isDefined( self.stealth.tagging );
}

/@
"Name: get_tagged()"
"Summary: returns if this entity is tagged or not
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( self stealth_tagging::get_tagged() )"
"SPMP: singleplayer"
@/
function get_tagged( )
{
	return isDefined( self.stealth ) && isDefined( self.stealth.tagging ) && ( isdefined( self.stealth.tagging.tagged ) && self.stealth.tagging.tagged );
}

/@
"Name: tagging_thread()"
"Summary: Monitor for tagging targets"
"Module: Stealth"
"CallOn: A Player entity"
"Example: player thread stealth_tagging::tagging_thread();"
"SPMP: singleplayer"
@/
function tagging_thread()
{
	assert( isPlayer( self ) );
	assert( self stealth_tagging::enabled() );
		
	self endon( "disconnect" );
	
	timeInc = 0.25;

	// stagger threads
	wait ( randomfloatrange( 0.05, 1.0 ) );
	
	while ( 1 )
	{
		if ( self PlayerADS() > 0.3 )
		{
			vec_eye_dir = AnglesToForward( self GetPlayerAngles() );
			vec_eye_pos = self GetPlayerCameraPos();
			rangeSq = self.stealth.tagging.range * self.stealth.tagging.range;
			
			trace = BulletTrace( vec_eye_pos, vec_eye_pos + (vec_eye_dir * 32000), true, self );
			
			foreach ( enemy in level.stealth.enemies[self.team] )
			{			
				if ( !isDefined( enemy ) || !isAlive( enemy ) )
					continue;

				if ( !enemy stealth_tagging::enabled() || ( isdefined( enemy.stealth.tagging.tagged ) && enemy.stealth.tagging.tagged ) )
					continue;
				
				if( !isActor( enemy ) )
					continue;

				enemyEntNum = enemy GetEntityNumber();
				bDirectAiming = isDefined( trace["entity"] ) && trace["entity"] == enemy;
				bBroadAiming = false;
				
				if ( !bDirectAiming )
				{
					distSq = DistanceSquared( enemy.origin, vec_eye_pos );
					vec_enemy_dir = VectorNormalize( (enemy.origin + (0, 0, 30)) - vec_eye_pos );	
					if ( distSq < rangeSq && VectorDot( vec_enemy_dir, vec_eye_dir ) > self.stealth.tagging.tag_fovcos )
						bBroadAiming = self tagging_sight_trace( vec_eye_pos, enemy );
				}
				
				if ( bDirectAiming || bBroadAiming )
				{
					if ( !isDefined( self.stealth.tagging.tag_times[enemyEntNum] ) )
						self.stealth.tagging.tag_times[enemyEntNum] = 0.0;
					self.stealth.tagging.tag_times[enemyEntNum] += (1.0 / self.stealth.tagging.tag_time) * timeInc;
					
					if ( self.stealth.tagging.tag_times[enemyEntNum] >= 1.0 )
					{
						if ( isPlayer( self ) )
							self playsoundtoplayer( "uin_gadget_fully_charged", self );
						enemy thread tagging_set_tagged( true );
					}
					
					continue;
				}
				
				if ( isDefined( self.stealth.tagging.tag_times[enemyEntNum] ) )
					self.stealth.tagging.tag_times[enemyEntNum] = undefined;
			}
		}
		
		wait timeInc;
	}
}

function tagging_set_tagged( tagged )
{
	if ( isAlive( self ) )
	{
		self oed::set_force_tmode( tagged );

		if ( isdefined( self.stealth ) && isdefined( self.stealth.tagging ) )
		{
			if ( !tagged ) 
				self.stealth.tagging.tagged = undefined;
			else
				self.stealth.tagging.tagged = tagged;
		}
		
		self clientfield::set( "tagged", tagged );
	}
}

/@
"Name: tagging_sight_trace( vec_eye_pos, enemy )"
"Summary: Tests if enemy can be seen from given point"
"Module: Stealth"
"CallOn: A Player entity"
"Example: if ( player stealth_tagging::tagging_sight_trace( eye, aiGuy ) )"
"SPMP: singleplayer"
@/
function tagging_sight_trace( vec_eye_pos, enemy )
{
	result = false;
		
	if ( isActor( enemy ) )
	{
		if ( !result && SightTracePassed( vec_eye_pos, enemy GetTagOrigin( "j_head" ), false, self ) )
			result = true;
		
		if ( !result && SightTracePassed( vec_eye_pos, enemy GetTagOrigin( "j_spinelower" ), false, self ) )
			result = true;
	}
	
	if ( !result && SightTracePassed( vec_eye_pos, enemy.origin, false, self ) )
		result = true;
	
	return result;
}

