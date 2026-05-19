sub init()
	m.rowLabel = m.top.findNode("rowLabel")
	m.tileRow = m.top.findNode("tileRow")
	if m.tileRow <> invalid then
		m.tileRow.observeField("rowItemFocused", "onInnerRowItemFocused")
		m.tileRow.observeField("rowItemSelected", "onInnerRowItemSelected")
	end if
end sub

sub onItemContentChanged()
	applyFromItemContent()
	onLayoutChanged()
	applySharedFieldsFromParent()
end sub

sub onLayoutChanged()
	if m.tileRow = invalid then return
	w = m.top.width
	h = m.top.height
	if w <> invalid AND w > 0 then
		' if m.rowLabel <> invalid then m.rowLabel.width = w
		' m.tileRow.width = w
	end if
	if h <> invalid AND h > 0 then
		listInnerH = h - 44
		' if listInnerH < 80 then listInnerH = h * 0.75
		' m.tileRow.height = listInnerH
	end if
	applyRowListGeometry()
end sub

sub applyFromItemContent()
	if m.tileRow = invalid then return
	c = m.top.itemContent
	if c = invalid then
		m.tileRow.content = invalid
		if m.rowLabel <> invalid then m.rowLabel.text = ""
		return
	end if
	if m.rowLabel <> invalid then m.rowLabel.text = rowTitleForContentNode(c)
	m.tileRow.content = contentForRowList(c)
	m.tileRow.jumpToRowItem = [0, 0]
end sub

function rowTitleForContentNode(c as Object) as String
	if c = invalid then return ""
	t = c.TITLE
	if t = invalid then return ""
	return t
end function

function contentForRowList(rowNode as Object) as Object
	if rowNode = invalid then return invalid
	wrapped = createObject("roSGNode", "ContentNode")
	listRow = wrapped.createChild("ContentNode")
	t = rowNode.TITLE
	if t <> invalid AND t <> "" then listRow.TITLE = t
	for i = 0 to rowNode.getChildCount() - 1
		ch = rowNode.getChild(i)
		if ch <> invalid then listRow.appendChild(ch)
	end for
	return wrapped
end function

sub applySharedFieldsFromParent()
	parentList = listOfListsAncestor()
	if parentList = invalid OR m.tileRow = invalid then return
	n = parentList.itemComponentName
	if n = invalid OR n = "" then n = "MovieTile"
	c = m.top.itemContent
	if c <> invalid
		alt = c.rowItemComponentName
		if alt <> invalid AND alt <> "" then n = alt
	end if
	' print "applySharedFieldsFromParent: "; n
	' STOP
	' if m.tileRow <> invalid 
	' 	test = m.top.findNode("tileRow")
	' 	STOP
	' 	test.itemComponentName = n
	' else 
	' 	STOP
	' 	m.tileRow = m.top.findNode("tileRow")
	' 	if m.tileRow <> invalid then m.tileRow.itemComponentName = n
	' end if
	' STOP
	applyRowListGeometry()
end sub

sub applyRowListGeometry()
	if m.tileRow = invalid then return
	parentList = listOfListsAncestor()
	if parentList = invalid then return
	iw = parentList.itemWidth
	ih = parentList.itemHeight
	hs = parentList.itemHorizSpacing
	if iw = invalid OR iw <= 0 then iw = 216
	if ih = invalid OR ih <= 0 then ih = 360
	if hs = invalid OR hs < 0 then hs = 16
	lw = m.top.width
	if lw = invalid OR lw <= 0 then lw = parentList.listWidth
	if lw = invalid OR lw <= 0 then lw = 1280
	listInnerH = m.tileRow.height
	if listInnerH = invalid OR listInnerH <= 0 then listInnerH = ih + 8
	m.tileRow.itemSize = [lw, listInnerH]
	m.tileRow.rowItemSize = [[iw, ih]]
	m.tileRow.rowItemSpacing = [[hs, 0]]
	m.tileRow.numRows = 1
	m.tileRow.showRowLabel = [false]
	m.tileRow.showRowCounter = [false]
end sub

function listOfListsAncestor() as Object
	n = m.top.getParent()
	while n <> invalid
		if n.subtype() = "ListOfLists" then return n
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
	parentList = listOfListsAncestor()
	if parentList = invalid OR m.tileRow = invalid then return
	idx = rowIndexForItem()
	if idx < 0 then return
	col = rowItemPairSecond(m.tileRow.rowItemFocused)
	if col < 0 then col = 0
	parentList.focusedRowIndex = idx
	parentList.focusedItemIndex = col
end sub

sub onInnerRowItemSelected()
	parentList = listOfListsAncestor()
	if parentList = invalid OR m.tileRow = invalid then return
	idx = rowIndexForItem()
	if idx < 0 then return
	col = rowItemPairSecond(m.tileRow.rowItemSelected)
	if col < 0 then return
	parentList.itemSelectedRow = idx
	parentList.itemSelectedCol = col
end sub

function rowItemPairSecond(a as Object) as Integer
	if a = invalid then return -1
	cnt = a.Count()
	if cnt = invalid OR cnt < 2 then return -1
	return a[1]
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press then return false
	if key <> "up" AND key <> "down" then return false
	parentList = listOfListsAncestor()
	if parentList = invalid OR m.tileRow = invalid then return false
	row = rowIndexForItem()
	if row < 0 then return false
	col = rowItemPairSecond(m.tileRow.rowItemFocused)
	if col < 0
		col = parentList.focusedItemIndex
		if col = invalid then col = 0
	end if
	if key = "up"
		if row <= 0 then return false
		return parentList.callFunc("focusRowTile", { rowIndex: row - 1, colIndex: col })
	else if key = "down"
		rc = parentList.content
		if rc = invalid then return false
		if row >= rc.getChildCount() - 1 then return false
		return parentList.callFunc("focusRowTile", { rowIndex: row + 1, colIndex: col })
	end if
	return false
end function
