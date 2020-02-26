#include maps\_utility;

// Example from level script:
/*
main()
{
	PrecacheNotetrack( "name_of_notetrack_file" ); // Must be in your .csv file in order to work on the xenon. (Austin, we'll need Linker to recognize "PrecacheNotetrack()")

	level thread my_scene();
}

my_scene()
{
	wait( 5 );
	level thread maps\_notetrack::play_notetrack( "name_of_notetrack_file" );
}
*/

play_notetrack( notetrack )
{
	PlayNoteTrack( notetrack ); // This is a code function to begin the notetrack file.

	for(;;)
	{
		level waittill( notetrack, note, val1, val2, val3 );

		if( note == "end" ) // Sent automatically by code if the notetrack file is done playing.
		{
			return;
		}

		if( note == "play_sound_at_pos" )
		{
			// Now call the play_sound_in_space function in _utility.gsc
			level thread play_sound_in_space( val1, val2 );
		}
	}
}