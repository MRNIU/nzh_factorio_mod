-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- styles.lua for MRNIU/nzh_factorio_mod.

local default_gui = data.raw["gui-style"].default

default_gui.nzh_flow_style =
{
	type = "horizontal_flow_style",
	parent = "horizontal_flow",
	top_padding = 5,
	bottom_padding = 5,
	left_padding = 5,
	right_padding = 5,
	horizontal_spacing = 0,
	vertical_spacing = 0,
	max_on_row = 0,
	resize_row_to_width = true,
	graphical_set = { type = "none" },
}

default_gui.nzh_button_style =
{
	type = "button_style",
	parent = "button",
	font = "default",
	align = "center",
	top_padding = 1,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	height = 36,
	minimal_width = 36,
	scalable = false,
	left_click_sound =
	{
		{
			filename = "__core__/sound/gui-click.ogg",
			volume = 1
		}
	},
}
