//
//  CoursesStructs.swift
//  UProtect
//
//  Created by Andrea Romano on 06/06/24.
//

import Foundation
import SwiftUI

struct Course101: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("What Is Situational Awareness?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("Situational awareness involves perceiving your environment, understanding its significance, and predicting future events. It's crucial for navigating daily dangers and is heavily relied upon in various fields such as law enforcement, emergency response, military operations, aviation, nautical navigation, and sports. It's equally essential for everyday safety.")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Section(header: Text(NSLocalizedString("Steps of Situational Awareness", comment: "")).font(.title3).fontWeight(.bold).foregroundColor(CustomColor.redBackground)) {
                                    SafetyTipView4(icon: "👀", titleKey: "Perceiving Elements", descriptionKey: "Notice sounds, smells, and visual cues in your environment. For example, at a train station, you might hear a loud bang, smell smoke, and see people fleeing.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🔍", titleKey: "Attributing Meaning", descriptionKey: "Recognize that these elements, like smoke or running people, indicate potential danger. Understand their significance.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🔮", titleKey: "Predicting Outcomes", descriptionKey: "Foresee possible threats and determine the best course of action, such as joining the crowd to escape danger.")
                                        .accessibilityElement(children: .combine)
                                }
            }
            .padding()
        }
    }
}

struct Course102: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Practicing and Developing Situational Awareness")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("While humans naturally possess situational awareness due to innate survival instincts, it can be enhanced through vigilance, continuous practice, and improving cognitive abilities.")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                
                Section(header: Text(NSLocalizedString("Enhancing Perception", comment: "Header for enhancing perception section")).font(.subheadline).fontWeight(.bold)) {
                                    SafetyTipView4(icon: "🩺", titleKey: "Regular Checkups", descriptionKey: "Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🍏", titleKey: "Healthy Lifestyle", descriptionKey: "Maintain a healthy diet and avoid activities that strain your body, like smoking.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🌍", titleKey: "Engage with Surroundings", descriptionKey: "Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you.")
                                        .accessibilityElement(children: .combine)
                                }
                
                Section(header: Text("Attributing Meaning to Perceived Elements").font(.subheadline).fontWeight(.bold)) {
                    Text("After perceiving elements, the next step is understanding their meaning by asking key questions:")
                    Text("- **Who**: Who is the person? Is their body language open or nervous? Who are they with?")
                    Text("- **What**: What are they doing? What actions are they taking? What are they wearing?")
                    Text("- **When**: What is the time of day? Is it a busy weekday morning, or a quiet Saturday night?")
                    Text("- **Where**: Where are you? What usually happens in this place?")
                    Text("- **Why**: Why is the person acting this way? Why are they here at this time?")
                    Text("- **How**: How did this person arrive here? How are they behaving?")
                }
                
                Section(header: Text("Projecting Future Outcomes").font(.subheadline).fontWeight(.bold)) {
                    Text("The final step involves processing all the information gathered and predicting future events:")
                    Text("- Context Matters: Consider the entire context. For instance, a pregnant woman holding a pocket knife late at night may be protecting herself, not posing a threat.")
                    Text("- Behavioral Patterns: Conversely, a young man with a face mask in a desolate area might raise alarms. Use context and other clues to predict potential threats accurately.")
                }
            }
            .padding()
        }
    }
}

struct Course103: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Additional Safety Tips")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                                    SafetyTipView4(icon: "😌", titleKey: "Appear Confident", descriptionKey: "Walk with your head high, maintain good posture, and appear purposeful. Predators often target those who seem timid or lost.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "💇🏻‍♀️", titleKey: "Mind Your Hair", descriptionKey: "Avoid hairstyles that can be easily grabbed, like ponytails. Wearing a cap can prevent such grabs.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🧪", titleKey: "Avoid Intoxication Alone", descriptionKey: "If intoxicated, ensure a friend accompanies you home. Intoxicated individuals are more vulnerable targets.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🅿️", titleKey: "Park in Well-Lit Areas", descriptionKey: "Avoid dark parking spots, which provide cover for predators. Always park in well-lit, busy areas.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "‼️", titleKey: "Stay Aware of Your Surroundings", descriptionKey: "Avoid talking on the phone or wearing earphones when walking alone. These distractions can reduce your awareness.")
                                        .accessibilityElement(children: .combine)
                                }
                
                Text("Importance of Training")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("In emergencies, people rely on their lowest level of training. Training helps develop quick, effective solutions focusing on speed and efficiency rather than perfection. For example, in an active shooter scenario, instructing students to run to the nearest exit may not be perfect but is likely to save more lives.")
            }
            .padding()
        }
    }
}

struct Course104: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Cooper’s Color Code for Awareness Levels")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                                    Text(NSLocalizedString("Jeff Cooper's Color Code categorizes different levels of awareness:", comment: "Introduction to Cooper's Color Code"))
                                    SafetyTipView4(icon: "⚪️", titleKey: "White:", descriptionKey: "Relaxed and unaware; suitable for safe environments.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🟡", titleKey: "Yellow:", descriptionKey: "Relaxed but alert; the goal for most situations.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🟠", titleKey: "Orange:", descriptionKey: "Heightened awareness due to specific potential threats.")
                                        .accessibilityElement(children: .combine)
                                    SafetyTipView4(icon: "🔴", titleKey: "Red:", descriptionKey: "High alert, taking direct action to neutralize an immediate threat.")
                                        .accessibilityElement(children: .combine)
                                }
                
                Text("Practical Implementation Strategies")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Recognize Patterns")
                        .fontWeight(.bold)
                    Text("- Establish normal patterns of behavior in your environment to detect anomalies.")
                    Text("- Modify interaction rules to improve situational awareness, observing attire, carried objects, and making eye contact.")
                    
                    Text("2. Environmental Analysis")
                        .fontWeight(.bold)
                    Text("Assess your environment for safety:")
                    Text("- Home: Identify safe rooms and escape paths.")
                    Text("- Work: Locate exits, understand the layout, and identify objects that can provide cover.")
                    
                    Text("3. Understand Atmospherics")
                        .fontWeight(.bold)
                    Text("Read the collective mood of the environment; a relaxed crowd versus an anxious or volatile one can indicate potential danger.")
                }
            }
            .padding()
        }
    }
}

struct SafetyTip {
    let id: UUID
    let title: String
    let description: String
}

struct DailyTipView: View {
    @State private var currentTip: SafetyTip?
    
    private var tips: [SafetyTip] = [
        SafetyTip(id: UUID(), title: "Appear Confident", description: "Walk with your head high, maintain good posture, and appear purposeful."),
        SafetyTip(id: UUID(), title: "Mind Your Hair", description: "Avoid hairstyles that can be easily grabbed, like ponytails."),
        SafetyTip(id: UUID(), title: "Avoid Intoxication Alone", description: "If intoxicated, ensure a friend accompanies you home."),
        SafetyTip(id: UUID(), title: "Park in Well-Lit Areas", description: "Avoid dark parking spots, which provide cover for predators."),
        SafetyTip(id: UUID(), title: "Stay Aware of Your Surroundings", description: "Avoid talking on the phone or wearing earphones when walking alone."),
        SafetyTip(id: UUID(), title: "Regular Checkups", description: "Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well."),
        SafetyTip(id: UUID(), title: "Healthy Lifestyle", description: "Maintain a healthy diet and avoid activities that strain your body, like smoking."),
        SafetyTip(id: UUID(), title: "Engage with Surroundings", description: "Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you."),
        SafetyTip(id: UUID(), title: "Plan Your Route", description: "Before leaving, choose well-lit streets with lots of people and open stores. Share your travel plan with someone you trust."),
        SafetyTip(id: UUID(), title: "Share Your Plan", description: "Inform a family member or friend of your route and expected arrival time. They can check on you if they don't hear from you."),
        SafetyTip(id: UUID(), title: "Carry Your Phone", description: "Keep your phone with you and fully charged. Consider carrying a power bank. Avoid using your phone for messages or music while walking."),
        SafetyTip(id: UUID(), title: "Avoid Suspicious Areas and People", description: "Stick to well-lit, busy places. Avoid shortcuts through dark alleys or parks. Stay alert for anything that feels off."),
        SafetyTip(id: UUID(), title: "Keep Your Hands Free", description: "You may need your hands for your phone or self-defense tools. Carry a small, light purse."),
        SafetyTip(id: UUID(), title: "Carry Non-Violent Deterrents", description: "A loud alarm can draw attention and deter attackers. Ensure any deterrents you carry are legal in your area."),
        SafetyTip(id: UUID(), title: "Learn Self-Defense", description: "Self-defense classes boost confidence and situational awareness, preparing you mentally and physically for stressful situations."),
        SafetyTip(id: UUID(), title: "Situational Awareness", description: "Stay alert and aware of your surroundings. Notice if a person or vehicle appears repeatedly."),
        SafetyTip(id: UUID(), title: "Frequent Glances", description: "Use reflective surfaces like windows or your phone screen to check for followers discreetly."),
        SafetyTip(id: UUID(), title: "Change Pace and Direction", description: "Alter your walking pattern. Speed up, slow down, or take several turns to see if the follower mirrors your movements."),
        SafetyTip(id: UUID(), title: "Do Not Head Straight Home", description: "Avoid leading a potential follower to your residence. Go to a public, well-lit, crowded place like a café, mall, or police station."),
        SafetyTip(id: UUID(), title: "Contact Authorities", description: "If you feel threatened, call the police. Inform them of your location and situation. Also, inform friends or family."),
        SafetyTip(id: UUID(), title: "Observe and Note Details", description: "Remember details about the follower or their vehicle, like appearance, clothing, or license plate."),
        SafetyTip(id: UUID(), title: "Make Noise and Seek Help", description: "Enter a store or crowded area and inform someone in charge. Drawing attention can deter a stalker."),
        SafetyTip(id: UUID(), title: "Share Your Itinerary", description: "Let someone you trust know your plans and expected arrival times. Use apps to share your live location with friends or family."),
        SafetyTip(id: UUID(), title: "Vary Your Routes", description: "Avoid predictable routines. Change your routes and travel times frequently."),
        SafetyTip(id: UUID(), title: "Use Technology", description: "Use personal safety apps with features like panic buttons that send your location and a distress message to contacts or authorities."),
        SafetyTip(id: UUID(), title: "Walk Confidently", description: "Walk confidently and at a steady pace."),
        SafetyTip(id: UUID(), title: "Avoid Isolated Areas", description: "Avoid isolated areas, especially at night."),
        SafetyTip(id: UUID(), title: "Keep Your Phone Accessible", description: "Keep your phone easily accessible."),
        SafetyTip(id: UUID(), title: "If Followed by Another Car", description: "If another car is following you, do not drive home. Go to a police station or a well-lit, busy area."),
        SafetyTip(id: UUID(), title: "Make Intentional Turns", description: "Make intentional turns to confirm if the same vehicle is still behind you."),
        SafetyTip(id: UUID(), title: "Avoid Stopping in Secluded Areas", description: "Avoid stopping in secluded areas."),
        SafetyTip(id: UUID(), title: "Sit Near the Front", description: "Move towards the front of the bus or train where the driver or conductor can see you."),
        SafetyTip(id: UUID(), title: "Get Off at Busy Stops", description: "If you feel unsafe, get off at a busy stop and wait for the next bus or train."),
        SafetyTip(id: UUID(), title: "Set a Limit", description: "Decide on a drinking limit beforehand."),
        SafetyTip(id: UUID(), title: "Eat a Meal", description: "Eating before drinking slows alcohol absorption."),
        SafetyTip(id: UUID(), title: "Alternate Drinks", description: "Drink water or soft drinks between alcoholic beverages."),
        SafetyTip(id: UUID(), title: "Have a Plan", description: "Plan your way home, keep your phone charged, or bring a power bank."),
        SafetyTip(id: UUID(), title: "Stick with Friends", description: "Stay with friends to reduce the risk of incidents and injuries."),
        SafetyTip(id: UUID(), title: "Bright Clothes", description: "Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective."),
        SafetyTip(id: UUID(), title: "Walk Together", description: "Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards."),
        SafetyTip(id: UUID(), title: "Alternatives", description: "Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed."),
        SafetyTip(id: UUID(), title: "Look Both Ways", description: "Always look both ways before crossing the street."),
        SafetyTip(id: UUID(), title: "Use Pedestrian Crossings", description: "Use pedestrian crossings and obey traffic signals."),
        SafetyTip(id: UUID(), title: "Walk on Sidewalks", description: "Walk on sidewalks or, if unavailable, facing traffic on the road's edge."),
        SafetyTip(id: UUID(), title: "Never Play or Run", description: "Never play or run into the street."),
        SafetyTip(id: UUID(), title: "Never Accept Rides", description: "Never accept rides or gifts from strangers."),
        SafetyTip(id: UUID(), title: "Know Safe Adults", description: "Know safe adults they can turn to if they feel uncomfortable or in danger."),
        SafetyTip(id: UUID(), title: "Mobile Phones", description: "Consider giving your child a phone to contact you in emergencies. Teach them how to use it responsibly and practice emergency procedures."),
        SafetyTip(id: UUID(), title: "Safe Spots", description: "Identify safe places along the route, like trusted neighbors' homes or businesses, where your child can seek help if needed."),
        SafetyTip(id: UUID(), title: "No Headphones", description: "Discourage the use of headphones while walking to ensure they remain alert to their surroundings."),
        SafetyTip(id: UUID(), title: "Identifying Safe Routes", description: "Choose routes that avoid isolated or poorly lit areas, busy roads without sidewalks, and other hazards.")
    ]

    var body: some View {
        VStack(alignment: .leading) {
            if let tip = currentTip {
                HStack {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("Daily Safety Tip")
                            .font(.title)
                            .bold()
                            .foregroundColor(CustomColor.redBackground)
                            .padding(.bottom)
                        Text(tip.title)
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(tip.description)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 40)

                    Spacer()
                }
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.bottom, 10)
            } else {
                Text("Loading Tip...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    .padding(.bottom, 10)
            }
        }
        .onAppear(perform: loadDailyTip)
    }

    private func loadDailyTip() {
        let calendar = Calendar.current
        let date = Date()
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        currentTip = tips[dayOfYear % tips.count]
    }
}


// SafetyTipView4 with Emoji Icon
struct SafetyTipView4: View {
    let icon: String
    let titleKey: String
    let descriptionKey: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(icon)
                .font(.title)
                .accessibilityLabel("")
            VStack(alignment: .leading) {
                Text(NSLocalizedString(titleKey, comment: ""))
                    .font(.headline)
                Text(NSLocalizedString(descriptionKey, comment: ""))
                    .font(.body)
            }
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .combine)
    }
}

// SituationalAwarenessStepView with Emoji Icon
struct SituationalAwarenessStepView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("🔍 \(title)")
                .font(.headline)
            Text(description)
                .font(.body)
        }
        .padding(.vertical, 5)
    }
}

// SituationalAwarenessPracticeView with Emoji Icon
struct SituationalAwarenessPracticeView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(icon) \(title)")
                .font(.headline)
            Text(description)
                .font(.body)
        }
        .padding(.vertical, 5)
    }
}

struct Course105: View {
    @State private var selectedAnswer1: Int? = nil
    @State private var showResult1: Bool = false
    @State private var selectedAnswer2: Int? = nil
    @State private var showResult2: Bool = false
    @State private var selectedAnswer3: Int? = nil
    @State private var showResult3: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Situational Awareness Quiz")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                // Question 1
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 1: What is the correct order of the steps of situational awareness?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer1 = index
                            showResult1 = true
                        }) {
                            Text(orderOptions(index))
                                .padding()
                                .background(selectedAnswer1 == index ? (selectedAnswer1 == 3 ? Color.green : Color.white) : Color.white)
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
                            .foregroundColor(selectedAnswer1 == 3 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
                
                Divider()
                
                // Question 2
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 2: Which level of Cooper’s Color Code indicates being relaxed but alert?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer2 = index
                            showResult2 = true
                        }) {
                            Text(cooperCodeOptions(index))
                                .padding()
                                .background(selectedAnswer2 == index ? (selectedAnswer2 == 2 ? Color.green : Color.white) : Color.white)
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
                            .foregroundColor(selectedAnswer2 == 2 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
                
                Divider()
                
                // Question 3
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 3: What should you do to enhance your situational awareness perception?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer3 = index
                            showResult3 = true
                        }) {
                            Text(enhancePerceptionOptions(index))
                                .padding()
                                .background(selectedAnswer3 == index ? (selectedAnswer3 == 4 ? Color.green : Color.white) : Color.white)
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
                            .foregroundColor(selectedAnswer3 == 4 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
            }
            .padding()
        }
    }
    
    // Answer Options for Question 1
    private func orderOptions(_ index: Int) -> String {
        switch index {
        case 1: return NSLocalizedString("1. Perceiving Elements, Predicting Outcomes, Attributing Meaning", comment: "")
        case 2: return NSLocalizedString("2. Attributing Meaning, Perceiving Elements, Predicting Outcomes", comment: "")
        case 3: return NSLocalizedString("3. Perceiving Elements, Attributing Meaning, Predicting Outcomes", comment: "")
        case 4: return NSLocalizedString("4. Predicting Outcomes, Attributing Meaning, Perceiving Elements", comment: "")
        default: return ""
        }
    }
    
    // Answer Options for Question 2
    private func cooperCodeOptions(_ index: Int) -> String {
        switch index {
        case 1: return NSLocalizedString("1. White", comment: "")
        case 2: return NSLocalizedString("2. Yellow", comment: "")
        case 3: return NSLocalizedString("3. Orange", comment: "")
        case 4: return NSLocalizedString("4. Red", comment: "")
        default: return ""
        }
    }
    
    // Answer Options for Question 3
    private func enhancePerceptionOptions(_ index: Int) -> String {
        switch index {
        case 1: return NSLocalizedString("1. Walk with your head high", comment: "")
        case 2: return NSLocalizedString("2. Avoid hairstyles that can be easily grabbed", comment: "")
        case 3: return NSLocalizedString("3. Avoid talking on the phone", comment: "")
        case 4: return NSLocalizedString("4. Engage with your surroundings", comment: "")
        default: return ""
        }
    }
    
    // Result Texts
    private func resultText1() -> String {
        if selectedAnswer1 == 3 {
            return NSLocalizedString("Correct! The correct order is Perceiving Elements, Attributing Meaning, Predicting Outcomes.", comment: "")
        } else {
            return NSLocalizedString("Incorrect. The correct order is Perceiving Elements, Attributing Meaning, Predicting Outcomes.", comment: "")
        }
    }
    
    private func resultText2() -> String {
        if selectedAnswer2 == 2 {
            return NSLocalizedString("Correct! Yellow indicates being relaxed but alert.", comment: "")
        } else {
            return NSLocalizedString("Incorrect. Yellow indicates being relaxed but alert.", comment: "")
        }
    }
    
    private func resultText3() -> String {
        if selectedAnswer3 == 4 {
            return NSLocalizedString("Correct! Engaging with your surroundings helps enhance your situational awareness perception.", comment: "")
        } else {
            return NSLocalizedString("Incorrect. Engaging with your surroundings helps enhance your situational awareness perception.", comment: "")
        }
    }
}
