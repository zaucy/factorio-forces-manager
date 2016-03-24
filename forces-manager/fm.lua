require 'defines'

if _G['fm'] == nil then
  _G['fm'] = {}
end

local function ensure_force(force)
  if type(force) == "string" then
    force = game.forces[force]
  end

  return force
end

local function make_unique_force_name(force_name)
  if force_name == "" then
    force_name = "Force 1"
  end

  if game.forces[force_name] then
    local num = string.match(force_name, "%d+")
    if type(num) == "string" then
      local newNum = tostring(tonumber(num)+1)
      force_name = string.sub(force_name, 0, -string.len(num) - 1) .. newNum
    else
      force_name = force_name .. "1"
    end
  end

  if game.forces[force_name] then
    return make_unique_force_name(force_name)
  end

  return force_name
end

fm.join_force = function(player, force)
  force = ensure_force(force)
  player.force = force
end

fm.leave_force = function(player, force)
  force = ensure_force(force)
  player.force = game.forces.player
end

fm.delete_force = function(force)
  force = ensure_force(force)

  force.reset()
  game.merge_forces(force.name, "player")
end

fm.create_force = function(force_name)
  return game.create_force(make_unique_force_name(force_name))
end

fm.player_can_delete_force = function(player)
  return true
end

fm.is_default_force = function(force)
  return force.name == "player" or force.name == "neutral" or force.name == "enemy"
end
