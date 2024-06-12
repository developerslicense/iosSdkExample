
import Foundation
import SwiftUI
import PathPresenter
import AirbaPay
import SimpleToast

import UIKit
import WebKit

private let ACCOUNT_ID_TEST = "77002111112"

private let shopId = "" // todo заменить на логин в системе AirbaPay
private let password = "" // todo заменить на пароль в системе AirbaPay
private let terminalId = "" // todo заменить на terminalId в системе AirbaPay
let applePayMerchantId = "merchant.~" //todo заменить на свой мерчант айди. Для нативного надо выполнить настройки как описано в документации

struct TestSettings {
    static var isRenderSecurityCvv: Bool? = nil
    static var isRenderSecurityBiometry: Bool? = nil
    static var isRenderSavedCards: Bool? = nil
    static var isRenderApplePay: Bool? = nil
    static var isApplePayNative: Bool = true
    static var needDisableScreenShot: Bool = false
}

struct ExamplePage: View {

    
    @StateObject var editTextViewModel: CoreEditTextViewModel = CoreEditTextViewModel()

    @State var autoCharge: Bool = false
    
    @State var showDropdownRenderSecurityCvv: Bool = false
    @State var showDropdownRenderSecurityBiometry: Bool = false
    @State var showDropdownRenderSavedCards: Bool = false
    @State var showDropdownRenderGooglePay: Bool = false
    
    @State var renderSecurityCvv: Bool? = TestSettings.isRenderSecurityCvv
    @State var renderSecurityBiometry: Bool? = TestSettings.isRenderSecurityBiometry
    @State var renderSavedCards: Bool? = TestSettings.isRenderSavedCards
    @State var renderApplePay: Bool? = TestSettings.isRenderApplePay
    
    @State var featureCustomPages: Bool = false
    
    @State var nativeApplePay: Bool = TestSettings.isApplePayNative
    @State var needDisableScreenShot: Bool = TestSettings.needDisableScreenShot
    
    @State var isLoading: Bool = false
    
    @State var errorToast: Bool = false
    @State var errorJwtToast: Bool = false
    
    private let toastOptions = SimpleToastOptions(
            alignment: .bottom,
            hideAfter: 5
    )

    var body: some View {

        ZStack {
            Color.white

            ScrollView {
                if shopId.isEmpty {
                    Text("Нужно заполнить shopId, terminalId, password")
                        .foregroundColor(.blue)
                } else {
                    VStack(alignment: .center) {
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        Task {
                                            airbaPaySdk.getCards(
                                                onSuccess: { cards in
                                                    var index = 0
                                                    
                                                    while index < cards.count {
                                                        airbaPaySdk.deleteCard(
                                                            cardId: cards[index].id ?? "",
                                                            onSuccess: {}, onError: {})
                                                        index = index + 1
                                                    }
                                                    
                                                    isLoading = false
                                                    
                                                },
                                                onNoCards: { isLoading = false }
                                            )
                                            
                                        }
                                    },
                                    showError: {
                                        withAnimation {
                                            errorToast.toggle()
                                        }
                                    }
                                    
                                )
                            },
                            label: {
                                Text("Удалить привязанные карты")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        
                        Text("Номера тестовых карт, которые можно использовать " +
                             "\n 4111 1111 1111 1616 cvv 333 " +
                             "\n 4111 1111 1111 1111 cvv 123 " +
                             "\n 3411 1111 1111 111 cvv 7777"
                        )
                        .padding(16)
                        .foregroundColor(.black)
                        
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                
                                let airbaPaySdk = testInitSdk(
                                    needDisableScreenShot: needDisableScreenShot,
                                    featureCustomPages: featureCustomPages
                                )
                                
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        airbaPaySdk.standardFlow(
                                            isApplePayNative: nativeApplePay,
                                            applePayMerchantId: applePayMerchantId,
                                            shopName: "Shop Name"
                                        )
                                    },
                                    showError: {
                                        withAnimation {
                                            errorToast.toggle()
                                        }
                                    }
                                    
                                )
                            },
                            label: {
                                Text("Стандартный флоу PASSWORD")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                
                                UIApplication.shared.endEditing()
                                let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        TestCoordinator().openPage(content: TestSwiftUiApplePayPage(airbaPaySdk: airbaPaySdk))
                                    },
                                    showError: {
                                        withAnimation {
                                            errorToast.toggle()
                                        }
                                    }
                                )
                            },
                            label: {
                                Text("Тест внешнего API ApplePay PASSWORD")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        TestCoordinator().openPage(content: TestCardsPagee(airbaPaySdk: airbaPaySdk))
                                    },
                                    showError: {
                                        withAnimation {
                                            errorToast.toggle()
                                        }
                                    }
                                )
                                
                                
                            },
                            label: {
                                Text("Тест внешнего API сохраненных карт PASSWORD")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        airbaPaySdk.standardFlowWebView(
                                            isLoadingComplete: { isLoading = false },
                                            shouldOverrideUrlLoading: { obj in
                                                if(obj.navAction.navigationType == .other) {
                                                    obj.decisionHandler(.allow)
                                                    return
                                                    
                                                } else {
                                                    
                                                    if obj.isCallbackSuccess {
                                                        TestCoordinator().openPage(content: ExamplePage())
                                                        
                                                    } else if obj.isCallbackBackToApp {
                                                        TestCoordinator().openPage(content: ExamplePage())
                                                        
                                                    } else {
                                                        obj.decisionHandler(.allow)
                                                        return
                                                    }
                                                    
                                                }
                                                
                                                obj.decisionHandler(.allow)
                                                
                                            },
                                            onError: { withAnimation { errorToast.toggle() }}
                                        )
                                    },
                                    showError: {
                                        isLoading = false
                                        withAnimation { errorToast.toggle() }
                                    }
                                )
                                
                                
                            },
                            label: {
                                Text("Стандартный флоу через вебвью")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        
                        Text(
                            "Все нижние варианты требуют предварительно сгенерировать " +
                            "или вставить JWT в поле ввода. "
                        )
                        .padding(.top, 30)
                        .padding(16)
                        .foregroundColor(.black)
                        
                        
                        ViewEditText(
                            viewModel: editTextViewModel,
                            placeholder: "JWT",
                            keyboardType: .default,
                            actionOnTextChanged: { text in
                                editTextViewModel.text = text
                            }
                        )
                        .padding(16)
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                isLoading = true
                                
                                let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                
                                onStandardFlowPassword(
                                    airbaPaySdk: airbaPaySdk,
                                    autoCharge: autoCharge ? 1 : 0,
                                    isLoading: { b in isLoading = b },
                                    onSuccess: { token in
                                        editTextViewModel.text = token
                                    },
                                    showError: {
                                        withAnimation {
                                            errorToast.toggle()
                                        }
                                    }
                                    
                                )
                                
                            },
                            label: {
                                Text("Сгенерировать JWT и вставить в поле ввода")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                if editTextViewModel.text.isEmpty {
                                    withAnimation {
                                        errorJwtToast.toggle()
                                    }
                                } else {
                                    isLoading = true
                                    
                                    let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                    
                                    airbaPaySdk.authJwt(
                                        jwt: editTextViewModel.text,
                                        onSuccess: {
                                            isLoading = false
                                            airbaPaySdk.standardFlow(
                                                isApplePayNative: nativeApplePay,
                                                applePayMerchantId: applePayMerchantId,
                                                shopName: "Shop Name"
                                            )
                                        },
                                        onError: {
                                            isLoading = false
                                            withAnimation {
                                                errorToast.toggle()
                                            }
                                        }
                                    )
                                }
                            },
                            label: {
                                Text("Стандартный флоу JWT")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                UIApplication.shared.endEditing()
                                if editTextViewModel.text.isEmpty {
                                    withAnimation {
                                        errorJwtToast.toggle()
                                    }
                                } else {
                                    isLoading = true
                                    
                                    let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                    
                                    airbaPaySdk.authJwt(
                                        jwt: editTextViewModel.text,
                                        onSuccess: {
                                            isLoading = false
                                            TestCoordinator().openPage(
                                                content: TestSwiftUiApplePayPage(airbaPaySdk: airbaPaySdk)
                                            )
                                        },
                                        onError: {
                                            isLoading = false
                                            withAnimation {
                                                errorToast.toggle()
                                            }
                                        }
                                    )
                                }
                            },
                            label: {
                                Text("Тест внешнего API ApplePay JWT")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Button(
                            action: {
                                if editTextViewModel.text.isEmpty {
                                    withAnimation {
                                        errorJwtToast.toggle()
                                    }
                                } else {
                                    isLoading = true
                                    
                                    let airbaPaySdk = testInitSdk(needDisableScreenShot: needDisableScreenShot)
                                    
                                    airbaPaySdk.authJwt(
                                        jwt: editTextViewModel.text,
                                        onSuccess: {
                                            isLoading = false
                                            TestCoordinator().openPage(
                                                content: TestCardsPagee(airbaPaySdk: airbaPaySdk)
                                            )
                                        },
                                        onError: {
                                            isLoading = false
                                            withAnimation {
                                                errorToast.toggle()
                                            }
                                        }
                                    )
                                }
                            },
                            label: {
                                Text("Тест внешнего API сохраненных карт JWT")
                                    .font(.system(size: 16))
                                    .padding(16)
                                
                            }
                        )
                        
                        Text("Настройки только для Стандартного флоу")
                            .padding(.top, 30)
                            .padding(16)
                            .foregroundColor(.black)
                        
                        DropdownList(
                            title1: "CVV - NULL",
                            title2: "CVV - FALSE",
                            title3: "CVV - TRUE",
                            showDropdown: showDropdownRenderSecurityCvv,
                            isRender: renderSecurityCvv,
                            onSelect: { b in
                                TestSettings.isRenderSecurityCvv = b
                            }
                        )
                        DropdownList(
                            title1: "Биометрия - NULL",
                            title2: "Биометрия - FALSE",
                            title3: "Биометрия - TRUE",
                            showDropdown: showDropdownRenderSecurityBiometry,
                            isRender: renderSecurityBiometry,
                            onSelect: { b in
                                TestSettings.isRenderSecurityBiometry = b
                            }
                        )
                        DropdownList(
                            title1: "Сохраненные карты - NULL",
                            title2: "Сохраненные карты - FALSE",
                            title3: "Сохраненные карты - TRUE",
                            showDropdown: showDropdownRenderSavedCards,
                            isRender: renderSavedCards,
                            onSelect: { b in
                                TestSettings.isRenderSavedCards = b
                            }
                        )
                        DropdownList(
                            title1: "ApplePay - NULL",
                            title2: "ApplePay - FALSE",
                            title3: "ApplePay - TRUE",
                            showDropdown: showDropdownRenderGooglePay,
                            isRender: renderApplePay,
                            onSelect: { b in
                                TestSettings.isRenderApplePay = b
                            }
                        )
                        
                        SwitchedView(
                            text: "AutoCharge 0 (off) / 1 (on)",
                            switchCheckedState: autoCharge,
                            actionOnChanged: { b in
                                autoCharge = b
                            }
                        )
                        .padding(8)
                        
                        
                        SwitchedView(
                            text: "Нативный ApplePay",
                            switchCheckedState: nativeApplePay,
                            actionOnChanged: { b in
                                nativeApplePay = b
                                TestSettings.isApplePayNative = b
                            }
                        )
                        .padding(8)
                        
                        
                        SwitchedView(
                            text: "Блокировать скриншот",
                            switchCheckedState: needDisableScreenShot,
                            actionOnChanged: { b in
                                needDisableScreenShot = b
                                TestSettings.needDisableScreenShot = needDisableScreenShot
                            }
                        )
                        .padding(8)
                    }
                }
            }
            .onTapGesture(perform: {
                UIApplication.shared.endEditing()
            })

            .simpleToast(isPresented: $errorToast, options: toastOptions) {
                Label("Что-то пошло не так", systemImage: "icAdd")
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
            }
            .simpleToast(isPresented: $errorJwtToast, options: toastOptions) {
                Label("Добавьте JWT в поле ввода", systemImage: "icAdd")
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
            }
            
            if isLoading {
                Color.white

                ProgressBarView()
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


func onStandardFlowPassword(
    airbaPaySdk: AirbaPaySdk,
    autoCharge: Int = 0,
    invoiceId: String = String(Int(Date().timeIntervalSince1970)),
    isLoading: @escaping (Bool) -> Void,
    onSuccess: @escaping (String) -> Void,
    showError: @escaping () -> Void
) {
    isLoading(true)
    airbaPaySdk.authPassword(
        terminalId: "65c5df69e8037f1b451a0594",
        shopId: "test-baykanat",
        password: "baykanat123!",
        onSuccess: { token in
            
            let someOrderNumber = Int(Date().timeIntervalSince1970)

            let goods = [
                AirbaPaySdk.Goods(
                        brand: "Чай Tess Banana Split черный 20 пирамидок",
                        category: "Tess",
                        model: "Черный чай",
                        quantity: 1,
                        price: 1000
                ),
                AirbaPaySdk.Goods(
                        brand: "Чай Tess Green",
                        category: "Tess",
                        model: "Green чай",
                        quantity: 1,
                        price: 500.04
                )
            ]

            let settlementPayment = [
                AirbaPaySdk.SettlementPayment(
                        amount: 1000,
                        companyId: "210840019439"
                ),
                AirbaPaySdk.SettlementPayment(
                        amount: 500.04,
                        companyId: "254353"
                )
            ]
            
            airbaPaySdk.createPayment(
                authToken: token,
                failureCallback: "https://site.kz/failure-clb",
                successCallback: "https://site.kz/success-clb",
                purchaseAmount: 1500.45,
                accountId: ACCOUNT_ID_TEST,
                invoiceId: invoiceId,
                orderNumber: String(someOrderNumber),
                onSuccess: { r in
                    isLoading(false)
                    onSuccess(r.token ?? "")
                },
                onError: {
                    isLoading(false)
                    showError()
                },
                renderSecurityCvv: TestSettings.isRenderSecurityCvv,
                renderSecurityBiometry: TestSettings.isRenderSecurityBiometry,
                renderApplePay: TestSettings.isRenderApplePay,
                renderSavedCards: TestSettings.isRenderSavedCards
//                goods = goods,
//                settlementPayments = settlementPayment
            )
        },
        onError: {
            isLoading(false)
            showError()
        }
    )
}

func testInitSdk(
        needDisableScreenShot: Bool = false,
        featureCustomPages: Bool = false
) -> AirbaPaySdk {


    let airbaPaySdk = AirbaPaySdk.initSdk(
            isProd: false,
            lang: AirbaPaySdk.Lang.RU(),
            phone: ACCOUNT_ID_TEST,
            userEmail: "test@test.com",
            enabledLogsForProd: false,
            needDisableScreenShot: needDisableScreenShot,
            actionOnCloseProcessing: { (b, navigation ) in
                
                TestCoordinator().openPage(content: ExamplePage())
            }

    )


    return airbaPaySdk
}


class TestCoordinator: UIViewController {
    
    private var navigation: UINavigationController? = nil
    func openPage(content: some View) {
        DispatchQueue.main.async {
            
            if self.navigation == nil {
                if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
                    
                    self.navigation = UINavigationController(rootViewController: self)
                    window.rootViewController = self.navigation
                }
            }
            
            let newVC = UIHostingController(rootView: content)
            
            self.navigationController?.setToolbarHidden(true, animated: false)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.toolbar?.isHidden = true
            self.navigationController?.popViewController(animated: false)
            self.navigationController?.pushViewController(newVC, animated: false)
        }
    }
}

struct DropdownList: View {
    var title1: String
    var title2: String
    var title3: String
    @State var showDropdown: Bool
    @State var isRender: Bool?
    var onSelect: (Bool?) -> Void

    var body: some View {
        ZStack {
            Color.white
         
            VStack {
                Button(
                    action: {
                        showDropdown = !showDropdown
                    },
                    label: {
                        Text(isRender == nil ? title1 : isRender == false ? title2 : title3)
                            .font(.system(size: 16))
                            .padding(16)
                        
                    }
                )
                .frame(width: .infinity)
                .padding(.vertical, 20)
                .padding(.horizontal, 50)
                
                if showDropdown {
                    Text(title1)
                        .frame(alignment: .center)
                        .padding(.top, 16)
                        .background(Color.green)
                        .onTapGesture {
                            showDropdown = false
                            isRender = nil
                            onSelect(nil)
                        }
                    
                    Text(title2)
                        .frame(alignment: .center)
                        .padding(.top, 16)
                        .background(Color.green)
                        .onTapGesture {
                            showDropdown = false
                            isRender = false
                            onSelect(false)
                        }
                    
                    Text(title3)
                        .frame(alignment: .center)
                        .padding(.top, 16)
                        .background(Color.green)
                        .onTapGesture {
                            showDropdown = false
                            isRender = true
                            onSelect(true)
                        }
                }
            }
        }
    }
}


