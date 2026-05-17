sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	m.rowList = m.top.findNode("rowList")
	m.titleLabel.width = m.top.listWidth
	m.rowList.observeField("rowItemSelected", "onInnerRowItemSelected")
	m.rowList.observeField("rowItemFocused", "onInnerRowItemFocused")
	applyItemComponentName()
	applyRowListConfig()
	layoutChrome()
	onTitleChanged()
	onContentChanged()
end sub

sub onTitleChanged()
	if m.titleLabel = invalid then return
	t = m.top.title
	if t = invalid then t = ""
	m.titleLabel.text = t
end sub

sub onContentChanged()
	if m.rowList = invalid then return
	c = m.top.content
	if c = invalid then
		m.rowList.content = invalid
		return
	end if
	m.rowList.content = contentForRowList(c)
	m.rowList.jumpToRowItem = [0, 0]
end sub

function contentForRowList(flatOrStructured as Object) as Object
	if flatOrStructured = invalid then return invalid
	if isFlatItemList(flatOrStructured) then return wrapItemsAsSingleRow(flatOrStructured)
	return flatOrStructured
end function

function isFlatItemList(root as Object) as Boolean
	if root = invalid OR root.getChildCount() = 0 then return true
	for i = 0 to root.getChildCount() - 1
		if root.getChild(i).getChildCount() > 0 then return false
	end for
	return true
end function

function wrapItemsAsSingleRow(flatRoot as Object) as Object
	wrapped = createObject("roSGNode", "ContentNode")
	rowNode = wrapped.createChild("ContentNode")
	rowTitle = m.top.title
	if rowTitle <> invalid AND rowTitle <> "" then rowNode.TITLE = rowTitle
	while flatRoot.getChildCount() > 0
		ch = flatRoot.getChild(0)
		rowNode.appendChild(ch)
	end while
	return wrapped
end function

sub onItemComponentNameChanged()
	applyItemComponentName()
end sub

sub applyItemComponentName()
	if m.rowList = invalid then return
	n = m.top.itemComponentName
	if n = invalid OR n = "" then n = "MovieTile"
	m.rowList.itemComponentName = n
end sub

sub onItemGeometryChanged()
	applyItemGeometry()
end sub

sub applyItemGeometry()
	if m.rowList = invalid then return
	iw = m.top.itemWidth
	ih = m.top.itemHeight
	hs = m.top.itemVertSpacing
	if iw = invalid OR iw <= 0 then iw = 216
	if ih = invalid OR ih <= 0 then ih = 360
	if hs = invalid OR hs < 0 then hs = 18
	lw = m.top.listWidth
	if lw = invalid OR lw <= 0 then lw = 1280
	listInnerH = m.rowList.height
	if listInnerH = invalid OR listInnerH <= 0 then listInnerH = ih + 8
	m.rowList.itemSize = [lw, listInnerH]
	m.rowList.rowItemSize = [[iw, ih]]
	m.rowList.rowItemSpacing = [[hs, 0]]
end sub

sub onRowListConfigChanged()
	applyRowListConfig()
end sub

sub applyRowListConfig()
	if m.rowList = invalid then return
	nr = m.top.numRows
	if nr = invalid OR nr < 1 then nr = 1
	m.rowList.numRows = nr
	m.rowList.showRowLabel = [false]
	m.rowList.showRowCounter = [false]
end sub

sub layoutChrome()
	if m.titleLabel = invalid OR m.rowList = invalid then return
	lw = m.top.listWidth
	lh = m.top.listHeight
	if lw = invalid OR lw <= 0 then lw = 1280
	if lh = invalid OR lh <= 0 then lh = 600
	m.titleLabel.width = lw
	m.rowList.translation = [0, 44]
	m.rowList.width = lw
	m.rowList.height = lh - 44
	applyItemGeometry()
end sub
sub onInnerRowItemSelected()
	a = m.rowList.rowItemSelected
	col = rowItemPairSecond(a)
	if col >= 0 then m.top.itemSelected = col
end sub

sub onInnerRowItemFocused()
	a = m.rowList.rowItemFocused
	col = rowItemPairSecond(a)
	if col >= 0 then m.top.itemFocused = col
end sub

function rowItemPairSecond(a as Object) as Integer
	if a = invalid then return -1
	cnt = a.Count()
	if cnt = invalid OR cnt < 2 then return -1
	return a[1]
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if not press then return false ' optional: ignore key-up
	print "tiles row list --------------------------------"
    if key = "OK"
        return false ' let focused content handle OK (MarkupList itemSelected, players, etc.)
    else if key = "back"
        print "Back"
        return true
    end if
    return false
end function