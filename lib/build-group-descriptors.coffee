itemFunctions = require './item-functions'

module.exports = (info) ->
  {items, extra} = info

  for own group,members of extra.groups

    # for an array, combine their values to generate the value
    if Array.isArray members
      value = 0
      value += item.value for item in items when item.name in members

    else # for an object, it *should* provide the `value`
      value   = members.value
      members = members.members

    # replace members elements with the actual items
    members = items.filter (item) -> item.name in members

    props = # the usual item props, plus a `members`
      name : value:group, enumerable:true
      index: value:items.length, enumerable:true
      value: value:value, enumerable:true
      # getter slices to prevent mutation
      members: get: -> members.slice()
      __ENUM__: value:info.name

    for own key,value of itemFunctions # use default functions
      props[key] = value:value # enumerable/configurable/writable are false

    # also needs a function to test another item is in this group
    #props.has = value:hasMember

    # create using the `props` and no prototype.
    # this way, no props can be altered, so, it's immutable,
    # and all props are configured right on the object
    items.push Object.create null, props

  # now that we've used the groups, get rid of their info on `extra`
  # because later we'll add any remaining `extra` properties onto the enum.
  delete extra.groups

  return info
