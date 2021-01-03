#using scripts\core\_multi_extracam;

#using scripts\codescripts\struct;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;
#using scripts\shared\animation_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                

#namespace character_customization;













	





#using_animtree("all_player");

function autoexec __init__sytem__() {     system::register("character_customization",&__init__,undefined,undefined);    }		

///////////////////////////////////////////////////////////////////////////
// SETUP
///////////////////////////////////////////////////////////////////////////
function __init__()
{
	level.extra_cam_render_hero_func_callback = &process_character_extracam_request;
	level.extra_cam_render_lobby_client_hero_func_callback = &process_lobby_client_character_extracam_request;
	level.extra_cam_render_current_hero_headshot_func_callback = &process_current_hero_headshot_extracam_request;
	level.extra_cam_render_outfit_preview_func_callback = &process_outfit_preview_extracam_request;
	level.model_type_bones = associativearray( "helmet", "", "head", "" );
	level.custom_characters = associativearray();
	
	level.characterCustomizationSetup = &localClientConnect;
}

function localClientConnect( localClientNum )
{
	// setup our live and static characters
	level.liveCCData = setup_live_character_customization_target( localClientNum );
	level.staticCCData = setup_static_character_customization_target( localClientNum );
}

function create_character_data_struct( characterModel )
{
	if ( !isdefined( characterModel ) )
	{
		return undefined;
	}
	
	if ( isdefined( level.custom_characters[characterModel.targetname] ) )
	{
		return level.custom_characters[characterModel.targetname];
	}
	
	data_struct = SpawnStruct();
	level.custom_characters[characterModel.targetname] = data_struct;
	characterModel SetHighDetail( true );
	
	// models
	data_struct.characterModel = characterModel;
	data_struct.attached_model_anims = array();
	data_struct.attached_models = array();
	data_struct.attached_entities = array();
	data_struct.origin = characterModel.origin;
	data_struct.angles = characterModel.angles;
	
	// indices
	data_struct.characterIndex = 0;
	data_struct.characterMode = 3;
	
	data_struct.bodyIndex = 0;
	data_struct.bodyColors = array( 0, 0, 0 );

	data_struct.helmetIndex = 0;
	data_struct.helmetColors = array( 0, 0, 0 );
	
	data_struct.headIndex = 0;
	
	data_struct.align_target = undefined;
	data_struct.currentAnimation = undefined;
	data_struct.currentScene = undefined;
	
	// render options
	data_struct.body_render_options = GetCharacterBodyRenderOptions( 0, 0, 0, 0, 0 );
	data_struct.helmet_render_options = GetCharacterHelmetRenderOptions( 0, 0, 0, 0, 0 );
	data_struct.head_render_options = GetCharacterHeadRenderOptions( 0 );
	data_struct.mode_render_options = GetCharacterModeRenderOptions( 0 );
	
	// menu options
	data_struct.useFrozenMomentAnim = false;
	data_struct.frozenMomentStyle = "weapon";
	data_struct.show_helmets = true;
	
	return data_struct;
}

function handle_forced_streaming( game_mode )
{
	return; // MJD - disable all forcing

	heroes = GetHeroes( game_mode );
	foreach( hero in heroes )
	{
		bodies = GetHeroBodyModelIndices( hero, game_mode );
		helmets = GetHeroHelmetModelIndices( hero, game_mode );
		foreach( helmet in helmets )
		{
			ForceStreamXModel( helmet, 8, -1 );
		}
		foreach( body in bodies )
		{
			ForceStreamXModel( body, 8, -1 );
		}
	}
	
	heads = GetHeroHeadModelIndices( game_mode );
	foreach( head in heads )
	{
		ForceStreamXModel( head, 8, -1 );
	}
}

///////////////////////////////////////////////////////////////////////////
// UTILITY
///////////////////////////////////////////////////////////////////////////

// supported "params" fields: align_struct, anim_name, weapon_left, weapon_right, scene, extracam_data
function loadEquippedCharacterOnModel( localClientNum, data_struct, characterIndex, params )
{
	assert( isdefined( data_struct ) );

	if( !isdefined( characterIndex ) )
	{
		characterIndex = GetEquippedHeroIndex( localClientNum, params.sessionMode );
	}

	defaultIndex = undefined;

	if ( ( isdefined( params.isDefaultHero ) && params.isDefaultHero ) )
	{
		defaultIndex = 0;
	}
	
	set_character( data_struct, characterIndex );
	
	characterMode = params.sessionMode;
	set_character_mode( data_struct, characterMode );
	
	body = get_character_body( localClientNum, characterMode, characterIndex, params.extracam_data );
	bodyColors = get_character_body_colors( localClientNum, characterMode, characterIndex, body, params.extracam_data );
	set_body( data_struct, characterMode, characterIndex, body, bodyColors );

	head = character_customization::get_character_head( localClientNum, characterMode, params.extracam_data );
	set_head( data_struct, characterMode, head );
	
	helmet = get_character_helmet( localClientNum, characterMode, characterIndex, params.extracam_data );
	helmetColors = get_character_helmet_colors( localClientNum, characterMode, data_struct.characterIndex, helmet, params.extracam_data );
	set_helmet( data_struct, characterMode, characterIndex, helmet, helmetColors );
	
	update( localClientNum, data_struct, params );
}

#using_animtree("generic");


function update_model_attachment( localClientNum, data_struct, attached_model, slot, model_anim, force_update )
{
	assert( isdefined( data_struct.attached_models ) );
	assert( isdefined( data_struct.attached_model_anims ) );
	assert( isdefined( level.model_type_bones ) );
	
	data_struct.characterModel notify( "streamer_refresh" );
	
	if ( force_update || attached_model !== data_struct.attached_models[slot] || model_anim !== data_struct.attached_model_anims[slot] )
	{
		bone = slot;
		if ( isdefined( level.model_type_bones[slot] ) )
		{
			bone = level.model_type_bones[slot];
		}
		
		assert( isdefined( bone ) );
	
		if ( isdefined( data_struct.attached_models[slot] ) )
		{
			if ( isDefined(data_struct.attached_entities[slot]) )
			{
				data_struct.attached_entities[slot] Unlink();
				data_struct.attached_entities[slot] Delete();
				data_struct.attached_entities[slot] = undefined;
			}
			else
			{
				if( data_struct.characterModel IsAttached( data_struct.attached_models[slot], bone ) )
				{
					data_struct.characterModel Detach( data_struct.attached_models[slot], bone );
				}
			}
			
			data_struct.attached_models[slot] = undefined;
		}

		data_struct.attached_models[slot] = attached_model;
		if ( isdefined( data_struct.attached_models[slot] ) )
		{
			if ( isDefined(model_anim) )
			{
				ent = Spawn( localClientNum, data_struct.characterModel.origin, "script_model" );
				ent SetHighDetail( true );
				data_struct.attached_entities[slot] = ent;
				ent SetModel( data_struct.attached_models[slot] );
				if ( !ent HasAnimTree() )
				{
					ent UseAnimTree( #animtree );
				}
				
				ent.origin = data_struct.characterModel.origin;
				ent.angles = data_struct.characterModel.angles;
			
				ent AnimScripted( "_anim_notify_", ent.origin, ent.angles, model_anim, 0, 1 );
			}
			else
			{
				if ( !data_struct.characterModel IsAttached( data_struct.attached_models[slot], bone ) )
				{
					data_struct.characterModel Attach( data_struct.attached_models[slot], bone );
				}
			}

			data_struct.attached_model_anims[slot] = model_anim;
		}
	}
}

function set_character( data_struct, characterIndex )
{
	data_struct.characterIndex = characterIndex;
}

function set_character_mode( data_struct, characterMode )
{
	assert( isdefined( characterMode ) );
	data_struct.characterMode = characterMode;
	data_struct.mode_render_options = GetCharacterModeRenderOptions( characterMode );
}

function set_body( data_struct, mode, characterIndex, bodyIndex, bodyColors )
{
	assert( isdefined( mode ) );
	assert( mode != 3 );
	
	data_struct.bodyIndex = bodyIndex;
	data_struct.bodyModel = GetCharacterBodyModel( characterIndex, bodyIndex, mode );
	
	if( isdefined( data_struct.bodyModel ) )
	{
		data_struct.characterModel SetModel( data_struct.bodyModel );
	}
	
	if( isdefined( bodyColors ) )
	{
		set_body_colors( data_struct, mode, bodyColors );
	}
	
	render_options = GetCharacterBodyRenderOptions( data_struct.characterIndex, data_struct.bodyIndex, data_struct.bodyColors[0], data_struct.bodyColors[1], data_struct.bodyColors[2] );
	data_struct.body_render_options = render_options;
}

function set_body_colors( data_struct, mode, bodyColors )
{
	for( i = 0; i < bodyColors.size && i < bodyColors.size; i++ )
	{
		set_body_color( data_struct, i, bodyColors[ i ] );
	}
}

function set_body_color( data_struct, colorSlot, colorIndex )
{
	data_struct.bodyColors[ colorSlot ] = colorIndex;
	
	render_options = GetCharacterBodyRenderOptions( data_struct.characterIndex, data_struct.bodyIndex, data_struct.bodyColors[0], data_struct.bodyColors[1], data_struct.bodyColors[2] );
	data_struct.body_render_options = render_options;
}

function set_head( data_struct, mode, headIndex )
{
	data_struct.headIndex = headIndex;
	data_struct.headModel = GetCharacterHeadModel( headIndex, mode );
	
	render_options = GetCharacterHeadRenderOptions( headIndex );
	data_struct.head_render_options = render_options;
}

function set_helmet( data_struct, mode, characterIndex, helmetIndex, helmetColors )
{
	data_struct.helmetIndex = helmetIndex;
	data_struct.helmetModel = GetCharacterHelmetModel( characterIndex, helmetIndex, mode );
	
	set_helmet_colors( data_struct, helmetColors );
}

function set_helmet_colors( data_struct, colors )
{
	for ( i = 0; i < colors.size && i < data_struct.helmetColors.size; i++ )
	{
		set_helmet_color( data_struct, i, colors[ i ] );
	}
	
	render_options = GetCharacterHelmetRenderOptions( data_struct.characterIndex, data_struct.helmetIndex, data_struct.helmetColors[0], data_struct.helmetColors[1], data_struct.helmetColors[2] );
	data_struct.helmet_render_options = render_options;
}

function set_helmet_color( data_struct, colorSlot, colorIndex )
{
	data_struct.helmetColors[ colorSlot ] = colorIndex;
	
	render_options = GetCharacterHelmetRenderOptions( data_struct.characterIndex, data_struct.helmetIndex, data_struct.helmetColors[0], data_struct.helmetColors[1], data_struct.helmetColors[2] );
	data_struct.helmet_render_options = render_options;
}

function update( localClientNum, data_struct, params )
{
	data_struct.characterModel notify( "streamer_refresh" );

	data_struct.characterModel SetBodyRenderOptions( data_struct.mode_render_options, data_struct.body_render_options, data_struct.helmet_render_options, data_struct.head_render_options );
	
	helmet_model = "tag_origin";
	if ( data_struct.show_helmets )
	{
		helmet_model = data_struct.helmetModel;
	}

	update_model_attachment( localClientNum, data_struct, helmet_model, "helmet", undefined, true );
	update_model_attachment( localClientNum, data_struct, data_struct.headModel, "head", undefined, true );	
	
	update_character_animation_and_attachments( localClientNum, data_struct, params );

	start_character_streaming( data_struct );
}

function is_character_streamed( data_struct )
{
	if( isDefined( data_struct.characterModel ) )
	{
		if( !( data_struct.characterModel isStreamed() ) )
		{
			return false;
		}
	}

	foreach( ent in data_struct.attached_entities )
	{
		if( isDefined( ent ) )
		{
			if( !( ent isStreamed() ) )
			{
				return false;
			}
		}
	}

	return true;
}

function character_streamer( ents )
{
	self endon( "streamer_refresh" );

	// wait for meshes to load
	foreach( e in ents )
	{
		if( !isDefined( e ) )
		{
			return;
		}
		
		while( !( e isStreamed() ) )
		{
			wait 0.1;
		}
	}

	// meshes have loaded, set them visible
	foreach( e in ents )
	{
		if( isDefined( e ) )
		{
			e Show();
		}
	}
}

function setup_character_streaming( data_struct )
{
	ents = array();

	// init, force high detail and hide everything
	if( isDefined( data_struct.characterModel ) )
	{
		data_struct.characterModel SetHighDetail( true );
		data_struct.characterModel Hide();
		array::add( ents, data_struct.characterModel );
	}

	foreach( ent in data_struct.attached_entities )
	{
		if( isDefined( ent ) )
		{
			ent SetHighDetail( true );
			ent Hide();
			array::add( ents, ent );
		}
	}

	allStreamed = true;
	foreach( e in ents )
	{
		if( !( e isStreamed() ) )
		{
			allStreamed = false;
			break;
		}
	}

	if( allStreamed )
	{
		foreach( e in ents )
		{
			e Show();
		}
		return;
	}

	wait 0.1;

	data_struct.characterModel thread character_streamer( ents );
}

function start_character_streaming( data_struct )
{
	data_struct.characterModel notify( "streamer_refresh" );

	level thread setup_character_streaming( data_struct );
}
		

function get_character_mode( localClientNum )
{
	return GetEquippedHeroMode( localClientNum );
}

function get_character_body( localClientNum, characterMode, characterIndex, extracamData )
{
	assert( isdefined( characterIndex ) );
	
	if( isdefined( extracamData ) && ( isdefined( extracamData.isDefaultHero ) && extracamData.isDefaultHero ) )
	{
		return 0;
	}
	else if( isdefined( extracamData ) && extracamData.useLobbyPlayers )
	{
		return GetEquippedBodyIndexForHero( localClientNum, characterMode, extracamData.jobIndex, true );
	}
	else
	{
		return GetEquippedBodyIndexForHero( localClientNum, characterMode, characterIndex );
	}
}

function get_character_body_color( localClientNum, characterMode, characterIndex, bodyIndex, colorSlot, extracamData )
{
	if( isdefined( extracamData ) && ( isdefined( extracamData.isDefaultHero ) && extracamData.isDefaultHero ) )
	{
		return 0;
	}
	else if( isdefined( extracamData ) && extracamData.useLobbyPlayers )
	{
		return GetEquippedBodyAccentColorForHero( localClientNum, characterMode, extracamData.jobIndex, bodyIndex, colorSlot, true );
	}
	else
	{
		return GetEquippedBodyAccentColorForHero( localClientNum, characterMode, characterIndex, bodyIndex, colorSlot );
	}
}

function get_character_body_colors( localClientNum, characterMode, characterIndex, bodyIndex, extracamData )
{
	bodyAccentColorCount = GetBodyAccentColorCountForHero( localClientNum, characterMode, characterIndex, bodyIndex );
	
	colors = [];
	for( i = 0; i < 3; i++ )
	{
		colors[ i ] = 0;
	}
	
	for( i = 0; i < bodyAccentColorCount; i++ )
	{
		colors[ i ] = get_character_body_color( localClientNum, characterMode, characterIndex, bodyIndex, i, extracamData );
	}
	
	return colors;
}

function get_character_head( localClientNum, characterMode, extracamData )
{
	if( isdefined( extracamData ) && ( isdefined( extracamData.isDefaultHero ) && extracamData.isDefaultHero ) )
	{
		return 0;
	}
	else if ( isdefined( extracamData ) && extracamData.useLobbyPlayers )
	{
		return GetEquippedHeadIndexForHero( localClientNum, characterMode, extracamData.jobIndex );
	}
	else
	{
		return GetEquippedHeadIndexForHero( localClientNum, characterMode );
	}
}

function get_character_helmet( localClientNum, characterMode, characterIndex, extracamData )
{
	if( isdefined( extracamData ) && ( isdefined( extracamData.isDefaultHero ) && extracamData.isDefaultHero ) )
	{
		return 0;
	}
	else if ( isdefined( extracamData ) && extracamData.useLobbyPlayers )
	{
		return GetEquippedHelmetIndexForHero( localClientNum, characterMode, extracamData.jobIndex, true );
	}
	else
	{
		return GetEquippedHelmetIndexForHero( localClientNum, characterMode, characterIndex );
	}
}

function get_character_helmet_color( localClientNum, characterMode, characterIndex, helmetIndex, colorSlot, extracamData )
{
	if( isdefined( extracamData ) && ( isdefined( extracamData.isDefaultHero ) && extracamData.isDefaultHero ) )
	{
		return 0;
	}
	else if ( isdefined( extracamData ) && extracamData.useLobbyPlayers )
	{
		return GetEquippedHelmetAccentColorForHero( localClientNum, characterMode, extracamData.jobIndex, helmetIndex, colorSlot, true );
	}
	else
	{
		return GetEquippedHelmetAccentColorForHero( localClientNum, characterMode, characterIndex, helmetIndex, colorSlot );
	}
}

function get_character_helmet_colors( localClientNum, characterMode, characterIndex, helmetIndex, extracamData )
{
	helmetColorCount = GetHelmetAccentColorCountForHero( localClientNum, characterMode, characterIndex, helmetIndex );
	
	colors = [];
	for( i = 0; i < 3; i++ )
	{
		colors[ i ] = 0;
	}
	
	for( i = 0; i < helmetColorCount; i++ )
	{
		colors[ i ] = get_character_helmet_color( localClientNum, characterMode, characterIndex, helmetIndex, i, extracamData );
	}
	
	return colors;
}

#using_animtree("all_player");
function update_character_animation_tree_for_scene(characterModel)
{
	if ( !characterModel HasAnimTree() )
	{
		characterModel UseAnimTree( #animtree );
	}
}

function get_current_frozen_moment_params( localClientNum, data_struct, params )
{
	fields = GetCharacterFields( data_struct.characterIndex, data_struct.characterMode );
		
	if ( data_struct.frozenMomentStyle == "weapon" )
	{
		if ( isdefined( fields.weaponFrontendFrozenMomentXAnim) ) { params.anim_name = fields.weaponFrontendFrozenMomentXAnim; };
		params.scene = undefined;
		if ( isdefined( fields.weaponFrontendFrozenMomentWeaponLeftModel) ) { params.weapon_left = fields.weaponFrontendFrozenMomentWeaponLeftModel; };
		if ( isdefined( fields.weaponFrontendFrozenMomentWeaponLeftAnim) ) { params.weapon_left_anim = fields.weaponFrontendFrozenMomentWeaponLeftAnim; };
		if ( isdefined( fields.weaponFrontendFrozenMomentWeaponRightModel) ) { params.weapon_right = fields.weaponFrontendFrozenMomentWeaponRightModel; };
		if ( isdefined( fields.weaponFrontendFrozenMomentWeaponRightAnim) ) { params.weapon_right_anim = fields.weaponFrontendFrozenMomentWeaponRightAnim; };
		if ( isdefined( fields.weaponFrontendFrozenMomentExploder) ) { params.exploder_id = fields.weaponFrontendFrozenMomentExploder; };
		if ( isdefined( struct::get( fields.weaponFrontendFrozenMomentAlignTarget )) ) { params.align_struct = struct::get( fields.weaponFrontendFrozenMomentAlignTarget ); };
		if ( isdefined( fields.weaponFrontendFrozenMomentXCam) ) { params.xcam = fields.weaponFrontendFrozenMomentXCam; };
		if ( isdefined( fields.weaponFrontendFrozenMomentXCamSubXCam) ) { params.subXCam = fields.weaponFrontendFrozenMomentXCamSubXCam; };
		if ( isdefined( fields.weaponFrontendFrozenMomentXCamFrame) ) { params.xcamFrame = fields.weaponFrontendFrozenMomentXCamFrame; };
	}
	else if ( data_struct.frozenMomentStyle == "ability" )
	{
		if ( isdefined( fields.abilityFrontendFrozenMomentXAnim) ) { params.anim_name = fields.abilityFrontendFrozenMomentXAnim; };
		params.scene = undefined;
		if ( isdefined( fields.abilityFrontendFrozenMomentWeaponLeftModel) ) { params.weapon_left = fields.abilityFrontendFrozenMomentWeaponLeftModel; };
		if ( isdefined( fields.abilityFrontendFrozenMomentWeaponLeftAnim) ) { params.weapon_left_anim = fields.abilityFrontendFrozenMomentWeaponLeftAnim; };
		if ( isdefined( fields.abilityFrontendFrozenMomentWeaponRightModel) ) { params.weapon_right = fields.abilityFrontendFrozenMomentWeaponRightModel; };
		if ( isdefined( fields.abilityFrontendFrozenMomentWeaponRightAnim) ) { params.weapon_right_anim = fields.abilityFrontendFrozenMomentWeaponRightAnim; };
		if ( isdefined( fields.abilityFrontendFrozenMomentExploder) ) { params.exploder_id = fields.abilityFrontendFrozenMomentExploder; };
		if ( isdefined( struct::get( fields.abilityFrontendFrozenMomentAlignTarget )) ) { params.align_struct = struct::get( fields.abilityFrontendFrozenMomentAlignTarget ); };
		if ( isdefined( fields.abilityFrontendFrozenMomentXCam) ) { params.xcam = fields.abilityFrontendFrozenMomentXCam; };
		if ( isdefined( fields.abilityFrontendFrozenMomentXCamSubXCam) ) { params.subXCam = fields.abilityFrontendFrozenMomentXCamSubXCam; };
		if ( isdefined( fields.abilityFrontendFrozenMomentXCamFrame) ) { params.xcamFrame = fields.abilityFrontendFrozenMomentXCamFrame; };
	}
	
	if ( !isdefined( params.align_struct ) )
	{
		params.align_struct = data_struct; // moves the character back to their original position
	}
}

function handle_camo( localClientNum, camo_on, reveal )
{
	flags_changed = self duplicate_render::set_dr_flag( "gadget_camo_friend", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "gadget_camo_flicker", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "gadget_camo_break", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "gadget_camo_reveal", reveal );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "gadget_camo_on", false );
	
	if ( flags_changed )
	{
		self duplicate_render::update_dr_filters();
	}
	self thread gadget_camo_render::doReveal( localClientNum, camo_on );
}

function handle_camo_on( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while ( true )
	{
		self waittillmatch("_anim_notify_","camo_on");
		self handle_camo( localClientNum, true, true );
	}
}

function handle_camo_off( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while ( true )
	{
		self waittillmatch("_anim_notify_","camo_off");
		self handle_camo( localClientNum, false, true );
	}
}

function update_character_animation_and_attachments( localClientNum, data_struct, params )
{
	if ( !isdefined( params ) )
	{
		params = SpawnStruct();
	}
	
	if ( data_struct.useFrozenMomentAnim && isdefined( data_struct.frozenMomentStyle ) )
	{
		get_current_frozen_moment_params( localClientNum, data_struct, params );
	}
	
	if ( !isdefined( params.exploder_id ) )
	{
		params.exploder_id = data_struct.default_exploder;
	}
	
	align_changed = false;
	if(!isdefined(params.align_struct))params.align_struct=struct::get( data_struct.align_target );
	if(!isdefined(params.align_struct))params.align_struct=data_struct;
	if ( isdefined( params.align_struct ) && ( params.align_struct.origin !== data_struct.characterModel.origin || params.align_struct.angles !== data_struct.characterModel.angles ) )
	{
		data_struct.characterModel.origin = params.align_struct.origin;
		data_struct.characterModel.angles = params.align_struct.angles;
		params.anim_name = ( isdefined( params.anim_name ) ? params.anim_name : data_struct.currentAnimation );
		align_changed = true;
	}
	
	if ( isdefined( params.anim_name ) && ( params.anim_name !== data_struct.currentAnimation || align_changed ) )
	{
		data_struct.currentAnimation = params.anim_name;
		if ( !data_struct.characterModel HasAnimTree() )
		{
			data_struct.characterModel UseAnimTree( #animtree );
		}
		
		data_struct.characterModel thread animation::play( params.anim_name, data_struct.characterModel.origin, data_struct.characterModel.angles, 1, 0, 0, 0 );
		if ( (GetDvarInt( "ui_execdemo_gamescom", 0 ) == 0) && (GetDvarInt( "ui_execdemo_beta", 0 ) == 0) && (params.anim_name == "pb_cac_assassin_ability_idle") )
		{
			data_struct.characterModel handle_camo( localClientNum, false, false );
			data_struct.characterModel thread handle_camo_on( localClientNum );
			data_struct.characterModel thread handle_camo_off( localClientNum );
		}
	}
	else if ( isdefined( params.scene ) && params.scene !== data_struct.currentScene )
	{
		if ( isdefined( data_struct.currentScene ) )
		{
			level scene::stop( data_struct.currentScene, false );
		}
		
		update_character_animation_tree_for_scene(data_struct.characterModel);
		
		data_struct.currentScene = params.scene;
		level thread scene::play( params.scene );
	}
	
	if ( data_struct.exploder_id !== params.exploder_id )
	{
		if ( isdefined( data_struct.exploder_id ) )
		{
			KillRadiantExploder( localClientNum, data_struct.exploder_id );
		}
		
		if ( isdefined( params.exploder_id ) )
		{
			PlayRadiantExploder( localClientNum, params.exploder_id );
		}
		
		data_struct.exploder_id = params.exploder_id;
	}
	
	update_model_attachment( localClientNum, data_struct, params.weapon_right, "tag_weapon_right", params.weapon_right_anim, align_changed );
	update_model_attachment( localClientNum, data_struct, params.weapon_left, "tag_weapon_left", params.weapon_left_anim, align_changed );
}

function update_use_frozen_moments( localClientNum, data_struct, useFrozenMoments )
{
	if ( data_struct.useFrozenMomentAnim != useFrozenMoments )
	{
		data_struct.useFrozenMomentAnim = useFrozenMoments;
		params = SpawnStruct();
		if ( !data_struct.useFrozenMomentAnim )
		{
			params.align_struct = struct::get( "character_customization" );
			params.anim_name = "pb_cac_main_lobby_idle";
			params.weapon_right = "wpn_t7_arak_paint_shop";
		}
		update_character_animation_and_attachments( localClientNum, data_struct, params );
		
		if ( data_struct.useFrozenMomentAnim )
		{
			level notify( "frozenMomentChanged" );
		}
	}
}

function update_show_helmets( localClientNum, data_struct, show_helmets )
{
	if ( data_struct.show_helmets != show_helmets )
	{
		data_struct.show_helmets = show_helmets;
		update( localClientNum, data_struct, undefined );
	}
}

function set_character_align( localClientNum, data_struct, align_target )
{
	if ( data_struct.align_target !== align_target )
	{
		data_struct.align_target = align_target;
		
		params = SpawnStruct();
		params.weapon_right = data_struct.attached_models["tag_weapon_right"];
		params.weapon_left = data_struct.attached_models["tag_weapon_left"];
		update( localClientNum, data_struct, params );
	}
}

///////////////////////////////////////////////////////////////////////////
// LIVE CHARACTER
///////////////////////////////////////////////////////////////////////////

function setup_live_character_customization_target( localClientNum )
{
	characterEnt = GetEnt( localClientNum, "character_customization", "targetname" );
	
	if ( isdefined( characterEnt ) )
	{
		customization_data_struct = character_customization::create_character_data_struct( characterEnt );
		customization_data_struct.default_exploder = "char_customization";
		level thread updateEventThread( localClientNum, customization_data_struct, "begin_personalizing_hero", "done_personalizing_hero" );
		
		return customization_data_struct;
	}
	
	return undefined;
}

function updateEventThread( localClientNum, data_struct, rotateStartEvent, rotateEndEvent )
{		
	level thread rotation_thread_spawner( localClientNum, data_struct, rotateStartEvent, rotateEndEvent );

	
	while( 1 )
	{
		level waittill( "updateHero", eventType, param1, param2, param3 );
		
		switch( eventType )
		{
			case "refresh":
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param1;
				character_customization::loadEquippedCharacterOnModel( localClientNum, data_struct, undefined, params );
				break;
				
			case "changeHero":
				// param1 = hero index
				// param2 = session mode				
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param2;
				character_customization::loadEquippedCharacterOnModel( localClientNum, data_struct, param1, params );
				break;
				
			case "changeBody":
				//param1 = new body index
				//param2 =session mode
				params = spawnstruct();
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param2;
				character_customization::set_body( data_struct, param2, data_struct.characterIndex, param1, data_struct.bodyColors );
				character_customization::update( localClientNum, data_struct, params );
				break;
				
			case "changeHelmet":
				//param1 = new helmet index
				params = spawnstruct();
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param2;
				character_customization::set_helmet( data_struct, param2, data_struct.characterIndex, param1, data_struct.helmetColors );
				character_customization::update( localClientNum, data_struct, params );
				break;
				
			case "changeHead":
				//param1 = head index
				params = spawnstruct();
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param2;
				character_customization::set_head( data_struct, param2, param1 );
				character_customization::update( localClientNum, data_struct, params );
				break;
				
			case "changeBodyAccentColor":
				//param1 = accent color slot
				//param2 = accent color index
				params = spawnstruct();
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param3;
				character_customization::set_body_color( data_struct, param1, param2 );
				character_customization::update( localClientNum, data_struct, params );
				break;
				
			case "changeHelmetAccentColor":
				//param1 = accent color slot
				//param2 = accent color index
				//param3 = sessionMode
				params = spawnstruct();
				params.weapon_right = "wpn_t7_arak_paint_shop";
				params.sessionMode = param3;
				character_customization::set_helmet_color( data_struct, param1, param2 );
				character_customization::update( localClientNum, data_struct, params );
				break;
				
			case "changeFrozenMoment":
				//param1 = new frozen moment type
				data_struct.frozenMomentStyle = param1;
				if ( data_struct.useFrozenMomentAnim )
				{
					update_character_animation_and_attachments( localClientNum, data_struct, undefined );
				}
				level notify( "frozenMomentChanged" );
				break;
		}
	}
}

function rotation_thread_spawner( localClientNum, data_struct, startOnEvent, endOnEvent )
{
	if ( !isdefined( startOnEvent ) || !isdefined( endOnEvent ) )
	{
		return;
	}
	
	assert( isdefined( data_struct.characterModel ) );
	model = data_struct.characterModel;
	baseAngles = model.angles;
	
	while ( 1 )
	{
		level waittill( startOnEvent );
		level thread update_model_rotation_for_right_stick( localClientNum, data_struct, endOnEvent );
		level waittill( endOnEvent );
		
		model.angles = baseAngles;
	}
}

function update_model_rotation_for_right_stick( localClientNum, data_struct, endOnEvent )
{
	level endon( endOnEvent );
	assert( isdefined( data_struct.characterModel ) );
	model = data_struct.characterModel;
	
	while ( true )
	{
		pos = GetControllerPosition( localClientNum );
		model.angles = ( model.angles[0], AbsAngleClamp360( model.angles[1] + pos["look"][0] * 3.0 ), model.angles[2] );
		{wait(.016);};
	}
}

///////////////////////////////////////////////////////////////////////////
// STATIC CHARACTER
///////////////////////////////////////////////////////////////////////////

function setup_static_character_customization_target( localClientNum )
{
	characterEnt = GetEnt( localClientNum, "character_customization_staging", "targetname" );
	level.extra_cam_hero_data = setup_character_extracam_struct( "ui_cam_character_customization", "cam_menu_unfocus", "pb_cac_main_lobby_idle", false );
	level.extra_cam_lobby_client_hero_data = setup_character_extracam_struct( "ui_cam_char_identity", "cam_bust", "pb_cac_vs_screen_idle_1", true );
	level.extra_cam_headshot_hero_data = setup_character_extracam_struct( "ui_cam_char_identity", "cam_bust", "pb_cac_vs_screen_idle_1", false );
	level.extra_cam_outfit_preview_data = setup_character_extracam_struct( "ui_cam_char_identity", "cam_bust", "pb_cac_main_lobby_idle", false );
	
	if ( isdefined( characterEnt ) )
	{
		customization_data_struct = character_customization::create_character_data_struct( characterEnt );
		level thread update_character_extracam( localClientNum, customization_data_struct );
		
		return customization_data_struct;
	}
	
	return undefined;
}

function setup_character_extracam_struct( xcam, subXCam, model_animation, useLobbyPlayers )
{
	newStruct = SpawnStruct();
	newStruct.xcam = xcam;
	newStruct.subXCam = subXCam;
	newStruct.anim_name = model_animation;
	newStruct.useLobbyPlayers = useLobbyPlayers;
	return newStruct;
}

function wait_for_extracam_close( camera_ent, extraCamIndex )
{
	level waittill( "render_complete_" + extraCamIndex );
	multi_extracam::extracam_reset_index( extraCamIndex );
}

function setup_character_extracam_settings( localClientNum, data_struct, extracam_data_struct )
{
	assert( isdefined( extracam_data_struct.jobIndex ) );
	
	initializedExtracam = false;
	camera_ent = (isDefined(level.camera_ents) ? level.camera_ents[extracam_data_struct.extraCamIndex] : undefined);
	if( !isdefined( camera_ent ) )
	{
		initializedExtracam = true;
		multi_extracam::extracam_init_index( localClientNum, "character_staging_extracam" + (extracam_data_struct.extraCamIndex+1), extracam_data_struct.extraCamIndex);
		camera_ent = level.camera_ents[extracam_data_struct.extraCamIndex];
	}

	assert( isdefined( camera_ent ) );
		
	camera_ent PlayExtraCamXCam( extracam_data_struct.xcam, 0, extracam_data_struct.subXCam );
	
	params = spawnstruct();
	params.anim_name = extracam_data_struct.anim_name;
	params.extracam_data = extracam_data_struct;
	params.weapon_right = "wpn_t7_arak_paint_shop";
	params.isDefaultHero = extracam_data_struct.isDefaultHero;
	params.sessionMode = extracam_data_struct.sessionMode;
	
	loadEquippedCharacterOnModel( localClientNum, data_struct, extracam_data_struct.characterIndex, params );

	while( !is_character_streamed( data_struct ) )
	{
		{wait(.016);};
	}
	
	wait 0.1;	// wait for a bit to allow the models to get set up correctly and have the lighting update

	setExtraCamRenderReady( extracam_data_struct.jobIndex );
	
	extracam_data_struct.jobIndex = undefined;
	
	if( initializedExtracam )
	{
		level thread wait_for_extracam_close( camera_ent, extracam_data_struct.extraCamIndex );
	}
}

function update_character_extracam( localClientNum, data_struct )
{
	level endon( "disconnect" );
	
	while ( true )
	{
		level waittill( "process_character_extracam", extracam_data_struct );
		setup_character_extracam_settings( localClientNum, data_struct, extracam_data_struct );
	}
}

function process_character_extracam_request( localClientNum, jobIndex, extraCamIndex, sessionMode, characterIndex )
{
	level.extra_cam_hero_data.jobIndex = jobIndex;
	level.extra_cam_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_hero_data.characterIndex = characterIndex;
	level.extra_cam_hero_data.sessionMode = sessionMode;
	
	level notify( "process_character_extracam", level.extra_cam_hero_data );
}

function process_lobby_client_character_extracam_request( localClientNum, jobIndex, extraCamIndex, sessionMode )
{
	level.extra_cam_lobby_client_hero_data.jobIndex = jobIndex;
	level.extra_cam_lobby_client_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_lobby_client_hero_data.characterIndex = GetEquippedCharacterIndexForLobbyClientHero( localClientNum, jobIndex );
	level.extra_cam_lobby_client_hero_data.sessionMode = sessionMode;
	
	level notify( "process_character_extracam", level.extra_cam_lobby_client_hero_data );
}

function process_current_hero_headshot_extracam_request( localClientNum, jobIndex, extraCamIndex, sessionMode, characterIndex, isDefaultHero )
{
	level.extra_cam_headshot_hero_data.jobIndex = jobIndex;
	level.extra_cam_headshot_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_headshot_hero_data.characterIndex = characterIndex;
	level.extra_cam_headshot_hero_data.isDefaultHero = isDefaultHero;	
	level.extra_cam_headshot_hero_data.sessionMode = sessionMode;
	
	level notify( "process_character_extracam", level.extra_cam_headshot_hero_data );
}

function process_outfit_preview_extracam_request( localClientNum, jobIndex, extraCamIndex, sessionMode, outfitIndex )
{
	level.extra_cam_outfit_preview_data.jobIndex = jobIndex;
	level.extra_cam_outfit_preview_data.extraCamIndex = extraCamIndex;
	level.extra_cam_outfit_preview_data.characterIndex = outfitIndex;
	level.extra_cam_outfit_preview_data.sessionMode = sessionMode;
	
	level notify( "process_character_extracam", level.extra_cam_outfit_preview_data );
}
