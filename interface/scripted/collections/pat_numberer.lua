local indexLabels = {}
pat_indexLabels = indexLabels

local populateList_old = populateList
function populateList(...)
  populateList_old(...)

  if not self.collectionName then return end

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
  if not self.collectionName then return end

  local indexesEnabled = widget.getChecked("pat_numbererToggleButton")
  local labels = indexLabels[self.collectionName]

  for widgetName, collectable in pairs(self.currentCollectables) do
    local text = indexesEnabled and labels[collectable.name] or collectable.order
    widget.setText(widgetName .. ".index", text)
  end
end

local createTooltip_old = createTooltip
function createTooltip(screenPosition, ...)
  local child = widget.getChildAt(screenPosition)
  if child == ".pat_numbererToggleButton" then
    return widget.getData("pat_numbererToggleButton")
  end

  return createTooltip_old(screenPosition, ...)
end

local init_old = init
function init(...)
  init_old(...)
  widget.setChecked("pat_numbererToggleButton", not not getmetatable''.pat_collectionNumbererEnabled)
end

local uninit_old = uninit
function uninit(...)
  if uninit_old then uninit_old() end
  getmetatable''.pat_collectionNumbererEnabled = widget.getChecked("pat_numbererToggleButton")
end