sub init()
	items = itemNodes()
	if items.count() > 0 then items[0].setFocus(true)
end sub

function itemNodes()
	out = CreateObject("roArray", 0, true)
	list = m.top.findNode("itemList")
	if list = invalid then return out
	n = list.getChildCount()
	for i = 0 to n - 1
		c = list.getChild(i)
		if c <> invalid then out.push(c)
	end for
	return out
end function
