/datum/controller
	var/delay = 1

	New()
		Repeater()

	proc/Repeater()
		spawn(delay)
			Fire()
			Repeater()

	proc/Fire()
		return