import XCTest
@testable import WaxSealLog

@MainActor
final class WaxSealLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.items = []
        store.save()
    }

    func testSeedDataHasNoItemsAfterClear() {
        XCTAssertEqual(store.items.count, 0)
    }

    func testAddItemIncreasesCount() {
        let item = Seal(title: "Test Item")
        _ = store.add(item, isPro: false)
        XCTAssertEqual(store.items.count, 1)
    }

    func testAddRespectsFreeLimit() {
        for i in 0..<Store.freeLimit {
            _ = store.add(Seal(title: "Item \(i)"), isPro: false)
        }
        let added = store.add(Seal(title: "Overflow"), isPro: false)
        XCTAssertFalse(added)
        XCTAssertEqual(store.items.count, Store.freeLimit)
    }

    func testProBypassesFreeLimit() {
        for i in 0..<Store.freeLimit {
            _ = store.add(Seal(title: "Item \(i)"), isPro: true)
        }
        let added = store.add(Seal(title: "Extra"), isPro: true)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, Store.freeLimit + 1)
    }

    func testDeleteByIdRemovesItem() {
        let item = Seal(title: "Delete Me")
        _ = store.add(item, isPro: false)
        store.delete(id: item.id)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testUpdateChangesTitle() {
        var item = Seal(title: "Original")
        _ = store.add(item, isPro: false)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first?.title, "Updated")
    }

    func testCanAddMoreWhenUnderLimit() {
        XCTAssertTrue(store.canAddMore(isPro: false))
    }

    func testPersistenceRoundTrip() {
        let item = Seal(title: "Persisted")
        _ = store.add(item, isPro: false)
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.title == "Persisted" }))
    }
}
