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
                
                Section(header: Text("Steps of Situational Awareness").font(.title3).fontWeight(.bold).foregroundColor(CustomColor.redBackground)) {
                    SafetyTipView4(icon: "👀", title: "Perceiving Elements", description: "Notice sounds, smells, and visual cues in your environment. For example, at a train station, you might hear a loud bang, smell smoke, and see people fleeing.")
                        SafetyTipView4(icon: "🔍", title: "Attributing Meaning", description: "Recognize that these elements, like smoke or running people, indicate potential danger. Understand their significance.")
                        SafetyTipView4(icon: "🔮", title: "Predicting Outcomes", description: "Foresee possible threats and determine the best course of action, such as joining the crowd to escape danger.")
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
                
                Section(header: Text("Enhancing Perception").font(.subheadline).fontWeight(.bold)) {
                    SafetyTipView4(icon: "🩺", title: "Regular Checkups", description: "Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well.")
                    SafetyTipView4(icon: "🍏", title: "Healthy Lifestyle", description: "Maintain a healthy diet and avoid activities that strain your body, like smoking.")
                    SafetyTipView4(icon: "🌍", title: "Engage with Surroundings", description: "Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you.")
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
                    SafetyTipView4(icon: "😌", title: "Appear Confident", description: "Walk with your head high, maintain good posture, and appear purposeful. Predators often target those who seem timid or lost.")
                    SafetyTipView4(icon: "💇🏻‍♀️", title: "Mind Your Hair", description: "Avoid hairstyles that can be easily grabbed, like ponytails. Wearing a cap can prevent such grabs.")
                    SafetyTipView4(icon: "🧪", title: "Avoid Intoxication Alone", description: "If intoxicated, ensure a friend accompanies you home. Intoxicated individuals are more vulnerable targets.")
                    SafetyTipView4(icon: "🅿️", title: "Park in Well-Lit Areas", description: "Avoid dark parking spots, which provide cover for predators. Always park in well-lit, busy areas.")
                    SafetyTipView4(icon: "‼️", title: "Stay Aware of Your Surroundings", description: "Avoid talking on the phone or wearing earphones when walking alone. These distractions can reduce your awareness.")
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
                    Text("Jeff Cooper's Color Code categorizes different levels of awareness:")
                        SafetyTipView4(icon: "⚪️", title: "White:", description: "Relaxed and unaware; suitable for safe environments.")
                        SafetyTipView4(icon: "🟡", title: "Yellow:", description: "Relaxed but alert; the goal for most situations.")
                        SafetyTipView4(icon: "🟠", title: "Orange:", description: "Focused on potential danger; mentally taxing and not sustainable long-term.")
                        SafetyTipView4(icon: "🔴", title: "Red:", description: "Action mode; dealing with an immediate threat.")
                        SafetyTipView4(icon: "⚫️", title: "Black:", description: "Panic mode; breakdown of physical and mental abilities.")
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
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(icon)
                .font(.title)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
            }
        }
        .padding(.vertical, 5)
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
        case 1: return "1. Perceiving Elements, Predicting Outcomes, Attributing Meaning"
        case 2: return "2. Attributing Meaning, Perceiving Elements, Predicting Outcomes"
        case 3: return "3. Perceiving Elements, Attributing Meaning, Predicting Outcomes"
        case 4: return "4. Predicting Outcomes, Attributing Meaning, Perceiving Elements"
        default: return ""
        }
    }
    
    // Answer Options for Question 2
    private func cooperCodeOptions(_ index: Int) -> String {
        switch index {
        case 1: return "1. White"
        case 2: return "2. Yellow"
        case 3: return "3. Orange"
        case 4: return "4. Red"
        default: return ""
        }
    }
    
    // Answer Options for Question 3
    private func enhancePerceptionOptions(_ index: Int) -> String {
        switch index {
        case 1: return "1. Walk with your head high"
        case 2: return "2. Avoid hairstyles that can be easily grabbed"
        case 3: return "3. Avoid talking on the phone"
        case 4: return "4. Engage with your surroundings"
        default: return ""
        }
    }
    
    // Result Texts
    private func resultText1() -> String {
        if selectedAnswer1 == 3 {
            return "Correct! The correct order is Perceiving Elements, Attributing Meaning, Predicting Outcomes."
        } else {
            return "Incorrect. The correct order is Perceiving Elements, Attributing Meaning, Predicting Outcomes."
        }
    }
    
    private func resultText2() -> String {
        if selectedAnswer2 == 2 {
            return "Correct! Yellow indicates being relaxed but alert."
        } else {
            return "Incorrect. Yellow indicates being relaxed but alert."
        }
    }
    
    private func resultText3() -> String {
        if selectedAnswer3 == 4 {
            return "Correct! Engaging with your surroundings helps enhance your situational awareness perception."
        } else {
            return "Incorrect. Engaging with your surroundings helps enhance your situational awareness perception."
        }
    }
}
