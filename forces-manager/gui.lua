require 'defines'

if _G['fm'] == nil then
  _G['fm'] = {}
end

fm.gui = {}
fm.gui.width = 600

local function fm_create_force_player_gui(force, player, frame, width)
  frame.add{type='label', name='player_name', caption=player.name}
  frame.player_name.style.maximal_width = width
  frame.player_name.style.minimal_width = width
end

local function fm_create_force_gui(force, frame, width)
  local owner = game.players[frame.player_index]

  frame.add{type='flow', name='header', direction='horizontal'}
  frame.header.style.maximal_width = width
  frame.header.style.minimal_width = width

  -- Force Title
  frame.header.add{type='label', name='title', caption=force.name}
  frame.header.title.style.minimal_width = width * 0.6
  frame.header.title.style.maximal_width = width * 0.6

  -- Force Join, leave, delete
  frame.header.add{type='flow', name='controls', direction='horizontal'}
  frame.header.controls.style.maximal_width = width * 0.4
  frame.header.controls.style.minimal_width = width * 0.4
  if owner.force == force then
    frame.header.controls.add{type='button', name='fm_leave_force', caption='LEAVE', style='fm_force_action_button_style'}
  else
    frame.header.controls.add{type='button', name='fm_join_force', caption='JOIN', style='fm_force_action_button_style'}
  end
  if fm.player_can_delete_force(owner) then
    if fm.is_default_force(force) then
      frame.header.controls.add{type='button', name='fm_delete_force_disabled', caption='DELETE', style='fm_force_action_disabled_button_style'}
    else
      frame.header.controls.add{type='button', name='fm_delete_force', caption='DELETE', style='fm_force_action_button_style'}
    end
  end

  -- Force player list
  local player_frame_width = width
  frame.add{type='flow', name='players_list', direction='vertical'}
  for k, force_player in pairs(force.players) do
    frame.players_list.add{type='flow', name=force_player.name, direction='horizontal'}
    local player_frame = frame.players_list[force_player.name]
    player_frame.style.maximal_width = player_frame_width
    player_frame.style.minimal_width = player_frame_width
    fm_create_force_player_gui(force, force_player, player_frame, player_frame_width)
  end
end

fm.gui.show = function(player)
  if player == nil then
    player = game.player
  end

  player.gui.center.add{type='frame', name='forces_manager', direction='vertical'}
  local fm_gui = player.gui.center.forces_manager
  fm_gui.style.maximal_width = fm.gui.width
  fm_gui.style.minimal_width = fm.gui.width

  -- Forces Manager Title
  fm_gui.add{type='flow', name='title_flow', direction='horizontal'}
  fm_gui.title_flow.style.minimal_width = fm.gui.width
  fm_gui.title_flow.style.maximal_width = fm.gui.width
  fm_gui.title_flow.add{type='label', name='title', caption='Forces Manager', style='fm_title_label_style'}
  fm_gui.title_flow.add{type='label', name='version', caption='(v0.0.1)', style='fm_version_label_style'}

  -- Forces Manager Settings
  fm_gui.add{type='flow', name='settings_flow', direction='vertical'}
  fm_gui.settings_flow.style.maximal_width = fm.gui.width
  fm_gui.settings_flow.style.minimal_width = fm.gui.width

  fm_gui.settings_flow.add{type='flow', name='hide_default_forces_flow', direction='horizontal'}
  fm_gui.settings_flow.hide_default_forces_flow.style.maximal_width = fm.gui.width * 0.5
  fm_gui.settings_flow.hide_default_forces_flow.style.minimal_width = fm.gui.width * 0.5
  fm_gui.settings_flow.hide_default_forces_flow.add{type='label', name='label', caption='Hide Default Forces'}
  fm_gui.settings_flow.hide_default_forces_flow.style.maximal_width = fm.gui.width * 0.25
  fm_gui.settings_flow.hide_default_forces_flow.style.minimal_width = fm.gui.width * 0.25
  fm_gui.settings_flow.hide_default_forces_flow.add{type='checkbox', name='fm_hide_default_forces_checkbox', state=fm.settings.hide_default_forces}

  -- Create new Force
  fm_gui.add{type='flow', name='create_new_force_flow', direction='horizontal'}
  fm_gui.create_new_force_flow.style.maximal_width = fm.gui.width
  fm_gui.create_new_force_flow.style.minimal_width = fm.gui.width
  fm_gui.create_new_force_flow.add{type='textfield', name='fm_new_force_input'}
  fm_gui.create_new_force_flow.fm_new_force_input.text = "<FORCE NAME>"
  fm_gui.create_new_force_flow.add{type='button', name='fm_new_force_submit', caption='Create New Force', style='fm_force_action_button_style'}

  -- Forces List
  local force_frame_width = fm.gui.width * 0.7
  fm_gui.add{type='flow', name='forces', direction='vertical'}
  fm_gui.forces.style.maximal_width = force_frame_width
  fm_gui.forces.style.minimal_width = force_frame_width
  for key, force in pairs(game.forces) do
    if fm.settings.hide_default_forces and fm.is_default_force(force) then
      goto continue
    end
    fm_gui.forces.add{type='frame', name=force.name, direction='vertical', style='technology_preview_frame_style'}
    local force_frame = fm_gui.forces[force.name]
    force_frame.style.maximal_width = force_frame_width
    force_frame.style.minimal_width = force_frame_width
    fm_create_force_gui(force, force_frame, force_frame_width)
    ::continue::
  end

  -- Player list not in a force.


end

fm.gui.hide = function(player)
  if player == nil then
    player = game.player
  end

  player.gui.center.forces_manager.destroy()
end

fm.gui.update = function(player)
  if fm.gui.is_showing() then
    fm.gui.hide(player)
    fm.gui.show(player)
  end
end

fm.gui.is_hidden = function(player)
  if player == nil then
    player = game.player
  end

  return player.gui.center.forces_manager == nil
end

fm.gui.is_showing = function(player)
  return not fm.gui.is_hidden(player)
end
