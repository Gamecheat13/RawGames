#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "material", "damage_feedback" );
#precache( "material", "damage_feedback_flak" );
#precache( "material", "damage_feedback_tac" );

#namespace damagefeedback;

function autoexec __init__sytem__() {     system::register("damagefeedback",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &init );
	callback::on_connect( &on_player_connect );
}

function init()
{
}

function on_player_connect()
{
	self.hud_damagefeedback = newdamageindicatorhudelem(self);
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	self.hitSoundTracker = true;
}

function should_play_sound( mod )
{
	if ( !isdefined( mod ) )
		return false;
		
	switch( mod )
	{
	case "MOD_CRUSH":
	case "MOD_GRENADE_SPLASH":
	case "MOD_HIT_BY_OBJECT":
	case "MOD_MELEE_ASSASSINATE":
	case "MOD_MELEE":
	case "MOD_MELEE_WEAPON_BUTT":
		return false;
	};
	
	return true;
}

function update( mod, inflictor, perkFeedback )
{
	if ( !isPlayer( self ) || SessionModeIsZombiesGame() )
		return;
	
	if ( should_play_sound( mod ) )
	{
	
		if ( isdefined( inflictor ) && isdefined( inflictor.soundMod ))
		{
			//Add sound stuff here for specific inflictor types	
			switch ( inflictor.soundMod )
			{
				case "player":
				self playlocalsound ("mpl_hit_alert");					
					break;	

				case "heli":	
				self thread play_hit_sound (mod, "mpl_hit_alert_air");	
					break;
					
				case "hpm":	
				self thread play_hit_sound (mod, "mpl_hit_alert_hpm");	
					break;
	
				case "taser_spike":
				self thread play_hit_sound (mod, "mpl_hit_alert_taser_spike");						
					break;	
					
				case "straferun":				
				case "dog":
					break;	
										
				case "default_loud":
				self thread play_hit_sound (mod, "mpl_hit_heli_gunner");					
					break;						
				
				default:
				self thread play_hit_sound (mod, "mpl_hit_alert_low");		
					break;
			}
		}
		else
		{
			self playlocalsound ("mpl_hit_alert_low");
		}
	}
	
	if ( isdefined( perkFeedback ) )
	{
		switch( perkFeedback )
		{
			case "flakjacket": 
				self.hud_damagefeedback setShader( "damage_feedback_flak", 24, 48 );
			break; 
			case "tacticalMask": 
				self.hud_damagefeedback setShader( "damage_feedback_tac", 24, 48 );
			break;
		}

	}
	else
	{
		self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	}
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}

function play_hit_sound (mod, alert)
{
	self endon ("disconnect");
	
	if (self.hitSoundTracker)
	{
		self.hitSoundTracker = false;
		
		self playlocalsound(alert);
		
		//println ("hit type mod " + mod);
		wait .05;	// waitframe
		self.hitSoundTracker = true;
	}
}	

function update_special( hitEnt )
{
	if ( !isPlayer( self ) )
		return;
	
	if ( !isdefined(hitEnt) )
		return;
		
	if ( !isPlayer( hitEnt ) )
		return;

	{wait(.05);};
	if ( !isdefined( self.directionalHitArray ) )
	{
		self.directionalHitArray = [];
		hitEntNum = hitEnt getEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
		self thread send_hit_special_event_at_frame_end(hitEnt);
	}
	else
	{
		hitEntNum = hitEnt getEntityNumber();
		self.directionalHitArray[hitEntNum] = 1;
	}
}

function send_hit_special_event_at_frame_end(hitEnt)
{
	self endon ("disconnect");
	waittillframeend;

	enemysHit = 0;
	value = 1;
		
	entBitArray0 = 0;
	for ( i = 0; i < 32; i++ )
	{
		if (isdefined (self.directionalHitArray[i]) && self.directionalHitArray[i] != 0 )
		{
			entBitArray0 += value;
			enemysHit++;
		}
		value *= 2;
	}	
	entBitArray1 = 0;
	for (  i = 33; i < 64; i++ )
	{
		if (isdefined (self.directionalHitArray[i]) && self.directionalHitArray[i] != 0 )
		{
			entBitArray1 += value;
			enemysHit++;
		}
		value *= 2;
	}
	

	if ( enemysHit )
	{
		self directionalHitIndicator( entBitArray0, entBitArray1 );
	}
	self.directionalHitArray = undefined;
	entBitArray0 = 0;
	entBitArray1 = 0;
}
