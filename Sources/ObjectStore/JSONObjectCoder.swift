// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct JSONObjectCoder: ObjectCoder {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    public init() {
    }
    
    public func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        try decoder.decode(type, from: from)
    }
    
    public func encodeObject<T>(_ object: T) throws -> Data where T : Encodable {
        let data = try encoder.encode(object)
        return data
    }
}
