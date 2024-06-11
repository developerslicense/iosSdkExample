//
//  SwitchedView.swift
//  TestApp
//
//  Created by Mikhail Belikov on 30.05.2024.
//


import Foundation
import SwiftUI

struct SwitchedView: View {
    var text: String
    @State var switchCheckedState = false
    var actionOnChanged: (Bool) -> Void

    var body: some View {

        if #available(iOS 16.0, *) {
            Toggle(text, isOn: $switchCheckedState)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .tint(Color.blue)
                    .foregroundColor(.black)
                    .onChange(of: switchCheckedState) { value in
                        actionOnChanged(value)
                    }

        } else {
            Toggle(text, isOn: $switchCheckedState)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .foregroundColor(.black)
                    .onChange(of: switchCheckedState) { value in
                        actionOnChanged(value)
                    }
        }
    }
}
