sub init()
	m.titleLabel = m.top.findNode("titleLabel")
	m.tileGrid = m.top.findNode("tileGrid")
	m.titleLabel.width = m.top.gridWidth
	m.tileGrid.observeField("itemSelected", "onInnerItemSelected")
	m.tileGrid.observeField("itemFocused", "onInnerItemFocused")
	applyItemComponentName()
	applyItemGeometry()
	applyGridConfig()
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
	if m.tileGrid = invalid then return
	m.tileGrid.content = m.top.content
end sub

sub onItemComponentNameChanged()
	applyItemComponentName()
end sub

sub applyItemComponentName()
	if m.tileGrid = invalid then return
	n = m.top.itemComponentName
	if n = invalid OR n = "" then n = "MovieTile"
	m.tileGrid.itemComponentName = n
end sub

sub onItemGeometryChanged()
	applyItemGeometry()
end sub

sub applyItemGeometry()
	if m.tileGrid = invalid then return
	iw = m.top.itemWidth
	ih = m.top.itemHeight
	hs = m.top.itemHorizSpacing
	vs = m.top.itemVertSpacing
	if iw = invalid OR iw <= 0 then iw = 216
	if ih = invalid OR ih <= 0 then ih = 360
	if hs = invalid OR hs < 0 then hs = 16
	if vs = invalid OR vs < 0 then vs = 20
	m.tileGrid.itemSize = [iw, ih]
	m.tileGrid.itemSpacing = [hs, vs]
end sub

sub onGridConfigChanged()
	applyGridConfig()
end sub

sub applyGridConfig()
	if m.tileGrid = invalid then return
	nc = m.top.numColumns
	nr = m.top.numRows
	if nc = invalid OR nc < 1 then nc = 4
	if nr = invalid OR nr < 1 then nr = 3
	m.tileGrid.numColumns = nc
	m.tileGrid.numRows = nr
end sub

sub layoutChrome()
	if m.titleLabel = invalid OR m.tileGrid = invalid then return
	gw = m.top.gridWidth
	gh = m.top.gridHeight
	if gw = invalid OR gw <= 0 then gw = 1280
	if gh = invalid OR gh <= 0 then gh = 720
	m.titleLabel.width = gw
	m.tileGrid.translation = [0, 44]
	m.tileGrid.width = gw
	m.tileGrid.height = gh - 44
end sub

sub onInnerItemSelected()
	m.top.itemSelected = m.tileGrid.itemSelected
end sub

sub onInnerItemFocused()
	m.top.itemFocused = m.tileGrid.itemFocused
end sub
