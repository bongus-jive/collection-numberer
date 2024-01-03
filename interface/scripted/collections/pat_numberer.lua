local populateList_old = populateList

function populateList()
  populateList_old()

  if not self.collectionName then return end

  local collectables = root.collectables(self.collectionName)
  table.sort(collectables, function(a, b) return a.order < b.order end)

  local labels = {}
  for i, c in ipairs(collectables) do
    labels[c.name] = tostring(i)
  end

  for widgetName, collectable in pairs(self.currentCollectables) do
    local label = labels[collectable.name]
    widget.setText(widgetName..".index", label)
  end
end