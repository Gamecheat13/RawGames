#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\coup;
#include common_scripts\utility;

temp_prints( line1, line2, line3, line4 )
{
	if (1)
		return;
	
	temp_killprints();
	level.intro_offset = 0;
	lines = [];
	if( isdefined( line1 ) )
		lines[ lines.size ] = line1;
	
	if( isdefined( line2 ) )
		lines[ lines.size ] = line2;
	
	if( isdefined( line3 ) )
			lines[ lines.size ] = line3;
	
	if( isdefined( line4 ) )
			lines[ lines.size ] = line4;


	for( i=0; i < lines.size; i++ )
		maps\_introscreen::introscreen_corner_line( lines[ i ] );
	
	thread temp_prints_internal();
}

temp_prints_internal()
{
	level endon( "destroy_hud_elements" );	
	wait 3.5;
	temp_killprints();
}

temp_killprints()
{
	level notify( "destroy_hud_elements" );
}

fadeinBlackOut( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

dialogprint( string, delay )
{
	iprintln( string );
	
	if( isdefined( delay ) && delay > 0 )
		wait delay;
}
