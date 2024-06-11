//
//  ApplePayManager.swift
//
//  Created by Mikhail Belikov on 04.04.2024.
//

import Foundation
import PassKit
import UIKit
import AirbaPay

final class ApplePayManagerLocal: NSObject {

    var isSuccess: Bool = false
    var redirect3dsUrl: String? = nil
    var applePayToken: String? = nil
    
    var airbaPaySdk: AirbaPaySdk? = nil

    func buyBtnTapped(airbaPaySdk: AirbaPaySdk) {
        self.airbaPaySdk = airbaPaySdk
        
        let paymentRequest: PKPaymentRequest = {
            let request: PKPaymentRequest = PKPaymentRequest()
            //label here can be passed in as a variable like we do itemCost and shippingCost.
            let summary = PKPaymentSummaryItem(label: "TestTest", amount: NSDecimalNumber(string: "1500.04"))

            //        shippingMethod.identifier = "ios App"
            request.merchantIdentifier = applePayMerchantId
            request.countryCode = "KZ"
            request.currencyCode = "KZT"
            request.merchantCapabilities = .capability3DS//PKMerchantCapability([.capability3DS, .capabilityCredit, .capabilityDebit, .capabilityEMV])
            request.paymentSummaryItems = [summary]
            request.shippingType = .servicePickup
            request.supportedCountries = ["KZ"]
            request.supportedNetworks = [.maestro, .masterCard, .quicPay, .visa, .vPay]

            return request
        }()
        
        guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest),
              let window = UIApplication.shared.connectedScenes
                                      .filter({$0.activationState == .foregroundActive})
                                      .map({$0 as? UIWindowScene})
                                      .compactMap({$0})
                                      .first?.windows
                          .filter({$0.isKeyWindow}).first
        else {
            return
            
        }
        paymentVC.delegate = self
        window.rootViewController?.present(paymentVC, animated: true, completion: nil)
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate
extension ApplePayManagerLocal: PKPaymentAuthorizationViewControllerDelegate {

    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)

        if isSuccess {

            let airbaPaySdk = testInitSdk(needDisableScreenShot: false)

            onStandardFlowPassword(
                airbaPaySdk: airbaPaySdk,
                autoCharge: 0,
                isLoading: { b in  },
                onSuccess: { token in
                    self.airbaPaySdk?.processExternalApplePay(applePayToken: self.applePayToken ?? "")

                },
                showError: {}
                
            )
        }
    }

    public func paymentAuthorizationViewController(
            _ controller: PKPaymentAuthorizationViewController,
            didAuthorizePayment payment: PKPayment,
            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        self.isSuccess = true
        self.applePayToken = String(data: payment.token.paymentData, encoding: .utf8)!
        completion(.init(status: .success, errors: nil))

    }
}

