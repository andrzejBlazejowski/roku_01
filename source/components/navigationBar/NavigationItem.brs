sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	applyTitle()
	m.top.observeField("title", "onTitleChanged")
	updateFocusLook()
	m.top.observeField("hasFocus", "OnHasFocusChanged")
    m.top.observeField("focusedChild", "OnChildFocused")
	m.top.findNode("titleLabel").observeField("hasFocus", "onTitleLabelHasFocusChanged")
end sub

sub onTitleChanged()
	applyTitle()
end sub

sub applyTitle()
	if m.titleLabel = invalid then return
	t = m.top.title
	if t = invalid OR t = "" then t = m.top.routeId
	if t <> invalid AND t <> "" then m.titleLabel.text = t
end sub

sub OnChildFocused()
	print "++++++++++++++++++++++++++++++++++++++++++++++++ navigation item OnChildFocused: "; m.top.focusedChild
	updateFocusLook()
end sub

sub OnHasFocusChanged()
	print "++++++++++++++++++++++++++++++++++++++++++++++++ navigation item OnHasFocusChanged: "; m.top.hasFocus
	updateFocusLook()
end sub

sub onTitleLabelHasFocusChanged()
	print "++++++++++++++++++++++++++++++++++++++++++++++++ navigation item onTitleLabelHasFocusChanged: "; m.titleLabel.hasFocus
	updateFocusLook()
end sub

sub updateFocusLook()
	if m.titleLabel = invalid then return
	if m.top.isInFocusChain() = true then
		m.titleLabel.color = "0xFF0000FF"
	else
		m.titleLabel.color = "0xCCFFFFFF"
	end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	' print "------------------- navigation item onKeyEvent: "; key
	if NOT press OR key <> "OK" then return false
	route = m.top.routeId
	if route = invalid OR route = "" then return false

	r = router()
	if r = invalid then return false

	r.route = route
	return true
end function

function router()
	s = m.top.getScene()
	if s = invalid then return invalid
	return s.findNode("router")
end function
