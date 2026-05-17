sub init()
	m.rowMarkupList = m.top.findNode("rowMarkupList")
	onSharedLayoutChanged()
	onContentChanged()
	focusFirstRowTile()
	m.rowMarkupList.observeField("itemSelected", "onItemSelected")
	m.rowMarkupList.observeField("itemFocused", "onItemFocused")
	' m.rowMarkupList.isInFocusChain = true
end sub

sub onItemSelected()
	print "tiles row stack onItemSelected: "; m.rowMarkupList.itemSelected
end sub

sub onItemFocused()
	print "tiles row stack onItemFocused: "; m.rowMarkupList.itemFocused
end sub

sub onSharedLayoutChanged()
	if m.rowMarkupList = invalid then return
	lw = m.top.listWidth
	if lw = invalid OR lw <= 0 then lw = 1280
	rh = m.top.rowListHeight
	if rh = invalid OR rh <= 0 then rh = 600
	m.rowMarkupList.width = lw
	vh = m.top.viewportHeight
	if vh = invalid OR vh <= 0 then vh = 688
	m.rowMarkupList.height = vh
	m.rowMarkupList.itemSize = [lw, rh]
	rs = m.top.rowSpacing
	if rs = invalid OR rs < 0 then rs = 12
	m.rowMarkupList.itemSpacing = [0, rs]
end sub

sub onContentChanged()
	if m.rowMarkupList = invalid then return
	m.rowMarkupList.content = m.top.content
end sub

function findFirstRowListInSubtree(n as Object, depth as Integer) as Object
	if n = invalid OR depth < 0 then return invalid
	if n.subtype() = "RowList" AND n.id = "rowList" then return n
	for i = 0 to n.getChildCount() - 1
		r = findFirstRowListInSubtree(n.getChild(i), depth - 1)
		if r <> invalid then return r
	end for
	return n
end function

function getFirstRowList() as Object
	if m.rowMarkupList = invalid then return invalid
	return findFirstRowListInSubtree(m.rowMarkupList, 8)
end function

function focusFirstRowTile() as Boolean
	if m.rowMarkupList = invalid then return false
	m.rowMarkupList.jumpToItem = 0
	rl = getFirstRowList()
	if rl = invalid then return false
	m.firstRowList = rl
	' rl.jumpToRowItem = [1, 1]
	' print "=============================s==================="
	' print "focusFirstRowTile: rl.jumpToRowItem = ", rl
	' print rl
	' STOP
	' rl.getChild(0).setFocus(true)
	m.firstRowList.setFocus(true)
	m.firstRowList.observeField("content", "onFirstRowListContentChanged")
	return true

end function

function onFirstRowListContentChanged() as Void
	print "tiles row stack onFirstRowListContentChanged: "; m.firstRowList.content
	STOP
end function


function onKeyEvent(key as String, press as Boolean) as Boolean
	print "tiles row stack onKeyEvent: "; key
	return false 
    ' if not press then return false ' optional: ignore key-up
    ' if key = "OK"
    '     return false ' let focused content handle OK (MarkupList itemSelected, players, etc.)
    ' else if key = "back"
    '     print "Back"
    '     print "tiles row stack--------------------------------"
    '     return true
    ' else if key = "left" or key = "right" or key = "up" or key = "down"
    '     print "D-pad"
    '     print "tiles row stack--------------------------------"
    '     return false ' let focused child or built-in navigation handle it
    ' end if
    ' return false
end function