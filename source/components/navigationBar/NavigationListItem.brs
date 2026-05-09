sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	m.activeColor = "0xCCFFFFFF"
	m.inactiveColor = "0xFFCCFFFF"
	m.selectedColor = "0xFFFFCCFF"
	ensureNavigationObservers()
	updateVisualState()
end sub

function navigationGroup() as Object
	n = m.top.getParent()
	while n <> invalid
		if n.subtype() = "Navigation" then return n
		n = n.getParent()
	end while
	s = m.top.getScene()
	if s = invalid then return invalid
	return s.findNode("navigation")
end function

sub ensureNavigationObservers()
	if m.navObserversAttached = true then return
	m.navOwner = navigationGroup()
	if m.navOwner = invalid then return
	m.navOwner.observeField("activeRouteId", "onNavigationOwnerFieldChanged")
	m.navOwner.observeField("navVisualRev", "onNavigationOwnerFieldChanged")
	m.navObserversAttached = true
end sub

sub onNavigationOwnerFieldChanged()
	updateVisualState()
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
	ensureNavigationObservers()
	t = c.TITLE
	if t = invalid OR t = "" then t = c.routeId
	if t <> invalid AND t <> "" then m.titleLabel.text = t
	updateVisualState()
end sub

sub onFocusVisualChanged()
	updateVisualState()
end sub

sub updateVisualState()
	if m.titleLabel = invalid then return
	focused = m.top.listHasFocus AND (m.top.itemHasFocus OR m.top.focusPercent > 0.5)
	if focused then
		m.titleLabel.color = m.selectedColor
		return
	end if
	myRoute = invalid
	c = m.top.itemContent
	if c <> invalid then myRoute = c.routeId
	activeId = invalid
	if m.navOwner <> invalid then activeId = m.navOwner.activeRouteId
	if activeId = invalid OR activeId = "" then
		r = router()
		if r <> invalid then activeId = r.route
	end if
	if activeId = invalid OR activeId = "" then activeId = "home"
	isActive = myRoute <> invalid AND myRoute <> "" AND activeId = myRoute
	if isActive then
		m.titleLabel.color = m.activeColor
	else
		m.titleLabel.color = m.inactiveColor
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
