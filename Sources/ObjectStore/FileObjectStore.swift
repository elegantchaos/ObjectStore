// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import Foundation

protocol ObjectDecoder {
    func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T: Decodable
}

extension JSONDecoder: ObjectDecoder {
    func decodeObject<T>(_ type: T.Type, from: Data) throws -> T where T : Decodable {
        try decode(type, from: from)
    }
}

protocol ObjectEncoder {
    func encodeObject<T>(_ object: T) throws -> Data where T: Encodable
}


struct FileObjectStore<E,D>: ObjectStore where E: ObjectEncoder, D: ObjectDecoder {
    func load<T>(_ type: T.Type, withIds ids: [String]) -> [T]? where T: Decodable {
        var loaded: [T] = []
        for id in ids {
            if let data = root.file(id).asData {
                do {
                    let decoded = try decoder.decodeObject(type, from: data)
                    loaded.append(decoded)
                } catch {
                    
                }
            }
        }
        
        return loaded
    }
    
    func save<T>(_ objects: [T], withIds ids: [String]) where T : Encodable {
        assert(objects.count == ids.count)
        for (object, id) in zip(objects, ids) {
            do {
                let data = try encoder.encodeObject(object)
                let file = root.file(id)
                file.write(asData: data)
            } catch {
                
            }
        }
    }
    
    let root: Folder
    let encoder: E
    let decoder: D
}
