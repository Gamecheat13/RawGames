#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_filter;
#using scripts\zm\_zm;

#namespace zm_turned;

function autoexec __init__sytem__() {     system::register("zm_turned",&__init__,undefined,undefined);    }
	
function __init__()
{
	// called from _zm.csc to handle setting up client filelds on map restart because precache() does not get called from CodeCallback_PrecacheGameType on a map restart
	dvar = GetDvarString( "ui_gametype" );
	if ( dvar == "zcleansed" )
	{
		precache();
	}
}	

function precache()
{
	if (( isdefined( level._zm_turned_precached ) && level._zm_turned_precached ))
		return;
	level._zm_turned_precached=1;
	
	level.face_override_func = turned_face_override_func();
	
	visionset_mgr::register_visionset_info( "zombie_turned", 1, 1, "zombie_turned", "zombie_turned" );
	clientfield::register( "toplayer", "turned_ir", 1, 1, "int", &zombie_turned_ir, !true, true ); 
	clientfield::register( "allplayers", "player_has_eyes", 1, 1, "int", &zm::player_eyes_clientfield_cb, !true, true );
	clientfield::register( "allplayers", "player_eyes_special", 1, 1, "int", &zm::player_eye_color_clientfield_cb, !true, true );
	
//	level._effect["player_eye_glow_blue"] = "_t6/maps/zombie/fx_zombie_eye_returned_blue";
//	level._effect["player_eye_glow_orng"] = "_t6/maps/zombie/fx_zombie_eye_returned_orng";
	
	SetDvar( "aim_target_player_enabled", true );
}

//#using_animtree( "zombie_player" );
function turned_face_override_func()
{
/*	level.face_anim_tree = "zombie_player";
	
	self face::setFaceRoot( %head );
	self face::buildFaceState( "face_casual", true, -1, 0, "basestate", array(%pf_casual_idle) );
	self face::buildFaceState( "face_alert", true, -1, 0, "basestate", array(%pf_alert_idle) );
	self face::buildFaceState( "face_shoot", true, 1, 1, "eventstate", array(%pf_firing) );
	self face::buildFaceState( "face_shoot_single", true, 1, 1, "eventstate", array(%pf_firing) );
	self face::buildFaceState( "face_melee", true, 2, 1, "eventstate", array(%pf_melee) );
	self face::buildFaceState( "face_pain", false, -1, 2, "eventstate", array(%pf_pain) );
	//self face::buildFaceState( "face_death", false, -1, 2, "exitstate", array(%pf_death) );
	//self face::buildFaceState( "zombie_face_casual", true, -1, 0, "basestate", array( %f_idle_zombie_v1, %f_idle_zombie_v2, %f_idle_zombie_v3, %f_idle_zombie_v4, %f_idle_zombie_v5 ) );
	//self face::buildFaceState( "zombie_face_alert", true, -1, 0, "basestate", array( %f_locomotion_zombie_v1, %f_locomotion_zombie_v2, %f_locomotion_zombie_v3, %f_locomotion_zombie_v4, %f_locomotion_zombie_v5 ) );
	//self face::buildFaceState( "zombie_face_melee", true, 2, 1, "eventstate", array( %f_attack_zombie_v1, %f_attack_zombie_v2, %f_attack_zombie_v3, %f_attack_zombie_v4, %f_attack_zombie_v5 ) );
	//self face::buildFaceState( "zombie_face_death", false, -1, 2, "exitstate", array( %f_death_zombie_v1, %f_death_zombie_v2, %f_death_zombie_v3, %f_death_zombie_v4, %f_death_zombie_v5 ) );
	self face::buildFaceState( "face_advance", false, -1, 3, "nullstate", array() );
	self face::buildFaceState( "zombie_face_advance", false, -1, 3, "nullstate", array() );*/
}

function main()
{
	//level thread zm_audio::zmbMusLooper();

	setup_zombie_exerts();

	if ( IsDemoPlaying() )
		thread zombie_turned_demo_ir();
}

function zombie_turned_set_ir( lcn, newVal )
{
	if( newVal )
	{
		SetLutScriptIndex( lcn, 2 );
		filter::enable_filter_zm_turned( self, 0, 0 );
		self SetSonarAttachmentEnabled( true );
	}
	else
	{
		SetLutScriptIndex( lcn, 0 );
		filter::disable_filter_zm_turned( self, 0, 0 );
		self SetSonarAttachmentEnabled( false );
	}
}

function zombie_turned_ir( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(!self isLocalPlayer() )
	{
		return;
	}

	if(!isDefined(self GetLocalClientNumber() ))
	{
		return;
	}
	if ( self GetLocalClientNumber() != localClientNum )
	{
		return; 
	}

	self.is_player_zombie = newVal;
	
	if ( IsDemoPlaying() && IsSpectating( localClientNum ) )
		newVal = false;

	zombie_turned_set_ir( localClientNum, newVal );
}

function zombie_turned_demo_ir()
{
	lcn = 0;

	while( 1 )
	{
		assert( IsDemoPlaying() );

		if ( GetLocalPlayer( lcn ).is_player_zombie )
		{
			GetLocalPlayer( lcn ) zombie_turned_set_ir( lcn, !IsSpectating( lcn ) );
		}

		wait( 0.05 );
	}
}

function setup_zombie_exerts()
{
	// sniper hold breath
	level.exert_sounds[1]["playerbreathinsound"] = "null";
	
	// sniper exhale
	level.exert_sounds[1]["playerbreathoutsound"] = "null";
	
	// sniper hold breath
	level.exert_sounds[1]["playerbreathgaspsound"] = "null";

	// falling damage
	level.exert_sounds[1]["falldamage"] = "null";
	
	// mantle launch
	level.exert_sounds[1]["mantlesoundplayer"] = "null";
	
	// melee swipe
	level.exert_sounds[1]["meleeswipesoundplayer"] = "vox_exert_generic_zombieswipe";
	
	// DTP land ** this may need to be expanded to take surface type into account
	level.exert_sounds[1]["dtplandsoundplayer"] = "null";
}

