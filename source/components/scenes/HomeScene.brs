sub init()
	m.top.setFocus(true)
	print "================================================"
	print "HomeScene init"
	print "================================================"
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false ' optional: ignore key-up
    if key = "OK"
        print "OK"
        print "home scene--------------------------------"
        return true ' consumed — platform won't bubble default behavior
    else if key = "back"
        print "Back"
        print "home scene--------------------------------"
        return true
    else if key = "left" or key = "right" or key = "up" or key = "down"
        print "D-pad"
        print "home scene--------------------------------"
        return false ' let focused child or built-in navigation handle it
    end if
    return false
end function