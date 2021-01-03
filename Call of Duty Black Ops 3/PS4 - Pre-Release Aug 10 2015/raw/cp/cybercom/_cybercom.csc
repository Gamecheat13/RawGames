    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\math_shared;

#using scripts\cp\cybercom\_cybercom_gadget_firefly;
#using scripts\cp\cybercom\_cybercom_gadget_security_breach;
#using scripts\cp\cybercom\_cybercom_gadget_misdirection;


	
// CyberCombat arm pulse tuning
	// in ms
	// How much time until the arm is in ready position for the pulse
	// How long to pulse down the arm until we hit the back of the hand
	// How long to keep the back of the hand glowing









#namespace cybercom;

#precache( "client_string", "CGAME_ASSET" );
#precache( "client_fx", "electric/fx_ability_elec_sensory_ol_human");

function autoexec __init__sytem__() {     system::register("cybercom",&__init__,undefined,undefined);    }

function __init__()
{
	level.cybercom_status = 0;
	init_clientfields();
	callback::on_spawned( &on_player_spawned );
	
	cybercom_firefly::init();
	cybercom_security_breach::init();
	cybercom_misdirection::init();
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "world", "cybercom_disabled", 1, 1, "int", &cybercomDisabledAll, !true, !true );
	clientfield::register( "toplayer", "cybercom_disabled", 1, 1, "int", &cybercomDisabled, !true, !true );
	clientfield::register( "vehicle", "cybercom_setiffname", 1, 3, "int", &setIffName, !true, !true );
	clientfield::register( "actor", "cybercom_setiffname", 1, 3, "int", &setIffName, !true, !true );

	
	clientfield::register( "toplayer", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );
	clientfield::register( "actor", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );
	clientfield::register( "scriptmover", "cyber_arm_pulse", 1, 2, "counter", &cyber_arm_pulse, !true, !true );


	clientfield::register( "actor", "sensory_overload", 1, 1, "int", &cybercom_sensoryoverload, !true, !true );
	clientfield::register( "actor", "forced_malfunction", 1, 1, "int", &cybercom_forcedmalfunction, !true, !true );
	clientfield::register( "toplayer", "hacking_progress", 1, 12, "int", &cybercom_hacking, !true, !true );
	
	clientfield::register( "toplayer", "resetAbilityWheel", 1, 1, "int", &cybercom_resetPositions, !true, !true );
	clientfield::register( "scriptmover", "makedecoy", 1, 1, "int", &cyber_misdirectionDecoy, !true, !true );

	
	level._effect["sensory_disable_human"]				= "electric/fx_ability_elec_sensory_ol_human";
	level._effect["forced_malfunction"]					= "electric/fx_ability_elec_sensory_ol_human";
	
//	clientfield::register( "toplayer", "repulsorArmorRecharging", VERSION_SHIP, 1, "int", &repulsorArmorRecharging, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

//---------------------------------------------------------
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
		self setintacticalhud( true );
		audio::playloopat("gdt_tac_menu_snapshot_loop", (0,0,0) );
	}
}

function freeTacMenuHandle( localClientNum, menu )
{
	audio::stoploopat("gdt_tac_menu_snapshot_loop", (0,0,0) );
	wait( 0.75 );
	CloseLUIMenu( localClientNum, menu );
	self.tacticalMenu = undefined;
	self setintacticalhud( false );
}

function closeTacMenu( localClientNum )
{
	if( isDefined( self.tacticalMenu ) )
	{
		SetLUIMenuData( localClientNum, self.tacticalMenu, "close_current_menu", 1 );
		self thread freeTacMenuHandle( localClientNum, self.tacticalMenu );
	}
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
		if (level.cybercom_status == 0 && !( isdefined( self.cyberComDisabled ) && self.cyberComDisabled ) )
		{
			self openTacMenu( localClientNum );
		}
	}
}

function watchMenuToggle( localClientNum )
{
	self notify ( "watchMenuToggle" );
	self endon ( "watchMenuToggle" );
	
	for( ;; )
	{
		self waittill( "tactical_menu_toggle" );
		
		if( isDefined( self.tacticalMenu ) )
		{
			self closeTacMenu( localClientNum );
		}
		else
		{
			if (level.cybercom_status == 0  && !( isdefined( self.cyberComDisabled ) && self.cyberComDisabled ) )
			{
				self openTacMenu( localClientNum );
			}
		}		
	}
}

function watchMenu( localClientNum )
{
	if( self isLocalPlayer() )
	{
		self thread watchMenuOpen( localClientNum );
		self thread watchMenuClose( localClientNum );
		self thread watchMenuToggle( localClientNum );
	}
}

function cybercomDisabled(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal== 1)
	{
		self notify("tactical_menu_close");
		self.cyberComDisabled = true;
	}
	else
	{
		self.cyberComDisabled = undefined;
	}
}

function cybercomDisabledAll(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level.cybercom_status = newVal;
	players = GetLocalPlayers();
	if(level.cybercom_status == 1)
	{
		foreach(player in players)
		{
			player notify("tactical_menu_close");
			player.cyberComDisabled = true;
		}
	}
	else
	{
		foreach(player in players)
		{
			player notify("tactical_menu_close");
			player.cyberComDisabled = undefined;
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setIffName(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	//This should probably be moved into proper UI support.  Rather than using setdrawname, would be better if there was some
	//UI supported animated symbology or something..
	switch (newVal)
	{
		case 0:									//IFF no longer active; name/symbol should be not seen	
			self setdrawname();
			self.iffname = undefined;
			self notify("iffName_shutdown");
			break;
		case 1:							//IFF has started, name/symbol represents in progress notification
			text = MakeLocalizedString("WEAPON_LINK_INPROGRESS");
			self.iffname = text;
			self setdrawname(self.iffname ,1);
			break;
		case 2:									//IFF is on; name/symbol represents player control over robot/vehicle;  Right now, using a pseudo EUI64; 
			self.iffname = getEUI();
			self setdrawname(self.iffname ,1);
			self _iffName_TurnOffForce();
			break;
		case 3:								//IFF is on, but expiring; name/symbol indicates IFF expiration
			text = MakeLocalizedString("WEAPON_LINK_FAILURE");
			self.iffname = text;
			self setdrawname(self.iffname ,1);
			//self thread _iffName_Blink();
			break;
		case 4:								//IFF is turning off now; name/symbol indicates IFF shutting down
			text = MakeLocalizedString("WEAPON_LINK_TERMINATED");
			self.iffname = text;
			self setdrawname(self.iffname ,1);
			break;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iffName_Blink()
{
	self endon("entityshutdown");
	self notify("iffName_shutdown");
	self endon("iffName_shutdown");
	           
	while(1)
	{
		wait 2;
		self setdrawname(self.iffname ,2);
		wait 2;
		self setdrawname(self.iffname ,1);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _iffName_TurnOffForce()
{
	self endon("entityshutdown");
	self notify("iffName_shutdown");
	self endon("iffName_shutdown");
	while(1)
	{
		self waittill("damage",amount);
		if (isDefined(amount) && amount > self.heath)
			break;
	}
	self setdrawname();//force off
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_random_byte()
{
	alpha 	= array("A","B","C","D","E","F");
	digit 	= array("0","1","2","3","4","5","6","7","8","9");
	nib1 	= ((RandomInt(100)<50)?alpha[RandomInt(alpha.size)]:digit[RandomInt(digit.size)]);
	nib2 	= ((RandomInt(100)<50)?alpha[RandomInt(alpha.size)]:digit[RandomInt(digit.size)]);
	return(nib1+nib2);
}
function private getEUI()		// pseudo EUI-64
{
	name  	= "";
	if(isSubStr(self.model,"_54i_"))
		oui = "3534:49FF:FE";
	else
	if(isSubStr(self.model,"_nrc_"))
		oui = "4E52:43FF:FE";
	else
		oui = "4349:41FF:FE";
	
	byte1  	= _get_random_byte();
	byte2  	= _get_random_byte();
	byte3  	= _get_random_byte();
	name	= oui + byte1 +":"+byte2+byte3;
	return name;
}
/*
CIA = 43 – 49 - 41
NRC= 4E – 52 – 43
54I = 35 – 34 – 49
ZURICH = ZUR = 5A – 55 – 52 
*/


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
		
			self notify( "cybercom_start_arm_pulse" );
			self thread play_arm_pulse_ability_activation();
			
			break;
			
			
		// For player initiated hacks.
		case 1:
				
				// TEMP TUNINGS UNTIL PULSE EFFECT IS READY
				// ========================================
				
				n_pulse_speed = 3.023;
				n_effect_duration = 3.05;
				n_number_of_pulses = 4;
				// ========================================
				
				self notify( "cybercom_start_arm_pulse" );
				self SetArmPulse( n_effect_duration, n_pulse_speed, n_number_of_pulses );
			break;
			
		// When reviving a downed ally.
		case 2:
				
				// TEMP TUNINGS UNTIL PULSE EFFECT IS READY
				// ========================================
				
				n_pulse_speed = 3.023;
				n_effect_duration = 3.05;
				n_number_of_pulses = 5;
				
				/*n_number_of_pulses = GetDvarInt( "cybercom_tuning_num_pulses", 1 );
				n_effect_duration = GetDvarFloat( "cybercom_tuning_pulse_dur", 1.10 );
				n_pulse_speed = GetDvarFloat( "cybercom_tuning_pulse_speed", 2.5 );*/
				// ========================================
				
				self notify( "cybercom_start_arm_pulse" );
				self SetArmPulse( n_effect_duration, n_pulse_speed, n_number_of_pulses );
			break;
	}
	
	
}


// Move the arm pulse shader through its different states for activation of a CyberCombat ability.
// Provides explicit control for:
// - When to start moving down the arm
// - How long to take moving down the arm
// - How long to glow the back of the hand.
function play_arm_pulse_ability_activation()
{
	// Turn off conditions
	self endon( "entityshutdown" );
	self endon( "disconnect" );
	self endon( "cybercom_start_arm_pulse" );

	
	pulse_state = 0;
	current_pulse_pos = 0.0;
	pulse_move = 1.0;
	time_counter = 0.0;				// Have to keep track of our own time since get_time might not work with the timescale.
	
	keyframe_arm_ready = GetDvarInt( "cybercom_arm_ready", 50 );
	keyframe_move_up_arm = GetDvarInt( "cybercom_move_down_arm", 110 );
	keyframe_hold_on_hand = GetDvarInt( "cybercom_hold_on_arm", 290 );
	hand_glow_shader_pct = GetDvarFloat( "cybercom_hand_glow_shader_pct", 0.46 );
	hand_glow_start_pos = GetDvarFloat( "cybercom_hand_glow_start", 0.07 );
	total_pulse_time = 690;
	
	current_pulse_pos = hand_glow_start_pos;
	
	total_time = total_pulse_time;
	
	while( time_counter < total_time )
	{
		current_time = time_counter;
		
		switch (pulse_state)
		{
			
			// "Start Up" state
			// Get the pulse to its starting spot for when the arm is on screen.
			case 0:
				if ( current_time > keyframe_arm_ready )
				{
					pulse_state = 1;
				}
				else
				{
					// Move the pulse to its start point on the arm
					pulse_move = (0.2 - hand_glow_start_pos) / (keyframe_arm_ready * (0.01 * 10));
					current_pulse_pos += pulse_move;
					self SetArmPulsePosition(current_pulse_pos);
				}
					
				
				break;
				
				
			// Move down arm
			case 1:
				if ( current_time > keyframe_move_up_arm)
				{
					pulse_state = 2;
				}
				else
				{
					// Linear increase when moving down the arm
					pulse_move = (hand_glow_shader_pct - 0.2) / ((keyframe_move_up_arm - keyframe_arm_ready) * (0.01 * 10));
					current_pulse_pos += pulse_move;
					self SetArmPulsePosition(current_pulse_pos);
				}
					
				
				break;
				
			// Hold on back of hand glow	
			case 2:
				if ( current_time > keyframe_hold_on_hand)
				{
					pulse_move = (1 - hand_glow_shader_pct) / ((total_time - current_time) * (0.01 * 10));
					pulse_state = 3;
				}
				
				break;
			
			// Finish pulse
			case 3:
				current_pulse_pos += pulse_move;
				self SetArmPulsePosition(current_pulse_pos);
				
				break;
		}
		
		// Think tick
		wait (0.01);
		time_counter += (0.01 * 1000);
	}
}

function cybercom_forcedmalfunction( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal == 0 && isDefined(self.forcedMalfunctionFX))
		DeleteFx(localClientNum,self.forcedMalfunctionFX);
	
	if(newVal == 1)
	{
		if(isDefined(self.forcedMalfunctionFX))
			DeleteFx(localClientNum,self.forcedMalfunctionFX);
		
		tagOrigin = self GetTagOrigin("tag_brass");
		if(isDefined(tagOrigin))
		{
			self.forcedMalfunctionFX = playfxontag(localClientNum,level._effect["forced_malfunction"],self,"tag_brass" );
		}
	}
}
function cybercom_sensoryoverload( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal == 0 && isDefined(self.sensory_overloadFX))
		DeleteFx(localClientNum,self.sensory_overloadFX);
	
	if(newVal == 1)
	{
		if(isDefined(self.sensory_overloadFX))
			DeleteFx(localClientNum,self.sensory_overloadFX);
		self.sensory_overloadFX = playfxontag(localClientNum,level._effect["sensory_disable_human"],self,"j_neck" );
	}
}


function cyber_misdirectionDecoy( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		//self turn on UI marker	
	}
	else
	{
		//self turn off UI marker	
	}
}

/*
function cybercom_hacking( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	controllerModel = GetUIModelForController( localClientNum );
	if ( isdefined( controllerModel ) )
	{
		progressModel = GetUIModel( controllerModel, "WorldSpaceIndicators.hackingPercent" );
		if ( isdefined( progressModel ) )
		{
			SetUIModelValue( progressModel, newVal / 100.0 );
		}
	}
}
*/

function ui_animation_update( model, range, start )
{
	self notify("ui_animation_update");
	self endon ("ui_animation_update");
	self endon ("ui_animation_kill");
	startTime 	= GetRealTime();
	val 		= start/range;
	
	while( val <= 1.0 )
	{
		SetUIModelValue( model, val );
		totalTime = ( ( GetRealTime() - startTime ) / 1000.0 ) + start;
		val =  math::clamp(totalTime/range, 0, 1);
		{wait(.016);};
	}
	SetUIModelValue( model, 0 );
}

function cybercom_hacking( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	model = GetUIModel( GetUIModelForController( localClientNum ), "WorldSpaceIndicators.hackingPercent" );
	if( !isdefined( model ) )
		return;

	SetUIModelValue( model, 0 );
	if(newVal>0)
	{
		range = newVal & 0x1f;	//lower 5bits spec range
		start = ((newVal>>5)/128)*range;//upper 7 bits define offset into range
		self thread ui_animation_update( model, range,start );
	}
	else
	{
		self notify ("ui_animation_kill");
	}
}



function initializeCybercomUIModels( controllerModel )
{	
	CreateUIModel( controllerModel, "AbilityWheel.Selected1" );
	CreateUIModel( controllerModel, "AbilityWheel.Selected2" );
	CreateUIModel( controllerModel, "AbilityWheel.Selected3" );
}

function cybercom_resetPositions(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal == 1 )
	{
		controllerModel = GetUIModelForController( localClientNum );
		selected1 = GetUIModel( controllerModel, "AbilityWheel.Selected1" );
		
		if( !IsDefined( selected1 ) )
		{
			initializeCybercomUIModels( controllerModel );
			selected1 = GetUIModel( controllerModel, "AbilityWheel.Selected1" );
		}
		
		selected2 = GetUIModel( controllerModel, "AbilityWheel.Selected2" );
		selected3 = GetUIModel( controllerModel, "AbilityWheel.Selected3" );
		
		SetUIModelValue( selected1, 1 );
		SetUIModelValue( selected2, 1 );
		SetUIModelValue( selected3, 1 );
	}
}

