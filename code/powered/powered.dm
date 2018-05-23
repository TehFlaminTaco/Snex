/obj/powered
	icon = 'icons/powered.dmi'
	var/power = 0
	var/ticking = 1

	proc/update()
		if(power>0)
			return whilst_powered()
		else
			return whilst_unpowered()

	proc/whilst_powered()
		return

	proc/whilst_unpowered()
		return

/obj/powered/wire
	var/src_dir = NORTH
	var/tar_dir = SOUTH
	icon_state = "wire0"

	update()
		power = 0
		dir = src_dir | tar_dir
		if(dir&NORTH && dir&SOUTH)
			dir = NORTH
		if(dir&EAST && dir&WEST)
			dir = EAST
		for(var/obj/powered/P in get_step(loc,src_dir))
			power += P.power
		for(var/obj/powered/P in get_step(loc,tar_dir))
			if(!istype(P,/obj/powered/gate))
				P.power = power
		name = "[src_dir] > [tar_dir]"
		icon_state = "wire[power>0]"

/obj/powered/wire_exploder
	icon_state = "exploder"
	var/exploded = 0
	proc/Explode(var/src_dir)
		if(exploded)
			return
		exploded = 1
		for(var/D in adjecent)
			if(D != src_dir)
				for(var/obj/powered/P in get_step(src.loc, D))
					var/obj/powered/wire/W = new(src.loc)
					W.src_dir = src_dir
					W.tar_dir = D
					W.update()
					if(istype(P,/obj/powered/wire_exploder))
						var/obj/powered/wire_exploder/WE = P
						WE.Explode(get_dir(get_step(src.loc,D), src.loc))
		del(src)

/obj/powered/button
	icon_state = "button"
	New()
		spawn(1)
			for(var/D in adjecent)
				for(var/obj/powered/wire_exploder/WE in get_step(src.loc, D))
					WE.Explode(inv_adj(D))

	update()
		power = 0
		for(var/atom/movable/M in loc)
			if(!M.anchored)
				power = 1
				return

/obj/powered/button_once
	icon_state = "button"
	New()
		spawn(1)
			for(var/D in adjecent)
				for(var/obj/powered/wire_exploder/WE in get_step(src.loc, D))
					WE.Explode(inv_adj(D))

	update()
		if(power)
			return
		for(var/atom/movable/M in loc)
			if(!M.anchored)
				power = 1

/obj/powered/button_toggle
	icon_state = "button"
	var/had_worm = 0
	New()
		spawn(1)
			for(var/D in adjecent)
				for(var/obj/powered/wire_exploder/WE in get_step(src.loc, D))
					WE.Explode(inv_adj(D))

	update()
		var/found_worm = 0
		for(var/atom/movable/M in loc)
			if(!M.anchored)
				found_worm = 1
				if(!had_worm)
					power = !power
		had_worm = found_worm

/obj/powered/gate
	icon = 'icons/gate.dmi'

	New()
		spawn(1)
			for(var/obj/powered/wire_exploder/WE in get_step(src.loc, dir))
				WE.Explode(inv_adj(dir))

	var/list/inputs = list()
	update()
		inputs.Cut()
		for(var/D in adjecent)
			if(D!=dir)
				for(var/obj/powered/wire/P in get_step(src.loc,D))
					if(P.tar_dir == inv_adj(D))
						inputs += P.power
				for(var/obj/powered/gate/P in get_step(src.loc,D))
					if(P.dir == inv_adj(D))
						inputs += P.power
		power = action()
		for(var/obj/powered/P in get_step(src.loc,dir))
			P.power = power

	proc/action()
		return 0

/obj/powered/gate/not
	icon_state = "not"

	action()
		var/T = 0
		for(var/D in inputs)
			T += D
		name = "NOT: [T] [T<=0]"
		return T<=0

/obj/powered/gate/or
	icon_state = "or"

	action()
		var/T = 0
		for(var/D in inputs)
			T += D
		name = "OR: [T]"
		return T

/obj/powered/gate/xor
	icon_state = "xor"

	action()
		var/T = 0
		for(var/D in inputs)
			T ^= D
		name = "XOR: [T]"
		return T