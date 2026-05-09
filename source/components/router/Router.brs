sub init()
	m.pageHost = m.top.findNode("pageHost")
	mapRoutes()
	if m.top.route = invalid OR m.top.route = "" then m.top.route = "home"
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
		print "Router: unknown route "; id; " — using home"
		id = "home"
		typeName = m.routesById[id]
	end if
	if typeName = invalid then return

	if m.loadedRouteId = id AND m.currentPage <> invalid then return

	if m.currentPage <> invalid then
		m.pageHost.removeChild(m.currentPage)
		m.currentPage = invalid
	end if

	page = CreateObject("roSGNode", typeName)
	if page = invalid then
		print "Router: failed to create "; typeName
		return
	end if

	m.pageHost.appendChild(page)
	m.currentPage = page
	m.loadedRouteId = id

	w = m.pageHost.width
	h = m.pageHost.height
	if w <> invalid AND h <> invalid AND w > 0 AND h > 0 then
		page.width = w
		page.height = h
	else
		page.width = 1020
		page.height = 720
	end if
end sub
