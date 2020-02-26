// Callback set up, clientside.

#include clientscripts\_utility;
#include clientscripts\_vehicle;
#include clientscripts\_lights;
#include clientscripts\_fx;

statechange(clientNum, system, newState)
{

	if(!isdefined(level._systemStates))
	{
		level._systemStates = [];
	}

	if(!isdefined(level._systemStates[system]))
	{
		level._systemStates[system] = spawnstruct();
	}

	//level._systemStates[system].oldState = oldState;
	level._systemStates[system].state = newState;
	
	if(isdefined(level._systemStates[system].callback))
	{
		[[level._systemStates[system].callback]](clientNum, newState);
	}
	else
	{
		/#println("*** Unhandled client system state change - " + system + " - has no registered callback function.");#/
	}
}

maprestart()
{
	/#println("*** Client script VM map restart.");#/
	
	// This really needs to be in a loop over 0 -> num local clients.
	// syncsystemstates(0);
}

glass_smash(org, dir)
{

	level notify("glass_smash", org, dir);
	
	//debugstar(org, 20, (0,1,0));
}

soundsetambientstate(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom)
{
	clientscripts\_ambientpackage::setCurrentAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom);
}

soundsetaiambientstate(triggers, actors, numTriggers)
{
	self thread clientscripts\_ambientpackage::setCurrentAiAmbientState(triggers, actors, numTriggers);
}

init_fx(clientNum)
{
	waitforclient(clientNum);
	clientscripts\_fx::fx_init(clientNum);
}

AddCallback(event, func)
{
	assert(IsDefined(event), "Trying to set a callback on an undefined event.");

	if (!IsDefined(level._callbacks) || !IsDefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}

	level._callbacks[event] = add_to_array(level._callbacks[event], func, false);
}

Callback(event,clientNum)
{
	if (IsDefined(level._callbacks) && IsDefined(level._callbacks[event]))
	{
		for (i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i];
			if (IsDefined(callback))
			{
				self thread [[callback]](clientNum);
			}
		}
	}
}

localclientconnect(clientNum)
{
	/#println("*** Client script VM : Local client connect " + clientNum);#/
	
	level.usetreadfx = 1;
	if(isdefined(level._load_done) && clientNum > 0)
	{
		level notify( "kill_treads_forever" );	// doesn't work in split screen yet.
		level.usetreadfx = 0;	
	}
	
	if(!isdefined(level._laststand))
	{
		level._laststand = [];
	}
	
	level._laststand[clientNum] = false;
	
	level notify("connected", clientNum);

	level thread localclientconnect_callback(clientNum);
}

localclientconnect_callback(clientNum)
{
	wait .01;	// player will be undefined if we don't wait here.
	player = level.localPlayers[clientNum];
	player Callback("on_player_connect",clientNum);
}

localclientdisconnect(clientNum)
{
	/#println("*** Client script VM : Local client disconnect " + clientNum);#/
}

playerspawned(localClientNum)
{
	self endon( "entityshutdown" );

	self thread clientscripts\_flamethrower_plight::play_pilot_light_fx( localClientNum );

	if(isdefined(level._faceAnimCBFunc))
		self thread [[level._faceAnimCBFunc]](localClientNum);
		
	if(isdefined(level._playerCBFunc))
		self thread [[level._playerCBFunc]](localClientNum);
	
}

CodeCallback_GibEvent( localClientNum, type, locations )
{
	if ( isdefined( level._gibEventCBFunc ) )
	{
		self thread [[level._gibEventCBFunc]]( localClientNum, type, locations );
	}
}

get_gib_def()
{
	if( !isdefined( level._gibbing_actor_models ) )
	{
		return -1;
	}
	
	for ( i = 0; i < level._gibbing_actor_models.size; i++ )
	{
		if ( self [[level._gibbing_actor_models[i].matches_me]]() )
		{
			self._original_model = self.model;	// Store this off in case were switched to the gib body before we get the message to create our bits.
			return i;
		}
	}
	
	return -1;
}

entityspawned(localClientNum)
{
	self endon( "entityshutdown" );
	
	if ( !isdefined( self.type ) )
	{
		/#PrintLn( "Entity type undefined!" );#/
		return;
	}
	
	//println("type: " + self.type + " weapon: " + self.weapon );

	//PrintLn( "Entity type: " + self.type );
	if ( self.type == "missile"  )
	{		
		if ( isDumbRocketLauncherWeapon(self.weapon) )
		{
			self thread clientscripts\_audio::rpgWhizbyWatcher();
		}
		//PrintLn( "entity spawned: " + self.weapon + "\n" );
		switch( self.weapon )
		{
			case "explosive_bolt_sp":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, true, false );
				break;
			case "explosive_bolt_zm":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, true, false );
				break;
			case "explosive_bolt_upgraded_zm":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, true, true );
				break;
			case "crossbow_explosive_sp":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, true, false );
				break;
			case "crossbow_explosive_zm":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, true, false );
				break;
			case "crossbow_explosive_upgraded_zm":
				self thread clientscripts\_explosive_bolt::spawned( localClientNum, false, true );
				break;
			case "claw_grenade_sp": // AI claw weapon
			case "bigdog_launcher":	// player claw turret weapon
				self thread clientscripts\_claw_grenade::spawned( localClientNum/*, true, false*/ );
				break;
			case "network_intruder_sp":
				self thread clientscripts\_network_intruder::spawned( localClientNum );
				break;
			case "explosive_dart_sp":
			case "titus_explosive_dart_sp":
				self thread clientscripts\_explosive_dart::spawned( localClientNum );
				break;
		}
	}

	if( self.type == "vehicle"  )
	{	
		// if _load.csc hasn't been called (such as in most testmaps), set up vehicle arrays specifically
		if( !isdefined( level.vehicles_inited ) )
		{
			clientscripts\_vehicle::init_vehicles();
		}
		
		clientscripts\_treadfx::loadtreadfx(self); 
		
		if( isdefined(level._customVehicleCBFunc) )
		{
			self thread [[level._customVehicleCBFunc]](localClientNum);
		}
	
		if( self is_4wheel() )
		{
			//self clientscripts\_helicopter_sounds::veh_throttle();	
			self thread clientscripts\_audio::play_death_fire_loop();
		}

		self thread play_exhaust( localClientNum );
		self thread lights_on( localClientNum );
		
		// aircrafts don't need everything
		if ( !( self is_plane() ) && !(self is_helicopter()) && level.usetreadfx == 1 )
		{
			// start load fx assets
			assert( isdefined( self.rumbleType ) );
			precacherumble( self.rumbleType );

			// end load fx assets
			self thread vehicle_treads(localClientNum);
			self thread vehicle_rumble(localClientNum);
			self thread vehicle_variants(localClientNum);
			self thread vehicle_weapon_fired();
		}
		else if (self is_plane())
		{
			//println("*** Client : Aircraft dustkick.");
			self thread aircraft_dustkick();
			
			//adding jet support to heli scripts
			self clientscripts\_helicopter_sounds::start_helicopter_sounds();		
		}

		else if(self is_helicopter())
		{
			//println("Client: is helicopter");
			
			// start load fx assets
			assert( isdefined( self.rumbleType ) );
			precacherumble( self.rumbleType );

			self thread aircraft_dustkick();

			self clientscripts\_helicopter_sounds::start_helicopter_sounds();
		}
	}

	if( self.type == "actor" && isdefined(level._faceAnimCBFunc) )
	{
		self thread [[level._faceAnimCBFunc]](localClientNum);
	}

	self.entity_spawned = true;
	self notify("entity_spawned");
/*	
	if(  self.type == "vehicle" )
	{
		printLn( "^5a self.vehicleclass used in _helicopter_sounds.csc = " + self.vehicleclass);
	}
*/
}
entityshutdown_callback( localClientNum, entity )
{
	if( IsDefined( level._entityShutDownCBFunc ) )
	{
		[[level._entityShutDownCBFunc]]( localClientNum, entity );
	}
}

localClientChanged_callback( localClientNum )
{
	// localClientChanged need to get updated players
	level.localPlayers = getLocalPlayers();
}


airsupport( localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype )
{
	pos = ( x, y, z );
	
	switch( teamFaction )
	{
		case "v":
			teamfaction = "vietcong";
			break;
		case "n":
		case "nva":
			teamfaction = "nva";
			break;
		case "j":
			teamfaction = "japanese";
			break;
		case "m":
			teamfaction = "marines";
			break;
		case "s":
			teamfaction = "specops";
			break;
		case "r":
			teamfaction = "russian";
			break;
		default:
			/#
			println( "Warning: Invalid team char provided, defaulted to marines" );
			println( teamFaction  + "\n" );
			#/
			teamfaction = "marines";
			break;
	}
	
	switch( team )
	{
		case "x":
			team = "axis";
			break;
		case "l":
			team = "allies";
			break;
		case "r":
			team = "free";
			break;
		default:
			/#println( "Invalid team used with playclientAirstike/napalm: " + team + "\n");#/
			team = "allies";
			break;
	}
	
	switch( exitType )
	{
		case "l":
			exitType = "left";
			break;
		case "r":
			exitType = "right";
			break;
		case "s":
			exitType = "straight";
			break;
		case "b":
			exitType = "barrelroll";
			break;
		default:
			/#
			println( "Warning: Incorret exit type, defaulting to left" );
			println( exitType + "\n" );
			#/
			team = "left";
			break;
	}
	
	if ( type == "n" )
	{
		clientscripts\_napalm::startNapalm( localClientNum, pos, yaw, teamfaction, team, owner, exitType );
	}
	else
	{	
		/#
		println( "" );
		println( "Unhandled airsupport type, only A (airstrike) and N (napalm) supported" );
		println( type );
		println( "" );
		#/
	}
}

scriptmodelspawned(local_client_num, ent, destructable_index)
{
	if(destructable_index == 0)
		return;		// Get out of here.
	
	if(!isdefined(level.createFXent))
		return;

	fixed = false;
		
	for(i = 0; i < level.createFXent.size; i ++)
	{
		if(level.createFXent[i].v["type"] != "exploder")
			continue;
			
		exploder = level.createFXent[i];
		
		if(!isdefined(exploder.needs_fixup))
			continue;
			
		if(exploder.needs_fixup == destructable_index)
		{
//			structinfo(exploder);
			
			//exploder.v["origin"] = ent.origin;
			//exploder.v["angles"] = ent.angles;

/*			println("exp org " + exploder.v["origin"]);
			println("ent org " + ent.origin);
			println("ent ang " + ent.angles); */

			exploder.v["angles"] = VectorToAngles( ent.origin - exploder.v["origin"] ); 	

			exploder clientscripts\_fx::set_forward_and_up_vectors();

/*			keys = getarraykeys(exploder.v);
			
			for(i = 0; i < keys.size; i ++)
			{
				println(keys[i] + " : " + exploder.v[keys[i]]);
			}			

			
			println("** Fixed up exploder " + i);	*/
			exploder.needs_fixup = undefined;
			fixed = true;
		}
	}	
}

callback_activate_exploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
		return;

	keys = getarraykeys(level._exploder_ids);

	exploder = undefined;
	
	for(i = 0; i < keys.size; i ++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}

	if(!isdefined(exploder))
	{
		//println("*** Client : Exploder id " + exploder_id + " unknown.");
		return;
	}

	//println("*** Client callback - activate exploder " + exploder_id + " : " + exploder);

	clientscripts\_fx::activate_exploder(exploder);
}

callback_deactivate_exploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
		return;

	keys = getarraykeys(level._exploder_ids);

	exploder = undefined;
	
	for(i = 0; i < keys.size; i ++)
	{
		if(level._exploder_ids[keys[i]] == exploder_id)
		{
			exploder = keys[i];
			break;
		}
	}

	if(!isdefined(exploder))
	{
		//println("*** Client : Exploder id " + exploder_id + " unknown.");
		return;
	}

	//println("*** Client callback - deactivate exploder " + exploder_id + " : " + exploder);

	clientscripts\_fx::deactivate_exploder(exploder);
}

sound_notify(client_num, entity,  note )
{
	if ( note == "sound_dogstep_run_default" )
	{
		entity playsound( client_num, "fly_dog_step_run_default" );
		return true;
	}	
	prefix = getsubstr( note, 0, 5 );

	if ( prefix != "sound" )
		return false;
		
	alias = "aml" + getsubstr( note, 5 );

	entity play_dog_sound( client_num, alias);
}

dog_sound_print( message )
{
/# 
	level.dog_debug_sound = false;
	
	if (!level.dog_debug_sound)
		return;
		
	println("CLIENT DOG SOUND: " + message );
#/
}

play_dog_sound( localClientNum, sound, position )
{
	dog_sound_print( "SOUND " + sound);
	
	if ( isdefined( position ) )
	{
		return self playsound( localClientNum, sound, position );
	}
	
	return self playsound( localClientNum, sound );
}

client_flag_callback(localClientNum, flag, set, newEnt)
{
	level endon("save_restore");
	if ((self.type == "vehicle" || self.type == "actor" || self.type == "missle") && !IsDefined(self.entity_spawned))
	{
		// makes sure entity is fully set up before handling flags
		//PrintLn("CFCB : ent " + self GetEntityNumber() + " waiting.");
		self waittill("entity_spawned");
		//PrintLn("CFCB : ent " + self GetEntityNumber() + " done waiting.");
	}

	if(isdefined(level._client_flag_callbacks) && isdefined(level._client_flag_callbacks[self.type]) && IsDefined(level._client_flag_callbacks[self.type][flag]))
	{
		//PrintLn("*** CFCB " + self.type + " " + flag);
		self thread [[level._client_flag_callbacks[self.type][flag]]](localClientNum, set, newEnt);
	}
	else
	{
//		PrintLn("*** : Clientflag callback Got flag " + flag + " for ent type " + self.type + " But no callback exists for it.");
	}
}

client_flagasval_callback(localClientNum, val)
{
	if(isdefined(level._client_flagasval_callbacks) && isdefined(level._client_flagasval_callbacks[self.type]))
	{
		self thread [[level._client_flagasval_callbacks[self.type]]](localClientNum, val);
	}
}

CodeCallback_CreatingCorpse(localClientNum, player )
{
	player notify( "face", "face_death" );
}

CodeCallback_PlayerJump(client_num, player, ground_type, firstperson, quiet, isLouder)
{
	clientscripts\_footsteps::playerJump(client_num, player, ground_type, firstperson, quiet);
}

CodeCallback_PlayerLand(client_num, player, ground_type, firstperson, quiet, damagePlayer, isLouder)
{
	clientscripts\_footsteps::playerLand(client_num, player, ground_type, firstperson, quiet, damagePlayer);
}

CodeCallback_PlayerFoliage(client_num, player, firstperson, quiet)
{
	clientscripts\_footsteps::playerFoliage(client_num, player, firstperson, quiet);
}

AddPlayWeaponDeathEffectsCallback(weaponname, func)
{
	if (!IsDefined(level._playweapondeatheffectscallbacks))
	{
		level._playweapondeatheffectscallbacks = [];
	}

	level._playweapondeatheffectscallbacks[weaponname] = func;
}

CodeCallback_PlayWeaponDeathEffects( localclientnum, weaponname, userdata )
{
	if (IsDefined(level._playweapondeatheffectscallbacks) && IsDefined(level._playweapondeatheffectscallbacks[weaponname]))
	{
		self thread [[level._playweapondeatheffectscallbacks[weaponname]]]( localclientnum, weaponname, userdata );
	}
}

AddPlayWeaponDamageEffectsCallback(weaponname, func)
{
	if (!IsDefined(level._playweapondamageeffectscallbacks))
	{
		level._playweapondamageeffectscallbacks = [];
	}

	level._playweapondamageeffectscallbacks[weaponname] = func;
}

CodeCallback_PlayWeaponDamageEffects( localclientnum, weaponname, userdata )
{
	if (IsDefined(level._playweapondamageeffectscallbacks) && IsDefined(level._playweapondamageeffectscallbacks[weaponname]))
	{
		self thread [[level._playweapondamageeffectscallbacks[weaponname]]]( localclientnum, weaponname, userdata );
	}
}

CodeCallback_SUIMessage(localclientnum,param1, param2)
{
	if (isDefined(level.onSUIMessage))
		[[level.onSUIMessage]](localclientnum,param1,param2);
}

CodeCallback_ArgusNotify(localclientnum,argusID,userTag,message)
{
	if (isDefined(level.onArgusNotify))
		return [[level.onArgusNotify]](localclientnum,argusID,userTag,message);
	return true;
}
