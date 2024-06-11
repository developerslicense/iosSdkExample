//
// Created by Mikhail Belikov on 24.08.2023.
//

import Foundation
import SwiftUI

struct ViewEditText: View {
    @StateObject var viewModel: CoreEditTextViewModel

    var placeholder: String
    var keyboardType: UIKeyboardType = .decimalPad
    var actionOnTextChanged: (String) -> Void
    var actionClickInfo: (() -> Void)?
    var actionClickScanner: (() -> Void)? = nil

    var body: some View {

        VStack {

            CoreEditText(
                viewModel: viewModel,
                placeholder: placeholder,
                keyboardType: keyboardType,
                actionOnTextChanged: actionOnTextChanged,
                actionClickInfo: actionClickInfo,
                actionClickScanner: actionClickScanner
            )
           
        }
    }
}
