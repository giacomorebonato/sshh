//
//  QuitButton.swift
//  sshh
//
//  Created by Boris Bielik on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import Foundation
import SwiftUI

struct QuitButton: View {
    var body: some View {
        Button(action: {
            exit(0)
        }) {
            Text("Quit")
        }
    }
}

struct Quit_Button_Previews: PreviewProvider {
    static var previews: some View {
        QuitButton()
    }
}
