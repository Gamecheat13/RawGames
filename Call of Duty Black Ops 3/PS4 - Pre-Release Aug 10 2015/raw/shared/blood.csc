#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\filter_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace blood;









 // per ms
	
function autoexec __init__sytem__() {     system::register("blood",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_spawned( &player_spawned );
}

function player_spawned( localClientNum )
{
	if ( self IsLocalPlayer() )
	{
		self thread player_watch_blood( localClientNum );
		self thread player_watch_blood_shutdown( localClientNum );
	}
}

function player_watch_blood_shutdown( localClientNum )
{
	self waittill ( "entityshutdown" );
	filter::disable_filter_feedback_blood( localClientNum, 2, 2 );
}

function enable_blood( localClientNum )
{
	self.blood_enabled = true;
	filter::init_filter_feedback_blood( localClientNum );
	filter::enable_filter_feedback_blood( localClientNum, 2, 2 );
	filter::set_filter_feedback_blood_sundir( localClientNum, 2, 2, 65, 32 );
}

function disable_blood( localClientNum )
{
	self.blood_enabled = false;
	filter::disable_filter_feedback_blood( localClientNum, 2, 2 );
}

function blood_in( localClientNum, playerHealth )
{
	appliedBlood = false;
	remainderHealth = playerHealth;
	if( remainderHealth < .5 )
	{
		self.stage3Amount = ( .5 - remainderHealth ) / ( .5 );
		filter::set_filter_feedback_blood_vignette( localClientNum, 2, 2, self.stage3Amount );
		remainderHealth = .5;
		appliedBlood = true;
	}
	else
	{
		self.stage3Amount = 0;
	}
	
	if( remainderHealth < .80 )
	{
		self.stage2Amount = ( .80 - remainderHealth ) / ( .80 - .5 );
		filter::set_filter_feedback_blood_opacity( localClientNum, 2, 2, self.stage2Amount );
		remainderHealth = .80;
		appliedBlood = true;
	}
	else
	{
		self.stage2Amount = 0;
	}
	
	if ( appliedBlood == false ) 
	{
		filter::set_filter_feedback_blood_opacity( localClientNum, 2, 2, 0 );
	}
}

function blood_out( localClientNum )
{
	currentTime = GetServerTime( localClientNum );
	elapsedTime = currentTime - self.lastBloodUpdate;
	self.lastBloodUpdate = currentTime;
	subTract = elapsedTime / 1000;
	if( self.stage3Amount > 0 )
	{
		filter::set_filter_feedback_blood_vignette( localClientNum, 2, 2, self.stage3Amount );
		self.stage3Amount -= subTract;
	}
	
	if( self.stage3Amount < 0 )
	{
		self.stage3Amount = 0;
		filter::set_filter_feedback_blood_vignette( localClientNum, 2, 2, self.stage3Amount );
	}
	
	if( self.stage2Amount > 0 )
	{
		filter::set_filter_feedback_blood_opacity( localClientNum, 2, 2, self.stage2Amount );
		self.stage2Amount -= subTract;
	}
	
	if( self.stage2Amount < 0 )
	{
		self.stage2Amount = 0;
		filter::set_filter_feedback_blood_opacity( localClientNum, 2, 2, self.stage2Amount );
	}
}

function player_watch_blood( localClientNum )
{
	self endon( "disconnect" );
	self endon( "entityshutdown" );

	self.stage2Amount = 0;
	self.stage3Amount = 0;
	self.lastBloodUpdate = 0;
	
	priorPlayerHealth = renderhealthoverlayhealth( localClientNum );
	while( true )
	{
		if( renderHealthOverlay( localClientNum ) )
		{
			shouldEnabledOverlay = false;
			playerHealth = renderhealthoverlayhealth( localClientNum );
			if( playerHealth < priorPlayerHealth )
			{
				shouldEnabledOverlay = true;
				self blood_in( localClientNum, playerHealth );
			}
			else if( ( playerHealth == priorplayerhealth ) && ( playerhealth != 1.0 ) )
			{
				shouldEnabledOverlay = true;
				self.lastBloodUpdate = GetServerTime( localClientNum );
			}
			else if( ( self.stage2Amount > 0 ) || ( self.stage3Amount > 0 ) ) // while we're recovering till we're done fading out
			{
				shouldEnabledOverlay = true;
				self blood_out( localClientNum );
			}
			else if( ( isdefined( self.blood_enabled ) && self.blood_enabled ) )
			{
				self disable_blood( localClientNum );
			}
			priorPlayerHealth = playerHealth;
			
			if( !( isdefined( self.blood_enabled ) && self.blood_enabled ) && shouldEnabledOverlay )
			{
				self enable_blood( localClientNum );
			}
		}
		else if( ( isdefined( self.blood_enabled ) && self.blood_enabled ) )
		{
			self disable_blood( localClientNum );
		}
		{wait(.016);};
	}
}
