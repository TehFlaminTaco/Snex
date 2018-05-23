/turf
	var/process = 0
	New()
		if(process)
			turf_controller.processing+=src

	proc/update()
		return

var/datum/controller/turf/turf_controller = new()
/datum/controller/turf
	var/list/processing = list()
	delay = 1
	Fire()
		for(var/turf/T in processing)
			T.update()