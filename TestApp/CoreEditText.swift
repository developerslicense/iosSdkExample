//
// Created by Mikhail Belikov on 28.08.2023.
//

import Foundation
import SwiftUI

// https://suragch.medium.com/getting-and-setting-the-cursor-position-in-swift-68da99bcef39

class CoreEditTextViewModel: ObservableObject {
    @MainActor @Published var text: String = ""

    func changeText(text: String) {
        Task {
            await MainActor.run {
                self.text = text
            }
        }
    }
}

struct CoreEditText: View {

    @StateObject var viewModel: CoreEditTextViewModel

    var placeholder: String
    var keyboardType: UIKeyboardType

    var actionOnTextChanged: (String) -> Void
    var actionClickInfo: (() -> Void)? = nil
    var actionClickScanner: (() -> Void)? = nil

    @State private var textBeforeChange: String = ""
    @State private var cursorPositionForShow: Int = 5


    var body: some View {
        HStack {

            ZStack(alignment: .leading) {
                if viewModel.text.isEmpty {
                    Text(placeholder)
                            .frame(width: .infinity, alignment: .leading)
                            .foregroundColor( Color.black)
                }

            
                    if #available(iOS 16.0, *) {
                        let textField = TextField("", text: $viewModel.text, axis: .vertical)
                        
                        
                        textField
                            .onChange(
                                of: viewModel.text,
                                perform: { newValue in
                                    onPerformed(newValue: newValue)
                                }
                            )
                            .keyboardType(keyboardType)
                            .disableAutocorrection(true)
                            .foregroundColor( Color.black)
                            .frame(minHeight: 18)
                            .lineLimit(10)
                            .accentColor(Color.blue)
                        
                    } else {
                        let textField = TextField("", text: $viewModel.text)
                        
                        
                        textField
                            .onChange(
                                of: viewModel.text,
                                perform: { newValue in
                                    onPerformed(newValue: newValue)
                                }
                            )
                            .keyboardType(keyboardType)
                            .disableAutocorrection(true)
                            .foregroundColor( Color.black)
                            .frame(minHeight: 18)
                            .lineLimit(10)
                            .accentColor(Color.blue)
                    }
                    
            }
                    .frame(minHeight: 24)

        }
                .padding(.horizontal, 10)
                .padding(.vertical, 14)
                .background(Color.white)
                .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                )
    }

    private func onPerformed(newValue: String) {
        
        viewModel.text = newValue
        

        textBeforeChange = viewModel.text
        actionOnTextChanged(viewModel.text)
    }
}

