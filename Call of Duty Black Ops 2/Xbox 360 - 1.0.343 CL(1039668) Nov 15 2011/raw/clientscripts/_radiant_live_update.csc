/* ---------------------------------------------------------------------------------
This script handles player radiant live update commands
-----------------------------------------------------------------------------------*/

main()
{
	thread scriptstruct_debug_render();
}

scriptstruct_debug_render()
{
	while( 1 )
	{
		level waittill( "liveupdate", selected_struct );
		
		if( isdefined(selected_struct) )
		{
			level thread render_struct( selected_struct );
		}
		else
		{
			level notify( "stop_struct_render" );
		}
	}
}

render_struct( selected_struct )
{
	self endon( "stop_struct_render" );
	
	while( isdefined( selected_struct ) )
	{
		Box( selected_struct.origin, (-16, -16, -16), (16, 16, 16), 0, (1, 0.4, 0.4) );
		wait 0.01;
	}
}

