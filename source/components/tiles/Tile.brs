sub init()
	m.layout = m.top.findNode("layout")
	m.poster = m.top.findNode("poster")
	m.titleLabel = m.top.findNode("titleLabel")
	m.metaLabel = m.top.findNode("metaLabel")
	m.titleFocusColor = "0xFFFFFFFF"
	m.titleIdleColor = "0xEEFFFFFF"
	m.metaFocusColor = "0xDDFFFFFF"
	m.metaIdleColor = "0xAAFFFFFF"
	onLayoutChanged()
	onItemContentChanged()
	onFocusVisualChanged()
end sub

sub onItemContentChanged()
	c = m.top.itemContent
	if m.poster = invalid OR m.titleLabel = invalid OR m.metaLabel = invalid then return
	if c = invalid then
		m.poster.uri = ""
		m.titleLabel.text = ""
		m.metaLabel.text = ""
		return
	end if
	u = posterUriFromContent(c)
	if u <> invalid then m.poster.uri = u
	t = c.TITLE
	if t = invalid then t = ""
	m.titleLabel.text = t
	applyMetaLine(c)
	onLayoutChanged()
end sub

function posterUriFromContent(c) as String
	if c = invalid then return ""
	u = c.HDGRIDPOSTERURL
	if u <> invalid AND u <> "" then return u
	u = c.HDPOSTERURL
	if u <> invalid AND u <> "" then return u
	u = c.SDGRIDPOSTERURL
	if u <> invalid AND u <> "" then return u
	u = c.SDPOSTERURL
	if u <> invalid AND u <> "" then return u
	return ""
end function

sub applyMetaLine(c as Object)
	line1 = c.SHORTDESCRIPTIONLINE1
	if line1 = invalid then line1 = ""
	line2 = c.SHORTDESCRIPTIONLINE2
	if line2 = invalid then line2 = ""
	st = m.top.subtype()
	text = ""
	if st = "SeriesTile" then
		text = line1
		if line2 <> "" then
			if text <> "" then
				text = text + " · " + line2
			else
				text = line2
			end if
		end if
	else
		text = line1
		if text = "" then text = line2
	end if
	m.metaLabel.text = text
end sub

sub onLayoutChanged()
	if m.layout = invalid OR m.poster = invalid OR m.titleLabel = invalid OR m.metaLabel = invalid then return
	pad = 16.0
	w = m.top.width - pad
	h = m.top.height - pad
	if w <= 0 OR h <= 0 then return
	m.layout.translation = [pad / 2, pad / 2]
	labelReserve = 56.0
	posterH = h - labelReserve
	if posterH < 80 then posterH = h * 0.55
	posterW = posterH * 2 / 3
	if posterW > w then
		posterW = w
		posterH = posterW * 3 / 2
		if posterH + labelReserve > h then posterH = h - labelReserve
	end if
	m.poster.width = posterW
	m.poster.height = posterH
	m.titleLabel.width = w
	m.metaLabel.width = w
end sub

sub onFocusVisualChanged()
	if m.poster = invalid OR m.titleLabel = invalid OR m.metaLabel = invalid then return
	listOn = m.top.listHasFocus OR m.top.gridHasFocus OR m.top.rowListHasFocus
	rowActive = true
	if m.top.rowHasFocus <> invalid then rowActive = m.top.rowHasFocus
	fp = m.top.focusPercent
	if fp = invalid then fp = 0.0
	s = 1.0
	if listOn AND rowActive then s = 1.0 + 0.06 * fp
	m.poster.scale = [s, s]
	focused = listOn AND rowActive AND (m.top.itemHasFocus OR fp > 0.5)
	if focused then
		m.titleLabel.color = m.titleFocusColor
		m.metaLabel.color = m.metaFocusColor
	else
		m.titleLabel.color = m.titleIdleColor
		m.metaLabel.color = m.metaIdleColor
	end if
end sub
