//
//
//
//


import SwiftUI
import StoreKit


class SubscriptionManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    @Published var purchaseStatus: String = ""

    private var productsRequest: SKProductsRequest?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    func fetchProducts() {
        let productIdentifiers = Set(["Tier1_Beginning", "Tier2_Intermediate", "Tier3_Advanced", "Tier4_Elite"])
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products.sorted(by: { $0.price.compare($1.price) == .orderedAscending })
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products: \(error.localizedDescription)")
    }

    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseStatus = "Purchase successful!"
                    self.sendReceiptToBackend()
                }
            case .failed:
                if let error = transaction.error as? SKError {
                    print("Transaction Failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.purchaseStatus = "Purchase failed: \(error.localizedDescription)"
                    }
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }

    func refreshPurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        self.sendReceiptToBackend()
    }

    private func sendReceiptToBackend() {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            print("Failed to get receipt data")
            return
        }
        let receiptString = receiptData.base64EncodedString(options: [])
        
        guard let tokenData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "userToken"),
              let token = String(data: tokenData, encoding: .utf8) else {
            print("Authentication error: Unable to retrieve token.")
            return
        }
        
        #if DEBUG
        print("\n--BEGIN RECEIPT STRING--")
        // print(receiptString)
        print("---END RECEIPT STRING--\n")
        #endif
        
        var request = URLRequest(url: URL(string: "\(IP_ADDRESS)/Authentication/validateReceipt")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let json: [String: Any] = ["receipt_data": receiptString]

        request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let _ = data, error == nil else {
                    print("Failed to send receipt data: \(error?.localizedDescription ?? "No data")")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Receipt validation successful")
                    // Save the receipt to Keychain after successful validation
                    self.saveReceiptToKeychain(receipt: receiptString)
                } else {
                    print("Receipt validation failed")
                }
            }
        }
        task.resume()
    }

    func getReceiptFromKeychain() -> String? {
        guard let receiptData = KeychainHelper.standard.read(service: "com.phneelgroup.Now-Dribble", account: "receipt") else {
            return nil
        }
        return String(data: receiptData, encoding: .utf8)
    }

    private func saveReceiptToKeychain(receipt: String) {
        if let receiptData = receipt.data(using: .utf8) {
            KeychainHelper.standard.save(receiptData, service: "com.phneelgroup.Now-Dribble", account: "receipt")
        }
    }

    func getReceipt() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            print("Failed to get receipt data")
            return nil
        }
        return receiptData.base64EncodedString(options: [])
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? "\(self.price)"
    }
}

struct SubscriptionsView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager // to access the shared subscription manager

    var body: some View {
        VStack {
            Text("Subscribe")
                .font(.title)
                .padding()

            // List all products in rows
            List(subscriptionManager.products, id: \.productIdentifier) { product in
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.localizedTitle)
                            .font(.headline)
                        Text(product.localizedDescription)
                            .font(.subheadline)
                    }

                    Spacer()
                    Button(action: {
                        subscriptionManager.buyProduct(product)
                    }) {
                        Text(product.localizedPrice)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.vertical)
            }

            if subscriptionManager.products.isEmpty {
                Text("Loading products...")
            }

            Text("Each subscription grants access to increasingly more workouts and renews monthly.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()

            #if DEBUG
            Text(subscriptionManager.purchaseStatus)
                .foregroundColor(.red)
                .padding()
            #endif
        }
        .onAppear {
            subscriptionManager.fetchProducts()
        }
    }
}
