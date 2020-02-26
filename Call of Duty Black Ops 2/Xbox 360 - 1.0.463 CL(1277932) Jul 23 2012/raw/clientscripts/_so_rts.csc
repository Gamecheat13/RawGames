
#include clientscripts\_utility; 
#include clientscripts\_filter;
#include clientscripts\_audio;
#include clientscripts\_ambientpackage;

#insert raw\maps\_so_rts.gsh;

#define RETICLE_FILTER_ID 		0
#define SATELLITE_FILTER_ID 	1


rts_init()
{	
	register_clientflag_callback( "player", FLAG_CLIENT_FLAG_ALLY_SWITCH, ::toggle_satellite_hotness );
	register_clientflag_callback( "player", FLAG_CLIENT_FLAG_REMOTE_MISSILE, ::toggle_satellite_RemoteMissile );
	register_clientflag_callback( "player", FLAG_CLIENT_FLAG_RETICLE, ::toggle_reticle );
	register_clientflag_callback( "player", FLAG_CLIENT_FLAG_THIRD_PERSON_CAM, ::toggle_third_person_cam );
	register_clientflag_callback( "actor", FLAG_CLIENT_FLAG_GPR_UPDATED, ::gpr_updated );
	register_clientflag_callback( "actor", FLAG_CLIENT_FLAG_DIED, ::entity_died );
	register_clientflag_callback( "vehicle", FLAG_CLIENT_FLAG_GPR_UPDATED, ::gpr_updated );
	register_clientflag_callback( "vehicle", FLAG_CLIENT_FLAG_DIED_VEH, ::entity_died );
	register_clientflag_callback( "scriptmover", FLAG_CLIENT_FLAG_GPR_UPDATED, ::gpr_updated );
	register_clientflag_callback( "scriptmover", FLAG_CLIENT_FLAG_MAKE_FAKE_BLACKHAWK, ::make_fake_blackhawk );


	waitforclient(0);
	thread rtsAudioTransitions();

	ui3dsetwindow( 0, 0, 0, 1, 1 );
	
	players = getlocalplayers();
	for(i=0;i<players.size;i++)
	{
		init_filter_satellite_transition( players[i] );
		init_filter_hud_projected_pip( players[i] );
	}			

	level.rts_mode				= 0;
	level.satellite_duration	= 1.2;
	level.holdFullStatic		= 0;
	level.entities				= [];
	
	level.playerHealthSystemOverride	= ::rtsHealthSystem;
	
	// for the death cam
	SetClientDvar( "cg_thirdPersonRange", 300 );
}

entity_died(localClientNum, set, newEnt )
{
	self target_unit_highlight(localClientNum,0,0);
	self sethudoutlinecolor(0);
	ArrayRemoveValue(level.entities,self);
}

gpr_updated(localClientNum, set, newEnt )
{
	signBit	 	= self.gpr & GPR_SIGN_BIT;	
	self.gpr	= self.gpr & ~GPR_SIGN_BIT;	
	data		= self.gpr & GPR_PAYLOAD;
	op			= self.gpr>>GPR_OP_SHIFT;
	if (signBit != 0 )
	{
		op |= 8;
	}
	
	switch(op)
	{
		case GPR_OP_CODE_BAR://this is the POI takeover bar
			val = data & GPR_FFFF;
			if (val>0)
			{
				self target_unit_highlight(localClientNum,1,val);
			}
			else
			{
				self target_unit_highlight(localClientNum,0,0);
			}
		break;
		case GPR_OP_CODE_SET_TEAM:				
			level.entities = remove_the_dead(level.entities);
			level.entities[level.entities.size] = self;
			self update_hudOutline();
		break; 
	}
}

make_fake_blackhawk( localClientNum, set, newEnt )
{
	if( set ) 
	{
		self.vehicletype = "heli_osprey";
		self.lightfxnamearray = [];
		self.treadfx = [];
		self.treadfx["concrete"] = loadfx( "vehicle/treadfx/fx_heli_dust_concrete" );
		self thread clientscripts\_vehicle::aircraft_dustkick();
		//self thread clientscripts\_helicopter_sounds::start_helicopter_sounds();
	}
}

initTransitionTime(time)
{
	level.satellite_duration = time;
}

holdSwitchStatic(set)
{
	level.holdFullStatic = set;
}

update_hudOutline()
{
	if(!isDefined(self))
		return;
		
	if ( level.rts_mode )
	{
		if (self.team == "allies" )
		{	
			self sethudoutlinecolor( 2 );
		}
		else
		{
			self sethudoutlinecolor( 1 );
		}
	}
	else
	{
//		self sethudoutlinecolor(0);
	}
}

remove_the_dead(arrayIn)
{
	alive = [];
	for(i=0;i<arrayIn.size;i++)
	{
		if(isDefined(arrayIn[i]))
		   alive[alive.size] = arrayIn[i];
	}
	return alive;
}

update_all_hudOutlines()
{
	level.entities = remove_the_dead(level.entities);
	for(i=0;i<level.entities.size;i++)
	{
		level.entities[i] update_hudOutline();
	}
}

target_unit_highlight(localClientNum,onOff,progValue)
{
	if (onOff < 0 )
		onOff = -1;
	if (onOff > 0 )
	{
		onOff = onOff | UNIT_HIGHLIGHT_ON;
	}

	if ( isDefined(self.max_health) && isDefined(self.health) )
	{
		health = (self.max_health<<16) + self.health;
	}
	else
	{
		health = -1;
	}
	self SetTargetHighlight(localClientNum, onOff,progValue,health); // 1 on
}

toggle_reticle(localClientNum,set, newEnt)
{
	if ( !IsDefined( level.targeting_reticle ) )
	{
		level.targeting_reticle = false;
	}
 	if ( !level.targeting_reticle && set )
    {
		enable_filter_hud_projected_pip( level.localPlayers[localClientNum], RETICLE_FILTER_ID );
		set_filter_hud_projected_pip_radius( level.localPlayers[localClientNum], RETICLE_FILTER_ID, PROJECTED_PIP_RADIUS );
    }
    else if ( level.targeting_reticle && !set )
    {
		disable_filter_hud_projected_pip( level.localPlayers[localClientNum], RETICLE_FILTER_ID );
    }	
	level.targeting_reticle = set;
   	/#
      PrintLn( "**** reticle - client **** (" + set + ")"  );
   #/
}

toggle_satellite_hotness(localClientNum,set, newEnt)
{
	if ( !IsDefined( level.satelliteTransisionActive ) )
	{
		level.satelliteTransisionActive = false;
	}
   	/#
   		PrintLn( "**** satellite - client **** set(" + set + ") active ("+level.satelliteTransisionActive+")"  );
   #/
 	if ( !level.satelliteTransisionActive && set )
    {
	    level.satelliteTransisionActive = true;
		level thread satellite_transition( localClientNum, level.satellite_duration );
    }
    else if ( level.satelliteTransisionActive && !set )
    {
        level.satelliteTransisionActive = false;
    }	
}

toggle_satellite_RemoteMissile(localClientNum,set, newEnt)
{
	if ( !IsDefined( level.satelliteTransisionActive ) )
	{
		level.satelliteTransisionActive = false;
	}
 	if ( !level.satelliteTransisionActive && set )
    {
		enable_filter_satellite_transition( level.localPlayers[localClientNum], SATELLITE_FILTER_ID );
	    level.satelliteTransisionActive = true;
	   	set_filter_satellite_transition_amount( level.localPlayers[localClientNum], SATELLITE_FILTER_ID, 0.7);	
     }
    else if ( level.satelliteTransisionActive && !set )
    {
		disable_filter_satellite_transition( level.localPlayers[localClientNum], SATELLITE_FILTER_ID );
        level.satelliteTransisionActive = false;
	   	set_filter_satellite_transition_amount( level.localPlayers[localClientNum], SATELLITE_FILTER_ID, 0.0 );	
    }	
   	/#
   		PrintLn( "**** ("+GetTime()+") remoteMissile - client **** (" + set + ")"  );
   #/
}


	
satellite_transition( localClientNum, duration )
{
	//while( 1 )
	{
		enable_filter_satellite_transition( level.localPlayers[localClientNum], SATELLITE_FILTER_ID );
		
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		starttime      = getrealtime();
		currenttime    = starttime;
		elapsedtime    = 0;
		halfTime       = duration * 0.5;
		staticTime 	   = 0.15;
		heldTime	   = 0;
		totalDuration  = duration+staticTime;
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		while( elapsedtime < totalDuration )
		{
			lastTime = currenttime;
			wait( 0.01 );
			currenttime = getrealtime();
			elapsedtime = ( currenttime - starttime - heldTime ) / 1000.0;
		
			if ( elapsedtime > totalDuration )
				elapsedTime = totalDuration;

			if ( elapsedTime < halfTime )
				val = elapsedtime/halfTime;
			else
			{
			
				if (elapsedTime < halfTime + staticTime )
				{
					val = 1;
				}
				else
				{
					val = 1 - ( elapsedtime - halfTime - staticTime ) / halfTime;
				}
				
				if (level.holdFullStatic)
				{
					val = 1;
					heldTime += currenttime - lastTime;
				}
	
			}
				
   	/#
//      PrintLn( "**** satellite - client **** (" + val + ")"  );
   #/

			set_filter_satellite_transition_amount( level.localPlayers[localClientNum], SATELLITE_FILTER_ID, val );	

		}
				
		// -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
		
		disable_filter_satellite_transition( level.localPlayers[localClientNum], SATELLITE_FILTER_ID );
	}
}


lerp_fov_overtime( time, dest )
{
	basefov 	= GetDvarfloat( "cg_fov" );
	incs 		= int( time/.01 );
	incfov 		= ( dest  -  basefov  ) / incs ;
	currentfov 	= basefov;
	
	if(incfov == 0)
	{
		return;
	}

	for ( i = 0; i < incs; i++ )
	{
		currentfov += incfov;
		SetClientDvar( "cg_fov", currentfov );
		wait .01;
	}
	//fix up the little bit of rounding error. not that it matters much .002, heh
	SetClientDvar( "cg_fov", dest );
}

rtsAudioTransitions()
{
	level.vehicle_sound_ent = undefined;
	
	level thread rtsAmbientPackage();
	level thread waitfor_rtsON();
	level thread waitfor_rtsOFF();
	level thread waitfor_povON();
	level thread waitfor_characterSwitch();
	level thread vehicleLoopSounds( "rts_intoclaw", "evt_rts_claw_1stperson_lp" );
	level thread vehicleLoopSounds( "rts_intomtl", "evt_rts_metalstorm_1stperson_lp" );
	level thread vehicleLoopSounds( "rts_intoquad", "evt_rts_quadrotor_1stperson_lp" );
}
rtsAmbientPackage()
{
	declareAmbientRoom("rts_commandcenter" );
	setAmbientRoomReverb( "rts_commandcenter", "dockside_small_room", 1, 1 );
	setAmbientRoomContext( "rts_commandcenter", "ringoff_plr", "indoor" );
	setAmbientRoomTone( "rts_commandcenter", "amb_command_center_bg", 3, 1.5 );
}
waitfor_rtsON()
{
	while(1)
	{
		level waittill( "rts_ON" );
		activateAmbientRoom( 0, "rts_commandcenter", 80 );
		playsound( 0, "evt_command_switch_static", (0,0,0) );
		snd_set_snapshot( "spl_rts_commandcenter" );
		level.rts_mode = 1;
		level thread commandServoSounds();
		update_all_hudOutlines();
	}
}
waitfor_rtsOFF()
{
	while(1)
	{
		level waittill( "rts_OFF" );
		deactivateAmbientRoom( 0, "rts_commandcenter", 80 );
		playsound( 0, "evt_command_switch_static_shrt", (0,0,0) );
		snd_set_snapshot( "default" );
		level.rts_mode = 0;
		update_all_hudOutlines();
	}
}

waitfor_povON()
{
	
	while (1)
	{
		msg = level waittill_any_return( "takeover_quadrotor_pkg", "takeover_metalstorm_pkg", "takeover_bigdog_pkg", "rts_ON", "rts_OFF", "infantry_ally_reg_pkg", "takeover_infantry_ally_reg_pkg" );
		
		switch (msg)
		{
		case "takeover_quadrotor_pkg":
			//iprintlnbold("quadrotor_pkg");
			setglobalfutz("spl_quad_pov", 0.5);
			setsoundcontext ("grass", "in_grass");
			break;
		case "takeover_metalstorm_pkg":
			//iprintlnbold("metalstorm_pkg");
			setglobalfutz("spl_asd_pov", 0.7);
			setsoundcontext ("grass", "in_grass");
			break;
		case "takeover_bigdog_pkg":
			//iprintlnbold("bigdog_pkg");
			setglobalfutz("spl_bigdog_pov", 0.5);
			setsoundcontext ("grass", "in_grass");
			break;
		case "rts_ON":
			//iprintlnbold("rts_ON");
			setglobalfutz("spl_war_command", 1.0);
			setsoundcontext ("grass", "no_grass");
			break;
		default:
			//iprintlnbold("default");
			setglobalfutz("spl_war_command", 0.0);			
			setsoundcontext ("grass", "no_grass");
			break;
		}
	}
}
waitfor_povOFF()
{
	
	while (1)
	{
		msg = level waittill_any_return( "restore_quadrotor_pkg", "restore_metalstorm_pkg", "restore_bigdog_pkg", "chr_swtch_start",  "rts_OFF" );
		
		switch (msg)
		{
		case "restore_quadrotor_pkg":
			//iprintlnbold("quadrotor_pkg restore");
			break;
			setglobalfutz("spl_quad_pov", 0.0);
			setsoundcontext ("grass", "no_grass");
		case "restore_metalstorm_pkg":
			//iprintlnbold("metalstorm_pkg restore");
			setglobalfutz("spl_asd_pov", 0.0);
			setsoundcontext ("grass", "no_grass");			
			break;
		case "restore_bigdog_pkg":
			//iprintlnbold("bigdog_pkg restore");
			setglobalfutz("spl_bigdog_pov", 0.0);
			setsoundcontext ("grass", "no_grass");			
			break;
		case "rts_OFF":
			//iprintlnbold("rts_OFF");
			setglobalfutz("default", 0.0);
			setsoundcontext ("grass", "no_grass");			
			break;
		default:
			//iprintlnbold("default restore");
			setglobalfutz("default", 0.0);
			setsoundcontext ("grass", "no_grass");
			break;
		}
	}
}
waitfor_characterSwitch()
{
	while(1)
	{
		level waittill( "chr_swtch_start" );
		snd_set_snapshot( "spl_rts_character_switch" );
		playsound( 0, "evt_command_switch_static", (0,0,0) );
		level waittill( "chr_swtch_end" );
		snd_set_snapshot( "default" );
	}
}

commandServoSounds()
{
    player = getlocalplayers()[0];
    pan_volume = 0;
    move_volume = 0;
    
    panSoundEnt = spawn( 0, (0,0,0), "script_origin" );
    moveSoundEnt = spawn( 0, (0,0,0), "script_origin" );
    panLooper = panSoundEnt PlayLoopSound( "evt_rts_cmd_pan_lp" , .1 );
    moveLooper = moveSoundEnt PlayLoopSound( "evt_rts_cmd_move_lp" , .1 );
    
    while( level.rts_mode == 1 )
    {
        pan = player GetNormalizedCameraMovement();
        move = player GetNormalizedMovement();
    
        pan = abs(pan[0]);
        move = abs(move[0]);
        
        //iprintlnbold( "PAN: " + pan + "    MOVE: " + move );
        
        if( pan > 0 )
        	pan_volume = 1;
        else
        	pan_volume = 0;
        
        if( move > 0 )
        	move_volume = 1;
        else
        	move_volume = 0;

        setSoundVolume( panLooper, pan_volume );
        setSoundVolume( moveLooper, move_volume );
        
        wait (.05);
    }
    
    panSoundEnt delete();
    moveSoundEnt delete();
}
//C.Ayers - Activates whenever entering a vehicle
//Put any snapshots, etc here
vehicleLoopSounds( string, alias )
{
	if( !isdefined( level.vehicle_sound_ent ) )
	{
		level.vehicle_sound_ent = spawn( 0, (0,0,0), "script_origin" );
	}
	
	while(1)
	{
		level waittill( string );
		level.vehicle_sound_ent playloopsound( alias, 1 );
		level waittill_any( "chr_swtch_start", "rts_ON" );
		level.vehicle_sound_ent stoploopsound( 1 );
	}
}
//Temporarily disabling standard health system, as it mucks about with how the RTS gamemode sounds
rtsHealthSystem( clientNum )
{
}

toggle_third_person_cam( localClientNum, set, newEnt )
{    
	SetThirdPerson( set );
}