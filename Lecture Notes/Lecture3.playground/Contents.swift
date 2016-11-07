//
//  Lecture 3 Notes
//

import UIKit


// ---------- Optionals ----------

// just an enum
enum Optional<T> { // T is a generic type, like Array<T>
    case None
    case Some(T)
}

let a: String? = nil  // same as `let a = Optional<String>.None`
let b: String? = "hello"  // same as `let b = Optional<String>.Some("hello")
var c = b!
/* is the same as ...
switch b {
    case .Some(let value): c = value
    case .None:  // raise exception
}
*/

// chaining optionals

var display: UILabel?
if let label = display {
    if let text = label.text {
        let d = text.hashValue
    }
}
// ... or ...
let e = display?.text?.hashValue  // will try to unwrap each optional denoted by "?" or will return nil

// default for optionals

let s: String? = "I'm a string"
if s != nil {
    display?.text = s!
} else {
    display?.text = " "
}
// ... or ...
display?.text = s ?? " "


// ---------- Tuples ----------

let t: (String, Int, Double) = ("hello", 5, 0.85)
let (word, number, value) = t  // elements named when _accessing_ the tuple
word
number
value

let u: (w: String, i: Int, v: Double) = ("hello", 5, 0.85)  // elements named during declaration
u == t
let (wrd, num, val) = u  // this is also legal (renames elements on access)

let x = (w: "hello", i: 5, v: 0.85)
x.w
x.i
x.v


// ---------- Range ----------

// a range is just 2 endpoints
struct Range<T> {
    var startIndex: T
    var endIndex: T
}
var arrayRange: Range<Int>  // since arrays are indexed by integers

let array = ["a", "b", "c", "d"]
let subArray1 = array[2...3]
let subArray2 = array[2..<3]
for i in 27...104 {}  // Ranges are enumeratable


// ---------- Fundamental Data Structures ----------

class CalculatorBrain: UIColor {  // only classes have inhertance (e.g., here it inherits from UIColor)
    // classes are passed by reference
    func doit(argument: String) -> Double? {
        return Double(argument)
    }
}
struct Vertex {  // passed by value
    init(arg1: String, arg2: Int) {
        // some initializer code
    }
    var storedProperty = 6
    mutating func plusOne(){
        // must mark functions that will change an enum/struct with "mutating"
        storedProperty += 1
    }
}
enum Op {  // passed by value
    // can't have stored properties
    // can't have an initializer
    var computedProperty: Double {
        get {return 1.5}
        set {}
    }
}

// ---------- Methods ----------

func foo(forcedFirst first: Int, externalSecond second: Double) -> Double {  // first parameter defaults to "_", i.e. no external variable name
    var sum = 0.0
    for _ in 0..<first { sum += second }
    return second
}

func bar() {
    let result = foo(forcedFirst: 123, externalSecond: 5.5)
    print(result)
}

func bestPractice(first: Int, second: Double) -> Double {
    var done: Double?
    if (first > 0) {
        let next = first - 1
        done = bestPractice(first: next, second: second)  // updated for swift 3.0
    }
    return done ?? second
}

class SubCalculatorBrain: CalculatorBrain {
    override func doit(argument: String) -> Double? {
        // new func!
        return 3.14
    }
    
    final func cannotChangeThisFunc() {
        // subclasses can't override this
    }
    
    static func classFunc() {
        // this is accessed at the class level, e.g. SubCalculatorBrain.classFunc()
    }
}

final class FinalSubCalculatorBrain: SubCalculatorBrain {
    // nothing in this class can be overridden
}

// Instance vs. Type methods/properties

var d: Double = 07734
if (d.isFinite) {  // instance property
    d = Double.abs(d)  // type method
}


// ---------- Properties ----------

// Observers

var someStoredProperty = 42 {
    willSet { newValue }  // is the new value
    didSet { oldValue }  // is the old value
}  // can do this for inherited properties too

var operations: Dictionary<String, Double> = ["one": 1] {
    willSet { }  // executed if dictionary is mutated at all
    didSet { }  // executed if dictionary is mutated at all
}

// Lazy Initialization

class LazyClass {
    lazy var brain = CalculatorBrain()  // does not get initialized until someone accesses brain
    
    func initializeMyProperty() -> Double {
        return 1.3
    }
    
    lazy var myProperty: Double = self.initializeMyProperty()  // usually this is illegal, but "lazy" makes it work
    
    lazy var someProperty: Double = {
        return 2.0 + 2.0
    }()  // need the paratheses at the end to initialize it
}



// ---------- Array ----------

let animals = ["Giraffe", "Cow", "Doggie", "Bird"]
// can't .append() since it's immutable
// animals[5] will crash since the index is out of bounds

for animal in animals {
    print(animal)
}

// Methods
let numbers = [2, 47, 118, 5, 9]
let bigNumbers = numbers.filter({ $0 > 20 })
bigNumbers

let stringify = [1, 2, 3].map { String($0) }  // don't need paratheses when a closure is the last argument
stringify

let reducedArray = [1,2,3].reduce(0) {$0 + $1}  // trailing closure syntax
reducedArray
let newStartValue = [1,2,3].reduce(5) {$0 + $1}
newStartValue


// ---------- Dictionary ----------

// this is the same as = Dictionary<String, Int>()
var pac10TeamRankings = [String: Int]()

pac10TeamRankings = [
    "Stanford": 1,
    "Cal": 12
]

let ohioRanking = pac10TeamRankings["Ohio State"]

for (key, value) in pac10TeamRankings {
    print( "\(key) = \(value)" )
}

for (key, _) in pac10TeamRankings {
    print( "\(key) is a pac 10 team")
}


// ---------- String ----------
// these are full unicode

let myString = "This is a string."

// human readable representation of the characters in a string
var myStringCharacters = myString.characters

for i in myStringCharacters {
    print( i )
}

myStringCharacters.startIndex
myStringCharacters.endIndex

myStringCharacters[myStringCharacters.startIndex]


// methods
"1,2,3".components(separatedBy: ",")



// ---------- Other Classes ----------

// NSObject: The base class of all Objective-C classes
// sometimes need to subclass this so older APIs will work

// NSNumber: generic number holding class
// Obj-C needs primitive types wrapped in this object to store it in Arrays or Dictionairies, but Swift doesn't. Don't need to worry about compatability as these are "bridged"

// NSDate: also see NSCalendar, NSDateFormatter, NSDateComponents


// NSData: a "bag o' bits"
// used to save / restore / transmit raw data throughout the iOS SDK


// AnyObject
// need to convert to a known class before doing anything
// uses as? (or as!) to "cast" to a different class
let stringAO : AnyObject = "Any Object" as AnyObject
if let foo = stringAO as? String {
    print(foo)
}

if stringAO is String {
    true
} else {
    false
}

stringAO is Int ? true : false


// Property Lists

// e.g., UserDefaults (a *small* database that persists between app launches, good for settings)
let defaults = UserDefaults.standard

let plist = defaults.object(forKey: "foo")
defaults.set(plist, forKey: "foo")



