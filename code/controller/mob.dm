/mob/proc/Life()
	return 0

var/datum/controller/mob/mob_controller = new()
/datum/controller/mob
	delay = 1
	Fire()
		for(var/mob/M in world)
			M.Life()