var/datum/controller/physics/physics_controller = new()
/datum/controller/physics
	delay = 1
	Fire()
		for(var/atom/movable/A in world)
			if(A.gravity && A.should_fall())
				A.make_fall()
