//
//  KeychainService.swift
//  Now Dribble
//
//  Created by Isaiah Harville on 3/16/24.
//

import Foundation
import Security

class KeychainHelper {
    static let standard = KeychainHelper()

    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary

        // First delete any existing item
        SecItemDelete(query)

        // Add the new keychain item
        let statusAdd = SecItemAdd(query, nil)
        guard statusAdd == errSecSuccess else { print("Error saving to Keychain: \(statusAdd)"); return }
        print("Successfully saved data to Keychain")
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        guard status == errSecSuccess else { print("Error reading from Keychain: \(status)"); return nil }

        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Error deleting keychain item: \(status)")
        } else {
            print("Keychain item deleted successfully")
        }
    }
}
