#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\stealth_player;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	            	    	   	                           	                               	                                	                                                              	                                                                          	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	              	                  	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                          	                                   	                                   	                                                    	                                    

#namespace stealth_detect;

/*
	STEALTH - Detection System
*/

/@
"Name: init()"
"Summary: Initializes stealth detection for an entity"
"Module: stealth"
"CallOn: Entity"
"Example: self stealth_detect::init();"
@/
function init( )
{
	assert( isDefined( self.stealth ) );
	assert( !isDefined( self.stealth.detect ) );

	if(!isdefined(self.stealth.detect))self.stealth.detect=SpawnStruct();
	
	self.stealth.detect.alert = [];
	self.stealth.detect.can_see = [];
	self.stealth.detect.can_see_any = false;
	self.stealth.detect.aware = [];
	self.stealth.detect.last_update = 0;
}

/@
"Name: enabled()"
"Summary: returns if this system is enabled on the given object
"Module: Stealth"
"CallOn: Entity or Struct"
"Example: if ( stealth_detect::enabled() )"
"SPMP: singleplayer"
@/
function enabled( )
{
	return IsDefined( self.stealth ) && isDefined( self.stealth.detect );
}

/@
"Name: get_alert( <enemy> )"
"Summary: Returns detection alert level for given enemy"
"Module: stealth"
"CallOn: Entity or Struct"
"Example: if ( ai stealth_detect::get_alert( me ) >= 1.0 )"
@/
function get_alert( enemy )
{
	assert( self stealth_detect::enabled() );
	
	enemyEntNum = enemy GetEntityNumber();
	
	if ( isDefined( self.stealth.detect.alert[enemyEntNum] ) )
	    return self.stealth.detect.alert[enemyEntNum];
	   
	return 0.0;	  
}

/@
"Name: set_alert( <enemy>, <alert> )"
"Summary: Returns detection alert level for given enemy"
"Module: stealth"
"CallOn: Entity or Struct"
"Example: ai stealth_detect::set_alert( me, 0.0 );"
@/
function set_alert( enemy, alert )
{
	assert( self stealth_detect::enabled() );

	enemyEntNum = enemy GetEntityNumber();

	self.stealth.detect.alert[enemyEntNum] = max( 0.0, min( 1.0, float( alert ) ) );
}

/@
"Name: can_see( <enemy> )"
"Summary: Returns true if this agent can see the given enemy or any enemy if passed undefined"
"Module: stealth"
"CallOn: Entity or Struct"
"Example: if ( ai stealth_detect::can_see( me ) )"
@/
function can_see( enemy )
{
	assert( self stealth_detect::enabled() );

	if ( !isDefined( self.stealth.detect.can_see ) )
		return false;

	if ( isDefined( enemy ) && isDefined( self.stealth.detect.can_see[enemy getEntityNumber()] ) )
		return self.stealth.detect.can_see[enemy getEntityNumber()];
		
	if ( !isDefined( enemy ) )
		return self.stealth.detect.can_see_any;
		
	return false;
}

/@
"Name: update( <awarenessParms>, <vEyeOrigin>, <vEyeAngles> )"
"Summary: Monitors detection for a given entity for a frame"
"Module: stealth"
"CallOn: Actor"
"Example: self stealth_detect::update();"
@/
function update( awarenessParms, vEyeOrigin, vEyeAngles )
{
	assert( self stealth_detect::enabled() );
	assert( isdefined( self.stealth.enemies ) );

	delta_time = 0;
    	
    parm = awarenessParms;
    detect = self.stealth.detect;
 
	if ( detect.last_update != 0 )
		delta_time = float( GetTime() - detect.last_update ) / 1000.0;
	detect.last_update = GetTime();
    
    alert_dist = parm.alert_dist;
		
    // First find out which enemies we can see
	detect.can_see_any = false;
    foreach ( enemy in self.stealth.enemies )
    {
    	if ( !isDefined( enemy ) )
    		continue;
    	    	
    	distSq = 0;
    	
		enemyEntNum = enemy GetEntityNumber();
		enemyStance = enemy GetStance();
		
		multiplier = parm.stanc_mult[enemyStance];
		if ( !isDefined( multiplier ) )
			multiplier = 1.0;
	    alert_dist_actual_sq = ( alert_dist * multiplier ) * ( alert_dist * multiplier );
		
		detect.can_see[enemyEntNum] = false;
		if ( !isDefined( detect.alert[enemyEntNum] ) )
		    detect.alert[enemyEntNum] = 0;	
		
		vEnemyEye = enemy.origin;
		if ( isPlayer( enemy ) )
			vEnemyEye += ( 0, 0, enemy GetPlayerViewHeight() );
		
		// Check basic existance
		if ( IsAlive( enemy ) && !enemy.ignoreme )
		{
			// Check height diff
			if ( abs( vEyeOrigin[2] - vEnemyEye[2] ) < parm.max_height )
			{
				// Check max alert_dist with multiplier
		    	distSq = DistanceSquared( vEyeOrigin, vEnemyEye );
		    	if ( distSq < alert_dist_actual_sq )
				{
					// Check fov
					v_delta = VectorNormalize( vEnemyEye - vEyeOrigin );
					v_eye = AnglesToForward( (0, vEyeAngles[1], 0) );
					if ( VectorDot( v_delta, v_eye ) > self.fovcosine )
					{
				        // Check if sight is clear from eye to eye
						if ( SightTracePassed( vEyeOrigin, vEnemyEye, false, enemy ) )
						{
							detect.can_see[enemyEntNum] = true;
							detect.can_see_any = true;
						}
					}
				}	        
			}
		}
	
		bCanSee = detect.can_see[enemyEntNum];
						
		if ( bCanSee )
		{
			// Sighting enemy - Faster noticing rate the closer the enemy is (x^2 exponential)
			range_scale = 1.0 - ( distSq / alert_dist_actual_sq );
			sight_rate = parm.sight_rate_max + (parm.sight_rate_min - parm.sight_rate_max) * range_scale;
			detect.alert[enemyEntNum] += sight_rate * delta_time;
		}
		else 
		{
			// Losing sight of enemy
			detect.alert[enemyEntNum] -= parm.sight_lose_rate * delta_time;
		}

		detect.alert[enemyEntNum] = max( 0.0, min( 1.0, detect.alert[enemyEntNum] ) );
    }
}
