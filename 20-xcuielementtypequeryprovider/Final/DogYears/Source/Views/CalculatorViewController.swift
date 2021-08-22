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

class CalculatorViewController: UIViewController {
  @IBOutlet private weak var lblOutput: UILabel! {
    didSet {
      lblOutput.accessibilityIdentifier = "output"
    }
  }

	@IBOutlet private weak var lblHistory: UILabel!
	@IBOutlet private weak var btnDog: UIButton!
	@IBOutlet private weak var btnCat: UIButton!
	@IBOutlet private weak var btnChicken: UIButton!
	@IBOutlet private weak var btnHuman: UIButton!
	@IBOutlet private weak var btnDot: UIButton!
	@IBOutlet private weak var btn0: UIButton!
	@IBOutlet private weak var btn1: UIButton!
	@IBOutlet private weak var btn2: UIButton!
	@IBOutlet private weak var btn3: UIButton!
	@IBOutlet private weak var btn4: UIButton!
	@IBOutlet private weak var btn5: UIButton!
	@IBOutlet private weak var btn6: UIButton!
	@IBOutlet private weak var btn7: UIButton!
	@IBOutlet private weak var btn8: UIButton!
	@IBOutlet private weak var btn9: UIButton!
	@IBOutlet private weak var btnAdd: UIButton!
	@IBOutlet private weak var btnSub: UIButton!
	@IBOutlet private weak var btnMult: UIButton!
	@IBOutlet private weak var btnDiv: UIButton!
	@IBOutlet private weak var btnEqual: UIButton!
	@IBOutlet private weak var btnClear: UIButton!
	@IBOutlet private weak var btnDelete: UIButton!

	private var isTypingANumber = false
	private var hasEnteredADot = false
	private var calc = Calculator()
	private var types = [UIButton]()
	private var currentType = Type.typeFor(tag: 100)
	
	var displayValue: Double {
		get {
			let text = lblOutput.text!
			return NumberFormatter().number(from: text)!.doubleValue
		}
		set {
			lblOutput.text = newValue.noZeroString()
			isTypingANumber = false
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Get type buttons into array
		for i in 100 ... 103 {
			if let btn = view.viewWithTag(i) as? UIButton {
				// Set initial type selection
				if i == 100 {
					btn.isSelected = true
				}
				types.append(btn)
			}
		}
		// Update theme
		let themes = Themes()
		// Set current selection
		let def = UserDefaults.standard
		let selection = def.integer(forKey: "CurrentTheme")
		if let thm = themes.themeAt(row: selection) {
			setup(theme: thm)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
	// MARK:- Actions
	@IBAction func selectType(sender: UIButton) {
		// Iterate over all type buttons
		for btn in types {
			btn.isSelected = btn == sender
		}
		// Switch type, if necessary
		if currentType.tag != sender.tag {
			let oldType = currentType
			currentType = Type.typeFor(tag: sender.tag)
			// Convert entry or displayed value to new type
			if calc.canConvert {
				if isTypingANumber {
					numberEntered()
				}
				// For first time
				if calc.lastOp == nil {
					_ = calc.evaluate(op: ">", arg: displayValue, type: oldType)
				}
				let result = calc.evaluate(op: ">", arg: displayValue, type:currentType)
				lblHistory.text = calc.history
				displayValue = result
			}
		}
	}
	
	@IBAction func appendDigit(sender: UIButton) {
		guard let text = lblOutput.text else { return }
		let digit = sender.currentTitle!
		if digit == "." {
			if hasEnteredADot {
				return
			} else {
				hasEnteredADot = true
			}
		}
		if isTypingANumber {
			lblOutput.text = text + digit
		} else {
			lblOutput.text = digit
			isTypingANumber = true
		}
	}
	
	@IBAction func operate(sender: UIButton) {
		if isTypingANumber {
			numberEntered()
		}
		if let op = sender.currentTitle {
			let result = calc.evaluate(op: op, arg: displayValue, type:currentType)
			lblHistory.text = calc.history
			displayValue = result
		}
	}
	
	@IBAction func clear() {
		numberEntered()
		lblOutput.text = "0"
		print("Calculator has been reset")
		calc = Calculator()
		lblHistory.text = calc.history
	}
	
	@IBAction func backspace() {
		guard let text = lblOutput.text else { return }
		if text.count > 0 {
			lblOutput.text = String(text.dropLast())
			if lblOutput.text!.isEmpty {
				isTypingANumber = false
				lblOutput.text = "0"
			}
		}
	}
	
	@IBAction func changeSign() {
		displayValue = -(displayValue)
	}
	
	// MARK:- Public Methods
	func setup(theme: Theme) {
		// Background
		view.backgroundColor = UIColor.from(hex: theme.bg)
		// Results
		lblOutput.backgroundColor = UIColor.from(hex: theme.result)
		lblOutput.textColor = UIColor.from(hex: theme.buttonText)
		// History
		lblHistory.textColor = UIColor.from(hex: theme.historyText)
		// Numbers
		btnDot.backgroundColor = UIColor.from(hex: theme.numbers)
		btnDot.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn0.backgroundColor = UIColor.from(hex: theme.numbers)
		btn0.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn1.backgroundColor = UIColor.from(hex: theme.numbers)
		btn1.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn2.backgroundColor = UIColor.from(hex: theme.numbers)
		btn2.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn3.backgroundColor = UIColor.from(hex: theme.numbers)
		btn3.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn4.backgroundColor = UIColor.from(hex: theme.numbers)
		btn4.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn5.backgroundColor = UIColor.from(hex: theme.numbers)
		btn5.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn6.backgroundColor = UIColor.from(hex: theme.numbers)
		btn6.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn7.backgroundColor = UIColor.from(hex: theme.numbers)
		btn7.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn8.backgroundColor = UIColor.from(hex: theme.numbers)
		btn8.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btn9.backgroundColor = UIColor.from(hex: theme.numbers)
		btn9.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		// Operators
		btnDog.backgroundColor = UIColor.from(hex: theme.operators)
		btnCat.backgroundColor = UIColor.from(hex: theme.operators)
		btnChicken.backgroundColor = UIColor.from(hex: theme.operators)
		btnHuman.backgroundColor = UIColor.from(hex: theme.operators)
		btnAdd.backgroundColor = UIColor.from(hex: theme.operators)
		btnAdd.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btnSub.backgroundColor = UIColor.from(hex: theme.operators)
		btnSub.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btnMult.backgroundColor = UIColor.from(hex: theme.operators)
		btnMult.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btnDiv.backgroundColor = UIColor.from(hex: theme.operators)
		btnDiv.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btnEqual.backgroundColor = UIColor.from(hex: theme.operators)
		btnEqual.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		// Actions
		btnClear.backgroundColor = UIColor.from(hex: theme.actions)
		btnClear.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
		btnDelete.backgroundColor = UIColor.from(hex: theme.actions)
		btnDelete.setTitleColor(UIColor.from(hex: theme.buttonText), for: UIControl.State.normal)
	}
	
	// MARK:- Private Methods
	private func numberEntered() {
		isTypingANumber = false
		hasEnteredADot = false
	}
}
