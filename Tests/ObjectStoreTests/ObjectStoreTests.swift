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
        waitForAsync { done in
            store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"]) { errors in
                XCTAssertEmpty(errors)
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
        waitForAsync { done in
            store.save(Test(name: "obj1"), withId: "id1") { result in
                XCTAssertSuccess(result)

                store.load(Test.self, withId: "id1") { result in
                    XCTAssertSuccess(result) { XCTAssertEqual($0.name, "obj1") }
                    done()
                }
            }
        }
    }

    func testMissingMultiple() {
        waitForAsync { done in
            store.load(Test.self, withIds: ["missing1", "missing2"]) { decoded, errors in
                XCTAssertEmpty(decoded)
                XCTAssertEqual(errors.count, 2)
                done()
            }
        }
    }

    func testMissingSingle() {
        waitForAsync { done in
            store.load(Test.self, withId: "missing") { result in
                XCTAssertFailure(result)
                done()
            }
        }
    }

    func testMissingPartial() {
        waitForAsync { done in
            store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"]) { errors in
                XCTAssertEmpty(errors)

                store.load(Test.self, withIds: ["id1", "missing"]) { decoded, errors in
                    XCTAssertEqual(decoded.count, 1)
                    XCTAssertEqual(errors.count, 1)
                    done()
                }
            }
        }
    }
    
    func testReplacement() {
        waitForAsync { done in
            store.save(Test(name: "obj1"), withId: "id1") { result in
                XCTAssertSuccess(result)

                store.load(Test.self, withId: "id1") { result in
                    XCTAssertSuccess(result) { XCTAssertEqual($0.name, "obj1") }
                    done()
                }
            }
        }

        waitForAsync { done in
            store.save(Test(name: "obj2"), withId: "id1") { errors in
                store.load(Test.self, withId: "id1") { result in
                    XCTAssertSuccess(result) { XCTAssertEqual($0.name, "obj2") }
                }
                done()
            }
        }
    }

    func testRemovalMultiple() {
        waitForAsync { done in
            store.save([Test(name: "obj1"), Test(name: "obj2")], withIds: ["id1", "id2"]) { errors in
                XCTAssertEmpty(errors)

                store.load(Test.self, withIds: ["id1", "id2"]) { decoded, errors in
                    XCTAssertEqual(decoded.count, 2)
                    done()
                }
            }
        }

        waitForAsync { done in
            store.remove(objectsWithIds: ["id1", "id2"]) { errors in
                XCTAssertEmpty(errors)
                done()
            }
        }

        waitForAsync { done in
            store.load(Test.self, withIds: ["id1", "id2"]) { decoded, errors in
                XCTAssertEqual(errors.count, 2)
                done()
            }
        }
    }

    func testRemovalSingle() {
        waitForAsync { done in
            store.save(Test(name: "obj1"), withId: "id1") { result in
                XCTAssertSuccess(result)

                store.load(Test.self, withId: "id1") { result in
                    XCTAssertSuccess(result) { XCTAssertEqual($0.name, "obj1") }
                    done()
                }
            }
        }

        waitForAsync { done in
            store.remove(objectWithId: "id1") { result in
                switch result {
                    case .failure: XCTFail()
                    case .success: break
                }
                done()
            }
        }

        waitForAsync { done in
            store.load(Test.self, withId: "id1") { result in
                switch result {
                    case .failure(let error as NSError):
                        XCTAssertEqual(error.domain, NSCocoaErrorDomain)
                        XCTAssertEqual(error.code, NSFileNoSuchFileError)
                    case .success: XCTFail()
                }
                done()
            }
        }
    }

}

