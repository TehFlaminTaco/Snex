/atom/movable
	var/gravity = 0
	var/anchored = 1
	var/did_push = 0
	animate_movement = NO_STEPS

	proc/can_push(var/pusher,var/xoff=0,var/yoff=0)
		if(did_push)
			return 0
		if(anchored)
			return 0
		var/turf/T = locate(x+xoff, y+yoff, z)

		// Manual Sausage Override for physics objects.
		for(var/mob/sausage/M in T)
			return 0


		return !T.dense()

	proc/push(var/pusher,var/xoff=0,var/yoff=0)
		if(can_push(pusher,xoff,yoff))
			if(pusher)
				did_push = 1
			x += xoff
			y += yoff
			return 1
		return 0

	proc/should_fall()
		return !istype(loc,/turf/climable)&&can_push(null,0,-1)

	proc/make_fall()
		return push(null,0,-1)