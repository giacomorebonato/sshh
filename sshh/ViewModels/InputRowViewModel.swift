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

    @Published var device: AudioDevice
    @Published var isDefaultDevice = false {
        didSet {
            if isDefaultDevice {
                setDeviceAsDefault()
            }
        }
    }
    @Published var isMuted: Bool = false {
        didSet {
            self.toggleMute()
        }
    }
    @Published var volume: Float32 = 0 {
        didSet {
            device.setVolume(volume, channel: 0, direction: direction)
        }
    }

    let id = UUID()
    var deviceName: String {
        device.name
    }
    private var lastVolumeLevel: Float32 = 0
    private var direction: Direction

    init(device: AudioDevice) {
        let direction: Direction = device.isOutputOnlyDevice() ? .recording : .playback
        let volumeInfo = device.volumeInfo(channel: 0, direction: direction)
        self.direction = direction

        self.isDefaultDevice = AudioDevice.defaultInputDevice()?.id == device.id
        self.device = device
        self.isMuted = (device.isMuted(channel: 0, direction: direction)) ?? false
        self.volume = volumeInfo?.volume ?? self.lastVolumeLevel

        print("Volume is " + String(self.volume))
    }

    func toggleMute() {
        let isMuted = self.device.isMuted(channel: 0, direction: direction) ?? false
        self.lastVolumeLevel = self.device.volumeInfo(channel: 0, direction: direction)?.volume ?? 0
        self.device.setMute(!isMuted, channel: 0, direction: direction)
    }

    func setDeviceAsDefault() {
        device.setAsDefaultInputDevice()
    }
}
