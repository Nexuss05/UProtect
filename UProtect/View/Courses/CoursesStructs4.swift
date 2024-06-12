//
//  CoursesStructs4.swift
//  UProtect
//
//  Created by Andrea Romano on 07/06/24.
//

import Foundation
import SwiftUI

struct SafetyTipView3: View {
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

// Course 401: Security for Children Walking Alone to School
struct Course401: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Security for Children Walking Alone to School")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("""
                Legal Age to Walk Alone: the **recommended** age for children to walk alone varies by country and region, **generally** around 10 years old. **Check local laws** and regulations for specific guidelines.
                """)
                
                Text("Walking to School Alone Tips:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                                    SafetyTipView3(icon: "👕", title: NSLocalizedString("Bright Clothes", comment: ""), description: NSLocalizedString("Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "👥", title: NSLocalizedString("Walk Together", comment: ""), description: NSLocalizedString("Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🧠", title: NSLocalizedString("Alternatives", comment: ""), description: NSLocalizedString("Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed.", comment: "")).accessibilityElement(children: .combine)
                                    
                                    Text(NSLocalizedString("**Road Safety Rules**: Teach children road safety basics, such as:", comment: ""))
                                    VStack(alignment: .leading, spacing: 5) {
                                        SafetyTipView3(icon: "👀", title: NSLocalizedString("Look Both Ways", comment: ""), description: NSLocalizedString("Always look both ways before crossing the street.", comment: "")).accessibilityElement(children: .combine)
                                        SafetyTipView3(icon: "🚸", title: NSLocalizedString("Use Pedestrian Crossings", comment: ""), description: NSLocalizedString("Use pedestrian crossings and obey traffic signals.", comment: "")).accessibilityElement(children: .combine)
                                        SafetyTipView3(icon: "🚶‍♀️", title: NSLocalizedString("Walk on Sidewalks", comment: ""), description: NSLocalizedString("Walk on sidewalks or, if unavailable, facing traffic on the road's edge.", comment: "")).accessibilityElement(children: .combine)
                                        SafetyTipView3(icon: "🏃‍♀️", title: NSLocalizedString("Never Play or Run", comment: ""), description: NSLocalizedString("Never play or run into the street.", comment: "")).accessibilityElement(children: .combine)
                                    }
                                    
                                    Text(NSLocalizedString("**Stranger Danger**: Educate your child on how to handle situations with strangers:", comment: ""))
                                    VStack(alignment: .leading, spacing: 5) {
                                        SafetyTipView3(icon: "🚘", title: NSLocalizedString("Never Accept Rides", comment: ""), description: NSLocalizedString("Never accept rides or gifts from strangers.", comment: "")).accessibilityElement(children: .combine)
                                        SafetyTipView3(icon: "👨‍🦳", title: NSLocalizedString("Know Safe Adults", comment: ""), description: NSLocalizedString("Know safe adults they can turn to if they feel uncomfortable or in danger.", comment: "")).accessibilityElement(children: .combine)
                                    }
                                    
                                    SafetyTipView3(icon: "📱", title: NSLocalizedString("Mobile Phones", comment: ""), description: NSLocalizedString("Consider giving your child a phone to contact you in emergencies. Teach them how to use it responsibly and practice emergency procedures.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🏡", title: NSLocalizedString("Safe Spots", comment: ""), description: NSLocalizedString("Identify safe places along the route, like trusted neighbors' homes or businesses, where your child can seek help if needed.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🎧", title: NSLocalizedString("No Headphones", comment: ""), description: NSLocalizedString("Discourage the use of headphones while walking to ensure they remain alert to their surroundings.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🗺", title: NSLocalizedString("Identifying Safe Routes", comment: ""), description: NSLocalizedString("Choose routes that avoid isolated or poorly lit areas, busy roads without sidewalks, and other hazards.", comment: "")).accessibilityElement(children: .combine)
                                }
                            }
            .padding()
        }
    }
}

// Course 402: Road Safety Rules
struct Course402: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Road Safety Rules")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    SafetyTipView3(icon: "👀", title: NSLocalizedString("Look Before Crossing", comment: ""), description: NSLocalizedString("Hold an adult's hand, look left, right, and left again before crossing.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "🚫", title: NSLocalizedString("Don’t Play on the Road", comment: ""), description: NSLocalizedString("Teach children the importance of staying away from streets.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "🚶‍♀️", title: NSLocalizedString("Use Sidewalks", comment: ""), description: NSLocalizedString("Always walk on sidewalks or face traffic if no sidewalk is available.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "🚦", title: NSLocalizedString("Understand Traffic Signals", comment: ""), description: NSLocalizedString("Explain the meanings of red, yellow, and green lights.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "🚗", title: NSLocalizedString("Exit Cars Safely", comment: ""), description: NSLocalizedString("Always exit vehicles away from traffic.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "🚴‍♀️", title: NSLocalizedString("Wear Helmets", comment: ""), description: NSLocalizedString("Ensure helmets are worn when biking or skateboarding.", comment: "")).accessibilityElement(children: .combine)
                    SafetyTipView3(icon: "💡", title: NSLocalizedString("Additional Tips", comment: ""), description: NSLocalizedString("Always wear seatbelts, be alert to horns, and let vehicles pass safely.", comment: "")).accessibilityElement(children: .combine)
                }
            }
            .padding()
        }
    }
}

// Course 403: At-Home Safety Rules
struct Course403: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("At-Home Safety Rules")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                                    SafetyTipView3(icon: "📞", title: NSLocalizedString("Emergency Contacts", comment: ""), description: NSLocalizedString("Children should know emergency contacts and memorize parents’ phone numbers.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🚪", title: NSLocalizedString("Get Permission to Leave", comment: ""), description: NSLocalizedString("Always ask for permission before leaving the house.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🚫", title: NSLocalizedString("Avoid Opening Doors to Strangers", comment: ""), description: NSLocalizedString("Teach children to verify who is at the door and not open it to unknown people.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🔥", title: NSLocalizedString("No Playing with Fire or Water", comment: ""), description: NSLocalizedString("Educate about fire hazards and water safety.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "❌", title: NSLocalizedString("No Climbing on High Surfaces", comment: ""), description: NSLocalizedString("Warn against jumping on furniture or climbing on shelves.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "📚", title: NSLocalizedString("Safe At-Home Learning", comment: ""), description: NSLocalizedString("Ensure the learning environment is child-friendly.", comment: "")).accessibilityElement(children: .combine)
                                }
            }
            .padding()
        }
    }
}

// Course 404: Safety Rules About Strangers
struct Course404: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Safety Rules About Strangers")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                                    SafetyTipView3(icon: "🚫", title: NSLocalizedString("Be Wary of Strangers", comment: ""), description: NSLocalizedString("Don’t accept offers or go with strangers. Report any suspicious behavior.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "👨‍👩‍👧", title: NSLocalizedString("Always Tell Parents", comment: ""), description: NSLocalizedString("Encourage open communication about interactions with adults.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "↔️", title: NSLocalizedString("Maintain Distance", comment: ""), description: NSLocalizedString("Keep a safe distance from unknown adults asking for help.", comment: "")).accessibilityElement(children: .combine)
                                }
                                
                                Text(NSLocalizedString("General Safety", comment: ""))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(CustomColor.redBackground)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    SafetyTipView3(icon: "🆘", title: NSLocalizedString("What to Do if Lost", comment: ""), description: NSLocalizedString("Stay calm, stay where they are, and seek help from a trusted adult if lost.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "📞", title: NSLocalizedString("Know Contact Information", comment: ""), description: NSLocalizedString("Memorize parents’ full names, address, and phone numbers.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "✋", title: NSLocalizedString("Good Touch vs. Bad Touch", comment: ""), description: NSLocalizedString("Educate about appropriate and inappropriate touch and report any bad touch immediately.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "💻", title: NSLocalizedString("Internet Safety", comment: ""), description: NSLocalizedString("Don’t share personal information online and report suspicious behavior.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "🌊", title: NSLocalizedString("Safety Around Water Bodies", comment: ""), description: NSLocalizedString("Never swim alone and always have adult supervision.", comment: "")).accessibilityElement(children: .combine)
                                    SafetyTipView3(icon: "☀️", title: NSLocalizedString("Sun Safety", comment: ""), description: NSLocalizedString("Wear sunscreen or appropriate clothing on sunny days.", comment: "")).accessibilityElement(children: .combine)
                                }
                            }
            .padding()
        }
    }
}

struct Course405: View {
    @State private var selectedAnswer1: Int? = nil
    @State private var showResult1: Bool = false
    @State private var selectedAnswer2: Int? = nil
    @State private var showResult2: Bool = false
    @State private var selectedAnswer3: Int? = nil
    @State private var showResult3: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Safety and Security Quiz")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                // Question 1
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 1: What is the recommended age for children to walk alone to school?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer1 = index
                            showResult1 = true
                        }) {
                            Text(question1Options(index))
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
                    Text("Question 2: What should children do if they encounter strangers while walking alone?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer2 = index
                            showResult2 = true
                        }) {
                            Text(question2Options(index))
                                .padding()
                                .background(selectedAnswer2 == index ? (selectedAnswer2 == 3 ? Color.green : Color.white) : Color.white)
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
                            .foregroundColor(selectedAnswer2 == 3 ? .green : .red)
                            .padding(.top, 20)
                    }
                }
                
                Divider()
                
                // Question 3
                VStack(alignment: .leading, spacing: 10) {
                    Text("Question 3: What is an important safety rule for children when using the internet?")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(1..<5) { index in
                        Button(action: {
                            selectedAnswer3 = index
                            showResult3 = true
                        }) {
                            Text(question3Options(index))
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
    
    private func question1Options(_ index: Int) -> String {
        switch index {
        case 1:
            return NSLocalizedString("7 years old", comment: "")
        case 2:
            return NSLocalizedString("12 years old", comment: "")
        case 3:
            return NSLocalizedString("10 years old", comment: "")
        case 4:
            return NSLocalizedString("15 years old", comment: "")
        default:
            return ""
        }
    }
    
    private func question2Options(_ index: Int) -> String {
        switch index {
        case 1:
            return NSLocalizedString("Accept gifts from strangers", comment: "")
        case 2:
            return NSLocalizedString("Run away from strangers", comment: "")
        case 3:
            return NSLocalizedString("Report any suspicious behavior and never accept rides from strangers", comment: "")
        case 4:
            return NSLocalizedString("Introduce themselves to strangers", comment: "")
        default:
            return ""
        }
    }
    
    private func question3Options(_ index: Int) -> String {
        switch index {
        case 1:
            return NSLocalizedString("Share personal information online", comment: "")
        case 2:
            return NSLocalizedString("Meet strangers from the internet alone", comment: "")
        case 3:
            return NSLocalizedString("Report any suspicious behavior", comment: "")
        case 4:
            return NSLocalizedString("Don't share personal information online", comment: "")
        default:
            return ""
        }
    }
    
    private func resultText1() -> String {
        return selectedAnswer1 == 3 ? NSLocalizedString("Correct! 10 years old is the recommended age for children to walk alone to school.", comment: "") : NSLocalizedString("Incorrect. The recommended age for children to walk alone to school is around 10 years old.", comment: "")
    }
    
    private func resultText2() -> String {
        return selectedAnswer2 == 3 ? NSLocalizedString("Correct! Children should report any suspicious behavior and never accept rides from strangers.", comment: "") : NSLocalizedString("Incorrect. Children should report any suspicious behavior and never accept rides from strangers.", comment: "")
    }
    
    private func resultText3() -> String {
        return selectedAnswer3 == 4 ? NSLocalizedString("Correct! Children should not share personal information online.", comment: "") : NSLocalizedString("Incorrect. Children should not share personal information online.", comment: "")
    }
}
