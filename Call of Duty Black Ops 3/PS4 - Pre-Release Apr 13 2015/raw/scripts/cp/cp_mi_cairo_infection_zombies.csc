#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           

#using scripts\cp\_load;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_cairo_infection_hideout_outro;

#precache( "client_fx", "zombie/fx_glow_eye_orange" );
#precache( "client_fx", "zombie/fx_spawn_dirt_hand_burst_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_billowing_zmb" );
#precache( "client_fx", "zombie/fx_spawn_dirt_body_dustfalling_zmb" );
#precache( "client_fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "client_fx", "fire/fx_fire_wall_moving_infection_city" );
#precache( "client_fx", "fire/fx_fire_backdraft_md" );
#precache( "client_fx", "fire/fx_fire_backdraft_sm" );

#namespace infection_zombies;
function main()
{
	level.zombie_game_time = 150;
	init_clientfields();
	init_fx();
}


function init_fx()
{
	level._effect["eye_glow"]					= "zombie/fx_glow_eye_orange";	
	level._effect["rise_burst"]					= "zombie/fx_spawn_dirt_hand_burst_zmb";
	level._effect["rise_billow"]				= "zombie/fx_spawn_dirt_body_billowing_zmb";
	level._effect["rise_dust"]					= "zombie/fx_spawn_dirt_body_dustfalling_zmb";	
	level._effect[ "zombie_firewall_fx" ] = "fire/fx_fire_wall_moving_infection_city";
	level._effect["zombie_guts_explosion"]      = "zombie/fx_blood_torso_explo_zmb";
	level._effect[ "zombie_backdraft_md" ] = "fire/fx_fire_backdraft_md";
	level._effect[ "zombie_backdraft_sm" ] = "fire/fx_fire_backdraft_sm";
}

function init_clientfields()
{
	/#	PrintLn( "ZM >> init_clientfields START (infection_zombies.csc) " );	#/
	
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		clientfield::register("actor", "zombie_riser_fx", 1, 1, "int", &infection_zombies::handle_zombie_risers, true, true);
		clientfield::register("actor", "zombie_has_eyes", 1, 1, "int", &infection_zombies::zombie_eyes_clientfield_cb, !true, true);
		clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int", &infection_zombies::zombie_gut_explosion_cb, !true, true);
	}

	clientfield::register("scriptmover", "zombie_fire_wall_fx", 1, 1, "int", &handle_fire_wall_fx, true, !true);
	clientfield::register("scriptmover", "zombie_fire_backdraft_fx", 1, 1, "int", &zombie_fire_backdraft_init, true, !true);
	clientfield::register("toplayer", "zombie_fire_overlay_init", 1, 1, "int", &callback_set_fire_fx, true, true);
	clientfield::register("toplayer", "zombie_fire_overlay", 1, 7, "float", &callback_activate_fire_fx, true, true);
	clientfield::register("world", "zombie_root_grow", 1, 1, "int", &handle_roots_growth, !true, !true);
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE RISE FX
//--------------------------------------------------------------------------------------------------
function handle_zombie_risers(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	level endon("demo_jump");
	self endon("entityshutdown");
	
	if ( !oldVal && newVal )
	{
		localPlayers = level.localPlayers;
		
		sound = "zmb_zombie_spawn";
		burst_fx = level._effect["rise_burst"];
		billow_fx = level._effect["rise_billow"];
		type = "dirt";
		
		if(isdefined(level.riser_type) && level.riser_type == "snow" )
		{
			sound = "zmb_zombie_spawn_snow";
			burst_fx = level._effect["rise_burst_snow"];
			billow_fx = level._effect["rise_billow_snow"];
			type = "snow";
		}		

  		playsound (0,sound, self.origin);
		
		for(i = 0; i < localPlayers.size; i ++)
		{
			self thread rise_dust_fx(i,type,billow_fx,burst_fx);
		}
	}

}

function rise_dust_fx( clientnum, type, billow_fx, burst_fx )
{
	dust_tag = "J_SpineUpper";
	
	self endon("entityshutdown");
	level endon("demo_jump");
	
	if ( IsDefined( burst_fx ) )
	{
		playfx(clientnum,burst_fx,self.origin + ( 0,0,randomintrange(5,10) ) );
	}
	
	wait(.25);
	
	if ( IsDefined( billow_fx ) )
	{
		playfx(clientnum,billow_fx,self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
	}
	
	wait(2);	//wait a bit to start playing the falling dust 
	dust_time = 5.5; // play dust fx for a max time
	dust_interval = .3; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	player = level.localPlayers[clientnum];
	
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
		PlayfxOnTag(clientnum,effect, self, dust_tag);
		wait dust_interval;
	}

}

//--------------------------------------------------------------------------------------------------
//		TREE ROOTS GROWING
//--------------------------------------------------------------------------------------------------
function handle_roots_growth( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_left_bundle", &callback_tree_roots_shader, "init" );
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_middle_bundle", &callback_tree_roots_shader, "init" );
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_right_bundle", &callback_tree_roots_shader, "init" );
								
		level thread scene::init( "p7_fxanim_cp_infection_house_roots_left_bundle" );	
		level thread scene::init( "p7_fxanim_cp_infection_house_roots_middle_bundle" );	
		level thread scene::init( "p7_fxanim_cp_infection_house_roots_right_bundle" );	
	}
	else
	{
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_left_bundle", &callback_tree_roots_shader, "play" );		
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_middle_bundle", &callback_tree_roots_shader, "play" );		
		scene::add_scene_func( "p7_fxanim_cp_infection_house_roots_right_bundle", &callback_tree_roots_shader, "play" );		
		
		level thread scene::play( "p7_fxanim_cp_infection_house_roots_left_bundle" );	
		level thread scene::play( "p7_fxanim_cp_infection_house_roots_middle_bundle" );	
		level thread scene::play( "p7_fxanim_cp_infection_house_roots_right_bundle" );	
	}		
}

function callback_tree_roots_shader( a_ents )
{
	foreach( e_root in a_ents )
	{
		e_root thread hideout_outro::city_tree_shader();				
	}	
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

function createZombieEyesInternal(localClientNum)
{
	self endon("entityshutdown");
	
	self util::waittill_dobj( localClientNum );	

	if ( !isdefined( self._eyeArray ) )
	{
		self._eyeArray = [];
	}

	if ( !isdefined( self._eyeArray[localClientNum] ) )
	{
		linkTag = "j_eyeball_le";

		effect = level._effect["eye_glow"];

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
	if ( isdefined( self._eyeArray ) )
	{
		if ( isdefined( self._eyeArray[localClientNum] ) )
		{
			DeleteFx( localClientNum, self._eyeArray[localClientNum], true );
			self._eyeArray[localClientNum] = undefined;
		}
	}
}

//--------------------------------------------------------------------------------------------------
//		ZOMBIE EXPLODES
//--------------------------------------------------------------------------------------------------
function zombie_gut_explosion_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal)
	{
		if(isdefined(level._effect["zombie_guts_explosion"]))
		{
			org = self GetTagOrigin("J_SpineLower");
			
			if(isdefined(org))
			{
				playfx( localClientNum, level._effect["zombie_guts_explosion"], org ); 	 
			}
		}
	}
}


//--------------------------------------------------------------------------------------------------
//		ZOMBIE FIRE WALL FX
//--------------------------------------------------------------------------------------------------
function handle_fire_wall_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		self.fire_id = PlayFXOnTag(localClientNum, level._effect[ "zombie_firewall_fx" ], self, "tag_origin" );
	}
	else
	{
		DeleteFx( localClientNum, self.fire_id, false );
		self.fire_id = undefined;
	}		
}

//--------------------------------------------------------------------------------------------------
//Play a Backdraft Fire effect when firewall reaches certain points.
function zombie_fire_backdraft_init( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
	{
		s_backdraft_pos = struct::get_array( "backdraft_fire", "targetname" );
		foreach( struct in s_backdraft_pos )
		{
			struct thread zombie_fire_backdraft( localClientNum, self );
		}
	}
}
	
function zombie_fire_backdraft( localClientNum, e_fire_wall )
{
	n_wall_pos= e_fire_wall.origin;
	
	while( self.origin[0] <  n_wall_pos[0])
	{
		wait 0.1;	
		
		n_wall_pos = e_fire_wall.origin;
	}
	
	forward = AnglesToForward(self.angles);	
	if(RandomInt(100) > 50)
	{	
		PlayFX(localClientNum, level._effect[ "zombie_backdraft_md" ], self.origin, forward);
		playsound (0, "pfx_backdraft", self.origin);
	}
	else
	{		
		PlayFX(localClientNum, level._effect[ "zombie_backdraft_sm" ], self.origin, forward);
		playsound (0, "pfx_backdraft", self.origin);
	}			
}	

//--------------------------------------------------------------------------------------------------
//		ZOMBIE BURN FX OVERLAY
//--------------------------------------------------------------------------------------------------
function callback_set_fire_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetDvar( "r_radioactiveFX_enable", newVal );
	
	if ( newVal != oldVal )
	{
		SetDvar( "r_radioactiveIntensity", 0 );
	}
}

function callback_activate_fire_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_intensity_amount = math::linear_map( newVal, 0.00, 1.00, 0.00, 4.00 );
	
	SetDvar( "r_radioactiveIntensity", n_intensity_amount );
}