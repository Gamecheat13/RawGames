#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\math_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                     
#using scripts\shared\lui_shared;
#using scripts\shared\system_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\cp\_util;
#using scripts\shared\laststand_shared;
#using scripts\shared\player_shared;
#using scripts\shared\vehicle_ai_shared;

                                                                                                      	                       	     	                                                                     
     
                                            
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;















#namespace cybercom_gadget_security_breach;
#precache( "string", "endersgame" );
#precache( "lui_menu_data", "vehicle.outOfRange" );


function init()
{
	clientfield::register( "toplayer", "hijack_vehicle_transition", 1, 2, "int" );
	clientfield::register( "toplayer", "hijack_static_effect", 1, 7, "float" );
	clientfield::register( "toplayer", "sndInDrivableVehicle", 1, 1, "int" );

	clientfield::register( "vehicle", "vehicle_hijacked", 1, 1, "int" );
	clientfield::register( "toplayer", "hijack_spectate", 1, 1, "int" );
	clientfield::register( "toplayer", "hijack_static_ramp_up", 1, 1, "int" );
	
	
	visionset_mgr::register_info( "visionset", "hijack_vehicle", 1, 5, 1, true );
	visionset_mgr::register_info( "visionset", "hijack_vehicle_blur", 1, 6, 1, true );

	callback::on_spawned( &on_player_spawned );
}

function main()
{
	cybercom_gadget::registerAbility(0,	(1<<5));
	
	level.cybercom.security_breach = spawnstruct();
	level.cybercom.security_breach._is_flickering  	= &_is_flickering;
	level.cybercom.security_breach._on_flicker 		= &_on_flicker;
	level.cybercom.security_breach._on_give 		= &_on_give;
	level.cybercom.security_breach._on_take 		= &_on_take;
	level.cybercom.security_breach._on_connect 		= &_on_connect;
	level.cybercom.security_breach._on 				= &_on;
	level.cybercom.security_breach._off 			= &_off;
	level.cybercom.security_breach._is_primed 		= &_is_primed;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_player_spawned()
{	
	self clientfield::set_to_player("hijack_static_effect",0);
	self clientfield::set_to_player("hijack_spectate",0);
	self clientfield::set_to_player("hijack_static_ramp_up",0);
	self util::freeze_player_controls( false );	
	self CameraActivate( false );
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	self.cybercom.weapon 							= weapon;
	self.cybercom.security_breach_target_count 		= 1;
	self.cybercom.security_breach_lifetime 			= GetDvarInt( "scr_security_breach_lifetime", 30 );
	if(self hasCyberComAbility("cybercom_securitybreach")  == 2)
	{
		self.cybercom.security_breach_lifetime = GetDvarInt( "scr_security_breach_upgraded_lifetime", 60 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
}

function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.weapon	= undefined;
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_security_breach(slot,weapon);
	self _off( slot, weapon );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self thread cybercom::weaponEndLockWatcher();
	self.cybercom.is_primed = undefined;
}

function _is_primed( slot, weapon )
{
	//self thread gadget_flashback_start( slot, weapon );
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		self thread cybercom::weaponLockWatcher(self.cybercom.activeCybercomWeapon, self.cybercom.security_breach_target_count);
		self.cybercom.is_primed = true;
		self playsoundtoplayer( "gdt_securitybreach_target", self );
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_hijack")) 
		return false;

	if(( isdefined( target.hijacked ) && target.hijacked ))
		return false;
	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	enemyvehicles = ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
	allyvehicles = GetAITeamArray("allies");
	vehicles = ArrayCombine(enemyvehicles,allyvehicles,false,false);//GetVehicleTeamArray( "axis" );
	valid	 = [];
	foreach (vehicle in vehicles)
	{
		if(!isVehicle(vehicle))
			continue;
		valid[valid.size] = vehicle;
	}
	return valid;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_security_breach(slot,weapon)
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	
	if ( !isDefined(self.cybercom.lock_targets) || self.cybercom.lock_targets.size == 0 )
	{	//player has the buttons down, and just released, no targets, what to do? 
		//Feedback UI
		//Feedback Audio
		//do we incur the cost of firing the weapon? Seems like we shouldnt
	}
	
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if ( !cybercom::targetIsValid(item.target) )
				continue;
			
			item.target thread _security_breach(self);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _security_breach_ramp_visionset( player, setname, delay, direction, duration )
{
	wait delay;
	
	if ( direction > 0 )
	{
		visionset_mgr::activate( "visionset", setname, player, duration, 0.0, 0.0 );
		visionset_mgr::deactivate( "visionset", setname, player );
	}
	else
	{
		visionset_mgr::activate( "visionset", setname, player, 0.0, 0.0, duration );
		visionset_mgr::deactivate( "visionset", setname, player );
	}
}

function private _security_breach(player) //self is vehicle
{
	if(!isVehicle(self))  //shouldnt happen; Only valid targets are selectable, but what the heck, a little extra sanity doesnt hurt
		return;
	if( player laststand::player_is_in_laststand() )
		return;
	if ( ( isdefined( player.cybercom.emergency_reserve ) && player.cybercom.emergency_reserve ))
		return;
	
	if(isDefined(self.playerdrivenversion))
	{
        self setvehicletype( self.playerdrivenversion );
	}
			
	vehEntNum = self getEntityNumber();
	self notify("CloneAndRemoveEntity",vehEntNum); //give self a heads up if level scripter isn't expecting a 'death' notify
	level notify("CloneAndRemoveEntity",vehEntNum); 
	
	clone = CloneAndRemoveEntity(self);  //self just got deleted!
	if(!isDefined(clone))
		return;
	level notify("ClonedEntity",clone,vehEntNum);
	player notify("ClonedEntity",clone,vehEntNum);
	player util::freeze_player_controls( true );
	player enableinvulnerability();
	wait 0.1;
	if(!isDefined(clone))
	{
		player disableinvulnerability();
		return;
	}
		
	clone.takedamage = 0;// IsGodMode( player );
	oldstance 		= player getstance();
	oldignoreme 	= player.ignoreme;
	player.ignoreme = true;
	
	//player setUsingRemote( "cybercom_hijack" );	
	player SetClientUIVisibilityFlag( "hud_visible", 0 ); 	
	player setStance("crouch");
	player clientfield::set( "camo_shader", 2 );
	//player camo_loop_sound();  //turn on camo suit audio
	clone.hijacked = true;
	clone vehicle_ai::TurnOff();
	player thread _start_transition( 2 );

	player thread _security_breach_ramp_visionset( player, "hijack_vehicle", 0.1, 1, 0.1 );

	player waittill("transition_in_do_switch");
	oldAds = player AllowAds( false );
	player setlowready(true);
	visionset_mgr::activate( "visionset", "hijack_vehicle_blur", player );
	player Hide();
	player NotSolid();
	player clientfield::set( "camo_shader", 1 );
	clone.team 			= player.team;
	clone.health		= clone.healthdefault;
	clone thread _invulnerableForATime(GetDvarInt( "scr_security_breach_no_damage_time", 8 ),player);
	
	if(isDefined(clone.vehicletype) && clone.vehicletype != "turret_sentry") //disable range futz for turret since its stationary.
		clone thread _anchor_to_location(player,player.origin);
	
	player clientfield::set_to_player("sndInDrivableVehicle",1);
	clone.blockTween = 1;
	player player::take_weapons();
	clone MakeVehicleUsable();
	clone usevehicle( player, 0 );
	clone MakeVehicleUnUsable();
	player waittill("transition_done");
	if(!isDefined(clone.archetype) || clone.archetype != "wasp") 
	{
		clone clientfield::set( "vehicle_hijacked", 1);  //wasp handled differently in spectate
	}
	clone.blockTween = undefined;
	clone MakeVehicleUsable();
	clone thread _wait_for_return(player);
	player util::freeze_player_controls( false );

	
	player waittill("return_to_body");
	
	player player::give_back_weapons();
	player thread _security_breach_ramp_visionset( player, "hijack_vehicle", 0.0, -1, 0.1 );
	visionset_mgr::deactivate( "visionset", "hijack_vehicle_blur", player );
	
	player Show();
	player Solid();
	player setStance(oldstance);
	player setlowready(false);
	player AllowAds( oldAds );


	player waittill("transition_done");
	
	player clientfield::set_to_player("sndInDrivableVehicle",0);
	
	player disableinvulnerability();
	player.ignoreme = oldignoreme;
//	player clearUsingRemote();
	player SetClientUIVisibilityFlag( "hud_visible", 1 ); 	
	wait 1;
	player clientfield::set( "camo_shader", 0 );
	player notify ("stop_camo_sound");  //turn off camo suit audio
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _start_transition( direction )
{
	self endon("death");
	self notify("_start_transition");
	self endon("_start_transition");
	
//	self lui::play_movie( "endersgame", "fullscreen" );

	//self playsoundtoplayer( "gdt_securitybreach_transition_in", self );
	self clientfield::set_to_player("hijack_vehicle_transition", direction);
	util::wait_network_frame();
	self notify("transition_in_do_switch");
	wait 0.2;
	//self playsoundtoplayer( "gdt_securitybreach_transition_out", self );
	wait 0.2;
	self notify("transition_done");
	self clientfield::set_to_player("hijack_vehicle_transition",1);
}






///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setAnchorVolume(ent)
{
	clearAnchorVolume();
	if(isDefined(ent) && isPlayer(self))
	{
		self.cybercom.secBreachAnchorEnt = ent;
		if(isDefined(ent.script_parameters))
		{
			data = strtok(ent.script_parameters," ");
			assert(data.size == 2);
			self.cybercom.secBreachAnchorMinSQ = ( (int(data[0])) * (int(data[0])) );
			self.cybercom.secBreachAnchorMaxSQ = ( (int(data[1])) * (int(data[1])) );
		}
	}
}

function clearAnchorVolume()
{
	self.cybercom.secBreachAnchorEnt 	= undefined;
	self.cybercom.secBreachAnchorMinSQ  = undefined;
	self.cybercom.secBreachAnchorMaxSQ  = undefined;
}

function private _anchor_to_location(player, anchor)
{
	self endon("death");
	player endon("return_to_body");
	player endon("kill_static_achor");
	player waittill("transition_done");
	
	wait .1;	
	maxStatic =0.95;//temp, because full blackness sucks for now
	lastOutOfRangeWarningValue = undefined;
	while(1)
	{
		distCheck = true;
		loseContactDistSQ = GetDvarInt( "scr_security_breach_lose_contact_distanceSQ", ( (GetDvarInt( "scr_security_breach_lose_contact_distance", 1200 )) * (GetDvarInt( "scr_security_breach_lose_contact_distance", 1200 )) ) );
		lostContactDistSQ = GetDvarInt( "scr_security_breach_lost_contact_distanceSQ", ( (GetDvarInt( "scr_security_breach_lost_contact_distance", 2400 )) * (GetDvarInt( "scr_security_breach_lost_contact_distance", 2400 )) ) );
		
		if (isDefined(player.cybercom.secBreachAnchorEnt) )
		{
			if(isDefined(player.cybercom.secBreachAnchorMinSQ))
			{
				loseContactDistSQ = player.cybercom.secBreachAnchorMinSQ;
				lostContactDistSQ = player.cybercom.secBreachAnchorMaxSQ;
			}
			if (player IsTouching(player.cybercom.secBreachAnchorEnt) )
			{
				val = 0;
				distanceSQ = 0;
				distCheck = false;
			}
		}
		
		if(distCheck)
		{
			distanceSQ = distancesquared(self.origin, anchor);
			if (distanceSQ < loseContactDistSQ )
			{
				val = 0;
			}
			else if (distanceSQ >= lostContactDistSQ )
			{
				val = maxStatic;
			}
			else
			{
				range = lostContactDistSQ - loseContactDistSQ;
				val = math::clamp(((distanceSQ - loseContactDistSQ)/range),0,maxStatic);
			}
			
			outOfRangeWarningValue = ( distanceSQ >= (GetDvarFloat( "scr_security_breach_lost_contact_warning_distance_percent", 0.6 )*lostContactDistSQ) ); //lostContactDistSQ can be overridden by scripters via the setAnchorVolume call
			if ( outOfRangeWarningValue !== lastOutOfRangeWarningValue )
			{
				player SetControllerUIModelValue( "vehicle.outOfRange", outOfRangeWarningValue );
				lastOutOfRangeWarningValue = outOfRangeWarningValue;
			}
		}
		
		player clientfield::set_to_player("hijack_static_effect",val);
		
		if ( distanceSQ > lostContactDistSQ )
		{
			self kill();
		}

		{wait(.05);};
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _invulnerableForATime(time,player)
{
	self endon("death");
	self.takedamage = false;
	player util::waittill_any_timeout(time,"return_to_body");
	self.takedamage = !IsGodMode(player);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _playerSpectate(vehicle)//self == player
{
	self endon("spawned");
	
	self util::freeze_player_controls( true );
	self clientfield::set_to_player("hijack_static_ramp_up",1);
	
	if(isDefined(vehicle.archetype) && vehicle.archetype == "wasp")
	{
		self thread _playerSpectateChase(vehicle);
	}
	else
	{
		self clientfield::set_to_player("hijack_spectate",1);
	}

	self CameraActivate( true );    
	self waittill("transition_in_do_switch");
	self clientfield::set_to_player("hijack_static_ramp_up",0);
	self CameraActivate( false );
	self clientfield::set_to_player("hijack_spectate",0);
	self clientfield::set_to_player("hijack_static_effect",0);
	self util::freeze_player_controls( false );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _playerSpectateChase(vehicle)//self == player
{
	forward = AnglesToForward( vehicle.angles );
	moveAmount = VectorScale( forward, -200 );
	moveAmount = (moveAmount[0], moveAmount[1], vehicle.origin[2]+72);
	cam = spawn( "script_model", vehicle.origin + moveamount );
	cam SetModel( "tag_origin" );
	
	if( !( isdefined( vehicle.crash_style ) && vehicle.crash_style ) )	// plane style crash
		cam LinkTo( vehicle,"tag_origin");
	
	self StartCameraTween( 1 );
	origin = vehicle.origin;
	{wait(.05);};
 	self CameraSetPosition( cam );
 	if(isDefined(vehicle))
 	{
 		self CameraSetLookAt( vehicle );
 	}
 	else
 	{
 		self CameraSetLookAt( origin + (0,0,50) );
 	}
 	self util::waittill_any("transition_in_do_switch","spawned","disconnect","death","return_to_body");
	cam delete();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _wait_for_death(player)
{
	player endon("return_to_body");
	self waittill("death");
	player thread _playerSpectate(self);
	wait 3;
	player notify("kill_static_achor");
	player thread _start_transition( 3 );
	player waittill("transition_in_do_switch");
	waittillframeend;
	player unlink();
	player notify("return_to_body",(1));	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _wait_for_player_exit(player)
{
	self endon( "death" );
	player endon("return_to_body");
	self util::waittill_any("unlink","exit_vehicle" );
	
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" || ( isdefined( level.gameEnded ) && level.gameEnded ) )
		return;
	
	self.takedamage = true;
	self kill();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _wait_for_return(player)
{
	self thread _wait_for_death(player);			//failsafe for vehicle death;  Need to restore player correctly on vehicle death
	self thread _wait_for_player_exit(player);
	
	original_location = player.origin;
	original_angles	  = player.angles;
	player.cybercom.tacrigs_disabled = true;

	self.vehdontejectoccupantsondeath = true; 	
	
	oldgadget 		= player.cybercom.activeCybercomWeapon;
	oldmeleeWeap 	= player.cybercom.activeCybercomMeleeWeapon;
	player TakeWeapon( player.cybercom.activeCybercomWeapon );
	player.cybercom.activeCybercomWeapon  = undefined;
	if(isDefined(player.cybercom.activeCybercomMeleeWeapon))
	{
		player TakeWeapon( player.cybercom.activeCybercomMeleeWeapon );
		player.cybercom.activeCybercomMeleeWeapon = undefined;
	}
	player waittill("return_to_body",reason);

	{wait(.05);};
	player SetOrigin(original_location);
	player SetPlayerAngles(original_angles);
	{wait(.05);};
	
	if(isDefined(self))
	{
		self kill();
	}

	player.cybercom.tacrigs_disabled = undefined;
	player.cybercom.activeCybercomWeapon = oldgadget;
	player GiveWeapon( player.cybercom.activeCybercomWeapon );	

	player.cybercom.activeCybercomMeleeWeapon = oldmeleeWeap;
	if(isDefined(player.cybercom.activeCybercomMeleeWeapon))
	{
		player GiveWeapon( player.cybercom.activeCybercomMeleeWeapon );	
	}
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function clearUsingRemote()
{
	self enableOffhandWeapons();
	if ( isdefined(self.lastWeapon) )
	{
		self switchToWeapon( self.lastWeapon );
		wait 1;
	}
	self takeweapon(self.remoteWeapon);
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setUsingRemote( remoteName )
{
	self.lastWeapon = self getCurrentWeapon();
	self.remoteWeapon = GetWeapon( remoteName );
	self giveWeapon( self.remoteWeapon );
	self switchToWeapon( self.remoteWeapon );
	self disableOffhandWeapons();
}


//SOUND CALLS TO BE SET UP IN GDT FIELDS
/*function camo_loop_sound()
{
	self endon ("death");
	
	if ( IsDefined( self.active_camo_sound_ent ) )
	{
		self.active_camo_sound_ent stoploopsound( .05 );
		self.active_camo_sound_ent delete();	
	}
	
	self.active_camo_sound_ent = Spawn( "script_origin", self.origin );
	self.active_camo_sound_ent linkto( self );
	self.active_camo_sound_ent playsound ("gdt_camo_suit_on");
	
	wait .5;
	
	self.active_camo_sound_ent PlayLoopSound( "gdt_camo_suit_loop" , .1 );	
	self.active_camo_sound_ent thread camo_loop_sound_stop(self);
}
	
	
function camo_loop_sound_stop(player)
{
	self endon("death");
	player waittill ("stop_camo_sound");
	self PlaySound( "gdt_camo_suit_off");
	self stoploopsound(.5);
	self delete();
}*/

	
