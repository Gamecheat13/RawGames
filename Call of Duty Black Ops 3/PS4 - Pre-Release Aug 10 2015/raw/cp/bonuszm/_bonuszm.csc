#using scripts\codescripts\struct;

#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\load_shared;
#using scripts\shared\music_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\_oob;
#using scripts\shared\postfx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_bouncingbetty;
#using scripts\shared\weapons\_proximity_grenade;
#using scripts\shared\weapons\_riotshield;
#using scripts\shared\weapons\_satchel_charge;
#using scripts\shared\weapons\_tacticalinsertion;
#using scripts\shared\weapons\_trophy_system;
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;

#using scripts\cp\cybercom\_cybercom;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#using scripts\shared\util_shared;


#precache( "client_fx", "zombie/fx_glow_eye_orange" );
#precache( "client_fx", "zombie/fx_glow_eye_blue" );
#precache( "client_fx", "zombie/fx_glow_eye_green" );
#precache( "client_fx", "zombie/fx_glow_eye_red" );
#precache( "client_fx", "zombie/fx_spawn_dirt_hand_burst_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_billowing_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_dustfalling_zmb" );
#precache( "client_fx", "zombie/fx_powerup_on_green_zmb");
#precache( "client_fx", "zombie/fx_powerup_on_red_zmb");
#precache( "client_fx", "zombie/fx_weapon_box_open_glow_zmb" );
#precache( "client_fx", "zombie/fx_weapon_box_closed_glow_zmb" );
#precache( "client_fx", "player/fx_plyr_clone_reaper_appear" );
#precache( "client_fx", "player/fx_plyr_clone_vanish" );
#precache( "client_fx", "explosions/fx_ability_exp_ravage_core" );
#precache( "client_fx", "zombie/fx_spawn_body_cp_zmb" );

#namespace bonuszm;

function autoexec __init__sytem__() {     system::register("bonuszm",&__init__,undefined,undefined);    }

function __init__()
{
	SetupStaticModelsForTheMode();
	SetupVolumeDecalsForTheMode();
	
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;

	bonuszm::register_clientfields();
	bonuszm::init_fx();
	
	callback::on_spawned( &on_player_spawned );
//	level thread sndPlayMusicUnderscore();
	
	add_magic_box_weapons();
}

function autoexec BZM_IgnoreSystems()
{
	
}

function private on_player_spawned( localClientNum )
{
	self TModeEnable(0);	
	SetDvar( "r_bloomUseLutALT", 1 );	
}

function SetupStaticModelsForTheMode()
{
	a_misc_models = FindStaticModelIndexArray( "zombie_misc_model" );
	
	if( ( SessionModeIsCampaignZombiesGame() ) )
	{	
		// No need to do anything.
	}
	else
	{
		foreach( a_misc_model in a_misc_models )
		{
			HideStaticModel( a_misc_model );
		}
	}
}

function SetupVolumeDecalsForTheMode()
{
	a_volume_decals = FindVolumeDecalIndexArray( "zombie_volume_decal" );
	
	if( ( SessionModeIsCampaignZombiesGame() ) )
	{	
		// No need to do anything.
	}
	else
	{
		foreach( a_volume_decal in a_volume_decals )
		{
			HideVolumeDecal( a_volume_decal );
		}
	}
}

function sndPlayMusicUnderscore()
{
	mapname = GetDvarString( "mapname" );
	if( mapname != "cp_mi_sing_sgen" || mapname != "cp_mi_cairo_lotus2"  )
	{
		audio::playloopat( "mus_bonuszm_underscore", (0,0,0) );
	}
}


function register_clientfields()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &handle_zombie_risers, !true, true);
	clientfield::register("actor", "bonus_zombie_eye_color", 1, 3, "int", &zombie_eyes_clientfield_cb2, !true, true);
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &zombie_eyes_clientfield_cb, !true, true);
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &zombie_gut_explosion_cb, !true, true);
	
	clientfield::register("actor", "zombie_instakill_fx", 1, 2, "int", &zombie_instakill_fx_cb, !true, true);
	
	clientfield::register("actor", "zombie_appear_vanish_fx", 1, 3, "int", &zombie_appear_vanish_fx, !true, true);
		
	clientfield::register("scriptmover", "powerup_on_fx", 1, 2, "int", &callback_powerup_on_fx, true, !true);
	clientfield::register("scriptmover", "powerup_grabbed_fx", 1, 1, "int", &callback_powerup_grabbed_fx, true, !true);
		
	clientfield::register( "zbarrier", "magicbox_open_glow", 1, 1, "int", &magicbox_open_glow_callback, !true, !true );
	clientfield::register( "zbarrier", "magicbox_closed_glow", 1, 1, "int", &magicbox_closed_glow_callback, !true, !true );
	
	clientfield::register( "toplayer", "instakill_upgraded_fx", 1, 1, "int", &instakill_upgraded_fx_cb, !true, !true );
	
	clientfield::register( "toplayer", "bonuszm_post_fx", 1, 2, "int", &apply_new_post_fx, !true, !true );
}

function init_fx()
{
	// Zombie eye glow effect
	level._effect["eye_glow_o"]					= "zombie/fx_glow_eye_orange";	
	level._effect["eye_glow_b"]					= "zombie/fx_glow_eye_blue";	
	level._effect["eye_glow_g"]					= "zombie/fx_glow_eye_green";	
	level._effect["eye_glow_r"]					= "zombie/fx_glow_eye_red";	
	
	// Rise Zombie effects
	level._effect["rise_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";
	
	// Power up effects
	level._effect["powerup_on"] 				= "zombie/fx_powerup_on_green_zmb";
	level._effect["powerup_on_upgraded"]		= "zombie/fx_powerup_on_red_zmb";
	
	// Magicbox effects
	level._effect["chest_light"]				= "zombie/fx_weapon_box_open_glow_zmb"; 
	level._effect["chest_light_closed"] 		= "zombie/fx_weapon_box_closed_glow_zmb"; 
	
	// Appear/Vanish
	level._effect["zombie_appear"]				= "player/fx_plyr_clone_reaper_appear"; 
	level._effect["zombie_vanish"] 				= "player/fx_plyr_clone_vanish"; 
	level._effect["zombie_spawn"] 				= "zombie/fx_spawn_body_cp_zmb"; 	
	
	// Suicide
	level._effect["zombie_suicide"]				= "explosions/fx_ability_exp_ravage_core"; 
}


//--------------------------------------------------------------------------------------------------
//		ZOMBIE RISE FX
//--------------------------------------------------------------------------------------------------
function handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( newVal )
	{		
		sound = "zmb_zombie_spawn";
		//burst_fx = level._effect["rise_burst"];
		burst_fx = level._effect["zombie_spawn"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		
		if(IsDefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}		

  		playsound (0,sound, self.origin);
		self thread rise_dust_fx(localClientNum,type,billow_fx,burst_fx);		
	}
}

function rise_dust_fx( localClientNum, type, billow_fx, burst_fx )
{
	dust_tag = "J_SpineUpper";
	
	self endon("entityshutdown");
	level endon("demo_jump");
	
	if ( IsDefined( burst_fx ) )
	{
		playfx(localClientNum,burst_fx,self.origin + ( 0,0,randomintrange(5,10) ) );
	}
	
	wait(.25);
		
	if ( IsDefined( billow_fx ) )
	{
		playfx(localClientNum,billow_fx,self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
	}
	
	wait(2);	//wait a bit to start playing the falling dust 
	dust_time = 5.5; // play dust fx for a max time
	dust_interval = .3; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	player = level.localPlayers[localClientNum];
	
	effect = level._effect["rise_dust"];
	
	if ( type == "snow")
	{
		effect = level._effect["rise_dust_snow"];
	}
	else if ( type == "none" )
	{
		return;
	}
		
	for (t = 0; t < dust_time; t += dust_interval)
	{
		PlayfxOnTag(localClientNum,effect, self, dust_tag);
		wait dust_interval;
	}	
}

function zombie_eyes_clientfield_cb2(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	//health value
	self.eyecol = newVal;
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE EYE GLOWS
//--------------------------------------------------------------------------------------------------
function zombie_eyes_clientfield_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)  // self = actor
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		self createZombieEyesInternal( localClientNum );
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_on_luminance(), self get_eyeball_color() );
	}
	else
	{
		self deleteZombieEyes(localClientNum);
		self mapshaderconstant( localClientNum, 0, "scriptVector2", 0, get_eyeball_off_luminance(), self get_eyeball_color() );
	}
	
	// optional callback for handling zombie eyes
	if ( IsDefined( level.zombie_eyes_clientfield_cb_additional ) )
	{
		self [[ level.zombie_eyes_clientfield_cb_additional ]]( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump );
	}	
}

function createZombieEyesInternal(localClientNum )
{
	self endon("entityshutdown");
	
	self util::waittill_dobj( localClientNum );	

	if ( !IsDefined( self._eyeArray ) )
	{
		self._eyeArray = [];
	}

	if ( !IsDefined( self._eyeArray[localClientNum] ) )
	{
		linkTag = "j_eyeball_le";
		
		if( !IsDefined(self.eyecol) )
		{
			return;
		}

		if( self.eyecol==0 )
		{
			effect = level._effect["eye_glow_o"];
		}
		else if( self.eyecol==1 )
		{
			effect = level._effect["eye_glow_b"];
		}
		else if( self.eyecol==2 )
		{
			effect = level._effect["eye_glow_g"];
		}
		else if( self.eyecol==3 )
		{
			effect = level._effect["eye_glow_r"];
		}
		else
		{
			return;
		}

		// will handle level wide eye fx change
		if(IsDefined(level._override_eye_fx))
		{
			effect = level._override_eye_fx;
		}
		// will handle individual spawner or type eye fx change
		if(IsDefined(self._eyeglow_fx_override))
		{
			effect = self._eyeglow_fx_override;
		}

		if(IsDefined(self._eyeglow_tag_override))
		{
			linkTag = self._eyeglow_tag_override;
		}

		self._eyeArray[localClientNum] = PlayFxOnTag( localClientNum, effect, self, linkTag );
	}
}

function get_eyeball_on_luminance()
{
	if( IsDefined( level.eyeball_on_luminance_override ) )
	{
		return level.eyeball_on_luminance_override;
	}
	
	return 1;
}

function get_eyeball_off_luminance()
{
	if( IsDefined( level.eyeball_off_luminance_override ) )
	{
		return level.eyeball_off_luminance_override;
	}
	
	return 0;
}

function get_eyeball_color()  // self = zombie
{
	val = 0;
	
	if ( IsDefined( level.zombie_eyeball_color_override ) )
	{
		val = level.zombie_eyeball_color_override;
	}
	
	if ( IsDefined( self.zombie_eyeball_color_override ) )
	{
		val = self.zombie_eyeball_color_override;
	}
	
	return val;
}

function deleteZombieEyes(localClientNum)
{
	if ( IsDefined( self._eyeArray ) )
	{
		if ( IsDefined( self._eyeArray[localClientNum] ) )
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum], true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

//--------------------------------------------------------------------------------------------------
//		POWER UP FX
//--------------------------------------------------------------------------------------------------
function callback_powerup_on_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		if( newVal == 2 ) // upgraded
			self.pwr_fx = PlayFxOnTag( localClientNum, level._effect["powerup_on_upgraded"], self, "tag_origin" );
		else
			self.pwr_fx = PlayFxOnTag( localClientNum, level._effect["powerup_on"], self, "tag_origin" );
		
		PlaySound( localClientNum, "zmb_spawn_powerup", self.origin );
		self PlayLoopSound( "zmb_spawn_powerup_loop" , .5);
	}
	else
	{
		if( IsDefined( self.pwr_fx ) )
		{
			self StopAllLoopSounds();
			DeleteFx( localClientNum, self.pwr_fx, false );
			self.pwr_fx = undefined;
		}
	}
}

function callback_powerup_grabbed_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if(newVal)
	{
		PlaySound( localClientNum, "zmb_powerup_grabbed", self.origin );		
	}	
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE EXPLODES
//--------------------------------------------------------------------------------------------------
function zombie_instakill_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if( newVal == 2 )
	{
		PlayFX( localClientNum, level._effect["zombie_suicide"], self.origin + ( 0, 0, 35 ) );
	}
	if ( newVal > 0 )
	{
		fxObj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
		
		fxObj thread PlayeSoundAndDelete( localClientNum, fxObj );		
	}
}

function private PlayeSoundAndDelete( localClientNum, fxObj )
{
	fxObj PlaySound( localClientNum, "evt_ai_explode" );		
	
	wait 1;
	
	fxObj Delete();
}


//--------------------------------------------------------------------------------------------------
//		ZOMBIE EXPLODES
//--------------------------------------------------------------------------------------------------
function zombie_gut_explosion_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		if(IsDefined(level._effect["zombie_guts_explosion"]))
		{
			org = self GetTagOrigin("J_SpineLower");
			
			if(IsDefined(org))
			{
				playfx( localClientNum, level._effect["zombie_guts_explosion"], org ); 	 
			}
		}
	}
}

//--------------------------------------------------------------------------------------------------
//	MAGIC BOX
//--------------------------------------------------------------------------------------------------
function magicbox_open_glow_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !IsDefined( self.open_glow_obj_array ) )
	{
		self.open_glow_obj_array = [];
	}

	if ( newVal && !IsDefined( self.open_glow_obj_array[localClientNum] ) )
	{
		fx_obj = spawn( localClientNum, self.origin, "script_model" ); 
		fx_obj setmodel( "tag_origin" ); 
		fx_obj.angles = self.angles;
		PlayFXOnTag( localClientNum, level._effect["chest_light"], fx_obj, "tag_origin" );
		
		PlaySound( localClientNum, "zmb_lid_open", self.origin );
		PlaySound( localClientNum, "zmb_music_box", self.origin );
					
		self.open_glow_obj_array[localClientNum] = fx_obj;
		self open_glow_obj_demo_jump_listener( localClientNum );
	}
	else if ( !newVal && IsDefined( self.open_glow_obj_array[localClientNum] ) )
	{
		self open_glow_obj_cleanup( localClientNum );
	}
}

function open_glow_obj_demo_jump_listener( localClientNum )
{
	self endon( "end_demo_jump_listener" );

	level waittill( "demo_jump" );

	self open_glow_obj_cleanup( localClientNum );
}


function open_glow_obj_cleanup( localClientNum )
{
	self.open_glow_obj_array[localClientNum] delete();
	self.open_glow_obj_array[localClientNum] = undefined;

	self notify( "end_demo_jump_listener" );
}

function magicbox_closed_glow_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !IsDefined( self.closed_glow_obj_array ) )
	{
		self.closed_glow_obj_array = [];
	}

	if ( newVal && !IsDefined( self.closed_glow_obj_array[localClientNum] ) )
	{
		fx_obj = spawn( localClientNum, self.origin, "script_model" ); 
		fx_obj setmodel( "tag_origin" ); 
		fx_obj.angles = self.angles;
		PlayFXOnTag( localClientNum, level._effect["chest_light_closed"], fx_obj, "tag_origin" );

		PlaySound( localClientNum, "zmb_lid_close", self.origin );
		
		self.closed_glow_obj_array[localClientNum] = fx_obj;
		self closed_glow_obj_demo_jump_listener( localClientNum );
	}
	else if ( !newVal && IsDefined( self.closed_glow_obj_array[localClientNum] ) )
	{
		self closed_glow_obj_cleanup( localClientNum );
	}
}


function closed_glow_obj_demo_jump_listener( localClientNum )
{
	self endon( "end_demo_jump_listener" );

	level waittill( "demo_jump" );

	self closed_glow_obj_cleanup( localClientNum );
}


function closed_glow_obj_cleanup( localClientNum )
{
	self.closed_glow_obj_array[localClientNum] delete();
	self.closed_glow_obj_array[localClientNum] = undefined;

	self notify( "end_demo_jump_listener" );
}
	
function add_magic_box_weapons()
{
	// number of rows = number of weapons
	weaponsTableName = "gamedata/tables/cpzm/" + "cpzm_weapons_default.csv";
	
	numWeapons = TableLookupRowCount( weaponsTableName );
	availableWeapons = [];
	
	// lookup row one by one
	for( i = 0; i < numWeapons; i++ )
	{
		weaponName = TableLookupColumnForRow( weaponsTableName, i, 0 );

		array::add( availableWeapons, weaponName );
	}
		
	availableWeapons = array::randomize( availableWeapons );
		
	for( i = 0; i < availableWeapons.size; i++ )
	{	
		if( i >= 30  )
			break;
		
		weapon = GetWeapon( availableWeapons[i] );
		
		if( !IsDefined(weapon) )
			continue;
		
		if( IsDefined( weapon.worldModel ) )
		{
			AddZombieBoxWeapon( weapon, weapon.worldModel, false );
		}
	}
}

//--------------------------------------------------------------------------------------------------
//	INSTAKILL UPGRADED
//--------------------------------------------------------------------------------------------------
function instakill_upgraded_fx_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		self.instakill_soundId = self playloopsound( "zmb_insta_kill_loop", 2 );
	}
	else
	{
		self notify("stop_instakill_upgrade_fx");
		playsound( localClientNum, "zmb_insta_kill_loop_off", (0,0,0) );
		self stoploopsound( self.instakill_soundId );
	}
}

//--------------------------------------------------------------------------------------------------
//	POST FX
//--------------------------------------------------------------------------------------------------
function apply_new_post_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		// bblend
		filter::map_material_helper( self, "generic_zombie_bblend_vignette" );
		setfilterpassmaterial( self.localClientNum, 7, 0, filter::mapped_material_id( "generic_zombie_bblend_vignette" ) );
		setfilterpassenabled( self.localClientNum, 7, 0, true );
		setFilterPassConstant( self.localClientNum, 7, 0, 0, 1 );
		setFilterPassConstant( self.localClientNum, 7, 0, 1, 0 );
		
		/# 
			iprintlnbold( "POSTFX: BBLEND" );
		#/
	}
	else if( newVal == 2 )
	{
		// multiply
		filter::map_material_helper( self, "generic_zombie_bmultiply_vignette" );
		setfilterpassmaterial( self.localClientNum, 7, 0, filter::mapped_material_id( "generic_zombie_bmultiply_vignette" ) );
		setfilterpassenabled( self.localClientNum, 7, 0, true );
		setFilterPassConstant( self.localClientNum, 7, 0, 0, 1 );
		setFilterPassConstant( self.localClientNum, 7, 0, 1, 0 );
		
		/# 
			iprintlnbold( "POSTFX: MULTIPLY" );
		#/
	}
	else
	{
		 setfilterpassenabled( self.localClientNum, 7, 0, false );
		 
		/# 
			iprintlnbold( "POSTFX: NONE" );
		#/
	}
}

//--------------------------------------------------------------------------------------------------
//	Appear / Vanish
//--------------------------------------------------------------------------------------------------
function zombie_appear_vanish_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 1 )
	{
		//PlayFX( localClientNum, level._effect["zombie_appear"], self.origin + ( 0, 0, 35 ) );
		PlayFX( localClientNum, level._effect["zombie_spawn"], self.origin + ( 0, 0, 35 ) );				
	}
	else if( newVal == 2 )
	{
		//PlayFX( localClientNum, level._effect["zombie_vanish"], self.origin + ( 0, 0, 35 ) );		
		PlayFX( localClientNum, level._effect["zombie_spawn"], self.origin + ( 0, 0, 35 ) );				
	}
	else if( newVal == 3 )
	{
		PlayFX( localClientNum, level._effect["zombie_spawn"], self.origin + ( 0, 0, 35 ) );				
	}
}
