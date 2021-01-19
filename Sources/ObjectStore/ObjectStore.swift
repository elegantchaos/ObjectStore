// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

public protocol ObjectStore {
    typealias ErrorsCompletion = ([String:Error]) -> ()
    typealias ErrorCompletion = (Result<Void,Error>) -> ()
    
    func save<T>(_ objects: [T], withIds ids: [String], completion: ErrorsCompletion) where T: Encodable
    func load<T>(_ type: T.Type, withIds ids: [String], completion: ([T], [String:Error]) -> ()) where T: Decodable
    func remove(objectsWithIds ids: [String], completion: ErrorsCompletion)
}

// Convenience extensions which take a single object instead of a list.

public extension ObjectStore {
    func save<T>(_ object: T, withId id: String, completion: ErrorCompletion) where T: Encodable {
        save([object], withIds: [id]) { errors in
            if let error = errors.first {
                completion(.failure(error.value))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func load<T>(_ type: T.Type, withId id: String, completion: (Result<T,Error>) -> ()) where T: Decodable {
        load(type, withIds: [id]) { decoded, errors in
            if let decoded = decoded.first {
                completion(.success(decoded))
            } else {
                completion(.failure(errors[id]!))
            }
        }
    }
    
    func remove(objectWithId id: String, completion: ErrorCompletion) {
        remove(objectsWithIds: [id]) { errors in
            if let error = errors.first {
                completion(.failure(error.value))
            } else {
                completion(.success(()))
            }
        }
    }
}

// Convenience extensions which infer the identifier from the object (which must conform to Identifiable)
@available(macOS 10.15, *) public extension ObjectStore {
    func save<T>(_ objects: [T], completion: ErrorsCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        save(objects, withIds: objects.map({ $0.id }), completion: completion)
    }

    func save<T>(_ object: T, completion: ErrorsCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        save([object], withIds: [object.id], completion: completion)
    }

    func remove<T>(_ objects: [T], completion: ErrorsCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        remove(objectsWithIds: objects.map({ $0.id }), completion: completion)
    }

    func remove<T>(_ object: T, completion: ErrorCompletion) where T: Encodable, T: Identifiable, T.ID == String {
        remove(objectWithId: object.id, completion: completion)
    }

}
