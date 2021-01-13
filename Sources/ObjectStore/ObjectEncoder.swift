// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol ObjectEncoder {
    func encodeObject<T>(_ object: T) throws -> Data where T: Encodable
}

extension JSONEncoder: ObjectEncoder {
    func encodeObject<T>(_ object: T) throws -> Data where T : Encodable {
        let data = try encode(object)
        return data
    }
}
