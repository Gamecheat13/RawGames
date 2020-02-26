#include common_scripts\utility;
#include maps\_utility;


#insert raw\maps\_scene.gsh;

//////////////////////////////////////////////////////////////////////////////////////////////////
main()
{
	maps\afghanistan::main();
}


/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
setup_skiptos()
{
	//Section 1
	add_skipto( "intro", maps\afghanistan_intro::skipto_intro, "Intro", maps\afghanistan_intro::main );
	add_skipto( "horse_intro", maps\afghanistan_horse_intro::skipto_intro, "Horse Intro", maps\afghanistan_horse_intro::main );
	add_skipto( "rebel_base_intro", maps\afghanistan_intro_rebel_base::skipto_intro, "rebel base intro", maps\afghanistan_intro_rebel_base::main );

	//Section 2
	add_skipto( "firehorse", maps\afghanistan_firehorse::skipto_firehorse, "Fire Horse", maps\afghanistan_firehorse::main );
	add_skipto( "wave_1", maps\afghanistan_wave_1::skipto_wave1, "Wave 1", maps\afghanistan_wave_1::main );
	add_skipto( "wave_2", maps\afghanistan_wave_2::skipto_wave2, "Wave 2", maps\afghanistan_wave_2::main );
	add_skipto( "wave_3", maps\afghanistan_wave_3::skipto_wave3, "Wave 3", maps\afghanistan_wave_3::main );
	add_skipto( "blocking_done", maps\afghanistan_blocking_done::skipto_blockingdone, "Blocking Done", maps\afghanistan_blocking_done::main );
		
	//Section 3
	add_skipto( "horse_charge", maps\afghanistan_horse_charge::skipto_horse_charge, "Horse Charge", maps\afghanistan_horse_charge::main );
	add_skipto( "krav_tank", maps\afghanistan_horse_charge::skipto_krav_tank, "Krav Tank", maps\afghanistan_horse_charge::after_button_mash_scene );
	add_skipto( "krav_captured", maps\afghanistan_krav_captured::skipto_krav_captured, "Krav Captured", maps\afghanistan_krav_captured::main );
	add_skipto( "interrogation", maps\afghanistan_krav_captured::skipto_krav_interrogation, "Krav Captured", maps\afghanistan_krav_captured::interrogation );
	add_skipto( "beat_down", maps\afghanistan_krav_captured::skipto_beat_down, "Beatdown", maps\afghanistan_krav_captured::beatdown );
	add_skipto( "deserted", maps\afghanistan_deserted::skipto_deserted, "Deserted", maps\afghanistan_deserted::main );
	
	default_skipto( "intro" );
}