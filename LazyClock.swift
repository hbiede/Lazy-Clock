//
//  LazyClock.swift
//  Lazy Clock
//
//  Created by Hundter Biede on 11/5/22.
//  Copyright © 2022 Hundter Biede. All rights reserved.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct LazyClock: AppIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "LazyClockIntent"

    static var title: LocalizedStringResource = "Lazy Clock"
    static var description = IntentDescription(
        "Natural Language Time conversion for the current time. Copies the result to the clipboard."
    )

    static var parameterSummary: some ParameterSummary {
        Summary()
    }

    func perform() async throws -> some IntentResult {
        let result = NaturalLanguageTime().description
        let dialog = IntentDialog(stringLiteral: result)
        return .result(value: result, dialog: dialog)
    }
}

fileprivate extension IntentDialog {
    static func responseSuccess(timeResponse: String) -> Self {
        "\(timeResponse)"
    }
    static var responseFailure: Self {
        "Error. Time Doesn't Exist."
    }
}
