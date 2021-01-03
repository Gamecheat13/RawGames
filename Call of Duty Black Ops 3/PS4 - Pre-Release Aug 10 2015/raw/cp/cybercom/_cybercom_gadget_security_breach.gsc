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
	clientfield::register( "toplayer", "vehicle_hijacked", 1, 1, "int" );
	
	
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
	self.cybercom.target_count 		= 1;
	self.cybercom.security_breach_lifetime 			= GetDvarInt( "scr_security_breach_lifetime", 30 );
	if(self hasCyberComAbility("cybercom_securitybreach")  == 2)
	{
		self.cybercom.security_breach_lifetime = GetDvarInt( "scr_security_breach_upgraded_lifetime", 60 );
	}
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self.cybercom.autoActivate = &_autofire;
	self.cybercom.abortConditions = (1|2|4|8|16|32);
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}


function _on_take( slot, weapon )
{
	self _off( slot, weapon );
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
	self.cybercom.abortConditions = undefined;
	self.cybercom.autoActivate = undefined;
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _autofire(slot,weapon)
{
	self GadgetActivate(slot,weapon);		
	_on( slot, weapon );
}

function _on( slot, weapon )
{
	self thread _activate_security_breach(slot,weapon);
	self _off( slot, weapon );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self thread cybercom::weaponEndLockWatcher( weapon );
	self.cybercom.is_primed = undefined;
	self notify( "cybercom_hijack_off" );
}

function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		assert (self.cybercom.activeCybercomWeapon == weapon);
		self notify( "cybercom_hijack_primed" );
		self thread cybercom::weaponLockWatcher(slot, weapon, self.cybercom.target_count);
		self.cybercom.is_primed = true;
		self playsoundtoplayer( "gdt_securitybreach_target", self );
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if( target cybercom::cybercom_AICheckOptOut("cybercom_hijack")) 
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}

	if(isDefined(target.lockon_owner) && target.lockon_owner != self )
	{
		self cybercom::cybercomSetFailHint(7);
		return false;
	}
	
	if(( isdefined( target.hijacked ) && target.hijacked ))
	{
		self cybercom::cybercomSetFailHint(3);
		return false;
	}

	if(( isdefined( target.is_disabled ) && target.is_disabled ))
	{
		self cybercom::cybercomSetFailHint(6);
		return false;
	}
	
	if (( isdefined( target.no_hijack ) && target.no_hijack ))
		return false;
	
	if (!IsVehicle(target))
	{
		self cybercom::cybercomSetFailHint(1);
		return false;
	}
	
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	enemy = ArrayCombine(GetAITeamArray("axis"),GetAITeamArray("team3"),false,false);//GetVehicleTeamArray( "axis" );
	ally = GetAITeamArray("allies");
	return ArrayCombine(enemy,ally,false,false);//GetVehicleTeamArray( "axis" );
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _activate_security_breach(slot,weapon)
{
	aborted = 0;
	fired 	= 0;
	foreach(item in self.cybercom.lock_targets)
	{
		if(isDefined(item.target) && ( isdefined( item.inRange ) && item.inRange ) )
		{
			if (item.inRange == 1)
			{
				
				if ( !cybercom::targetIsValid(item.target) )
					continue;
				
				item.target thread _security_breach(self,weapon);
				fired++;
			}
			else
			if (item.inRange == 2)
			{//aborted
				aborted++;
			}
		}
	}
	if(aborted && !fired )
	{
		self.cybercom.lock_targets = [];
		self cybercom::cybercomSetFailHint(4,false);
	}
	if( !aborted && fired )
	{
		upgraded = (weapon.name  == "gadget_remote_hijack_upgraded" );
		
		self playsound( "gdt_cybercore_activate" + (( isdefined( upgraded ) && upgraded )?"_upgraded":"") );
	}
	
	cybercom::cybercomAbilityTurnedONNotify(weapon,fired);
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

function private _security_breach(player,weapon) //self is vehicle
{
	wait GetDvarFloat( "scr_security_breach_activate_delay", .5 );
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
	self notify("cybercom_action",weapon,player);
	self notify("CloneAndRemoveEntity",vehEntNum); //give self a heads up if level scripter isn't expecting a 'death' notify
	level notify("CloneAndRemoveEntity",vehEntNum); 
	player gadgetpowerset(0, 0);
	player gadgetpowerset(1, 0);
	player gadgetpowerset(2, 0);
	player cybercom::disableCybercom(true);
	waittillframeend;
	
	clone = CloneAndRemoveEntity(self);  //self just got deleted!
	if(!isDefined(clone))
		return;
	level notify("ClonedEntity",clone,vehEntNum);
	player notify("ClonedEntity",clone,vehEntNum);
	clone.takedamage = 0;// IsGodMode( player );
	clone.hijacked = true;
	clone.hijack_hacker = undefined;
	clone.is_disabled = true;
	clone.owner		= player;
	//clone.targetname +="_clone";
	clone vehicle_ai::TurnOff();
	clone SetTeam(player.team);
	clone.health		= clone.healthdefault;

	playerState = SpawnStruct();
	
	player player_security_breach_stage( playerState, "begin" );
	
	if(!isDefined(clone))
	{
		player disableinvulnerability();
		player cybercom::enableCybercom();
		return;
	}
		
	player.hijacked_vehicle_entity = clone;
	
	player player_security_breach_stage( playerState, "cloak" );

	clone thread _invulnerableForATime(GetDvarInt( "scr_security_breach_no_damage_time", 8 ),player);
	
	if(isDefined(clone.vehicletype) && clone.vehicletype != "turret_sentry") //disable range futz for turret since its stationary.
		clone thread _anchor_to_location(player,player.origin);
	
	clone.blockTween = 1;
	clone MakeVehicleUsable();
	clone usevehicle( player, 0 );
	clone MakeVehicleUnUsable();

	player player_security_breach_stage( playerState, "cloak_wait" );

	clone clientfield::set( "vehicle_hijacked", 1);  //wasp handled differently in spectate
	clone.blockTween = undefined;
	clone MakeVehicleUsable();
	clone thread _wait_for_return(player);
	
	player player_security_breach_stage( playerState, "return_wait" );
	
	visionset_mgr::deactivate( "visionset", "hijack_vehicle_blur", player );

	player player_security_breach_stage( playerState, "finish" );
}


function player_security_breach_stage( obj_state, str_state ) // self = player
{
	assert( isPlayer( self ) );
	
	player = self;

	switch ( str_state ) 
	{
		case "begin":
			player SetControllerUIModelValue( "vehicle.outOfRange", 0 );
			player util::freeze_player_controls( true );
			player enableinvulnerability();
			player cybercom::disableCybercom(true);	
			wait 0.1;
			return;
			
		case "cloak":
			obj_state.oldstance 		= player getstance();
			obj_state.oldignoreme 	= player.ignoreme;
			obj_state.oldTacMode		= player.b_tactical_mode_enabled;
			
			player.b_tactical_mode_enabled=false;
			player.ignoreme = true;
			//player setUsingRemote( "cybercom_hijack" );	
			player SetClientUIVisibilityFlag( "weapon_hud_visible", 0 ); 	
			player setStance("crouch");
			player clientfield::set( "camo_shader", 2 );
			//player camo_loop_sound();  //turn on camo suit audio
			player thread _start_transition( 2 );
		
			player thread _security_breach_ramp_visionset( player, "hijack_vehicle", 0.1, 1, 0.1 );
		
			player waittill("transition_in_do_switch");
			
			//obj_state.oldAds = player AllowAds( false );
			player util::set_low_ready( true );
			visionset_mgr::activate( "visionset", "hijack_vehicle_blur", player );
			player Hide();
			player NotSolid();
			player clientfield::set( "camo_shader", 1 );
			player clientfield::set_to_player( "sndInDrivableVehicle", 1 );
		//	player player::take_weapons();
			return;
			
		case "cloak_wait":
			player waittill("transition_done");
			player clientfield::set_to_player("vehicle_hijacked",1);
			player util::freeze_player_controls( false );
			return "return_wait";
		
		case "return_wait":
			player waittill("return_to_body");
		//	player player::give_back_weapons();
			player thread _security_breach_ramp_visionset( player, "hijack_vehicle", 0.0, -1, 0.1 );
			return;

		case "finish":
			player Show();
			player Solid();
			player setStance( obj_state.oldstance );
			player util::set_low_ready( false );
			//player AllowAds( obj_state.oldAds );
			player.b_tactical_mode_enabled=obj_state.oldTacMode;
			player waittill("transition_done");
			player clientfield::set_to_player("vehicle_hijacked",0);
			player clientfield::set_to_player("sndInDrivableVehicle",0);
			player.hijacked_vehicle_entity	= undefined;
			player disableinvulnerability();
			player.ignoreme = obj_state.oldignoreme;
		//	player clearUsingRemote();
			player SetClientUIVisibilityFlag( "weapon_hud_visible", 1 ); 	
			player cybercom::enableCybercom();
			wait 1;
			player clientfield::set( "camo_shader", 0 );
			player notify ("stop_camo_sound");  //turn off camo suit audio
			return;
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function _start_transition( direction )
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
			if (self IsTouching(player.cybercom.secBreachAnchorEnt) )
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
			self SetTeam("axis");
			self.takedamage = true;
			self.owner = undefined;
			self.skipFriendlyFireCheck = true;
			if(isDefined(player))
				self kill(self.origin,player);
			else
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
	
	if(isDefined(vehicle.archetype) && vehicle.archetype == "wasp" && !( isdefined( vehicle.no_spectate_chase ) && vehicle.no_spectate_chase ) )
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
	self SetTeam("axis");
	self.takedamage = true;
	self.owner = undefined;
	if(isDefined(player))
		self kill(self.origin,player,player,GetWeapon("gadget_remote_hijack"));
	else
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
	player waittill("return_to_body",reason);

	{wait(.05);};
	player SetOrigin(original_location);
	player SetPlayerAngles(original_angles);
	{wait(.05);};
	
	if(isDefined(self))
	{
		self SetTeam("axis");
		self.takedamage = true;
		self.owner = undefined;
		if(isDefined(player))
		{
			self kill(self.origin,player);
		}
		else
		{
			self kill();
		}
	}

	player.cybercom.tacrigs_disabled = undefined;
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

	
function waspToggleMyCloneChaseCam(onOff,entNum)//thread on level
{
	while(1)
	{
		level waittill("ClonedEntity",clone,vehEntNum);
		if (vehEntNum == entNum)
		{
			clone.no_spectate_chase = onOff;
			return;
		}
	}
}

function waspTakeOverWatcher()//self == wasp
{
	self endon("death");
	self waittill("CloneAndRemoveEntity",myEntNum);
	level thread waspToggleMyCloneChaseCam(false,myEntNum);
}
	


