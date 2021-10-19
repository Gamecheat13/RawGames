;(script continuous lockout_main
;	(add_recycling_volume garbage 0 2)
;	(sleep 60)
;)
;(script continuous lockout_pad
;	(add_recycling_volume garbage_pad 20 15)
;	(sleep 450)
;)
;(script continuous lockout_sniper_hi
;	(add_recycling_volume garbage_sniper_hi 20 15)
;	(sleep 450)
;)
;(script continuous lockout_sniper_lo
;	(add_recycling_volume garbage_sniper_lo 20 15)
;	(sleep 450)
;)
;(script continuous lockout_pad_lo
;	(add_recycling_volume garbage_pad_lo 20 15)
;	(sleep 450)
;)
;(script continuous lockout_br_tower_hi
;	(add_recycling_volume garbage_br_tower_hi 20 15)
;	(sleep 450)
;)
;(script continuous lockout_br_tower_lo
;	(add_recycling_volume garbage_br_tower_lo 20 15)
;	(sleep 450)
;)
;(script continuous lockout_sniper_bottom
;	(add_recycling_volume garbage_sniper_bottom 20 15)
;	(sleep 450)
;)
;(script continuous lockout_br_tower_bottom
;	(add_recycling_volume garbage_br_tower_bottom 20 15)
;	(sleep 450)
;)
(script continuous lockout_all
	(add_recycling_volume garbage_all 30 30)
	(sleep 900)
)