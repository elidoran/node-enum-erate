interpreted    = require './interpret-params'
forAutoFilled  = require './autofill'
andDescriptors = require './build-item-descriptors'
withGroups     = require './build-group-descriptors'
createEnum     = require './create-enum'

module.exports = (name, items...) ->

  # calls all the worker functions in synchronous sequence (some fun wordplay)
  createEnum withGroups andDescriptors forAutoFilled interpreted name, items
