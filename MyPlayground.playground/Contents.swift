//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let dateString = "2016-05-29T14:45:03+0800"
let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

let date = dateFormatter.dateFromString(dateString)!

let outputFormatter = NSDateFormatter()
outputFormatter.locale = NSCalendar.currentCalendar().locale
outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

print(outputFormatter.stringFromDate(date))


