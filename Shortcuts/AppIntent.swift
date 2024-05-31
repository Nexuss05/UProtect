//
//  AppIntent.swift
//  UProtect
//
//  Created by Simone Sarnataro on 31/05/24.
//

import AppIntents
import SwiftUI

struct LogBreakIntent: AppIntent {
  static let title: LocalizedStringResource = "Send notification"

  func perform() async throws -> some IntentResult & ProvidesDialog {
    let timerManager = TimerManager()
      timerManager.Activation()
      timerManager.CircleAnimation()
    return .result(dialog: "Notification sent!")
  }
}
