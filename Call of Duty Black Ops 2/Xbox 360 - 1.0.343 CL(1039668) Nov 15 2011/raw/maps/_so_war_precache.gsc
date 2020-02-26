main()
{
	/#
	PrintLn("_so_war_precache");
	#/
	
	precacherumble( "damage_light" );
	
	// HUD items
	PrecacheString( &"SO_WAR_LASTSTAND_GETUP_BAR" );
	
	PrecacheString( &"SO_WAR_SURVIVAL_OBJECTIVE" );
	PrecacheString( &"SO_WAR_WAVE_TITLE" );
	PrecacheString( &"SO_WAR_WAVE_SUCCESS_TITLE" );
	PrecacheString( &"SO_WAR_SURVIVE_TIME" );
	PrecacheString( &"SO_WAR_WAVE_TIME" );
	PrecacheString( &"SO_WAR_PARTNER_READY" );
	PrecacheString( &"SO_WAR_READY_UP_WAIT" );
	PrecacheString( &"SO_WAR_READY_UP" );

	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_ACCURACY" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_TIME" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_WAVE" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_HEADSHOT" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_DAMAGE" );
	PrecacheString( &"SO_WAR_WAVE_PERFORMANCE_KILLS" );
	PrecacheString( &"SO_WAR_PERFORMANCE_REWARD" );
	
	precacheShader("perk_backing_blueshield"); //armor shield graphic
	PrecacheShader( "perk_second_chance" ); // last stand
	PrecacheShader( "hud_specops_ui_deltasupport" ); // ally drop
	PrecacheShader( "hudicon_spetsnaz_ctf_flag_carry" ); // ally drop
	
	PrecacheShader( "extracam2d_clean" ); // extra cam

	precacheShader("progress_bar_fill"); //armor shield graphic
	precacheShader("progress_bar_fg_sel"); //armor shield graphic


	// smoke grenade for the juggenaut drop off
	PrecacheItem( "willy_pete_sp" );
	
	// for AI dropping the rpg
	PrecacheItem( "rpg_player_sp" );
}
