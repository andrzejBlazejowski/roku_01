sub init()
	m.homeList = m.top.findNode("homeList")
	buildSampleListContent()
	if m.homeList <> invalid then m.homeList.callFunc("focusFirstTile")
	m.top.observeField("hasFocus", "onHasFocusChanged")
end sub

sub onHasFocusChanged()
	if m.top.hasFocus <> true then return
	if m.homeList <> invalid then m.homeList.callFunc("focusFirstTile")
end sub

sub buildSampleListContent()
	if m.homeList = invalid then return
	art = "pkg:/images/channel-poster_hd.png"
	root = createObject("roSGNode", "ContentNode")
	addRowToRoot(root, art, "Featured", "movie", "")
	addRowToRoot(root, art, "Movies for you", "movie", "")
	addRowToRoot(root, art, "Popular series", "series", "SeriesTile")
	addRowToRoot(root, art, "Continue watching", "movie", "")
	m.homeList.content = root
end sub

sub addRowToRoot(root as Object, art as String, rowTitle as String, kind as String, rowItemCmp as String)
	if root = invalid then return
	rowNode = root.createChild("ContentNode")
	rowNode.TITLE = rowTitle
	if rowItemCmp <> invalid AND rowItemCmp <> "" then
		rowNode.addFields({ rowItemComponentName: "string" })
		rowNode.rowItemComponentName = rowItemCmp
	end if
	for i = 1 to 6
		n = rowNode.createChild("ContentNode")
		n.TITLE = rowTitle + " " + StrI(i)
		n.HDPOSTERURL = art
		n.SHORTDESCRIPTIONLINE1 = sampleLine1(kind, i)
		n.SHORTDESCRIPTIONLINE2 = sampleLine2(kind, i)
	end for
end sub

function sampleLine1(kind as String, i as Integer) as String
	if kind = "series" then return "Season " + StrI(i) + " · Now streaming"
	return "202" + StrI(i mod 5) + " · " + StrI(90 + i) + " min"
end function

function sampleLine2(kind as String, i as Integer) as String
	if kind = "series" then return StrI(6 + i) + " episodes left"
	return "Director Pick #" + StrI(i)
end function
