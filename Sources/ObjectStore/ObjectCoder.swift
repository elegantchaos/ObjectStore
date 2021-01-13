//
//  File.swift
//  
//
//  Created by Sam Developer on 13/01/2021.
//

import Foundation

public protocol ObjectCoder {
    func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable
    func encodeObject<T>(_ object: T) throws -> Data where T: Encodable
}
