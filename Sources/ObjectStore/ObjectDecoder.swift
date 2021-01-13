// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol ObjectDecoder {
    func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable
}

extension JSONDecoder: ObjectDecoder {
    func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        try decode(type, from: from)
    }
}
