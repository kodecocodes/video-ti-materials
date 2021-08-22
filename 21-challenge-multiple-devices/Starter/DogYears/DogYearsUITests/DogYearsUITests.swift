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

class DogYearsUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    app = .init()
    app.launch()

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
  }

  func test_navigationBackToMenu() throws {
    let isiPad = UIDevice.current.userInterfaceIdiom == .pad
    let isPortrait = XCUIDevice.shared.orientation.isPortrait

    let masterNavBar = app.navigationBars["Master"]
    let menuButton = masterNavBar.buttons["Menu"]
    menuButton.tap()

    XCTAssertFalse(masterNavBar.exists)
    XCTAssert(app.navigationBars["Menu"].exists)
  }

  func test_calculatorEntry() {
    let app = XCUIApplication()
    app.buttons["2"].tap()
    app.buttons["4"].tap()
    XCTAssertEqual(
      app
        .staticTexts
        .matching(identifier: "output")
        .firstMatch
        .label,
      "24"
    )
  }
}
