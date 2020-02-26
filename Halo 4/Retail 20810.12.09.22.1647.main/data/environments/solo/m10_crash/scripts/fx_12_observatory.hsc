
// Observatory Window Shields ON

script static void fx_shield_fr_on()
	print ("::: shield front on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_03.effect, fx_win_shield_03 );
end

script static void fx_shield_rt_on()
	print ("::: shield right on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_01.effect, fx_win_shield_01 );	
end

script static void fx_shield_lf_on()
	print ("::: shield left on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_02.effect, fx_win_shield_02 );
end	


// Observatory Window Shields - Phantom Boarding Tube ON

script static void fx_shield_tube_fr_on()
	print ("::: shield tube front on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_hole_03.effect, fx_win_shield_03 );
end

script static void fx_shield_tube_rt_on()
	print ("::: shield tube right on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_hole_01.effect, fx_win_shield_01 );	
end
	
script static void fx_shield_tube_lf_on()
	print ("::: shield tube left on FX:::");
	effect_new (environments\solo\m10_crash\fx\shields\obs_win_shield_hole_02.effect, fx_win_shield_02 );
end


///////////////////////////////////////
///   Cortana - Plinth Floor Glow   ///
///////////////////////////////////////

// Cortana Plinth Floor Glow
script static void fx_cortana_plinth_glow_obs()
	print ("::: M10 - Cortana Plinth Floor Glow - FX :::");
	effect_new( objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, fx_cortana_plinth_obs );
end


////////////////////////////
///   Cortana - Rez-in   ///
////////////////////////////

// Cortana Rez-in
script static void fx_cortana_rez_obs()
	print ("::: M10 - Cortana Rez-in - FX :::");
	effect_new( objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, fx_cortana_rez_obs );
end
