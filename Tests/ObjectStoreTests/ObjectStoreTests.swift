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
    func testExample() {
        
        let folder = FileManager.default.locations.temporary.folder("store")
        let store = FileObjectStore(root: folder, encoder: JSONEncoder(), decoder: JSONDecoder())
        store.save([Test(name: "test")], withIds: ["test"])
        
        let decoded = store.load(Test.self, withIds: ["test"])!.first!
        XCTAssertEqual(decoded.name, "test")
    }
}
