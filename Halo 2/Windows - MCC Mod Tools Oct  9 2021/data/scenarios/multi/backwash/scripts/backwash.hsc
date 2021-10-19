(script continuous backwash_weather
;	(weather_stop 0)
;	(sleep (random_range 150 300))
;	(print "starting")
;	(weather_start (random_range 10 20))
;	(sleep (random_range 900 1200))

	(weather_start 0)
	(weather_change_intensity 0 0.3)
	(sleep (random_range 900 1800))
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(print "stopping")
					(weather_stop (random_range 10 20))
					(sleep (random_range 900 1800))
					(print "restarting")
					(weather_start (random_range 10 20))
					(sleep (random_range 900 1800))
				)
;				(begin
;					(print "light rain")
;					(weather_change_intensity (random_range 10 20) 0.3)
;					(sleep (random_range 900 1800))
;				)
				(begin
					(print "light rain")
					(weather_change_intensity (random_range 10 20) 0.3)
					(sleep (random_range 900 1800))
				)
				(begin
					(print "light rain")
					(weather_change_intensity (random_range 10 20) 0.3)
					(sleep (random_range 900 1800))
				)
				(begin
					(print "heavy rain")
					(weather_change_intensity (random_range 10 20) 1)
					(sleep (random_range 900 1200))
					(weather_change_intensity (random_range 10 20) 0.3)
					(sleep (random_range 900 1200))
				)
			)
			FALSE
		)
	)
)