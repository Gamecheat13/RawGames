#include soundscripts\_snd;
#include soundscripts\_audio;
#include soundscripts\_audio_mix_manager;
#include maps\_shg_debug;

ONE_FRAME = 0.05;

snd_hud_init()
{
	/#
	assert( IsDefined( level._snd ) );
	
	level._snd.hud = SpawnStruct();
	
	// used to store incoming hud sets so when hud is enabled
	// dynamically, it will display latest info
	level._snd.hud.hud_input = spawnstruct();
		
	thread snd_hud_dvar_monitor_thread();
	#/
}

/#
enable_zone_hud()
{
	level._snd.hud.zone_hud_enabled = true;
}
#/	

/#
disable_zone_hud()
{
	level._snd.hud.zone_hud_enabled = undefined;
}
#/

/#
is_zone_hud_enabled()
{
	return IsDefined( level._snd.hud.zone_hud_enabled );
}
#/	

/#
enable_volmod_submix_hud()
{
	level._snd.hud.volmod_submix_hud_enabled = true;
}
#/	

/#
disable_volmod_submix_hud()
{
	level._snd.hud.volmod_submix_hud_enabled = undefined;
}
#/

/#
is_volmod_submix_hud_enabled()
{
	return IsDefined( level._snd.hud.volmod_submix_hud_enabled );
}
#/	

/#
enable_submix_hud()
{
	level._snd.hud.submix_hud_enabled = true;
}
#/	

/#
disable_submix_hud()
{
	level._snd.hud.submix_hud_enabled = undefined;
}
#/	
	
/#
is_submix_hud_enabled()
{
	return IsDefined( level._snd.hud.submix_hud_enabled );
}	
#/
	
/#
create_volmod_submix_hud()
{
	while( !IsDefined( level.uiParent ) )
	{
		wait( ONE_FRAME );
	}

	enable_volmod_submix_hud();
	
	// store the names for hud object destruction
	level._snd.hud.volmod_submix_hud = [];

	hud_data = undefined;
	if ( IsDefined( level._snd.hud.submix_data ) )
	{
		hud_data = level._snd.hud.submix_data;
	}
	else
	{		
		hud_data = spawnstruct();	
		hud_data.fontsize = 1.0;
		hud_data.value_x = 50;
		hud_data.label_x = 100;
		hud_data.y = 50;
		hud_data.label_color = (0.4, 0.9, 0.6);
		hud_data.value_color = (0.4, 0.6, 0.9);
		hud_data.number_color = (1.0, 1.0, 1.0);
		hud_data.spacing = 10;
		level._snd.hud.submix_data = hud_data;
	}
	
	new_volmod_submix_hud( "volmod_submixes_header", hud_data.label_x, hud_data.y, hud_data.label_color, "Volume Mod Submixes:", hud_data.fontsize );
		
	update_volmod_submix_hud();
}
#/
	
/#
new_volmod_submix_hud( store_label, x, y, color, label, fontsize )
{
	create_debug_text_hud( "volmod_submix_" + store_label, x, y, color, label, fontsize );
	level._snd.hud.volmod_submix_hud[ store_label ] = true;
}	
#/
		
/#
delete_volmod_submix_hud( store_label )
{
	if ( IsDefined( level._snd.hud.volmod_submix_hud[ store_label ] ) )
	{
		delete_debug_text_hud( "volmod_submix_" + store_label );
		level._snd.hud.volmod_submix_hud[ store_label ] = undefined;
	}
}
#/
		
/#
// this is the indented list of currently applied submixes
update_volmod_submix_hud()
{
	if ( is_volmod_submix_hud_enabled() )
	{
		num_volmods = mm_get_num_volmod_submixes();
		
		if ( num_volmods <= 0 )
			return;
			
		assert( IsDefined( level._snd.hud.submix_data ) );
		
		hd = level._snd.hud.submix_data;
		
		fontsize = hd.fontsize;
		label_x = hd.label_x;
		label_offset = label_x + 5; // no offset...
		value_color = hd.volmod_color;
		spacing = hd.spacing;
		y = hd.y + spacing;
		
		// first clear submix labels if they exist
		if ( !IsDefined( level._snd.hud.volmod_submix_hud ) )
			level._snd.hud.volmod_submix_hud = [];

		is_different = false;

		// check to see if anything changed
		for ( i = 0; i < num_volmods; i++ )
		{
			name = mm_get_volmod_submix_name_by_index( i );
			if ( !IsDefined( level._snd.hud.volmod_submix_hud[ name ] ) )
			{
				is_different = true;
				break;
			}
		}
		
		if ( !is_different )
		{
			foreach( submix_name, value in level._snd.hud.volmod_submix_hud )
			{
				if ( submix_name != "volmod_submixes_header" )
				{
					submix = mm_get_volmod_submix_by_name( submix_name );
					if ( !IsDefined( submix ) )
					{
						is_different = true;
						break;
					}
				}
			}	
		}		
		
		if ( is_different )
		{
			foreach( submix_name, value in level._snd.hud.volmod_submix_hud )
			{
				if ( submix_name != "volmod_submixes_header" )
					delete_volmod_submix_hud( submix_name );
			}
			
			for ( i = 0; i < num_volmods; i++ )
			{
				volmod_submix_name = mm_get_volmod_submix_name_by_index( i );
				assert( IsDefined( volmod_submix_name ) );
				
				if ( !IsDefined( level._snd.hud.volmod_submix_hud[ volmod_submix_name ] ) )
				{ 
					label = i + " - " + volmod_submix_name; // give the index of the volmod, so that it lines up with the volmod submix matrix
					new_volmod_submix_hud( volmod_submix_name, label_offset, y, value_color, label, fontsize );
					y += spacing;
				}
			}
		}
	}
}
#/

/#
create_zone_hud()
{
	enable_zone_hud();
	// make sure the hud stuff is initialized

	while( !IsDefined( level.uiParent ) )
	{
		wait( ONE_FRAME );
	}
	
	zone_hud = SpawnStruct();
	
	// store the names for easy destruction
	zone_hud.names = [];
	
	// store data to prevent reseting values
	zone_hud.data = [];
	
	fontsize = 1.0;
	value_x = 530;
	label_x = value_x - 75;
	y = 150;
	label_color = ( 0.4, 0.9, 0.6 );
	value_color = ( 0.4, 0.6, 0.9 );
	zone_color = ( 0.4, 0.9, 0.9 );
	number_color = (1.0, 1.0, 1.0);
	indent = 10; // sub-text from streamed ambience
	amp_indent = 30; // indents from label
	label_indent = amp_indent + 50; // indents from the amplitude
	zone_indent = 10;
	
	// ZONE
	create_debug_text_hud( "zone_label", label_x, y, label_color, "Zone:", fontsize );
	create_debug_text_hud( "zone_value", value_x, y, label_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "zone_label";
	zone_hud.names[ zone_hud.names.size ] = "zone_value";
	
	// STREAM
	y += 13;
	
	create_debug_text_hud( "stream_preset_label", label_x  + zone_indent, y, zone_color, "Streamed Ambience:", fontsize );
	create_debug_text_hud( "stream_preset_label_value", value_x, y, zone_color, "", fontsize ); // current streamed ambience

	zone_hud.names[ zone_hud.names.size ] = "stream_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "stream_preset_label_value";

	// STREAM FROM
	y += 10;
	
	create_debug_text_hud( "stream_preset_label_from", label_x  + zone_indent + indent, y, value_color, "From:", fontsize ); // from label
	create_debug_text_hud( "stream_preset_value_from_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "stream_preset_value_from", value_x, y, value_color, "", fontsize ); // from stream name

	zone_hud.names[ zone_hud.names.size ] = "stream_preset_label_from";
	zone_hud.names[ zone_hud.names.size ] = "stream_preset_value_from_amp";
	zone_hud.names[ zone_hud.names.size ] = "stream_preset_value_from";

	// STREAM TO
	y += 10;
	
	create_debug_text_hud( "stream_preset_label_to", label_x  + zone_indent + indent, y, value_color, "To:", fontsize ); // to label
	create_debug_text_hud( "stream_preset_value_to_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "stream_preset_value_to", value_x, y, value_color, "", fontsize ); // to stream name

	zone_hud.names[ zone_hud.names.size ] = "stream_preset_label_to";
	zone_hud.names[ zone_hud.names.size ] = "stream_preset_value_to_amp";
	zone_hud.names[ zone_hud.names.size ] = "stream_preset_value_to";

	// DAMB
	y += 13;
	
	create_debug_text_hud( "damb_preset_label", label_x + zone_indent, y, zone_color, "Dynamic Ambience:", fontsize );
	create_debug_text_hud( "damb_preset_value", value_x, y, zone_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_value";
	
	// DAMB FROM
	y += 10;
	
	create_debug_text_hud( "damb_preset_label_from", label_x  + zone_indent + indent, y, value_color, "From:", fontsize ); // from label
	create_debug_text_hud( "damb_preset_value_from_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "damb_preset_value_from", value_x, y, value_color, "", fontsize ); // from stream name

	zone_hud.names[ zone_hud.names.size ] = "damb_preset_label_from";
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_value_from_amp";
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_value_from";
	
	// DAMB TO
	y += 10;
	
	create_debug_text_hud( "damb_preset_label_to", label_x  + zone_indent + indent, y, value_color, "To:", fontsize ); // to label
	create_debug_text_hud( "damb_preset_value_to_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "damb_preset_value_to", value_x, y, value_color, "", fontsize ); // to stream name

	zone_hud.names[ zone_hud.names.size ] = "damb_preset_label_to";
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_value_to_amp";
	zone_hud.names[ zone_hud.names.size ] = "damb_preset_value_to";	
	
	// MIX
	y += 13;
	
	create_debug_text_hud( "mix_preset_label", label_x + zone_indent, y, zone_color, "Mix:", fontsize );
	create_debug_text_hud( "mix_preset_value", value_x, y, zone_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "mix_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "mix_preset_value";
	
	// REVERB
	y += 13;
	
	create_debug_text_hud( "reverb_preset_label", label_x + zone_indent, y, zone_color, "Reverb:", fontsize );
	create_debug_text_hud( "reverb_preset_value", value_x, y, zone_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "reverb_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "reverb_preset_value";
	
	// FILTER
	y += 13;
	
	create_debug_text_hud( "filter_preset_label", label_x + zone_indent, y, zone_color, "Filter:", fontsize );
	create_debug_text_hud( "filter_preset_value", value_x, y, zone_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_value";
	
	// FILTER FROM
	y += 10;
	
	create_debug_text_hud( "filter_preset_label_from", label_x  + zone_indent + indent, y, value_color, "From:", fontsize ); // from label
	create_debug_text_hud( "filter_preset_value_from_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "filter_preset_value_from", value_x, y, value_color, "", fontsize ); // from stream name

	zone_hud.names[ zone_hud.names.size ] = "filter_preset_label_from";
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_value_from_amp";
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_value_from";

	// FILTER TO
	y += 10;
	
	create_debug_text_hud( "filter_preset_label_to", label_x  + zone_indent + indent, y, value_color, "To:", fontsize ); // to label
	create_debug_text_hud( "filter_preset_value_to_amp", label_x  + zone_indent + amp_indent, y, number_color, "", fontsize ); // amp
	create_debug_text_hud( "filter_preset_value_to", value_x, y, value_color, "", fontsize ); // to stream name

	zone_hud.names[ zone_hud.names.size ] = "filter_preset_label_to";
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_value_to_amp";
	zone_hud.names[ zone_hud.names.size ] = "filter_preset_value_to";
	
	// OCCLUSION
	y += 13;
	
	create_debug_text_hud( "occlusion_preset_label", label_x + zone_indent, y, zone_color, "Occlusion:", fontsize );
	create_debug_text_hud( "occlusion_preset_value", value_x, y, zone_color, "", fontsize );

	zone_hud.names[ zone_hud.names.size ] = "occlusion_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "occlusion_preset_value";
	
	// MUSIC
	y += 15;
	
	create_debug_text_hud( "music_preset_label", label_x, y, label_color, "Music:", fontsize );
	create_debug_text_hud( "music_preset_value", value_x, y, label_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "music_preset_label";
	zone_hud.names[ zone_hud.names.size ] = "music_preset_value";

	// MUSIC SUBMIX
	y += 13;
	
	create_debug_text_hud( "music_submix_label", label_x + zone_indent, y, zone_color, "Music Submix:", fontsize );
	create_debug_text_hud( "music_submix_value", value_x, y, number_color, "", fontsize );
	
	zone_hud.names[ zone_hud.names.size ] = "music_submix_label";
	zone_hud.names[ zone_hud.names.size ] = "music_submix_value";

	// DAMB ENTITY COUNTER
	y += 15;
		
	create_debug_text_hud( "damb_entity_count_label", label_x, y, label_color, "Ambient Entity Count:", fontsize );
	create_debug_text_hud( "damb_entity_count_value", value_x, y, number_color, "", fontsize );
	zone_hud.names[ zone_hud.names.size ] = "damb_entity_count_label";
	zone_hud.names[ zone_hud.names.size ] = "damb_entity_count_value";
	
	level._snd.hud.zone_hud = zone_hud;
	
	set_hud_values();
}
#/

/#
set_hud_values()
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	if ( IsDefined( level._snd.hud.hud_input.occlusion ) )
	{
		set_occlusion_hud( level._snd.hud.hud_input.occlusion );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.filter_from_name ) )
	{
		name = level._snd.hud.hud_input.filter_from_name;
		amp = level._snd.hud.hud_input.filter_from_amp;
		set_filter_from_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.filter_to_name ) )
	{
		name = level._snd.hud.hud_input.filter_to_name;
		amp = level._snd.hud.hud_input.filter_to_amp;
		set_filter_to_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.filter) )
	{
		name = level._snd.hud.hud_input.filter;
		set_filter_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.reverb) )
	{
		name = level._snd.hud.hud_input.reverb;
		set_reverb_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.mix ) )
	{
		name = level._snd.hud.hud_input.mix;
		set_mix_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.damb_from_name ) )
	{
		name = level._snd.hud.hud_input.damb_from_name;
		amp = level._snd.hud.hud_input.damb_from_amp;
		set_damb_from_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.damb_to_name ) )
	{
		name = level._snd.hud.hud_input.damb_to_name;
		amp = level._snd.hud.hud_input.damb_to_amp;
		set_damb_to_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.damb) )
	{
		name = level._snd.hud.hud_input.damb;
		set_damb_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.stream_from_name ) )
	{
		name = level._snd.hud.hud_input.stream_from_name;
		amp = level._snd.hud.hud_input.stream_from_amp;
		set_stream_from_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.stream_to_name ) )
	{
		name = level._snd.hud.hud_input.stream_to_name;
		amp = level._snd.hud.hud_input.stream_to_amp;
		set_stream_to_hud( name, amp );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.stream) )
	{
		name = level._snd.hud.hud_input.stream;
		set_stream_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.zone ) )
	{
		name =level._snd.hud.hud_input.zone;
		set_zone_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.music) )
	{
		name = level._snd.hud.hud_input.music;
		set_music_hud( name );
	}
	
	if ( IsDefined( level._snd.hud.hud_input.music_submix ) )
	{
		amp = level._snd.hud.hud_input.music_submix;
		set_music_submix_hud( amp );
	}
}
#/

/#
set_occlusion_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.occlusion = name;
	thread set_hud_data( name, "occlusion_preset_value" );
}
#/

/#
set_filter_from_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.filter_from_name = name;
	level._snd.hud.hud_input.filter_from_hud = amp;
	thread set_from_or_to( name, amp, "filter_preset_value_from", "filter_preset_value_from_amp" );
}
#/

/#
set_filter_to_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.filter_to_name = name;
	level._snd.hud.hud_input.filter_to_hud = amp;
	thread set_from_or_to( name, amp, "filter_preset_value_to", "filter_preset_value_to_amp" );
}
#/

/#
set_filter_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.filter = name;
	thread set_hud_data( name, "filter_preset_value" );
}
#/

/#
set_reverb_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.reverb = name;
	thread set_hud_data( name, "reverb_preset_value" );
}
#/

/#
set_mix_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.mix = name;
	thread set_hud_data( name, "mix_preset_value" );
}
#/

/#
set_damb_from_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.damb_from_name = name;
	level._snd.hud.hud_input.damb_from_amp = amp;
	thread set_from_or_to( name, amp, "damb_preset_value_from", "damb_preset_value_from_amp" );
}
#/

/#
set_damb_to_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.damb_to_name = name;
	level._snd.hud.hud_input.damb_to_amp = amp;
	thread set_from_or_to( name, amp, "damb_preset_value_to", "damb_preset_value_to_amp" );
}
#/

/#
set_damb_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.damb = name;
	thread set_hud_data( name, "damb_preset_value" );
}
#/

/#
set_stream_from_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.stream_from_name = name;
	level._snd.hud.hud_input.stream_from_amp = amp;
	thread set_from_or_to( name, amp, "stream_preset_value_from", "stream_preset_value_from_amp" );
}
#/

/#
set_stream_to_hud( name, amp )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.stream_to_name = name;
	level._snd.hud.hud_input.stream_to_amp = amp;
	thread set_from_or_to( name, amp, "stream_preset_value_to", "stream_preset_value_to_amp" );
}
#/

/#
set_stream_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.stream = name;
	thread set_hud_data( name, "stream_preset_label_value" );
}
#/

/#
set_zone_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.zone = name;
	thread set_hud_data( name, "zone_value" );
}
#/

/#
set_music_hud( name )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.music = name;
	thread set_hud_data( name, "music_preset_value" );
}
#/

/#
set_music_submix_hud( value )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.music_submix = value;
	
	if ( is_zone_hud_enabled() )
	{
		while( !IsDefined( level._snd.hud ) )
		{
			wait( ONE_FRAME );
		}
		
		zone_hud = level._snd.hud.zone_hud;
		assert( IsDefined( zone_hud ) );
		assert( IsDefined( zone_hud.data ) );
		
		if ( !IsDefined( zone_hud.data[ "music_submix_value" ] ) )
			zone_hud.data[ "music_submix_value" ] = "";
		
		string_value = value + "";
		if ( zone_hud.data[ "music_submix_value" ] != string_value )
		{
			zone_hud.data[ "music_submix_value" ] = string_value;
			print_debug_text_hud( "music_submix_value", value );
		}
	}
}
#/

/#
set_damb_entity_hud( value )
{
	assert( IsDefined( level._snd.hud.hud_input ) );
	level._snd.hud.hud_input.entity = value;
	
	if ( is_zone_hud_enabled() )
	{
		// make sure the hud stuff is initialized
		while( !Isdefined( level._snd.hud ) )
		{
			wait( ONE_FRAME );
		}
		
		zone_hud = level._snd.hud.zone_hud;
		assert( IsDefined( zone_hud ) );
		assert( IsDefined( zone_hud.data ) );
		
		if ( !IsDefined( zone_hud.data[ "damb_entity_count_value" ] ) )
			zone_hud.data[ "damb_entity_count_value" ] = "";
		
		string_value = value + "";
		if ( zone_hud.data[ "damb_entity_count_value" ] != string_value )
		{
			zone_hud.data[ "damb_entity_count_value" ] = string_value;
			print_debug_text_hud( "damb_entity_count_value", value );
		}
	}
}
#/

/#
set_hud_data( name, preset_value )
{
	if ( is_zone_hud_enabled() )
	{
		// make sure the hud stuff is initialized
		while( !IsDefined( level._snd.hud ) )
		{
			wait( ONE_FRAME );
		}
		
		if ( !IsDefined( name ) )
			name = "";
		
		if ( !IsDefined( preset_value ) )
			preset_value = "";

		zone_hud = level._snd.hud.zone_hud;
		assert( IsDefined( zone_hud ) );
		assert( IsDefined( zone_hud.data ) );
		assert( IsString( preset_value ) );
		
		if ( !IsDefined( zone_hud.data[ preset_value ] ) )
			zone_hud.data[ preset_value ] = "";
		
		if ( zone_hud.data[ preset_value ] != name )
		{
			zone_hud.data[ preset_value ] = name;
			print_debug_text_string_hud( preset_value, name );
		}
	}
}
#/

/#
// utility to set from or to labels in audio debug hud
set_from_or_to( name, amp, preset_value, preset_amp )
{
	if ( is_zone_hud_enabled() )
	{
		// make sure the hud stuff is initialized
		while( !IsDefined( level._snd.hud ) )
		{
			wait( ONE_FRAME );
		}
		
		if ( !IsDefined( name ) )
			name = "";
			
		if ( !IsDefined( amp ) || name == "" )
			amp = "";
		
		zone_hud = level._snd.hud.zone_hud;
		
		assert( IsDefined( zone_hud ) );
		assert( IsDefined( zone_hud.data ) );
		
		if ( !IsDefined( zone_hud.data[ preset_value ] ) )
			zone_hud.data[ preset_value ] = "";
		
		if ( zone_hud.data[ preset_value ] != name )
		{
			zone_hud.data[ preset_value ] = name;
			print_debug_text_string_hud( preset_value, name );
		}

		if ( !IsDefined( zone_hud.data[ preset_amp ] ) )
			zone_hud.data[ preset_amp ] = "";
		
		amp_string = amp + "";
		if ( zone_hud.data[ preset_amp ] != amp_string)
		{
			zone_hud.data[ preset_amp ] = amp_string;
			if ( IsString( amp ) )
			{
				print_debug_text_string_hud(preset_amp, amp );
			}
			else
			{
				val = int( amp*1000);
				print_debug_text_hud(preset_amp, val / 1000.0);
			}
		}
	}
}
#/

/#
destroy_zone_hud()
{
	if ( IsDefined( level._snd.hud.zone_hud ) )
	{
		zone_hud = level._snd.hud.zone_hud;

		foreach( name in zone_hud.names )
		{
			delete_debug_text_hud( name );
		}

		disable_zone_hud();
		level._snd.hud.zone_hud = undefined;
	}
}
#/

/#
snd_hud_dvar_monitor_thread()
{
	wait( 0.1 ); // init wait for system initializations	

	while ( 1 )
	{
		wait( 0.5 );
		check_zone_hud_dvar();
		check_submix_hud_dvar();
	}
}
#/

/#
check_zone_hud_dvar()
{
	SetDvarIfUninitialized( "zone_hud", "0" );
	dvar = GetDvar( "zone_hud" );
	if ( dvar == "1" )
	{
		if ( !is_zone_hud_enabled() )
			create_zone_hud();
	}
	else if ( dvar == "0" )
	{
		if ( is_zone_hud_enabled() )
			destroy_zone_hud();
	}
}
#/
	
/#
check_submix_hud_dvar()
{
	SetDvarIfUninitialized( "submix_hud", "0" );
	dvar = GetDvar( "submix_hud" );
	if ( dvar == "1" )
	{
		if ( !is_volmod_submix_hud_enabled() )
		{
			create_volmod_submix_hud();
		}				
	}
	else if ( dvar == "0" )
	{
		if ( is_volmod_submix_hud_enabled() )
		{
			disable_volmod_submix_hud();
		}
	}
}
#/
	
