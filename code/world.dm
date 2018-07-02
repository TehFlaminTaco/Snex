datum/globals
	var/list/clients = list()

var/datum/globals/GLOB = new /datum/globals()

world
	New()
		setup_perms()
		setup_ranks()
		spawn(1)
			controller_loop()
		..()

	proc/controller_loop()
		while(1)
			for(var/datum/controller/C in controllers)
				C.try_fire()
			sleep(1)