#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_shg_debug;
#include soundscripts\_snd;
#include soundscripts\_snd_playsound;

#using_animtree( "vehicles" );

FASTZIP_ROPE_LENGTH = 200;			// (2400 units) how far an AI can fastzip, in feet (total distance rope goes in animation)
GROUND_CHECK_DISTANCE = 40;			// (480 units) distance the AI must slide within to start checking for the ground
DOWN_ANGLE_LIMIT = 60;				// 0-90 degrees down the turret can aim at
SIDE_ANGLE_LIMIT = 45;				// 0-90 degrees to the side the turret can aim at
SLIDE_RATE_SCALE = 1.2;				// scale the slide animation speed

is_using_model_memory_sharing()
{
	return !is_gen4();
}

main( model, type, classname )
{
	stealth_version = false;
	if( IsSubStr( classname, "_stealth" ) )
	{
		stealth_version = true;
	}
	
	no_turrets = false;
	if ( IsSubStr( classname, "_no_turret" ) )
	{
		no_turrets = true;
	}

	PrecacheModel( "npc_zipline_gun_left" );
	PrecacheModel( "npc_zipline_rope_left" );
	PrecacheModel( "npc_zipline_gun_right" );
	PreCacheModel( "npc_zipline_rope_right" );
	PreCacheModel( "npc_optics_zipline_gun" );
	
	set_console_status();
	if ( is_using_model_memory_sharing() )
	{
		PreCacheModel( "vehicle_xh9_warbird_cloaked_transparent" );
		PreCacheModel( "vehicle_xh9_warbird_decloaking_masked" );
	}
	else
		PreCacheModel( "vehicle_xh9_warbird_cloaked_in_out" );
	
	if ( stealth_version )
	{
		PreCacheModel( "vehicle_xh9_warbird_turret_left_stealth" );
		PreCacheModel( "vehicle_xh9_warbird_turret_right_stealth" );
	}
	else
	{
		PreCacheModel( "vehicle_xh9_warbird_turret_left" );
		PreCacheModel( "vehicle_xh9_warbird_turret_right" );
	}
	PreCacheTurret( "zipline_gun" );
	PreCacheTurret( "zipline_gun_rope" );
	
	build_template( "xh9_warbird", model, type, classname );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_xh9_warbird" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims, ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );
    build_bulletshield( true );
    //build_drive( %warbird_rotors_spin, undefined, 0 );// repeated for building anim csv's
    
    if ( !no_turrets )
    {
	    if( stealth_version )
		{
	    	//            info,             tag,                model,                                      maxrange,  defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw, offset_tag
	    	build_turret( "warbird_turret", "tag_turret_left",  "vehicle_xh9_warbird_turret_left_stealth",  undefined, "manual",      undefined,   0,                0,              undefined);
	    	build_turret( "warbird_turret", "tag_turret_right", "vehicle_xh9_warbird_turret_right_stealth", undefined, "manual",      undefined,   0,                0,              undefined);
	    }
	    else
	    {
	    	build_turret( "warbird_turret", "tag_turret_left",  "vehicle_xh9_warbird_turret_left",          undefined, "manual",      undefined,   0,                0,              undefined);
	    	build_turret( "warbird_turret", "tag_turret_right", "vehicle_xh9_warbird_turret_right",         undefined, "manual",      undefined,   0,                0,              undefined);
	    }
    }

	randomStartDelay = RandomFloatRange( 0, 1 );
			 //   model      name 					   tag 				      effect 							   group 	   delay 		    
	//build_light( classname, "cockpit_blue_cargo01"	, "tag_light_cargo01"  , "vfx/lights/air_light_cockpit_red"	, "interior", 0.0 );
	//build_light( classname, "cockpit_blue_cockpit01", "tag_light_cockpit01", "vfx/lights/air_light_cockpit_blue" , "interior", 0.0 );
	//build_light( classname, "white_blink"			, "tag_light_belly"	   , "vfx/lights/air_light_wingtip_red"	, "running" , randomStartDelay );
	//build_light( classname, "wingtip_green"			, "tag_light_L_wing"   , "vfx/lights/air_light_wingtip_red", "running" , randomStartDelay );
	//build_light( classname, "wingtip_red"			, "tag_light_R_wing"   , "vfx/lights/air_light_wingtip_red"	, "running" , randomStartDelay );
	build_light( classname, "white_blink_tail"		, "tag_light_tail"	   , "vfx/lights/air_light_wingtip_red"	, "running" , randomStartDelay );
	build_light( classname, "wingtip_red_body_r"	, "TAG_light_body_R"   , "vfx/lights/air_light_wingtip_red", "running" , randomStartDelay );
	build_light( classname, "wingtip_red_body_l"	, "TAG_light_body_L"   , "vfx/lights/air_light_wingtip_red"	, "running" , randomStartDelay );

	
	build_is_helicopter();
	
	thread load_script_model_anims();
}

#using_animtree( "script_model" );
load_script_model_anims()
{	
	level.scr_animtree[ "_zipline_gun_fl" ] = #animtree;
	level.scr_model[ "_zipline_gun_fl" ] = "npc_zipline_gun_right";
	level.scr_anim[ "_zipline_gun_fl" ][ "folded_idle" ] = %fastzip_launcher_folded_idle_right;
	level.scr_anim[ "_zipline_gun_fl" ][ "rest_idle" ] = %fastzip_launcher_rest_idle_right;
	level.scr_anim[ "_zipline_gun_fl" ][ "readyup" ] = %fastzip_launcher_readyup_right;
	level.scr_anim[ "_zipline_gun_fl" ][ "jumpout" ] = %fastzip_launcher_jumpout_right;
	level.scr_anim[ "_zipline_gun_fl" ][ "fastzip_pullout" ] = %fastzip_launcher_pullout;
	level.scr_anim[ "_zipline_gun_fl" ][ "fastzip_putaway" ] = %fastzip_launcher_putaway;
	level.scr_anim[ "_zipline_gun_fl" ][ "fastzip_aim_idle" ] = %fastzip_launcher_aim_level_right;
	level.scr_anim[ "_zipline_gun_fl" ][ "fastzip_fire" ] = %fastzip_launcher_fire_right_npc;
	level.scr_anim[ "_zipline_gun_fl" ][ "fastzip_slide" ] = %fastzip_launcher_slidedown_right_npc;
	level.scr_anim[ "_zipline_gun_fl" ][ "retract_rope" ] = %fastzip_launcher_retract_right;
	
	level.scr_animtree[ "_zipline_gun_fr" ] = #animtree;
	level.scr_model[ "_zipline_gun_fr" ] = "npc_zipline_gun_left";
	level.scr_anim[ "_zipline_gun_fr" ][ "folded_idle" ] = %fastzip_launcher_folded_idle_left;
	level.scr_anim[ "_zipline_gun_fr" ][ "rest_idle" ] = %fastzip_launcher_rest_idle_left;
	level.scr_anim[ "_zipline_gun_fr" ][ "readyup" ] = %fastzip_launcher_readyup_left;
	level.scr_anim[ "_zipline_gun_fr" ][ "jumpout" ] = %fastzip_launcher_jumpout_left;
	level.scr_anim[ "_zipline_gun_fr" ][ "fastzip_pullout" ] = %fastzip_launcher_pullout;
	level.scr_anim[ "_zipline_gun_fr" ][ "fastzip_putaway" ] = %fastzip_launcher_putaway;
	level.scr_anim[ "_zipline_gun_fr" ][ "fastzip_aim_idle" ] = %fastzip_launcher_aim_level_left;
	level.scr_anim[ "_zipline_gun_fr" ][ "fastzip_fire" ] = %fastzip_launcher_fire_left_npc;
	level.scr_anim[ "_zipline_gun_fr" ][ "fastzip_slide" ] = %fastzip_launcher_slidedown_left_npc;
	level.scr_anim[ "_zipline_gun_fr" ][ "retract_rope" ] = %fastzip_launcher_retract_left;
	
	level.scr_animtree[ "_zipline_gun_kl" ] = #animtree;
	level.scr_model[ "_zipline_gun_kl" ] = "npc_zipline_gun_left";
	level.scr_anim[ "_zipline_gun_kl" ][ "folded_idle" ] = %fastzip_launcher_folded_idle_left;
	level.scr_anim[ "_zipline_gun_kl" ][ "rest_idle" ] = %fastzip_launcher_rest_idle_left;
	level.scr_anim[ "_zipline_gun_kl" ][ "readyup" ] = %fastzip_launcher_readyup_left;
	level.scr_anim[ "_zipline_gun_kl" ][ "jumpout" ] = %fastzip_launcher_jumpout_left;
	level.scr_anim[ "_zipline_gun_kl" ][ "fastzip_pullout" ] = %fastzip_launcher_pullout;
	level.scr_anim[ "_zipline_gun_kl" ][ "fastzip_putaway" ] = %fastzip_launcher_putaway;
	level.scr_anim[ "_zipline_gun_kl" ][ "fastzip_aim_idle" ] = %fastzip_launcher_aim_level_left;
	level.scr_anim[ "_zipline_gun_kl" ][ "fastzip_fire" ] = %fastzip_launcher_fire_left_npc;
	level.scr_anim[ "_zipline_gun_kl" ][ "fastzip_slide" ] = %fastzip_launcher_slidedown_left_npc;
	level.scr_anim[ "_zipline_gun_kl" ][ "retract_rope" ] = %fastzip_launcher_retract_left;
	
	level.scr_animtree[ "_zipline_gun_kr" ] = #animtree;
	level.scr_model[ "_zipline_gun_kr" ] = "npc_zipline_gun_right";
	level.scr_anim[ "_zipline_gun_kr" ][ "folded_idle" ] = %fastzip_launcher_folded_idle_right;
	level.scr_anim[ "_zipline_gun_kr" ][ "rest_idle" ] = %fastzip_launcher_rest_idle_right;
	level.scr_anim[ "_zipline_gun_kr" ][ "readyup" ] = %fastzip_launcher_readyup_right;
	level.scr_anim[ "_zipline_gun_kr" ][ "jumpout" ] = %fastzip_launcher_jumpout_right;
	level.scr_anim[ "_zipline_gun_kr" ][ "fastzip_pullout" ] = %fastzip_launcher_pullout;
	level.scr_anim[ "_zipline_gun_kr" ][ "fastzip_putaway" ] = %fastzip_launcher_putaway;
	level.scr_anim[ "_zipline_gun_kr" ][ "fastzip_aim_idle" ] = %fastzip_launcher_aim_level_right;
	level.scr_anim[ "_zipline_gun_kr" ][ "fastzip_fire" ] = %fastzip_launcher_fire_right_npc;
	level.scr_anim[ "_zipline_gun_kr" ][ "fastzip_slide" ] = %fastzip_launcher_slidedown_right_npc;
	level.scr_anim[ "_zipline_gun_kr" ][ "retract_rope" ] = %fastzip_launcher_retract_right;
}
	

init_local()
{
	self.script_badplace = false;// All helicopters dont need to create bad places
	
	self ent_flag_init( "left_door_open" );
	self ent_flag_init( "right_door_open" );
	
	// wait until turrets are created
	waittillframeend;
	
	if ( IsSubStr( self.classname, "_no_turret" ) )
	{
		// just add models of turrets for show
		if ( IsSubStr( self.classname, "_stealth" ) )
		{
			self thread spawn_turret_model( "tag_turret_left", "vehicle_xh9_warbird_turret_left_stealth" );
			self thread spawn_turret_model( "tag_turret_right", "vehicle_xh9_warbird_turret_right_stealth" );
		}
		else
		{
			self thread spawn_turret_model( "tag_turret_left", "vehicle_xh9_warbird_turret_left" );
			self thread spawn_turret_model( "tag_turret_right", "vehicle_xh9_warbird_turret_right" );
		}
	}
	
	// make sure proper rotors showing
	self thread handle_rotors();
	
	if ( !IsSubStr( self.classname, "_no_zipline" ) )
	{			
		// use a script model turret to represent turrets to get exact placement in animation.
		//   fastzip will spawn turrets when it needs to use them.
		self thread spawn_script_model_turret( "_zipline_gun_fl", "tag_turret_zipline_fl", "TAG_GUNNER_FL", "npc_zipline_rope_right" );
		self thread spawn_script_model_turret( "_zipline_gun_fr", "tag_turret_zipline_fr", "TAG_GUNNER_FR", "npc_zipline_rope_left" );
		self thread spawn_script_model_turret( "_zipline_gun_kl", "tag_turret_zipline_kl", "TAG_GUNNER_KL", "npc_zipline_rope_left", "npc_optics_zipline_gun" );
		self thread spawn_script_model_turret( "_zipline_gun_kr", "tag_turret_zipline_kr", "TAG_GUNNER_KR", "npc_zipline_rope_right" );
	}
}

spawn_turret_model( turret_tag, model_name )
{
	turret_model = Spawn( "script_model", (0,0,0) );
	turret_model SetModel( model_name );
	turret_model LinkTo( self, turret_tag, (0,0,14), (-8,0,0) );
	
	if ( !IsDefined( self.turret_models ) )
	{
		self.turret_models = [];
	}
	self.turret_models[ turret_tag ] = turret_model;
	
	self waittill( "death" );
	turret_model Delete();
}

show_blurry_rotors()
{
	// always show blurry ones for now until we need a static one in the scene; fix this then
	self.blurry_rotors_on = true;
	self HidePart( "TAG_STATIC_MAIN_ROTOR_L" );
	self HidePart( "TAG_STATIC_MAIN_ROTOR_R" );
	self HidePart( "TAG_STATIC_TAIL_ROTOR" );
	self ShowPart( "TAG_SPIN_MAIN_ROTOR_L" );
	self ShowPart( "TAG_SPIN_MAIN_ROTOR_R" );
	self ShowPart( "TAG_SPIN_TAIL_ROTOR" );
}

#using_animtree( "vehicles" );
handle_rotors()
{
	self endon( "death" );
	self endon( "stop_handle_rotors" );
	
	self show_blurry_rotors();
	
	if ( IsDefined( self.no_anim_rotors ) && self.no_anim_rotors )
		return;
	
	self SetAnim( %warbird_rotors_spin, 1, 0.2, 1 );
	
	current_tilt = 0;
	goal_tilt = 0;
	
	while ( true )
	{
		current_velocity = self Vehicle_GetVelocity();
		forward = AnglesToForward( self.angles );
		forward_dot = VectorDot( current_velocity, forward );
		if ( forward_dot > 0 )
		{
			// moving forward
			goal_tilt = ( forward_dot / 3000 );
			goal_tilt = min( goal_tilt, 1 );
		}
		else if ( forward_dot < 0 )
		{
			goal_tilt = ( forward_dot / 1000 );
			goal_tilt = max( goal_tilt, -1 );
		}
		else
		{
			goal_tilt = 0;
		}
		
		if ( current_tilt < goal_tilt )
		{
			current_tilt = current_tilt + 0.1;
			current_tilt = min( current_tilt, goal_tilt );
		}
		else if ( current_tilt > goal_tilt )
		{
			current_tilt = current_tilt - 0.1;
			current_tilt = max( current_tilt, goal_tilt );
		}
		
		if ( current_tilt > 0 )
		{
			self SetAnimKnob( %warbird_rotors_forward, 1, 0.2, 0 );
			self SetAnimTime( %warbird_rotors_forward, current_tilt );
			self SetAnim( %rotors_tilt, 1, 0.2, 1 );
		}
		else if ( current_tilt < 0 )
		{
			self SetAnimKnob( %warbird_rotors_backward, 1, 0.2, 0 );
			self SetAnimTime( %warbird_rotors_backward, current_tilt * -1 );
			self SetAnim( %rotors_tilt, 1, 0.2, 1 );
		}
		else
		{
			self ClearAnim( %rotors_tilt, 0.2 );
		}
		
		wait 0.1;
	}
}

open_doors_for_unload( gunner_tag )
{
	aim_angles = self GetTagAngles( gunner_tag );
	aim_dir = AnglesToForward( aim_angles );
	
	// make sure doors are open, and open them if they are not
	vehicle_right = AnglesToRight( self.angles );
	right_dot = VectorDot( vehicle_right, aim_dir );
	if ( right_dot > 0 )
	{
		// make sure right door is open
		if ( !self ent_flag( "right_door_open" ) )
		{
			self thread open_right_door();
		}
	}
	else
	{
		// make sure left door is open
		if ( !self ent_flag( "left_door_open" ) )
		{
			self thread open_left_door();
		}
	}
}

open_right_door()
{
	if ( !IsDefined( self.right_door_anim ) || self.right_door_anim != "opening" )
	{
		self.right_door_anim = "opening";
		
		self SetAnim( %warbird_doors, 1, 0.2, 1 );
		self SetAnim( %warbird_door_r_open, 1, 0.2, 1 );
		
		open_time = GetAnimLength( %warbird_door_r_open );
		wait open_time;
		self ent_flag_set( "right_door_open" );
	}
}

open_left_door()
{
	if ( !IsDefined( self.left_door_anim ) || self.left_door_anim != "opening" )
	{
		self.left_door_anim = "opening";
		
		self SetAnim( %warbird_doors, 1, 0.2, 1 );
		self SetAnim( %warbird_door_l_open, 1, 0.2, 1 );
		
		open_time = GetAnimLength( %warbird_door_l_open );
		wait open_time;
		self ent_flag_set( "left_door_open" );
	}
}

copy_animation_to_model( model_ent )
{
	if ( !IsDefined( model_ent ) )
		return;
	
	model_ent CopyAnimTreeState( self );
}


copy_animation_to_cloak_models()
{
	copy_animation_to_model( self.cloaked_model );
	copy_animation_to_model( self.decloaking_model );
}

handle_cloak_models_animation()
{
	self endon( "death" );
	self endon( "stop_cloaked_models_animation" );
	
	while ( true )
	{
		copy_animation_to_cloak_models();
		wait 0.05;
	}
}
	
spawn_script_model_turret( anim_name, turret_tag, gunner_tag, attach_rope, attachment )
{
	zipline_gun_model = spawn_anim_model( anim_name );
	
	if ( IsDefined( attach_rope ) )
	{
		zipline_gun_model Attach( attach_rope );
		zipline_gun_model.rope_model = attach_rope;
	}
	
	if ( IsDefined( attachment ) )
	{
		attachment_model = Spawn( "script_model", (0,0,0) );
		attachment_model SetModel( "npc_optics_zipline_gun" );
		attachment_model LinkTo( zipline_gun_model, "TAG_DE_TECH", (0,0,0), (0,0,0) );
		zipline_gun_model.attachment = attachment_model;
	}
	
	zipline_gun_model LinkTo( self, turret_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	zipline_gun_model SetAnim( level.scr_anim[ anim_name ][ "folded_idle" ], 1, 0, 1 );
	
	if ( !IsDefined( self.zipline_gun_model ) )
	{
		self.zipline_gun_model = [];
	}
	self.zipline_gun_model[ turret_tag ] = zipline_gun_model;
	self.zipline_gunner_tag[ turret_tag ] = gunner_tag;
	
	self waittill( "death" );
	zipline_gun_model Delete();
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0; i < 6; i++ )
		positions[ i ] = SpawnStruct();
	
	// pilot
	positions[ 0 ].idle = %helicopter_pilot1_idle;
	
	// passengers
	positions[ 1 ].idle = %helicopter_pilot1_idle;
	positions[ 2 ].idle = %helicopter_pilot1_idle;
	positions[ 3 ].idle = %helicopter_pilot1_idle;
	positions[ 4 ].idle = %helicopter_pilot1_idle;
	
	// co-pilot
	positions[ 5 ].idle = %helicopter_pilot1_idle;
	
	positions[0].sittag = "TAG_DRIVER";
	positions[1].sittag = "TAG_GUY0"; //left
	positions[2].sittag = "TAG_GUY2"; //left
	positions[3].sittag = "TAG_GUY3"; //right
	positions[4].sittag = "TAG_GUY5"; //right
	positions[5].sittag = "TAG_PASSENGER";
	
	positions[ 1 ].getout = true;
	positions[ 1 ].bNoanimUnload = true;
	
	positions[ 2 ].getout = true;
	positions[ 2 ].bNoanimUnload = true;
	
	positions[ 3 ].getout = true;
	positions[ 3 ].bNoanimUnload = true;
	
	positions[ 4 ].getout = true;
	positions[ 4 ].bNoanimUnload = true;
	
	positions[ 1 ].rider_func = ::setup_fastzip_unload;
	positions[ 2 ].rider_func = ::setup_fastzip_unload;
	positions[ 3 ].rider_func = ::setup_fastzip_unload;
	positions[ 4 ].rider_func = ::setup_fastzip_unload;
	
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "default" ] = [];
	
	unload_groups[ "default" ][ unload_groups[ "default" ].size ] = 1;
	unload_groups[ "default" ][ unload_groups[ "default" ].size ] = 2;
	unload_groups[ "default" ][ unload_groups[ "default" ].size ] = 3;
	unload_groups[ "default" ][ unload_groups[ "default" ].size ] = 4;

	return unload_groups;
}

#using_animtree( "vehicles" );
show_attached_clone_model( model_ent, model_name )
{
	if ( !IsDefined( model_ent ) )
	{
		model_ent = Spawn( "script_model", self GetOrigin() );
		model_ent SetModel( model_name );
		model_ent UseAnimTree( #animtree );
	}
	
	model_ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	copy_animation_to_cloak_models();
	model_ent Show();
	
	return model_ent;
}

show_cloaked_warbird()
{
	self.cloaked_model = show_attached_clone_model( self.cloaked_model, "vehicle_xh9_warbird_cloaked_transparent" );
}

show_decloaking_warbird()
{
	self.decloaking_model = show_attached_clone_model( self.decloaking_model, "vehicle_xh9_warbird_decloaking_masked" );
}

cloak_warbird()
{	
	if( is_using_model_memory_sharing() )
	{
		self Hide();
		show_cloaked_warbird();
		self thread handle_cloak_models_animation();
	}
	else
	{
		self.uncloak_model = self.model;
		self SetModel( "vehicle_xh9_warbird_cloaked_in_out" );
	}
	
	// make sure you're showing the correct rotors
	if ( IsDefined( self.blurry_rotors_on ) && self.blurry_rotors_on )
	{
		self show_blurry_rotors();
	}
	
	waittillframeend;
	waittillframeend;
	self set_cloak_parameter( 0.0, 0.0 );

	// hide zipline guns
	if ( IsDefined( self.zipline_gun_model ) )
	{
		foreach ( zipline_gun in self.zipline_gun_model )
		{
			zipline_gun Hide();
		}
	}
	
	if ( IsDefined( self.turret_models ) )
	{
		foreach ( turret_model in self.turret_models )
		{
			turret_model Hide();
		}
	}
	
	if ( IsDefined( self.mgturret ) )
	{
		foreach ( mgturret in self.mgturret )
		{
			mgturret Hide();
		}
	}
}

set_cloak_parameter( targetValue, lerpTime )
{
	if ( IsDefined( self.uncloak_model ) )
		self SetMaterialScriptParam( targetValue, lerpTime );
	
	if ( IsDefined( self.cloaked_model ) )
		self.cloaked_model SetMaterialScriptParam( targetValue, lerpTime );
	
	if ( IsDefined( self.decloaking_model ) )
		self.decloaking_model SetMaterialScriptParam( targetValue, lerpTime );
}

setmodel_warbird( waittime )
{
	wait( waittime );
	
	if ( is_using_model_memory_sharing() )
	{
		self Show();
		
		if ( IsDefined( self.cloaked_model ) )
			self.cloaked_model Hide();
		if ( IsDefined( self.decloaking_model ) )
			self.decloaking_model Hide();
	
		self notify( "stop_cloaked_models_animation" );
	}
	else if ( IsDefined( self.uncloak_model ) )
		self SetModel( self.uncloak_model );
	
	maps\_vehicle::vehicle_lights_on( "running" );
	self show_blurry_rotors();
}

uncloak_warbird( transition_time )
{
	curr_waittime = 8.3;
	if( IsDefined( transition_time ) ) curr_waittime = transition_time;
	
	if ( is_using_model_memory_sharing() )
	{
		show_decloaking_warbird();
		self thread setmodel_warbird( curr_waittime );
	}
	else if ( IsDefined( self.uncloak_model ) )
		self thread setmodel_warbird( curr_waittime );
	
	set_cloak_parameter( 1.0, curr_waittime );
	
	wait( curr_waittime );
	if ( IsDefined( self.blurry_rotors_on ) && self.blurry_rotors_on )
	{
		self show_blurry_rotors();
	}
	
	if ( IsDefined( self.zipline_gun_model ) )
	{
		foreach ( zipline_gun in self.zipline_gun_model )
		{
			zipline_gun Show();
		}
	}
	
	if ( IsDefined( self.turret_models ) )
	{
		foreach ( turret_model in self.turret_models )
		{
			turret_model Show();
		}
	}
	
	if ( IsDefined( self.mgturret ) )
	{
		foreach ( mgturret in self.mgturret )
		{
			mgturret Show();
		}
	}
}


/*****************************************************/
// rider functions

setup_fastzip_unload()
{
	self.customUnloadFunc = ::fastzip_unload;
	
	self.ridingvehicle thread guy_idle( self, self.vehicle_position );
	self thread guy_death_inside_warbird();
}

#using_animtree( "generic_human" );
setup_fastzip_anims( turret_tag )
{
	if ( turret_tag == "tag_turret_zipline_fl" || turret_tag == "tag_turret_zipline_kr" )
	{
		animname = "zipline_guy_right";
		self.zipline_animname = animname;
		level.scr_anim[ animname ][ "rest_idle" ] = %zipline_right_rest;
		level.scr_anim[ animname ][ "readyup" ] = %zipline_right_readyup;
		level.scr_anim[ animname ][ "jumpout" ] = %zipline_right_jumpedout;
		level.scr_anim[ animname ][ "fire" ] = %zipline_right_fire;
		level.scr_anim[ animname ][ "slide_idle_a" ][0] = %zipline_right_slidedown_guy_a;
		level.scr_anim[ animname ][ "slide_idle_b" ][0] = %zipline_right_slidedown_guy_b;
		level.scr_anim[ animname ][ "zipline_right_land_guy_a" ] = %zipline_right_land_guy_a;
		level.scr_anim[ animname ][ "zipline_right_land_guy_b" ] = %zipline_right_land_guy_b;
	}
	else
	{
		animname = "zipline_guy_left";
		self.zipline_animname = animname;
		level.scr_anim[ animname ][ "rest_idle" ] = %zipline_left_rest;
		level.scr_anim[ animname ][ "readyup" ] = %zipline_left_readyup;
		level.scr_anim[ animname ][ "jumpout" ] = %zipline_left_jumpedout;
		level.scr_anim[ animname ][ "fire" ] = %zipline_left_fire;
		level.scr_anim[ animname ][ "slide_idle_a" ][0] = %zipline_left_slidedown_guy_a;
		level.scr_anim[ animname ][ "slide_idle_b" ][0] = %zipline_left_slidedown_guy_b;
		level.scr_anim[ animname ][ "zipline_left_landing_guy_a" ] = %zipline_left_landing_guy_a;
		level.scr_anim[ animname ][ "zipline_left_landing_guy_b" ] = %zipline_left_landing_guy_b;
	}
}

fastzip_unload( vehicle, pos )
{
	// get vehicle rider is on
	Assert( vehicle == self.ridingvehicle );
	
	// get closest turret to rider
	turret_tag = undefined;
	closest_distance = undefined;
	foreach ( i, turret in vehicle.zipline_gun_model )
	{
		dist = Distance2D( turret.origin, self.origin );
		if ( !IsDefined( closest_distance ) || dist < closest_distance )
		{
			if ( !IsDefined( turret.turret ) )
			{
				closest_distance = dist;
				turret_tag = i;
			}
		}
	}
	
	if ( !IsDefined( turret_tag ) )
	{
		println( "^1Warning: Could not find zipline turret to use for unload." );
		return false;
	}
	
	self setup_fastzip_anims( turret_tag );
	
	gunner_tag = vehicle.zipline_gunner_tag[ turret_tag ];
	
	if ( !IsDefined( gunner_tag ) )
	{
		PrintLn( "^1Warning: Could not find zipline turret gunner tag for turret: " + turret_tag );
		return false;
	}
	
	// get unload target
	closest_node = find_unload_node( vehicle, gunner_tag );
	if ( !IsDefined( closest_node ) )
	{
		println( "^1Warning: AI at " + gunner_tag + " could not find valid location to fastzip unload." );
		return false;
	}
	
	// get the actual turret target point from the unload node
	target_pos = calculate_rope_target( vehicle, turret_tag, closest_node );
	if ( !validate_target_pos( vehicle, gunner_tag, target_pos ) )
		return false;
	
	////// all checks pass, past this point, guy will unload //////
	zipline_model = vehicle.zipline_gun_model[ turret_tag ];
	Assert( !IsDefined( zipline_model.turret ) );
	
	zipline_turret = setup_zipline_gun( "zipline_gun", vehicle, turret_tag, zipline_model.model, zipline_model.rope_model, zipline_model.animname );
	zipline_turret_rope = setup_zipline_gun( "zipline_gun_rope", vehicle, turret_tag, zipline_model.rope_model, undefined, zipline_model.animname );
	zipline_model.turret = zipline_turret;
	
	goal_pos = spawn_tag_origin();
	goal_pos.origin = target_pos;
	zipline_turret thread delete_on_death( goal_pos );
	
	// for aim testing
	//goal_pos.origin = zipline_turret GetTagOrigin( "tag_aim" ) + ( AnglesToForward( zipline_turret GetTagAngles( "tag_aim" ) ) * 100 );
	//zipline_turret thread aim_test( goal_pos, vehicle, gunner_tag );
	
	self.allowdeath = true;
	
	// set up guy and turret to get ready to use
	self get_ready_to_use_turret( vehicle, zipline_model, gunner_tag );
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		return true;
	}
	
	// AI using turret
	zipline_model Hide();
	zipline_turret Show();
	
	zipline_turret SetTurretIgnoreGoals( true );
	self UseTurret( zipline_turret );
	
	zipline_turret SetTargetEntity( goal_pos );
	zipline_turret_rope SetTargetEntity( goal_pos );

	//zipline_turret waittill( "aim_test_done" );
	
	// wait to be on target
	zipline_turret waittill( "turret_on_target" );
	
	// if guy was killed, just bail
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		return true;
	}
	
	// start to zipline down
	self StopUseTurret();
	
	// fire turret
	self LinkTo( vehicle, gunner_tag );
	vehicle thread anim_single_solo( self, "fire", gunner_tag, undefined, self.zipline_animname );
	rope_distance = zipline_turret_rope fire_rope( zipline_turret, goal_pos.origin, zipline_model );
	
	// jump out
	zipline_model Show();
	zipline_turret Hide();
	
	// if guy was killed, just bail
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		return true;
	}
	
	self play_jump_out_anim( vehicle, zipline_model, gunner_tag );
	self notify( "fastzip_jumped_out" );
	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		// choose slide/land anims
		AssertEx( IsDefined( closest_node.animation ), "No land animation specified for fast zip" );

		land_anim = closest_node.animation;
		
		// map different slide anims to go with the land anim
		slide_anims = [];
		slide_anims[ "zipline_right_land_guy_a" ] = "slide_idle_a";
		slide_anims[ "zipline_right_land_guy_b" ] = "slide_idle_b";
		
		slide_anims[ "zipline_left_landing_guy_a" ] = "slide_idle_a";
		slide_anims[ "zipline_left_landing_guy_b" ] = "slide_idle_b";
		
		// find the slide anim that goes with the land
		slide_anim = slide_anims[ land_anim ];
		if ( !IsDefined( slide_anim ) )
			slide_anim = "slide_idle_a";

		self fastzip_slide( zipline_turret_rope, slide_anim );
		
		// not really necessary, but we probably shouldn't be checking for the ground right after we zip out
		wait 0.1;
		self fastzip_land( zipline_turret_rope, closest_node.origin, land_anim );
	
		wait 1;
	
		zipline_turret_rope retract_rope( rope_distance );
	}

	goal_pos Delete();
	
	zipline_turret Delete();
	zipline_turret_rope Delete();
	zipline_model.turret = undefined;
	
	return true;
}

get_ready_to_use_turret( vehicle, zipline_model, gunner_tag )
{
	self endon( "death" );
	
	self thread play_rest_anim( vehicle, zipline_model, gunner_tag );
	
	wait 0.05;

	// open warbird doors
	vehicle thread open_doors_for_unload( gunner_tag );
	
	// play ready up as doors open
	self play_ready_up_anim( vehicle, zipline_model, gunner_tag );
}	

find_unload_node( vehicle, gunner_tag )
{	
	closest_node = undefined;
	closest_side_dot = undefined;
	
	left_side = true;
	if ( gunner_tag == "TAG_GUNNER_FL" || gunner_tag == "TAG_GUNNER_KR" )
	{
		left_side = false;
	}
	
	aim_pos = vehicle GetTagOrigin( gunner_tag );
	aim_angles = vehicle GetTagAngles( gunner_tag );
	aim_dir = AnglesToForward( aim_angles );
	aim_right = AnglesToRight( aim_angles );
	
	unload_nodes = getstructarray( vehicle.currentnode.target, "targetname" );
	foreach ( unload_node in unload_nodes )
	{
		if ( !IsDefined( unload_node.script_unloadtype ) )
			continue;
		
		to_node = unload_node.origin - aim_pos;
		to_node_dir = VectorNormalize( to_node );
		to_node_xy = ( to_node[0], to_node[1], 0 );
		to_node_xy_dir = VectorNormalize( to_node_xy );
		
		forward_dot = VectorDot( aim_dir, to_node_dir );
		if ( forward_dot < 0 )
			continue;
		
		right_dot = VectorDot( aim_right, to_node_xy_dir );
		if ( !left_side && ( !IsDefined( closest_side_dot ) || right_dot > closest_side_dot ) )
		{
			closest_node = unload_node;
			closest_side_dot = right_dot;
		}
		else if ( left_side && ( !IsDefined( closest_side_dot ) || right_dot < closest_side_dot ) )
		{
			closest_node = unload_node;
			closest_side_dot = right_dot;
		}
	}
	
	if ( !IsDefined( closest_node ) )
	{
		println( "^1Warning: No valid unload node defined." );
		return undefined;
	}
	
	return closest_node;
}

calculate_rope_target( vehicle, turret_tag, land_node )
{
	// calculate approximate angles that the rope will be in
	turret_tag_pos = vehicle GetTagOrigin( turret_tag );
	tag_to_land = land_node.origin - turret_tag_pos;
	rope_angles = VectorToAngles( tag_to_land );
	
	// spawn dummy model to calculate where rope should go from the land node
	zipline_model = vehicle.zipline_gun_model[ turret_tag ];
	dummy_rope = Spawn( "script_model", land_node.origin );
	dummy_rope.animname = zipline_model.animname;
	dummy_rope.angles = rope_angles;
	dummy_rope assign_animtree();
	dummy_rope SetModel( zipline_model.rope_model );
	dummy_rope Hide();
	
	pose_anim = dummy_rope getanim( "fastzip_fire" );
	dummy_rope SetAnimKnob( pose_anim, 1, 0, 0 );
	
	// adjust dummy rope so that the ai's origin will be on the land node
	[ guy_origin, guy_angles ] = dummy_rope get_ai_fastzip_pos();
	to_land_node = land_node.origin - guy_origin;
	dummy_rope.origin = dummy_rope.origin + to_land_node;
	
	// need to wait a frame for the entity to update its pos
	wait 0.05;
	
	// get turret aim position
	target_pos = dummy_rope GetTagOrigin( "jnt_shuttleRoot" );
	
	dummy_rope Delete();
	
	return target_pos;
}

validate_target_pos( vehicle, gunner_tag, target_pos )
{
	aim_pos = vehicle GetTagOrigin( gunner_tag );
	aim_angles = vehicle GetTagAngles( gunner_tag );
	aim_dir = AnglesToForward( aim_angles );
	
	// picked a best node, make sure it meets all the requirements
	aim_down = AnglesToUp( aim_angles ) * -1;
	
	to_node = target_pos - aim_pos;
	to_node_dir = VectorNormalize( to_node );
	down_dot = VectorDot( to_node_dir, aim_down );
	if ( down_dot > cos(90 - DOWN_ANGLE_LIMIT) )
	{
		// closest node too steep
		println( "^1Warning: Node at " + target_pos + " too steep (" + (90 - acos(down_dot)) + ", limit " + DOWN_ANGLE_LIMIT + ")." );
		//AssertMsg( "^1Warning: Node at " + closest_node.origin + " too steep (" + (90 - acos(down_dot)) + ", limit " + DOWN_ANGLE_LIMIT + ")." );
		return undefined;
	}
	
	to_node_xy = ( to_node[0], to_node[1], 0 );
	to_node_xy_dir = VectorNormalize( to_node_xy );
	aim_dot = VectorDot( to_node_xy_dir, aim_dir );
	if ( aim_dot < cos(SIDE_ANGLE_LIMIT) )
	{
		println( "^1Warning: Node at " + target_pos + " outside cone (" + acos(aim_dot) + ", limit " + SIDE_ANGLE_LIMIT + ")." );
		//AssertMsg( "^1Warning: Node at " + closest_node.origin + " outside cone (" + acos(aim_dot) + ", limit " + SIDE_ANGLE_LIMIT + ")." );
		return undefined;
	}
	
	node_distance = Length( to_node );
	if ( node_distance > ( FASTZIP_ROPE_LENGTH * 12 ) )
	{
		// node too far
		println( "^1Warning: Node at " + target_pos + " too far (" + node_distance + ", limit " + (FASTZIP_ROPE_LENGTH * 12) + ")." );
		//AssertMsg( "^1Warning: Node at " + closest_node.origin + " too far (" + node_distance + ", limit " + (FASTZIP_ROPE_LENGTH * 12) + ")." );
		return undefined;
	}
	
	return true;
}

play_rest_anim( vehicle, zipline_model, gunner_tag )
{
	self notify( "newanim" );
	self anim_stopanimscripted();
	self Unlink();
	
	zipline_model clear_script_model_anim( 0 );
	zipline_model SetAnim( zipline_model getanim( "rest_idle" ), 1, 0, 0 );
	
	vehicle anim_first_frame_solo( self, "rest_idle", gunner_tag, self.zipline_animname );
	
	self LinkTo( vehicle, gunner_tag );
}

play_ready_up_anim( vehicle, zipline_model, gunner_tag )
{
	self endon( "death" );
	vehicle endon( "death" );
	
	// wait a random amount so they are not all synchronized
	wait RandomFloatRange( 0, 0.25 );
	
	vehicle thread anim_single_solo( zipline_model, "readyup", gunner_tag );
	vehicle anim_single_solo( self, "readyup", gunner_tag, undefined, self.zipline_animname );
}

play_jump_out_anim( vehicle, zipline_model, gunner_tag )
{
	self endon( "death" );
	
	guys = [self, zipline_model];
	
	vehicle thread anim_single_solo( zipline_model, "jumpout", gunner_tag );
	vehicle anim_single_solo( self, "jumpout", gunner_tag, undefined, self.zipline_animname );
}
	
aim_test( goal_pos, vehicle, gunner_tag )
{
	aim_pos = self GetTagOrigin( "tag_aim" );
	aim_angles = self GetTagAngles( "tag_aim" );
	
	aim_angles = ( AngleClamp180( aim_angles[0] ), AngleClamp180( aim_angles[1] ), AngleClamp180( aim_angles[2] ) );
	
	goal_pos.origin = aim_pos + ( AnglesToForward( aim_angles ) * 100 );

	// move up 5 degrees
	while ( aim_angles[0] > -5 )
	{
		aim_pos = self GetTagOrigin( "tag_aim" );
		aim_angles = aim_angles - (0.1, 0, 0);
		goal_pos.origin = aim_pos + ( AnglesToForward( aim_angles ) * 100 );
		
		/#
			maps\_shg_debug::draw_point( goal_pos.origin, 10, (0,0,1) );
		#/
		wait 0.05;
	}
	
	wait 2;
	
	while ( aim_angles[0] < 60 )
	{
		aim_pos = self GetTagOrigin( "tag_aim" );
		tag_angles = self GetTagAngles( "tag_aim" );
		
		tag_weapon_pos = self GetTagOrigin( "tag_weapon" );
		tag_weapon_angles = self GetTagAngles( "tag_weapon" );
		
		weapon_pos = self GetTagOrigin( "tag_flash" );
		weapon_angles = self GetTagAngles( "tag_flash" );
		
		gunner_pos = vehicle GetTagOrigin( gunner_tag );
		gunner_angles = vehicle GetTagAngles( gunner_tag );
		
		aim_angles = aim_angles + (0.3, 0, 0);
		goal_pos.origin = aim_pos + ( AnglesToForward( aim_angles ) * 100 );
		
		/#
			maps\_shg_debug::draw_point( goal_pos.origin, 10, (0,0,1) );
			maps\_shg_debug::draw_axis( aim_pos, tag_angles );
			maps\_shg_debug::draw_axis( tag_weapon_pos, tag_weapon_angles );
			
			maps\_shg_debug::draw_axis( weapon_pos, weapon_angles );
			
			maps\_shg_debug::draw_axis( gunner_pos, gunner_angles );
		#/
			
			
		wait 0.05;
	}
	
	wait 1;
	
	while ( aim_angles[0] > 0 )
	{
		aim_pos = self GetTagOrigin( "tag_aim" );
		
		aim_angles = aim_angles - (0.3, 0, 0);
		goal_pos.origin = aim_pos + ( AnglesToForward( aim_angles ) * 100 );
		
		/#
			maps\_shg_debug::draw_point( goal_pos.origin, 10, (0,0,1) );
		#/
		wait 0.05;
	}
	
	self notify( "aim_test_done" );
}

/*
#using_animtree( "generic_human" );
custom_wait()
{
	self endon( "death" );
	self notify( "killanimscript" );
	self.pushable = 0;

	self OrientMode( "face angle", self.angles[ 1 ] );

	self setanim( %zipline_left_aim_center, 1, 0, 0 );

	self waittill( "killanimscript" );
}

position_on_turret( vehicle, zipline_turret )
{
	self endon( "newanim" );
	
	self ClearAnim( %body, 0 );
	
	array = zipline_turret get_anim_position( "tag_weapon" );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	/#
		thread maps\_shg_debug::draw_axis( org, angles, 5 );
	#/

	neworg = GetStartOrigin( org, angles, %zipline_left_aim_center );
	newangles = GetStartAngles( org, angles, %zipline_left_aim_center );

	/#
		thread maps\_shg_debug::draw_axis( neworg, newangles, 5 );
	#/
	
	position = spawn_tag_origin();
	position.origin = neworg;
	position.angles = newangles;
	
	position LinkTo( vehicle );
	
	self ForceTeleport( neworg, newangles );
	self LinkTo( position, "tag_origin", (0,0,0), (0,0,0) );
	
	level.debug_draw_position = position;
}
*/


/************************* FAST ZIP TURRET ************************/
#using_animtree( "script_model" );
spawn_zipline_turret( turret_asset, turret_tag, turret_model, animname )
{
	turret = SpawnTurret( "misc_turret", ( 0, 0, 0 ), turret_asset );
	turret LinkTo( self, turret_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	turret SetModel( turret_model );
	turret.angles = self.angles;
	
	Assert( IsDefined( self.script_team ) );
	turret.script_team = self.script_team;// lets mgturret know not to mess with this turret
	maps\_vehicle_code::set_turret_team( turret );
	
	//default drop pitch defaultdroppitch, defaultdropyaw
	turret SetDefaultDropPitch( 0 );
	turret SetMode( "manual" );
	
	turret MakeUnusable();
	turret UseAnimTree( #animtree );
	turret.animname = animname;

	return turret;
}

setup_zipline_gun( turret_asset, heli, turret_tag, turret_model, attach_model, animname )
{
	heli_turret = heli spawn_zipline_turret( turret_asset, turret_tag, turret_model, animname );
	if ( IsDefined( attach_model ) )
	{
		heli_turret Attach( attach_model );
	}
	heli_turret Hide();
	heli_turret SetDefaultDropPitch( 0 );
	
	// set idle animation
	heli_turret anim_stopanimscripted();
	heli_turret clear_script_model_anim( 0 );
	heli_turret SetAnim( heli_turret getanim( "fastzip_aim_idle" ), 1, 0, 0 );
	
	heli thread delete_on_death( heli_turret );
	
	return heli_turret;
}

clear_script_model_anim( fade_time )
{
	self ClearAnim( %root, fade_time );
}

fire_rope( heli_turret, aim_pos, zipline_gun_model )
{
	fire_speed = 210;				// feet/sec
	
	fire_rate = fire_speed / 30;	// playback speed
	
	heli_turret Detach( zipline_gun_model.rope_model );
	zipline_gun_model Detach( zipline_gun_model.rope_model );

	self Show();
	
	barrel_pos = heli_turret GetTagOrigin( "tag_barrel" );
	aim_dir = aim_pos - barrel_pos;
	aim_dir = VectorNormalize( aim_dir );
	ground_pos = aim_pos + ( aim_dir * ( FASTZIP_ROPE_LENGTH * 12 ) );
	trace = BulletTrace( aim_pos, ground_pos, false );
	if ( trace[ "fraction" ] < 1 )
	{
		ground_pos = trace[ "position" ];
	}
	
	dist = Distance( barrel_pos, ground_pos ) / 12; //units to feet... ish
	AssertEx( dist <= FASTZIP_ROPE_LENGTH, "distance is longer than the rope" );
	percent_of_anim = dist / FASTZIP_ROPE_LENGTH;
	
	//play fx
	//playfxontag(getfx("harpoon_dust"), self, "jnt_harpoon");
	//playfxontag(getfx("zipline_flash_view"), self, "TAG_FLASH");
	
	self thread sndxt_fastzip_fire( ground_pos );

	rope_anim = self getanim( "fastzip_fire" );
	time_of_anim = GetAnimLength( rope_anim );
	time_to_interrupt = ( time_of_anim / fire_rate ) * percent_of_anim;
	self SetAnimKnob( rope_anim, 1, 0.2, fire_rate );
	heli_turret SetAnimKnob( rope_anim, 1, 0.2, 1 );
	
	time_to_interrupt = time_to_interrupt - 0.05;
	if ( time_to_interrupt > 0.05 )
	{
		wait( time_to_interrupt );
	}
		
	self SetAnim( rope_anim, 1, 0, 0 );
	self SetAnimTime( rope_anim, percent_of_anim );
	
	return dist;
}

sndxt_fastzip_fire( ground_pos )
{
	turret = self;
	rand_wait_time = randomfloatrange( 0.1, 0.2 );
	
	wait( rand_wait_time );
	turret snd_play( "tac_fastzip_fire" );
	wait( rand_wait_time );
	play_sound_in_space( "tac_fastzip_proj_impact", ground_pos );
}

fastzip_slide( heli_turret_rope, slide_anim_name )
{
	// animated slide down
	slide_anim = heli_turret_rope getanim( "fastzip_slide" );
	heli_turret_rope SetAnimLimited( %add_slide, 1, 0, 0 );
	heli_turret_rope SetAnimLimited( slide_anim, 1, 0, 0 );
	
	self thread anim_loop_solo( self, slide_anim_name, "stop_loop", undefined, self.zipline_animname );
	
	// lerp ai to position
	[ ai_origin, ai_angles ] = heli_turret_rope get_ai_fastzip_pos();
	
	mover = spawn_tag_origin();
	mover.origin = self.origin;
	mover.angles = self.angles;
	self LinkTo( mover, "tag_origin", (0,0,0), (0,0,0) );
	
	mover MoveTo( ai_origin, 0.2, 0.1, 0 );
	mover RotateTo( ai_angles, 0.2, 0.1, 0 );
	mover waittill( "movedone" );
	
	self ForceTeleport( ai_origin, ai_angles );
	self LinkTo( heli_turret_rope, "jnt_shuttleRoot", (0,0,0), (0,0,0) );
	mover Delete();
	
	// animated slide down
	heli_turret_rope SetAnimLimited( %add_slide, 1, 0, SLIDE_RATE_SCALE );
	heli_turret_rope SetAnimLimited( slide_anim, 1, 0, SLIDE_RATE_SCALE );
	
	//snd_message( "fastzip_rappel" );
}

fastzip_land( heli_turret_rope, land_pos, land_anim_name )
{
	frame_velocity = (0,0,0);
	trace = [];
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		start_position = self.origin;
		previous_position = self.origin;
		
		total_distance = Distance( self.origin, land_pos );
		
		while ( true )
		{
			wait 0.05;
			
			[ current_position, current_angles ] = heli_turret_rope get_ai_fastzip_pos();
			
			frame_distance = Distance( previous_position, current_position );
			distance_left = Distance( current_position, land_pos );
			distance_traveled = Distance( current_position, start_position );
			
			// distance to ideal point is less than the time it moved last frame
			if ( distance_left < ( frame_distance * 4 ) )
				break;
			
			// check that you might have passed the end position somehow
			if ( total_distance < ( distance_traveled + frame_distance ) )
				break;
			
			previous_position = current_position;
		}
		
		if ( IsDefined( self ) )
		{
			mover = spawn_tag_origin();
			mover.origin = self.origin;
			mover.angles = self.angles;
			self LinkTo( mover, "tag_origin", (0,0,0), (0,0,0) );
			
			land_angles = ( 0, self.angles[1], 0 );
			mover MoveTo( land_pos, 0.2, 0.1, 0 );
			mover RotateTo( land_angles, 0.2, 0.1, 0 );
			mover waittill( "movedone" );

			if ( IsAlive( self ) )
			{
				self Unlink();
				self notify( "stop_loop" );

				self ForceTeleport( land_pos, land_angles );
				self thread anim_single_solo( self, land_anim_name, undefined, undefined, self.zipline_animname );
			}
			
			mover Delete();
		}
	}
	
	slide_anim = heli_turret_rope getanim( "fastzip_slide" );
	heli_turret_rope SetAnimLimited( slide_anim, 1, 0, 0 );
	
	if ( IsDefined( self ) && IsAlive( self ) )
	{
		self endon( "death" );
		self waittill( land_anim_name );
		
		// set up AI
        // if he doesn't target a node make his new goal position his current position
        if ( guy_resets_goalpos( self ) )
        {
            self SetGoalPos( self.origin );
        }
	}
}

retract_rope( rope_distance )
{
	rope_ratio = rope_distance / FASTZIP_ROPE_LENGTH;
	rope_ratio = 1 - min( rope_ratio, 1 );
	
	anim_frame_length = 30;
	anim_rate = 1;
	
	rope_anim = self getanim( "retract_rope" );
	
	self SetAnimKnob( rope_anim, 1, 0.2, anim_rate );
	self SetAnimTime( rope_anim, rope_ratio );
	
	play_time = ( anim_frame_length * (1 - rope_ratio) ) / ( 30 * anim_rate );
	wait play_time + 0.05;
}

// get where the ai is on the turret rope
get_ai_fastzip_pos()
{
	current_position = self GetTagOrigin( "jnt_shuttleRoot" );
	current_angles = self GetTagAngles( "jnt_shuttleRoot" );
	
	clamp_pitch = AngleClamp180( current_angles[0] );
	clamp_pitch = clamp( clamp_pitch, -20, 20 );
	clamp_angles = ( clamp_pitch, current_angles[1], current_angles[2] );
	
	current_up = AnglesToUp( clamp_angles );
	current_position = current_position + ( current_up * -70 );
	
	return [ current_position, clamp_angles ];
}

// handle death if dying in warbird
guy_death_inside_warbird()
{
	self endon( "fastzip_jumped_out" );
	
	warbird = self.ridingvehicle;
	
	self thread kill_on_fastzip_jump();
	
	self.noragdoll = true;
	self waittill( "death" );
	
	if ( IsDefined( warbird ) )
	{
		self LinkTo( warbird );
		warbird waittill( "death" );
		if ( IsDefined( self ) )
		{
			self Delete();
		}
	}
}

kill_on_fastzip_jump()
{
	self endon( "death" );
	self waittill( "fastzip_jumped_out" );
	
	self.noragdoll = false;
}

// fast zip nodes, used to figure out where the AI should land (and visualize in Radiant)

/*QUAKED script_struct_unload_fastzip_fl_a (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Front left guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_right_land_guy_a"
*/

/*QUAKED script_struct_unload_fastzip_fl_b (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Front left guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_right_land_guy_b"
*/

/*QUAKED script_struct_unload_fastzip_fr_a (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Front right guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_left_landing_guy_a"
*/

/*QUAKED script_struct_unload_fastzip_fr_b (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Front right guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_left_landing_guy_b"
*/

/*QUAKED script_struct_unload_fastzip_br_a (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Back right guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_right_land_guy_a"
*/

/*QUAKED script_struct_unload_fastzip_br_b (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Back right guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_right_land_guy_b"
*/

/*QUAKED script_struct_unload_fastzip_bl_a (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Back left guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_left_landing_guy_a"
*/

/*QUAKED script_struct_unload_fastzip_bl_b (1.0 0.0 0.0) (-8 -8 -8) (8 8 8) ?
Node to be used to specify location of fastzip guys from a supported vehicle. Back left guy.

default:"script_unloadtype" "fastzip"
default:"model" "body_complete_sp_vip"
default:"animation" "zipline_left_landing_guy_b"
*/

/*QUAKED script_vehicle_xh9_warbird (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird", undefined, "script_vehicle_xh9_warbird" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_xh9_warbird_no_turret (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird", undefined, "script_vehicle_xh9_warbird_no_turret" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_xh9_warbird_stealth (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_stealth", undefined, "script_vehicle_xh9_warbird_stealth" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird_stealth"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_xh9_warbird_stealth_no_turret (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_stealth", undefined, "script_vehicle_xh9_warbird_stealth_no_turret" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird_stealth"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_xh9_warbird_low (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_low", undefined, "script_vehicle_xh9_warbird_low" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp

defaultmdl="vehicle_xh9_warbird_low"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/


/*QUAKED script_vehicle_xh9_warbird_low_no_zipline (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_low", undefined, "script_vehicle_xh9_warbird_low_no_zipline" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp

defaultmdl="vehicle_xh9_warbird_low"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/


/*QUAKED script_vehicle_xh9_warbird_low_no_turret_no_zipline (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_low", undefined, "script_vehicle_xh9_warbird_low_no_turret_no_zipline" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird_low"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_xh9_warbird_low_interior (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_xh9_warbird::main( "vehicle_xh9_warbird_interior_low", undefined, "script_vehicle_xh9_warbird_low_interior" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_xh9_warbird
sound,vehicle_blackhawk,vehicle_standard,all_sp


defaultmdl="vehicle_xh9_warbird_interior_low"
default:"vehicletype" "xh9_warbird"
default:"script_team" "allies"
*/

/*QUAKED misc_turret_zipline_gun (1 0 0) (-16 -16 0) (16 16 56) pre-placed
Spawn Flags:
	pre-placed - Means it already exists in map.  Used by script only.

Key Pairs:
	leftarc - horizonal left fire arc.
	rightarc - horizonal left fire arc.
	toparc - vertical top fire arc.
	bottomarc - vertical bottom fire arc.
	yawconvergencetime - time (in seconds) to converge horizontally to target.
	pitchconvergencetime - time (in seconds) to converge vertically to target.
	suppressionTime - time (in seconds) that the turret will suppress a target hidden behind cover
	maxrange - maximum firing/sight range.
	aiSpread - spread of the bullets out of the muzzle in degrees when used by the AI
	playerSpread - spread of the bullets out of the muzzle in degrees when used by the player
	defaultmdl="npc_zipline_gun_left"
	default:"weaponinfo" "zipline_gun"
	default:"targetname" "delete_on_load"
*/
