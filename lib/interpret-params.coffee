# get the stuff we need from different types of input params
module.exports = (name, items) ->

  # check if we need to unwrap/extract from the one element
  if items.length is 1

    # unwrap the array
    if Array.isArray items[0] then items = items[0]

    # extract array from object and remember the extras
    else if typeof items[0] is 'object' and items[0].items?
      extra = items[0]
      items = extra.items
      delete extra.items

  name : name
  items: items
  extra: extra ? {}
