# @enum/erate
[![Build Status](https://travis-ci.org/elidoran/node-enum-erate.svg?branch=master)](https://travis-ci.org/elidoran/node-enum-erate)
[![Dependency Status](https://gemnasium.com/elidoran/node-enum-erate.png)](https://gemnasium.com/elidoran/node-enum-erate)
[![npm version](https://badge.fury.io/js/%40enum%2Ferate.svg)](http://badge.fury.io/js/%40enum%2Ferate)
[![Coverage Status](https://coveralls.io/repos/github/elidoran/node-enum-erate/badge.svg?branch=master)](https://coveralls.io/github/elidoran/node-enum-erate?branch=master)

Create an immutable enum with immutable items and custom properties on both enum and enum items.

## Install

```sh
npm install @enum/erate --save
```

## Usage: Quick Start


```javascript
var enumerate = require('@enum/erate')
  , Color     = enumerate 'Color', 'RED', 'GREEN', 'BLUE'

console.log(Color.name)              // 'Color'
console.log(Color.RED)               // 'RED'
console.log(Color.RED.name)          // 'RED'
console.log(Color.RED.index)         // 0
console.log(Color.RED.value)         // 1 (2^0)

console.log(Color.BLUE)              // 'BLUE'
console.log(Color.BLUE.name)         // 'BLUE'
console.log(Color.BLUE.index)        // 1
console.log(Color.BLUE.value)        // 2 (2^1)

console.log(Color.RED === Color.RED) // true
console.log(Color.RED === Color.BLUE)// false

console.log(Color.toString())  // Color[RED,GREEN,BLUE]
console.log(Color)             // outputs:
{
  { name: 'RED',   index:0, value:1 }
  { name: 'GREEN', index:1, value:2 }
  { name: 'BLUE',  index:2, value:4 }
}

// this array is immutable because it returns a copy.
// array of enum items [ Color.RED, Color.GREEN, Color.BLUE ]
console.log(Color.items)

// these are immutable because they aren't stored in memory,
// when called, they run a filter on the items array to get the result
console.log(Color.names())   // [ 'RED', 'GREEN', 'BLUE' ]
console.log(Color.keys())    // [ 'RED', 'GREEN', 'BLUE' ]
console.log(Color.indexes()) // [ 0, 1, 2 ]  (custom indexes are possible...)
console.log(Color.values())  // [ 1, 2, 4 ]

// individual items have a `has()` function to be consistent
// with the group items which have `has()`
console.log(Color.RED.has(Color.RED))  // true  (see groups section)
console.log(Color.RED.has(Color.BLUE)) // false (see groups section)

// default values are power of 2 for bit operations:
var purple = Color.RED.value | Color.BLUE.value
// test with is()
console.log(Color.RED.is(purple))    // true
console.log(Color.GREEN.is(purple))  // false
console.log(Color.BLUE.is(purple))   // true

Color.valueOf(0)     // uses it as index to get Color.RED
Color.valueOf('RED') // uses it as name to get Color.RED
```


## Usage: How to Build

Specify the elements via multiple styles.

Always specify the name of the enum as the first input parameter.

```javascript
// A. as plain parameters
enm = enumerate('Name', 'A', 'B', 'C')
enm = enumerate('Name', {name:'A'}, {name:'B'}, {name:'C'})

// B. as an array (same as above, just wrapped in an array)
enm = enumerate('Name', ['A', 'B', 'C'])
enm = enumerate('Name', [{name:'A'}, {name:'B'}, {name:'C'}])

// C. an object with elements in `items` property
enm = enumerate('Name', {items:['A', 'B', 'C']})

// D. explicitly set other props, `index` and `value`,
// unlike the above examples which autofill those props.
enm = enumerate('Name', [
  {name:'A', index:0, value:1}, // NOTE: can customize `value`
  {name:'B', index:1, value:2}, // instead of power of 2.
  {name:'C', index:2, value:4}
])

enm = enumerate('Name', // doesn't have to be an array
  {name:'A', index:0, value:1},
  {name:'B', index:1, value:2},
  {name:'C', index:2, value:4}
)

// E. add extra properties to enum object, or an enum item
enm = enumerate('Name', {
  someNum: 123,
  someString: 'extra',
  someFn: function () { return 'fun' } // this will not be enumerable on `enm`
  items: [
    {name:'A', itemNum:456 },
    {name:'B', itemString:'item' },
    {name:'C', itemFn:function() { return 'fun 2'} }
  ]
})

// the properties are on the `enm` enum object.
// they're enumerable, except functions.
console.log(enm.someNum)    // 123
console.log(enm.someString) // 'extra'
console.log(enm.someFn())   // 'fun'


// the extra properties on the items are also available.
// they're enumerable, except functions.
console.log(enm.A.itemNum)    // 456
console.log(enm.A.itemString) // 'item'
console.log(enm.A.itemFn())   // 'fun 2'

// F. specify some groups of the enum items to become their own item
// see the section on Groups for more
enm = enumerate('Name', {
  items: [ 'A', 'B', 'C' ],
  groups: {
    // style 1: key is name and value is array of members.
    // the value for the group is calculated by adding member values.
    AB: [ 'A', 'B' ],
    // style 2: key is name and value is an object with
    // `value` set explicitly and array moved to `members`
    BC: {
      value: 6, // B=2 + C=4
      members: [ 'B', 'C' ]
    }
  }
})

console.log(enm.names)         // [ 'A', 'B', 'C', 'AB', 'BC' ]
console.log(enm.AB.has(enm.A)) // true
console.log(enm.AB.has(enm.C)) // false
console.log(enm.AB.members)    // contains both enm.A and enm.B in array
```

## Usage: Groups

Specify extra enum items which group together other items. There's a simple way which auto-calculates the value and an explicit which allows specifying the value.

```javascript
// think the suits of a deck of cards
var enm = enumerate('Suit',
  items: ['Spades', 'Hearts', 'Clubs', 'Diamonds'],
  groups: {
    // style 1: just specify the names in an array
    Red: [ 'Hearts', 'Diamonds' ],
    // style 2: specify the names array in `members`, and specify the `value`
    Black: {
      value: 5, // Spades=1, Clubs=4 when autofilled with power of 2
      members: [ 'Spades', 'Clubs' ]
    }
  }
)

Suit.Red.has(Suit.Hearts)     // true
Suit.Black.has(Suit.Diamonds) // false

// immutable members array because it copies it in the getter
Suit.Red.members // [
//  {name:'Hearts',index:1,value:2}
//  {name:'Diamonds',index:3,value:8}
//]
```


## MIT License
