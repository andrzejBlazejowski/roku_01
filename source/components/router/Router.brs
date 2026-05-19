sub init()
	m.pageHost = m.top.findNode("pageHost")
	mapRoutes()
	if m.top.route = invalid OR m.top.route = "" then m.top.route = "trending"
	m.top.observeField("route", "onRouteChange")
	presentRoute(m.top.route)
end sub

sub mapRoutes()
	m.routesById = {
		home: "HomeScene"
		trending: "TrendingScene"
		about: "AboutScene"
		settings: "SettingsScene"
		assetDetails: "AssetDetailsScene"
		player: "PlayerScene"
	}
end sub

sub onRouteChange()
	presentRoute(m.top.route)
end sub

sub presentRoute(routeId)
	if m.pageHost = invalid then return

	id = routeId
	if id = invalid OR id = "" then id = "home"

	typeName = m.routesById[id]
	if typeName = invalid then
		id = "home"
		typeName = m.routesById[id]
	end if
	if typeName = invalid then return

	if m.loadedRouteId = id AND m.currentPage <> invalid then
		m.currentPage.setFocus(true)
		return
	end if

	if m.currentPage <> invalid then
		m.pageHost.removeChild(m.currentPage)
		m.currentPage = invalid
	end if

	page = CreateObject("roSGNode", typeName)
	if page = invalid then
		return
	end if

	m.pageHost.appendChild(page)
	m.currentPage = page
	m.loadedRouteId = id

	w = m.pageHost.width
	h = m.pageHost.height
	' if w <> invalid AND h <> invalid AND w > 0 AND h > 0 then
	' 	page.width = w
	' 	page.height = h
	' else
	' 	page.width = 1020
	' 	page.height = 720
	' end if

	page.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false ' optional: ignore key-up
    if key = "OK"
        return false ' let focused content handle OK (MarkupList itemSelected, players, etc.)
    else if key = "back"
        print "Back"
        print "router--------------------------------"
        return true
    else if key = "left" or key = "right" or key = "up" or key = "down"
        print "D-pad"
        print "Router--------------------------------"
        return false ' let focused child or built-in navigation handle it
    end if
    return false
end function