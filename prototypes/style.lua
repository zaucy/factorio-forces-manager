-- Factorio will throw if this is not checked.
if _G['data'] then
  local styles = data.raw["gui-style"].default

  -- Forces Manager menu title
  styles.fm_title_label_style = {
    type = "label_style",
    parent = "label_style",
    font = "default-bold"
  }

  -- Version text on right side of Forces Manager menu title
  styles.fm_version_label_style = {
    type = "label_style",
    parent = "label_style",
    default_font_color = {r=0.5, g=0.5, b=0.5},
  }

  styles.fm_force_action_button_style = {
    type = "button_style",
    parent = "button_style",
    maximal_height = 24,
    minimal_height = 24,
    font = "default",
    top_padding = 0,
    left_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
  }

  local disabled_fcolor = {r=0.5, g=0.5, b=0.5}
  local disabled_gset = {
    type = "composition",
    filename = "__core__/graphics/gui.png",
    priority = "extra-high-no-scale",
    corner_size = {3, 3},
    position = {0, 0}
  }

  styles.fm_force_action_disabled_button_style = {
    type = "button_style",
    parent = "fm_force_action_button_style",
    default_font_color = disabled_fcolor,
    default_graphical_set = disabled_gset,
    hovered_font_color = disabled_fcolor,
    hovered_graphical_set = disabled_gset,
    clicked_font_color = disabled_fcolor,
    clicked_graphical_set = disabled_gset,
  }
end
