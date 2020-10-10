//
//  ContentViewViewModel.swift
//  sshh
//
//  Created by Pete Smith on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import AMCoreAudio
import SwiftUI

class ContentViewViewModel: ObservableObject {
    @Published var inputDevices: [AudioDevice]

    init() {
        self.inputDevices = AudioDevice.allInputDevices()
    }

    func refresh() {
        self.inputDevices = AudioDevice.allInputDevices()
    }
}
