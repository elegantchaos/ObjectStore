// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

protocol ObjectStore {
    func save<T>(_ objects: [T], withIds ids: [String]) where T: Encodable
    func load<T>(_ type: T.Type, withIds ids: [String]) -> [T]? where T: Decodable
}

extension ObjectStore {
    func save<T>(_ object: T, withId id: String) where T: Encodable {
        save([object], withIds: [id])
    }
    
    func load<T>(_ type: T.Type, withId id: String) -> T? where T: Decodable {
        guard let objects = load(type, withIds: [id]) else { return nil }
        return objects.first
    }
}
