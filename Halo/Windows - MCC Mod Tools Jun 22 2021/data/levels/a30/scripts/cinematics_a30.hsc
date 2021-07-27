
;	A30 CINEMATICS

;========== Dialog Scripts ==========

(script dormant dialog_first_wave_4_alert
	(if (< 0 (ai_living_count first_marine)) (sound_impulse_start sound\dialog\a30\A30_210_Fitzgerald none 1))
	)

(script dormant dialog_one_rescued_prompt
	(sleep 1)
	(sound_impulse_start sound\dialog\a30\A30_860_Cortana none 1)
	)

(script dormant dialog_two_rescued_prompt
	(sleep 1)
	(cond ((not global_cliff_marine_rescued) (sound_impulse_start sound\dialog\a30\A30_870_Cortana none 1))
		 ((not global_river_marine_rescued) (sound_impulse_start sound\dialog\a30\A30_880_Cortana none 1))
		 ((not global_rubble_marine_rescued) (sound_impulse_start sound\dialog\a30\A30_890_Cortana none 1))
		 )

	(sleep -1)
	(sound_impulse_start sound\dialog\a30\A30_900_Cortana none 1)
;NEEDS NAV MARKER
	)

(script dormant cutscene_one_rescued_cliff
;This is played if the second rescue happens at the cliff
	(sound_impulse_start sound\dialog\a30\A30_930_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_930_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_940_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_940_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_950_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_950_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_960_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_960_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_970_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_970_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_980_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_980_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_990_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_990_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1000_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1000_Cortana))
	)

(script dormant cutscene_one_rescued_rubble
;This is played if the second rescue happens at the rubble
	(sound_impulse_start sound\dialog\a30\A30_930_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_930_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_940_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_940_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_950_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_950_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_960_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_960_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1030_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1030_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_980_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_980_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_990_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_990_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1000_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1000_Cortana))
	)

(script dormant cutscene_one_rescued_river
;This is played if the second rescue happens at the river
	(sound_impulse_start sound\dialog\a30\A30_930_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_930_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_940_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_940_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_950_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_950_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_960_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_960_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_970_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_970_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1040_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1040_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_990_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_990_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1000_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1000_Cortana))
	)

(script dormant dialog_one_rescued_killed
;This is played if the second rescue happens at the cliff
	(sound_impulse_start sound\dialog\a30\A30_1050_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1050_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1060_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1060_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_1070_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1070_Pilot))
	)

(script dormant dialog_two_rescued
	(sound_impulse_start sound\dialog\a30\A30_1080_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1080_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1090_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1090_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_1100_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1100_Cortana))
	)

(script dormant dialog_two_rescued_killed
	(sound_impulse_start sound\dialog\a30\A30_1110_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1110_Pilot))
	(sound_impulse_start sound\dialog\a30\A30_1120_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_1120_Cortana))

	)
