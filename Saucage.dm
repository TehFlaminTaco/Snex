/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 16	// 32x32 icon size by default

	view = 34		// show up to 6 tiles outward from center (13x13 view)
	mob = /mob/sausage/head
	turf = /turf/background

// Make objects move 8 pixels per tick when walking

mob
	step_size = 16

	New(var/atom/l)
		if(!istype(l))
			if(spawns.len)
				loc = pick(spawns)
obj
	step_size = 16

atom
	icon = 'icons/icons.dmi'