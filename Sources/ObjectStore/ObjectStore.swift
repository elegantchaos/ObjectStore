// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

public protocol ObjectStore {
    typealias SaveCompletion = ([String:Error]) -> ()
    func save<T>(_ objects: [T], withIds ids: [String], completion: SaveCompletion) where T: Encodable
    func load<T>(_ type: T.Type, withIds ids: [String]) -> [T]? where T: Decodable
}

public extension ObjectStore {
    func save<T>(_ object: T, withId id: String, completion: SaveCompletion) where T: Encodable {
        save([object], withIds: [id], completion: completion)
    }
    
    func load<T>(_ type: T.Type, withId id: String) -> T? where T: Decodable {
        guard let objects = load(type, withIds: [id]) else { return nil }
        return objects.first
    }
}

@available(macOS 10.15, *) public extension ObjectStore {
    func save<T>(_ objects: [T], completion: SaveCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        save(objects, withIds: objects.map({ $0.id }), completion: completion)
    }

    func save<T>(_ object: T, completion: SaveCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        save([object], withIds: [object.id], completion: completion)
    }

}
