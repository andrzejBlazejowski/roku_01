sub init()
	m.row = m.top.findNode("row")
	print "tiles row list stack item init: "; m.row
	if m.row <> invalid then
		print "++++++++++ tiles row list stack item init: "; m.row
		m.row.observeField("itemFocused", "onInnerRowItemFocused")
		m.row.observeField("itemSelected", "onInnerRowItemSelected")
	end if
end sub

sub onItemContentChanged()
	applyFromItemContent()
	onLayoutChanged()
	applySharedFieldsFromStack()
end sub

sub onLayoutChanged()
	if m.row = invalid then return
	w = m.top.width
	h = m.top.height
	if w <> invalid AND w > 0 then m.row.listWidth = w
	if h <> invalid AND h > 0 then m.row.listHeight = h
end sub

sub applyFromItemContent()
	if m.row = invalid then return
	c = m.top.itemContent
	if c = invalid then
		m.row.content = invalid
		m.row.title = ""
		return
	end if
	m.row.title = rowTitleForContentNode(c)
	m.row.content = c
end sub

function rowTitleForContentNode(c as Object) as String
	if c = invalid then return ""
	t = c.TITLE
	if t = invalid then return ""
	return t
end function

sub applySharedFieldsFromStack()
	if m.row = invalid then return
	stk = tilesRowListStackAncestor()
	if stk = invalid then return
	n = stk.itemComponentName
	if n = invalid OR n = "" then n = "MovieTile"
	c = m.top.itemContent
	if c <> invalid
		alt = c.rowItemComponentName
		if alt <> invalid AND alt <> "" then n = alt
	end if
	m.row.itemComponentName = n
	m.row.itemWidth = stk.itemWidth
	m.row.itemHeight = stk.itemHeight
	m.row.itemVertSpacing = stk.itemVertSpacing
	m.row.numRows = stk.numRows
end sub

function tilesRowListStackAncestor() as Object
	n = m.top.getParent()
	while n <> invalid
		if n.subtype() = "TilesRowListStack" then return n
		n = n.getParent()
	end while
	return invalid
end function

function rowIndexForItem() as Integer
	c = m.top.itemContent
	if c = invalid then return -1
	p = c.getParent()
	if p = invalid then return -1
	for i = 0 to p.getChildCount() - 1
		if p.getChild(i) = c then return i
	end for
	return -1
end function

sub onInnerRowItemFocused()
	print "tiles row list stack item onInnerRowItemFocused: "; m.row.itemFocused
	stk = tilesRowListStackAncestor()
	if stk = invalid OR m.row = invalid then return
	idx = rowIndexForItem()
	if idx < 0 then return
	stk.focusedRowIndex = idx
	stk.focusedItemIndex = m.row.itemFocused
end sub

sub onInnerRowItemSelected()
	print "tiles row list stack item onInnerRowItemSelected: "; m.row.itemSelected
	stk = tilesRowListStackAncestor()
	if stk = invalid OR m.row = invalid then return
	idx = rowIndexForItem()
	if idx < 0 then return
	stk.itemSelectedRow = idx
	stk.itemSelectedCol = m.row.itemSelected
end sub



function onKeyEvent(key as String, press as Boolean) as Boolean

	print "tiles row list stack item --------------------------------"
	return false
    ' if not press then return false ' optional: ignore key-up
    ' if key = "OK"
    '     return false ' let focused content handle OK (MarkupList itemSelected, players, etc.)
    ' else if key = "back"
    '     print "Back"
    '     print "tiles row list stack item --------------------------------"
    '     return true
    ' else if key = "left" or key = "right" or key = "up" or key = "down"
    '     print "D-pad"
    '     print "tiles row list stack item --------------------------------"
    '     return false ' let focused child or built-in navigation handle it
    ' end if
    ' return false
end function