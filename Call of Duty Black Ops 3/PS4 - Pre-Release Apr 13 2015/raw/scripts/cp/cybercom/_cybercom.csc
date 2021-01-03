    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\audio_shared;

#using scripts\cp\cybercom\_cybercom_gadget_firefly;
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;



#namespace cybercom;

#precache( "client_string", "CGAME_ASSET" );

function autoexec __init__sytem__() {     system::register("cybercom",&__init__,undefined,undefined);    }

function __init__()
{
	level.cybercom_status = 0;
	init_clientfields();
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	cybercom_firefly::init();
	cybercom_security_breach::init();
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "world", "cybercom_disabled", 1, 1, "int", &cybercomDisabledAll, !true, !true );
	clientfield::register( "toplayer", "cybercom_disabled", 1, 1, "int", &cybercomDisabled, !true, !true );
	clientfield::register( "toplayer", "emergencyReserve", 1, 1, "int", &emergencyReserve, !true, !true );
	clientfield::register( "vehicle", "cybercom_setiffname", 1, 3, "int", &setIffName, !true, !true );

	
	clientfield::register( "toplayer", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );
	clientfield::register( "actor", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );
	clientfield::register( "scriptmover", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );


	
//	clientfield::register( "toplayer", "repulsorArmorRecharging", VERSION_SHIP, 1, "int", &repulsorArmorRecharging, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

//---------------------------------------------------------
function on_player_connect(localClientNum)
{	
	self initCybercom(localClientNum);
}
function on_player_spawned(localClientNum)
{	
	self initCybercom(localClientNum);
	self thread watchMenu( localClientNum );
}

function openTacMenu( localClientNum )
{
	if( !isDefined( self.tacticalMenu ) )
	{
		self.tacticalMenu = CreateLUIMenu( localClientNum, self.cybercom.menu );
		OpenLUIMenu( localClientNum, self.tacticalMenu );
	}
	self setintacticalhud( true );
	audio::playloopat("gdt_tac_menu_snapshot_loop", (0,0,0) );
}

function freeTacMenuHandle( localClientNum, menu )
{
	wait( 0.75 );
	CloseLUIMenu( localClientNum, menu );
}

function closeTacMenu( localClientNum )
{
	if( isDefined( self.tacticalMenu ) )
	{
		SetLUIMenuData( localClientNum, self.tacticalMenu, "close_current_menu", 1 );
		self thread freeTacMenuHandle( localClientNum, self.tacticalMenu );
		self.tacticalMenu = undefined;
	}
	self setintacticalhud( false );
	audio::stoploopat("gdt_tac_menu_snapshot_loop", (0,0,0) );
}

function watchMenuClose( localClientNum )
{
	self notify ( "watchMenuCloseStart" );
	self endon ( "watchMenuCloseStart" );
	
	for( ;; )
	{
		self waittill( "tactical_menu_close" );
		self closeTacMenu( localClientNum );
	}
}

function watchMenuOpen( localClientNum )
{
	self notify ( "watchMenuOpenStart" );
	self endon ( "watchMenuOpenStart" );
	
	for( ;; )
	{
		self waittill( "tactical_menu_open" );
		if (level.cybercom_status == 0)
		{
			self openTacMenu( localClientNum );
		}
	}
}

function watchMenu( localClientNum )
{
	if( self isLocalPlayer() )
	{
		self thread watchMenuOpen( localClientNum );
		self thread watchMenuClose( localClientNum );
	}
}

function cybercomDisabled(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal== 1)
	{
		self notify("tactical_menu_close");
	}
}

function cybercomDisabledAll(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.cybercom_status = newVal;
	if(level.cybercom_status == 1)
	{
		players = GetLocalPlayers();
		foreach(player in players)
		{
			player notify("tactical_menu_close");
		}
	}
}

function emergencyReserve(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{ 
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );
	
	if(( isdefined( player.emergencyReserve ) && player.emergencyReserve ) && !newVal )
	{
		player.emergencyReserve = undefined;
		VisionSetNaked( localClientNum, GetDvarString( "mapname" ), 0.0 );
	}
	else
	if(!( isdefined( player.emergencyReserve ) && player.emergencyReserve ) && newVal )
	{
		player.emergencyReserve = 1;
		VisionSetNaked(localClientNum, "cheat_bw", 0.5 );	
	}
}

function repulsorArmorRecharging(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{ 
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );
	
	
	if(( isdefined( player.repulsorRecharging ) && player.repulsorRecharging ) && !newVal )
	{
		player.repulsorRecharging = undefined;
		VisionSetNaked( localClientNum, GetDvarString( "mapname" ), 0.0 );
	}
	else
	if(!( isdefined( player.repulsorRecharging ) && player.repulsorRecharging ) && newVal )
	{
		player.repulsorRecharging = 1;
		VisionSetNaked(localClientNum, "cheat_bw", 0.5 );	
	}
	
}


function castingAnimationWatcher(localClientNum)
{
	self notify("castingAnimationWatcher");
	self endon("castingAnimationWatcher");
	self endon("disconnect");
	self endon("entityshutdown");
	self.cybercom.lastCastAt = 0;
	while(1)
	{
		self waittill("gadget_casting_anim");
		curtime = Gettime();
		if(self.cybercom.lastCastAt + 1000 < curtime)//guard against multiple notifies dispatched by gadget system.
		{
			cyber_arm_pulse(localclientnum, 0, 0);
			self.cybercom.lastCastAt = curtime;
		}
	}
}

function initCybercom(localClientNum)
{
	if(!isDefined(self.cybercom))
	{
		self.cybercom = spawnstruct();
		self.cybercom.menu  = "AbilityWheel"; //one menu that dynamically checks type bits probably best way imo
		self.tacticalMenu = undefined;
	}
	self thread castingAnimationWatcher(localClientNum);
}


function setIffName(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal == 0 )
	{
		self setdrawname();
	}
	else
	{
		assert(newVal>=1 && newVal <=4);
		players = GetPlayers();
		newVal -=1;
		text = MakeLocalizedString("CGAME_ASSET");
		text = text	+ " : "+ players[newVal].name;
		self setdrawname(text);
	}
}


// Play the arm pulse effect client side.
function cyber_arm_pulse( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_effect_duration = 1.0;
	n_pulse_speed = 1.0;
	n_number_of_pulses = 1;
	
	// Determine the type of DNI arm pulse we want to display.
	switch (newVal)
	{
		// For activating a CyberCombat Ability.
		case 0:
		
			// Use the DVAR tunings for CyberCombat Ability activation
			n_effect_duration = GetDvarFloat( "cybercom_tuning_pulse_dur", 1.10 );
			n_pulse_speed = GetDvarFloat( "cybercom_tuning_pulse_speed", 0.97 );
			break;
			
			
		// For player initiated hacks.
		case 1:
				
				// TEMP TUNINGS UNTIL PULSE EFFECT IS READY
				// ========================================
				n_effect_duration = 1.0;
				n_pulse_speed = 0.4;
				n_number_of_pulses = 7;
				// ========================================
			break;
			
		// When reviving a downed ally.
		case 2:
				
				// TEMP TUNINGS UNTIL PULSE EFFECT IS READY
				// ========================================
				n_effect_duration = 1.0;
				n_pulse_speed = 0.6;
				n_number_of_pulses = 5;
				// ========================================
			break;
	}
	
	self SetArmPulse( n_effect_duration, n_pulse_speed, n_number_of_pulses );
}
