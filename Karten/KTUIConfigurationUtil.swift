import Foundation
import UIKit

private var configurationDict    = readConfigurationFromFile()
private let textAlignmentMap = [
    "left" : NSTextAlignment.Left,
    "right" : NSTextAlignment.Right,
    "center" : NSTextAlignment.Center,
    "justified" : NSTextAlignment.Justified
]

extension NSDictionary {
    class func attributesDictionaryWithJSONAttributes(attributes: NSDictionary) -> NSDictionary {
        let fontName = attributes["font"] as! NSString
        let fontSize = attributes["size"] as! NSNumber
        let colorString = attributes["color"] as! NSString
        let color = UIColor(rgb_a: colorString as String)
        let font = UIFont(name: fontName as String, size: CGFloat(fontSize.floatValue))!
        var dict = [
                    NSFontAttributeName : font,
                    NSForegroundColorAttributeName : color
        ]
        if let alignmentString = attributes["alignment"] as? NSString {
            var paragraph = NSMutableParagraphStyle()
            paragraph.alignment = textAlignmentMap[alignmentString as String]!
            dict[NSParagraphStyleAttributeName] = paragraph
        }
        if let kerning = attributes["kerning"] as? NSNumber {
            dict[NSKernAttributeName] = kerning
        }

        return dict
    }
}

private func readConfigurationFromFile() -> NSDictionary {
    let filePath = NSBundle.mainBundle().pathForResource("KTUIConfigurationInfo", ofType: "json")!
    let jsonData = NSData(contentsOfFile: filePath)!
    var err : NSError?
    var dict = NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions.AllowFragments, error: &err) as? NSDictionary
    return dict!
}

public class KTUIConfigurationUtil {
    
    var prefix                              : String!
    
    func keyWithPrefix(key: String) -> String {
        return "\(prefix):\(key)"
    }
    
    func colorForKey(key: String) -> UIColor {
        return KTUIConfigurationUtil.colorForKey(keyWithPrefix(key))
    }
    
    func fontAttributesForKey(key: String) -> NSDictionary {
        return KTUIConfigurationUtil.fontAttributesForKey(keyWithPrefix(key))
    }
    func URLForKey(key: String) -> NSURL {
        return KTUIConfigurationUtil.URLForKey(keyWithPrefix(key))
    }
    
    func stringForKey(key: String) -> String? {
        return KTUIConfigurationUtil.stringForKey(keyWithPrefix(key))
    }
    
    func integerForKey(key: String) -> Int {
        return KTUIConfigurationUtil.integerForKey(keyWithPrefix(key))
    }
    
    func floatForKey(key: String) -> CGFloat {
        return KTUIConfigurationUtil.floatForKey(keyWithPrefix(key))
    }
    
    class func utilWithPrefix(prefix: String) -> KTUIConfigurationUtil {
            let util = KTUIConfigurationUtil()
            util.prefix = prefix
            return util
    }
    
    class func valueForKey(object: AnyObject, key: String) -> NSObject {
        var tokenized = split(key) {$0 == ":"} as [String]
        if tokenized.count == 0 {
            return object as!    NSObject
        }
        var currentKey = tokenized[0]
        tokenized.removeAtIndex(0)
        if let v = object[currentKey] as? NSDictionary {
            var remaining = ":".join(tokenized)
            return valueForKey(v, key: remaining)
        } else {
            return object[currentKey] as! NSObject
        }
    }

    class func valueForKey(key: String) -> NSObject {
        return valueForKey(configurationDict, key:key)
    }
    
    class func colorForKey(key: String) -> UIColor {
        var colorDescription = valueForKey(key) as! String
        var color = UIColor(rgb_a: colorDescription)
        return color
    }
    
    class func fontAttributesForKey(key: String) -> NSDictionary {
        let attributesDict = valueForKey(key) as! NSDictionary
        let parsedDict = NSDictionary.attributesDictionaryWithJSONAttributes(attributesDict)
        return parsedDict
    }
    
    class func URLForKey(key: String) -> NSURL {
        let URLString = valueForKey(key) as! String
        let url = NSURL(string: URLString)!
        return url
    }
    
    class func stringForKey(key: String) -> String? {
        return valueForKey(key) as? String
    }
    
    class func integerForKey(key: String) -> Int {
        var stringValue = valueForKey(key) as? NSNumber
        if stringValue == nil {
            return 0
        } else {
            var number = stringValue!.integerValue
            return number
        }
    }
    
    class func floatForKey(key: String) -> CGFloat {
        var stringValue = valueForKey(key) as? NSNumber
        if stringValue == nil {
            return CGFloat(0)
        } else {
            var number = stringValue!.floatValue
            return CGFloat(number)
        }
    }
    
    
}
