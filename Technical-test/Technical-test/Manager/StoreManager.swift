//
//  StoreManager.swift
//  Technical-test
//
//  Created by Maksym Leshchenko on 19.04.2023.
//

import Foundation

protocol StoreManageProtocol {
    func updateFavorite(_ object: Quote)
    func getFavorites() -> [Quote]
}

struct UserDefaultsStoreManager: StoreManageProtocol {
    
    enum Keys: String {
        case quote
    }
    
    private let userDefaults = UserDefaults.standard
    
    func updateFavorite(_ object: Quote) {
        var quotes = Set(getFavorites())
        
        if quotes.contains(object) {
            quotes.remove(object)
        } else {
            quotes.insert(object)
        }
        
        saveFavorites(Array(quotes))
    }
    
    private func saveFavorites(_ objects: [Quote]) {
        do {
            let data = try JSONEncoder().encode(objects)
            userDefaults.set(data, forKey: Keys.quote.rawValue)
        } catch {
            print("Error encoding objects: \(error.localizedDescription)")
        }
    }
    
    func getFavorites() -> [Quote] {
        guard let data = userDefaults.data(forKey: Keys.quote.rawValue) else {
            return []
        }
        
        do {
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            return quotes
        } catch {
            print("Error decoding object: \(error.localizedDescription)")
            return []
        }
    }
}


