/// Copyright (c) 2020 Razeware LLC
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

import XCTest
@testable import DogYears

class DogYearsUnitTests: XCTestCase {
  
    let calc = Calculator()
    var resData: Data? = nil
  
    func testSettingsScreen() {
      
      let sb = UIStoryboard(name: "Main", bundle: nil)
      XCTAssertNotNil(sb, "Could not instantiate storyboard for Settings View creation")
      let vc = sb.instantiateViewController(withIdentifier: "SettingsView") as? SettingsViewController
      XCTAssertNotNil(vc, "Could not instantiate Settings view controller")
      _ = vc?.view
    }

    func testAdd() {
      let result = calc.evaluate(op: "+", arg1: 2.0, arg2: 9.0)
      XCTAssert(result == 11.0, "Calculator add operation failed")
    }
  
    func testSubtract() {
      
      let result = calc.evaluate(op: "-", arg1: 9.0, arg2: 2.0)
      XCTAssert(result == 7.0, "Calculator subtraction operation failed")
      
    }
  
    func testResult() {
    
      let res1 = calc.evaluate(op: "+", arg1: 2.0, arg2: 2.0)
      let res2 = calc.result
      XCTAssert(res1 == res2, "Calculator displayed result does not match calculation result.")
    
    }
  
    func testMenuLoadPerformance() {
    
      var menu = Menu()
      self.measure {
        menu.loadDefaultMenu()
      }
  
    }
  
  
    func testClear() {
    
      let res1 = calc.evaluate(op: "+", arg1: 2.0, arg2: 2.0)
      let res2 = calc.result
      XCTAssert(res1 == res2, "Calculated value did not match result in clear operation test")
      calc.clear()
      let res3 = calc.result
      XCTAssert(res2 != res3 && res3 == 0.0, "Calculator clear operation failed")
    
    }
  
    func testInfoLoading() {
    
      let url = "https://raw.githubusercontent.com/FahimF/Test/master/DogYears-Info.rtf"
     
      let session = MockSession()
      let client = HTTPClient(session: session)
      client.get(url: url) {
        (data, error) in
          self.resData = data
      }
      let pred = NSPredicate(format: "resData != nil")
      let exp = expectation(for: pred, evaluatedWith: self, handler: nil)
      let res = XCTWaiter.wait(for: [exp], timeout: 5.0)
      if res == XCTWaiter.Result.completed {
        XCTAssertNotNil(resData, "No data recived from the server for InfoView content")
      } else {
        XCTAssert(false, "The call to get the URL ran into some other error")
      }
      
    }
}
