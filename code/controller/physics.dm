var/datum/controller/physics/physics_controller = new()
/datum/controller/physics
	delay = 1
	Fire()
		for(var/atom/movable/A in world)
			A.did_push = 0
			if(A.gravity && A.should_fall())
				A.make_fall()
