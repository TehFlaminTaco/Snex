/obj/powered/elevator
	icon = 'icons/elevator.dmi'
	icon_state = "retracted"
	var/top_icon = "retracted"
	var/mid_icon = "extended"
	var/extended = 0
	var/obj/powered/elevator/holder
	var/max_length = -1
	var/length = 0
	density = 1
	proc/extend()
		var/turf/T = get_step(loc,dir)
		for(var/obj/powered/elevator/E in T)
			if(E.dir == dir)
				E.extend()
				return
		if(T.dense())
			return
		if(holder.length == holder.max_length)
			return

		for(var/mob/sausage/W in T)
			if(!W.push(dir_x(dir),dir_y(dir)))
				return
		holder.length++
		var/obj/powered/elevator/P = new/obj/powered/elevator/pipe(T)
		P.dir = dir
		P.holder = holder
		icon_state = mid_icon
		extended = 1

	proc/retract()
		var/turf/T = get_step(loc,dir)
		for(var/obj/powered/elevator/E in T)
			if(E.dir == dir && E.extended)
				E.retract()
				return
			else if(E.dir == dir)
				del(E)
				extended = 0
				icon_state = top_icon
				holder.length--
				return
		if(src!=holder)
			holder.retract()

	whilst_powered()
		extend()

	whilst_unpowered()
		retract()


	New()
		holder = src
		icon_state = top_icon

/obj/powered/elevator/pipe
	top_icon = "head"
	mid_icon = "pipe"

	update()
		return