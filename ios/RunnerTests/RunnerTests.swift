import Flutter
import UIKit
import XCTest
@testable import Runner

class RunnerTests: XCTestCase {

  func testAppDelegateWindowExists() {
    let appDelegate = try XCTUnwrap(UIApplication.shared.delegate as? AppDelegate, "App delegate should exist")
    let _ = try XCTUnwrap(appDelegate.window, "App delegate should have a window")
  }

  func testAppDelegateWindowHasRootViewController() {
    let appDelegate = try XCTUnwrap(UIApplication.shared.delegate as? AppDelegate, "App delegate should exist")
    let _ = try XCTUnwrap(appDelegate.window?.rootViewController, "Window should have a root view controller")
  }

}
