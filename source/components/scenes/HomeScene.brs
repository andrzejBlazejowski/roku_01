sub init()
	buildSampleRows()
	wireRowListFocusChain()
	m.top.setFocus(true)
end sub

sub buildSampleRows()
	art = "pkg:/images/channel-poster_hd.png"
	addRowItems(m.top.findNode("rowFeatured"), art, "Featured", "movie")
	addRowItems(m.top.findNode("rowMovies"), art, "Pick", "movie")
	addRowItems(m.top.findNode("rowSeries"), art, "Show", "series")
	addRowItems(m.top.findNode("rowContinue"), art, "Resume", "movie")
end sub

sub addRowItems(rowGroup as Object, art as String, namePrefix as String, kind as String)
	if rowGroup = invalid then return
	root = createObject("roSGNode", "ContentNode")
	for i = 1 to 6
		n = root.createChild("ContentNode")
		n.TITLE = namePrefix + " " + StrI(i)
		n.HDPOSTERURL = art
		n.SHORTDESCRIPTIONLINE1 = sampleLine1(kind, i)
		n.SHORTDESCRIPTIONLINE2 = sampleLine2(kind, i)
	end for
	rowGroup.content = root
end sub

function sampleLine1(kind as String, i as Integer) as String
	if kind = "series" then return "Season " + StrI(i) + " · Now streaming"
	return "202" + StrI(i mod 5) + " · " + StrI(90 + i) + " min"
end function

function sampleLine2(kind as String, i as Integer) as String
	if kind = "series" then return StrI(6 + i) + " episodes left"
	return "Director Pick #" + StrI(i)
end function

sub wireRowListFocusChain()
	r1 = m.top.findNode("rowFeatured")
	r2 = m.top.findNode("rowMovies")
	r3 = m.top.findNode("rowSeries")
	r4 = m.top.findNode("rowContinue")
	l1 = listOfRow(r1)
	l2 = listOfRow(r2)
	l3 = listOfRow(r3)
	l4 = listOfRow(r4)
	if l1 = invalid OR l2 = invalid OR l3 = invalid OR l4 = invalid then return
	l1.nextFocusDown = l2
	l2.nextFocusUp = l1
	l2.nextFocusDown = l3
	l3.nextFocusUp = l2
	l3.nextFocusDown = l4
	l4.nextFocusUp = l3
end sub

function listOfRow(row as Object) as Object
	if row = invalid then return invalid
	return row.findNode("rowList")
end function
