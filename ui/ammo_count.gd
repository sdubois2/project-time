extends CanvasLayer

func update_text(string : String) :
	$TotalAmmo.text = string
	$MaxAmmo.text = "12"

func reload_animation() :
	$TotalAmmo.text = "-"
	$MaxAmmo.text = "-"
