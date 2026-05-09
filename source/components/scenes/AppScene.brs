sub init()
	m.top.setFocus(true)
	m.navigation = m.top.findNode("navigation")
	m.router = m.top.findNode("router")
end sub

sub focusNavigationMenu()
	if m.navigation = invalid then return
	print "------------------- focusNavigationMenu"
	m.navigation.setFocus(true)

end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press then return false
	' print "------------------- app scene onKeyEvent: "; key
	if key = "options"
		focusNavigationMenu()
		return true
	end if
	return false
end function
