#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace callback;

function callback( event, localclientnum, params )
{
	if ( isdefined( level._callbacks ) && isdefined( level._callbacks[event] ) )
	{
		for ( i = 0; i < level._callbacks[event].size; i++ )
		{
			callback = level._callbacks[event][i][0];
			obj = level._callbacks[event][i][1];
			
			if ( !isdefined( callback ) )
			{
				continue;
			}

			if ( isdefined( obj ) )
			{
				if ( isdefined( params ) )
				{
					obj thread [[callback]]( localclientnum, self, params );
				}
				else
				{
					obj thread [[callback]]( localclientnum, self );
				}
			}
			else
			{
				if ( isdefined( params ) )
				{
					self thread [[callback]]( localclientnum, params );
				}
				else
				{
					self thread [[callback]]( localclientnum );
				}
			}
		}
	}
}

function add_callback( event, func, obj )
{
	assert( isdefined( event ), "Trying to set a callback on an undefined event." );

	if ( !isdefined( level._callbacks ) || !isdefined( level._callbacks[event] ) )
	{
		level._callbacks[event] = [];
	}

	array::add( level._callbacks[event], array( func, obj ), false );
	
	if ( isdefined( obj ) )
	{
		obj thread remove_callback_on_death( event, func );
	}
}

function remove_callback_on_death( event, func )
{
	self waittill( "death" );
	remove_callback( event, func, self );
}

function remove_callback( event, func, obj )
{
	assert( isdefined( event ), "Trying to remove a callback on an undefined event." );
	assert( isdefined( level._callbacks[event] ), "Trying to remove callback for unknown event." );
	
	foreach ( index, func_group in level._callbacks[event] )
	{
		if ( func_group[0] == func )
		{
			if ( ( func_group[1] === obj ) )
			{
				ArrayRemoveIndex( level._callbacks[event], index, false );
			}
		}
	}
}

/@
"Name: on_localclient_connect(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when the local client connects"
"MandatoryArg: <func> the function you want to call on the new local client."
"Example: callback::on_localclient_connect(&on_player_connect);"
"SPMP: MP"
@/
function on_localclient_connect( func, obj )
{
	add_callback( #"on_localclient_connect", func, obj );
}

/@
"Name: on_finalize_initialization(<func>)"
"Module: Callbacks"
"Summary: Set a callback for afer final initialization"
"MandatoryArg: <func> the function you want to call."
"Example: callback::on_finalize_initialization( &foo );"
@/
function on_finalize_initialization( func, obj )
{
	add_callback( #"on_finalize_initialization", func, obj );
}

/@
"Name: on_spawned(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player spawns in the game"
"MandatoryArg: <func> the function you want to call on the player."
"Example: callback::on_spawned( &foo );"
@/
function on_spawned( func, obj )
{
	add_callback( #"on_player_spawned", func, obj );
}

/@
"Name: on_shutdown(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an entity is shutdown"
"MandatoryArg: <func> the function you want to call on the entity."
"Example: callback::on_shutdown( &foo );"
@/
function on_shutdown( func, obj )
{
	add_callback( #"on_entity_shutdown", func, obj );
}

/@
"Name: on_start_gametype(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player starts a gametype"
"MandatoryArg: <func> the function you want to call on the player."
"Example: callback::on_start_gametype( &init );"
@/
function on_start_gametype( func, obj )
{
	add_callback( #"on_start_gametype", func, obj );
}


/*================
Called by code before level main but after autoexecs
================*/
function CodeCallback_PreInitialization()
{
	callback::callback( #"on_pre_initialization" );
	system::run_pre_systems();
}

/*================
Called by code as the final step of initialization
================*/
function CodeCallback_FinalizeInitialization()
{
	system::run_post_systems();
	callback::callback( #"on_finalize_initialization" );
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// Files moved from _callbacks.csc
//////////////////////////////////////////////////////////////////////////////////////////////////

function CodeCallback_StateChange(clientNum, system, newState)
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
	/#	println("*** Unhandled client system state change - " + system + " - has no registered callback function.");	#/
	}
}

function CodeCallback_MapRestart()
{
/#	println("*** Client script VM map restart.");	#/
	
	// This really needs to be in a loop over 0 -> num local clients.
	// syncsystemstates(0);
	util::waitforclient( 0 );	
	level thread util::init_utility();
}

function CodeCallback_LocalClientConnect( localClientNum )
{
/#	println("*** Client script VM : Local client connect " + localClientNum);	#/
	[[level.callbackLocalClientConnect]]( localClientNum );
}

function CodeCallback_LocalClientDisconnect(clientNum)
{
/#	println("*** Client script VM : Local client disconnect " + clientNum);	#/
}

function CodeCallback_GlassSmash(org, dir)
{
	level notify("glass_smash", org, dir);
}

function CodeCallback_SoundSetAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom)
{
	audio::setCurrentAmbientState(ambientRoom, ambientPackage, roomColliderCent, packageColliderCent, defaultRoom);
}

function CodeCallback_SoundSetAiAmbientState(triggers, actors, numTriggers)
{
}

function CodeCallback_SoundPlayUiDecodeLoop(decodeString, playTimeMs)
{
	self thread audio::soundplayuidecodeloop(decodeString, playTimeMs);
}

function CodeCallback_PlayerSpawned(localClientNum)
{
	/#	PrintLn("****CodeCallback_PlayerSpawned****");	#/
	[[level.callbackPlayerSpawned]]( localClientNum );	
}


function CodeCallback_GibEvent( localClientNum, type, locations )
{
	if ( isdefined( level._gibEventCBFunc ) )
	{
		self thread [[level._gibEventCBFunc]]( localClientNum, type, locations );
	}
}

/*================
function Called by code after the level's main script function has run - only called from CG_Init() - not from CG_MapRestart()
================*/

function CodeCallback_PrecacheGameType()
{
	if(isdefined(level.callbackPrecacheGameType))
	{
		[[level.callbackPrecacheGameType]]();
	}
}

/*================
Called by code after the level's main script function has run.
================*/
function CodeCallback_StartGameType()
{
	// If the gametype has not beed started, run the startup
	if(isdefined(level.callbackStartGameType) && (!isdefined(level.gametypestarted) || !level.gametypestarted))
	{
		[[level.callbackStartGameType]]();

		level.gametypestarted = true; // so we know that the gametype has been started up
	}
}

function CodeCallback_EntitySpawned(localClientNum)
{
	[[level.callbackEntitySpawned]]( localClientNum );
}

function CodeCallback_SoundNotify( localClientNum, entity, note )
{
	switch( note )
	{
		case "scr_bomb_beep":
			// tagTMR<NOTE>: add custom game mode override for silencing 3p bomb beep
			if ( GetGametypeSetting( "silentPlant" ) == 0 )
			{
				entity PlaySound( localClientNum, "fly_bomb_buttons_npc" );
			}
			break;
	}	
}

function CodeCallback_EntityShutdown( localClientNum, entity )
{
	if( isdefined( level.callbackEntityShutdown ) )
	{
		[[level.callbackEntityShutdown]]( localClientNum, entity );
	}
	
	entity callback::callback( #"on_entity_shutdown", localClientNum );
}

function CodeCallback_LocalClientChanged( localClientNum )
{
	// localClientChanged need to get updated players
	level.localPlayers = getLocalPlayers();
}


function CodeCallback_AirSupport( localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height )
{
	if( isdefined( level.callbackAirSupport ) )
	{
		[[level.callbackAirSupport]]( localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height );
	}	
}

function CodeCallback_DemoJump( localClientNum, time )
{
	level notify( "demo_jump", time );
	level notify( "demo_jump" + localClientNum, time );
}

function CodeCallback_DemoPlayerSwitch( localClientNum )
{
	level notify( "demo_player_switch" );
	level notify( "demo_player_switch" + localClientNum );
}

function CodeCallback_PlayerSwitch( localClientNum )
{
	level notify( "player_switch" );
	level notify( "player_switch" + localClientNum );
}

function CodeCallback_KillcamBegin( localClientNum, time )
{
	level notify( "killcam_begin", time );
	level notify( "killcam_begin" + localClientNum, time );
}

function CodeCallback_KillcamEnd( localClientNum, time )
{
	level notify( "killcam_end", time );
	level notify( "killcam_end" + localClientNum, time );
}

function CodeCallback_CreatingCorpse(localClientNum, player )
{
	if( isdefined( level.callbackCreatingCorpse ) )
	{
		[[level.callbackCreatingCorpse]]( localClientNum, player );
	}
}

function CodeCallback_PlayerFoliage(client_num, player, firstperson, quiet)
{
	footsteps::playerFoliage(client_num, player, firstperson, quiet);
}

function CodeCallback_ActivateExploder(exploder_id)
{
	if(!isdefined(level._exploder_ids))
	{
		//PrintLn("No exploder_ids");
		return;
	}

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
		//PrintLn("*** Client : Exploder id " + exploder_id + " unknown.");
		return;
	}

	//PrintLn("*** Client callback - activate exploder " + exploder_id + " : " + exploder);

	exploder::activate_exploder(exploder);
}

function CodeCallback_DeactivateExploder(exploder_id)
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

	exploder::stop_exploder(exploder);
}

function CodeCallback_ChargesHotWeaponSoundNotify( localClientNum, weapon, chargeShotLevel )
{	
	if( isdefined( level.sndChargeShot_Func ) )
	{
		self [[level.sndChargeShot_Func]]( localClientNum, weapon, chargeShotLevel );
	}
}

function CodeCallback_HostMigration( localClientNum )
{
	/# println("*** Client:  CodeCallback_HostMigration()"); #/
	if( isdefined( level.callbackHostMigration ) )
	{
		[[level.callbackHostMigration]]( localClientNum );
	}	
}

function CodeCallback_DogSoundNotify(client_num, entity,  note )
{
	if( isdefined( level.callbackDogSoundNotify ) )
	{	
		[[level.callbackDogSoundNotify]]( client_num, entity,  note );
	}
}

function CodeCallback_PlayAIFootstep(client_num, pos, surface, notetrack, bone)
{	
	[[level.callbackPlayAIFootstep]]( client_num, pos, surface, notetrack, bone );
}

function CodeCallback_PlayLightLoopExploder( exploderIndex )
{
	[[level.callbackPlayLightLoopExploder]]( exploderIndex );
}

function CodeCallback_StopLightLoopExploder( exploderIndex )
{
	num = Int(exploderIndex);
	
	if(isdefined(level.createFXexploders[num]))	
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			ent = level.createFXexploders[num][i];

			if ( !isdefined( ent.looperFX ) ) 
			{
				ent.looperFX = [];
			}
	
	    for( clientNum = 0; clientNum < level.max_local_clients; clientNum++ )
	    {
		    if( localClientActive( clientNum ) )
		    {
					if ( isdefined( ent.looperFX[clientNum] ) )
					{
						for( looperFXCount = 0; looperFXCount < ent.looperFX[clientNum].size; looperFXCount++ )
						{
							deletefx( clientNum, ent.looperFX[clientNum][looperFXCount] );
						}
					}
				}
				
				ent.looperFX[clientNum] = [];
			}
			
			ent.looperFX = [];
		}
	}
}

function CodeCallback_ClientFlag( localClientNum, flag, set )
{
	if( isdefined( level.callbackClientFlag ) )
	{
		[[level.callbackClientFlag]]( localClientNum, flag, set );	
	}
}

function CodeCallback_ClientFlagAsVal(localClientNum, val)
{
	if(isdefined(level._client_flagasval_callbacks) && isdefined(level._client_flagasval_callbacks[self.type]))
	{
		self thread [[level._client_flagasval_callbacks[self.type]]](localClientNum, val);
	}
}

function CodeCallback_ExtraCamRenderHero( localClientNum, extraCamIndex, jobIndex, characterIndex )
{
	if ( isdefined( level.extra_cam_render_hero_func_callback ) )
	{
		[[level.extra_cam_render_hero_func_callback]]( localClientNum, extraCamIndex, jobIndex, characterIndex );
	}
}

function CodeCallback_ExtraCamRenderLobbyClientHero( localClientNum, extraCamIndex, jobIndex )
{
	if ( isdefined( level.extra_cam_render_lobby_client_hero_func_callback ) )
	{
		[[level.extra_cam_render_lobby_client_hero_func_callback]]( localClientNum, extraCamIndex, jobIndex );
	}
}

function CodeCallback_ExtraCamRenderCurrentHeroHeadshot( localClientNum, extraCamIndex, jobIndex, characterIndex, isDefaultHero )
{
	if ( isdefined( level.extra_cam_render_current_hero_headshot_func_callback ) )
	{
		[[level.extra_cam_render_current_hero_headshot_func_callback]]( localClientNum, extraCamIndex, jobIndex, characterIndex, isDefaultHero );
	}
}

function CodeCallback_ExtraCamRenderOutfitPreview( localClientNum, extraCamIndex, jobIndex, outfitIndex )
{
	if ( isdefined( level.extra_cam_render_outfit_preview_func_callback ) )
	{
		[[level.extra_cam_render_outfit_preview_func_callback]]( localClientNum, extraCamIndex, jobIndex, outfitIndex );
	}
}

function add_weapon_type( weapontype, callback )
{
	if ( !isdefined( level.weapon_type_callback_array ) )
	{
		level.weapon_type_callback_array = [];
	}
	
	if ( IsString(weapontype) )
	{
		weapontype = GetWeapon(weapontype);
	}
	
	level.weapon_type_callback_array[weapontype] = callback;
}

function spawned_weapon_type( localClientNum )
{
	weapontype = self.weapon.rootweapon;
	if( isdefined( level.weapon_type_callback_array ) && isdefined( level.weapon_type_callback_array[weapontype] ) )
	{
		self thread [[level.weapon_type_callback_array[weapontype]]]( localClientNum );
	}
}

function add_treadfx_type( vehicletype, callback )
{
	if ( !isdefined( level.treadfx_callback_array ) )
	{
		level.treadfx_callback_array = [];
	}
	
	level.treadfx_callback_array[vehicletype] = callback;
}

function load_treadfx_type()
{
	vehicletype = self.vehicletype;
	if( isdefined( level.treadfx_callback_array ) && isdefined( level.treadfx_callback_array[vehicletype] ) )
	{
		self thread [[level.treadfx_callback_array[vehicletype]]]();
	}	
}

/*================
Called when an animation notetrack for calling a script function is encountered.
pSelf is the entity playing the animation that is executing the notetrack
label is the label set for the function to be called
param is a string containing all parameters passed through the notetrack
================*/
function CodeCallback_CallClientScript( pSelf, label, param )
{
	if ( !IsDefined( level._animnotifyfuncs ) )
		return;
	
	if ( IsDefined( level._animnotifyfuncs[ label ] ) )
	{
		pSelf [[ level._animnotifyfuncs[ label ] ]]( param );
	}
}

function CodeCallback_CallClientScriptOnLevel( label, param )
{
	if ( !IsDefined( level._animnotifyfuncs ) )
		return;
	
	if ( IsDefined( level._animnotifyfuncs[ label ] ) )
	{
		level [[ level._animnotifyfuncs[ label ] ]]( param );
	}
}

function CodeCallback_ServerSceneInit( scene_name )
{
	if( IsDefined( level.server_scenes[ scene_name ] ) )
	{
		level thread scene::init( scene_name );
	}
}

function CodeCallback_ServerScenePlay( scene_name )
{
	level thread scene_black_screen();
	
	if( isdefined( level.server_scenes[ scene_name ] ) )
	{
		level thread scene::play( scene_name );
	}
}

function CodeCallback_ServerSceneStop( scene_name )
{
	level thread scene_black_screen();
	
	if( isdefined( level.server_scenes[ scene_name ] ) )
	{
		level thread scene::stop( scene_name, undefined, undefined, undefined, true );
	}
}

function scene_black_screen()
{
	foreach ( i, player in level.localplayers )
	{
		if ( !isdefined( player.lui_black ) )
		{
			player.lui_black = CreateLUIMenu( i, "FullScreenBlack" );
			OpenLUIMenu( i, player.lui_black );
		}
	}
	
	{wait(.016);};
	
	foreach ( i, player in level.localplayers )
	{
		if ( isdefined( player.lui_black ) )
		{
			CloseLUIMenu( i, player.lui_black );
			player.lui_black = undefined;
		}
	}
}

function CodeCallback_GadgetVisionPulse_Reveal(local_client_num, entity, bReveal )
{
	if( isdefined( level.gadgetVisionPulse_reveal_func ) )
	{
		entity [[level.gadgetVisionPulse_reveal_func]](local_client_num, bReveal );	
	}	 
}