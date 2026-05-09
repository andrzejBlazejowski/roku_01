sub init()
	m.navigationItemsList = m.top.findNode("navigationItemsList")
	syncActiveRouteFromRouter()
	observeRouterRoute()
	m.navigationItemsList.content = navigationContent()
	m.navigationItemsList.observeField("itemSelected", "onNavigationItemSelected")
	m.top.observeField("focusedChild", "OnChildFocused")
	m.top.navVisualRev = 0
	observeSceneFocusedChild()
	m.top.setFocus(true)
end sub

sub syncActiveRouteFromRouter()
	r = routerFromScene()
	if r = invalid then return
	rid = r.route
	if rid = invalid OR rid = "" then rid = "home"
	m.top.activeRouteId = rid
end sub

sub observeRouterRoute()
	r = routerFromScene()
	if r = invalid then return
	r.observeField("route", "onRouterRouteChanged")
end sub

sub onRouterRouteChanged()
	syncActiveRouteFromRouter()
end sub

sub bumpNavVisualRev()
	n = m.top.navVisualRev
	if n = invalid then n = 0
	m.top.navVisualRev = n + 1
end sub

sub observeSceneFocusedChild()
	sc = m.top.getScene()
	if sc = invalid then return
	sc.observeField("focusedChild", "onSceneFocusedChildChanged")
end sub

sub onSceneFocusedChildChanged()
	bumpNavVisualRev()
end sub

sub onNavigationItemSelected()
	list = m.navigationItemsList
	if list = invalid then return
	idx = list.itemSelected
	if idx = invalid OR idx < 0 then return
	root = list.content
	if root = invalid then return
	itemNode = root.getChild(idx)
	if itemNode = invalid then return
	route = itemNode.routeId
	if route = invalid OR route = "" then return
	r = routerFromScene()
	if r = invalid then return
	r.route = route
end sub

function routerFromScene() as Object
	s = m.top.getScene()
	if s = invalid then return invalid
	return s.findNode("router")
end function

function navigationContent() as Object
	items = CreateObject("roArray", 0, true)
	items.push({ routeId: "home", title: "Home" })
	items.push({ routeId: "trending", title: "Trending" })
	items.push({ routeId: "about", title: "About" })
	items.push({ routeId: "settings", title: "Settings" })
	items.push({ routeId: "assetDetails", title: "Asset details" })
	items.push({ routeId: "player", title: "Player" })
	root = CreateObject("roSGNode", "ContentNode")
	for each spec in items
		node = CreateObject("roSGNode", "ContentNode")
		node.addfields({ routeId: "string" })
		node.routeId = spec.routeId
		node.TITLE = spec.title
		root.appendChild(node)
	end for
	return root
end function

sub OnChildFocused()
	if m.top.focusedChild = invalid then return
	list = m.navigationItemsList
	if list = invalid then return
	if focusIsInsideList(list, m.top.focusedChild) then return
	list.setFocus(true)
end sub

function focusIsInsideList(listNode as Object, focused as Object) as Boolean
	if listNode = invalid OR focused = invalid then return false
	targetId = listNode.id
	if targetId = invalid OR targetId = "" then return false
	n = focused
	while n <> invalid
		if n.id <> invalid AND n.id = targetId then return true
		n = n.getParent()
	end while
	return false
end function

function itemNodes()
	out = CreateObject("roArray", 0, true)
	list = m.navigationItemsList
	if list = invalid OR list.content = invalid then return out
	n = list.content.getChildCount()
	for i = 0 to n - 1
		c = list.content.getChild(i)
		if c <> invalid then out.push(c)
	end for
	return out
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press then return false
	print "------------------- navigation onKeyEvent: "; key
	if key = "options"
		return true
	end if
	return false
end function