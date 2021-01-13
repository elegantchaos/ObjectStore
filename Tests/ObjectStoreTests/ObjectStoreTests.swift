// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 13/01/2021.
//  All code (c) 2021 - present day, Elegant Chaos.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Files
import XCTest
import XCTestExtensions

@testable import ObjectStore

struct Test: Codable {
    let name: String
}

final class ObjectStoreTests: XCTestCase {
    typealias FileStore = FileObjectStore<JSONObjectCoder>
    
    var store: FileStore!
    
    override func setUp() {
        let folder = FileManager.default.locations.temporary.folder("store")
        store = FileObjectStore(root: folder, coder: JSONObjectCoder())
    }

    override func tearDown() {
        try? store.root.delete()
    }

    func testMultiple() {
        store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"])
        
        let decoded = store.load(Test.self, withIds: ["id1", "id2"])!
        XCTAssertEqual(decoded.count, 2)
        XCTAssertEqual(decoded[0].name, "obj1")
        XCTAssertEqual(decoded[1].name, "obj2")
    }

    func testSingle() {
        store.save(Test(name: "obj1"), withId: "id1")
        
        let decoded = store.load(Test.self, withId: "id1")!
        XCTAssertEqual(decoded.name, "obj1")
    }

    func testMissingMultiple() {
        let decoded = store.load(Test.self, withIds: ["missing"])
        XCTAssertEqual(decoded?.count, 0)
    }

    func testMissingPartial() {
        let decoded = store.load(Test.self, withIds: ["missing"])
        XCTAssertEqual(decoded?.count, 0)
    }

    func testMissing() {
        store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"])

        let decoded = store.load(Test.self, withIds: ["id1", "missing"])
        XCTAssertEqual(decoded?.count, 1)
    }
    
    func testReplacement() {
        store.save(Test(name: "obj1"), withId: "id1")
        
        let decoded = store.load(Test.self, withId: "id1")!
        XCTAssertEqual(decoded.name, "obj1")

        store.save(Test(name: "obj2"), withId: "id1")
        
        let decodedAgain = store.load(Test.self, withId: "id1")!
        XCTAssertEqual(decodedAgain.name, "obj2")

    }
}

