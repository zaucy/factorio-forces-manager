require 'defines'

require 'forces-manager/fm'
require 'forces-manager/settings'
require 'forces-manager/gui'

script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player.gui.top.add{type="button", name="fm_toggle", caption="Show Forces Manager"}

  fm.gui.update_all()
end)

script.on_event(defines.events.on_gui_click, function(event)
  local owner = game.players[event.element.player_index]

  if event.element.name == "fm_toggle" then
    if fm.gui.is_hidden(owner) then
      owner.gui.top.fm_toggle.caption = "Hide Forces Manager"
      fm.gui.show(owner)
    else
      owner.gui.top.fm_toggle.caption = "Show Forces Manager"
      fm.gui.hide(owner)
    end
  elseif event.element.name == "fm_join_force" then
    fm.join_force(owner, event.element.parent.parent.parent.name)
  elseif event.element.name == "fm_leave_force" then
    fm.leave_force(owner, event.element.parent.parent.parent.name)
  elseif event.element.name == "fm_delete_force" then
    fm.delete_force(event.element.parent.parent.parent.name)
  elseif event.element.name == "fm_new_force_input" then
    if event.element.text == "<FORCE NAME>" then
      event.element.text = ""
    end
  elseif event.element.name == "fm_new_force_submit" then
    local new_force_name = event.element.parent.fm_new_force_input.text
    event.element.parent.fm_new_force_input.text = ""
    fm.create_force(new_force_name)
  elseif event.element.name == "fm_hide_default_forces_checkbox" then
    fm.settings.hide_default_forces = event.element.state
    fm.gui.update(owner)
  end

end)
