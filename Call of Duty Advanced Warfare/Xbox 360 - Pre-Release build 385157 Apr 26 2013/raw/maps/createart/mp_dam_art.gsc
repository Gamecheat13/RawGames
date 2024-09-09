// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	if (IsUsingHDR())
		maps\createart\mp_dam_fog_hdr::SetupFog( );
	else
		maps\createart\mp_dam_fog::SetupFog( );
	VisionSetNaked( "mp_dam", 0 );

}
