var/list/spawns = list()


obj/spawn_point
	icon = 'icons/icons.dmi'
	icon_state = "SPAWNPOINT"

	New()
		spawns += loc
		del(src)