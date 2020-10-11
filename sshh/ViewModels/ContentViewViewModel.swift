//
//  ContentViewViewModel.swift
//  sshh
//
//  Created by Pete Smith on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import AMCoreAudio
import SwiftUI

final class ContentViewViewModel: ObservableObject {
    @Published var inputViewModels: [InputRowViewModel] = []

    init() {
        reload()
    }

    func reload() {
        inputViewModels = AudioDevice.allInputDevices().map {
            InputRowViewModel(device: $0)
        }
    }
}
