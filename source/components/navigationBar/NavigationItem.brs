sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	applyTitle()
	m.top.observeField("title", "onTitleChanged")
	updateFocusLook()
	m.top.observeField("hasFocus", "onHasFocusChanged")
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

sub onHasFocusChanged()
	updateFocusLook()
end sub

sub updateFocusLook()
	if m.titleLabel = invalid then return
	if m.top.hasFocus = true then
		m.titleLabel.color = "0x72D7EEFF"
	else
		m.titleLabel.color = "0xCCFFFFFF"
	end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
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
