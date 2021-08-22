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

import Foundation

enum OperationType:String {
	case none = ""
	case add = "+"
	case subtract = "−"
	case divide = "÷"
	case multiply = "×"
	case enter = "="
	case convert = ">"
}

struct Op {
	var argument = 0.0
	var result = 0.0
	var operation = OperationType.none
	var type = Type()
}

class Calculator {
	private var opStack = [Op]()
	private (set) var history = "History: "
	private (set) var canConvert = true
  private (set) var result = 0.0

	var lastOp: Op? {
		return opStack.last
	}
	
  func clear() {
    self.result = 0.0
  }
 
	func evaluate(op: String, arg: Double, type: Type) -> Double {
		result = 0.0
		var prevOp = OperationType.none
		let currOp = OperationType(rawValue: op) ?? OperationType.none
		// Multiple conversion support
		if let pop = opStack.last, pop.operation == OperationType.convert {
			if currOp != OperationType.convert {
				opStack.removeAll()
				history = "History: "
			}
		}
		canConvert = currOp == OperationType.enter || currOp == OperationType.convert
		// Previous operation check
		if opStack.isEmpty {
			result = arg
			var o = Op()
			o.result = arg
			o.operation = currOp
			o.type = type
			opStack.append(o)
			// History
			history += arg.noZeroString() + type.emoji + " " + (currOp == OperationType.convert ? "=" : op) + " "
			return result
		} else {
			let o = opStack.last!
			result = o.result
			prevOp = o.operation
			// Type conversion
			if o.type.tag != type.tag {
				result = (result / o.type.years) * type.years
			}
		}
		// Reset history if last operation was =
		if prevOp == OperationType.enter && currOp != OperationType.convert {
			history = "History: "
		}
		// History
		if currOp == OperationType.convert {
			if opStack.count > 1 {
				history += " = "
			}
		} else {
			history += arg.noZeroString() + type.emoji + " " + op + " "
		}
		// Operation
		switch prevOp {
		case .add:
			result += arg
			
		case .subtract:
			result -= arg
			
		case .multiply:
			result *= arg
			
		case .divide:
			result /= arg
			
		case .enter, .convert, .none:
			break
		}
		var o = Op()
		o.argument = arg
		o.operation = currOp
		o.result = result
		o.type = type
		opStack.append(o)
		// Update history if operator was =
		if currOp == OperationType.enter || currOp == OperationType.convert {
			history += result.noZeroString() + type.emoji
		}
		return result
	}
	
	func evaluate(op: String, arg1: Double, arg2: Double) -> Double {
		let type = Type.typeFor(tag: 103)
    let op1 = op == "-" ? "−" : op == "/" ? "÷" : op == "*" ? "x" : op
		_ = evaluate(op: op1, arg: arg1, type: type)
		let res = evaluate(op: "=", arg: arg2, type: type)
		return res
	}
}
