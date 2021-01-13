// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import Foundation

struct FileObjectStore<E,D>: ObjectStore where E: ObjectEncoder, D: ObjectDecoder {
    let root: Folder
    let encoder: E
    let decoder: D

    init(root: Folder, encoder: E, decoder: D) {
        self.root = root
        self.encoder = encoder
        self.decoder = decoder
        
        try? root.create()
    }
    
    func file(forId id: String) -> File {
        return root.file(id)
    }
    
    func load<T>(_ type: T.Type, withIds ids: [String]) -> [T]? where T: Decodable {
        var loaded: [T] = []
        for id in ids {
            if let data = file(forId: id).asData {
                do {
                    let decoded = try decoder.decodeObject(type, from: data)
                    loaded.append(decoded)
                } catch {
                    print(error)
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
                file(forId: id).write(asData: data)
            } catch {
                print(error)
            }
        }
    }
    
}
