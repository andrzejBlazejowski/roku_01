sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	applyTitle()
	m.top.observeField("title", "onTitleChanged")
	ensureNavigationObservers()
	updateFocusLook()
	m.top.observeField("hasFocus", "OnHasFocusChanged")
    m.top.observeField("focusedChild", "OnChildFocused")
	m.top.findNode("titleLabel").observeField("hasFocus", "onTitleLabelHasFocusChanged")
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
	updateFocusLook()
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
		return
	end if
	myRoute = m.top.routeId
	activeId = invalid
	if m.navOwner <> invalid then activeId = m.navOwner.activeRouteId
	if activeId = invalid OR activeId = "" then
		r = router()
		if r <> invalid then activeId = r.route
	end if
	if activeId = invalid OR activeId = "" then activeId = "home"
	isActive = myRoute <> invalid AND myRoute <> "" AND activeId = myRoute
	if isActive then
		m.titleLabel.color = "0xFFFFFFFF"
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
