obj/pellet
	icon = 'icons/icons.dmi'
	icon_state = "pellet"
	density = 0

	var/eaten = 0

	push(var/pusher)
		if(istype(pusher,/mob/sausage))
			var/mob/sausage/M = pusher
			if(can_eat(M))
				M.grow(src)
				eat()
		return 0

	proc/can_eat(var/mob/sausage/M)
		if(M.spawner==src)
			return 0
		if(istype(M.tail))
			return can_eat(M.tail)
		return 1

	proc/eat()
		if(eaten)
			return 0
		eaten = 1
		icon_state = "pellet_eaten"
		spawn(60)
			eaten = 0
			icon_state = "pellet"

		return 1