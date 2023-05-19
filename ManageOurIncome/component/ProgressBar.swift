//
//  ProgressBar.swift
//  ManageOurIncome
//
//  Created by Irfan Dary Sujatmiko on 14/05/23.
//

import Foundation
import SwiftUI
struct ProgressBar: View {
    private let value: Double
    private let maxValue: Double
    private let backgroundEnabled: Bool
    private let backgroundColor: Color
    private let foregroundColor: Color
    
    init(value: Double,
         maxValue: Double,
         backgroundEnabled: Bool = true,
         backgroundColor: Color = Color(UIColor(red: 245/255,
                                                green: 245/255,
                                                blue: 245/255,
                                                alpha: 1.0)),
         foregroundColor: Color = Color.black) {
        self.value = value
        self.maxValue = maxValue
        self.backgroundEnabled = backgroundEnabled
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    var body: some View {
        // 1
        ZStack {
            GeometryReader { geometryReader in
 
                if self.backgroundEnabled {
                    Capsule()
                        .foregroundColor(self.backgroundColor) // 4
                }
                    
                Capsule()
                    .frame(width: self.progress(value: self.value,
                                                maxValue: self.maxValue,
                                                width: geometryReader.size.width))
                    .foregroundColor(self.foregroundColor)
                    .animation(.easeIn)
            }
        }
    }
    private func progress(value: Double,
                          maxValue: Double,
                          width: CGFloat) -> CGFloat {
        let percentage = value / maxValue
        return width *  CGFloat(percentage)
    }
}
struct ProgressConfig {
    static func backgroundColor() -> Color {
        return Color(UIColor(red: 245/255,
                             green: 245/255,
                             blue: 245/255,
                             alpha: 1.0))
    }
    
    static func foregroundColor() -> Color {
        return Color.black
    }
}
