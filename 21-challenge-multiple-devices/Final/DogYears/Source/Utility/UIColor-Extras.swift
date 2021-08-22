/// Copyright (c) 2020 Fahim Farook
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

extension UIColor {
	convenience init(hex:String, alpha:Float = 1.0) {
		var al = alpha
		// Remove # prefix, if used
		var tmp = hex.hasPrefix("#") ? String(hex[hex.index(after:hex.startIndex)...]) : hex
		// Handle standard HTML colours such as black, white etc.
		let colours = ["black":"000000", "white":"FFFFFF", "red":"FF0000", "cyan":"00FFFF", "blue":"0000FF", "purple":"800080", "yellow":"FFFF00", "lime":"00FF00", "magenta":"FF00FF", "silver":"C0C0C0", "green":"008000", "olive":"808000"]
		if let buf = colours[tmp] {
			tmp = buf
		}
		// Set a default of black (in case the string is invalid)
		var strR = "0"
		var strG = "0"
		var strB = "0"
		let cnt = tmp.count
		// Is this a 3 digit hex string?
		var from = tmp.startIndex
		if cnt == 3 {
			var to = tmp.index(after:from)
			strR = String(tmp[from..<to])
			from = tmp.index(after:from)
			to = tmp.index(after:from)
			strG = String(tmp[from..<to])
			from = tmp.index(after:from)
			to = tmp.index(after:from)
			strB = String(tmp[from..<to])
		}
		// Handle 6 digit hex string
		if cnt >= 6 {
			var to = tmp.index(from, offsetBy:2)
			strR = String(tmp[from..<to])
			from = to
			to = tmp.index(from, offsetBy:2)
			strG = String(tmp[from..<to])
			from = to
			to = tmp.index(from, offsetBy:2)
			strB = String(tmp[from..<to])
			if cnt == 8 {
				from = to
				to = tmp.index(from, offsetBy:2)
				let str = String(tmp[from..<to])
				var a: UInt64 = 0
				Scanner(string:str).scanHexInt64(&a)
				al = Float(a) / 255.0
			}
		}
		// Convert strings to Int values
    var r: UInt64 = 0
    var g: UInt64 = 0
    var b: UInt64 = 0
		Scanner(string:strR).scanHexInt64(&r)
		Scanner(string:strG).scanHexInt64(&g)
		Scanner(string:strB).scanHexInt64(&b)
		let rf = Float(r) / 255.0
		let gf = Float(g) / 255.0
		let bf = Float(b) / 255.0
//		println("Final values r:\(rf), g:\(gf), b:\(bf)")
		self.init(red:CGFloat(rf), green:CGFloat(gf), blue:CGFloat(bf), alpha:CGFloat(al))
	}
	
	@objc public class func from(hex:String)->UIColor {
		return UIColor(hex:hex, alpha:1.0)
	}
	
	var hexString:String {
		let colorSpace = cgColor.colorSpace!.model
		var r:Float = 0
		var g:Float = 0
		var b:Float = 0
		var a:Float = 0
		if let comps = cgColor.components {
			if colorSpace == CGColorSpaceModel.monochrome {
				r = Float(comps[0])
				g = Float(comps[0])
				b = Float(comps[0])
				a = Float(comps[1])
			} else if colorSpace == CGColorSpaceModel.rgb {
				r = Float(comps[0])
				g = Float(comps[1])
				b = Float(comps[2])
				a = Float(comps[3])
			}
		}
		return String(format:"#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
	}
}
