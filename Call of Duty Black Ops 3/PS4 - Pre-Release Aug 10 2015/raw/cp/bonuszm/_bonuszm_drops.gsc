#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ammo_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientids_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\_load;
#using scripts\cp\_oed;
#using scripts\cp\_util;

// BONUZM
#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\bonuszm\_bonuszm_util;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm_magicbox;
#using scripts\cp\bonuszm\_bonuszm_weapons;

// SGEN SPECIFIC
#using scripts\cp\bonuszm\_bonuszm_sgen;
#using scripts\cp\bonuszm\_bonuszm_biodomes1;
#using scripts\cp\bonuszm\_bonuszm_prologue;

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#namespace bonuszmdrops;

function autoexec main()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	level.BZMOnCyberComOnCallback = &BZMOnCyberComOnCallback;
	
	BZM_SetupCyberComAbilities();
	
	// Track number of drops
	level.bzmActiveDrops = 0;	
}

function init()
{
	
}

// ----------------------
// Drop thread per AI when he dies
//-----------------------
function BZM_ZombieDropItemsOnDeath()
{
	if( level.bzmActiveDrops >= 8 )
		return;
	
	if( ( isdefined( self._bzmKilledByFailSafe ) && self._bzmKilledByFailSafe ) )
		return;
	
	isDroppingPowerUpEnabled 	= level.bonusZMSkiptoData["powerupdropsenabled"];
	droppingChance				= level.bonusZMSkiptoData["powerdropchance"];
	
/#
	if( GetDvarString("bzm_forceDrop") != "" )
	{
		isDroppingPowerUpEnabled = true;
		droppingChance = 100;
	}
#/		
	if( !isDroppingPowerUpEnabled )
		return;
	
	forceDrop = false;
	
	if( ( isdefined( self.BZMMiniBoss ) && self.BZMMiniBoss ) )
		forceDrop = true;
	
	// Roll the dice first to decide we should drop or not
	rollDice = RandomInt( 100 );	
	if( rollDice > droppingChance && !forceDrop )
		return;

	randomChance = RandomInt( droppingChance );
	
	selectedDrop = undefined;
	possibleDrops = [];
	
	// Instakill force drop when miniboss zombie gets killed
	if( ( isdefined( forceDrop ) && forceDrop ) )
	{
		possibleDrops[possibleDrops.size] = "instakill";
	}
	else
	{
		// Weapon Drop
		if( randomChance < level.bonusZMSkiptoData["weapondropchance"] )
		{
			possibleDrops[possibleDrops.size] = "random_weapon";		
		}
					
		// Cybercom
		if( randomChance < level.bonusZMSkiptoData["cybercoredropchance"] )
		{
			possibleDrops[possibleDrops.size] = "cybercom";		
		}
		
					
		// Cybercom upgraded
		if( randomChance < level.bonusZMSkiptoData["cybercoreupgradeddropchance"] )
		{
			possibleDrops[possibleDrops.size] = "cybercom_upgraded";		
		}
		
		// Instakill
		if( randomChance < level.bonusZMSkiptoData["instakilldropchance"] && !BZM_IsInstaKillActive() )
		{
			possibleDrops[possibleDrops.size] = "instakill";		
		}
		
		// Maxammo
		if( randomChance < level.bonusZMSkiptoData["maxdropammochance"] )
		{
			possibleDrops[possibleDrops.size] = "max_ammo";		
		}
		
		// Instakill upgraded
		if( randomChance < level.bonusZMSkiptoData["instakillupgradeddropchance"] && !BZM_IsUpGradedInstaKillActive() )
		{
			possibleDrops[possibleDrops.size] = "instakill_upgraded";		
		}
		
		// raps
		if( randomChance < level.bonusZMSkiptoData["rapsdropchance"] && !( isdefined( level.BZMRapsActive ) && level.BZMRapsActive ) )
		{
			possibleDrops[possibleDrops.size] = "raps";		
		}
	}
	
	if( possibleDrops.size )
	{
		selectedDrop = possibleDrops[RandomInt( possibleDrops.size )];
	}

/#
	if( GetDvarString("bzm_forceDrop") != "" )
	{
		selectedDrop = GetDvarString("bzm_forceDrop");
	}
#/	
	
	if( !IsDefined( selectedDrop ) )
		return;
		
	players = GetPlayers();
	closestPlayer = ArrayGetClosest( self.origin, players, 100 );
	origin = self.origin;
	
	if( IsDefined( closestPlayer ) )
	{
		// This means there is a player nearby
		direction = VectorNormalize( self.origin - closestPlayer.origin );
		origin = self.origin + VectorScale( direction, 150 );
	}
		
	switch( selectedDrop )
	{
		case "random_weapon":
		{				
			weaponInfo = bonuszmdrops::BZM_GetRandomWeaponFromTable( false );
							
			if( !IsDefined( weaponInfo ) )
				return;
			
			if( weaponInfo[0] == level.weaponNone )
				return;
			
			str_identifier = "random_weapon";
			str_bonus = "random_weapon";
			
			str_model = weaponInfo[0].worldModel;
						
			dropped_model = self bzmdrop_drop_model( str_model, origin, ( 0, 0, 30 ), weaponInfo, false );	
			break;
		}		
			
		case "cybercom":
		{				
			str_identifier = "cybercom";
			str_bonus = "cybercom";
			dropped_model = self bzmdrop_drop_model( "p7_zm_power_up_cyber_core", origin, ( 0, 0, 30 ), undefined, false );
			break;
		}
			
		case "cybercom_upgraded":
		{				
			str_identifier = "cybercom_upgraded";
			str_bonus = "cybercom_upgraded";
			dropped_model = self bzmdrop_drop_model( "p7_zm_power_up_cyber_core", origin, ( 0, 0, 30 ), undefined, true );
			break;
		}
			
		case "max_ammo":
		{
			str_identifier = "max_ammo";
			str_bonus = "ammo";
			dropped_model = self bzmdrop_drop_model( "p7_zm_power_up_max_ammo", origin, ( 0, 0, 30 ), undefined, false );				
			break;			
		}
			
		case "instakill":
		{
			str_identifier = "instakill";
			str_bonus = "instakill";
			dropped_model = self bzmdrop_drop_model( "p7_zm_power_up_insta_kill", origin, ( 0, 0, 30 ), undefined, false );				
			break;			
		}
			
		case "instakill_upgraded":
		{
			str_identifier = "instakill_upgraded";
			str_bonus = "instakill_upgraded";
			dropped_model = self bzmdrop_drop_model( "p7_zm_power_up_insta_kill", origin, ( 0, 0, 30 ), undefined, true );
			break;			
		}
		
		case "raps":
			str_identifier = "raps";
			str_bonus = "raps";
			dropped_model = self bzmdrop_drop_model( "veh_t7_drone_raps", origin, ( 0, 0, 30 ), undefined, false );
			break;
			
		default:
			AssertMsg("Bonuszm - Invalid powerup!");
	}
			
	level.bzmActiveDrops++;	
	self thread checkbzmdrop_drop_pickup( dropped_model, str_identifier, str_bonus );	
}

// ----------------------
// Dropped model
//-----------------------
function bzmdrop_drop_model( str_model, v_model_origin, v_offset = ( 0, 0, 0 ), weaponInfo, upgraded )  // self = player
{
	if ( !IsDefined( self.perkbzmdrop_models ) )
	{
		self.perkbzmdrop_models = [];
	}
		
	if( !MaySpawnEntity() )
	{
		/# IPrintLn( "BZM:Too many entities, could not spawn drop" ); #/
		return;
	}
	
	dropped_model = Spawn( "script_model", (0,0,0) );
	dropped_model SetModel( "tag_origin" );	
	dropped_model NotSolid();
	
	if( ( isdefined( upgraded ) && upgraded ) )
		dropped_model SetScale( 0.7 );
	else
		dropped_model SetScale( 0.6 );
	
	if( str_model == "veh_t7_drone_raps" )
	{
		dropped_model SetScale( 0.4 );
	}
	
	dropped_model.weaponInfo = weaponInfo;
	dropped_model.upgraded = upgraded;
	
	dropped_model thread delay_showingbzmdrop_ent( v_model_origin + v_offset, str_model, upgraded );
	dropped_model thread bzmdrop_drop_model_thread();
		
	return dropped_model;
}

// network optimization: space out zombie death event network traffic
function delay_showingbzmdrop_ent( v_moveto_pos, str_model, upgraded )
{
	self.drop_time = GetTime();
	
	util::wait_network_frame();  
	util::wait_network_frame();
	
	self.origin = v_moveto_pos;
	
	util::wait_network_frame();
	
	if ( IsDefined( str_model ) )
	{
		self SetModel( str_model );
		if( IsDefined( self.weaponInfo ) )
		{
			self SetWeaponRenderOptions( self.weaponInfo[2], 0, 0, 0, 0 );
		}
		
		if( ( isdefined( upgraded ) && upgraded ) )
			self clientfield::set("powerup_on_fx", 2);	
		else
			self clientfield::set("powerup_on_fx", 1);
		
		self oed::enable_keyline();
 	}
	
	self Show();
}

function bzmdrop_model_blink_animate()
{
	self thread bzmdrop_model_blink_timeout();
	self thread bzmdrop_model_rotate();
}

function bzmdrop_model_rotate()
{
	self endon("death");
	upgraded = ( isdefined( self.upgraded ) && self.upgraded );
	
	if( upgraded )
		rotateTime	= 0.3;
	else
		rotateTime	= 0.7;
	
	while(1)
	{
		self RotateYaw( -180, rotateTime );			
			
		wait rotateTime;
	}
}

// model is solid for half its life, then blinks slowly, medium, fast, and deletes
function bzmdrop_model_blink_timeout()
{
	self endon( "death" );
	self endon( "stopbzmdrop_behavior" );
	
	// three blinks: slow, medium, fast
	n_time_total = 18	;
	n_frames = ( n_time_total * 20 );
	n_section = Int( n_frames / 6 );
	
	// cutoff times
	n_flash_slow = n_section * 3;
	n_flash_medium = n_section * 4;
	n_flash_fast = n_section * 5;
	
	b_show = true;
	i = 0;
	
	while ( i < n_frames )
	{
		if ( i < n_flash_slow )
		{
			// solid full time
			n_multiplier = n_flash_slow;  // solid for first half of life
		}
		else if ( i < n_flash_medium )
		{
			// flash slowly
			n_multiplier = 10;  // 0.5 seconds
		}
		else if ( i < n_flash_fast )
		{
			// flash medium
			n_multiplier = 5;  // 0.25 seconds
		}
		else 
		{
			// flash quickly
			n_multiplier = 2;  // 0.1 seconds
		}
		
		if ( b_show )
		{
			self Show();
		}
		else 
		{
			self Ghost();
		}
		
		b_show = !b_show; // toggle
		i += n_multiplier;  // increment count
		wait 0.05 * n_multiplier;
	}
	
	self notify( "stopbzmdrop_behavior" );
}

function IsPlayerFacingTheDrop( facee ) // within 110
{
	requiredDot = 0.5;
	orientation = self GetPlayerAngles();
	forwardVec = anglesToForward( orientation );
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );
	toFaceeVec = facee.origin - self.origin;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > requiredDot ); 
}

function checkbzmdrop_drop_pickup( dropped_model, str_identifier, str_bonus )
{
	if ( !IsDefined( dropped_model ) )
	{
		return;  // bzmdrop_drop_model couldn't find model, so don't run logic 
	}	
	
	dropped_model endon( "death" );
	dropped_model endon( "stopbzmdrop_behavior" );
	
	util::wait_network_frame();  // make sure all threads have a chance to get ready
	
	n_times_to_check = Int( 18 / 0.1 );
	
	for ( i = 0; i < n_times_to_check; i++ )
	{
		//Run on each player and spawned hero
		//If player gets close to Zombie then GO
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			b_player_inside_radius =  ( Distance2DSquared( dropped_model.origin, players[i].origin ) < 32 * 32 );
			b_player_inside_height =  Abs( dropped_model.origin[2] - players[i].origin[2] ) < ( 30 + 20 );
			
			if ( b_player_inside_radius && b_player_inside_height )
			{
				player = players[i];
				
				if( player IsPlayerFacingTheDrop(dropped_model) )
				{
					dropped_model.picked_up = true;
					
					players[i] notify( "BZMNotifyDropPickedUp" );
	
					players[i] notify( str_identifier );
					players[i] givebzmdrop_bonus( str_bonus, dropped_model );
					
					dropped_model notify( "stopbzmdrop_behavior" );
	
					break;
				}
			}
		}
		
		wait 0.1;
	}
}

function _deletebzmdrop_ent( n_delay = 0.1 )
{
	level.bzmActiveDrops--;	
	assert( level.bzmActiveDrops >= 0 );		
	
	self clientfield::set("powerup_on_fx", 0);
	
	if ( n_delay > 0 )
	{
		self Ghost();
		wait n_delay;
	}
	
	self Delete();
}

function bzmdrop_drop_model_thread()  // self = script model
{
	self thread bzmdrop_model_blink_animate();
	
	self util::waittill_any( "death_or_disconnect", "stopbzmdrop_behavior" );
	
	n_delete_delay = 0.1;  // needs 0.1 wait to make sure client has recieved appropriate field notification
	
	if ( ( isdefined( self.picked_up ) && self.picked_up ) )
	{
		self clientfield::set("powerup_grabbed_fx", 1);
		n_delete_delay = 1;
	}
	
	self _deletebzmdrop_ent( n_delete_delay );	
}

// ----------------------
// Give Drop on pickup
//-----------------------
function givebzmdrop_bonus( str_bonus, dropped_model )  // self = player
{	
	switch ( str_bonus )
	{
		case "cybercom":
			self give_random_cybercore(false);
			break;
			
		case "cybercom_upgraded":	
			self give_random_cybercore(true);
			break;				
			
		case "ammo":
			self give_max_ammo();
			break;
		
		case "random_weapon":
			self give_random_weapon(dropped_model);
			break;
		
		case "instakill":
			self give_instakill();
			break;
			
		case "instakill_upgraded":
			self give_instakill_upgraded();
			break;	
			
		case "raps":
			self thread give_raps();
			break;	
			
		default:
			Assert( "invalid bonus string '" + str_bonus + "' used in givebzmdrop_bonus()!" );
			break;
	}
}

// ----------------------
// RAPS/MEAT BALL
//-----------------------
function private give_raps()
{
	level.BZMRapsActive = true;
	
	closestPlayer = ArrayGetClosest( self.origin, level.players );
	playerForward = AnglesToForward( closestPlayer.angles );
	locationInFrontOfPlayer = closestPlayer.origin + VectorScale( playerForward, 100 );
	locationInFrontOfPlayer = GetClosestPointOnNavMesh( locationInFrontOfPlayer, 300 );
	
	if( !IsDefined( locationInFrontOfPlayer ) )
		return;
	
	raps_ai = SpawnVehicle( "spawner_enemy_54i_vehicle_raps_suicide", locationInFrontOfPlayer, closestPlayer.angles, "raps_drop" );
		
	if( IsDefined( raps_ai ) )
	{		
		raps_ai.team = "allies";
		raps_ai.ignoreme = true;
		raps_ai.disableAutoDetonation = true;
		raps_ai SetAvoidanceMask( "avoid none" );
		
		wait 40;
				
		if( IsDefined( raps_ai ) && IsAlive( raps_ai ) )
		{
			attacker = raps_ai;			
			raps_ai stopsounds();			
			raps_ai DoDamage( raps_ai.health + 1000, raps_ai.origin, attacker, raps_ai, "none", "MOD_EXPLOSIVE", 0, raps_ai.turretWeapon );
		}
	}
	
	level.BZMRapsActive = false;
}

// ----------------------
// Cybercom
//-----------------------
function BZM_SetupCyberComAbilities()
{
	// Setup available abilities array
	level.__BZMSupportedCyberComAbilities = [];
	
	array::add( level.__BZMSupportedCyberComAbilities, "cybercom_overdrive" );
	array::add( level.__BZMSupportedCyberComAbilities, "cybercom_camo" );
	array::add( level.__BZMSupportedCyberComAbilities, "cybercom_concussive" );
	array::add( level.__BZMSupportedCyberComAbilities, "cybercom_unstoppableforce" );
	array::add( level.__BZMSupportedCyberComAbilities, "cybercom_fireflyswarm" );
	//array::add( level.__BZMSupportedCyberComAbilities, "cybercom_misdirection" ); // Not working out so great currently
}

function give_random_cybercore( upgraded ) // self = player 
{	
	assert( IsDefined(level.__BZMSupportedCyberComAbilities) && level.__BZMSupportedCyberComAbilities.size );
	
	abilities = ArrayCopy( level.__BZMSupportedCyberComAbilities );
	
	// This is to make sure that player always gets a different ability than the one he currently has
	foreach( ability in level.__BZMSupportedCyberComAbilities )
	{
		if( self HasCybercomAbility( ability ) > 0 )
		{
		   ArrayRemoveValue( abilities, ability );
		}
	}
	
	cyberComAbility = array::random( abilities );
	
/#
	if(GetDvarString("bzm_forceCyberCom","")!="")
		cyberComAbility = GetDvarString("bzm_forceCyberCom");
#/	
		
	self cybercom::enableCybercom();
		
	// Take all existing abilities
	assert( IsDefined( level.cybercom.abilities ) );
	
	foreach(ability in level.cybercom.abilities)
	{	
		self ClearCyberComAbility(ability.name);
		self cybercom_gadget::abilityTaken(ability);
	}
	
	if( ( isdefined( upgraded ) && upgraded ) )
		self cybercom_gadget::giveAbility( cyberComAbility, true );
	else
		self cybercom_gadget::giveAbility( cyberComAbility, false );
	
	self cybercom_gadget::equipAbility( cyberComAbility, true );	 	
	
	self thread trackCurrentCyberComUsage(cyberComAbility, upgraded);
}

function private trackCurrentCyberComUsage(cyberComAbility, upgraded)
{
	self endon("death");
	self notify( "trackCurrentCyberComUsage" );
	
	self.BZMCyberComUsage = 0;
	self.BZMCyberComGivenTime = GetTime();
	
	switch( cyberComAbility )
	{
		case "cybercom_overdrive":
		case "cybercom_camo":		
		case "cybercom_concussive":
		case "cybercom_fireflyswarm":					
			self thread _trackCurrentCyberComUsageCounter(upgraded);
			break;	
		
		case "cybercom_unstoppableforce":
			self thread _trackCurrentCyberComUsageTime(upgraded);
			break;				
	}
}

function private _trackCurrentCyberComUsageTime(upgraded)
{
	self endon("death");
	self endon( "trackCurrentCyberComUsage" );
	
	self notify( "_trackCurrentCyberComUsageTime" );
	self endon( "_trackCurrentCyberComUsageTime" );
	
	assert( self.BZMCyberComGivenTime > 0 );
	
	if( ( isdefined( upgraded ) && upgraded ) )
	{
		takeAwayCyberComTime = self.BZMCyberComGivenTime + 60 * 1000;;
	}
	else
	{
		takeAwayCyberComTime = self.BZMCyberComGivenTime + 30 * 1000;;
	}
	
	while( GetTime() < takeAwayCyberComTime )
	{
		wait 0.1;
	}
	
	foreach(ability in level.cybercom.abilities)
	{	
		self ClearCyberComAbility(ability.name);
		self cybercom_gadget::abilityTaken(ability);
	}	
}

function private _trackCurrentCyberComUsageCounter(upgraded)
{
	self endon("death");
	self endon( "trackCurrentCyberComUsage" );
	
	self notify( "_trackCurrentCyberComUsageCounter" );
	self endon( "_trackCurrentCyberComUsageCounter" );
	
	assert(self.BZMCyberComUsage == 0);
	
	if( ( isdefined( upgraded ) && upgraded ) )
	{
		allowedUsage = 5;
	}
	else
	{
		allowedUsage = 3;
	}
	
	while(self.BZMCyberComUsage < 3 )
	{
		wait 0.1;
	}
	
	wait 5;
				
	foreach(ability in level.cybercom.abilities)
	{	
		self ClearCyberComAbility(ability.name);
		self cybercom_gadget::abilityTaken(ability);
	}
}

function private BZMOnCyberComOnCallback(player) // self = player
{
	Assert( IsPlayer(player) );
	
	if( !IsDefined( player.BZMCyberComUsage ) )
		return;
	
	player.BZMCyberComUsage++;
}

// ----------------------
// Max Ammo
//-----------------------
function give_max_ammo()
{	
	a_w_weapons = self GetWeaponsList();

	foreach ( w_weapon in a_w_weapons )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}
}

// ----------------------
// Random Weapon
//-----------------------
function give_random_weapon( dropped_model )
{
	assert( IsDefined( dropped_model.weaponInfo ) );
	
	self bonuszmdrops::BZM_GivePlayerWeapon(dropped_model.weaponInfo);
}

// ----------------------
// Instakill
//-----------------------
function give_instakill() // self = player
{	
	self thread instakill_think();
}

function instakill_think() // self = player
{
	self endon("death");
	self endon("disconnect");
	self notify("new_instakill_think");
	
	self endon("new_instakill_think");
		
	self.forceAnhilateOnDeath = true;
	
	wait 15;
	
	self.forceAnhilateOnDeath = false;
}

function BZM_IsInstaKillActive()
{
	// Only one player gets the upgraded instakill
	foreach( player in level.players )
	{
		if( IsDefined( self.forceAnhilateOnDeath ) )
			return true;
	}
	
	return false;
}



// ----------------------
// Instakill Upgraded
//-----------------------
function BZM_IsUpGradedInstaKillActive()
{
	// Only one player gets the upgraded instakill
	foreach( player in level.players )
	{
		if( IsDefined( self.bzm_instakillAIBucket ) )
			return true;
	}
	
	return false;
}

function give_instakill_upgraded() // self = player
{
	if( IsDefined( self.bzm_instakillAIBucket ) )
		return;
		
	self thread instakill_upgraded_think();
}

function instakill_upgraded_think() // self = player
{
	self endon("death");
	
	assert( !IsDefined( self.bzm_instakillAIBucket ) );
	
	foreach( player in level.players )
	{
		player clientfield::set_to_player("instakill_upgraded_fx", 1);
	}
	
	self.bzm_instakillAIBucket = [];
	self.forceAnhilateOnDeath = true;	
		
	SetSlowMotion( 1, 0.7, 2 );
	
	wait 2;
	
	if( level.players.size == 1 ) // only allow bucket logic when in solo mode. In co-op just instakill guys
	{
		self.bzm_forceKeepAIAlive	= true;	
		level.bzm_worldPaused	= true;
		SetPauseWorld( true );
	}	
	
	wait 8;
		
	if( ( isdefined( level.bzm_worldPaused ) && level.bzm_worldPaused ) )
	{
		self.bzm_forceKeepAIAlive	= false;	
		level.bzm_worldPaused	= false;
		SetPauseWorld( false );
	}
		
	foreach( player in level.players )
	{
		self clientfield::set_to_player("instakill_upgraded_fx", 0);
	}
	
	foreach( ai in self.bzm_instakillAIBucket )
	{
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai ASMSetAnimationRate( 0.1 );
		}
	}
		
	startTime = 0.8;
	
	for( i = self.bzm_instakillAIBucket.size - 1; i >= 0; i-- )
	{	
		ai = self.bzm_instakillAIBucket[i];
		
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			ai DoDamage( ai.health + 1, self.origin, self );
			startTime = startTime - 0.1;
			
			if( startTime <= 0 )
				startTime = 0;
			
			wait startTime;
		}	
	}

	SetSlowMotion( 0.7, 1, 2 );	
		
	self.bzm_instakillAIBucket = undefined;	
	self.forceAnhilateOnDeath = false;
}
