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
