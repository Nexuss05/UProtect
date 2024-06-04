import SwiftUI

struct GoalView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
//    @State var num = 1
    @State var cont = 300
    @State var selectedMode = 2
    @State var isShowingMain: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        VStack {
            VStack{
                Text("Set your time")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("Set a custom timer to notify your emergency contacts exactly after the amount of time that most fits your needs.")
                    .font(.headline)
                    .fontWeight(.regular)
                    .frame(width: 330, height: 90)
            }.multilineTextAlignment(.center)
            
            Picker(selection: $selectedMode, label: Text("Mode")) {
                Text("Lightly").tag(1)
                Text("Moderately").tag(2)
                Text("Highly").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 310)
            .padding(.top, 30)
            .padding(.bottom, 80)
            .onChange(of: selectedMode) { newMode in
                switch newMode {
                case 1:
                    cont = 180
                    print("Lightly selected")
                case 2:
                    cont = 300
                    print("Moderately selected")
                case 3:
                    cont = 540
                    print("Highly selected")
                default:
                    break
                }
            }
            
            GoalSelectorView(counter: $cont)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width:350, height:60)
                    .foregroundColor(Color(CustomColor.orange))
                Text("Set timer")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding(.top, 90)
            .padding(.bottom, 50)
            .onTapGesture {
                modelContext.insert(Counter(counter: cont))
                timerManager.maxTime = cont
                isShowingMain.toggle()
                dismiss()
                timerManager.updateCountFromLastCounter()
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
        }
    }
}

//#Preview {
//    GoalView()
//}
