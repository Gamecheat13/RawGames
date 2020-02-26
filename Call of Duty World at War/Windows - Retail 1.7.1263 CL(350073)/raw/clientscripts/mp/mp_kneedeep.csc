// clientside script for mp_kneedeep

main()
{
	clientscripts\mp\mp_kneedeep_fx::main();

//clientscripts\mp\_sherman::main( "vehicle_usa_tracked_sherman_m4a3_mp" );      
//clientscripts\mp\_type97::main(   "vehicle_jap_tracked_type97shinhoto_mp" );

	clientscripts\mp\_load::main();

	thread clientscripts\mp\_fx::fx_init(0);       

	thread clientscripts\mp\_audio::audio_init(0);
            
	thread clientscripts\mp\mp_kneedeep_amb::main();

	println("*** Client : mp_kneedeep running...");
}
