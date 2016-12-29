# default functions for an enum
enumFunctions =
  # array of all the names of the enums
  names : -> @items.map (e) -> e.name

  # array of all the values of each enum prop.
  values: -> @items.map (e) -> e.value

  # array of all the indices of each enum prop.
  indexes: -> @items.map (e) -> e.index

  valueOf: (which) ->
    # NOTE: trouble when value type is number...
    switch typeof which
      when 'string' then return item for item in @items when item.name is which
      when 'number' then @items[which]
      else return item for item in @items when item.value is which

  # for example: Test[A,B,C]
  toString: -> @name + '[' + @names() + ']'

# convenience aliases
enumFunctions.keys    = enumFunctions.names
enumFunctions.indices = enumFunctions.indexes

module.exports = (info) ->

  # build the property descriptors for the enum object
  props =
    name : value:info.name
    items: get: -> info.items.slice()

  props[key] = value:value for own key,value of enumFunctions

  for own key,value of info.extra # enumerable when it's not a function
    props[key] = value:value, enumerable: typeof value isnt 'function'

  props[item.name] = value:item, enumerable:true for item in info.items

  Object.create null, props
