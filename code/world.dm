
world

	New()
		spawn(1)
			controller_loop()
		..()

	proc/controller_loop()
		while(1)
			for(var/datum/controller/C in controllers)
				C.try_fire()
			sleep(1)