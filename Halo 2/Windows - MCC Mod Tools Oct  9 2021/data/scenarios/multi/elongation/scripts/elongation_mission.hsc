
(global short k_crate_spacing 400)

(script continuous crate_spawner_right
	; Spawn the crates
	(object_create crate_right00)
	(sleep k_crate_spacing)
	(object_create crate_right01)
	(sleep k_crate_spacing)
	(object_create crate_right02)
	(sleep k_crate_spacing)
	(object_create crate_right03)
	(sleep k_crate_spacing)
	(object_create crate_right04)
	(sleep k_crate_spacing)
	(object_create crate_right05)
	(sleep k_crate_spacing)
	(object_create crate_right06)
	(sleep k_crate_spacing)
	(object_create crate_right07)
	(sleep k_crate_spacing)
;	(object_create crate_right08)
;	(sleep k_crate_spacing)
;	(object_create crate_right09)
;	(sleep k_crate_spacing)
;	(object_create crate_right10)
;	(sleep k_crate_spacing)
;	(object_create crate_right11)
;	(sleep k_crate_spacing)
)

(script continuous crate_spawner_left
	; Spawn the crates
	(object_create crate_left00)
	(sleep k_crate_spacing)
	(object_create crate_left01)
	(sleep k_crate_spacing)
	(object_create crate_left02)
	(sleep k_crate_spacing)
	(object_create crate_left03)
	(sleep k_crate_spacing)
	(object_create crate_left04)
	(sleep k_crate_spacing)
	(object_create crate_left05)
	(sleep k_crate_spacing)
	(object_create crate_left06)
	(sleep k_crate_spacing)
	(object_create crate_left07)
	(sleep k_crate_spacing)
;	(object_create crate_left08)
;	(sleep k_crate_spacing)
;	(object_create crate_left09)
;	(sleep k_crate_spacing)
;	(object_create crate_left10)
;	(sleep k_crate_spacing)
;	(object_create crate_left11)
;	(sleep k_crate_spacing)
)

(script continuous crate_eraser
	; Destroy objects
	(object_destroy (list_get (volume_return_objects tv_crate_eraser_left) 0))
	(object_destroy (list_get (volume_return_objects tv_crate_eraser_right) 0))
)