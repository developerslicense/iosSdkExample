//
//  TestSwiftUiPage.swift
//
//  Created by Mikhail Belikov on 28.02.2024.
//

import Foundation
import SwiftUI
import UIKit
import AirbaPay

struct TestSwiftUiApplePayPage: View {

    var airbaPaySdk: AirbaPaySdk
    var applePay: ApplePayManagerLocal = ApplePayManagerLocal()

    var body: some View {
        ZStack {
            Color.white
            VStack {


                VStack {
                    Text("Тест внешнего API ApplePay через передачу токена")
                }

                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            applePay.buyBtnTapped(airbaPaySdk: airbaPaySdk)
                        }

                VStack {
                    Text("Вернуться назад")
                }

                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            airbaPaySdk.backToApp()
                        }
            }
        }
    }
}


