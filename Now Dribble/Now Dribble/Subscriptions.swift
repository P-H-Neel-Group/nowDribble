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
        let productIdentifiers = Set(["Tier1_Beginning"])
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
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
                    // Handle the successful transaction here.
                    SKPaymentQueue.default().finishTransaction(transaction)
                case .failed:
                    // Handle the failed transaction here.
                    if let error = transaction.error as? SKError {
                        print("Transaction Failed: \(error.localizedDescription)")
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                default:
                    break
            }
        }
    }
}

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // Setting the locale to U.S.
        return formatter.string(from: price) ?? "$\(price)"
    }
}

struct SubscriptionsView: View {
    @ObservedObject private var subscriptionManager = SubscriptionManager()

    var body: some View {
        VStack {
            Text("Welcome to Subscriptions!")
                .font(.title)
                .padding()

            if let product = subscriptionManager.products.first {
                Button(action: {
                    subscriptionManager.buyProduct(product)
                }) {
                    Text("Subscribe for \(product.localizedPrice)")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                Text("Loading products...")
            }
            
            Text(subscriptionManager.purchaseStatus)
                .foregroundColor(.red)
                .padding()
        }
        .onAppear {
            subscriptionManager.fetchProducts()
        }
    }
}
