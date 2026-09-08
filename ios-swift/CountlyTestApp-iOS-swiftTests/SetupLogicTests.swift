// SetupLogicTests.swift
//
// This code is provided under the MIT License.
//
// Please visit www.count.ly for more information.

import XCTest
@testable import CountlyTestApp_iOS_swift

final class SetupValuesTests: XCTestCase {

    func testRejectsEmptyServerURL() {
        let values = SetupValues(host: "   ", appKey: "abc")
        XCTAssertEqual(values.validationError, "Server URL is required.")
    }

    func testRejectsServerURLWithoutScheme() {
        let values = SetupValues(host: "example.count.ly", appKey: "abc")
        XCTAssertEqual(values.validationError,
                       "Server URL must start with http:// or https:// and include a host name.")
    }

    func testRejectsEmptyAppKey() {
        let values = SetupValues(host: "https://example.count.ly", appKey: " ")
        XCTAssertEqual(values.validationError, "App key is required.")
    }

    func testAcceptsValidValues() {
        let values = SetupValues(host: "https://example.count.ly", appKey: "abc")
        XCTAssertNil(values.validationError)
    }

    func testAcceptsPlainHTTPWithIPAddressAndPort() {
        let values = SetupValues(host: "http://192.168.1.10:3001/", appKey: "abc")
        XCTAssertNil(values.validationError)
        XCTAssertEqual(values.normalizedHost, "http://192.168.1.10:3001")
    }

    func testAcceptsLocalhostAndIPv6LiteralWithPort() {
        XCTAssertNil(SetupValues(host: "http://localhost:3001", appKey: "abc").validationError)
        XCTAssertNil(SetupValues(host: "http://[fe80::1]:3001", appKey: "abc").validationError)
    }

    func testRejectsIPAddressWithoutScheme() {
        let values = SetupValues(host: "192.168.1.10:3001", appKey: "abc")
        XCTAssertEqual(values.validationError,
                       "Server URL must start with http:// or https:// and include a host name.")
    }

    func testNormalizedHostTrimsWhitespaceAndTrailingSlashes() {
        let values = SetupValues(host: "  https://example.count.ly//  ", appKey: "abc")
        XCTAssertEqual(values.normalizedHost, "https://example.count.ly")
    }

    func testNormalizedAppKeyAndDeviceIDTrimWhitespace() {
        let values = SetupValues(host: "https://example.count.ly", appKey: " abc ", deviceID: " dev-1 ")
        XCTAssertEqual(values.normalizedAppKey, "abc")
        XCTAssertEqual(values.normalizedDeviceID, "dev-1")
    }
}

final class SetupStoreTests: XCTestCase {
    private let suite = "SetupStoreTests"
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        defaults = UserDefaults(suiteName: suite)
        defaults.removePersistentDomain(forName: suite)
    }

    func testLoadReturnsDefaultsWhenNothingStored() {
        let values = SetupStore(defaults: defaults).load()
        XCTAssertEqual(values.host, "")
        XCTAssertEqual(values.appKey, "")
        XCTAssertEqual(values.deviceID, "")
        XCTAssertTrue(values.debugLogging)
        XCTAssertTrue(values.crashReporting)
        XCTAssertFalse(values.pushNotifications)
        XCTAssertFalse(values.autoInit)
    }

    func testSaveThenLoadRoundTrips() {
        let store = SetupStore(defaults: defaults)
        let saved = SetupValues(host: "https://example.count.ly", appKey: "key-1", deviceID: "dev-9",
                                debugLogging: false, crashReporting: false, pushNotifications: true, autoInit: true)
        store.save(saved)
        let loaded = SetupStore(defaults: defaults).load()
        XCTAssertEqual(loaded, saved)
    }
}

final class SDKSessionTests: XCTestCase {

    func testInitializeRejectsInvalidValuesWithoutStarting() {
        let session = SDKSession()
        session.reset(clearStorage: true)
        let error = session.initialize(with: SetupValues(host: "", appKey: "key"))
        XCTAssertEqual(error, "Server URL is required.")
        XCTAssertFalse(session.isInitialized)
        XCTAssertNil(session.activeHost)
    }

    func testInitializeStartsSDKWithGivenValues() {
        let session = SDKSession()
        session.reset(clearStorage: true)
        let error = session.initialize(with: SetupValues(host: "https://sdk-tests.invalid/", appKey: "test_key", deviceID: "device-a"))
        XCTAssertNil(error)
        XCTAssertTrue(session.isInitialized)
        XCTAssertEqual(session.activeHost, "https://sdk-tests.invalid")
        XCTAssertEqual(session.activeAppKey, "test_key")
        XCTAssertEqual(session.currentDeviceID(), "device-a")
    }

    func testResetThenInitializeAppliesNewValues() {
        let session = SDKSession()
        session.reset(clearStorage: true)
        _ = session.initialize(with: SetupValues(host: "https://sdk-tests.invalid", appKey: "k1", deviceID: "device-a"))
        session.reset(clearStorage: true)
        XCTAssertFalse(session.isInitialized)
        XCTAssertNil(session.activeHost)
        let error = session.initialize(with: SetupValues(host: "https://sdk-tests.invalid", appKey: "k2", deviceID: "device-b"))
        XCTAssertNil(error)
        XCTAssertEqual(session.activeAppKey, "k2")
        XCTAssertEqual(session.currentDeviceID(), "device-b")
    }

    func testSetNewHostAndAppKeyUpdateActiveValues() {
        let session = SDKSession()
        session.reset(clearStorage: true)
        _ = session.initialize(with: SetupValues(host: "https://sdk-tests.invalid", appKey: "k1"))
        session.setNewHost(" https://other.invalid/ ")
        session.setNewAppKey(" k2 ")
        XCTAssertEqual(session.activeHost, "https://other.invalid")
        XCTAssertEqual(session.activeAppKey, "k2")
    }

    func testResetWithClearStoragePreservesSetupValues() {
        // halt(true) removes the host app's whole UserDefaults domain; the Setup form must survive it.
        let store = SetupStore()
        let previous = store.load()
        addTeardownBlock { store.save(previous) }
        let saved = SetupValues(host: "https://sdk-tests.invalid", appKey: "keep-me", deviceID: "dev-1",
                                debugLogging: false, crashReporting: true, pushNotifications: false, autoInit: true)
        store.save(saved)
        let session = SDKSession()
        session.reset(clearStorage: true)
        XCTAssertEqual(store.load(), saved)
    }
}
