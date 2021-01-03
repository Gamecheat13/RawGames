#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\ai\systems\gib;

#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                       	     	                                                                                   
                   

#namespace hive_gun;

#precache( "client_fx", "weapon/fx_hero_firefly_hunting" );
#precache( "client_fx", "weapon/fx_hero_firefly_death" );
#precache( "client_fx", "weapon/fx_hero_firefly_attack" );
#precache( "client_fx", "weapon/fx_ability_firefly_attack_1p" );
#precache( "client_fx", "weapon/fx_ability_firefly_chase_1p" );
#precache( "client_fx", "weapon/fx_hero_firefly_attack_limb" );
//#precache( "client_fx", "weapon/fx_hero_firefly_start" );
#precache( "client_fx", "weapon/fx_hero_firefly_start_entity" );

function init_shared()
{	
//	visionset_mgr::register_overlay_info_style_postfx_bundle( "hive_gungun_splat", VERSION_SHIP, 7, "pstfx_hive_gun_splat", hive_gun_SPLAT_DURATION_MAX );
	level thread register();
}

function register()
{
	clientfield::register( "scriptmover", "firefly_state", 1, 3, "int",&firefly_state_change, !true, !true );
//	clientfield::register( "scriptmover", "firefly_target", VERSION_SHIP, 6, "int",&firefly_target, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	clientfield::register( "allplayers", "fireflies_attacking", 1, 1, "int", &fireflies_attacking, !true, true );
	clientfield::register( "allplayers", "fireflies_chasing", 1, 1, "int", &fireflies_chasing, !true, true );
}

function getOtherTeam( team )
{
	if ( team == "allies" )
		return "axis";
	else if ( team == "axis" )
		return "allies";
	else
		return "free";
}

function fireflies_attacking( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");
	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
		
	if ( newVal )
	{
		stop_player_fx(localClientNum);
	
//		self.fireflies_fx = PlayFXOnTag( localClientNum, "weapon/fx_hero_firefly_attack", self, "J_SpineLower");
//		SetFXTeam( localClientNum, self.fireflies_fx, getOtherTeam( self.team ) );
		
		if ( self IsLocalPlayer() && !(self GetInKillcam( localClientNum )) )
		{
			self.firstperson_fx = PlayFXOnCamera( localClientNum, "weapon/fx_ability_firefly_attack_1p", (0,0,0), (1,0,0), (0,0,1)  );
		}
		
		self thread watch_for_death(localClientNum);
	}
	else
	{
		stop_player_fx(localClientNum);
	}
}

function fireflies_chasing( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");
	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
		
	if ( newVal )
	{
		stop_player_fx(localClientNum);

		if ( self IsLocalPlayer() && !(self GetInKillcam( localClientNum )) )
		{
			self.firstperson_fx = PlayFXOnCamera( localClientNum, "weapon/fx_ability_firefly_chase_1p", (0,0,0), (1,0,0), (0,0,1) );
		}
		
		self thread watch_for_death(localClientNum);
	}
	else
	{
		stop_player_fx(localClientNum);
	}
}

function stop_player_fx(localClientNum)
{
	if ( IsDefined( self.fireflies_fx ) )
	{
		StopFx( localClientNum, self.fireflies_fx );		
		self.fireflies_fx = undefined;
	}
	if ( IsDefined( self.firstperson_fx ) )
	{
		StopFx( localClientNum, self.firstperson_fx );		
		self.firstperson_fx = undefined;
	}
}

function watch_for_death(localClientNum)
{
	self waittill("entityshutdown");
	stop_player_fx(localClientNum);
}

function firefly_state_change( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	self util::waittill_dobj( localClientNum );

	if ( !isdefined(self) )
		return;
	
	if ( !isdefined( self.initied ) )
	{
		self thread firefly_init( localClientNum );
		self.initied = true;
	}
	
	switch( newVal )
	{
		case 0:
		{
			break;
		}
		case 1:
		{
			self thread firefly_deploying( localClientNum );
			break;
		}
		case 2:
		{
			self thread firefly_hunting( localClientNum );
			break;
		}
		case 3:
		{
			self thread firefly_attacking( localClientNum );
			break;
		}
		case 4:
		{
			self thread firefly_link_attacking( localClientNum );
			break;
		}
	}
}

function on_shutdown(localClientNum, ent)
{
	if ( isdefined(ent) && isdefined(ent.origin) && self === ent && !( isdefined( self.no_death_fx ) && self.no_death_fx ) )
	{
		fx = PlayFX( localClientNum,"weapon/fx_hero_firefly_death", ent.origin, (0,0,1) );
		SetFXTeam( localClientNum, fx, ent.team );
	}
}

function firefly_init( localClientNum )
{
	self callback::on_shutdown( &on_shutdown, self );
}

function firefly_deploying( localClientNum )
{
	self endon("entityshutdown");
	
	fx = PlayFX( localClientNum, "weapon/fx_hero_firefly_start", self.origin, AnglesToUp(self.angles) );
	SetFXTeam( localClientNum, fx, self.team );
}

function firefly_hunting( localClientNum )
{
	self endon("entityshutdown");
	self.fireflies_fx = PlayFXOnTag( localClientNum, "weapon/fx_hero_firefly_hunting", self, "tag_origin");
	SetFXTeam( localClientNum, self.fireflies_fx, self.team );
	self.firefly_sound = self PlayLoopSound("wpn_gelgun_hive_hunt_lp" );
	self PlayRumbleLoopOnEntity( localClientNum, "firefly_chase_rumble_loop" );
}

function firefly_attacking( localClientNum )
{
	self endon("entityshutdown");
	stop_effects( localClientNum );
	self.no_death_fx = true;
}

function firefly_link_attacking( localClientNum )
{
	self endon("entityshutdown");
	fx = PlayFX( localClientNum, "weapon/fx_hero_firefly_start_entity", self.origin, AnglesToUp(self.angles) );
	SetFXTeam( localClientNum, fx, self.team );

	stop_effects( localClientNum );
	self.no_death_fx = true;
}

function firefly_dieing( localClientNum )
{
	self endon("entityshutdown");
	stop_effects( localClientNum );
}

function stop_effects(localClientNum)
{
	if ( isdefined( self.fireflies_fx ) )
	{
		StopFx( localClientNum, self.fireflies_fx );
		self.fireflies_fx = undefined;
	}
	if ( isdefined( self.firefly_sound ) )
	{
		StopSound( self.firefly_sound );
		self.firefly_sound = undefined;
	}
}

function gib_fx( localClientNum, fxFileName, gibFlag )
{
	fxTag = GibClientUtils::PlayerGibTag( localClientNum, gibFlag );
	if ( isdefined( fxTag ) )
	{
		fx = PlayFxOnTag( localClientNum, fxFileName, self, fxTag );
		SetFXTeam( localClientNum, fx, getOtherTeam( self.team ) );
	}
}

function gib_corpse( localClientNum, value ) 
{
	self endon("entityshutdown");
	
	self thread watch_for_gib_notetracks( localClientNum );
}

function watch_for_gib_notetracks( localClientNum )
{
	self endon("entityshutdown");
	
	if ( !util::is_mature() || util::is_gib_restricted_build() )
		return;

	fxFileName = "weapon/fx_hero_firefly_attack_limb";
	
	arm_gib = 0;
	leg_gib = 0;
	while( 1 )
	{
		notetrack = self util::waittill_any_return( "gib_leftarm", "gib_leftleg", "gib_rightarm", "gib_rightleg");
		
		switch( noteTrack )
		{
			case "gib_rightarm":
				{
					arm_gib = arm_gib | 1;
					gib_fx( localClientNum, fxFileName, 16 );
					self GibClientUtils::PlayerGibLeftArm( localClientNum );
					self SetCorpseGibState( leg_gib, arm_gib );
				}
				break;
			case "gib_leftarm":
				{
					arm_gib = arm_gib | 2;
					gib_fx( localClientNum, fxFileName, 32 );
					self GibClientUtils::PlayerGibLeftArm( localClientNum );
					self SetCorpseGibState( leg_gib, arm_gib );
				}
				break;
			case "gib_rightleg":
				{
					leg_gib = leg_gib | 1;
					gib_fx( localClientNum, fxFileName, 128 );
					self GibClientUtils::PlayerGibLeftLeg( localClientNum );	
					self SetCorpseGibState( leg_gib, arm_gib );
				}
				break;
			case "gib_leftleg":
				{
					leg_gib = leg_gib | 2;
					gib_fx( localClientNum, fxFileName, 256 );
					self GibClientUtils::PlayerGibLeftLeg( localClientNum );	
					self SetCorpseGibState( leg_gib, arm_gib );
				}
				break;
			default:
			break;
		}	
	}
}
