
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\beam_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\weapons\grapple;

                                                                           

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerup_beast_mana;
#using scripts\zm\_zm_utility;

#using scripts\zm\_zm_altbody;

#namespace zm_altbody_beast;

function autoexec __init__sytem__() {     system::register("zm_altbody_beast",&__init__,undefined,undefined);    }






	




	




	



#precache( "client_fx", "zombie/fx_bmode_muz_view_zmb" );
#precache( "client_fx", "zombie/fx_bmode_kiosk_fire_zod_zmb" );
#precache( "client_fx", "zombie/fx_bmode_kiosk_idle_zod_zmb" );
	
function __init__()
{
	if(!isdefined(level.bminteract))level.bminteract=[];
	
	clientfield::register( "missile", "bminteract", 1, 1, "int", &bminteract_changed, !true, !true );
	clientfield::register( "scriptmover", "bminteract", 1, 1, "int", &bminteract_changed, !true, !true );
	clientfield::register( "scriptmover", "bm_players_allowed", 1, 4, "int", &update_kiosk_state, !true, !true );
	
	duplicate_render::set_dr_filter_offscreen( "bmint", 35,
	              								"bminteract,bmplayer", undefined,                    
          		  								2, "mc/hud_keyline_beastmode"  );
	
	zm_altbody::init( "beast_mode", 
	                 "beast_mode_kiosk", 
	                 &"ZM_ZOD_ENTER_BEAST_MODE", 
	                 "zombie_beast", 
	                 123, 
					 &player_enter_beastmode,
					 &player_exit_beastmode );
	callback::on_localclient_connect( &player_on_connect );
	callback::on_spawned( &player_on_spawned );
	
	callback::add_weapon_type( "zombie_beast_ooze", &spawned_ooze );

	level._effect[ "ooze_view_muzzle" ]	= "zombie/fx_bmode_muz_view_zmb";
	
	level._effect[ "beast_kiosk_fx_enabled" ] = "zombie/fx_bmode_kiosk_fire_zod_zmb";
	level._effect[ "beast_kiosk_fx_disabled" ] = "zombie/fx_bmode_kiosk_idle_zod_zmb";
	
}

function spawned_ooze( localClientNum )
{
	owner = self GetOwner( localClientNum );
	if ( IsDefined(owner) && owner == GetLocalPlayer(localClientNum) )
	{
		fx = level._effect["ooze_view_muzzle"];
		PlayViewmodelFx( localclientnum, fx, "tag_weapon" );
	}
}
 

function player_on_connect( localClientNum )
{
	self thread player_update_beast_mode_objects( localClientNum, false );
}

function player_on_spawned( localClientNum )
{
	self thread player_update_beast_mode_objects( localClientNum, false );
	self oed_sitrepscan_setradius( 1800 );
}

function player_enter_beastmode( localClientNum )
{
	self.beast_mode = 1;
	self thread player_update_beast_mode_objects( localClientNum, true );
	self thread sndBeastMode( true );
	self thread grapple_watch(true);
}

function player_exit_beastmode( localClientNum )
{
	self thread grapple_watch(false);
	self thread player_update_beast_mode_objects( localClientNum, false );
	self thread sndBeastMode( false );
	self.beast_mode = 0;
}

// replaces GetEntArray which does not work with script_noteworthy
function get_script_noteworthy_array(  localClientNum, val, key )
{
	all = GetEntArray( localClientNum );
	ret = [];
	foreach( ent in all )
	{
		if ( IsDefined(ent.script_noteworthy) )
		{
			if ( ( ent.script_noteworthy === val ) )
			{
				ret[ret.size] = ent;
			}
		}
	}
	return ret;
	
}

function player_update_beast_mode_objects( localClientNum, onOff )
{
	bmo = get_script_noteworthy_array( localClientNum, "beast_mode", "script_noteworthy" );
	array::run_all( bmo, &entity_set_visible, localClientNum, self, onOff );
	bmho = get_script_noteworthy_array( localClientNum, "not_beast_mode", "script_noteworthy" );
	array::run_all( bmho, &entity_set_visible, localClientNum, self, !onOff );
	
	{wait(.016);};
	clean_deleted(level.bminteract);
	array::run_all( level.bminteract, &entity_set_bmplayer, localClientNum, onOff );
}

function entity_set_bmplayer( localClientNum, onOff )
{
	self duplicate_render::set_dr_flag( "bmplayer", onOff );
	self duplicate_render::update_dr_filters();
}

function entity_set_visible( localClientNum, player, onOff )
{
	if ( onOff )
		self Show();
	else
		self Hide();
}

function add_remove_list( &a, on_off )
{
	if(!isdefined(a))a=[];
	if ( on_off )
	{
		if ( !IsInArray( a, self ) )
		{
			ArrayInsert(a,self,a.size);
		}
	}
	else
	{
		ArrayRemoveValue( a, self, false );
	}
}

function clean_deleted( &array )
{
	done = false; 
	while ( !done && array.size > 0 )
	{
		done = true;
		foreach( key, val in array )
		{
			if (!IsDefined(val))
			{
				ArrayRemoveIndex(array,key,false);
				done = false; 
				break;
			}
		}
	}
}

function bminteract_changed( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self add_remove_list( level.bminteract, newVal );
	self duplicate_render::set_dr_flag( "bmplayer", ( isdefined( GetLocalPlayer(local_client_num).beast_mode ) && GetLocalPlayer(local_client_num).beast_mode ) );
	if ( newVal )
	{
		self duplicate_render::set_dr_flag( "bminteract", newVal );
		self duplicate_render::update_dr_filters();
	}
	else
	{
		if ( IsDefined(self.currentdrfilter))
		{
			self duplicate_render::set_dr_flag( "bminteract", newVal );
			self duplicate_render::update_dr_filters();
		}
	}	
}

function update_kiosk_state( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( localClientNum );
	n_entnum = player GetEntityNumber();
	
	if(!isdefined(self.beast_kiosk_fx))self.beast_kiosk_fx=[];
	if(!isdefined(self.beast_kiosk_fx[ localClientNum ]))self.beast_kiosk_fx[ localClientNum ]=[];
	
	if ( newVal & ( 1 << n_entnum ) )
	{
		if ( isdefined( self.beast_kiosk_fx[ localClientNum ][ "disabled" ] ) )
		{
			StopFX( localClientNum, self.beast_kiosk_fx[ localClientNum ][ "disabled" ] );
			self.beast_kiosk_fx[ localClientNum ][ "disabled" ] = undefined;
		}
		
		if ( !isdefined( self.beast_kiosk_fx[ localClientNum ][ "enabled" ] ) )
		{
			self.beast_kiosk_fx[ localClientNum ][ "enabled" ] =
				PlayFxOnTag(
					localClientNum,
					level._effect[ "beast_kiosk_fx_enabled" ],
					self,
					"tag_origin"
				);
		}
	}
	else
	{
		if ( isdefined( self.beast_kiosk_fx[ localClientNum ][ "enabled" ] ) )
		{
			StopFX( localClientNum, self.beast_kiosk_fx[ localClientNum ][ "enabled" ] );
			self.beast_kiosk_fx[ localClientNum ][ "enabled" ] = undefined;
		}
		
		if ( !isdefined( self.beast_kiosk_fx[ localClientNum ][ "disabled" ] ) )
		{
			self.beast_kiosk_fx[ localClientNum ][ "disabled" ] =
				PlayFxOnTag(
					localClientNum,
					level._effect[ "beast_kiosk_fx_disabled" ],
					self,
					"tag_origin"
				);
		}
	}	
}

function sndBeastMode(activate)
{
	if(activate)
	{		
		forceambientroom("zm_zod_beastmode");
		self thread sndBeastMode_ManaStart();
	}
	else
	{
		forceambientroom( "" );
		self thread sndBeastMode_ManaStop();
	}
}
function sndBeastMode_ManaStart()
{
	level endon( "sndManaStop" );
	self endon( "entityshutdown" );
	
	if( !isdefined( level.sndBeastModeEnt ) )
	{
		level.sndBeastModeEnt = spawn(0,(0,0,0),"script_origin");
		soundID = level.sndBeastModeEnt playloopsound( "zmb_beastmode_mana_looper", 2 );
		setsoundvolume( soundID, 0 );
	}
	
	while(1)
	{
		if( isdefined( self.mana ) )
		{
			if( self.mana <= .5 )
			{
				volume = .51-self.mana;
				setsoundvolume( soundID, volume );
			}
		}
		wait(.1);
	}
}
function sndBeastMode_ManaStop()
{
	level notify( "sndManaStop" );
	if( isdefined( level.sndBeastModeEnt ) )
	{
		level.sndBeastModeEnt delete();
		level.sndBeastModeEnt = undefined;
	}
}

function grapple_beam( player, pivot )
{
	level beam::launch( player, "tag_flash", pivot, "tag_origin", "zod_beast_grapple_beam" );
	player waittill( "grapple_done" );
	level beam::kill( player, "tag_flash", pivot, "tag_origin", "zod_beast_grapple_beam" );
}


function grapple_watch( onOff )
{
	self notify("grapple_done");
	
	self notify("grapple_watch");
	self endon("grapple_watch");
	
	if ( onOff )
	{
		while( IsDefined(self) )
		{
			self waittill ( "grapple_fired", weapon, target, pivot );
			if ( IsDefined(pivot) && !pivot IsPlayer() )
			{
				thread grapple_beam( self, pivot );
			}
			evt = self util::waittill_any_timeout( 2.5, "grapple_pulled", "grapple_landed", "grapple_cancel" );
			self notify("grapple_done");
		}
	}
}

