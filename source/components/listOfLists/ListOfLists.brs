sub init()
	m.rowsList = m.top.findNode("rowsList")
	m.focusedRowIndex = 0
	m.focusedItemIndex = 0
	onSharedLayoutChanged()
	onContentChanged()
	m.top.observeField("hasFocus", "onHasFocusChanged")
end sub

sub onHasFocusChanged()
	if m.top.hasFocus = true then focusFirstTile()
end sub

sub onContentChanged()
	if m.rowsList = invalid then return
	m.rowsList.content = m.top.content
	if m.top.content <> invalid then focusFirstTile()
end sub

sub onSharedLayoutChanged()
	if m.rowsList = invalid then return
	lw = m.top.listWidth
	if lw = invalid OR lw <= 0 then lw = 1280
	rh = m.top.rowHeight
	if rh = invalid OR rh <= 0 then rh = 166
	vh = m.top.viewportHeight
	if vh = invalid OR vh <= 0 then vh = 688
	rs = m.top.rowSpacing
	if rs = invalid OR rs < 0 then rs = 12
	' m.rowsList.width = lw
	' m.rowsList.height = vh
	m.rowsList.itemSize = [lw, rh]
	m.rowsList.itemSpacing = [0, rs]
end sub

function rowCount() as Integer
	root = m.top.content
	if root = invalid then return 0
	return root.getChildCount()
end function

function focusFirstTile() as Boolean
	m.focusedRowIndex = 0
	m.focusedItemIndex = 0
	m.top.focusedRowIndex = 0
	m.top.focusedItemIndex = 0
	return focusRowTile(0, 0)
end function

function focusRowTile(rowIndex as Integer, colIndex as Integer) as Boolean
	if m.rowsList = invalid then return false
	rc = rowCount()
	if rc <= 0 then return false
	if rowIndex < 0 then rowIndex = 0
	if rowIndex >= rc then rowIndex = rc - 1
	colIndex = clampColForRow(rowIndex, colIndex)
	m.focusedRowIndex = rowIndex
	m.focusedItemIndex = colIndex
	m.top.focusedRowIndex = rowIndex
	m.top.focusedItemIndex = colIndex
	m.rowsList.jumpToItem = rowIndex
	rl = findTileRowForRowIndex(rowIndex)
	if rl = invalid then rl = findTileRowInSubtree(m.rowsList, 12)
	if rl = invalid then return false
	rl.setFocus(true)
	rl.jumpToRowItem = [0, colIndex]
	return true
end function

function clampColForRow(rowIndex as Integer, colIndex as Integer) as Integer
	root = m.top.content
	if root = invalid then return 0
	if rowIndex < 0 OR rowIndex >= root.getChildCount() then return 0
	rowNode = root.getChild(rowIndex)
	if rowNode = invalid then return 0
	cnt = rowNode.getChildCount()
	if cnt <= 0 then return 0
	if colIndex < 0 then return 0
	if colIndex >= cnt then return cnt - 1
	return colIndex
end function

function findTileRowForRowIndex(rowIndex as Integer) as Object
	root = m.top.content
	if root = invalid then return invalid
	if rowIndex < 0 OR rowIndex >= root.getChildCount() then return invalid
	target = root.getChild(rowIndex)
	if target = invalid then return invalid
	return findTileRowForContentNode(m.rowsList, target, 12)
end function

function findTileRowForContentNode(n as Object, target as Object, depth as Integer) as Object
	if n = invalid OR target = invalid OR depth < 0 then return invalid
	if n.subtype() = "ListOfListsRowItem"
		c = n.itemContent
		if c <> invalid AND c = target then
			return n.findNode("tileRow")
		end if
	end if
	for i = 0 to n.getChildCount() - 1
		r = findTileRowForContentNode(n.getChild(i), target, depth - 1)
		if r <> invalid then return r
	end for
	return invalid
end function

function findTileRowInSubtree(n as Object, depth as Integer) as Object
	if n = invalid OR depth < 0 then return invalid
	if n.subtype() = "RowList" AND n.id = "tileRow" then return n
	for i = 0 to n.getChildCount() - 1
		r = findTileRowInSubtree(n.getChild(i), depth - 1)
		if r <> invalid then return r
	end for
	return invalid
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press then return false
	if key <> "up" AND key <> "down" then return false
	rc = rowCount()
	if rc <= 0 then return false
	row = m.focusedRowIndex
	if row = invalid then row = 0
	col = m.focusedItemIndex
	if col = invalid then col = 0
	if key = "up"
		if row <= 0 then return false
		return focusRowTile(row - 1, col)
	else if key = "down"
		if row >= rc - 1 then return false
		return focusRowTile(row + 1, col)
	end if
	return false
end function
