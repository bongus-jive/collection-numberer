local indexLabels = {}
pat_indexLabels = indexLabels

local _populateList = populateList
function populateList(...)
  if _populateList then _populateList(...) end

  if not self.collectionName or self.collectionName == "customCollections" then return end
  
  local collectables = root.collectables(self.collectionName)
  table.sort(collectables, function(a, b) return a.order < b.order end)

  local buttonVisible = false

  local labels = {}
  indexLabels[self.collectionName] = labels
  for i, c in ipairs(collectables) do
    if (i ~= c.order) then buttonVisible = true end
    labels[c.name] = i
  end

  widget.setVisible("pat_numbererToggleButton", buttonVisible)

  pat_setIndexLabels()
end

function pat_setIndexLabels()
  if not self.collectionName or self.collectionName == "customCollections" then return end

  local indexesEnabled = widget.getChecked("pat_numbererToggleButton")
  local labels = indexLabels[self.collectionName]
  if not labels then return end

  for widgetName, collectable in pairs(self.currentCollectables) do
    local text = indexesEnabled and labels[collectable.name] or collectable.order
    widget.setText(widgetName .. ".index", text)
  end
end

local _createTooltip = createTooltip
function createTooltip(screenPosition)
  local child = widget.getChildAt(screenPosition)
  if child == ".pat_numbererToggleButton" then
    return widget.getData("pat_numbererToggleButton")
  end

  if _createTooltip then
    return _createTooltip(screenPosition)
  end
end

local _init = init
function init()
  if _init then _init() end
  widget.setChecked("pat_numbererToggleButton", getmetatable''.pat_collectionNumbererEnabled ~= false)
end

local _uninit = uninit
function uninit()
  if _uninit then _uninit() end
  getmetatable''.pat_collectionNumbererEnabled = widget.getChecked("pat_numbererToggleButton")
end
