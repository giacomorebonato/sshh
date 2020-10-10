//
//  InputRowViewModel.swift
//  sshh
//
//  Created by Boris Bielik on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import Foundation
import AMCoreAudio

final class InputRowViewModel: ObservableObject, Identifiable {

    var id = UUID()
    var device: AudioDevice
    var deviceName: String {
        device.name
    }
    var lastVolumeLevel: Float32 = 0

    @Published var volume: Float32 = 0 {
        didSet {
            device.setVolume(volume, channel: 0, direction: .recording)
        }
    }

    @Published var isMuted: Bool = false {
        didSet {
            self.toggleMute()
        }
    }

    init(device: AudioDevice) {
        let volumeInfo = device.volumeInfo(channel: 0, direction: .recording)

        self.device = device
        self.isMuted = (device.isMuted(channel: 0, direction: .recording)) ?? false
        self.volume = volumeInfo?.volume ?? self.lastVolumeLevel

        print("Volume is " + String(self.volume))
    }

    func toggleMute() {
        let isMuted = self.device.isMuted(channel: 0, direction: .recording) ?? false
        self.lastVolumeLevel = self.device.volumeInfo(channel: 0, direction: .recording)?.volume ?? 0
        self.device.setMute(!isMuted, channel: 0, direction: .recording)
    }

    var isDefaultDevice: Bool {
        AudioDevice.defaultInputDevice()?.id == self.device.id
    }

    func setDeviceAsDefault() {
        device.setAsDefaultInputDevice()
    }
}
