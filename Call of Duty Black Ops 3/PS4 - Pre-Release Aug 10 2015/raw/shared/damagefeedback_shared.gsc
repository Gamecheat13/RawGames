#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "material", "damage_feedback" );
#precache( "material", "damage_feedback_flak" );
#precache( "material", "damage_feedback_tac" );
#precache( "material", "damage_feedback_armor" );

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

	self.hud_damagefeedback_additional = newdamageindicatorhudelem(self);
	self.hud_damagefeedback_additional.horzAlign = "center";
	self.hud_damagefeedback_additional.vertAlign = "middle";
	self.hud_damagefeedback_additional.x = -12;
	self.hud_damagefeedback_additional.y = -12;
	self.hud_damagefeedback_additional.alpha = 0;
	self.hud_damagefeedback_additional.archived = true;
	self.hud_damagefeedback_additional setShader( "damage_feedback", 24, 48 );
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

function update( mod, inflictor, perkFeedback, weapon, victim, psOffsetTime )
{
	if ( !isPlayer( self ) )
		return;
	
	if (isDefined(weapon) && ( isdefined( weapon.nohitmarker ) && weapon.nohitmarker ) )
		return;
	
	if ( !isDefined( self.lastHitMarkerTime ) )
	{
		self.lastHitMarkerTimes = [];
		self.lastHitMarkerTime = 0;
		self.lastHitMarkerOffsetTime = 0;
	}	
	
	if ( isdefined( psOffsetTime ) )
	{
		if ( self.lastHitMarkerTime == GetTime() )
		{
			// temporarily for the Beta do not do more than one hit at a time
			if ( self.lastHitMarkerOffsetTime === psOffsetTime )
				return;	
		}
	}
	else
	{
		// temporarily for the Beta do not do more than one hit at a time
		if ( self.lastHitMarkerTime == GetTime() )
			return;
	}
		
	self.lastHitMarkerTime = GetTime();
	self.lastHitMarkerOffsetTime = psOffsetTime;
	
	if ( should_play_sound( mod ) )
	{	
		if ( isdefined( inflictor ) && isdefined( inflictor.soundMod ))
		{
			//Add sound stuff here for specific inflictor types	
			switch ( inflictor.soundMod )
			{
				case "player":
					if( isdefined( victim ) && ( isdefined( victim.isAiClone ) && victim.isAiClone ) )
					{
						self play_hit_sound ("mpl_hit_alert_clone");
					}
					else if ( isdefined( victim ) && isPlayer( victim ) && victim flagsys::get( "gadget_armor_on" ) )
					{
						self play_hit_sound ("mpl_hit_alert_armor");				
					}
					else if( isdefined( victim ) && isPlayer( victim ) && isDefined( victim.carryObject ) && isDefined( victim.carryObject.hitSound ) && isDefined( perkfeedback ) && ( perkfeedback == "armor" ) )
					{
						self play_hit_sound ( victim.carryObject.hitSound );					
					}
					else
					{
						self play_hit_sound ("mpl_hit_alert");					
					}
					break;	

				case "heli":	
					self thread play_hit_sound ( "mpl_hit_alert_air");	
					break;
					
				case "hpm":	
					self thread play_hit_sound ( "mpl_hit_alert_hpm");	
					break;
	
				case "taser_spike":
					self thread play_hit_sound ( "mpl_hit_alert_taser_spike");						
					break;	
					
				case "straferun":				
				case "dog":
					break;

				case "firefly":
					self thread play_hit_sound ( "mpl_hit_alert_firefly");
					break;
					
				case "drone_land":
					self thread play_hit_sound ( "mpl_hit_alert_air");
					break;
				
				case "raps":
					self thread play_hit_sound ( "mpl_hit_alert_air");
					break;
										
				case "default_loud":
					self thread play_hit_sound ( "mpl_hit_heli_gunner");					
					break;						
				
				default:
					self thread play_hit_sound ( "mpl_hit_alert");		
					break;
			}
		}
		else
		{
			self playlocalsound ("mpl_hit_alert");
		}
	}
	
	if( isdefined( victim ) && ( isdefined( victim.isAiClone ) && victim.isAiClone ) )
		return;
	
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
			case "armor":
				self.hud_damagefeedback setShader( "damage_feedback_armor", 24, 48 );
			break;
		}
	}
	else
	{
		if (isDefined(self.hud_damagefeedback))
			self.hud_damagefeedback setShader( "damage_feedback", 24, 48 );
	}
	
	if (isDefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}
}

function update_override( icon, sound, additional_icon )
{
	if ( !IsPlayer( self ) )
		return;

	self PlayLocalSound( sound );

	if ( IsDefined( self.hud_damagefeedback ) )
	{
		self.hud_damagefeedback setShader( icon, 24, 48 );
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback fadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}

	if ( isDefined( self.hud_damagefeedback_additional ) )
	{
		if ( !IsDefined( additional_icon ) )
		{
			self.hud_damagefeedback_additional.alpha = 0;
		}
		else
		{
			self.hud_damagefeedback_additional setShader( additional_icon, 24, 48 );
			self.hud_damagefeedback_additional.alpha = 1;
			self.hud_damagefeedback_additional fadeOverTime(1);
			self.hud_damagefeedback_additional.alpha = 0;
		}
	}
}

function play_hit_sound (alert)
{
	self PlayHitMarker(alert);
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

function doDamageFeedback( weapon, eInflictor, iDamage, sMeansOfDeath )
{
	if ( !isdefined( weapon ) )
		return false;
		
	if (( isdefined( weapon.nohitmarker ) && weapon.nohitmarker )	)
		return false;

	if ( level.allowHitMarkers == 0 ) 
		return false;

	if ( level.allowHitMarkers == 1 ) // no tac grenades
	{
		if ( isdefined( sMeansOfDeath ) && isdefined( iDamage ) ) 
		{
			if ( isTacticalHitMarker( weapon, sMeansOfDeath, iDamage ) )
			{
				return false;
			}
		}
	}
	
	return true;
}

function isTacticalHitMarker( weapon, sMeansOfDeath, iDamage )
{
	if ( weapons::is_grenade( weapon ) )
	{
		if ( "Smoke Grenade" == weapon.offhandClass ) 
		{
			if ( sMeansOfDeath == "MOD_GRENADE_SPLASH" )
				return true;
		}
		else if ( iDamage == 1 )
		{
			return true;
		}
	}	
	return false;
}
