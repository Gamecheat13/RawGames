#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_utility;
#include maps\_shg_debug;
#include soundscripts\_audio;
#include soundscripts\_snd;
#include soundscripts\_snd_playsound;
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												TODO																			//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// - Make a dvar for this: k_vehicles_enabled
// - After preset build, check to make sure all envelopes exists.
// - Deal with the legacy "_plr" mode (deprecate it?). Then add a vm debug flag the verifies alieas at preset build time.
// - Add default smooth up/down to VM2_begin_oneshot_data(default_fade_time_);  AND maybe to VM2_begin_behavior_data()
// - Revise preset def constructors so they don't need end_XXX() calls (change the "get owner" stuff to have a self.current_foo pointer for each def type to simplify)
// - Make loop asset refs structs and oneshot asset ref structs identical to support polymorphism.
// - Input callback parameter passing (via preset); that is, allow passing args when registering inputs to "config" the input (e.g. dopplerExagerated).
// - Determine if snd_ents really need be "indexed":  inst_oneshot_struct.snd_ents[index]
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												DEPRECATED																		//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
VM2_add_oneshot( string1, string2 )
{
	AssertEx(false, "DEPRECATED:  VM2_add_oneshot()");
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												CONSTANTS																		//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
kVM2_UpdateRate					= 0.1;

kVM2x_LoopPlayState_Off			= 0;
kVM2x_LoopPlayState_On			= 1;

kVM2_OneshotMode_Unrestricted	= 0;
kVM2_OneshotMode_Restricted		= 1;
kVM2_OneshotMode_Exclusive		= 2;

kVM2_InchesPerSecPerMPH			= 17.6;
kVM2_MPHPerInchesPerSecond		= 1 / 17.6;
kVM2_GPerInchesPerSecSquared	= 1 / 800;  // matches the g_gravity dvar (which is actually >2x real gravity)

kVM2_units2yards_scalar			= 1/36;
kVM2_yards2units_scalar			= 36;

kVM2_hud_mode_silent			= 0;
kVM2_hud_mode_concise			= 1;
kVM2_hud_mode_verbose			= 2;
kVM2_MaxHudSlots				= 45;
kVM2_hud_max_y_screen_space_pos	= 479;

kVM2_Debug3D					= false;
kVM2_use_optimized_envelopes	= true;

kVM2_dvar_hud_mode				= "snd_vm_hud";
kVM2_dvar_verify_aliases		= "snd_verify_aliases";
kVM2_dvar_vm_debug				= "snd_vm_debug";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												PUBLIC FUNCTIONS																//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
=============
///ScriptDocBegin
"Name: VM2_init()"
"Summary: Initializes the Vehicle Manager."
"Module: Sound - Vehicle Manager"
"CallOn: An entity"
"Example: VM2_init();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_init()
{
	if (IsDefined(level._audio.vm))
		return;	// Already initialized.
	
	/*** CREATE MAIN VM STRUCTURE ***/
	AssertEx(IsDefined(level._audio), "Must call audio_init() before calling VM2_init()");
	if (!IsDefined(level._audio.vm))
		level._audio.vm = SpawnStruct();
	
	vm = VM2x_get();	
	
	/*** INIT GLOBALS ***/
	
	// Misc Globals.
	vm.callbacks					= [];	// Callbacks: input, loop_output, oneshot_output, state_condition, state_enter_action, state_exit_action.	
	vm.preset_constructors			= [];
	vm.presets						= [];	// Vehicle Presets.
	vm.running_intance_accumulator	= 0;	// Number of instances created to date; continually increments.
	
	// Parameter Defaults.
	vm.def_asset_type				= "alias";
	vm.def_player_mode				= false;
	vm.def_fadein_time				= 1.0;
	vm.def_fadeout_time				= 1.0;
	vm.def_state_min_retrigger_time	= 0;	// IN MSECS.
	vm.def_sound_offset				= (0,0,0);
	vm.def_smooth_up				= 1.0;
	vm.def_smooth_down				= 1.0;
	vm.def_input_name				= "distance";
	vm.def_output_name				= "volume";
	vm.def_output_scalar			= 1.0;
	vm.def_priority					= 50;
	/#
	vm.hud_vertical_spacing			= 10;
	vm.hud_fontsize					= 0.75;
	#/
	
	/*** REGISTER CALLBACKS ***/
	
	// Register Vehicle Manager messages with _snd.gsc
	snd_register_message( "snd_register_vehicle",	::snd_register_vehicle );
	snd_register_message( "snd_start_vehicle",		::snd_start_vehicle );
	snd_register_message( "snd_stop_vehicle",		::snd_stop_vehicle );
	
	// Register standard default input callbacks.
	VM2_register_callback( "distance2d",			::input_callback_distance2d );
	VM2_register_callback( "distance",				::input_callback_distance );
	VM2_register_callback( "throttle",				::input_callback_throttle );		// Range 0 - 1.0.
	VM2_register_callback( "speed",					::input_callback_speed );
	VM2_register_callback( "relative_speed",		::input_callback_relative_speed );
	VM2_register_callback( "doppler",				::input_callback_doppler );
	VM2_register_callback( "doppler_exaggerated",	::input_callback_doppler_exaggerated );
	VM2_register_callback( "doppler_subtle",		::input_callback_doppler_subtle );
	VM2_register_callback( "speed_mph",				::input_callback_speed_mph );		// units are mph
	VM2_register_callback( "acceleration_g",		::input_callback_acceleration_g );	// units are G's
	VM2_register_callback( "jerk_gps",				::input_callback_jerk_gps );		// units are G's per second
	VM2_register_callback( "pitch",					::input_callback_pitch );
	VM2_register_callback( "yaw",					::input_callback_yaw );
	
	/#	
	VM2x_hud_init();
	
	SetDvarIfUninitialized(kVM2_dvar_verify_aliases,	"0");
	SetDvarIfUninitialized(kVM2_dvar_hud_mode,			"0");
	#/
}

/#
	k_vehicles_enabled	= true;
#/
	
snd_register_vehicle(preset_name, preset_constructor)
{
	vm = VM2x_get();
	
	AssertEx(IsDefined(preset_name),							"snd_register_vehicle(): Bad arg for preset_name.\n");
	AssertEx(IsDefined(preset_constructor),						"snd_register_vehicle(): Bad arg for preset_constructor.\n");
	vm.preset_constructors[preset_name] = preset_constructor;
}

/*
=============
///ScriptDocBegin
"Name: snd_start_vehicle( <args> )"
"Summary: Creates and starts a new vehicle instance.  Also creates a preset the first time a vehicle is instanced.
"Module: Sound - Vehicle Manager"
"CallOn: A vehcile entity."
"MandatoryArg: args - argument struct or preset name string."
"MandatoryArg: args.preset_name - preset name string (mandatory only if <args> is a struct)."
"OptionalArg: args.player_mode: Use true for a PC version of the vehicle, false or undefined for an NPC version of the vehicle."
"OptionalArg: args.fadein_time: Upon start, time in seconds it takes to fade in the vehicle from zero to full volume."
"OptionalArg: args.fadeout_time: Upon stop, time in seconds it takes to fade out the vehicle from full volume to zero."
"OptionalArg: args.offset: Vehicle sound offset from actual vehicle origin."
"OptionalArg: args.initial_state_spec: Used to override the preset's default inital states. This is an array that is keyed by StateGroupName, where each data item is a StateName for the keyed StateGroup."
"Example: veh_ent snd_message("snd_start_vehicle", args);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_start_vehicle(args)
{ 	
	/#
		if (k_vehicles_enabled == false)
			return;
	#/
	
	AssertEx(!IsDefined(self.snd_instance),	"snd_start_vehicle():  Attempting to start a snd vehicle instance on a vehicle that already has a snd_instance attached.");
	AssertEx(IsDefined(args),				"snd_start_vehicle():  bad arg <args>.");
	vm = VM2x_get();
	
	// If user passes a string (the only required arg), convert it to an arg struct.
	if (IsString(args))	
	{
		preset_name 		= args;
		args				= SpawnStruct();
		args.preset_name	= preset_name;
	}
	
	// Mandatory args.
	AssertEx(IsString(args.preset_name), "snd_start_vehicle():  preset_name is a mandatory argument.");
	preset_name = args.preset_name;

	// Optional args
	player_mode_		= aud_get_optional_param(vm.def_player_mode,	args.player_mode);			// Optional:	true for player_mode, false for npc_mode.
	fadein_time_		= aud_get_optional_param(vm.def_fadein_time,	args.fadein_time);			// Optional: 	vehicle fade-in time.	
	fadeout_time_		= aud_get_optional_param(vm.def_fadeout_time,	args.fadeout_time);			// Optional: 	vehicle fade-out time.	
	offset_				= aud_get_optional_param(vm.def_sound_offset,	args.offset);				// Optional:	sound offset relative to vehicle position (optional).
	initial_state_spec_	= aud_get_optional_param(undefined,				args.initial_state_spec);	// Optional: 	which state(s) to use as the intial state in the state machine(s).
	
	// Create and start new preset instance.
	self.snd_instance = self thread VM2x_start_instance(preset_name, player_mode_, fadein_time_, fadeout_time_, offset_, initial_state_spec_);
}

// Called on Vehicle Entity.
/*
=============
///ScriptDocBegin
"Name: snd_stop_vehicle( <fade_out_time_> , <stop_delay_> )"
"Summary: Stops and instance of a vehicle manager preset."
"Module: Sound - Vehicle Manager"
"CallOn: A vehcile entity."
"OptionalArg: <fade_out_time_>: "
"OptionalArg: <stop_delay_>: "
"Example: veh_ent snd_message("snd_stop_vehicle");"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
snd_stop_vehicle(fade_out_time_, stop_delay_)
{ 	
	veh_ent	= self;
	vm		= VM2x_get();
	
	/#
		if (k_vehicles_enabled == false)
			return;
	
		AssertEx(IsDefined(veh_ent.snd_instance) || !GetDebugDvarInt(kVM2_dvar_vm_debug), "VM2 Error:  Attempting to stop a snd vehicle instance on a vehicle that does not have a snd_instance attached." );
		if (!IsDefined(veh_ent.snd_instance)) 
			return;
	#/
	
	// Get snd instance, and remove it from the vehicle entity.
	instance	= veh_ent.snd_instance;
	veh_ent.snd_instance = undefined;
	
	preset = instance VM2x_get_instance_preset();
	
	// Get fadeout time.
	default_fadeout_time	= aud_get_optional_param(instance.fadeout_time, preset.header.fadeout_time);
	instance.fadeout_time	= aud_get_optional_param(default_fadeout_time, fade_out_time_); // Store this in the instance in case the "montior death" thread stops it first.
	
	// Get Stop Delay.
	stop_delay_	 = aud_get_optional_param(0, stop_delay_);
	
	// Stop the preset instance.
	instance delayThread(stop_delay_, ::VM2x_stop_instance, instance.fadeout_time);
}

VM2_create_vehicle_proxy()
{
	proxy				= spawn_tag_origin(); // spawn("script_origin", (0, 0, 0));
	proxy.vm_is_proxy	= true;
	
	return proxy;
}

VM2x_is_vehicle_proxy()
{
	return IsDefined(self.vm_is_proxy) && self.vm_is_proxy == true;
}

/****************************************************************************************************/
/********************************* BEGIN PRESET CONSTRUCTION API ************************************/
/****************************************************************************************************/
/*
=============
///ScriptDocBegin
"Name: VM2_begin_preset_def()"
"Summary: Initiates a vehicle preset definition. Normally used within a vehicle_construction_callback, called by the Vehicle Manager on a pre-initialized Vehicle Instance."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <preset_name>: preset name"
"OptionalArg: <instance_init_callback_>: function to be called when each instance is created.  A <user_data> parameter is passed to the function which is a preallocated struct unique to the instance."
"Example: VM2_begin_preset_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_preset_def(preset_name, instance_init_callback_)
{	
	vm = VM2x_get();
	
	AssertEx(!IsDefined(vm.vehicle_under_construction),	"VM2_begin_preset_def() called during previous vehicle construction.");
	AssertEx(IsDefined(self.header),					"VM2_begin_preset_def() called before vehicle initialization.");
	AssertEx(!IsDefined(self.loop_data),				"VM2_begin_preset_def() called, but preset has already been created.");
	AssertEx(!IsDefined(self.oneshot_data),				"VM2_begin_preset_def() called, but preset has already been created.");
	AssertEx(!IsDefined(self.behavior_data),			"VM2_begin_preset_def() called, but preset has already been created.");
	AssertEx(!IsDefined(self.state_data),				"VM2_begin_preset_def() called, but preset has already been created.");
	
	// Set preset/instance name.
	self VM2x_set_preset_name(preset_name);
	
	self VM2x_set_instance_init_callback(instance_init_callback_);
	
	// Mark this vehicle instance as the one currently under construction.
	//self.currently_under_construction = true; TODO
	vm.vehicle_under_construction = self;
}
	
/*
=============
///ScriptDocBegin
"Name: VM2_begin_loop_data( <default_fadeout_time_> , <default_smooth_up_> , <default_smooth_down_> )"
"Summary: Signals the start of the loop data segment of a vehicle preset under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"OptionalArg: <default_fadeout_time_>: "
"OptionalArg: <default_smooth_up_>: "
"OptionalArg: <default_smooth_down_>: "
"Example: VM2_begin_loop_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_loop_data(default_fadeout_time_, default_smooth_up_, default_smooth_down_)
{
	AssertEx(IsDefined(self.header),		"VM2_begin_loop_data() called before vehicle initialization.");
	AssertEx(!IsDefined(self.loop_data),	"VM2_begin_loop_data() called, but preset has already been created.");
	vm = VM2x_get();
		
	// Create/init loop_data struct.
	self.loop_data = SpawnStruct();
	self.loop_data.loops = [];
	
	// Create/init loop_data defaults struct.
	self.loop_data.defaults					= SpawnStruct();
	self.loop_data.defaults.fadeout_time	= aud_get_optional_param(vm.def_fadeout_time,	default_fadeout_time_);
	self.loop_data.defaults.smooth_up		= aud_get_optional_param(vm.def_smooth_up,		default_smooth_up_);
	self.loop_data.defaults.smooth_down		= aud_get_optional_param(vm.def_smooth_down,	default_smooth_down_);
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_loop_def( <asset_name> , <loop_name_> , <asset_type_> )"
"Summary: Initiates construction of a new loop definition within a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <asset_name>: Name of sound content asset."
"OptionalArg: <loop_name_>: Preset loop object name. May be required if the same loop asset is being used multiple times with different preset meta data.  Default is <asset_name>."
"MandatoryArg: <asset_type_>: Type of sound asset being use for the loop; e.g., "alias", "soundevent", or "damb".  Default is "alias"."
"Example: VM2_begin_loop_def("fus_idle_lp_03", "pdrone_main_idle_loop")"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_loop_def(asset_name, fadeout_time_, default_smooth_up_, default_smooth_down_, loop_name_, asset_type_)
{
	AssertEx(IsDefined(self.loop_data),														"VM2_begin_loop_def() called before VM2_begin_loop_data().");
	AssertEx(!IsDefined(self.loop_data.loop_under_construction),							"VM2_begin_loop_def() during loop construction ( did you forget to call VM2_end_loop_def()? ).");
	AssertEx(IsString(asset_name),															"VM2_begin_loop_def() called without valid asset_name string.");
	AssertEx(!IsDefined(asset_type_) || (IsString(asset_type_) && asset_type_ == "alias"),	"VM2_begin_loop_def() unsupported asset_type.");
	
	
	// Handle default params.
	fadeout_time_			= aud_get_optional_param(self.loop_data.defaults.fadeout_time,	fadeout_time_);
	default_smooth_up_		= aud_get_optional_param(self.loop_data.defaults.smooth_up,		default_smooth_up_);
	default_smooth_down_	= aud_get_optional_param(self.loop_data.defaults.smooth_down,	default_smooth_down_);
	loop_name_				= aud_get_optional_param(asset_name, loop_name_);
	asset_type_				= aud_get_optional_param("alias", asset_type_);
	
	/#
	if (asset_type_ == "alias")
		AssertEx(!GetDebugDvarInt(kVM2_dvar_verify_aliases) || SoundExists( asset_name ) || SoundExists( asset_name + "_plr"), "VM2_begin_loop_def() - alias does not exists: " + asset_name  + ".");
	#/
	
	AssertEx(!IsDefined(self.loop_data.loops[loop_name_]), "VM2_begin_loop_def() adding loop that already exists; will be overwritten: " + loop_name_);
	
	// Create loop struct.
	loop						= SpawnStruct();
	loop.name					= loop_name_;
	loop.fadeout_time			= fadeout_time_;
	loop.asset_type				= asset_type_;
	loop.asset_names			= [asset_name];
	loop.preset_name			= self VM2x_get_preset_name();
	loop.param_maps				= [];
	
	// Create param_map defaults for this loop.
	loop VM2x_preset_set_param_map_defaults(default_smooth_up_, default_smooth_down_);
	
	// Add new loop to loop array & mark this loop as currently under construction.
	self.loop_data.loops[loop.name] = loop;	
	self.loop_data.loop_under_construction = loop;
}

/*
=============
// Used during preset construction to determing which object is the owner of the current param map under construction so it can be "attached" to it's owner once created.
// This is needed because param_maps and the data they contain can be used by both loop and oneshot objects within a preset.
=============
*/
// TODO: maybe change this to have a self.current_foo pointer for each def type
VM2x_preset_determine_param_map_owner(item_name)
{
	assert(IsString(item_name));
	pmap_owner = undefined;
	if (IsDefined(self.loop_data) && IsDefined(self.loop_data.loop_under_construction))					// Starting a loop param map?
	{
		pmap_owner = self.loop_data.loop_under_construction;
		
		if (IsDefined(self.behavior_data))
			AssertEx(!IsDefined(self.oneshot_data.oneshot_under_construction),	"VM2_begin_param_map(): Cannot create a loop while a oneshot is under construction (or vice vesa).");	
	}
	else if (IsDefined(self.oneshot_data) && IsDefined(self.oneshot_data.oneshot_under_construction))	// Starting a oneshot param map?
	{
		pmap_owner = self.oneshot_data.oneshot_under_construction;
	}	
	else if (IsDefined(self.behavior_data) && IsDefined(self.behavior_data.behavior_under_construction))
	{
		pmap_owner = self.behavior_data.behavior_under_construction;
	}
	
	AssertEx(IsDefined(pmap_owner),	"VM2x_preset_determine_param_map_owner(): Can't determine owner of " + item_name + "\n.");
	return pmap_owner;
}

/*
=============
// Used during preset construction to determing which object is the owner of the current param map envelope under construction so it can be "attached" to it's owner once created.
// This is needed because param_maps and the data they contain can be used by both loop and oneshot objects within a preset.
=============
*/
VM2x_preset_determine_param_map_env_owner(item_name)
{
	env_owner = undefined;
	assert(IsString(item_name));
	
	pmap_owner = VM2x_preset_determine_param_map_owner(item_name);
	AssertEx(IsDefined(pmap_owner),	"VM2x_preset_determine_param_map_env_owner() can't determine owner of " + item_name + "\n.");
	
	if (IsDefined(pmap_owner))
		env_owner = pmap_owner.pmap_under_construction;
	
	AssertEx(IsDefined(env_owner),	"VM2x_preset_determine_param_map_env_owner(): Can't determine owner of " + item_name + "\n.");
	return env_owner;
}

/*
=============
// Used during preset construction to set param_map default values.
// This is useful because param_maps and the data they contain can be used by both loop and oneshot objects within a preset.
=============
*/
VM2x_preset_set_param_map_defaults(default_smooth_up_, default_smooth_down_)
{
	vm = VM2x_get();
	
	self.param_map_defaults = SpawnStruct();

	def_smooth_up	= aud_get_optional_param(vm.def_smooth_up, self.param_map_defaults.smooth_up);
	def_smooth_down	= aud_get_optional_param(vm.def_smooth_down, self.param_map_defaults.smooth_down);
	
	// Apply defaults first...
	self.param_map_defaults.smooth_up		= aud_get_optional_param(def_smooth_up,		default_smooth_up_);
	self.param_map_defaults.smooth_down		= aud_get_optional_param(def_smooth_down,	default_smooth_down_);
	self.param_map_defaults.input_name		= vm.def_input_name;
	self.param_map_defaults.output_name		= vm.def_output_name;
	self.param_map_defaults.input_modifiers	= [];
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_param_map( <input> , <smooth_up_> , <smooth_down_> )"
"Summary: Inititates construction of a new param_map component within a loop or oneshot object in a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <input>: Vehicle entity input name or function callback to be mapped to an audio output."
"OptionalArg: <smooth_up_>: Input smoothing value when going up in value.  Default is the param_map's owner's default value for it's param maps."
"OptionalArg: <smooth_down_>: Input smoothing value when going down in value.  Default is <smooth_up_> if specified, or the param_map's owner's default value for it's param maps.""
"Example: VM2_begin_param_map("speed", 3.2)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_param_map(input, smooth_up_, smooth_down_)									
{
	// First determine if a loop or oneshot is building this param map.`
	
	AssertEx(IsString(input), "VM2_begin_param_map(): invalid param <input> - must be a string."); 
	input = ToLower(input);
	param_map_input_name = input;
	if (!IsString(param_map_input_name))
		param_map_input_name = "";	
	owner = VM2x_preset_determine_param_map_owner(param_map_input_name);
	AssertEx(IsDefined(owner),							"VM2_begin_param_map() called before calling VM2_begin_loop_def() or VM2_begin_behavior_def().");
	AssertEx(IsDefined(owner.param_maps), 				"VM2_begin_param_map() internal error:  param_map owner has not created it's param_maps list.");
	AssertEx(!IsDefined(owner.pmap_under_construction), "VM2_begin_param_map() internal error:  param_map owner has already defined pmap_under_construction.");
	
	// TODO: Revisit whether we want to make <input> an optional param and whether or not both input names and input function ptrs are allowed.
	// Pretty sure this supports function ptrs too, but for first dev pass on this, assert if it's not a name string.
	
	param_map_input_name = input;
	/#
		// VERIFY THAT INPUT NAMES ARE UNIUQUE WITHIN THE PARM_MAPS CHUNK (e.g. no duplicates).
		preset_name = VM2x_get_preset_name();
		AssertEx(	!IsDefined( owner.param_maps[param_map_input_name] ), 
			 		"VM2 PRESET ERROR: " + preset_name + " contains duplicate " + param_map_input_name + " INPUTS in item " + owner.name + ".");
	#/
				
	// Create & init new param map struct.		
	new_pmap = SpawnStruct();
	new_pmap.envs				= [];
	new_pmap.input_name			= input;
	new_pmap.smooth_up			= aud_get_optional_param(owner.param_map_defaults.smooth_up, smooth_up_);
	new_pmap.smooth_down		= aud_get_optional_param(owner.param_map_defaults.smooth_down, aud_get_optional_param(smooth_up_, smooth_down_));
	new_pmap.def_output_name	= owner.param_map_defaults.output_name;	// This is the default ouput name for envs contained in a param_map.
	
	// Adjust smoothness to be update-rate-independent (per T. Felker).
	new_pmap.smooth_up		= VM2_change_smoothing_rate(new_pmap.smooth_up, .1, kVM2_UpdateRate);
	new_pmap.smooth_down	= VM2_change_smoothing_rate(new_pmap.smooth_down, .1, kVM2_UpdateRate);
	
	// Attach new pmap to owner.
	owner.param_maps[param_map_input_name]	= new_pmap;
	owner.pmap_under_construction			= new_pmap;
}

VM2_compute_smoothing_rc_from_alpha(alpha, dt)
{
	return dt * (1 - alpha) / alpha;
}

VM2_compute_alpha_from_rc(rc, dt)
{
	return dt / (rc + dt);
}

VM2_change_smoothing_rate(old_alpha, old_dt, new_dt)
{
	rc = VM2_compute_smoothing_rc_from_alpha(old_alpha, old_dt);
	new_alpha = VM2_compute_alpha_from_rc(rc, new_dt);
	return new_alpha;
}

/*
=============
"Name: VM2x_add_behavior_shortcut_param_maps( <input_array> )"
"Summary: Optional shortcut to get 'unity' param maps (no env mapping, just raw input) into behaviors to be passed to the conditional_callback."
"CallOn: preset"
"MandatoryArg: <input_array>: "
=============
*/
VM2x_add_behavior_shortcut_param_maps(input_array, smooth_up_, smooth_down_)
{
	foreach (input_name in input_array)
	{
		VM2_begin_param_map(input_name, smooth_up_, smooth_down_);
		VM2_end_param_map();
	}
}

				
// outputName, envAssetName/func, optoinalEnvInstanceName (required if using mulitple instances of envAssetName/func) 
/*
=============
///ScriptDocBegin
"Name: VM2_add_param_map_env( <output_name> , <env_asset_name_or_func> , <env_instance_name_> )"
"Summary: Add's a mapping envelope (data or function) to the current parm_map under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <output_name>: Audio output to which the parent param map input will be mapped."
"MandatoryArg: <env_asset_name_or_func>: Envelope data array or envelope function to be used to determine how input is mapped to output."
"OptionalArg: <env_instance_name_>: NOTE:  This argument is required when specifying an envelope function callback."
"Example: VM2_add_param_map_env("volume", ::speed_to_volume_al_gore_has_no_rhythm", "Al_Gore_Mapper_Function")"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_add_param_map_env(output_name, env_asset_name_or_func, env_instance_name_)	
{
	// Validate & set default param values.
	AssertEx(IsString(output_name),				"VM2_add_param_map_env(): invalid output_name.");
	AssertEx(IsDefined(env_asset_name_or_func),	"VM2_add_param_map_env(): invalid env_asset_name_or_func.");
	
	if (IsString(env_asset_name_or_func))
	{
		env_instance_name_ = aud_get_optional_param(env_asset_name_or_func, env_instance_name_);
	}

	AssertEx(IsString(env_instance_name_), "VM2_add_param_map_env(): if <env_asset_name_or_func> is a function, then env_instance_name_ is required.");
	
	// Determine if a loop or oneshot is building this param map.
	env_owner = VM2x_preset_determine_param_map_env_owner(env_instance_name_);
	
	// More validation.
	tmp_name = env_asset_name_or_func;
	if (!IsString(tmp_name))
		tmp_name = "???";
	AssertEx(IsDefined(env_owner),		"VM2_add_param_map_env(): Can't determing the pmap that owns env: " + tmp_name + "\n.");
	AssertEx(IsArray(env_owner.envs),	"VM2_add_param_map_env() intrnal error:  did not create the envelope list for param_map " + env_owner.input_name + "\n.");
	
	// Create/init new envelope.
	new_env = SpawnStruct();
	new_env.asset_name	= env_asset_name_or_func;
	new_env.output_name	= output_name;
	
	// Add new env to list.
	env_owner.envs[env_instance_name_] = new_env;
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_param_map()"
"Summary: Terminates construction of a new param_map component within a loop or oneshot object in a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_param_map()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_param_map()
{
	pmap_owner = VM2x_preset_determine_param_map_owner("UNKNOWN param_map being terminated by VM2_end_param_map()");
	AssertEx(IsDefined(pmap_owner), 							"VM2_end_loop_param_map() can't determine current param_map owner.");
	if (IsDefined(pmap_owner))
	{
		AssertEx(IsDefined(pmap_owner.pmap_under_construction),	"VM2_end_loop_param_map() called before VM2_begin_param_map().");
	
		// Done with current loop's current param map.
		pmap_owner.pmap_under_construction = undefined;
	}
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_loop_def()"
"Summary: Terminates construction of a new loop definition within a preset."
"Module: Sound - Vehicle Manager"
"CallOn: An entity"
"Example: VM2_end_loop_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_loop_def()
{
	AssertEx(IsDefined(self.loop_data),							"VM2_end_loop_def() called before VM2_begin_loop_data().");
	AssertEx(IsDefined(self.loop_data.loop_under_construction), "VM2_end_loop_def() before VM2_begin_loop_def().");
	
	// Done with current loop def.
	self.loop_data.loop_under_construction = undefined;
}		

/*
=============
///ScriptDocBegin
"Name: VM2_end_loop_data()"
"Summary: Terminates construction of the loop section of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_loop_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_loop_data()
{
	AssertEx(IsDefined(self.loop_data),	"VM2_end_loop_data() called before VM2_begin_loop_data().");
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_oneshot_data()"
"Summary: Signals the start of the oneshot data segment of a vehicle preset under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_begin_oneshot_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_oneshot_data(default_fade_time_)
{
	AssertEx(IsDefined(self.header),		"VM2_begin_oneshot_data() called before vehicle initialization.");
	AssertEx(!IsDefined(self.oneshot_data),	"VM2_begin_oneshot_data() called, but preset has already been created.");
	vm = VM2x_get();
	
	// Create/init oneshot_data struct.
	self.oneshot_data			= SpawnStruct();
	self.oneshot_data.oneshots	= [];
	
	// Create/init oneshot_data defaults struct.
	self.oneshot_data.defaults				= SpawnStruct();
	self.oneshot_data.defaults.fadeout_time	= aud_get_optional_param(vm.def_fadeout_time, default_fade_time_);

}

/*
=============
///ScriptDocBegin
"Name:			VM2_begin_oneshot_def( <oneshot_name> , <duck_envelop_name_> , <fadeout_time_> , <oneshot_mode_> , <asset_name_or_array_> , <asset_type_> )"
"Summary:		Initiates construction of a new oneshot definition within a preset."
"Module:		Sound - Vehicle Manager"
"CallOn:		preset struct"
"MandatoryArg:	<oneshot_name>:			Preset oneshot object name. (used as default for optional <asset_name_or_array_> param."
"OptionalArg:	<duck_envelop_name_>:	Temporal duck envelope that should be applied to loops when this oneshot is triggered."
"OptionalArg:	<fadeout_time_>:		Used when oneshot is faded out due to it being restricted.
"OptionalArg:	<oneshot_mode_>:		0 - Unrestricted, 1 - Restricted, or 2 - Exclusive. Default is 1 - Restricted."
"OptionalArg:	<asset_name_or_array_>:	Asset name or array of asset names (e.g, alias name or array of alias names).  If not specified, <oneshot_name> is used."
"OptionalArg:	<asset_type_>:			Type of sound asset being use for the oneshot; e.g., "alias", "soundevent", or "damb".  Default is "alias"."
"Example:		VM2_begin_oneshot_def("pdrone_flyby", "pdrn_flyby_duck_envelope", 0.25, true, ["pdrn_by_1", "pdrn_by_2"]);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_oneshot_def(oneshot_name, duck_envelop_name_, fadeout_time_, oneshot_mode_, asset_name_or_array_, asset_type_)
{
	vm = VM2x_get();
	
	AssertEx(IsString(oneshot_name),									"VM2_begin_oneshot_def() called without valid oneshot_name arg; <oneshot_name> must be a string.");
	AssertEx(IsDefined(self.oneshot_data),								"VM2_begin_oneshot_def() called before VM2_begin_oneshot_data().");
	AssertEx(!IsDefined(self.oneshot_data.oneshot_under_construction),	"VM2_begin_oneshot_def() during oneshot construction ( did you forget to call VM2_end_oneshot_def()? ).");
	assert(IsDefined(self.oneshot_data.oneshots));
	AssertEx(!IsDefined(self.oneshot_data.oneshots[oneshot_name]), 		"VM2_begin_oneshot_def() adding oneshot that already exists; will be overwritten: " + oneshot_name);
	

	// Handle default params.
	duck_envelop_name_		= aud_get_optional_param(undefined, duck_envelop_name_);
	fadeout_time_			= aud_get_optional_param(self.oneshot_data.defaults.fadeout_time, fadeout_time_);
	oneshot_mode_			= aud_get_optional_param(kVM2_OneshotMode_Restricted, oneshot_mode_);
	asset_name_or_array_	= aud_get_optional_param(oneshot_name, asset_name_or_array_);
	asset_type_				= aud_get_optional_param(vm.def_asset_type, asset_type_);

	AssertEx(!IsDefined(asset_type_) || (IsString(asset_type_) && asset_type_ == "alias"),	"VM2_begin_oneshot_def() unsupported asset_type.");
		
	asset_names = asset_name_or_array_;
	if (IsString(asset_name_or_array_))	// Convert optional string asset name (e.g., single alias) to array format.
		asset_names = [asset_name_or_array_];
	
// TODO: This doesn't work, because at run-time we check the "is player" flag and concat the "_plr" to all aliaes.  
//			Need to either remove that run-time "_plyr" mode feature (probably should; may not ever be used because plr and npc vehicles are totally different),
//			Or, we could put a check at runtime when we try to find use the alias (but that defeats the purpose of preventing the runtime asserts via snd_play_sound().
	/#
	if (asset_type_ == "alias")
	{
		foreach (asset_name in asset_names)
		{
			AssertEx(!GetDebugDvarInt(kVM2_dvar_verify_aliases) || SoundExists( asset_name ) || SoundExists( asset_name + "_plr"), "VM2_begin_oneshot_def() - alias does not exists: " + asset_name  + ".");
		}
	}
	#/
	
	// Create oneshot struct.
	oneshot						= SpawnStruct();
	oneshot.name				= oneshot_name;
	oneshot.asset_names			= asset_names;
	oneshot.asset_type			= asset_type_;
	oneshot.duck_env_name		= duck_envelop_name_;
	oneshot.fadeout_time		= fadeout_time_;
	oneshot.oneshot_poly_mode	= oneshot_mode_;
	// Is this really needed?:  oneshot.preset_name		= self VM2x_get_preset_name();
	oneshot.param_maps			= [];
	oneshot.snd_ents			= [];	
	
	// Create param_map defaults for this oneshot.
	oneshot VM2x_preset_set_param_map_defaults();
	
	// Add new oneshot to the presets oneshot list.
	self.oneshot_data.oneshots[oneshot.name]		= oneshot;
	self.oneshot_data.oneshot_under_construction	= oneshot;
}

/*
=============
///ScriptDocBegin
"Name: VM2x_set_oneshot_update_mode( <mode> )"
"Summary: Determines weather the one shot is start-and-forget, or is continually updated."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <mode>: 0: play and forget mode, 1: continuous update mode "
"Example: VM2x_set_oneshot_update_mode(1)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2x_set_oneshot_update_mode(mode)
{
	AssertEx(IsDefined(self.oneshot_data),								"VM2x_set_oneshot_update_mode() called before VM2_begin_oneshot_data().");
	AssertEx(IsDefined(self.oneshot_data.oneshot_under_construction),	"VM2x_set_oneshot_update_mode() VM2_begin_oneshot_data().");
	AssertEx(IsDefined(mode) && (mode == 0 || mode == 1),				"VM2x_set_oneshot_update_mode() Invalid mode argument; must be 0 or 1.");
	
	oneshot_struct						= self.oneshot_data.oneshot_under_construction;
	oneshot_struct.oneshot_update_mode	= mode;
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_oneshot_def()"
"Summary: Terminates construction of a new oneshot definition within a preset."
"Module: Sound - Vehicle Manager"
"CallOn: An entity"
"Example: VM2_end_oneshot_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_oneshot_def()
{
	AssertEx(IsDefined(self.oneshot_data),							"VM2_end_oneshot_def() called before VM2_begin_oneshot_data().");
	AssertEx(IsDefined(self.oneshot_data.oneshot_under_construction), "VM2_end_oneshot_def() before VM2_begin_oneshot_def().");
	
	// Done with current oneshot def.
	self.oneshot_data.oneshot_under_construction = undefined;
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_oneshot_data()"
"Summary: Terminates construction of the oneshot section of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_oneshot_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_oneshot_data()
{
	AssertEx(IsDefined(self.oneshot_data),	"VM2_end_oneshot_data() called before VM2_begin_oneshot_data().");
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_behavior_data()"
"Summary: Initiates construction of the State Behavior Data section of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_begin_behavior_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_behavior_data(default_smooth_up_, default_smooth_down_)
{
	AssertEx(IsDefined(self.header),								"VM2_begin_behavior_data() called before vehicle initialization.");
	AssertEx(IsDefined(self.loop_data),								"VM2_begin_behavior_data() called before VM2_begin_loop_data().");	// Actually, defining behaviors before loops is probably supported.
	AssertEx(!IsDefined(self.loop_data.loop_under_construction),	"VM2_begin_behavior_data() called during loop construction.");
	AssertEx(!IsDefined(self.behavior_data),						"VM2_begin_behavior_data() called multiple times.");
	
	/*** Create/Init main behavior_data struct. ***/ 
	self.behavior_data						= SpawnStruct();
	self.behavior_data.behaviors			= [];
	self.behavior_data.defaults				= SpawnStruct();
	self.behavior_data.defaults.smooth_up	= default_smooth_up_;
	self.behavior_data.defaults.smooth_down	= default_smooth_down_;
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_behavior_def( <behavior_name> , <conditional_callback> , <conditional_input_array_> )"
"Summary: Initiates construction of the current state behavior within the behavior data section of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <behavior_name>: Name of state behavior object."
"MandatoryArg: <conditional_callback>: Callback determine if the conditions been met to move into state associated with this behavior; if so, callback should return either true or a list of assets to play upon state entry (overriding any assets listed in the preset)."
"OptionalArg: <conditional_input_array_>: Input list for raw params to be passed to param maps (no env mapping, just raw input) into behaviors to be passed to the conditional_callback."
"Example: VM2_begin_behavior_def("flyover", ::have_flyover_conditions_been_met())"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_behavior_def(behavior_name, conditional_callback, conditional_input_array_, default_smooth_up_, default_smooth_down_)
{
	AssertEx(IsString(behavior_name),													"VM2_begin_behavior_def() bad arg for behavior_name.");
	AssertEx(IsDefined(conditional_callback),											"VM2_begin_behavior_def() bad arg for conditional_callback.");
	AssertEx(IsDefined(self.behavior_data),												"VM2_begin_behavior_def() called before VM2_begin_behavior_data().");
	AssertEx(!IsDefined(self.behavior_data.behavior_under_construction),				"VM2_begin_behavior_def() called before previous VM2_end_behavior_def().");
	assert(IsArray(self.behavior_data.behaviors));
	AssertEx(!IsDefined(self.behavior_data.behaviors[behavior_name]),					"VM2_begin_behavior_def() attemp to define a behavior that allready exists: " + behavior_name);
	AssertEx(!IsDefined(conditional_input_array_) || IsArray(conditional_input_array_),	"VM2_begin_behavior_def() bad arg for <conditional_input_array_>");		
	
	vm = VM2x_get();
	
	// Create/init new behavior behavior.
	behavior				= SpawnStruct();
	behavior.oneshots		= [];
	behavior.loops			= []; //["ignore"];
	behavior.preset_name	= self VM2x_get_preset_name();
	behavior.param_maps		= [];

	// Store user params.
	behavior.name				= behavior_name;
	behavior.condition_callback	= conditional_callback;
	
	// Create param_map defaults for this loop.
	default_smooth_up_		= aud_get_optional_param(self.behavior_data.defaults.smooth_up,		default_smooth_up_);
	default_smooth_down_	= aud_get_optional_param(self.behavior_data.defaults.smooth_down,	default_smooth_down_);
	behavior VM2x_preset_set_param_map_defaults(default_smooth_up_, default_smooth_down_);
		
	// Attach new referece and mark as current behavior under construction.
	self.behavior_data.behaviors[behavior.name]		= behavior;
	self.behavior_data.behavior_under_construction	= behavior;
	
	if (IsArray(conditional_input_array_))
		VM2x_add_behavior_shortcut_param_maps(conditional_input_array_, self.behavior_data.defaults.smooth_up, self.behavior_data.defaults.smooth_down);
}

VM2_add_init_state_callback(init_state_callback)
{
	AssertEx(IsDefined(self.behavior_data.behavior_under_construction),	"VM2_add_exit_state_callback() called before VM2_begin_behavior_def().");
	self.behavior_data.behavior_under_construction.init_state_callback = init_state_callback;
}

VM2_add_in_state_callback(in_state_callback)
{
	AssertEx(IsDefined(self.behavior_data.behavior_under_construction),	"VM2_add_in_state_callback() called before VM2_begin_behavior_def().");
	self.behavior_data.behavior_under_construction.in_state_callback = in_state_callback;
}

/*
=============
///ScriptDocBegin
"Name: VM2_add_oneshots( <oneshot_names> )"
"Summary: Adds a set of oneshots to a state behavior."
"Module: Sound - Vehicle Manager"
"MandatoryArg: <oneshot_names>: Oneshot name or array of oneshot names that should be played when the upon entry of this state behavior. May be called multiple times within an beharior def block to add more oneshots."
"Example: VM2_add_oneshots(["pdrn_by_1", "pdrn_by_2"])"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_add_oneshots(oneshot_names)
{
	AssertEx(IsString(oneshot_names) || IsArray(oneshot_names),			"VM2_add_loop() bad arg for oneshot_names (must be loop name string or array of name strings).");
	AssertEx(IsDefined(self.behavior_data),								"VM2_add_oneshot() called before VM2_begin_behavior_data().");
	AssertEx(IsDefined(self.behavior_data.behavior_under_construction),	"VM2_add_oneshot() called before VM2_begin_behavior_def().");
	assert(IsDefined(self.oneshot_data.oneshots));
	
	if (IsString(oneshot_names))
		oneshot_names = [oneshot_names];
	
	foreach (oneshot_name in oneshot_names)
	{
		AssertEx(IsString(oneshot_name),									"VM2_add_oneshot() bad arg for <oneshot_name>.");
		AssertEx(IsDefined(self.oneshot_data.oneshots[oneshot_name]),		"VM2_add_oneshot() oneshot has not been defined: " + oneshot_name);
		
		// Get shortcut to oneshot owner.
		owner = self.behavior_data.behavior_under_construction;
		assert(IsArray(owner.oneshots));
		owner.oneshots[oneshot_name] = oneshot_name;
	}
}

/*
=============
///ScriptDocBegin
"Name: VM2_add_loops( <loop_names> )"
"Summary: Adds a loop item to a behavior definitition."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <loop_names>: Loop name string (or array of name strings) referencing a loop object(s) to play when the behavior's conditions have been met."
"Example: To specify loop playback: 1)	Have no affect on loops at all: Do not call VM2_add_loops() at all in the behavior def block. 2)	Turn on all loops: VM2_add_loops("ALL"); 3)	Turn off all loops: VM2_add_loops("NONE"), or VM2_add_loops([]), or VM2_add_loops(); 4)	Play only specific loops and turn off all others: VM2_add_loops( [ <loop1_name>, <loop2_name>, <loop3_name> ] );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_add_loops(loop_names)
{
	AssertEx(IsDefined(self.behavior_data),								"VM2_add_loop() called before VM2_begin_behavior_data().");
	AssertEx(IsDefined(self.behavior_data.behavior_under_construction),	"VM2_add_loop() called before VM2_begin_behavior_def().");
	assert(IsDefined(self.loop_data.loops));

	// Get shortcut to oneshot owner.
	owner = self.behavior_data.behavior_under_construction;
	
	// To Specify loop playback:
		//	1)	Have no affect on loops at all:						Do not call VM2_add_loops() at all in the behavior def block.
		//	2)	Turn on all loops:									VM2_add_loops("ALL");
		//	3)	Turn off all loops:									VM2_add_loops("NONE"), or VM2_add_loops([]), or VM2_add_loops();
		//	4)	Play only specific loops and turn off all others:	VM2_add_loops( [ <loop1_name>, <loop2_name>, <loop3_name> ] );
		
	// NOTE:  <loop_names> can also be a single loop name string (as a user shortcut).
		
	if (!IsDefined(loop_names) || loop_names.size == 0)	// Not defined or empty array means "none"
		loop_names = "none";
	
	if (IsString(loop_names))	// If it's a string, check for "all" or "none" keywords, otherwise it's a single loop name string.
	{
		if (ToLower(loop_names) == "all")
		{
			owner.loops[0] = "all";
		}
		else if (ToLower(loop_names) == "none")
		{
			owner.loops[0] = "none";
		}
		else
		{
			AssertEx(IsDefined(self.loop_data.loops[loop_names]), "VM2_add_loops() oneshot has not been defined: " + loop_names);
			owner.loops[loop_names] = loop_names;
		}
	}
	else
	{
		AssertEx(IsArray(loop_names),								"VM2_add_loop() bad arg for <loop_names>.");
		owner.loops[0] = undefined;
		
		foreach (loop_name in loop_names)
		{
			AssertEx(IsString(loop_name), "VM2_add_loop() bad arg for loop_name.");
			
			if (loop_name != "all" && loop_name != "none")
				AssertEx(IsDefined(self.loop_data.loops[loop_name]), "VM2_add_loops() loop has not been defined: " + loop_name);
	
			owner.loops[loop_name] = loop_name;
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_behavior_def()"
"Summary: Terminates a oneshot definition."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_behavior_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_behavior_def()
{
	AssertEx(IsDefined(self.behavior_data),								"VM2_end_behavior_def() called before VM2_begin_behavior_data().");
	AssertEx(IsDefined(self.behavior_data.behavior_under_construction),	"VM2_end_behavior_def() called before VM2_begin_behavior_def().");
	
	// Clear oneshot under construction.
	self.behavior_data.behavior_under_construction = undefined;
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_behavior_data()"
"Summary: Terminates construction of the oneshot data segment of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_behavior_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_behavior_data()
{
	AssertEx(IsDefined(self.behavior_data),								"VM2_end_behavior_data() called before VM2_begin_behavior_data().");
	AssertEx(!IsDefined(self.behavior_data.behavior_under_construction),	"VM2_end_behavior_data() called before VM2_end_behavior_def().");
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_state_data( <default_min_retrigger_time_> , <default_priority_> )"
"Summary: Initiates construction of the State Data segment of a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"OptionalArg: <default_min_retrigger_time_>: Default min re-trigger time in seconds to be used used for all states.  Default is 0.""
"OptionalArg: <default_priority_>: Default value to be used for all states.  Default is 50."
"Example: VM2_begin_state_data(undefined, 3.7)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_state_data(default_min_retrigger_time_, default_priority_)
{
	AssertEx(!IsDefined(self.state_data),	"VM2_begin_state_data() called multiple times.");
	if (IsDefined(default_min_retrigger_time_))
		default_min_retrigger_time_ *= 1000;	// Convert to mSecs.
	
	vm = VM2x_get(); // Get vm system struct.
	
	/*** Create/init state_data struct. ***/ 
	self.state_data								= SpawnStruct();
	self.state_data.state_groups				= [];
	self.state_data.defaults					= SpawnStruct();
	self.state_data.defaults.priority			= aud_get_optional_param(vm.def_priority,					default_priority_);
	self.state_data.defaults.min_retrigger_time	= aud_get_optional_param(vm.def_state_min_retrigger_time,	default_min_retrigger_time_);
}

/*
=============
///ScriptDocBegin
"Name: VM2_begin_state_group( <group_name> , <inital_state_name> , <inital_behavior> , <group_default_priority_> , <group_default_min_retrigger_time_> )"
"Summary: Initiates construction of a new state group within a preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <group_name>: Name of the group."
"MandatoryArg: <inital_state_name>: Specifies a group's initial state.
"MandatoryArg: <inital_behavior>: Specifies the initial state's associated conditional callback to be called when the vehicle starts.
"OptionalArg: <group_default_priority_>: Default priority for all states within the group.  Default is 50."
"OptionalArg: <group_default_min_retrigger_time_>: Default re-trigger time in seconds for all states within the group.  Default is 0."
"Example: VM2_begin_state_group("Turret_Rotation", "turret_idle", ::to_turret_idle_state)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_state_group(group_name, inital_state_name, inital_behavior_name, group_default_priority_,  group_default_min_retrigger_time_)
{
	AssertEx(IsDefined(self.state_data),							"VM2_begin_state_group() before VM2_begin_state_data().");
	AssertEx(IsString(group_name),									"VM2_begin_state_group(): bad arg for group_name.");
	AssertEx(IsString(inital_state_name),							"VM2_begin_state_group(): bad arg for inital_state_name.");
	AssertEx(IsString(inital_behavior_name),								"VM2_begin_state_group(): bad arg for inital_behavior_name.");
	assert(IsArray(self.state_data.state_groups));
	AssertEx(!IsDefined(self.state_data.state_groups[group_name]),	"VM2_begin_state_group() state group " + group_name + "already defined; over-writing.");
	
	if (IsDefined(group_default_min_retrigger_time_))
		group_default_min_retrigger_time_ *= 1000;	// Convert to mSecs.

	// Create/init new group
	group = SpawnStruct();
	group.name	= group_name;
	group.initial_state_name_pair		= [inital_state_name, inital_behavior_name];
	group.priority						= aud_get_optional_param(self.state_data.defaults.priority,				group_default_priority_);
	group.min_retrigger_time			= aud_get_optional_param(self.state_data.defaults.min_retrigger_time,	group_default_min_retrigger_time_);
	group.states						= [];
	
	// Add new group to group list & and mark it as currently under construction.
	self.state_data.state_groups[group_name] = group;
	self.state_data.group_under_construction = group;
}
		
/*
=============
///ScriptDocBegin
"Name: VM2_begin_state_def( <state_name> , <min_retrigger_time_> , <priority_> )"
"Summary: Initiates construction of a new state definition within a vehicle preset."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <state_name>: Name of new state."
"OptionalArg: <min_retrigger_time_>: Mininmum time in seconds that this state can be re-entered."
"OptionalArg: <priority_>: Priority of this state (in the case that conditions have been met to satisfy entry of multiple states)."
"Example: VM2_begin_state_def("flyover", 100, 5.0)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_begin_state_def(state_name, min_retrigger_time_, priority_)
{
	AssertEx(IsDefined(self.state_data),							"VM2_begin_state_def() before VM2_begin_state_data().");
	AssertEx(IsDefined(self.state_data.group_under_construction),	"VM2_begin_state_def() before VM2_begin_state_group().");
	assert(IsArray(self.state_data.group_under_construction.states));
	AssertEx(IsString(state_name),									"VM2_begin_state_def(): bad arg for state_name.");
	
	if (IsDefined(min_retrigger_time_))
		min_retrigger_time_ *= 1000;	// Convert to mSecs.
	
	group		= self.state_data.group_under_construction;
	group_name	= group.name;
	AssertEx(!IsDefined(group.states[state_name]),					"VM2_begin_state_def() state " + state_name + "already defined in " + group_name + "; over-writing.");
	
	// Create/init new state.
	state						= SpawnStruct();
	state.name					= state_name;
	state.transitions			= [];
	state.priority				= aud_get_optional_param(group.priority,			priority_);
	state.min_retrigger_time	= aud_get_optional_param(group.min_retrigger_time,	min_retrigger_time_);
	state.preset_name	 		= self VM2x_get_preset_name();
	
	// Add new state to current group's state list & mark as current state under construction.
	group.states[state_name] = state;
	self.state_data.group_under_construction.state_under_construction = state;
	
	/#
		// Create reference back to the state's parent state-group; only used for debugging.
		state.parent_state_group_name = group_name; 
	#/
}
			
/*
=============
///ScriptDocBegin
"Name: VM2_add_state_transition( <state_name> , <behavior_name> )"
"Summary: Adds a transition to the state currently under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <state_name>: Name of possible state to move to from this one."
"MandatoryArg: <behavior_name>: Oneshot behavior callback to call when going to the new state from the current one (this one... the one currently under construction)."
"Example: VM2_add_state_transition("flyby", ::to_flyby_from_death_dive_only)"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_add_state_transition(state_name, behavior_name)
{
	/#
	AssertEx(IsDefined(self.state_data),															"VM2_add_state_transition() before VM2_begin_state_data().");
	AssertEx(IsDefined(self.state_data.group_under_construction),									"VM2_add_state_transition() before VM2_begin_state_group().");
	AssertEx(IsDefined(self.state_data.group_under_construction.state_under_construction),			"VM2_add_state_transition() before VM2_begin_state_def().");
	
	one_frame_in_msecs = (0.05 * 1000);	// One frame in mSecs.
	if (	self.state_data.group_under_construction.state_under_construction.name == state_name &&
	    	self.state_data.group_under_construction.state_under_construction.min_retrigger_time < one_frame_in_msecs
	   )
	{
		AssertEx(self.state_data.group_under_construction.state_under_construction.min_retrigger_time >= one_frame_in_msecs, 
			"VM2_add_state_transition(): a state cannot *implicity* transition to itself unless it has a <min_retrigger_time> of at least one frame.");
		self.state_data.group_under_construction.state_under_construction.min_retrigger_time = one_frame_in_msecs;
	}
	#/
	
	state = self.state_data.group_under_construction.state_under_construction;
	assert(IsDefined(state.transitions));
	
	// Add transition pair to the current state's transition list.
	state.transitions[state.transitions.size] = [state_name, behavior_name];
}

/*
=============
///ScriptDocBegin
"Name: VM2_end_state_def()"
"Summary: Terminates the current state definition during preset construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_state_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_state_def()
{
	AssertEx(IsDefined(self.state_data),													"VM2_end_state_def() before VM2_begin_state_data().");
	AssertEx(IsDefined(self.state_data.group_under_construction),							"VM2_end_state_def() before VM2_begin_state_group().");
	AssertEx(IsDefined(self.state_data.group_under_construction.state_under_construction),	"VM2_end_state_def() before VM2_begin_state_def().");
	
	// Clear state under construction.
	self.state_data.group_under_construction.state_under_construction = undefined;
}
				
/*
=============
///ScriptDocBegin
"Name: VM2_end_state_group()"
"Summary: Terminates the current state group definition during preset construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_state_group()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_state_group()
{
	AssertEx(IsDefined(self.state_data),													"VM2_end_state_group() before VM2_begin_state_data().");
	AssertEx(IsDefined(self.state_data.group_under_construction),							"VM2_end_state_group() before VM2_begin_state_group().");
	AssertEx(!IsDefined(self.state_data.group_under_construction.state_under_construction),	"VM2_end_state_group() before VM2_end_state_def().");
	
	// Clear group under construction.
	self.state_data.group_under_construction = undefined;
}
			
/*
=============
///ScriptDocBegin
"Name: VM2_end_state_data()"
"Summary: Terminates the state data segment of a preset under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_state_data()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_state_data()
{
	AssertEx(IsDefined(self.state_data),	"VM2_end_state_data() before VM2_begin_state_data().");
}

/*
=============
///ScriptDocBegin
"Name: VM2_add_envelope( <env_name> , <env_data_or_function> )"
"Summary: Add's a data or function envelope to a preset under construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"MandatoryArg: <env_name>: Name of envelope."
"MandatoryArg: <env_data_or_function>: Envelope data array or function callback."
"Example: VM2_add_envelope("pdrn_rotor_vel2vol",
			[
				[kPDrn_MinSpeed,	kPDrn_Rotor_MinVol],
				[kPDrn_MaxSpeed,	kPDrn_Rotor_MaxVol]
			]
		);"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_add_envelope(env_name, env_data_or_function)
{
	AssertEx(IsDefined(env_name), "VM2_add_envelope(): bad <env_name> param.\n");
	if (IsString(env_name))
		env_name = ToLower(env_name);
	
	if (kVM2_use_optimized_envelopes)
	{
		VM2_add_envelope_optimized(env_name, env_data_or_function);
		return;
	}
	
	/#
	preset = self;
	preset_name = preset VM2x_get_preset_name();
	VM2x_validate_envelope(preset_name + " VM2_add_envelope()", env_name, env_data_or_function);
	#/
		
	vm = VM2x_get();
	AssertEx(IsDefined(vm.vehicle_under_construction),			"VM2_add_envelope() called, there is no vehicle under currently construction.");
	AssertEx(IsDefined(vm.vehicle_under_construction == self),	"VM2_add_envelope() called, but current vehicle def is not this one.");
	
	if (!IsDefined(self.env_data))
		self.env_data = [];

	AssertEx(!IsDefined(self.env_data[env_name]), "VM2_add_envelope(): Attemp to add an envelope to a preset that has already been defined: " + env_name + ". OVER-WRITING.\n");

	self.env_data[env_name] = env_data_or_function;
}

VM2_add_envelope_optimized(env_name, env_data_or_function)
{
	AssertEx(IsDefined(env_name), "VM2_add_envelope(): bad <env_name> param.\n");
	if (IsString(env_name))
		env_name = ToLower(env_name);
	/#
	preset = self;
	preset_name = preset VM2x_get_preset_name();
	VM2x_validate_envelope(preset_name + " VM2_add_envelope()", env_name, env_data_or_function);
	#/
		
	vm = VM2x_get();
	AssertEx(IsDefined(vm.vehicle_under_construction),			"VM2_add_envelope() called, there is no vehicle under currently construction.");
	AssertEx(IsDefined(vm.vehicle_under_construction == self),	"VM2_add_envelope() called, but current vehicle def is not this one.");
	
	if (!IsDefined(self.env_data))
		self.env_data = [];

	AssertEx(!IsDefined(self.env_data[env_name]), "VM2_add_envelope(): Attemp to add an envelope to a preset that has already been defined: " + env_name + ". OVER-WRITING.\n");

	env_data_struct = SpawnStruct();
	if(IsArray(env_data_or_function))
	{
		env_data_struct.env_array = [];
		foreach(point in env_data_or_function)
		{
			env_data_struct.env_array[env_data_struct.env_array.size] = ( point[0], point[1], 0 );
		}
	}
	else
	{
		env_data_struct.env_function = env_data_or_function;
	}
	
	self.env_data[env_name] = env_data_struct;
}

/#
VM2x_validate_envelope(error_msg_header, env_name, env_data)
{
	AssertEx(IsString(env_name),	error_msg_header + ": bad env_name.");
	AssertEx(IsDefined(env_data),	error_msg_header + ": bad env_data.");
	
	if (IsArray(env_data))
	{
		x = aud_get_envelope_domain(env_data);
		AssertEx(x[0] < x[1], error_msg_header + ": suspect envelope range in " + env_name);
	}
}
#/
	
/*
=============
///ScriptDocBegin
"Name: VM2_end_preset_def()"
"Summary: Terminates preset construction."
"Module: Sound - Vehicle Manager"
"CallOn: preset struct"
"Example: VM2_end_preset_def()"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_end_preset_def()
{
	vm = VM2x_get();
	AssertEx(IsDefined(vm.vehicle_under_construction),					"VM2_end_preset_def() called, there is no vehicle under currently construction.");
	AssertEx(IsDefined(vm.vehicle_under_construction == self),			"VM2_end_preset_def() called, but current vehicle def is not this one.");
	AssertEx(IsDefined(self.loop_data),									"VM2_end_preset_def(): loop_data has not been defined.");
	AssertEx(IsDefined(self.behavior_data),								"VM2_end_preset_def(): oneshot_data has not been defined.");
	AssertEx(IsDefined(self.state_data),								"VM2_end_preset_def(): state_data has not been defined.");
	
	AssertEx(!IsDefined(self.loop_data.loop_under_construction),		"VM2_end_preset_def(): loop still under construction.");
	AssertEx(!IsDefined(self.behavior_data.behavior_under_construction),	"VM2_end_preset_def(): oneshot still under construction.");
	AssertEx(!IsDefined(self.state_data.state_under_construction),		"VM2_end_preset_def(): state still under construction.");
	
	vm.vehicle_under_construction = undefined;
}

/****************************************************************************************************/
/********************************* END PRESET CONSTRUCTION API **************************************/
/****************************************************************************************************/

VM2x_get_master_volume()
{
	return self.master_volume;
}


/*
=============
///ScriptDocBegin
"Name: VM2_get_vehicle_snd_instance()"
"Summary: Get a vehicles sound instance."
"Module: Sound - Vehicle Manager"
"CallOn: A vehicle entity."
"Example: snd_instance = veh_ent VM2_get_vehicle_snd_instance();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_get_vehicle_snd_instance()
{
	return self.snd_instance;
}

/*
=============
///ScriptDocBegin
"Name: VM2_get_instance_name()"
"Summary: Get's a sound instance's name."
"Module: Sound - Vehicle Manager"
"CallOn: vehicle sound instance"
"Example: name = instance VM2_get_instance_name();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_get_instance_name()
{
	return self VM2x_get_instance_name();
}
	
/*
=============
///ScriptDocBegin
"Name: VM2_set_instance_master_volume( <target_volume> )"
"Summary: Sets the master volume of the instance."
"Module: Sound - Vehicle Manager"
"CallOn: vehicle instance"
"MandatoryArg: <target_volume>: New volume."
"OptionalArg: <fade_time_>: Time it takes to reach the new volume. Default is 1 second."
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_set_instance_master_volume(target_volume, fade_time_)
{
	thread VM2x_set_instance_master_volume(target_volume, fade_time_);
}

VM2x_set_instance_master_volume(target_volume, fade_time_)
{
	instance	= self;
	inst_name	= instance VM2x_get_instance_name();
	veh_ent		= instance VM2x_get_vehicle_entity();
		
	AssertEx(IsDefined(target_volume), "");
	target_volume	= clamp(target_volume, 0, 1);
	fade_time_		= clamp( aud_get_optional_param(1, fade_time_), 0, 60);
	
	end_thread_notify = inst_name;			// This is a singleton thread per loop: Ensure's that mutliple threads are not modfying the same loop's volume.
	instance notify(end_thread_notify);		// Kill current thread that might be modifying  this loop's volume.
	
	// Singnal thread termination conditions.
	instance	endon(end_thread_notify);
	level		endon("msg_snd_vehicle_stop");										// Entire vehicle system shutting down.
	level		endon("msg_snd_vehicle_stop_" + instance VM2x_get_instance_name());	// This instance is shutting down.
	veh_ent		endon("death");														// This instance's vehicle entity shutting down.
	
	update_rate				= VM2_get_update_rate();
	fade_amount				= target_volume - instance.master_volume;
	num_updates				= max(1, fade_time_/update_rate);
	fade_amount_per_update	= fade_amount/num_updates;
	
	while (1)
	{			   
		if (fade_amount_per_update < 0)			// Fading down.
		{
			if (instance.master_volume > target_volume)
				instance.master_volume = max(0, instance.master_volume + fade_amount_per_update);
			else
				break;
		}
		else if (fade_amount_per_update > 0)	// Fading up.
		{
			if (instance.master_volume < target_volume)
				instance.master_volume = min(1.0, instance.master_volume + fade_amount_per_update);
			else
				break;
		}

		wait update_rate;
	}
}


/*
=============
///ScriptDocBegin
"Name: VM2_get_running_instance_count()"
"Summary: Returns the current running instance count.  This is continually incremented as instances are created, but it is never decremented."
"Module: Sound - Vehicle Manager"
"CallOn: Any entity"
"Example: num_instances_ever_created = VM2_get_running_instance_count();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
VM2_get_running_instance_count(instance)
{
	return VM2x_get().running_intance_accumulator;
}

VM2_get_update_rate()
{
	return kVM2_UpdateRate;
}

VM2_get_vehicle_instance_count(preset_name_)
{
	result = 0;
	vm = VM2x_get();
	assert(IsDefined(vm.presets));
	
	if (IsString(preset_name_))
	{
		preset = vm.presets[preset_name_];
		if (IsDefined(preset) & IsArray(preset.instances))
			result = preset.instances.size;
	}
	else
	{
		foreach (preset in vm.presets)
		{
			if (IsArray(preset.instances))
				result += preset.instances.size;
		}
	}	
	
	return result;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												PRIVATE FUNCTIONS																//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
=============
"Name:		VM2x_create_preset(<preset_name>)"
"Summary:	Returns a preset, creating a new one if it doesn't already exist.
"CallOn:	Any entity.
=============
*/
VM2x_create_preset(preset_name)
{
	vm = VM2x_get(); 
	AssertEx(IsString(preset_name),								"VM2x_create_preset(): bad arg for preset_name\n.");
	AssertEx(IsDefined( vm.preset_constructors[preset_name]),	"VM2x_create_preset(): preset " + preset_name + "has not been registered.\n");
	preset_constructor = vm.preset_constructors[preset_name];
	
	// Create vehicle preset struct.
	preset				= SpawnStruct();
	preset.global_data	= SpawnStruct();
	preset.user_data	= SpawnStruct();
	preset.header		= SpawnStruct();
	preset.instances	= [];
	
	// Apply optional args.
	preset.header.preset_name		= aud_get_optional_param(undefined, preset_name);	// Can be supplied by preset_factory() below.
	preset.header.player_mode		= vm.def_player_mode;
	preset.header.fadein_time		= vm.def_fadein_time;
	preset.header.fadeout_time		= vm.def_fadeout_time;
	preset.header.sound_offset		= vm.def_sound_offset;
	
	// Create preset.	
	preset [[preset_constructor]]();	// Call supplied preset factory function to construct/configure the vehicle preset.
	/#
	new_preset_name = preset VM2x_get_preset_name();
	AssertEx(new_preset_name == preset_name, "VM2x_create_preset(): Preset constructor for " + preset_name + " changed the name of the preset to " + preset.header.preset_name + ".\n");
	#/
	
	// Add new preset to the preset list.
	preset VM2x_add_preset();
	
	return preset;
}

/*
=============
"Name:		VM2x_add_preset()"
"Summary:	Adds a new preset to the VMGR"
"CallOn:	A newly created vehicle manager preset struct."
=============
*/
VM2x_add_preset()
{
	vm = VM2x_get();
	AssertEx(IsDefined(self.header),							"VM2x_add_preset(): preset has no header.");
	AssertEx(IsString(self.header.preset_name),					"VM2x_add_preset(): preset has an invalid preset_name.");
	AssertEx(!IsDefined(vm.presets[self.header.preset_name]),	"VM2x_add_preset(): preset " + self.header.preset_name + " has already been added.");
	
	vm.presets[self.header.preset_name] = self;
}

/*
=============
"Name:		VM2x_reove_preset()"
"Summary:	Removes a preset from the VMGR"
"CallOn:	An existing vehicle manager preset struct."
=============
*/
VM2x_remove_preset()
{
	vm = VM2x_get();
	AssertEx(IsDefined(self.header),							"VM2x_remove_preset(): preset has no header.");
	AssertEx(IsString(self.header.preset_name),					"VM2x_remove_preset(): preset has an invalid preset_name.");
	AssertEx(IsDefined(vm.presets[self.header.preset_name]),	"VM2x_remove_preset(): preset " + self.header.preset_name + " was not previously added to the Vehicle Manager.");
	
	vm.presets[self.header.preset_name] = undefined;
}

/*
=============
"Name:		VM2x_add_instance()"
"Summary:	Adds a new preset instance to an existing VMGR preset.  Note that the preset must have been previously added to the VMGR.
"CallOn:	A newly created preset instance struct."
=============
*/
VM2x_add_instance()
{
	vm = VM2x_get();
	
	AssertEx(IsDefined(self.instance_name ),											"VM2x_add_instance(): preset has an invalid instance_name.");
	AssertEx(IsString(self.preset_name),												"VM2x_add_instance(): preset has an invalid preset_name.");
	assert(IsDefined(vm.presets));
	AssertEx(IsDefined(vm.presets[self.preset_name]),									"VM2x_add_instance(): preset " + self.preset_name + " was not previously added to the Vehicle Manager.");
	assert(IsDefined(vm.presets[self.preset_name].instances));
	AssertEx(!IsDefined(vm.presets[self.preset_name].instances[self.instance_name]),	"VM2x_add_instance(): preset " + self.preset_name + " was already added to the Vehicle Manager.");
	
	vm.presets[self.preset_name].instances[self.instance_name] = self;
	vm.running_intance_accumulator++;
}

/*
=============
"Name:		VM2x_remove_instance()"
"Summary:	Removes a existing preset instance from an existing VMGR preset.  Note both the preset and the instance must have been properly added.
"CallOn:	An existing preset instance struct."
=============
*/
VM2x_remove_instance()
{
	vm = VM2x_get();
	
	AssertEx(IsDefined(self.instance_name ),											"VM2x_remove_instance(): preset has an invalid instance_name.");
	AssertEx(IsString(self.preset_name),												"VM2x_remove_instance(): preset has an invalid preset_name.");
	assert(IsDefined(vm.presets));
	AssertEx(IsDefined(vm.presets[self.preset_name]),									"VM2x_remove_instance(): preset " + self.preset_name + " was not previously added to the Vehicle Manager.");
	assert(IsDefined(vm.presets[self.preset_name].instances));
	AssertEx(IsDefined(vm.presets[self.preset_name].instances[self.instance_name]),	"VM2x_remove_instance(): preset " + self.preset_name + " was not previously added to the Vehicle Manager.");
	
	vm.presets[self.preset_name].instances[self.instance_name] = undefined;
}

/*
=============
"Summary: Generates an instance name based on the preset name and running instance accumulator."
"CallOn: preset struct"
=============
*/
VM2x_generate_instance_name()
{
	assert(IsDefined(self.header));
	assert(IsDefined(self.header.preset_name));
	return self.header.preset_name + "_" + VM2_get_running_instance_count();
}

// Function.
VM2_register_callback(callback_name, callback_function, callback_userdata)
{
	assert(IsString(callback_name) && IsDefined(callback_function));
	VM2x_get().callbacks[callback_name] = [callback_function, callback_userdata];
}

// Called on instance.
// TODO: Potential bug unless state names are unquie accross state groups!
VM2x_get_instance_state_struct(state_name)
{
	instance = self;
	assert(IsString(state_name));
	ret_state = undefined;
	
	foreach (state_group in instance.state_group_list)
	{
		ret_state = state_group[state_name];
		if (IsDefined(ret_state))
			break;
	}
	
	assert(IsDefined(ret_state));
	return ret_state;
}

// Called on instance.
VM2x_get_behavior_instance_struct(behavior_name)
{
	instance = self;
	assert(IsString(behavior_name));
	assert(IsDefined(instance.behavior_list[behavior_name]));
	return instance.behavior_list[behavior_name];
}

// Called on preset.
VM2x_get_state_preset_struct(state_name)
{
	preset = self;
	assert(IsString(state_name));
	ret_state = undefined;
	
	foreach (state_group in preset.state_data.state_groups)
	{
		ret_state = state_group.states[state_name];
		if (IsDefined(ret_state))
			break;
	}
	
	assert(IsDefined(ret_state));
	return ret_state;
}

// Called on preset.
VM2x_get_behavior_preset_struct(behavior_name)
{
	preset = self;
	assert(IsString(behavior_name));
	assert(IsDefined(preset.behavior_data.behaviors[behavior_name]));
	return preset.behavior_data.behaviors[behavior_name];
}

/*
=============
"Summary: Returns an instance of a preset. "
"CallOn: preset struct"

	PRESET INSTANCE OVERVIEW:
			instance_name
			parent_preset_ref
			veh_ent
			
			loop_list[]					// list of structs, keyed by loop name
				snd_ent
				// Get the preset_loop_struct on the fly via loop name key and parent_preset_ref.
				io_struct->
					input_list[]	// list of floats, keyed by input name
					output_list[]	// list of floats, keyed by output name
			
			oneshot_list[]				// list of structs, keyed by oneshot name
				exlusive_snd_ents[]
				// Get the preset_loop_struct on the fly via loop name key and parent_preset_ref.
				io_struct->
					input_vals[]	// list of floats, keyed by input name
					output_vals[]	// list of floats, keyed by output name
					
			state_group_list[]		// list of structs, keyed by state name.  If state[name] doesn't exist, then defaults are used.
				state_list[]
					start_time	// optional.
=============
*/
VM2x_create_instance_struct(veh_ent, fadein_time, fadeout_time, offset, player_mode)
{
	preset = self;
		
	// CREATE/INIT INSTANCE STRUCT:
	instance					= SpawnStruct();
	instance.user_data			= SpawnStruct();
	instance.preset_name		= preset VM2x_get_preset_name();
	instance.instance_name		= preset VM2x_generate_instance_name();
	instance.veh_ent			= veh_ent;
	instance.fadein_time		= fadein_time;
	instance.fadeout_time		= fadeout_time;
	instance.sound_offset		= offset;
	instance.player_mode		= player_mode;
	instance.loop_duck_scalar	= 1.0;
	instance.oneshot_duck_vals	= [];
	instance.master_volume		= 1.0;
	
	// Init instance loop data.
	instance.loop_list = [];
	foreach (ps_snd_item in preset.loop_data.loops)
	{
		inst_snd_item			= SpawnStruct();
		inst_snd_item.ps_item	= ps_snd_item;
		inst_snd_item.play_mode	= kVM2x_LoopPlayState_Off;
		inst_snd_item.curr_io	= instance VM2x_create_param_io_struct(ps_snd_item);
		inst_snd_item.snd_ents	= [];
		inst_snd_item.volume	= 1.0;	// TODO:  Nee to reset this when owning state exits.
		
		instance.loop_list[ps_snd_item.name] = inst_snd_item;
	}
	
	// Init instance oneshot data.
	instance.oneshot_list = [];
	foreach (ps_snd_item in preset.oneshot_data.oneshots)
	{
		inst_snd_item			= SpawnStruct();
		inst_snd_item.ps_item	= ps_snd_item;
		inst_snd_item.curr_io	= instance VM2x_create_param_io_struct(ps_snd_item);
		inst_snd_item.snd_ents	= [];
		
		instance.oneshot_list[ps_snd_item.name]	= inst_snd_item;
	}	
	
	// Init instance behavior data.
	instance.behavior_list = [];
	foreach (ps_snd_item in preset.behavior_data.behaviors)
	{
		inst_snd_item			= SpawnStruct();
		inst_snd_item.ps_item	= ps_snd_item;
		inst_snd_item.curr_io	= instance VM2x_create_param_io_struct(ps_snd_item);
		
		instance.behavior_list[ps_snd_item.name]	= inst_snd_item;
	}	

	// Init instance state data.
	/#
		instance.debug_state_info = [];
	#/
	instance.state_group_list = [];
	foreach (ps_state_group_name, ps_state_group in preset.state_data.state_groups)
	{
		instance.state_group_list[ps_state_group_name] = [];
		assert(IsArray(ps_state_group.states));
		foreach (ps_state_name, ps_state in ps_state_group.states)
		{
			inst_state_item				= SpawnStruct();
			inst_state_item.ps_item		= ps_state;
			inst_state_item.start_time	= 0;
			/#
				// Create debug info for the state-group's dynamic data.
				instance.debug_state_info[ps_state_group_name] = SpawnStruct();
				instance.debug_state_info[ps_state_group_name].curr_state_name	= "";
			#/
				
			instance.state_group_list[ps_state_group_name][ps_state_name] = inst_state_item;
		}	
	}		
	
	// Call preset init callback if exists.
	if (IsDefined(preset.global_data.instance_init_callback))
		instance [[preset.global_data.instance_init_callback]](instance.user_data);
	
	/#
		instance.hud_deferred = false;
	#/
		
	return instance;
}


/*
=============
"Name: VM2x_start_instance( <preset_name> , <player_mode> , <fadein_time> , <fadeout_time> , <offset> , <initial_state_spec_> )"
"Summary: "
"CallOn: A vehilce entity"
"MandatoryArg: <preset_name>: "
"MandatoryArg: <player_mode>: "
"MandatoryArg: <fadein_time>: "
"MandatoryArg: <fadeout_time>: "
"MandatoryArg: <offset>: "
"OptionalArg: <initial_state_spec_>: "
"Example: "
=============
*/
VM2x_start_instance(preset_name, player_mode, fadein_time, fadeout_time, offset, initial_state_spec_)
{	
	veh_ent =  self;
	
	AssertEx(IsString(preset_name), "VM2x_start_instance(): preset_name is a mandatory parameter.");
	
	// Turnoff legacy vehicle audio.
	if (veh_ent VM2x_is_vehicle_proxy() == false)
		veh_ent Vehicle_TurnEngineOff();
	
	// Create new preset only if it doesn't already exist.
	preset = VM2x_get_preset(preset_name);
	if (!IsDefined(preset))
		preset = VM2x_create_preset(preset_name);
	AssertEx(IsDefined(preset), "VM2x_start_instance(): can't start preset: " + preset_name);
	
	// Create new preset instance struct.
	instance = preset VM2x_create_instance_struct(veh_ent, fadein_time, fadeout_time, offset, player_mode);
	
	// Add new instance struct to it's parent preset's intance list.
	instance VM2x_add_instance();
		
	// Launch loop update thread.
	instance thread VM2x_update_loops();
	
	// Launch a state thread for each state group.
	instance thread VM2x_launch_state_machines(initial_state_spec_);
	
	// Cleanup upon death.
	veh_ent thread VM2x_monitor_death(instance); 
	
	/#
	instance VM2x_hud_add_instance();	
	#/

	return instance;
}

/*
=============
"Summary: Stops an instance. "
"CallOn: A instance"
=============
*/
VM2x_stop_instance(fadeout_time_)
{
	if (!IsDefined(self.is_stopping))
	{
		self.is_stopping = true;
		
		instance		= self;
		preset			= instance VM2x_get_instance_preset();
		instance_name	= instance VM2x_get_instance_name();
		assert(IsString(instance_name));
		
		// Get fadeout time.
		fadeout_time_ = max(0.01, aud_get_optional_param(instance.fadeout_time, fadeout_time_));
		
		// Kill instance threads.
		level notify("msg_snd_vehicle_stop_" + instance_name);
		
		// Fade, stop, and cleanup all loops.
		foreach (loop in instance.loop_list)
		{
			fade_time = aud_get_optional_param(loop.ps_item.fadeout_time, fadeout_time_);
			loop thread VM2x_fade_stop_and_delete_sound_obj(fade_time);
		}
		
		// Fade, stop, and cleanup all oneshots.
		foreach (oneshot in instance.oneshot_list)
		{
			fade_time = aud_get_optional_param(oneshot.ps_item.fadeout_time, fadeout_time_);
			oneshot thread VM2x_fade_stop_and_delete_sound_obj(fade_time);
		}
		
		// Wait for all sound ents to fade/stop. TODO: Is this necessary?
		wait(fadeout_time_ + 0.05);	
				
		/#
		instance VM2x_hud_remove_instance();
		#/
			
		// Remove vehicle instance.
		instance VM2x_remove_instance();

	}
}

/*
=============
"Summary:  Upon vehicle entity death, stops and removes the preset instance.
"CallOn: A vehicle entity"
=============
*/
VM2x_monitor_death(instance)
{
	assert(IsDefined(instance));
	
	// End thread if insance is manually stopped.
	instance_name = instance VM2x_get_instance_name();
	assert(IsString(instance_name));
	level endon("msg_snd_vehicle_stop_" + instance_name);
	
	// Wait until the vehicle dies.
	self waittill("death");	
	
	// Stop the instance (which also removes it from the vehicle manager).
	instance thread VM2x_stop_instance();
}

/*
=============
"Summary:		Creates and initializes a param map owner's input/ouput arrays."
"CallOn:		"instance"
"MandatoryArg:	<ps_sound_item_struct> - A preset's "param map owner" struct (e.g., loop or state struct)"
"Returns:		<io_struct> - A struct to store the dynamic i/o values used by one of an intance's "param map owners" (e.g., loop or oneshot).
=============
*/
VM2x_create_param_io_struct(ps_sound_item_struct)
{	
	instance	= self;
	io_struct	= SpawnStruct();
	
	io_struct.smoothed_input	= [];
	io_struct.physical_output	= [];
			// Create the physical_output buffer:  an array defining the current output value of each output that any of the param_map evnvelope items feed.
			// That is, each param_map has a set of envelopes that map input to output.  They are are all scaled
			// to one final output value and stored in this keyed array (keyed bty output name).  
			// For example, all param_map envs that map to volume are scaled togeter to produce
			// one final volume level, which is stored here for final playback.	
	
	// Build and Initialize I/O param mapping values.
	foreach (input_item in ps_sound_item_struct.param_maps)
	{
		// Initialize smoothed input values to zero.
		io_struct.smoothed_input[input_item.input_name] = 0;
		
		// Initialize output values to 1.0 (similar outputs are scaled together to a final ouput value).
		foreach (env in input_item.envs)
		{	    
			if (!IsDefined(io_struct.physical_output[env.output_name]))
			     io_struct.physical_output[env.output_name] = 1.0;
		}
	}
	
	// "Fix" outputs that don't exist (user shortcut so don't have to add a dummy param map for unity pitch/volume).
	if (!IsDefined(io_struct.physical_output["volume"]))
		io_struct.physical_output["volume"] = 1.0;
	if (!IsDefined(io_struct.physical_output["pitch"]))
		io_struct.physical_output["pitch"] = 1.0;
	
	return io_struct;
}

/*
=============
"Name: VM2x_init_param_io_struct( <io_struct> )"
"Summary: Initializes a param map owner's previously created and input/ouput arrays."
"Module: instance"
"CallOn: An entity"
"MandatoryArg: <io_struct>: "
=============
*/
VM2x_init_param_io_struct(io_struct)
{	
	instance = self;
	assert(IsDefined(io_struct));
	
	foreach (key, val in io_struct.smoothed_input)
		io_struct.smoothed_input[key] = 0;
	
	foreach (key, val in io_struct.physical_output)
		 io_struct.physical_output[key] = 1.0;
}
	
/*
=============
"Name:		VM2x_get_current_instance_sound_item_input()"
"Summary:	Returns the current input array used by "
"CallOn:	inst_snd_item struct (e.g., loop or oneshot... any sound item that maps input to ouput)"
"Example:	inst_oneshot_struct VM2x_get_current_instance_sound_item_input()"
=============
*/
VM2x_get_current_instance_sound_item_input()
{
	assert(IsDefined(self.curr_io));
	assert(IsDefined(self.curr_io.smoothed_input));
	return self.curr_io.smoothed_input;
}

/*
=============
"Name:		VM2x_get_instance_sound_item_output()"
"Summary:	Returns the current input array used by "
"CallOn:	inst_snd_item struct (e.g., loop or oneshot... any sound item that maps input to ouput)"
"Example:	inst_oneshot_struct VM2x_get_instance_sound_item_output()"
=============
*/
VM2x_get_instance_sound_item_output()
{	
	assert(IsDefined(self.curr_io));
	assert(IsDefined(self.curr_io.smoothed_input));
	return self.curr_io.physical_output;
}

/*
=============
"Name:		VM2x_get_instance_sound_item_output()"
"Summary:	Returns the current current sound item volume "
"CallOn:	inst_snd_item struct (e.g., loop or oneshot... any sound item that maps input to ouput)"
"Example:	curr_vol = inst_oneshot_struct VM2x_get_instance_sound_item_volume()"
=============
*/
VM2x_get_instance_sound_item_volume()
{	
	inst_output = VM2x_get_instance_sound_item_output();
	assert(IsArray(inst_output));
	vol = inst_output["volume"];
	if (!IsDefined(vol))
		vol = 1.0;
	return vol;
}

/*
=============
"Summary:	MAIN LOOP THREAD:  Starts and continuously updates all loop ouput based on current input."
"CallOn:	instance struct"
=============
*/
VM2x_update_loops()
{
	instance	= self;
	preset		= VM2x_get_instance_preset();
	veh_ent		= VM2x_get_vehicle_entity();
		
	// Singnal thread termination conditions.
	level	endon("msg_snd_vehicle_stop");								// Entire vehicle system shutting down.
	level	endon("msg_snd_vehicle_stop_" + VM2x_get_instance_name());	// This instance is shutting down.
	veh_ent	endon("death");												// This instance's vehicle entity shutting down.
	
	
	//*********************************************************************//
	//********** MAIN UPDATE LOOP: Monitor input & update ouput. **********//
	//*********************************************************************//
	while (1)
	{	
		// Update loop ducking scalar.
		instance VM2x_update_loop_ducking_scalar();
		 
		foreach (loop in instance.loop_list)
		{	
			if (loop.play_mode == kVM2x_LoopPlayState_On)
			{
				loop_name = loop.ps_item.name;
				
				// Get current input values and map to current output values.
				instance VM2x_map_io(loop);
			
				// Update sound asset with mapped ouput params.
				instance VM2x_update_instance_loop_assets(loop);
			}		
		}
		
		wait(kVM2_UpdateRate);
	}
}


/*
=============
"Name: VM2x_set_loop_play_state( <inst_loop> , <state> )"
"Summary: "
"CallOn: instance"
"MandatoryArg: <inst_loop>: instance loop struct"
"MandatoryArg: <state>: kVM2x_LoopPlayState_On or kVM2x_LoopPlayState_Off"
=============
*/
VM2x_set_loop_play_state(inst_loop, state)
{
	instance	= self;
	
	switch (inst_loop.ps_item.asset_type)
	{
		case "alias":
			if (state == kVM2x_LoopPlayState_On && inst_loop.play_mode != kVM2x_LoopPlayState_On)
			{
				instance VM2x_start_loop(inst_loop);
				inst_loop.play_mode = kVM2x_LoopPlayState_On;
			}
			else if (state == kVM2x_LoopPlayState_Off && inst_loop.play_mode != kVM2x_LoopPlayState_Off)
			{
				instance VM2x_stop_loop(inst_loop);
				inst_loop.play_mode = kVM2x_LoopPlayState_Off;
			}
			else
			{
				assert(state == kVM2x_LoopPlayState_On || state == kVM2x_LoopPlayState_Off);
			}
			break;
		case "soundevent":
			break;
		case"damb":
			break;
		default:
			AssertEx(false, "Unsupported asset_type.\n");
			break;
	}
}

/*
=============
"Summary:		Calculates physical ouput values (e.g., volume, pitch, etc.) based on the current input values (e.g, speed, distance, etc.).
"CallOn:		instance"
"MandatoryArg:	<instance_sound_item>: an instance's loop or oneshot item struct"
"Example:		instance VM2x_map_io(inst_sound_struct);
=============
*/
VM2x_map_io(inst_sound_struct)
{
	instance		= self;
	preset			= VM2x_get_instance_preset();
	param_map_owner	= inst_sound_struct.ps_item;
	io_struct		= inst_sound_struct.curr_io;
	
	assert(IsDefined(preset));
	assert(IsDefined(param_map_owner));
	assert(IsDefined(io_struct));
	assert(IsArray(io_struct.smoothed_input));
	assert(IsArray(io_struct.physical_output));
	
	// First reset all ouputvalues to 1.0 (because existing values are scaled by new values).
	
	foreach (key, value in io_struct.physical_output)
		io_struct.physical_output[key] = 1.0;
	
	foreach (input_item in param_map_owner.param_maps)
	{
		// Get the raw input value.
		input_name		= input_item.input_name;
		input_callback	= VM2x_get_callback(input_name);
		targ_input_val	= instance [[input_callback]]();
		
		// Call input modifier if exist for this input.
		input_modifier_callback = param_map_owner.param_map_defaults.input_modifiers[ input_name ];
		if ( IsDefined( input_modifier_callback ) )
			targ_input_val = preset [[input_modifier_callback]](targ_input_val, instance.user_data);
					
		// Get current smoothed input value.
		assert( IsDefined(io_struct.smoothed_input[input_name]) );
		curr_input_val = io_struct.smoothed_input[input_name];
		
		// Choose appropriate smoothing coefficient.
		if (targ_input_val > curr_input_val)	// Is the input going up, or going down?
			smooth_operator =  input_item.smooth_up;
		else
			smooth_operator =  input_item.smooth_down;
		
		// Smooth the raw input value; store in io_struct.	
		new_input_val = curr_input_val + ( smooth_operator * (targ_input_val - curr_input_val) );
		
//		if (inst_sound_struct.ps_item.name == "prc_lyr2")	//if (param_map_owner.name == "to_state_driving")
//		{
//			smooth_up	= input_item.smooth_up;
//			smooth_down	= input_item.smooth_down;
//			IPrintLnBold("smooth_up=" + smooth_up + ", smooth_down=" + smooth_down + ", targ_input_val=" + targ_input_val + ", curr_input_val=" + curr_input_val);
//		}
		
		// Map and scale the new output value. (Note that ouput values can be affected by mulitiple input values, hence scaling rather than setting.)

		foreach (env_name, env_item in input_item.envs)
		{
			assert( IsDefined(io_struct.physical_output[env_item.output_name]) );
			io_struct.physical_output[env_item.output_name] *= preset VM2x_map_input(new_input_val, env_name);
		}

		// Store new smoothed input value.
		io_struct.smoothed_input[input_name] = new_input_val;
	}
}

/*
=============
"Summary:	Calc global loop ducking scalar."
"CallOn:	instance"
=============
*/
VM2x_update_loop_ducking_scalar()
{
	self.loop_duck_scalar = 1.0;
	foreach (scalar in self.oneshot_duck_vals)
	{
		self.loop_duck_scalar *= scalar;
	}
}

/*
=============
"Summary:	Send final output values to physical ouputs."
"CallOn:	instance_loop_item (loop struct referenced by a vehicle preset instance."
=============
*/
VM2x_update_instance_loop_assets(instance_loop_item)
{
	instance = self;
	
	foreach(output_name, output_value in instance_loop_item.curr_io.physical_output)
	{
		if (output_name == "volume")	// Apply loop ducking.
		{
			output_value *= instance.loop_duck_scalar;
			
			output_value *= instance_loop_item.volume;
		}

		foreach(snd_ent in instance_loop_item.snd_ents)
		{
			snd_ent VM2x_update_sound_ent_output_param(output_name, output_value);
		}
	}
}

VM2_set_loop_mute_state(loop_name, mute_state, fade_time_)
{
	instance = self;
	assert(IsString(loop_name));
	assert(IsDefined(instance.loop_list[loop_name]));
	
	inst_loop_struct = instance.loop_list[loop_name];
	
	target_vol = 1.0;
	if (mute_state == true)
		target_vol = 0;
	
	fade_time_ = aud_get_optional_param(0.05, fade_time_);
	
	fade_amount				= target_vol - inst_loop_struct.volume;
	num_updates				= max(1, fade_time_/VM2_get_update_rate());
	fade_amount_per_update	= fade_amount/num_updates;

	instance thread VM2x_set_loop_volume(inst_loop_struct, target_vol, fade_amount_per_update, VM2_get_update_rate());
}

VM2x_set_loop_volume(inst_loop_struct, vol, fade_amount_per_update, update_rate)
{
//	/* testing */ 
//	if (!IsDefined(level.vm_set_loop_volume_counter))
//		level.vm_set_loop_volume_counter = 0;
	
	instance	= self;
	veh_ent		= instance VM2x_get_vehicle_entity();
	
	assert(IsDefined(inst_loop_struct));
	assert(IsDefined(inst_loop_struct.volume));
	assert(IsDefined(vol));
	assert(vol >= 0 && vol <= 1.0);
	
//	/* testing */ end_thread_notify = inst_loop_struct.ps_item.name + level.vm_set_loop_volume_counter; 	
	
	end_thread_notify = inst_loop_struct.ps_item.name;	// This is a singleton thread per loop: Ensure's that mutliple threads are not modfying the same loop's volume.
	instance notify(end_thread_notify);					// Kill current thread that might be modifying  this loop's volume.

//	/* testing */ level.vm_set_loop_volume_counter++;
//	/* testing */ end_thread_notify = inst_loop_struct.ps_item.name + level.vm_set_loop_volume_counter;
	
	// Singnal thread termination conditions.
	instance	endon(end_thread_notify);
	level		endon("msg_snd_vehicle_stop");										// Entire vehicle system shutting down.
	level		endon("msg_snd_vehicle_stop_" + instance VM2x_get_instance_name());	// This instance is shutting down.
	veh_ent		endon("death");														// This instance's vehicle entity shutting down.
	
	while (1)
	{
//	/* testing */ IPrintLnBold("VM2x_set_loop_volume() " + end_thread_notify);
				   
		if (fade_amount_per_update < 0)			// Fading down.
		{
			if (inst_loop_struct.volume > vol)
				inst_loop_struct.volume = max(0, inst_loop_struct.volume + fade_amount_per_update);
			else
				break;
		}
		else if (fade_amount_per_update > 0)	// Fading up.
		{
			if (inst_loop_struct.volume < vol)
				inst_loop_struct.volume = min(1.0, inst_loop_struct.volume + fade_amount_per_update);
			else
				break;
		}

		wait update_rate;
	}
}


/*
=============
"Summary:	Starts and continuously updates state transitions (which trigger behaviors) for all state-groups."
"Note:		This function does not need to be threaded, as it simply launches each state-group thread.
"CallOn:	instance struct"
=============
*/
VM2x_launch_state_machines(initial_state_keyed_array_)
{
	instance	= self;
	preset		= VM2x_get_instance_preset();
	
	assert( IsArray( instance.state_group_list ) );
	assert( IsArray( instance.behavior_list ) );
	
	// For each State Group:
	//	- Get default "intital state/behavior pair" from preset.
	//	- Allow optional parameter overrides.
	//	- Locate instance's state/behavior pair corresponding to the intital state/behavior pair.
	//	- Start state machine:  instance thread VM2x_state_enter_action_function(initial_inst_state_struct, initial_inst_behavior_struct);	 
	foreach (ps_state_group_name, ps_state_group in preset.state_data.state_groups)
	{
		assert( IsArray( instance.state_group_list[ps_state_group_name] ) );	// Assert ps state group exists in the instance.
		assert( IsArray( ps_state_group.states ) );								// Assert ps state group has a statelist array.

		// Get default initial state/behavior name pairfrom preset (two-dim array - initial state/behavior name pairs for each group).
		initial_state_name_pair	= ps_state_group.initial_state_name_pair;
		
		// Allow optional param override.
		if (IsArray(initial_state_keyed_array_))
		{
			AssertEx( IsArray( initial_state_keyed_array_[ps_state_group_name] ),	"VM2x_launch_state_machines() bad initial_state_name_pair arg.\n" );
			initial_state_name_pair = initial_state_keyed_array_[ps_state_group_name];	// key=group_name, val=state_name.
		}
		AssertEx( IsArray( initial_state_name_pair ),								"VM2x_launch_state_machines() bad initial_state_name_pair arg.\n" );
		
		// Get inital state/behavior names.
		initial_state_name		= initial_state_name_pair[0];
		initial_behavior_name	= initial_state_name_pair[1];
		
		// Make sure the names are valid and exist in the preset.
		AssertEx( IsString( initial_state_name ),										"VM2x_launch_state_machines() bad initial_state_name arg.\n" );
		AssertEx( IsDefined( ps_state_group.states[initial_state_name] ),				"VM2x_launch_state_machines() initial_state_name not found in preset.\n" );
		AssertEx( IsString( initial_behavior_name ),									"VM2x_launch_state_machines() bad initial_behavior_name arg.\n" );
		AssertEx( IsDefined( preset.behavior_data.behaviors[initial_behavior_name] ),	"VM2x_launch_state_machines() initial_behavior_name not found in preset.\n" );
		
		// Get instance structs associated with the preset data for initial_state_name/initial_behavior_name.
		assert( IsDefined( instance.state_group_list[ps_state_group_name][initial_state_name] ) );
		assert( IsDefined( instance.behavior_list[initial_behavior_name] ) );
		inst_initial_state_struct		= instance.state_group_list[ps_state_group_name][initial_state_name];
		inst_initial_behavior_struct	= instance.behavior_list[initial_behavior_name];
						
		// Update the behavior's current input values and map to current output values.
		instance VM2x_map_io(inst_initial_behavior_struct);
		
		// Tell the next initial_state_name state to perform it's Enter Action.
		instance thread VM2x_state_enter_action_function(inst_initial_state_struct, inst_initial_behavior_struct);
	}
}

/*
=============
"Summary:	MAIN STATE THREAD: 
			1) Plays it's associated beavior's oneshots and loops, 
			2) Determines which state to go to next via each of it's transition states' Conditional_Functions,
			3) Performs the current sate's Exit_Action function,
			4) Threads off the new state's Enter_Action function."
"CallOn:	instance struct"
"MandatoryArg: <inst_curr_state_struct>: An instance sub-structure representing a new state being entered."
"MandatoryArg: <inst_curr_behavior_struct>: An instance sub-structure representing the behavior item to be executed upon entry. "
"Example: instance thread VM2x_state_enter_action_function(inst_initial_state_struct, inst_initial_behavior_struct);"
=============
*/
VM2x_state_enter_action_function(inst_curr_state_struct, inst_curr_behavior_struct)
{
	instance	= self;
	preset		= instance VM2x_get_instance_preset();
	ps_state	= inst_curr_state_struct.ps_item;
	veh_ent		= instance VM2x_get_vehicle_entity();
	
	// Singnal thread termination conditions.
	level	endon("msg_snd_vehicle_stop");								// Entire vehicle system shutting down.
	level	endon("msg_snd_vehicle_stop_" + VM2x_get_instance_name());	// This instance is shutting down.
	veh_ent	endon("death");												// This instance's vehicle entity shutting down.
		
	// Init current state instance run-time vars.
	inst_curr_state_struct.start_time = GetTime();
	//IPrintLnBold("STARTING: " + inst_curr_state_struct.ps_item.name + " at " + inst_curr_state_struct.start_time);
	
	/#
		instance VMx2_debug_set_instance_current_state_info(inst_curr_state_struct, inst_curr_behavior_struct);
	#/
		
	//********** PERFORM STATE ENTRANCE ACTION **********/
	instance VM2x_state_enter_action_init_data(		inst_curr_state_struct,	inst_curr_behavior_struct);
	instance VM2x_state_enter_action_play_oneshots(	inst_curr_state_struct,	inst_curr_behavior_struct);
	instance VM2x_state_enter_action_play_loops(	inst_curr_state_struct,	inst_curr_behavior_struct);
	
	// Call enter-state callback if exists.
	if (IsDefined(inst_curr_behavior_struct.ps_item.init_state_callback))
	{
		instance [[inst_curr_behavior_struct.ps_item.init_state_callback]](instance.user_data);
	}
		
	//********** DETERMINE WHICH STATE TO MOVE TO NEXT **********/
	inst_next_state			= undefined;
	inst_next_behavior		= undefined;
	next_oneshot_overrides	= undefined;
	temp_oneshot_overrides_	= undefined;
	
	while (true)
	{			
		// Call in-state callback if exists.
		if (IsDefined(inst_curr_behavior_struct.ps_item.in_state_callback))
		{
			instance VM2x_map_io(inst_curr_behavior_struct);
			instance [[inst_curr_behavior_struct.ps_item.in_state_callback]](inst_curr_behavior_struct.curr_io.smoothed_input, instance.user_data);
		}
		
		// Transition to next state if necessary.
		foreach (transition_set in ps_state.transitions)
		{
			// Determine next state candidate(s).
			trans_state_name		= transition_set[0];
			trans_behavior_name		= transition_set[1];
			trans_loop_names		= transition_set[2];
			inst_candidate_state	= instance VM2x_get_instance_state_struct(trans_state_name);	
			inst_candidate_behavior	= instance VM2x_get_behavior_instance_struct(trans_behavior_name);
			ps_candidate_state		= inst_candidate_state.ps_item;
			ps_candidate_behavior	= inst_candidate_behavior.ps_item;
					
			// If candate retrigger time has not yet expired, then ignore this candidate.
			if ((GetTime() - inst_candidate_state.start_time) < ps_candidate_state.min_retrigger_time) 
				continue;
			
			// Update the behavior's current input values and map to current output values.
			instance VM2x_map_io(inst_candidate_behavior);
			
			// Call behavior's conditional callback to see if current input indicates that we should move to this state.
			candiate_result = instance VM2x_state_condition_function(inst_candidate_state, inst_candidate_behavior);
				// NOTE: If the conditions have been met, candiate_result can be either <true> or an array of oneshot's to play upon state entry.
			if (IsArray(candiate_result))	// Callback returned an "on-the-fly" alias set to play upon entering this state.
			{
				temp_oneshot_overrides_ = candiate_result;
				candiate_result = true;
			}
			
			// Candidate input conditions have been met?
			if (candiate_result) 
			{
				// If the next candidate has a higher priority than the current candidate, then take take it's place.
				if (!IsDefined(inst_next_state) || ps_candidate_state.priority > inst_next_state.ps_item.priority)
				{
					inst_next_state			= inst_candidate_state;	
					inst_next_behavior		= inst_candidate_behavior;
					next_oneshot_overrides	= temp_oneshot_overrides_;
					temp_oneshot_overrides_		= undefined;
				}
			}
		}
		
		// Moving to next state.
		if (IsDefined(inst_next_state))
			break;

		wait(kVM2_UpdateRate);
	}
	
	//********** HANDLE ONESHOT OVERRIDES **********/
	instance VM2x_set_behavior_oneshot_overrides(inst_next_behavior, next_oneshot_overrides);		// Set (or clear) next behavior's oneshot overrides.
	next_restricted_oneshots = instance VM2x_get_behavior_restricted_oneshots(inst_next_behavior);	// Only stop curr state's restricted oneshots if the next state has any restricted oneshots.
	stop_curr_restricted_oneshots = next_restricted_oneshots.size > 0;
	
	//********** PERFORM STATE EXIT ACTION **********/
	instance thread VM2x_state_exit_action_function(inst_curr_behavior_struct, stop_curr_restricted_oneshots);
	
	//********** TRANSITION TO NEXT STATE **********/
	instance thread VM2x_state_enter_action_function(inst_next_state, inst_next_behavior);
}

VM2x_state_enter_action_init_data(inst_state_struct,	inst_behavior_struct)
{
	instance	= self;
	ps_behavior	= inst_behavior_struct.ps_item;
	
	if (IsDefined(ps_behavior.loops[0]))
	{
		assert(IsString(ps_behavior.loops[0]));
		if (ps_behavior.loops[0] == "all")
		{
			foreach(inst_loop_struct in instance.loop_list)
			{
				inst_loop_struct.volume = 1.0;
			}
		}
	}
	else
	{
		foreach(loop_name in ps_behavior.loops)
		{
			assert(IsDefined(instance.loop_list[loop_name]));
			inst_loop_struct = instance.loop_list[loop_name];
			inst_loop_struct.volume = 1.0;
		}
	}
}
	

/*
=============
"Name: 			VM2x_state_exit_action_function( <behavior_struct> , <stop_restricted_oneshots> )"
"Summary:		Performs state-exit operations: Stops all excusive or restricted (if requested) oneshots that are still playing."
"CallOn:		instance."
"MandatoryArg:	<behavior_struct>: Instance's currently executing state behavior struct."
"MandatoryArg:	<stop_restricted_oneshots>: boolean indicating if oneshots should be stopped or not."
"Example:		instance thread VM2x_state_exit_action_function(inst_curr_behavior_struct, stop_restricted_oneshots);"
=============
*/
VM2x_state_exit_action_function(behavior_struct, stop_restricted_oneshots)
{
	instance					= self;
	preset						= instance VM2x_get_preset();
	ps_behavior_oneshot_list	= behavior_struct.ps_item.oneshots;

	// Stop Sounds.
	foreach (oneshot_name in ps_behavior_oneshot_list)
	{
		inst_oneshot	= instance.oneshot_list[oneshot_name];
		oneshot_mode	= inst_oneshot.ps_item.oneshot_poly_mode;
		
		if ( (oneshot_mode == kVM2_OneshotMode_Exclusive) || (oneshot_mode == kVM2_OneshotMode_Restricted && stop_restricted_oneshots) )
		{
			// Remove sound ents from list.
			snd_ents				= inst_oneshot.snd_ents;
			inst_oneshot.snd_ents	= [];
			fadeout_time			= inst_oneshot.ps_item.fadeout_time;
			
			// Fade and delete each sound ent.
			foreach (key, snd_ent in snd_ents)
			{
				snd_ent thread VM2x_stop_and_delete_sound_ent(fadeout_time);
			}
		}
	}
	
	// TODO: Need to clear the io structs for THIS state's loops, oneshots, and behavior (not for every single one in the entire instance).
	// This is causing odd behavior when re-entering a state, beause the io starts off where it left off last time (especially noticible for long smoothing times).
	//instance VM2x_init_instance_param_io_structs();  
}

/*
=============
"Name: VM2x_fadeout_snd_obj( <fadeout_time> )"
"Summary: "
"CallOn: snd_obj (instance's oneshot or loop object)"
"MandatoryArg: <fadeout_time>: "
=============
*/
VM2x_fade_sound_obj(fadeout_time_)
{
	snd_obj			= self;
	fadeout_time_	= max(0.01, aud_get_optional_param(0.05, fadeout_time_));
	
	switch (snd_obj.ps_item.asset_type)
	{
		case "alias":
			foreach (key, snd_ent in snd_obj.snd_ents)
			{
				if (IsDefined(snd_ent))
				{
					snd_ent SetVolume(0, fadeout_time_);
					wait(fadeout_time_);
					
					if (IsDefined(snd_ent))
						snd_ent StopSounds();
				}		
			}
			break;
		case "soundevent":
			break;
		case "damb":
			break;		
		default:break;
	}	
}

/*
=============
"Name: VM2x_stop_and_delete_sound_ent( <fadeout_time_> )"
"Summary: Allows stopping sound ents concurrently - fades, stops, and deletes a sound entity."
"CallOn:  A sound entity."
"OptionalArg: <fadeout_time_>: "
"Example: snd_ent thread VM2x_stop_and_delete_sound_ent(fadeout_time);"
=============
*/
VM2x_stop_and_delete_sound_ent(fadeout_time_)
{
	snd_ent = self;
	
	if (IsDefined(snd_ent))
	{
		fadeout_time_ = aud_get_optional_param(0.05, fadeout_time_);
		
		snd_ent SetVolume(0, fadeout_time_);
		
		wait(fadeout_time_);
		if (IsDefined(snd_ent))
			snd_ent StopSounds();
		
		wait(0.05);
		if (IsDefined(snd_ent))
			snd_ent Delete();
	}
}

/*
=============
"Name: VM2x_state_condition_function( <candidate_behavior> )"
"Summary: Calls a presets state conditional callback with current, smoothed input values. Callback returns true (or an array of override oneshots to play) if the state should be ENTERED. "
"CallOn: instance"
"MandatoryArg: <inst_candidate_state>: An instance state struct."
"MandatoryArg: <inst_candidate_oneshot>: An instance oneshot-behavior struct."
"Example: instance VM2x_state_condition_function(inst_candidate_state, inst_candidate_oneshot)"
=============
*/
VM2x_state_condition_function(inst_candidate_state, inst_candidate_oneshot)
{
	result		= false;
	instance	= self;
	
	assert( IsDefined( inst_candidate_oneshot ) );
	assert( IsDefined( inst_candidate_oneshot.ps_item ) );
	assert( IsDefined( inst_candidate_oneshot.ps_item.condition_callback ) );
	assert( IsDefined( inst_candidate_oneshot ) );
	assert( IsDefined( inst_candidate_oneshot.curr_io ) );
	assert( IsDefined( inst_candidate_oneshot.curr_io.smoothed_input ) );
	assert( IsDefined( instance.user_data ) );
	
	result = instance [[inst_candidate_oneshot.ps_item.condition_callback]](inst_candidate_oneshot.curr_io.smoothed_input, instance.user_data);
	
	return result;
}

// Called on State Instance.
/*
=============
"Summary: Plays the oneshots assocated with entering a new state."
"CallOn: instance"
"MandatoryArg: <inst_state_struct>: state of an instance being entered."
"MandatoryArg: <inst_behavior_struct>: behavior to execute upon state entry."
"Example: instance VM2x_state_enter_action_play_oneshots(inst_state_struct, inst_behavior_struct);"
=============
*/
VM2x_state_enter_action_play_oneshots(inst_state_struct, inst_behavior_struct)
{
	instance			= self;
	preset				= instance VM2x_get_instance_preset();
	ps_state_struct		= inst_state_struct.ps_item;
	ps_behavior_struct	= inst_behavior_struct.ps_item;

	oneshot_names = inst_behavior_struct.oneshot_overrides;
	if (!IsDefined(oneshot_names))
	   oneshot_names = ps_behavior_struct.oneshots;
			
	foreach (oneshot_name in oneshot_names)
	{
		inst_oneshot_struct	= instance.oneshot_list[oneshot_name];
		ps_oneshot_struct	= inst_oneshot_struct.ps_item;
		oneshot_mode		= instance VM2x_get_oneshot_poly_mode(oneshot_name);
		continuous_update	= instance VM2x_get_oneshot_update_mode(oneshot_name);
		
		if (ps_oneshot_struct.asset_type == "alias")
		{
			// Get current input values and map to current output values.
			instance VM2x_map_io(inst_oneshot_struct);
			
			for (index = 0; index < ps_oneshot_struct.asset_names.size; index++)
			{
				// START SOUND.
				snd_ent = instance VM2x_start_oneshot_alias(inst_oneshot_struct, index);
				
				// UPDATE SOUND: Set snd_ent's initial param values.
				foreach (output_name_key, output_value in inst_oneshot_struct.curr_io.physical_output)
				{
					snd_ent VM2x_update_sound_ent_output_param(output_name_key, output_value);	
				}
				
				if (continuous_update)
				{
					//instance delaythread(VM2_get_update_rate(), ::VM2x_continuously_update_snd_ent, inst_oneshot_struct, snd_ent);
					// TODO: Ask Tom F. why using delayThread() above causes the doppler script to fail because it's accessing a removed veh entity.
					instance thread VM2x_continuously_update_snd_ent(inst_oneshot_struct, snd_ent);
				}
				
				// STORE SOUND: Store next restricted inst_oneshot_struct sound ent so we can turn it off later.
				if (oneshot_mode == kVM2_OneshotMode_Restricted || oneshot_mode == kVM2_OneshotMode_Exclusive)
					inst_oneshot_struct.snd_ents[index] = snd_ent;
			}
						
			// Handle ducking for this oneshot.
			instance thread VM2x_handle_oneshot_ducking(inst_oneshot_struct);
		}	
	}
}

VM2x_continuously_update_snd_ent(inst_oneshot_struct, new_snd_ent)
{
	instance			= self;
	veh_ent				= instance VM2x_get_vehicle_entity();
	updte_rate			= VM2_get_update_rate();
	
	level endon("msg_snd_vehicle_stop");									
	level endon("msg_snd_vehicle_stop_" + instance VM2x_get_instance_name());
	veh_ent endon("death");
	
	wait updte_rate;	// Initial params were alredy set when this function was called.
	
	while (IsDefined(new_snd_ent))
	{		
		instance VM2x_map_io(inst_oneshot_struct);
				
		if (IsDefined(new_snd_ent))
		{
			foreach (output_name_key, output_value in inst_oneshot_struct.curr_io.physical_output)
			{
				//IPrintLnBold(output_name_key + ", " + output_value);
				new_snd_ent VM2x_update_sound_ent_output_param(output_name_key, output_value);
			}
		}
		
		wait updte_rate;	// Do this first because caller has already done it once this update.
	}
}


VM2x_state_enter_action_play_loops(inst_state_struct, inst_behavior_struct)
{
	instance				= self;
	preset					= instance VM2x_get_instance_preset();
	ps_state_struct			= inst_state_struct.ps_item;
	ps_behavior_struct		= inst_behavior_struct.ps_item;
	behavior_loops_to_start	= ps_behavior_struct.loops; 
	
	if (IsDefined(behavior_loops_to_start[0]))
	{
		if (behavior_loops_to_start[0] == "all")
		{
			foreach(loop_name, inst_loop_struct in instance.loop_list)
				VM2x_set_loop_play_state(inst_loop_struct, kVM2x_LoopPlayState_On);
		}
		else if (behavior_loops_to_start[0] == "none")
		{
			foreach(loop_name, inst_loop_struct in instance.loop_list)
				VM2x_set_loop_play_state(inst_loop_struct, kVM2x_LoopPlayState_Off);
		}
		else
		{
			assert(false || !GetDebugDvarInt(kVM2_dvar_vm_debug));
		}
	}
	else if (behavior_loops_to_start.size > 0)
	{	
		start_list	= [];
		stop_list	= [];
		
		foreach(loop_name, inst_loop_struct in instance.loop_list)
		{
			if (IsDefined(behavior_loops_to_start[loop_name]))
			    start_list[loop_name] = inst_loop_struct;
			else
				stop_list[loop_name] = inst_loop_struct;
		}
		
		foreach (loop_name, inst_loop_struct in start_list)
			VM2x_set_loop_play_state(inst_loop_struct, kVM2x_LoopPlayState_On);
		
		foreach (loop_name, inst_loop_struct in stop_list)
			VM2x_set_loop_play_state(inst_loop_struct, kVM2x_LoopPlayState_Off);
	}
}

/************************************************/
/*************** DEFAULT CALLBACKS **************/
/************************************************/

/*** INPUT CALLBACKS. ***/
// CALLED ON SND VEHICLE INSTANCE

input_callback_distance2d()
{
	veh_ent = self VM2x_get_vehicle_entity();
	assert(IsDefined(veh_ent));
	return Distance2D(veh_ent.origin, level.player.origin);	
}

input_callback_distance()
{
	veh_ent = self VM2x_get_vehicle_entity();
	assert(IsDefined(veh_ent));
	return Distance(veh_ent.origin, level.player.origin);	
}

input_callback_throttle()
{
	veh_ent = self VM2x_get_vehicle_entity();
	assert(IsDefined(veh_ent));
	return veh_ent Vehicle_GetThrottle();
}

// Returns the current speed of the vehicle.
input_callback_speed()
{
	veh_ent = self VM2x_get_vehicle_entity();
	assert(IsDefined(veh_ent));
	
	speed = Length( ( veh_ent Vehicle_GetVelocity() ) * kVM2_MPHPerInchesPerSecond);
	//return veh_ent VM2x_Vehicle_GetSpeed(); TODO:  Apparenly GetSpeed doesn't really give you the lenght of the velocity, so we may need two functions, one for forward speed and one for speed in any direction.
	return speed;
}

// CALLED ON SND VEHICLE INSTANCE
// Returns the lenght of the relative velocity between the vehicle and the player.
input_callback_relative_speed()
{
	veh_ent = self VM2x_get_vehicle_entity();
	assert(IsDefined(veh_ent));
	//return veh_ent VM2x_Vehicle_GetSpeed();
	
	vehicle_velocity	= veh_ent Vehicle_GetVelocity();
	player_velocity		= level.player GetVelocity();
	relative_velocity	= vehicle_velocity - player_velocity;
	vector_length		= Length(relative_velocity) * kVM2_MPHPerInchesPerSecond;
	
	return vector_length;
}

input_callback_speed_mph()
{
	veh_ent = self VM2x_get_vehicle_entity();
	return (veh_ent get_differentiated_speed()) * kVM2_MPHPerInchesPerSecond;
}
	
input_callback_acceleration_g()
{
	veh_ent = self VM2x_get_vehicle_entity();
	return Length(veh_ent get_differentiated_acceleration()) * kVM2_GPerInchesPerSecSquared;
}

input_callback_jerk_gps()
{
	veh_ent = self VM2x_get_vehicle_entity();
	return Length(veh_ent get_differentiated_jerk()) * kVM2_GPerInchesPerSecSquared;
}

input_callback_doppler()
{
	veh_ent = self VM2x_get_vehicle_entity();
	return DopplerPitch(veh_ent.origin, veh_ent Vehicle_GetVelocity(), level.player.origin, level.player GetVelocity());
}

input_callback_doppler_exaggerated()
{
	veh_ent = self VM2x_get_vehicle_entity();	
	return DopplerPitch(veh_ent.origin, veh_ent Vehicle_GetVelocity(), level.player.origin, level.player GetVelocity(), 2, 5);
}

input_callback_doppler_subtle()
{
	veh_ent = self VM2x_get_vehicle_entity();
	return DopplerPitch(veh_ent.origin, veh_ent Vehicle_GetVelocity(), level.player.origin, level.player GetVelocity(), 1, 0.5);
}

// given the sound source's and the player's position and velocity, determine the pitch shift due to doppler effect.
// the last three args are optional, and if you don't pass them in you'll get a physically accurate result
// - origins must be vectors, in game units
// - velocities must be vectors in game units per second (not per frame).
// - exaggerate_closeness, if you raise it above one, will make it seem that the sound source is passing that much closer to you, and so the
//     blending from high to low pitch if it were to whiz by you would be faster
// - exaggerate_pitch, if you raise it above 1, will amplify the pitch shift by that amount.
// - speed_of_sound_ips is the speed of sound in inches (game units) per second, and the default is physically accurate.
VM2x_compute_doppler_pitch(source_origin, source_velocity, listener_origin, listener_velocity, exaggerate_closeness, exaggerate_pitch, speed_of_sound_ips)
{
     if(!IsDefined(exaggerate_closeness)) exaggerate_closeness = 1;
     if(!IsDefined(exaggerate_pitch))     exaggerate_pitch     = 1;
     if(!IsDefined(speed_of_sound_ips))   speed_of_sound_ips   = 13397;
     Assert(exaggerate_closeness != 0);
     
     // we exaggerate the closeness by moving the listener_origin closer to the line of the source's velocity
     if(exaggerate_closeness != 1)
     {
           source_velocity_in_listener_frame = source_velocity - listener_velocity;
           source_velocity_in_listener_frame_dir = VectorNormalize(source_velocity_in_listener_frame);
           source_to_listener = listener_origin - source_origin;
           source_to_listener_parallel = source_velocity_in_listener_frame_dir * VectorDot(source_velocity_in_listener_frame_dir, source_to_listener);
           source_to_listener_perpendicular = source_to_listener - source_to_listener_parallel;
           listener_origin = source_origin + source_to_listener_parallel + source_to_listener_perpendicular / exaggerate_closeness;
     }
     
     // this part is all physically accurate (other than ignoring lag in source speed changes)
     listener_to_source_dir = VectorNormalize(source_origin - listener_origin); 
     projected_source_speed = VectorDot(source_velocity, listener_to_source_dir);
     projected_listener_speed = VectorDot(listener_velocity, listener_to_source_dir);   
     pitch = (speed_of_sound_ips + projected_listener_speed) / (speed_of_sound_ips + projected_source_speed);
     
     // exaggerate the pitch change
     pitch = pow(pitch, exaggerate_pitch);
     
     // the engine doesn't like pitch scales above 2
     pitch = clamp(pitch, .1, 1.99);
     
     return pitch;
}

input_callback_pitch()
{
	veh_ent = self VM2x_get_vehicle_entity();
	pitch = veh_ent.angles[0];
	
	//player_angles = level.player GetPlayerAngles();
	//pitch = player_angles[0];
	
	return pitch;
}

input_callback_yaw()
{
	veh_ent = self VM2x_get_vehicle_entity();
	yaw = veh_ent.angles[1];
	
	//player_angles = level.player GetPlayerAngles();
	//yaw = player_angles[1];
	return yaw;
}

/************************************************/
/*************** MISC UTILS *********************/
/************************************************/

/*
=============
"Name: VM2x_start_oneshot_alias( <ps_oneshot_asset_struct> )"
"Summary: "
"CallOn: instance"
"MandatoryArg: <ps_oneshot_asset_struct>: An asset struct, contained in a oneshot struct, contained in a preset."
"Example: snd_ent = instance VM2x_start_oneshot_alias(oneshot);"
=============
*/
VM2x_start_oneshot_alias(inst_oneshot_struct, index)
{
	instance				= self;
	ps_oneshot_asset_struct	= inst_oneshot_struct.ps_item;
	snd_ent					= undefined;
	
	// Get the sound alias.
	assert(IsDefined(index));
	alias = instance VM2x_get_sound_alias(ps_oneshot_asset_struct, index);
	if (IsString(alias))
	{
		// Play the sound.
		veh_ent = instance VM2x_get_vehicle_entity();
		snd_ent = spawn("script_origin", veh_ent.origin);
		snd_ent linkto(veh_ent, "tag_origin", instance.sound_offset, (0,0,0));
		snd_ent ScaleVolume(0);
		snd_ent snd_play(alias, "sound_done");
		snd_ent thread VM2x_monitor_oneshot_done("sound_done");
	}
	
	return snd_ent;	
}

VM2x_monitor_oneshot_done(notify_string)
{
	self endon( "death" );
	
	assert(IsDefined(self));
	self waittill(notify_string);
	if (IsDefined(self))
		self Delete();
}

/*
=============
"Name: VM2x_IsPlayerMode()"
"Summary: "
"CallOn: instance"
"Returns: true or false."
"Example: instance VM2x_IsPlayerMode()"
=============
*/
VM2x_IsPlayerMode()
{
	return IsDefined(self.player_mode) && self.player_mode;
}

/*
=============
"Name: VM2x_get_sound_alias( <ps_sound_obj> , <index_> )"
"Summary: Returns a sound alias name."
"CallOn: instance"
"MandatoryArg: <ps_sound_obj>: A preset loop object or oneshot asset object."
"OptionalArg: <index_>: Alias index (default is zero)."
"Returns: A sound alias name string. "
"Example: instance VM2x_get_sound_alias(loop_or_oneshot_obj)"
=============
*/
VM2x_get_sound_alias(ps_sound_obj, index_)
{
	instance = self;
	assert(IsDefined(ps_sound_obj));
	assert(IsDefined(ps_sound_obj.asset_names));
		   
	alias = ps_sound_obj.asset_names[ aud_get_optional_param(0, index_) ];
	if (IsDefined(alias) && instance VM2x_IsPlayerMode())
		alias += "_plr";
	return alias;
}

/*
=============
"Name: VM2x_get_sound_alias_count(ps_sound_obj)"
"Summary: Returns a sound alias name."
"CallOn: instance"
"MandatoryArg: <ps_sound_obj>: A preset loop object or oneshot asset object."
"Returns: Number of aliases in the sound object. "
"Example: instance VM2x_get_sound_alias_count(loop_or_oneshot_obj)"
=============
*/
VM2x_get_sound_alias_count(ps_sound_obj)
{
	assert(IsDefined(ps_sound_obj));
	assert(IsDefined(ps_sound_obj.asset_names));
	return ps_sound_obj.asset_names.size;
}

// Called on Sound Alias Entity.
VM2x_update_sound_ent_output_param(output_name, output_value)
{
	switch(output_name)
	{
		case "volume":
			assert(output_value >= 0 && output_value <= 1.0 || !GetDebugDvarInt(kVM2_dvar_verify_aliases));
			self ScaleVolume(output_value, kVM2_UpdateRate);
			break;
		case "pitch":
			assert(output_value >= 0 || !GetDebugDvarInt(kVM2_dvar_verify_aliases));	// TODO: What is the max range for pitch?
			self ScalePitch(output_value, kVM2_UpdateRate);
			break;
		default:
			break;	
	}	
}

/*
=============
"Name: VM2x_handle_oneshot_ducking( <inst_oneshot_struct> )"
"Summary: Adds a oneshot's ducking scalar to a vehicle instance, applies a temporal envelope, and then removes the oneshot's ducking scalar from the vehicle instance."
"CallOn: instance"
"MandatoryArg: <snd_ents>: list of playing oneshot sound enities."
"Example: instance thread VM2x_handle_oneshot_ducking(ps_oneshot_asset_struct, snd_ents);
=============
*/
VM2x_handle_oneshot_ducking(inst_oneshot_struct) 
{
	instance = self;
	ps_oneshot_asset_struct = inst_oneshot_struct.ps_item;
	
	assert(IsDefined(ps_oneshot_asset_struct));
	assert(IsDefined(inst_oneshot_struct));
	assert(IsArray(inst_oneshot_struct.snd_ents));
	              
	// SETUP: Add this duck scalar to vehicle.
	instance VM2x_add_oneshot_ducking_scalar(ps_oneshot_asset_struct.name);
	
	// ACTION: Call this function synchronously; when it returns, do cleanup.
	instance VM2x_update_oneshot_duck_scalar(inst_oneshot_struct);
	
	// CLEANUP: Remove this duck scalar to vehicle.
	instance VM2x_remove_oneshot_ducking_scalar(ps_oneshot_asset_struct.name);
}

/*
=============
"Name:			VM2x_update_oneshot_duck_scalar( <inst_oneshot_struct> )"
"Summary:		Updates the current loop ducking amount while snd_ent is valid based on the oneshot's time-based envelope."
"CallOn:		instance"
"MandatoryArg:	<inst_oneshot_struct>: oneshot struct that is playing sounds."
"Example: "
=============
*/
VM2x_update_oneshot_duck_scalar(inst_oneshot_struct) 
{
	assert(IsDefined(inst_oneshot_struct));
	assert(IsDefined(inst_oneshot_struct.ps_item));
	assert(IsArray(inst_oneshot_struct.snd_ents));
	instance				= self;
	preset					= instance VM2x_get_instance_preset();
	ps_oneshot_asset_struct	= inst_oneshot_struct.ps_item;
	
	level endon("msg_snd_vehicle_stop");									// Entire vehicle system shutting down.
	level endon("msg_snd_vehicle_stop_" + instance VM2x_get_instance_name());	// This instance is shutting down.
	instance VM2x_get_vehicle_entity() endon("death");							// This instance's veh_ent shutting down.
	
	assert( IsDefined(ps_oneshot_asset_struct) );
	if ( IsDefined( ps_oneshot_asset_struct.duck_env_name ) )
	{
		env	= preset VM2x_get_envelope(ps_oneshot_asset_struct.duck_env_name);
		env_domain = aud_get_envelope_domain(env);
		time = 0;
		
		assert(time >= env_domain[0] && time <= env_domain[1]);
		max_env_time = env_domain[1];
		oneshot_name = ps_oneshot_asset_struct.name;
		while (VM2x_are_all_defined(inst_oneshot_struct.snd_ents) && time < max_env_time)
		{
			// Calc current oneshot duck scalar based on duck envelope and current oneshot volume (e.g., scale the duck amount by the curr oneshot volume so we duck proportionally.
			oneshot_volume		= inst_oneshot_struct VM2x_get_instance_sound_item_volume();
			curr_duck_scalar	= preset VM2x_map_input(time, ps_oneshot_asset_struct.duck_env_name);
			curr_duck_scalar	= (1.0 - (oneshot_volume * (1.0 - curr_duck_scalar)) );
			
			instance VM2x_set_oneshot_ducking_scalar(oneshot_name, curr_duck_scalar);
			
			wait(kVM2_UpdateRate);
			time = time + kVM2_UpdateRate;
		}
	}
}

VM2x_are_all_defined(ent_array)
{
	assert(IsArray(ent_array));
	
	result = true;
	foreach (ent in ent_array)
	{
		if (!IsDefined(ent))
		{
			result = false;
			break;
		}
	}
	return result;
}

// Called on instance.
VM2x_add_oneshot_ducking_scalar(oneshot_name)
{
	self.oneshot_duck_vals[oneshot_name] = 1.0;
}

// Called on instance.
VM2x_remove_oneshot_ducking_scalar(oneshot_name)
{
	self.oneshot_duck_vals[oneshot_name] = undefined;
}

// Called on instance.
VM2x_set_oneshot_ducking_scalar(oneshot_name, value)
{
	self.oneshot_duck_vals[oneshot_name] = value;
}

VM2x_normalize_ranged_value(input, range_low, range_high)
{
	assert(IsDefined(input) & IsDefined(range_low) & IsDefined(range_high));
	assert(range_low < range_high);
	assert(range_low >= range_low && input <= range_high);
	
	return (input - range_low)/(range_high - range_low);
}

		
/************************************************/
/*************** ACCESS FUNCTIONS ***************/
/************************************************/

/*
=============
"Summary: Gets the root vehicle manager struct."
"CallOn: An any entity."
=============
*/
VM2x_get()
{
	assertEx(IsDefined(level._audio), "Vehicle Manager called before initalizing Audio System.");
	assertEx(IsDefined(level._audio.vm), "Vehicle Manager used before initalizing Vehicle System system.");
	return level._audio.vm;
}

/*
=============
"Summary: Returns instance's vehicle entity."
"CallOn: Any entity."
=============
*/
VM2x_get_callback(callback_name)
{
	assert(IsString(callback_name) && IsArray(VM2x_get().callbacks[callback_name]) && IsDefined(VM2x_get().callbacks[callback_name][0]));
	return VM2x_get().callbacks[callback_name][0];
}

/*
=============
"Summary: Returns the name of a preset."
"CallOn: preset struct"
=============
*/
VM2x_get_preset_name()
{
	return self.header.preset_name;
}

/*
=============
"Summary: Sets the name of a preset."
"CallOn: preset struct"
=============
*/
VM2x_set_preset_name(preset_name)
{
	self.header.preset_name = preset_name;
}

VM2x_set_instance_init_callback(instance_init_callback_)
{
	assert(IsDefined(self.global_data));
	self.global_data.instance_init_callback = instance_init_callback_;
}

/#
/*
=============
"Summary: Sets an instance's state-group's current state info (for debugging only)."
"CallOn: instance"
=============
*/
VMx2_debug_set_instance_current_state_info(inst_curr_state_struct, inst_curr_behavior_struct)
{
	assert(IsDefined(inst_curr_state_struct));
	assert(IsDefined(inst_curr_state_struct.ps_item));
	assert(IsString(inst_curr_state_struct.ps_item.name));
	assert(IsString(inst_curr_state_struct.ps_item.parent_state_group_name));
	assert(IsDefined(self.debug_state_info));
	
	group_name		= inst_curr_state_struct.ps_item.parent_state_group_name;
	inst_state_info	= self.debug_state_info[group_name];
	
	inst_state_info.curr_state_name		= inst_curr_state_struct.ps_item.name;
	inst_state_info.curr_behavior_name	= inst_curr_behavior_struct.ps_item.name;
}

/*
=============
"Summary: Gets an instance's state-group's current state name (for debugging only)."
"CallOn: instance"
=============
*/
VMx2_debug_get_instance_current_state_name(state_group_name)
{
	assert(IsString(state_group_name));
	assert(IsDefined(self.debug_state_info));
	assert(IsDefined(self.debug_state_info[state_group_name]));
	assert(IsString(self.debug_state_info[state_group_name].curr_state_name));
	
	return self.debug_state_info[state_group_name].curr_state_name;
}

/*
=============
"Summary: Gets an instance's state-group's current oneshot name (for debugging only)."
"CallOn: instance"
=============
*/
VMx2_debug_get_instance_current_behavior_name(state_group_name)
{
	assert(IsString(state_group_name));
	assert(IsDefined(self.debug_state_info));
	assert(IsDefined(self.debug_state_info[state_group_name]));
	assert(IsString(self.debug_state_info[state_group_name].curr_state_name));
	
	return self.debug_state_info[state_group_name].curr_behavior_name;
}
#/

/*
=============
"Summary: Returns the name of an instance."
"CallOn: instance struct"
=============
*/
VM2x_get_instance_name()
{
	assert(IsDefined(self));
	assert(IsString(self.instance_name));
	return self.instance_name;
}

/*
=============
"Summary: Returns the name of an instance's parent preset."
"CallOn: instance struct"
=============
*/
VM2x_get_instance_preset_name()
{
	assert(IsDefined(self));
	assert(IsString(self.preset_name));
	return self.preset_name;
}

/*
=============
"Summary: Returns instance's parent preset."
"CallOn: instance struct"
=============
*/
VM2x_get_instance_preset()
{
	assert(IsDefined(self));
	assert(IsString(self.preset_name));
	
	return VM2x_get_preset(self.preset_name);
}

/*
=============
"Summary: Returns a vehicle preset struct, or undefined if the preset does not exist."
"CallOn: Anything."
=============
*/
VM2x_get_preset(preset_name)
{
	result = undefined;
	if (IsString(preset_name))
	{
		vm = VM2x_get();
		assert(IsDefined(vm.presets));
		result = vm.presets[preset_name];
	}
	return result;
}

/*
=============
"Summary: Returns a vehicle instance struct."
"CallOn: Anything."
=============
*/
VM2x_get_instance(instance_name, preset_name_)
{
	result = undefined;
	vm = VM2x_get();
	assert(IsString(instance_name));
	assert(IsDefined(vm.presets));

	if (IsString(preset_name_))
	{
		preset = VM2x_get_preset(preset_name_);
		if (IsDefined(preset))
		{
			assert(IsArray(preset.instances));
			result = preset.instances[instance_name];
		}
	}
	else
	{
		foreach (preset in vm.presets)
		{
			assert(IsDefined(preset.instances));
			foreach (intsance in preset.instances)
			{
				assert(IsString(intsance.instance_name));
				if (intsance.instance_name == instance_name)
				{
					result = intsance;
					break;
				}
			}
		}
	}
	
	return result;
}

/*
=============
"Summary: Returns instance's vehicle entity."
"CallOn: instance struct."
=============
*/
VM2x_get_vehicle_entity()
{
	return self.veh_ent;
}

/*
=============
"Summary: Returns vehicle entity's sound instance."
"CallOn: A vehicle entity."
=============
*/
VM2x_get_sound_instance()
{
	return self.snd_instance;
}

/*
=============
"Summary: Returns a preset's fade in time."
"CallOn: preset struct."
=============
*/
VM2x_get_fadein_time()
{
	return self.header.fadein_time;;
}

/*
=============
"Summary: Returns a preset's fade out time."
"CallOn: preset struct."
=============
*/
VM2x_get_fadeout_time()
{
	return self.header.fadeout_time;;
}

// call on instance
VM2x_set_behavior_oneshot_overrides(inst_behavior, oneshot_overrides_array_)
{
	inst_behavior.oneshot_overrides = oneshot_overrides_array_;
}

// Called on an instance.
VM2x_get_behavior_restricted_oneshots(inst_behavior_struct)
{
	assert(IsDefined(inst_behavior_struct));
	instance	= self;
	result		= [];
	ps_behavior	= inst_behavior_struct.ps_item;
	preset		= VM2x_get_preset(ps_behavior.preset_name);
	assert(IsDefined(preset));
	
	onshot_names = inst_behavior_struct.oneshot_overrides;			
	if (!IsDefined(onshot_names))	
    	onshot_names = ps_behavior.oneshots;		
	assert(IsArray(onshot_names));
	
	foreach (oneshot_name in onshot_names)
	{
		//if (instance VM2x_oneshot_is_restricted(oneshot_name))
		//	result[oneshot_name] = oneshot_name;
		
		if (instance VM2x_get_oneshot_poly_mode(oneshot_name) == kVM2_OneshotMode_Restricted)
			result[oneshot_name] = oneshot_name;
	}
		
	return result;
}

//// Called on an instance.
//VM2x_oneshot_is_restricted(oneshot_name)
//{
//	instance	= self;
//	assert(IsDefined(instance.oneshot_list[oneshot_name]));
//	assert(IsDefined(instance.oneshot_list[oneshot_name].ps_item));
//	
//	oneshot_preset_struct = instance.oneshot_list[oneshot_name].ps_item;
//		
//	return oneshot_preset_struct.oneshot_poly_mode == kVM2_OneshotMode_Restricted;
//}

VM2x_get_oneshot_poly_mode(oneshot_name)
{
	instance	= self;
	assert(IsDefined(instance.oneshot_list[oneshot_name]));
	assert(IsDefined(instance.oneshot_list[oneshot_name].ps_item));
	
	oneshot_preset_struct = instance.oneshot_list[oneshot_name].ps_item;
		
	return oneshot_preset_struct.oneshot_poly_mode;
}

VM2x_get_oneshot_update_mode(oneshot)
{
	instance	= self;
	mode		= 0;
	
	assert(IsDefined(oneshot));
	
	if (IsString(oneshot))	// It's a oneshot name string.
	{
		assert(IsDefined(instance.oneshot_list[oneshot]));
		assert(IsDefined(instance.oneshot_list[oneshot].ps_item));
		oneshot_preset_struct = instance.oneshot_list[oneshot].ps_item;
	}
	else					// It's a instance oneshot struct.
	{
		oneshot_preset_struct = oneshot.ps_item;
	}
	
	mode = oneshot_preset_struct.oneshot_update_mode;
	if (!IsDefined(mode))
		mode = 0;
	
	return mode;
}

/*
=============
"Name: VM2x_get_envelope( <env_name_or_function> )"
"Summary: Get's named envelope data from factory."
"CallOn: preset"
"MandatoryArg: <env_name_or_function>: "
=============
*/
VM2x_get_envelope(env_name)
{
	assert(IsArray(self.env_data));
	AssertEx(IsDefined(self.env_data[env_name]), "VM2x_get_envelope() can't find envelope data for " + env_name + " in preset " + self VM2x_get_preset_name());
	
	return self.env_data[env_name];
}

/*
=============
"Name: VM2x_map_input( <input> , <mapper> )"
"Summary: Maps an input value to an output value through a preset's envelope."
"CallOn: preset"
"MandatoryArg: <input>: input value"
"MandatoryArg: <env_name>: name of preset envelope array or function through which the input should be mapped to an ouput."
"Example: preset VM2x_map_input(new_input_val, env_name)"
=============
*/
VM2x_map_input(input, env_name)
{
	if (kVM2_use_optimized_envelopes)
		return VM2x_map_input_optimized(input, env_name);
			
	preset = self;
	mapper = preset VM2x_get_envelope(env_name);
	result = 0;
	
	if ( IsArray( mapper ) )
	{
		result = PiecewiseLinearLookup(input, mapper);
	}
	else
		result = [[mapper]](input);			// It's a function;
	
	return result;
}

VM2x_map_input_optimized(input, env_name)
{
	preset = self;
	env_data_struct = preset VM2x_get_envelope(env_name);
	
	
	if(IsDefined(env_data_struct.env_function))
	{
		result = [[env_data_struct.env_function]](input);
	}
	else
	{
		// find min from the envelope
		assert(IsArray(env_data_struct.env_array));
		assert(env_data_struct.env_array.size >= 2);
		
		result = PiecewiseLinearLookup(input, env_data_struct.env_array);
	}
	
	return result;
}

VM2x_start_loop(inst_loop)
{
	instance		= self;
	preset			= instance VM2x_get_instance_preset();
	veh_ent			= instance VM2x_get_vehicle_entity();
	ps_loop			= inst_loop.ps_item;
	alias_count		= preset VM2x_get_sound_alias_count(ps_loop);
	//stop_notify_msg	= "loop_stop_notify_" + instance VM2x_get_instance_name() + "_" + ps_loop.name;
	offset			= instance.sound_offset;
	
	for (index = 0; index < alias_count; index++)
	{
		alias = instance VM2x_get_sound_alias(ps_loop, index);
		//notify_msg	= stop_notify_msg + "_" + alias;
		
		snd_ent = spawn("script_origin", veh_ent.origin);
		snd_ent linkto(veh_ent, "tag_origin", offset, (0, 0, 0));
		//snd_ent SetVolume(0);
		snd_ent ScaleVolume(0);
		snd_ent snd_play_loop(alias);
		
		inst_loop.snd_ents[alias] = snd_ent;
	}
}

VM2x_stop_loop(inst_loop)
{
	instance			= self;
	snd_ents			= inst_loop.snd_ents;
	inst_loop.snd_ents	= [];
	
	foreach (snd_ent in snd_ents)
	{
		snd_ent thread VM2x_fade_delete_snd_ent(inst_loop.ps_item.fadeout_time);
	}
}

VM2x_fade_delete_snd_ent(fadeout_time_)
{
	snd_ent			= self;
	fadeout_time_	= max(0.05, aud_get_optional_param(0.05, fadeout_time_));

	if (IsDefined(snd_ent))
	{
		snd_ent SetVolume(0, fadeout_time_);
		wait fadeout_time_;
		
		if (IsDefined(snd_ent))
			snd_ent StopSounds();
		
		wait 0.05;
		if (IsDefined(snd_ent))
			snd_ent Delete();
	}		
}

/*
=============
"Name: VM2x_fadeout_vehicle( <fadeout_time> )"
"Summary: "
"CallOn: instance"
"MandatoryArg: <fadeout_time>: "
=============
*/
VM2x_fadeout_vehicle(fadeout_time)
{
	instance = self;
	
	// Fade out loops.
	foreach (loop in instance.loop_list)
		loop VM2x_fade_stop_and_delete_sound_obj(fadeout_time);
		
	// Fade out oneshots.
	foreach (oneshot in instance.oneshot_list)
		oneshot VM2x_fade_stop_and_delete_sound_obj(fadeout_time);
}

/*
=============
"Name: VM2x_fadeout_snd_obj( <fadeout_time> )"
"Summary: "
"CallOn: snd_obj (instance's oneshot or loop object)"
"MandatoryArg: <fadeout_time>: "
=============
*/
VM2x_fade_stop_and_delete_sound_obj(fadeout_time_)
{
	snd_obj = self;
	
	switch (snd_obj.ps_item.asset_type)
	{
		case "alias":
			foreach (key, snd_ent in snd_obj.snd_ents)
			{
				snd_ent VM2x_stop_and_delete_sound_ent(fadeout_time_);
				snd_obj.snd_ents[key] = undefined;
			}
			break;
		case "soundevent":
			break;
		case"damb":
			break;	
	}	
}

// Called on vehicle instance.
VM2x_delete_vehicle_sound_ents()
{
	instance = self;
	
	// Fade out loops.
	foreach (loop in instance.loop_list)
	{
		switch (loop.ps_item.asset_type)
		{
			case "alias":
				loop.snd_ents thread VM2x_stop_and_delete_sound_ent(0.05);
				loop.snd_ents = [];
				break;
			case "soundevent":
				break;
			case "damb":
				break;	
			default:
				AssertEx(false, "Unsupported asset_type.\n");
				break;				
		}		
	}	

	// Fade out oneshots.
	foreach (oneshot in instance.oneshot_list)
	{
		foreach (snd_ent in oneshot.snd_ents)
		{
			snd_ent thread VM2x_stop_and_delete_sound_ent(0.05);
		}
		oneshot.snd_ents = [];
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												"MACROS"																		//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
units2yards(units)
{
	return units * kVM2_units2yards_scalar;
}

yards2units(yards)
{
	return yards * kVM2_yards2units_scalar;
}

dist2yards(dist)
{
	return dist * kVM2_units2yards_scalar;
}

yards2dist(yards)
{
	return yards * kVM2_yards2units_scalar;
}

/#	
//------------ BEGIN DEBUG SCRIPT------------//
// Called on instance.
// TODO: THIS IS DEBUG INFO DRAWING ON THE ACTUAL VEHICLE; STILL NEEDS TO FUNCTION.
VM2x_debug_veh_ent()
{
	instance = self;
	
	self thread VM2x_debug_monitor_ducking();
		
	if (kVM2_Debug3D)
		self thread VM2x_debug_monitor_3d();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//												"HUD"																			//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

VM2x_hud_init()
{
	vm = VM2x_get();
	
	SetDvarIfUninitialized(kVM2_dvar_hud_mode, "0");
	//SetDvar(kVM2_dvar_hud_mode, "1");
	
	VM2x_hud_set_mode( VM2x_get_hud_dvar_value() );
	
	thread VM2x_hud_monitor_update_mode();
	thread VM2x_hud_monitor_deferred_instances();
	
	vm.hud_color[ "red" ]		= ( 1, 0, 0 );
	vm.hud_color[ "blue" ]		= ( 0, 0, 1 );
	vm.hud_color[ "yellow" ]	= ( 1, 1, 0 );
	vm.hud_color[ "cyan" ]		= ( 0, 1, 1 );
	vm.hud_color[ "green" ]		= ( 0, 1, 0 );
	vm.hud_color[ "purple" ]	= ( 1, 0, 1 );
	vm.hud_color[ "orange" ]	= ( 1, 0.5, 0 );

}
	
/*
=============
"Name:		VM2x_hud_reinit(curr_mode_)"
"Summary:	Re-initializes the hud based on the new hud mode.  Used for when user dynamically changes the hud mode dvar so the display will instantly respond."
"CallOn:	anything"
"OptionalArg: <curr_mode_>: defaults to kVM2_hud_mode_silent."
=============
*/
VM2x_hud_reinit(curr_mode_)
{
	curr_mode_	= aud_get_optional_param(kVM2_hud_mode_silent, curr_mode_);
	vm			= VM2x_get();
	
	// Remove any existing instance hud data.
	foreach (preset in vm.presets)
	{
		foreach (instance in preset.instances)
		{
			instance VM2x_hud_remove_instance();
		}
	}
	
	// Update the current hud display mode.
	VM2x_hud_set_mode(curr_mode_);
	
	// Create new hud instance data.
	foreach (preset in vm.presets)
	{
		foreach (instance in preset.instances)
		{
			instance VM2x_hud_add_instance();
		}
	}
}

/*
=============
"Name:		VM2x_get_hud_dvar_value()"
"Summary:	Returns current actual value of the hud mode dvar."
"CallOn:	anything"
=============
*/
VM2x_get_hud_dvar_value()
{
	SetDvarIfUninitialized(kVM2_dvar_hud_mode, kVM2_hud_mode_silent);
	dvar_value = GetDebugDvarInt(kVM2_dvar_hud_mode);
	Assert(IsDefined( dvar_value ));
	return dvar_value;
}

VM2x_set_hud_dvar_value(dvar_value)
{
	VM2x_validate_hud_mode(dvar_value);
	SetDvar(kVM2_dvar_hud_mode, dvar_value);
	//dvar_value = GetDebugDvarInt(kVM2_dvar_hud_mode);
}

VM2x_validate_hud_mode(dvar_value)
{
	AssertEx(IsDefined(dvar_value),					"VM2x_validate_hud_mode():  dvar value is undefined!");
	AssertEx(VM2x_is_valid_hud_mode(dvar_value),	"VM2x_validate_hud_mode() dvar out of range: " + dvar_value);
}

VM2x_is_valid_hud_mode(dvar_value)
{
	assert(IsDefined(dvar_value));
	return dvar_value == kVM2_hud_mode_silent || dvar_value == kVM2_hud_mode_concise || dvar_value == kVM2_hud_mode_verbose;
}

/*
=============
"Name:		VM2x_hud_get_mode()"
"Summary:	Returns the current Vehicle Manager hud mode state:  kVM2_hud_mode_silent, kVM2_hud_mode_concise, or kVM2_hud_mode_verbose."
"CallOn:	anything"
=============
*/
VM2x_hud_get_mode()
{
	vm = VM2x_get();
	Assert(IsDefined(vm.hud_mode));
	VM2x_validate_hud_mode(vm.hud_mode);
	return vm.hud_mode;
}

/*
=============
"Name:		VM2x_hud_set_mode()"
"Summary:	Sets the current Vehicle Manager hud mode state:  kVM2_hud_mode_silent, kVM2_hud_mode_concise, or kVM2_hud_mode_verbose."
"CallOn:	anything"
=============
*/
VM2x_hud_set_mode(mode)
{
	vm = VM2x_get();
	VM2x_validate_hud_mode(mode);
	vm.hud_mode = mode;
}

/*
=============
"Name:		VM2x_hud_add_instance()"
"Summary:	Creates a debug hud for a vehicle which displays it's current input, output, and other dynamic info."
"CallOn:	instance"
=============
*/
VM2x_hud_add_instance()
{
	if (VM2x_hud_get_mode() != kVM2_hud_mode_silent)
	{
		instance = self;
		
		// Create hud name list.
		instance VM2x_hud_get_instance_item_ids();
		
		// Locate free block.
		if (instance VM2x_hud_locate_free_block())
		{	
			// Create instance hud items.
			instance VM2x_hud_create_slots();
			
			// Continuously update param display.
			instance thread VM2x_hud_update_instance();
		}
	}			
}

/*
=============
"Name:		VM2x_hud_remove_instance()"
"Summary:	Deletes a vehicle's debug hud."
"CallOn:	instance"
=============
*/
VM2x_hud_remove_instance()
{
	instance = self;
	
	// Kill update thread.
	level notify("msg_snd_vehicle_remove_hud_" +  instance VM2x_get_instance_name());

	if (IsDefined(instance.hud_id))
	{		
		// Remove hud slot resource.
		slot_id			= instance.hud_id;			// Save instance slot id.
		instance.hud_id	= undefined; 				// Clear instance's hud_id so background hud update thread will no longer try to update it's values.
		instance VM2x_hud_delete_slots(slot_id);	// Deallocate vm hud slots.
	}
}

/*
=============
"Name:		VM2x_hud_get_instance_item_ids()"
"Summary:	Creates a list of hud tag names to be used by each debug line of a vehilce hud (e.g., loops, states, etc.)."
"CallOn:	instance"
=============
*/
VM2x_hud_get_instance_item_ids()
{
	if (VM2x_hud_get_mode() == kVM2_hud_mode_silent)
		return;
	
	instance = self;
	instance.hud_slot_info = [];
	base_name = instance VM2x_get_instance_name();
	vm = VM2x_get();
	
	// Global params such as loopDuckAmt are displayed in this line.
	info = SpawnStruct();
	info.id = base_name;
	info.color = vm.hud_color[ "red" ];
	instance.hud_slot_info[info.id] = info;	
	
	if (VM2x_hud_get_mode() == kVM2_hud_mode_verbose)
	{
		// Loop info such as input, output vals are displayed in these lines.
		foreach(loop_name, loop_struct in instance.loop_list)
		{
			info = SpawnStruct();
			info.id = base_name + "_" + loop_name;
			info.color 		= vm.hud_color[ "yellow" ];
			info.color_off	= vm.hud_color[ "blue" ];
			instance.hud_slot_info[info.id] = info;	
		}
		
		// Current state (and possibly ones shots as they are fired off) are displayed in these lines.
		foreach(group_name, group_struct in instance.state_group_list)
		{
			info = SpawnStruct();
			info.id = base_name + "_" + group_name;
			info.color = vm.hud_color[ "cyan" ];
			instance.hud_slot_info[info.id] = info;	
		}
	}
}

/*
=============
"Name:		VM2x_hud_update_instance()"
"Summary:	Update's the vehicle's hud with current input, output, and other dynamic data."
"CallOn:	instance"
=============
*/
VM2x_hud_update_instance() 
{
	instance	= self;
	inst_name	= instance VM2x_get_instance_name();
	veh_ent		= self VM2x_get_vehicle_entity();

	// Singnal thread termination conditions.
	level	endon("msg_snd_vehicle_stop");								// Entire vehicle system shutting down.
	level	endon("msg_snd_vehicle_stop_" + inst_name);					// This instance is shutting down.
	level	endon("msg_snd_vehicle_remove_hud_" + inst_name);			// Just removing the instances hud (not shutting down instance or it's vehicle).
	veh_ent	endon("death");												// This instance's vehicle entity shutting down.

	while (1)
	{
		if (IsDefined(instance.hud_id))
		{
			veh_ent		= instance VM2x_get_vehicle_entity();
			
			// Calc header padding for data alignment.
			//data_col_offset = instance VM2x_hud_calc_data_indentation();
			
			/***** Global info such as instance name, loop duck scalar, etc. *****/
			hud_id		= inst_name;
			hud_text	= "INSTANCE " + inst_name + ":";
			
			// Add loop duck scalar.
			hud_text += " LoopDuckAmt=" + VM2x_hud_format_param_val( instance.loop_duck_scalar );
			
			// Add general info.
			if (IsDefined(veh_ent))
			{
				veh_pos		= veh_ent.origin;
				veh_speed	= veh_ent VM2x_Vehicle_GetSpeed();
				hud_text += ", Speed=" + VM2x_hud_format_param_val( veh_speed ) + ", Distance=" + VM2x_hud_format_param_val( Distance(level.player.origin, veh_pos) );
			}
			
			print_debug_text_string_hud(inst_name, hud_text);
			
			if (VM2x_hud_get_mode() == kVM2_hud_mode_verbose)
			{
				/***** Loop info such as input, output vals are displayed in these lines. *****/
				foreach(loop_name, loop_struct in instance.loop_list)
				{
					hud_id		= inst_name + "_" + loop_name;
					hud_text	= "  loop - " + loop_name + ":";
					
					// Pad with whitespace so data lines up.
					//hud_text += VM2x_hud_get_pad_string(hud_text, data_col_offset);
					
					// Add loop input info.
					param_array	= loop_struct VM2x_get_current_instance_sound_item_input();
					hud_text += " [input:";
					foreach (param_name, param_value in param_array)
						hud_text += " " + param_name + "=" + VM2x_hud_format_param_val(param_value);
					hud_text += "]";
					
					// Add loop output info.
					param_array	= loop_struct VM2x_get_instance_sound_item_output();
					hud_text += " [output: ";
					foreach (param_name, param_value in param_array)
						hud_text += " " + param_name + "=" + VM2x_hud_format_param_val(param_value);
					hud_text += "]";
					 
									
					loop_color = instance.hud_slot_info[hud_id].color;
					if (loop_struct.play_mode == kVM2x_LoopPlayState_Off)
						loop_color = instance.hud_slot_info[hud_id].color_off;
					change_debug_text_hud_color(hud_id, loop_color);
					print_debug_text_string_hud(hud_id, hud_text);
				}
				
				
				/***** Current state (and possibly ones shots as they are fired off) are displayed in these lines. *****/
				foreach(group_name, group_struct in instance.state_group_list)
				{
					curr_state_name = instance VMx2_debug_get_instance_current_state_name(group_name);
					hud_id			= inst_name + "_" + group_name;
					hud_text		= "  state - " + curr_state_name + ":";
						
					curr_behavior_name	= instance VMx2_debug_get_instance_current_behavior_name(group_name);
					behavior_struct		= instance.behavior_list[curr_behavior_name];
					
					// Add loop input info.
					param_array	= behavior_struct VM2x_get_current_instance_sound_item_input();
					hud_text += " [input:";
					foreach (param_name, param_value in param_array)
						hud_text += " " + param_name + "=" + VM2x_hud_format_param_val(param_value);
					hud_text += "]";
					
					// Add loop output info.
					param_array	= behavior_struct VM2x_get_instance_sound_item_output();
					hud_text += " [output: ";
					foreach (param_name, param_value in param_array)
						hud_text += " " + param_name + "=" + VM2x_hud_format_param_val(param_value);
					hud_text += "]";
	
					print_debug_text_string_hud(hud_id, hud_text);
				}
			}
		}
		
		wait(0.1);
	}
}

/*
=============
"Name:		VM2x_hud_monitor_update_mode()"
"Summary:	Thread to update each vehicle instance's hud with current input, output, and other dynamic data."
"CallOn:	anything"
=============
*/
VM2x_hud_monitor_update_mode()
{	
	vm			= VM2x_get();
	prev_dvar	= VM2x_get_hud_dvar_value();
	
	while (1)
	{
		curr_dvar = VM2x_get_hud_dvar_value();
		
		if ( !VM2x_is_valid_hud_mode(curr_dvar) )
		{
			VM2x_set_hud_dvar_value(prev_dvar);	// Filter out bogus dvar values.
		}
		else if (curr_dvar != prev_dvar)
		{
			VM2x_hud_reinit(curr_dvar);
			prev_dvar = curr_dvar;
		}
		
		wait (0.1);
	}
}

VM2x_hud_monitor_deferred_instances()
{
	vm = VM2x_get();
	
	while (1)
	{
		// Create new hud instance data.
		foreach (preset in vm.presets)
		{
			foreach (instance in preset.instances)
			{
				if (instance.hud_deferred)
					instance VM2x_hud_add_instance();	// There was not enough screen realestate when it was created, but there may be now...
			}
		}
		
		wait (0.1);
	}
}

/*
=============
"Name:		VM2x_hud_locate_free_block()"
"Summary:	Finds a contiguous block of hud ids big enough to fit the number of items of a given instance; returs the id of the first slot number."
"CallOn:	anything"
=============
*/
VM2x_hud_locate_free_block()
{
	instance = self;
	assert(IsDefined(instance.hud_slot_info) && instance.hud_slot_info.size > 0);
	blockSize = instance.hud_slot_info.size;
	
	vm = VM2x_get();
	if (!IsDefined(vm.hud_slots))
		vm.hud_slots = [];	
	
	instance.hud_deferred = false;
		
	for (slot_index = 0; slot_index < kVM2_MaxHudSlots; slot_index++)
	{
		// Found start of a free block?
		if (!IsDefined(vm.hud_slots[slot_index]))	
		{
			// Is it big enough? (TWSS)
			free_count = 0;
			while (slot_index + free_count < kVM2_MaxHudSlots && free_count < blockSize && !IsDefined(vm.hud_slots[slot_index + free_count]))
			{
				free_count++;
			}
			assert(free_count <= blockSize);
			
			// Found a block that's big enough.
			if (free_count == blockSize)
			{
				if ((slot_index + blockSize) * vm.hud_vertical_spacing < kVM2_hud_max_y_screen_space_pos)
					instance.hud_id	= slot_index;
				else
					assert(false);
				
				break;	
			}			
		}
	}
	
	if (!IsDefined(instance.hud_id))
		instance.hud_deferred = true;
	
	return !instance.hud_deferred;
}

/*
=============
"Name:		VM2x_hud_create_slots()"
"Summary:	Creates the hud system resources needed for an instance."
"CallOn:	instance"
=============
*/
VM2x_hud_create_slots()
{
	instance = self;
	assert(IsDefined(instance.hud_slot_info) && instance.hud_slot_info.size > 0);
	
	if (IsDefined(instance.hud_id))
	{
		vm = VM2x_get();
		
		slot_index = instance.hud_id;
		foreach (info in instance.hud_slot_info)
		{
			vm.hud_slots[slot_index] = info.id;
			slot_index++;
			
			hud_x	= 0;
			hud_y	= slot_index * vm.hud_vertical_spacing;
			if (hud_y < kVM2_hud_max_y_screen_space_pos)
				create_debug_text_hud(info.id, hud_x, hud_y, info.color, undefined, vm.hud_fontsize);
			else
				AssertEx(false, "hud_y < kVM2_hud_max_y_screen_space_pos: value is " + hud_y);
		}
	}
}

/*
=============
"Name:		VM2x_hud_delete_slots()"
"Summary:	Deletes the hud system resources needed for an instance."
"CallOn:	instance"
=============
*/
VM2x_hud_delete_slots(slot_id)
{
	instance	= self;
	slot_index	= slot_id;
	vm			= VM2x_get();
	
	assert(IsDefined(vm.hud_slots) && IsDefined(vm.hud_slots[slot_id]));	
	
	foreach (info in instance.hud_slot_info)
	{
		vm.hud_slots[slot_index] = undefined;
		slot_index++;
		
		delete_debug_text_hud(info.id); 	// Delete the hud resource.
	}
}

/*
=============
"Name:			VM2x_hud_format_param_val()"
"Summary:		String-formats a floating point param value, padding with zeros on the left and right of the int/frac part."
"CallOn:		anything"
"MandatoryArg:	<param_value>: "
"OptoinalArg:	<numIntDigits_>: "
"OptoinalArg:	<numFracDigits_>: "
"Exanple:		num_string = instance VM2x_hud_format_param_val(3.1415926535, 2, 4);  // result: "03.1415"
=============
*/
VM2x_hud_format_param_val(param_value, numIntDigits_, numFracDigits_)
{
	assert(IsDefined(param_value));
	numIntDigits_	= aud_get_optional_param(2, numIntDigits_);
	numFracDigits_	= aud_get_optional_param(4, numFracDigits_);
	int_str			= "";
	frac_str		= "";
	int_part		= Abs(Int(param_value));
	frac_part		= param_value - int_part;
	
	/* INTEGER PART */
	// Pad with leading zeros interger part.
	if (int_part > 0)
	{
		padding	= "";
		num		= int_part;
		for (digits = 0; digits < numIntDigits_; digits++)
		{
			if (Int(num) < 1.0)
				padding	+= "0";
			num *= 0.1;
		}
		int_str = padding + int_part;
	}
	else
	{
		for (digits = 0; digits < numIntDigits_; digits++)
			int_str += "0";
	}
	
	if(param_value < 0)
		int_str = "-" + int_str;

	/* FRACTIONAL PART */
	// Trunc to numFracDigits and then pad with trailing zeros.
	padding = "";
	
//	mul = 1;
//	for (digits = 0; digits < numFracDigits_; digits++)
//		mul *= 10;

	mul = Pow(10, numFracDigits_);
	
	num = Int(frac_part * mul);
	if (num > 0)
	{
		for (digits = 0; digits < numFracDigits_; digits++)
		{
			if (Int(num) < 1.0)
				padding	+= "0";
			num *= 0.1;
		}
		frac_str = padding + Int(frac_part * mul);
	}
	else
	{
		for (digits = 0; digits < numFracDigits_; digits++)
			frac_str += "0";
	}
		
	return int_str + "." + frac_str;
}

/*
=============
"Name:		VM2x_hud_calc_data_indentation()"
"Summary:	Calcs header padding for data alignment."
"CallOn:	instance"
=============
*/
VM2x_hud_calc_data_indentation()
{
	instance = self;
	data_col_offset = 0;	
	assert(IsArray(instance.hud_slot_info));
	
	foreach (str in instance.hud_slot_info)
		data_col_offset = max(str.size, data_col_offset);
	
	return data_col_offset + 1;
}

/*
=============
"Name:		VM2x_hud_get_pad_string()"
"Summary:	Creates a padding for data alignment."
"CallOn:	instance"
=============
*/
VM2x_hud_get_pad_string(hud_text, data_col_offset)
{
	pad = "";
	
	delta = max(0, data_col_offset - hud_text.size);
	for (i = 0; i < delta; i++)
		pad += ".";
		
	return pad;
}

// Called on vehicle instance.
VM2x_debug_monitor_ducking()
{
	veh_ent = self VM2x_get_vehicle_entity();
	veh_ent endon("death");
	
	update_rate = 0.25;
	veh_name = self VM2x_get_instance_name();
	
	while (1)
	{
		wait(update_rate);
	}
}

VM2x_debug_monitor_3d()
{
	veh_ent = self VM2x_get_vehicle_entity();
	
	veh_ent thread aud_print_3d_on_ent("VM2: ", 1, "red", ::VM2x_debug_monitor_3d_callback);
}

VM2x_debug_monitor_3d_callback()
{
	yards_3d		= dist2yards( Distance(self.origin, level.player.origin) );
	yards_2d		= dist2yards( Distance2D(self.origin, level.player.origin) );
	vehicle_speed	= self VM2x_Vehicle_GetSpeed();
	relative_speed	= self VM2x_debug_get_ent_relative_velocity();
	//accel			= self input_callback_acceleration_g();
	
	return "speed = " + vehicle_speed + ", rel speed = " + relative_speed + ", yards_3d = " + yards_3d + ", yards_2d = " + yards_2d;
}

VM2x_debug_get_ent_relative_velocity()
{	
	vehicle_velocity	= self Vehicle_GetVelocity();
	player_velocity		= level.player GetVelocity();
	relative_velocity	= vehicle_velocity - player_velocity;
	vector_length		= Length(relative_velocity) / kVM2_InchesPerSecPerMPH;
	
	return vector_length;
}

//------------ END DEBUG SCRIPT------------//
#/
	
VM2x_Vehicle_GetSpeed()
{
	spd = 0;
	if (self VM2x_is_vehicle_proxy() == false)
		spd = self Vehicle_GetSpeed();
	return spd;
}
