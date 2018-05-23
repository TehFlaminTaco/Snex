/mob/sausage/verb
	delengthen()
		set name = "Shrink"
		set category = "Debug"
		if(istype(tail))
			tail.shrink()
			update_icon()

	say(var/txt as text)
		set name = "Say"
		set category = "IC"

		world << "<b>[src]:</b> \"[html_decode(txt)]\""

	emote(var/txt as text)
		set name = "Me"
		set category = "IC"

		world << "<b>[src] [html_decode(txt)]</b>"