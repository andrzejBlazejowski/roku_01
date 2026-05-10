sub init()
	buildSampleTrendingGrid()
	m.top.setFocus(true)
end sub

sub buildSampleTrendingGrid()
	grid = m.top.findNode("trendingGrid")
	if grid = invalid then return
	art = "pkg:/images/channel-poster_hd.png"
	root = createObject("roSGNode", "ContentNode")
	for i = 1 to 12
		n = root.createChild("ContentNode")
		n.TITLE = "Trending " + StrI(i)
		n.HDPOSTERURL = art
		n.SHORTDESCRIPTIONLINE1 = sampleLine1(i)
		n.SHORTDESCRIPTIONLINE2 = sampleLine2(i)
	end for
	grid.content = root
end sub

function sampleLine1(i as Integer) as String
	return "202" + StrI(i mod 5) + " · Popular pick"
end function

function sampleLine2(i as Integer) as String
	return "Hot this week #" + StrI(i)
end function
