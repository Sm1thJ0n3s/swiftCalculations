//
//  ContentView.swift
//  calculator
//
//  Created by StudentAM on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var numsAndOperations: [[String]] = [
            ["AC","+/-", "%", "÷"],
            ["7","8", "9", "x"],
            ["4","5", "6", "-"],
            ["1","2", "3", "+"],
            ["0", "." , "="]
        ]
    @State var text: String = ""
    @State private var operation: String = ""
    @State private var firstNum: String = ""
    var body: some View {
        VStack {
            Color.black.ignoresSafeArea()
            // Displays what ever the user has inputted (the number they have pressed and the operator
            Text("\(firstNum) \(operation)")
                .frame(maxWidth: 500, maxHeight: 50, alignment: .trailing)
                .foregroundColor(.gray)
                .font(.system(size: 25))
                .padding(.bottom, 1)
            // Displays what the user is currently working on
            Text("\(text)")
                .frame(maxWidth: 500, maxHeight: 50, alignment: .trailing)
                .foregroundColor(.white)
                .font(.system(size: 55))
                .padding(.bottom, 30)
            ForEach(numsAndOperations, id:\.self) { row in
                HStack {
                    ForEach (row, id:\.self) {text in
                        if text == "÷" || text == "x" || text == "-" || text == "+" || text == "="{
                            Button("\(text)", action:{
                                if text == "="{
                                    equals()
                                } else {
                                    buttonInputs(char: text)
                                }
                            })
                                .frame(width:37, height: 37)
                                .padding()
                                .background(text == operation ? .white : .orange)
                                .foregroundColor(text == operation ? .black : .white)
                                .font(.system(size: 35))
                                .clipShape(Circle())
                        } else if text == "AC" || text == "C" || text == "+/-" || text == "%" {
                            Button("\(text)", action:{
                                if text == "AC" || text == "C" {
                                    clear()
                                } else if text == "+/-" {
                                    opposites()
                                } else if text == "%" {
                                    percentage()
                                } else {
                                    buttonInputs(char:text)
                                }
                            })
                                .frame(width:37, height: 37)
                                .padding()
                                .background(Color(UIColor.lightGray))
                                .foregroundColor(.black)
                                .font(.system(size: 27))
                                .clipShape(Circle())
                        } else if text == "."{
                            Button("\(text)", action:{buttonInputs(char:text)})
                                .frame(width:37, height: 37)
                                .padding()
                                .background(Color(UIColor.darkGray))
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .clipShape(Circle())
                        } else if text == "0" {
                            Button("\(text)", action:{buttonInputs(char:text)})
                                .frame(width:113, height: 37)
                                .padding()
                                .background(Color(UIColor.darkGray))
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .cornerRadius(50)
                        } else {
                            Button("\(text)", action:{buttonInputs(char:text)})
                                .frame(width:37, height: 37)
                                .padding()
                                .background(Color(UIColor.darkGray))
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .background(Color.black)
    }
    // Depending on what button the user presses, it will be added to the text unless it is an operator. There are other functions below that works different from pressing on the numbers and the decimal point. The limit of characters is 9
    func buttonInputs (char: String) {
            if char == "÷" {
                operation = "÷"
                firstNum = text
                text = ""
            } else if char == "x"{
                operation = "x"
                firstNum = text
                text = ""
            } else if char == "+"{
                operation = "+"
                firstNum = text
                text = ""
            } else if char == "-"{
                operation = "-"
                firstNum = text
                text = ""
            } else {
                if text.count < 8 {
                    text += char
                    numsAndOperations[0][0] = "C"
                }
            }
        
    }
    // Clears everything in the text, firstNum and the operation.
    func clear () {
        text = ""
        firstNum = ""
        operation = ""
        numsAndOperations[0][0] = "AC"
    }
    // Do not use this with decimals. I tried to fix the crashing but failed when I pressed the +/- button. This turns the number the user types in to the opposite of what the number is (e.g. -100 becomes 100 and 67 becomes -67)
    func opposites () {
        var decimal: Bool = false
        for char in text {
            if char == "." {
                decimal = true
            }
        }
        if decimal == true {
            let numHolder: Double = Double(text)! * -1
            text = String(numHolder)
        } else {
            let numHolder: Int = Int(text)! * -1
            text = String(numHolder)
        }
    }
    // When users presses the equal sign, depending on the operator will call a function corresponding with the operation. This calls adding, subtracting, multiplying, and dividing functions.
    func equals () {
        if operation == "÷" {
            dividing(left: firstNum, right: text)
        } else if operation == "x" {
            multiplying(left: firstNum, right: text)
        } else if operation == "+" {
            adding(left: firstNum, right: text)
        } else if operation == "-" {
            subtracting(left: firstNum, right: text)
        }
        firstNum = ""
        operation = ""
    }
    // Multiples numbers from -.01 (divides by 100).
    func percentage () {
        var decimal: Bool = false
        for char in text {
            if char == "." {
                decimal = true
            }
        }
        if decimal == true {
            var textMath: Double = Double(text) ?? 0.0
            textMath = textMath * 100
            text = String(textMath)
        } else {
            var textMath: Double = Double(text) ?? 0.0
            textMath = textMath * 0.01
            text = String(textMath)
        }
    }
    // When dividing, this function is called
    func dividing (left: String, right: String){
        if right == "0" {
            text = "Error"
        }
        else{
            let leftSide: Double = Double(left) ?? 0.0
            let rightSide: Double = Double(right) ?? 0.0
            let sum: Double = leftSide / rightSide
            text = String(sum)
        }
    }
    // When multiplying, this function is called
    func multiplying (left: String, right: String) {
        var decimal: Bool = false
        for char in left + right {
            if char == "." {
                decimal = true
            }
        }
        if decimal == true {
            let leftSide: Double = Double(left) ?? 0.0
            let rightSide: Double = Double(right) ?? 0.0
            let sum: Double = Double(leftSide) * Double(rightSide)
            text = String(sum)
        } else {
            let leftSide: Int = Int(left) ?? 0
            let rightSide: Int = Int(right) ?? 0
            let sum: Int = leftSide * rightSide
            text = String(sum)
        }
    }
    // When adding, this function is called
    func adding (left: String, right: String) {
        var decimal: Bool = false
        for char in left + right {
            if char == "." {
                decimal = true
            }
        }
        if decimal == true {
            let leftSide: Double = Double(left) ?? 0.0
            let rightSide: Double = Double(right) ?? 0.0
            let sum: Double = leftSide + rightSide
            text = String(sum)
        } else {
            let leftSide: Int = Int(left) ?? 0
            let rightSide: Int = Int(right) ?? 0
            let sum: Int = leftSide + rightSide
            text = String(sum)
        }
    }
    // When subtracting, this function is called
    func subtracting (left: String, right: String) {
        var decimal: Bool = false
        for char in left + right {
            if char == "." {
                decimal = true
            }
        }
        if decimal == true {
            let leftSide: Double = Double(left) ?? 0.0
            let rightSide: Double = Double(right) ?? 0.0
            let sum: Double = leftSide - rightSide
            text = String(sum)
        } else {
            let leftSide: Int = Int(left) ?? 0
            let rightSide: Int = Int(right) ?? 0
            let sum: Int = leftSide - rightSide
            text = String(sum)
        }
    }
}

#Preview {
    ContentView()
}
