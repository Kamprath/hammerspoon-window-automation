WebView = {
	create = function(x, y, width, height)
		local rect = hs.geometry.rect(x, y, width, height)

		return hs.webview.new(rect)
	end
}