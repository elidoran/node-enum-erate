itemFunctions = require './item-functions'

# build the property descriptors for each item.
module.exports = (info) ->
  {items} = info

  for item,index in items
    props = {}

    for own key,value of itemFunctions # use default functions
      props[key] = value:value # enumerable/configurable/writable are false

    for own key,value of item # use the provided stuff
      # configurable/writable are false. only enumerable if it's not a function
      props[key] = value:value, enumerable:typeof value isnt 'function'

    props.__ENUM__ = value:info.name

    # replace the item with an object from described props.
    # create using the `props` and no prototype.
    # this way, no props can be altered, so, it's immutable,
    # and all props are configured right on the object
    items[index] = Object.create null, props

  return info
