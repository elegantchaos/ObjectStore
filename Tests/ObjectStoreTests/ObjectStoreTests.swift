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

extension XCTestCase {
    typealias Action = (() -> ()) -> ()
    
    func testAsync(timeout: TimeInterval = 1.0, _ action: Action) {
        let expectation = XCTestExpectation()
        action({ expectation.fulfill() })
        wait(for: [expectation], timeout: timeout)
    }
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
        testAsync { done in
            store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"]) { errors in
                XCTAssertEqual(errors.count, 0)
                store.load(Test.self, withIds: ["id1", "id2"]) { decoded, errors in
                    XCTAssertEqual(decoded.count, 2)
                    XCTAssertEqual(decoded[0].name, "obj1")
                    XCTAssertEqual(decoded[1].name, "obj2")
                    done()
                }
            }
        }
    }

    func testSingle() {
        testAsync { done in
            store.save(Test(name: "obj1"), withId: "id1") { errors in
                XCTAssertEqual(errors.count, 0)

                store.load(Test.self, withId: "id1") { result in
                    switch result {
                        case .failure(let error): XCTFail("\(error)")
                        case .success(let decoded): XCTAssertEqual(decoded.name, "obj1")
                    }
                    done()
                }
            }
        }
    }

    func testMissingMultiple() {
        testAsync { done in
            store.load(Test.self, withIds: ["missing1", "missing2"]) { decoded, errors in
                XCTAssertEqual(decoded.count, 0)
                XCTAssertEqual(errors.count, 2)
                done()
            }
        }
    }

    func testMissingSingle() {
        testAsync { done in
            store.load(Test.self, withId: "missing") { result in
                switch result {
                    case .success: XCTFail("shouldn't have succeeded")
                    case .failure: break
                }
                done()
            }
        }
    }

    func testMissingPartial() {
        testAsync { done in
            store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"]) { errors in
                XCTAssertEqual(errors.count, 0)

                store.load(Test.self, withIds: ["id1", "missing"]) { decoded, errors in
                    XCTAssertEqual(decoded.count, 1)
                    XCTAssertEqual(errors.count, 1)
                    done()
                }
            }
        }
    }
    
    func testReplacement() {
        testAsync { done in
            store.save(Test(name: "obj1"), withId: "id1") { errors in
                XCTAssertEqual(errors.count, 0)

                store.load(Test.self, withId: "id1") { result in
                    switch result {
                        case .failure: XCTFail()
                        case .success(let decoded): XCTAssertEqual(decoded.name, "obj1")
                    }
                    done()
                }
            }
        }

        testAsync { done in
            store.save(Test(name: "obj2"), withId: "id1") { errors in
                store.load(Test.self, withId: "id1") { result in
                    switch result {
                        case .failure: XCTFail()
                        case .success(let decoded): XCTAssertEqual(decoded.name, "obj2")
                    }
                }
                done()
            }
        }
    }
}

