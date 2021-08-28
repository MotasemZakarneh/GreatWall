tool
class_name ArArabic

#const reshaper = preload('res://addons/arabic-text/reshaper/arabic_reshaper.gd')
#const UBA = preload("res://addons/arabic-text/UBA/UBA.gd")
const reshaper = ArabicReShaper
const UBA = ArUBA

static func process_text(text):
	#my change start
	if text == null or text.empty():
		return ""
	#my change end
	if text.empty(): return text
	return UBA.display(reshaper.reshape(text))
