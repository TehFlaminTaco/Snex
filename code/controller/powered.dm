var/datum/controller/power/power_controller = new()
/datum/controller/power
	delay = 0
	Fire()
		for(var/obj/powered/P in world)
			if(P.ticking)
				P.update()
