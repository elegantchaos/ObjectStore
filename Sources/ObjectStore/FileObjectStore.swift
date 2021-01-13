// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import Foundation

public struct FileObjectStore<CoderType>: ObjectStore where CoderType: ObjectCoder {
    let root: Folder
    let coder: CoderType

    public init(root: Folder, coder: CoderType) {
        self.root = root
        self.coder = coder
        
        try? root.create()
    }
    
    func file(forId id: String) -> File {
        return root.file(id)
    }
    
    public func load<T>(_ type: T.Type, withIds ids: [String]) -> [T]? where T: Decodable {
        var loaded: [T] = []
        for id in ids {
            if let data = file(forId: id).asData {
                do {
                    let decoded = try coder.decodeObject(type, from: data)
                    loaded.append(decoded)
                } catch {
                    print(error)
                }
            }
        }
        
        return loaded
    }
    
    public func save<T>(_ objects: [T], withIds ids: [String]) where T : Encodable {
        assert(objects.count == ids.count)
        for (object, id) in zip(objects, ids) {
            do {
                let data = try coder.encodeObject(object)
                file(forId: id).write(asData: data)
            } catch {
                print(error)
            }
        }
    }
    
}
