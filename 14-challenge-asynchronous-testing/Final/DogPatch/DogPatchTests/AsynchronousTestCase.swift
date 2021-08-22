/// Copyright (c) 2021 Razeware LLC
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
@testable import DogPatch

final class AsynchronousTestCase: XCTestCase {
  let timeout: TimeInterval = 2
  var expectation: XCTestExpectation!

  override func setUp() {
    expectation = expectation(description: "Server responds in reasonable time")
  }

  func test_noServerResponse() {
    let url = URL(string: "doggone")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }

      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertNotNil(error)
    }
    .resume()

    waitForExpectations(timeout: timeout)
  }

  func test_decodeDogs() {
    let url = URL(string: "https://rawcdn.githack.com/raywenderlich/video-ti-materials/versions/5.0/15-test-doubles/Final/DogPatch/DogPatchTests/dogs.json")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }

      XCTAssertNil(error)

      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 200)

        let data = try XCTUnwrap(data)
        XCTAssertNoThrow(
          try JSONDecoder().decode([Dog].self, from: data)
        )
      } catch { }
    }
    .resume()

    waitForExpectations(timeout: timeout)
  }

  func test_decodeDogtors() {
    struct OrthopedicDogtor: Decodable {
      let id: String
      let sellerID: String
      let about: String
      let birthday: Date
      let breed: String
      let breederRating: Double
      let cost: Decimal
      let created: Date
      let imageURL: URL
      let name: String

      let bones: [Int]
    }

    URLSession.shared.dataTask(
      with: URL(string: "https://rawcdn.githack.com/raywenderlich/video-ti-materials/versions/5.0/15-test-doubles/Final/DogPatch/DogPatchTests/dogs.json")!
    ) { data, response, error in
      defer { self.expectation.fulfill() }

      XCTAssertNil(error)
      XCTAssertEqual(
        (response as? HTTPURLResponse)?.statusCode,
        200
      )

      do {
        _ = try JSONDecoder().decode(
          [OrthopedicDogtor].self,
          from: try XCTUnwrap(data)
        )
      } catch {
        switch error {
        case DecodingError.keyNotFound(let key, _):
          XCTAssertEqual(key.stringValue, "bones")
        default:
          XCTFail("\(error)")
        }
      }
    }
    .resume()

    waitForExpectations(timeout: timeout)
  }

  func test_404() {
    let url = URL(string: "https://rawcdn.githack.com/raywenderlich/video-ti-materials/versions/5.0/15-test-doubles/Final/DogPatch/DogPatchTests/cats.json")!
    URLSession.shared.dataTask(with: url) { data, response, error in
      defer { self.expectation.fulfill() }

      XCTAssertNil(error)
      do {
        let response = try XCTUnwrap(response as? HTTPURLResponse)
        XCTAssertEqual(response.statusCode, 404)

        let data = try XCTUnwrap(data)
        XCTAssertThrowsError(
          try JSONDecoder().decode([Dog].self, from: data)
        ) { error in
          guard case DecodingError.dataCorrupted = error else {
            XCTFail("\(error)")
            return
          }
        }
      } catch { }
    }
    .resume()

    waitForExpectations(timeout: timeout)
  }
}
