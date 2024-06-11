import Foundation
import SwiftUI

struct SafetyTipView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(icon)
                .font(.title)
                .accessibilityLabel("")
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
            }
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .combine)
    }
}

// Course 201: The Reality of Walking Alone
struct Course201: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("The Reality of Walking Alone")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("Walking alone can be risky, depending on factors like location, gender, and time of day. Here are some general tips to help keep you safe in any situation.")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Section(header: Text("Essential Safety Tips").font(.title3).fontWeight(.bold).foregroundColor(CustomColor.redBackground)) {
                    SafetyTipView(icon: "🛤️", title: "Plan Your Route", description: "Before leaving, choose well-lit streets with lots of people and open stores. Share your travel plan with someone you trust.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "💡", title: "Share Your Plan", description: "Inform a family member or friend of your route and expected arrival time. They can check on you if they don't hear from you.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "📱", title: "Carry Your Phone", description: "Keep your phone with you and fully charged. Consider carrying a power bank. Avoid using your phone for messages or music while walking.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "⚠️", title: "Avoid Suspicious Areas and People", description: "Stick to well-lit, busy places. Avoid shortcuts through dark alleys or parks. Stay alert for anything that feels off.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🤲", title: "Keep Your Hands Free", description: "You may need your hands for your phone or self-defense tools. Carry a small, light purse.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🚨", title: "Carry Non-Violent Deterrents", description: "A loud alarm can draw attention and deter attackers. Ensure any deterrents you carry are legal in your area.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🛡️", title: "Learn Self-Defense", description: "Self-defense classes boost confidence and situational awareness, preparing you mentally and physically for stressful situations.").accessibilityElement(children: .combine)

                }
            }
            .padding()
        }
    }
}

// Course 202: How to Tell If You Are Being Followed
struct Course202: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Tell If You Are Being Followed")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)

                    SafetyTipView(icon: "👀", title: "Situational Awareness", description: "Stay alert and aware of your surroundings. Notice if a person or vehicle appears repeatedly.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "📱", title: "Frequent Glances", description: "Use reflective surfaces like windows or your phone screen to check for followers discreetly.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🔄", title: "Change Pace and Direction", description: "Alter your walking pattern. Speed up, slow down, or take several turns to see if the follower mirrors your movements.").accessibilityElement(children: .combine)
            }
            .padding()
        }
    }
}

// Course 203: What to Do If You Suspect You’re Being Followed
struct Course203: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What to Do If You Suspect You’re Being Followed")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                    SafetyTipView(icon: "🏠", title: "Do Not Head Straight Home", description: "Avoid leading a potential follower to your residence. Go to a public, well-lit, crowded place like a café, mall, or police station.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🚔", title: "Contact Authorities", description: "If you feel threatened, call the police. Inform them of your location and situation. Also, inform friends or family.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "👀", title: "Observe and Note Details", description: "Remember details about the follower or their vehicle, like appearance, clothing, or license plate.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "📢", title: "Make Noise and Seek Help", description: "Enter a store or crowded area and inform someone in charge. Drawing attention can deter a stalker.").accessibilityElement(children: .combine)
                
                Section(header: Text("Preventive Measures").font(.title3).foregroundStyle(CustomColor.redBackground).bold()) {
                    SafetyTipView(icon: "🗺", title: "Share Your Itinerary", description: "Let someone you trust know your plans and expected arrival times. Use apps to share your live location with friends or family.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🔄", title: "Vary Your Routes", description: "Avoid predictable routines. Change your routes and travel times frequently.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "📱", title: "Use Technology", description: "Use personal safety apps with features like panic buttons that send your location and a distress message to contacts or authorities.").accessibilityElement(children: .combine)
                }
            }
            .padding()
        }
    }
}

// Course 204: Additional Safety Tips for Different Scenarios
struct Course204: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Additional Safety Tips for Different Scenarios")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                    .padding(.bottom)
                
                Section(header: Text("On Foot:").font(.title2).bold()) {
                    SafetyTipView(icon: "🚶‍♂️", title: "Walk Confidently", description: "Walk confidently and at a steady pace.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🚷", title: "Avoid Isolated Areas", description: "Avoid isolated areas, especially at night.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "📱", title: "Keep Your Phone Accessible", description: "Keep your phone easily accessible.").accessibilityElement(children: .combine)
                }.padding(.bottom)
                
                Section(header: Text("In a Vehicle:").font(.title2).bold()) {
                    SafetyTipView(icon: "🚗", title: "If Followed by Another Car", description: "If another car is following you, do not drive home. Go to a police station or a well-lit, busy area.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🔄", title: "Make Intentional Turns", description: "Make intentional turns to confirm if the same vehicle is still behind you.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🚫", title: "Avoid Stopping in Secluded Areas", description: "Avoid stopping in secluded areas.").accessibilityElement(children: .combine)
                }.padding(.bottom)
                Section(header: Text("Using Public Transport:").font(.title2).bold()) {
                    SafetyTipView(icon: "🚍", title: "Sit Near the Front", description: "Move towards the front of the bus or train where the driver or conductor can see you.").accessibilityElement(children: .combine)
                    SafetyTipView(icon: "🚉", title: "Get Off at Busy Stops", description: "If you feel unsafe, get off at a busy stop and wait for the next bus or train.").accessibilityElement(children: .combine)
                }
            }
            .padding()
        }
    }
}

struct Course205: View {
    @State private var selectedAnswer1: Int? = nil
    @State private var showResult1: Bool = false
    @State private var selectedAnswer2: Int? = nil
    @State private var showResult2: Bool = false
    @State private var selectedAnswer3: Int? = nil
    @State private var showResult3: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Safety Tips Quiz")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                // Question 1
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 1: What should you do before leaving for a walk alone?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer1 = index
                            showResult1 = true
                        }) {
                            Text(question1Options(index))
                                .padding()
                                .background(selectedAnswer1 == index ? (selectedAnswer1 == 1 ? Color.green : Color.white) : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    
                    if showResult1 {
                        Text(resultText1())
                            .font(.headline)
                            .foregroundColor(selectedAnswer1 == 1 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
                
                Divider()
                
                // Question 2
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 2: How can you tell if you're being followed?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer2 = index
                            showResult2 = true
                        }) {
                            Text(question2Options(index))
                                .padding()
                                .background(selectedAnswer2 == index ? (selectedAnswer2 == 1 ? Color.green : Color.white) : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    
                    if showResult2 {
                        Text(resultText2())
                            .font(.headline)
                            .foregroundColor(selectedAnswer2 == 1 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
                
                Divider()
                
                // Question 3
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 3: What should you do if you suspect you're being followed?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer3 = index
                            showResult3 = true
                        }) {
                            Text(question3Options(index))
                                .padding()
                                .background(selectedAnswer3 == index ? (selectedAnswer3 == 2 ? Color.green : Color.white) : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                    }
                    
                    if showResult3 {
                        Text(resultText3())
                            .font(.headline)
                            .foregroundColor(selectedAnswer3 == 2 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
            }
            .padding()
        }
    }
    
    // Question 1 Options
    private func question1Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Plan your route and share it with someone you trust."
        case 2: return "B. Carry your phone and use it for messages or music."
        case 3: return "C. Walk through dark alleys or parks for shortcuts."
        case 4: return "D. Avoid sharing your travel plan with anyone."
        default: return ""
        }
    }
    
    // Question 2 Options
    private func question2Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Stay alert and aware of surroundings."
        case 2: return "B. Use reflective surfaces to check for followers."
        case 3: return "C. Alter your walking pattern."
        case 4: return "D. Carry a loud alarm."
        default: return ""
        }
    }
    
    // Question 3 Options
    private func question3Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Call the police immediately."
        case 2: return "B. Go to a public, well-lit, crowded place."
        case 3: return "C. Make intentional turns to confirm if followed."
        case 4: return "D. Continue walking and ignore the feeling."
        default: return ""
        }
    }
    
    // Result Texts
    private func resultText1() -> String {
        if selectedAnswer1 == 1 {
            return "Correct! Planning your route and sharing it with someone you trust enhances safety."
        } else {
            return "Incorrect. Planning your route and sharing it with someone you trust enhances safety."
        }
    }
    
    private func resultText2() -> String {
        if selectedAnswer2 == 1 {
            return "Correct! Staying alert and aware of surroundings helps detect if you're being followed."
        } else {
            return "Incorrect. Staying alert and aware of surroundings helps detect if you're being followed."
        }
    }
    
    private func resultText3() -> String {
        if selectedAnswer3 == 2 {
            return "Correct! Going to a public, well-lit, crowded place if you suspect you're being followed is a recommended action."
        } else {
            return "Incorrect. Going to a public, well-lit, crowded place if you suspect you're being followed is a recommended action."
        }
    }
}
