//
//  AppState.swift
//  sshh
//
//  Created by Pete Smith on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import Foundation
import SwiftUI

final class AppState {
    @ObservedObject var contentViewModel = ContentViewViewModel()
}
