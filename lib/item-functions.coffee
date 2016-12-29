# default functions for an item
module.exports =
  
  # returns true for self or a group member or if its value/name matches
  has: (it) ->
    # if it's self then it's true
    if this is it then return true

    # if it has the __ENUM__ marker then it's one of our types
    if it.__ENUM__?

      # if the two types don't match, then they can't "has()"
      unless it.__ENUM__ is @__ENUM__ then return false

      # if this is a group, search its members
      if @members? then return it in @members

    # otherwise it's not an enum item, so, try based on the type of value
    else switch typeof it

      # try doing a bit op on the number or matching it exactly
      when 'number' then return ((@value & it) is it) or @value is it

      when 'string'
        # try matching its name, or value
        return it is @name or it is @value or
          # or finally, search members array for the string as its name
          (@members? and @members.filter((i) -> it is i.name).length > 0)

    # nothing worked
    return false

  toString: -> @name
