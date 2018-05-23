turf
	icon = 'icons/turf/turf.dmi'
	proc/worm_action(var/mob/sausage/S)
		return 0

	proc/head_action(var/mob/sausage/head/H)
		return 0

	proc/dense()
		if(density)
			return 1
		for(var/atom/O in contents)
			if(O.density)
				return 1
		return 0

turf/wall
	density = 1
	icon = 'icons/turf/walls.dmi'
	icon_state = "0"
	New()
		spawn(1)
			update_icon()

	proc/update_icon()
		var/mask = 0
		var/turf/wall/MN = locate(x,y+1,z)
		var/turf/wall/ME = locate(x+1,y,z)
		var/turf/wall/MS = locate(x,y-1,z)
		var/turf/wall/MW = locate(x-1,y,z)
		if(istype(MN))
			mask |= NORTH
		if(istype(ME))
			mask |= EAST
		if(istype(MS))
			mask |= SOUTH
		if(istype(MW))
			mask |= WEST
		icon_state = "[mask]"

turf/background
	density = 0
	icon_state = "bg"

turf/climable
	density = 0
	icon_state = "climbable"

turf/climable/convey
	icon_state = "convey"
	process = 1
	update()
		for(var/atom/movable/M in src)
			M.push(src,dir_x(dir),dir_y(dir))

turf/wormulator
	icon = 'icons/turf/wormulator.dmi'
	icon_state = "0"

	head_action(var/mob/sausage/head/S)
		var/mob/sausage/H = S
		while(istype(H))
			if(!istype(H.loc,/turf/wormulator))
				return
			H = H.tail

		H = S
		while(istype(H))
			H.z++
			H = H.tail
	New()
		spawn(1)
			update_icon()

	proc/update_icon()
		var/mask = 0
		var/turf/wormulator/MN = locate(x,y+1,z)
		var/turf/wormulator/ME = locate(x+1,y,z)
		var/turf/wormulator/MS = locate(x,y-1,z)
		var/turf/wormulator/MW = locate(x-1,y,z)
		if(istype(MN))
			mask |= NORTH
		if(istype(ME))
			mask |= EAST
		if(istype(MS))
			mask |= SOUTH
		if(istype(MW))
			mask |= WEST
		icon_state = "[mask]"