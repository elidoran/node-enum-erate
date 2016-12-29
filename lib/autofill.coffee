# fill in the info we can figure out based on defaults/style
module.exports = (info) ->
  {items} = info

  # for an array of strings, fill in both index and value
  if typeof items[0] is 'string' # convert strings to objects
    for name,index in items
      items[index] = name:name, index:index, value:Math.pow 2, index

  else # fill in index/value props on objects
    for item,index in items
      item.index = index
      item.value ?= Math.pow 2, index

  return info
