// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import XCTest
import XCTestExtensions

@testable import ObjectStore

final class ObjectStoreIdentifiableTests: XCTestCase {
    struct Test: Codable, Identifiable {
        let id: String
        let name: String
    }

    typealias FileStore = FileObjectStore<JSONEncoder, JSONDecoder>
    
    var store: FileStore!
    
    override func setUp() {
        let folder = FileManager.default.locations.temporary.folder("store")
        store = FileObjectStore(root: folder, encoder: JSONEncoder(), decoder: JSONDecoder())
    }

    override func tearDown() {
        try? store.root.delete()
    }

    func testMultiple() {
        store.save([Test(id: "id1", name: "obj1"), Test(id: "id2", name: "obj2")])
        
        let decoded = store.load(Test.self, withIds: ["id1", "id2"])!
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded[0].id, "id1")
        XCTAssertEqual(decoded[0].name, "obj1")
        XCTAssertEqual(decoded[1].id, "id2")
        XCTAssertEqual(decoded[1].name, "obj2")
    }

    func testSingle() {
        store.save(Test(id: "id1", name: "obj1"))
        
        let decoded = store.load(Test.self, withId: "id1")!
        XCTAssertEqual(decoded.id, "id1")
        XCTAssertEqual(decoded.name, "obj1")
    }

}
