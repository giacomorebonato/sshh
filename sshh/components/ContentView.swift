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


struct ContentView: View {
    @ObservedObject var vm: ContentViewViewModel
        
    init() {
        self.vm = ContentViewViewModel()
    }

    var body: some View {
        VStack {
            ForEach(vm.inputDevices, id: \.id) {
                device in InputRow(device: device, refresh: self.vm.refresh)
            }
            Divider()
            HStack {
                Button(action: {
                    exit(0)
                }) {
                    Text("Quit")
                }
            }
        }
        .padding(.top, 12)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 4)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
