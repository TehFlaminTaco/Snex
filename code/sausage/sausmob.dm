// Sausage angles
// 		NORTH SOUTH EAST WEST
// NORTH    N     O   NE   NW
// SOUTH
//  EAST
//  WEST

/mob/sausage
	name = "Sausage"
	var/mob/sausage/head // Refers to the next segment closest to the head. Not the head itself.
	var/mob/sausage/tail // Refers to the next segment closest to the tail.
	icon = 'icons/sausage.dmi'
	icon_state = "sausagetiny"
	density = 0
	animate_movement = NO_STEPS
	var/index = 1
	var/mob/sausage/head/face
	var/obj/pellet/spawner
	var/datum/skin/skin = new/datum/skin/rand()
	var/image/flesh_ovrl
	var/image/skin_ovrl

	New(var/loc,var/n_index,var/n_face)
		index = n_index
		face = n_face
		..()

	proc/get_face()
		if(istype(face))
			return face
		// Redudancy code
		if(istype(head))
			face = head.get_face()
		else
			face = src
		return face

	proc/force_move(var/turf/tloc)
		if(!tloc.dense()&&hit_worm(tloc))
			var/oldloc = loc
			loc = tloc
			if(istype(tail))
				tail.force_move(oldloc)
			update_icon()

	proc/hit_worm(var/tloc)
		for(var/mob/sausage/w in tloc)
			if(istype(w) && (istype(w.tail)||w.get_face()!=get_face()))
				return 0
		return 1

	proc/should_fall()
		if(istype(loc,/turf/climable))
			return 0
		var/turf/T = locate(x, y-1, z)
		if(T.dense())
			return 0
		for(var/mob/sausage/w in T)
			if(w.get_face()!=get_face())
				return 0
		if(istype(tail))
			return tail.should_fall()
		return 1

	proc/make_fall(var/ovr=0)
		if(ovr||should_fall())
			y -= 1
			if(istype(tail))
				tail.make_fall(1)

	proc/check_actions()
		if(istype(loc,/turf))
			var/turf/T = loc
			if(istype(src,/mob/sausage/head))
				if(!T.head_action(src))
					if(T.worm_action(src))
						return 1
				else
					return 1
			else
				if(T.worm_action(src))
					return 1
		if(istype(tail))
			return tail.check_actions()

	proc/check_conveyers()
		if(istype(loc, /turf/climable/convey))
			if(push(dir_x(loc.dir), dir_y(loc.dir)))
				return 1
		if(istype(tail))
			return tail.check_conveyers()

	proc/can_push(var/xoff=0,var/yoff=0,var/mdir=0)
		var/turf/T = locate(x+xoff, y+yoff, z)
		if(T.dense())
			return 0
		for(var/mob/sausage/w in T)
			if(w.get_face()!=get_face())
				return 0
		if((mdir==0||mdir==1)&&istype(head)&&!head.can_push(xoff,yoff,1))
			return 0
		if((mdir==0||mdir==-1)&&istype(tail)&&!tail.can_push(xoff,yoff,-1))
			return 0
		return 1

	proc/push(var/xoff=0,var/yoff=0,var/ovr=0,var/mdir=0)
		if(ovr||can_push(xoff,yoff))
			x += xoff
			y += yoff
			if((mdir==0||mdir==1)&&istype(head))
				head.push(xoff,yoff,1,1)
			if((mdir==0||mdir==-1)&&istype(tail))
				tail.push(xoff,yoff,1,-1)
			return 1
		return 0


	proc/can_eat(var/obj/pellet/P)
		if(spawner == P)
			return 0
		if(istype(tail))
			return tail.can_eat(P)
		return 1

	proc/grow(var/obj/pellet/P)
		if(spawner == P)
			return 0
		if(istype(tail))
			return tail.grow(P)
		else
			tail = new/mob/sausage(loc,index+1,get_face())
			tail.head = src
			tail.spawner = P
			tail.skin = skin
			get_face().len++
			return 1

	proc/shrink()
		if(!istype(tail))
			del(src)
		else
			tail.shrink()
			update_icon()
		return 1

	proc/update_icon()
		var/typ = "body"
		if(!istype(tail) && !istype(head))
			typ = "tiny"
		else if(!istype(head))
			typ = "head"
			dir = get_dir(tail.loc, loc)
		else if(!istype(tail))
			typ = "tail"
			dir = get_dir(loc, head.loc)
		else
			var/t_dir = get_dir(loc, tail.loc)
			var/h_dir = get_dir(loc, head.loc)
			dir = h_dir
			typ = "body[t_dir]"

		icon_state = "sausage[typ]"
		overlays.Cut()

		var/mob/sausage/head/f = get_face()
		if(istype(flesh_ovrl))
			del(flesh_ovrl)
		if(istype(skin_ovrl))
			del(skin_ovrl)

		flesh_ovrl = image(icon, icon_state = "flesh[typ]")
		flesh_ovrl.color = skin.get_point(index, f.len, src)
		overlays += flesh_ovrl

		skin_ovrl = image(icon, icon_state = "skin[typ]")
		if(istype(head))
			skin_ovrl.color = head.skin.get_point(index-1, f.len, src)
		else
			skin_ovrl.color = skin.get_point(index-1, f.len, src)
		overlays += skin_ovrl


/mob/sausage/head
	name = "Sausage"
	var/next_move = 0
	var/turf/oldloc
	var/did_push = 0
	var/len = 1


	New()
		if(spawns.len)
			loc = pick(spawns)
		update_icon()
		..(loc,1,src)
		oldloc = loc
		Life()

	can_push()
		if(did_push)
			return 0
		return ..()

	push(xoff,yoff)
		try_eat(locate(x+xoff,y+yoff,z))
		. = ..()
		if(.)
			did_push = 1
		return .

	get_face()
		return src

	shrink()
		if(istype(tail))
			return ..()
		return 0

	verb/possess(var/mob/sausage/head/H)
		H.client = usr.client

	proc/Life()
		make_fall()
		did_push = 0
		check_actions()
		check_conveyers()
		//if(client && oldloc != loc)
			//client.pixel_x=(oldloc.x-x)*ICON_SIZE
			//client.pixel_y=(oldloc.y-y)*ICON_SIZE
			//animate(client,pixel_x=0,pixel_y=0,2)
		oldloc = loc

		spawn(2)
			Life()

	proc/try_eat(var/atom/tloc)
		for(var/obj/pellet/P in tloc)
			if(can_eat(P))
				if(P.eat())
					grow(P)

	verb/delengthen()
		if(istype(tail))
			tail.shrink()
			update_icon()


	Move(tloc,dir,stepx,stepy)
		for(var/mob/sausage/S in tloc)
			if(S.get_face()!=src && !istype(S.tail))
				var/L = loc
				loc = S
				grow(new/obj/pellet(src))
				if(istype(tail))
					tail.force_move(L)
				tail.head = S
				S.tail = tail
				S.update_icon()
				tail.update_icon()

				if(client)
					var/mob/sausage/head/f = S.get_face()
					if(!istype(f.client))
						f.client = client
				del(src)
				return
		if(world.time>=next_move)
			try_eat(tloc)
			if(!istype(tail))
				src.dir = dir
			force_move(tloc)
			next_move = world.time + 2
			//if(client && oldloc != loc)
				//client.pixel_x=(oldloc.x-x)*ICON_SIZE
				//client.pixel_y=(oldloc.y-y)*ICON_SIZE