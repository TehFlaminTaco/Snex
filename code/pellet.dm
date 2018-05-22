obj/pellet
	icon = 'icons/icons.dmi'
	icon_state = "pellet"
	density = 0
	var/eaten = 0

	proc/eat()
		if(eaten)
			return 0
		eaten = 1
		icon_state = "pellet_eaten"
		spawn(60)
			eaten = 0
			icon_state = "pellet"

		return 1