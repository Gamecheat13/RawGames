#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\filter_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace explode;





function autoexec __init__sytem__() {     system::register("explode",&__init__,undefined,undefined);    }		

function __init__()
{
	level.dirt_enable = GetDvarInt( "scr_dirt_enable", 0 );
	
	callback::on_spawned( &player_spawned );
	
	/#
	level thread updateDvars();
	#/
}

/#
function updateDvars()
{
	while(1)
	{
		level.dirt_enable = GetDvarInt( "scr_dirt_enable", level.dirt_enable );
		
		wait(1.0);
	}
}
#/

function player_spawned( localClientNum )
{
	if( self islocalplayer() && level.dirt_enable )
	{
		filter::init_filter_sprite_dirt( self );
		filter::disable_filter_sprite_dirt( self, 5 );
		self thread watchForExplosion( localClientNum );
	}
}

function doExplosion( localClientNum, right, up, distance )
{
	self endon( "entityshutdown" );
	self notify( "do_explosion" );
	self endon( "do_explosion" );
	
	filter::enable_filter_sprite_dirt( self, 5 );
	filter::set_filter_sprite_dirt_seed_offset( self, 5, RandomFloatRange( 0.0, 1.0 ) );
	                                           
	startTime = GetServerTime( localClientNum );
	currentTime = startTime;
	elapsedTime = 0;
	while( elapsedTime < 2000 )
	{
		if( elapsedTime > 2000 - 500 )
		{
			filter::set_filter_sprite_dirt_opacity( self, 5, ( ( 2000 - elapsedTime ) / 500 ) );
		}
		else
		{
			filter::set_filter_sprite_dirt_opacity( self, 5, 1.0 );
		}
		
		filter::set_filter_sprite_dirt_source_position( self, 5, right, up, distance );
		filter::set_filter_sprite_dirt_elapsed( self, 5, currentTime );
		{wait(.016);};
		currentTime = GetServerTime( localClientNum );
		elapsedTime = currentTime - startTime;
	}
	
	filter::disable_filter_sprite_dirt( self, 5 );
}

function watchForExplosion( localClientNum )
{
	self endon ( "entityshutdown" );
	
	while ( true )
	{
		level waittill( "explode", localClientNum, position, mod, weapon, owner_cent );
		
		explosionDistance = Distance( self.origin, position );
		if ( ( ( mod == "MOD_GRENADE_SPLASH" ) || ( mod == "MOD_PROJECTILE_SPLASH" ) ) && ( explosionDistance < 600 ) )
		{
			cameraAngles = self GetCamAngles();
			forwardVec = VectorNormalize( AnglesToForward( cameraAngles ) );
			upVec = VectorNormalize( AnglesToUp( cameraAngles ) );
			rightVec = VectorNormalize( AnglesToRight( cameraAngles ) );
			explosionVec = VectorNormalize( position - (self GetCamPos() ) );
			
			if( VectorDot( forwardVec, explosionVec ) > 0 )
			{
				trace = bulletTrace( GetLocalClientEyePos( localClientNum ), position, false, self );
				if ( trace["fraction"] >= 1 )
				{
					uDot = -1.0 * VectorDot( explosionVec, upVec );
					rDot = VectorDot( explosionVec, rightVec );
					uDotAbs = abs( uDot );
					rDotAbs = abs( rDot );
					if( udotabs > rdotabs )
					{
						if( udot > 0 )
						{
							uDot = 1.0;
						}
						else
						{
							uDot = -1.0;
						}
					}
					else
					{
						if( rDot > 0 )
						{
							rDot = 1.0;
						}
						else
						{
							rDot = -1.0;
						}
					}
					self thread doExplosion( localClientNum, rDot, uDot, ( 1.0 - explosionDistance / 600 ) );
				}
			}
		}
	}
}
