sub init()
	m.stack = m.top.findNode("homeRowStacks")
	buildSampleStackContent()
end sub

sub buildSampleStackContent()
	if m.stack = invalid then return
	art = "pkg:/images/channel-poster_hd.png"
	root = createObject("roSGNode", "ContentNode")
	addRowToRoot(root, art, "Featured", "movie", "")
	addRowToRoot(root, art, "Movies for you", "movie", "")
	addRowToRoot(root, art, "Popular series", "series", "SeriesTile")
	addRowToRoot(root, art, "Continue watching", "movie", "")
	m.stack.content = root
end sub

sub addRowToRoot(root as Object, art as String, rowTitle as String, kind as String, rowItemCmp as String)
	if root = invalid then return
	rowNode = root.createChild("ContentNode")
	rowNode.TITLE = rowTitle
	if rowItemCmp <> invalid AND rowItemCmp <> "" then
		rowNode.addFields({ rowItemComponentName: rowItemCmp })
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

' function onKeyEvent(key as String, press as Boolean) as Boolean
'     if not press then return false ' optional: ignore key-up
'     if key = "OK"
'         return false ' let focused content handle OK (MarkupList itemSelected, players, etc.)
'     else if key = "back"
'         print "Back"
'         print "home screen --------------------------------"
'         return true
'     else if key = "left" or key = "right" or key = "up" or key = "down"
'         print "D-pad"
'         print "home screen --------------------------------"
'         return false ' let focused child or built-in navigation handle it
'     end if
'     return false
' end function