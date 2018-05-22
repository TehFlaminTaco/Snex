/datum/skin
	proc/get_point(var/index, var/len, var/mob/sausage/S)
		return "#FFFFFF"

/datum/skin/rand
	var/datum/skin/holder
	New()
		var/t = pick(/datum/skin/alternating/rand, /datum/skin/plain/rand, /datum/skin/two_col/rand, /datum/skin/rainbow)
		holder = new t()

	get_point(var/index, var/len, var/mob/sausage/S)
		return holder.get_point(index,len,S)


/datum/skin/blue
	get_point()
		return "#0000FF"

/datum/skin/alternating
	var/col1="#FFFFFF"
	var/col2="#000000"
	New(var/c1="#FFFFFF",var/c2="#000000")
		col1=c1
		col2=c2
	get_point(var/i)
		if(i%2)
			return col1
		return col2

/datum/skin/alternating/rand
	New()
		..(rgb(rand()*255,rand()*255,rand()*255),rgb(rand()*255,rand()*255,rand()*255))

/datum/skin/plain
	var/col = "#FFFFFF"
	New(var/c="#FFFFFF")
		col=c
	get_point()
		return col

/datum/skin/plain/rand
	New()
		..(rgb(rand()*255,rand()*255,rand()*255))

/datum/skin/two_col
	var/col1="#FFFFFF"
	var/col2="#000000"
	New(var/c1="#FFFFFF",var/c2="#000000")
		col1=c1
		col2=c2
	get_point(var/i, var/len)
		return lerp(col1,col2,i/len)

/datum/skin/two_col/rand
	New()
		..(rgb(rand()*255,rand()*255,rand()*255),rgb(rand()*255,rand()*255,rand()*255))

/datum/skin/rainbow
	get_point(var/i)
		if(i%3==0)
			return "#FF0000"
		if(i%3==1)
			return "#00FF00"
		if(i%3==2)
			return "#0000FF"