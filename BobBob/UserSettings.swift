//
//  UserSettings.swift
//  BobBob
//
//  Created by Hanyi on 19/11/25.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var selectedChronotype: String? = nil
    @Published var hasSeenOnboarding: Bool = false
}
