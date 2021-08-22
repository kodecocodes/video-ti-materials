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

import UIKit

class MenuCell: UITableViewCell {
	@IBOutlet private weak var vwBG: UIView!
	@IBOutlet private weak var imgIcon: UIImageView!
	@IBOutlet private weak var lblTitle: UILabel!

	private let colNormal = #colorLiteral(red: 0.008669083938, green: 0.8590171337, blue: 0.929469049, alpha: 0.4)
	private let colSelected = #colorLiteral(red: 0, green: 0.6686167717, blue: 0.9414479136, alpha: 0.4)
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set up
		vwBG.backgroundColor = colNormal
		vwBG.layer.masksToBounds = true
		vwBG.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		vwBG.backgroundColor = selected ? colSelected : colNormal
    }

	func setup(item: MenuItem) {
		lblTitle.text = item.title
		imgIcon.image = UIImage(named: item.title)
	}
}
