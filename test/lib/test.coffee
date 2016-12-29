assert = require 'assert'
enumerate = require '../../lib'

# this tests an enumerate result assuming it enumerated A, B, C.
# there are a few options which enable extra testing.
successfully = (result, options = {}) ->

  it 'should produce a result', -> assert result
  it 'should have a name', -> assert.equal result.name, 'Test'

  it 'should have an A item', -> assert result.A
  it 'should have A\'s name', -> assert.equal result.A.name, 'A'
  it 'should have A\'s index', -> assert.equal result.A.index, 0
  it 'should have A\'s value', -> assert.equal result.A.value, 1
  it 'should toString A to its name', -> assert.equal result.A.toString(), 'A'
  it 'item A should equal itself', -> assert.equal result.A, result.A
  it 'item A should NOT equal item B', -> assert.notEqual result.A, result.B
  it 'item A should be retrievable via name', -> assert.equal result.valueOf('A'),result.A
  it 'item A should be retrievable via index', -> assert.equal result.valueOf(0),result.A
  it 'item A should has() itself', -> assert result.A.has result.A
  it 'item A should has() its own value', -> assert result.A.has result.A.value
  it 'item A should NOT has() item B', -> assert.equal result.A.has(result.B), false
  it 'item A should NOT has() item B\'s value', -> assert.equal result.A.has(result.B.value), false

  it 'should have an B item', -> assert result.B
  it 'should have B\'s name', -> assert.equal result.B.name, 'B'
  it 'should have B\'s index', -> assert.equal result.B.index, 1
  it 'should have B\'s value', -> assert.equal result.B.value, 2
  it 'item B should equal itself', -> assert.equal result.B, result.B
  it 'item B should be retrievable via name', -> assert.equal result.valueOf('B'),result.B
  it 'item B should be retrievable via index', -> assert.equal result.valueOf(1),result.B

  it 'should have an C item', -> assert result.C
  it 'should have C\'s name', -> assert.equal result.C.name, 'C'
  it 'should have C\'s index', -> assert.equal result.C.index, 2
  it 'should have C\'s value', -> assert.equal result.C.value, 4
  it 'item C should equal itself', -> assert.equal result.C, result.C
  it 'item C should be retrievable via name', -> assert.equal result.valueOf('C'),result.C
  it 'item C should be retrievable via index', -> assert.equal result.valueOf(2),result.C

  it 'should have an items array', -> assert result.items

  it 'should be an immutable items array', ->

    answer = result.items

    # try to mutate it
    result.items.pop()
    result.items.shift()
    result.items.push 'a'
    result.items.unshift 'a'
    result.items.sort (a,b) -> b.index - a.index
    result.items.reverse()
    result.items.fill? 'a'
    result.items[0] = 'a'
    result.items[2] = 'z'

    assert.deepEqual result.items, answer

  if options.groups is true
    it 'should have a group', -> assert result.AB
    it 'should have a name for group', -> assert result.AB.name, 'AB'
    it 'should have an index for group', -> assert result.AB.index, 3
    it 'should have a combined value for group', -> assert result.AB.value, 3
    it 'should have members array for group', -> assert.deepEqual result.AB.members, [ result.A, result.B ]
    it 'group should has() item A', -> assert result.AB.has result.A
    it 'group should has() item A.value', -> assert result.AB.has result.A.value
    it 'group should has() item A.value', -> assert result.AB.has result.A.name
    it 'group should has() item B', -> assert result.AB.has result.B
    it 'group should NOT has() item C', -> assert.equal result.AB.has(result.C), false
    it 'should toString enum', -> assert.equal result.toString(), 'Test[A,B,C,AB]'
    it 'should have an items array', -> assert.deepEqual result.items, [result.A,result.B,result.C, result.AB]
    it 'should have names array',  -> assert.deepEqual result.names(), ['A','B','C','AB']
    it 'should have indexes array',-> assert.deepEqual result.indexes(), [0, 1, 2, 3]
    it 'should have values array', -> assert.deepEqual result.values(), [1, 2, 4, 3]

  else
    it 'should have an items array', -> assert.deepEqual result.items, [result.A,result.B,result.C]
    it 'should have names array',  -> assert.deepEqual result.names(), ['A','B','C']
    it 'should have indexes array',-> assert.deepEqual result.indexes(), [0, 1, 2]
    it 'should have values array', -> assert.deepEqual result.values(), [1, 2, 4]
    it 'should toString enum', -> assert.equal result.toString(), 'Test[A,B,C]'

  if options.extras is true
    it 'should have `extraNum`', -> assert.equal result.extraNum, 10
    it 'should have `extraString`', -> assert.equal result.extraString, 'test'
    it 'should have `extraFn`', -> assert result.extraFn
    it '`extraFn` should be a function', -> assert.equal typeof result.extraFn, 'function'
    it 'extra function should NOT be enumerable', ->
      found = false
      found = true for each of result when each is result.extraFn
      assert.equal found, false, 'should not find the function'

  if options.itemExtras is true
    it 'item A should have `extraNum`', -> assert.equal result.A.extraNum, 10
    it 'item A should have `extraString`', -> assert.equal result.A.extraString, 'test'
    it 'item A should have `extraFn`', -> assert result.A.extraFn
    it 'item A `extraFn` should be a function', -> assert.equal typeof result.A.extraFn, 'function'
    it 'item A extra function should NOT be enumerable', ->
      found = false
      found = true for each of result.A when each is result.A.extraFn
      assert.equal found, false, 'should not find the function'




# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Below runs the above tests on their enumerate results #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

describe 'test enumerate string params', ->

  successfully enumerate 'Test', 'A', 'B', 'C'


describe 'test enumerate array of strings param', ->

  successfully enumerate 'Test', ['A', 'B', 'C']


describe 'test enumerate object param with array of strings', ->

  successfully enumerate 'Test', items: ['A', 'B', 'C']


describe 'test enumerate object param with array of strings', ->

  successfully enumerate 'Test', items: ['A', 'B', 'C']


describe 'test enumerate object params', ->

  successfully enumerate 'Test', { name:'A'}, {name:'B'}, {name:'C'}


describe 'test enumerate array of objects param', ->

  successfully enumerate 'Test', [ { name:'A'}, {name:'B'}, {name:'C'} ]


describe 'test enumerate array of objects param', ->

  successfully enumerate 'Test', items:[ { name:'A'}, {name:'B'}, {name:'C'} ]


describe 'test enumerate object param', ->

  param =
    extraNum: 10
    extraString: 'test'
    extraFn: ->
    items:[ { name:'A'}, {name:'B'}, {name:'C'} ]

  successfully enumerate('Test', param), extras:true


describe 'test enumerate with a group (array value)', ->

  param =
    items:[ { name:'A'}, {name:'B'}, {name:'C'} ]
    groups: AB: [ 'A', 'B' ]

  successfully enumerate('Test', param), groups:true


describe 'test enumerate with a group (object value)', ->

  param =
    items:[ { name:'A'}, {name:'B'}, {name:'C'} ]
    groups: AB: value:3, members:[ 'A', 'B' ]

  successfully enumerate('Test', param), groups:true


describe 'test enumerate an item with extras', ->

  successfully enumerate( 'Test', [
      { name:'A', extraNum:10, extraString:'test', extraFn: -> }
      { name:'B' }
      { name:'C' }
    ]), itemExtras:true


 # # # # # # # # # # # # # # # # # # # # # # # # # #
 #  These run custom tests for what's missed above #
 # # # # # # # # # # # # # # # # # # # # # # # # # #

describe 'test enumerate with customValue', ->
  customValue = isa:'object'
  en = enumerate 'Test', [ { name:'A', value:customValue } ]

  assert.equal en.A.value, customValue
  assert.equal en.valueOf(customValue), en.A

describe 'test enumerate single object element', ->

  en = enumerate 'Test', {name: 'A'}
  assert.equal en.A.name, 'A'

describe 'test has() of diff enums items', ->

  en1 = enumerate 'Test1', 'A'
  en2 = enumerate 'Test2', 'A'
  assert.equal en1.A.has(en2.A), false
