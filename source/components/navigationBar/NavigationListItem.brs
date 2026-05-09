sub init()
	m.titleLabel = m.top.findNode("titleLabel")
end sub

sub onItemContentChanged()
	applyFromContent()
end sub

sub onLayoutChanged()
	if m.titleLabel = invalid then return
	if m.top.width > 0 then m.titleLabel.width = m.top.width
	if m.top.height > 0 then m.titleLabel.height = m.top.height
end sub

sub applyFromContent()
	if m.titleLabel = invalid then return
	c = m.top.itemContent
	if c = invalid then return
	t = c.TITLE
	if t = invalid OR t = "" then t = c.routeId
	if t <> invalid AND t <> "" then m.titleLabel.text = t
	onFocusVisualChanged()
end sub

sub onFocusVisualChanged()
	if m.titleLabel = invalid then return
	focused = m.top.listHasFocus AND (m.top.itemHasFocus OR m.top.focusPercent > 0.5)
	if focused then
		m.titleLabel.color = "0xFF0000FF"
	else
		m.titleLabel.color = "0xCCFFFFFF"
	end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
	if NOT press OR key <> "OK" then return false
	c = m.top.itemContent
	if c = invalid then return false
	route = c.routeId
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
