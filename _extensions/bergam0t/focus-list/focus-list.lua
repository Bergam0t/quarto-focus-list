-- Likely inspired by the conversation here: https://github.com/orgs/quarto-dev/discussions/4626

local dim_parents = false

-- A nested list has to sit outside its parent's fragment div, otherwise the
-- dimming inherits down the levels and compounds on every step
local function is_list(block)
  return block.t == "BulletList" or block.t == "OrderedList"
end

-- Wrap only the item's own content in the fragment, leaving any nested list as
-- a sibling of that div inside the <li>
local function focus_item(item)
  local own = {}
  local rest = {}
  local seen_list = false

  for _, block in ipairs(item) do
    if is_list(block) then
      seen_list = true
    end

    if seen_list then
      table.insert(rest, block)
    else
      table.insert(own, block)
    end
  end

  local blocks = {}

  if #own > 0 then
    table.insert(blocks, pandoc.Div(own, { class = "fragment" }))
  end

  for _, block in ipairs(rest) do
    table.insert(blocks, block)
  end

  return blocks
end

local function is_true(value)
  if value == nil then
    return false
  end

  if type(value) == "boolean" then
    return value
  end

  return pandoc.utils.stringify(value) == "true"
end

local function read_options(meta)
  local options = meta["focus-list"]

  if type(options) == "table" then
    dim_parents = is_true(options["dim-parents"])
  end
end

local function focus_list(el)
  if not el.classes:includes("focus-list") then
    return nil
  end

  quarto.doc.add_html_dependency({
    name = "focus-list-styles",
    version = "1.1.0",
    stylesheets = {"focus-list.css"}
  })

  if dim_parents and not el.classes:includes("dim-parents") then
    el.classes:insert("dim-parents")
  end

  -- The handler is deliberately not recursive: a hoisted nested list stays a
  -- plain BulletList in the item, so the walk still reaches it exactly once
  return pandoc.walk_block(el, {
    BulletList = function(list)
      for i, item in ipairs(list.content) do
        list.content[i] = focus_item(item)
      end
      return list
    end
  })
end

-- Two passes so the document options are read before any list is rewritten
return {
  { Meta = read_options },
  { Div = focus_list }
}
