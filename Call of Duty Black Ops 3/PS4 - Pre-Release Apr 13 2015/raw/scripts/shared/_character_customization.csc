#using scripts\core\_multi_extracam;

#using scripts\codescripts\struct;
#using scripts\shared\animation_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                     	                                    

#namespace character_customization;















	



	

	
#using_animtree("core_frontend");

function autoexec __init__sytem__() {     system::register("character_customization",&__init__,undefined,undefined);    }		

///////////////////////////////////////////////////////////////////////////
// SETUP
///////////////////////////////////////////////////////////////////////////
function __init__()
{
	level.characterModelTypes = GetHeroModelTypesEnum();
	level.extra_cam_render_hero_func_callback = &process_character_extracam_request;
	level.extra_cam_render_lobby_client_hero_func_callback = &process_lobby_client_character_extracam_request;
	level.extra_cam_render_current_hero_headshot_func_callback = &process_current_hero_headshot_extracam_request;
	level.extra_cam_render_outfit_preview_func_callback = &process_outfit_preview_extracam_request;
	level.model_type_bones = associativearray( "helmet", "", "head", "" );
	
	level.characterCustomizationSetup = &localClientConnect;
}

function localClientConnect( localClientNum )
{
	// setup our live and static characters
	level.liveCCData = setup_live_character_customization_target( localClientNum );
	level.staticCCData = setup_static_character_customization_target( localClientNum );
}

function create_character_data_struct( characterModel, model_type = undefined )
{	
	if ( !isdefined( characterModel ) )
	{
		return undefined;
	}
	
	data_struct = SpawnStruct();
	characterModel SetHighDetail();
	
	// models
	data_struct.characterModel = characterModel;
	data_struct.attached_models = array();
	data_struct.attached_entities = array();
	if ( isdefined( model_type ) )
	{
		data_struct.model_type = model_type;
	}
	else
	{
		data_struct.model_type = level.characterModelTypes["CCBODY_MODEL_THIRDPERSON"];
	}
	data_struct.origin = characterModel.origin;
	data_struct.angles = characterModel.angles;
	
	// indices
	data_struct.currentHeroIndex = 0;
	
	data_struct.currentBodyIndex = 0;
	data_struct.currentBodyColorIndex = array( 0, 0, 0 );

	data_struct.currentHelmetIndex = 0;
	data_struct.currentHelmetColorIndex = array( 0, 0, 0 );
	
	data_struct.currentHeadIndex = 0;
	
	data_struct.currentAnimation = undefined;
	data_struct.currentScene = undefined;
	
	// render options
	data_struct.body_render_options = GetHeroBodyRenderOptions( 0, 0, 0, 0, 0 );
	data_struct.helmet_render_options = GetHeroHelmetRenderOptions( 0, 0, 0, 0, 0 );
	data_struct.head_render_options = GetHeroHeadRenderOptions( 0 );
	
	// menu options
	data_struct.hide_helmet = false;
	data_struct.useFrozenMomentAnim = false;
	
	return data_struct;
}

function handle_forced_streaming( game_mode )
{
	heroes = GetHeroes( game_mode );
	foreach( hero in heroes )
	{
		bodies = GetHeroBodyModelIndices( hero, game_mode );
		helmets = GetHeroHelmetModelIndices( hero, game_mode );
		foreach( helmet in helmets )
		{
			ForceStreamXModel( helmet, 0, 1, true );
		}
		foreach( body in bodies )
		{
			ForceStreamXModel( body, 0, 1, true );
		}
	}
	
	heads = GetHeroHeadModelIndices( game_mode );
	foreach( head in heads )
	{
		ForceStreamXModel( head, 0, 1, true );
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
		characterIndex = GetEquippedHeroIndex( localClientNum );
	}

	defaultIndex = undefined;

	if ( ( isdefined( params.isDefaultHero ) && params.isDefaultHero ) )
	{
		defaultIndex = 0;
	}
	
	data_struct.currentHeroIndex = characterIndex;
	update_character_body( localClientNum, data_struct, defaultIndex, true, false, params.extracam_data );
	update_character_helmet( localClientNum, data_struct, defaultIndex, true, false, params.extracam_data );
	update_character_head( localClientNum, data_struct, defaultIndex, true, false, params.extracam_data );
	update_model_render_options( data_struct );
	
	update_character_animation_and_attachments( localClientNum, data_struct, params );
}

#using_animtree("generic");


function update_model_attachment( localClientNum, data_struct, attached_model, slot, model_anim )
{
	assert( isdefined( data_struct.attached_models ) );
	assert( isdefined( level.model_type_bones ) );
	
	if ( attached_model !== data_struct.attached_models[slot] )
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
				data_struct.characterModel Detach( data_struct.attached_models[slot], bone );
			}
		}
		

		data_struct.attached_models[slot] = attached_model;
		if ( isdefined( data_struct.attached_models[slot] ) )
		{
			if ( isDefined(model_anim) )
			{
				ent = Spawn( localClientNum, data_struct.characterModel.origin, "script_model" );
				data_struct.attached_entities[slot] = ent;
				ent SetModel( data_struct.attached_models[slot] );
				if ( !ent HasAnimTree() )
				{
					ent UseAnimTree( #animtree );
				}
				//ent LinkTo( data_struct.characterModel, bone );
				
				ent.origin = data_struct.characterModel GetTagOrigin( "tag_origin" );
				ent.angles = data_struct.characterModel GetTagAngles( "tag_origin" );
			
				ent AnimScripted( "_anim_notify_", ent.origin, ent.angles, model_anim, 0, 1 );
			}
			else
			{
				data_struct.characterModel Attach( data_struct.attached_models[slot], bone );
			}
		}
	}
}

function update_model_render_options( data_struct )
{
	data_struct.characterModel SetBodyRenderOptions( data_struct.body_render_options, data_struct.helmet_render_options, data_struct.head_render_options );
}

function update_body_render_options( data_struct, updateModelRenderOptions = true )
{
	render_options = GetHeroBodyRenderOptions( data_struct.currentHeroIndex, data_struct.currentBodyIndex, data_struct.currentBodyColorIndex[0], data_struct.currentBodyColorIndex[1], data_struct.currentBodyColorIndex[2] );
	
	if ( render_options !== data_struct.body_render_options )
	{
		data_struct.body_render_options = render_options;
		
		if ( updateModelRenderOptions )
		{
			update_model_render_options( data_struct );
		}
	}
}

function update_helmet_render_options( data_struct, updateModelRenderOptions = true )
{
	render_options = GetHeroHelmetRenderOptions( data_struct.currentHeroIndex, data_struct.currentHelmetIndex, data_struct.currentHelmetColorIndex[0], data_struct.currentHelmetColorIndex[1], data_struct.currentHelmetColorIndex[2] );
	
	if ( render_options !== data_struct.helmet_render_options )
	{
		data_struct.helmet_render_options = render_options;
		
		if ( updateModelRenderOptions )
		{
			update_model_render_options( data_struct );
		}
	}
}

function update_head_render_options( data_struct, updateModelRenderOptions = true )
{
	render_options = GetHeroHeadRenderOptions( data_struct.currentHeadIndex );
	
	if ( render_options !== data_struct.head_render_options )
	{
		data_struct.head_render_options = render_options;
		
		if ( updateModelRenderOptions )
		{
			update_model_render_options( data_struct );
		}
	}
}

function update_character_body( localClientNum, data_struct, body_index = undefined, forceUpdate = false, updateModelRenderOptions = true, extracam_data = undefined )
{
	assert( isdefined( data_struct.currentHeroIndex ) );
	
	if ( !isdefined( body_index ) )
	{
		if ( isdefined( extracam_data ) && extracam_data.useLobbyPlayers )
		{
			body_index = GetEquippedBodyIndexForHero( localClientNum, extracam_data.jobIndex, true );
		}
		else
		{
			body_index = GetEquippedBodyIndexForHero( localClientNum, data_struct.currentHeroIndex );
		}
	}
	
	if ( forceUpdate || body_index !== data_struct.currentBodyIndex )
	{
		data_struct.currentBodyIndex = body_index;
		model = GetHeroBodyModel( data_struct.currentHeroIndex, body_index, data_struct.model_type );
		data_struct.characterModel SetModel( model );
		
		bodyAccentColors = GetBodyAccentColorCountForHero( localClientNum, data_struct.currentHeroIndex, body_index );
		for ( i = 0; i < bodyAccentColors && i < data_struct.currentBodyColorIndex.size; i++ )
		{
			update_body_color( localClientNum, data_struct, i, undefined, true, false, extracam_data );
		}
		
		update_body_render_options( data_struct, updateModelRenderOptions );
	}
}

function update_body_color( localClientNum, data_struct, color_slot, color_index = undefined, forceUpdate = false, updateModelRenderOptions = true, extracam_data = undefined )
{
	assert( isdefined( data_struct.currentHeroIndex ) );
	assert( isdefined( data_struct.currentBodyIndex ) );
	assert( color_slot >= 0 && color_slot < data_struct.currentBodyColorIndex.size );
	
	if ( !isdefined( color_index ) )
	{
		if ( isdefined( extracam_data ) && extracam_data.useLobbyPlayers )
		{
			color_index = GetEquippedBodyAccentColorForHero( localClientNum, extracam_data.jobIndex, data_struct.currentBodyIndex, color_slot, true );
		}
		else
		{
			color_index = GetEquippedBodyAccentColorForHero( localClientNum, data_struct.currentHeroIndex, data_struct.currentBodyIndex, color_slot );
		}
	}
	
	if ( forceUpdate || color_index !== data_struct.currentBodyColorIndex[color_slot] )
	{
		data_struct.currentBodyColorIndex[color_slot] = color_index;
		update_body_render_options( data_struct, updateModelRenderOptions );
	}
}

function update_character_helmet( localClientNum, data_struct, helmet_index = undefined, forceUpdate = false, updateModelRenderOptions = true, extracam_data = undefined )
{
	assert( isdefined( data_struct.currentHeroIndex ) );
	
	if ( !isdefined( helmet_index ) )
	{
		if ( isdefined( extracam_data ) && extracam_data.useLobbyPlayers )
		{
			helmet_index = GetEquippedHelmetIndexForHero( localClientNum, extracam_data.jobIndex, true );
		}
		else
		{
			helmet_index = GetEquippedHelmetIndexForHero( localClientNum, data_struct.currentHeroIndex );
		}
	}
	
	if ( forceUpdate || helmet_index !== data_struct.currentHelmetIndex )
	{
		data_struct.currentHelmetIndex = helmet_index;
		model = GetHeroHelmetModel( data_struct.currentHeroIndex, helmet_index );
		
		update_model_attachment( localClientNum, data_struct, model, "helmet" );
		
		helmetAccentColors = GetHelmetAccentColorCountForHero( localClientNum, data_struct.currentHeroIndex, helmet_index );
		for ( i = 0; i < helmetAccentColors && i < data_struct.currentHelmetColorIndex.size; i++ )
		{
			update_helmet_color( localClientNum, data_struct, i, undefined, true, false, extracam_data );
		}
		
		update_helmet_render_options( data_struct, updateModelRenderOptions );
	}
}

function update_helmet_color( localClientNum, data_struct, color_slot, color_index = undefined, forceUpdate = false, updateModelRenderOptions = true, extracam_data = undefined )
{
	assert( isdefined( data_struct.currentHeroIndex ) );
	assert( isdefined( data_struct.currentHelmetIndex ) );
	assert( color_slot >= 0 && color_slot < data_struct.currentHelmetColorIndex.size );
	
	if ( !isdefined( color_index ) )
	{
		if ( isdefined( extracam_data ) && extracam_data.useLobbyPlayers )
		{
			color_index = GetEquippedHelmetAccentColorForHero( localClientNum, extracam_data.jobIndex, data_struct.currentHelmetIndex, color_slot, true );
		}
		else
		{
			color_index = GetEquippedHelmetAccentColorForHero( localClientNum, data_struct.currentHeroIndex, data_struct.currentHelmetIndex, color_slot );
		}
	}
	
	if ( forceUpdate || color_index !== data_struct.currentHelmetColorIndex[color_slot] )
	{
		data_struct.currentHelmetColorIndex[color_slot] = color_index;
		update_helmet_render_options( data_struct, updateModelRenderOptions );
	}
}

function update_character_head( localClientNum, data_struct, head_index = undefined, forceUpdate = false, updateModelRenderOptions = true, extracam_data = undefined )
{	
	if ( !isdefined( head_index ) )
	{
		if ( isdefined( extracam_data ) && extracam_data.useLobbyPlayers )
		{
			head_index = GetEquippedHeadIndexForHero( localClientNum, extracam_data.jobIndex );
		}
		else
		{
			head_index = GetEquippedHeadIndexForHero( localClientNum );
		}
	}
	
	if ( forceUpdate || head_index !== data_struct.currentHeadIndex )
	{
		data_struct.currentHeadIndex = head_index;
		model = GetHeroHeadModel( head_index );
		
		update_model_attachment( localClientNum, data_struct, model, "head" );
		update_head_render_options( data_struct, updateModelRenderOptions );
	}
}

#using_animtree("core_frontend");
function update_character_animation_and_attachments( localClientNum, data_struct, params )
{
	if ( !isdefined( params ) )
	{
		params = SpawnStruct();
	}
	
	if ( data_struct.useFrozenMomentAnim )
	{
		fields = GetHeroFields( data_struct.currentHeroIndex );
		
		if ( isdefined( fields.weaponFrontendFrozenMomentXAnim ) )
		{
			params.anim_name = fields.weaponFrontendFrozenMomentXAnim;
			params.scene = undefined;
			params.weapon_left = fields.weaponFrontendFrozenMomentWeaponLeftModel;
			params.weapon_left_anim = fields.weaponFrontendFrozenMomentWeaponLeftAnim;
			params.weapon_right = fields.weaponFrontendFrozenMomentWeaponRightModel;
			params.weapon_right_anim = fields.weaponFrontendFrozenMomentWeaponRightAnim;
			params.exploder_id = fields.weaponFrontendFrozenMomentExploder;
		}
		
		params.align_struct = data_struct;	// contains origin and angles to align to
	}
	
	if ( !isdefined( params.exploder_id ) )
	{
		params.exploder_id = data_struct.default_exploder;
	}
	
	if ( isdefined( params.anim_name ) && params.anim_name !== data_struct.currentAnimation )
	{
		data_struct.currentAnimation = params.anim_name;
		if ( !data_struct.characterModel HasAnimTree() )
		{
			data_struct.characterModel UseAnimTree( #animtree );
		}

		if (isdefined(params.align_struct) )
		{
			data_struct.characterModel.origin = params.align_struct.origin;
			data_struct.characterModel.angles = params.align_struct.angles;
			data_struct.characterModel thread animation::play( params.anim_name, params.align_struct.origin, params.align_struct.angles, 1, 0, 0, 0 );
		}
		else
		{
			data_struct.characterModel thread animation::play( params.anim_name );
		}
	}
	else if ( isdefined( params.scene ) && params.scene !== data_struct.currentScene )
	{
		if ( isdefined( data_struct.currentScene ) )
		{
			level scene::stop( data_struct.currentScene, false );
		}
		
		data_struct.currentScene = params.scene;
		level scene::play( params.scene );
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
	
	update_model_attachment( localClientNum, data_struct, params.weapon_right, "tag_weapon_right", params.weapon_right_anim );
	update_model_attachment( localClientNum, data_struct, params.weapon_left, "tag_weapon_left", params.weapon_left_anim );
}

function update_use_frozen_moments( localClientNum, data_struct, useFrozenMoments )
{
	if ( data_struct.useFrozenMomentAnim != useFrozenMoments )
	{
		data_struct.useFrozenMomentAnim = useFrozenMoments;
		update_character_animation_and_attachments( localClientNum, data_struct, undefined );
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
		customization_data_struct.default_exploder = "lights_character_customization";
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
		level waittill( "updateHero", eventType, param1, param2 );
		
		switch( eventType )
		{
			case "refresh":
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.weapon_right = "wpn_t7_arak_paint_shop";
				character_customization::loadEquippedCharacterOnModel( localClientNum, data_struct, undefined, params );
				break;
				
			case "changeHero":
				// param1 = hero index		
				params = spawnstruct();
				params.anim_name = "pb_cac_main_lobby_idle";
				params.weapon_right = "wpn_t7_arak_paint_shop";
				character_customization::loadEquippedCharacterOnModel( localClientNum, data_struct, param1, params );
				break;
				
			case "changeBody":
				//param1 = new body index
				character_customization::update_character_body( localClientNum, data_struct, param1 );				
				break;
				
			case "changeHelmet":
				//param1 = new helmet index
				character_customization::update_character_helmet( localClientNum, data_struct, param1 );				
				break;
				
			case "changeHead":
				//param1 = head index
				character_customization::update_character_head( localClientNum, data_struct, param1 );								
				break;
				
			case "changeBodyAccentColor":
				//param1 = accent color slot
				//param2 = accent color index
				character_customization::update_body_color( localClientNum, data_struct, param1, param2 );
				break;
				
			case "changeHelmetAccentColor":
				//param1 = accent color slot
				//param2 = accent color index
				character_customization::update_helmet_color( localClientNum, data_struct, param1, param2 );
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
		wait 0.01;
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

	loadEquippedCharacterOnModel( localClientNum, data_struct, extracam_data_struct.characterIndex, params );
	
	wait 0.05;	// wait for a bit to allow the models to get set up correctly and have the lighting update
		
	setExtraCamRenderReady( extracam_data_struct.jobIndex );
	
	extracam_data_struct.jobIndex = undefined;
	
	if( initializedExtracam )
	{
		level thread wait_for_extracam_close( camera_ent, extracam_data_struct.extraCamIndex );
	}
}

function do_we_have_data_to_process_extracam()
{
	while( true )
	{
		if ( CharacterCustomizationDataAvailable() ) 
		{
			return true;
		}
		
		wait 0.5;
	}
}

function update_character_extracam( localClientNum, data_struct )
{
	level endon( "disconnect" );
	
	while ( true )
	{
		level waittill( "process_character_extracam", extracam_data_struct );
		if ( do_we_have_data_to_process_extracam() )
		{
			setup_character_extracam_settings( localClientNum, data_struct, extracam_data_struct );
		}
	}
}

function process_character_extracam_request( localClientNum, extraCamIndex, jobIndex, characterIndex )
{
	level.extra_cam_hero_data.jobIndex = jobIndex;
	level.extra_cam_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_hero_data.characterIndex = characterIndex;
	
	level notify( "process_character_extracam", level.extra_cam_hero_data );
}

function process_lobby_client_character_extracam_request( localClientNum, extraCamIndex, jobIndex )
{
	level.extra_cam_lobby_client_hero_data.jobIndex = jobIndex;
	level.extra_cam_lobby_client_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_lobby_client_hero_data.characterIndex = GetEquippedCharacterIndexForLobbyClientHero( localClientNum, jobIndex );

	level notify( "process_character_extracam", level.extra_cam_lobby_client_hero_data );
}

function process_current_hero_headshot_extracam_request( localClientNum, extraCamIndex, jobIndex, characterIndex, isDefaultHero )
{
	level.extra_cam_headshot_hero_data.jobIndex = jobIndex;
	level.extra_cam_headshot_hero_data.extraCamIndex = extraCamIndex;
	level.extra_cam_headshot_hero_data.characterIndex = characterIndex;
	level.extra_cam_headshot_hero_data.isDefaultHero = isDefaultHero;	
	
	level notify( "process_character_extracam", level.extra_cam_headshot_hero_data );
}

function process_outfit_preview_extracam_request( localClientNum, extraCamIndex, jobIndex, outfitIndex )
{
	level.extra_cam_outfit_preview_data.jobIndex = jobIndex;
	level.extra_cam_outfit_preview_data.extraCamIndex = extraCamIndex;
	level.extra_cam_outfit_preview_data.characterIndex = outfitIndex;
	
	level notify( "process_character_extracam", level.extra_cam_outfit_preview_data );
}