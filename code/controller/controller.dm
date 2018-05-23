var/list/controllers = list()
/datum/controller
	var/delay = 1
	var/next_fire = 0

	New()
		controllers += src

	proc/try_fire()
		if(world.time >= next_fire)
			Fire()
			next_fire = world.time + delay


	proc/Fire()
		return