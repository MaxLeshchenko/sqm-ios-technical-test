//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

struct Quote: Codable, Hashable {
    
    private enum CodingKeys: String, CodingKey {
        case symbol, name, currency, readableLastChangePercent, last, lastChangePercent, variationColor, myMarket
    }
    
    var symbol: String?
    var name: String?
    var currency: String?
    var readableLastChangePercent: String?
    var last: String?
    var lastChangePercent: String?
    var variationColor: String?
    var myMarket: Market?
    
    var isFavorite: Bool = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        currency = try container.decodeIfPresent(String.self, forKey: .currency)
        readableLastChangePercent = try container.decodeIfPresent(String.self, forKey: .readableLastChangePercent)
        last = try container.decodeIfPresent(String.self, forKey: .last)
        lastChangePercent = try container.decodeIfPresent(String.self, forKey: .lastChangePercent)
        variationColor = try container.decodeIfPresent(String.self, forKey: .variationColor)
        myMarket = try container.decodeIfPresent(Market.self, forKey: .myMarket)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(symbol, forKey: .symbol)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(currency, forKey: .currency)
        try container.encodeIfPresent(readableLastChangePercent, forKey: .readableLastChangePercent)
        try container.encodeIfPresent(last, forKey: .last)
        try container.encodeIfPresent(lastChangePercent, forKey: .lastChangePercent)
        try container.encodeIfPresent(variationColor, forKey: .variationColor)
        try container.encodeIfPresent(myMarket, forKey: .myMarket)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
    }
    
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        return lhs.symbol == rhs.symbol
    }
}
