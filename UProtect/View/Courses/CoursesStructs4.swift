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
                    SafetyTipView3(icon: "👕", title: "Bright Clothes", description: "Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective.")
                    SafetyTipView3(icon: "👥", title: "Walk Together", description: "Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards.")
                    SafetyTipView3(icon: "🧠", title: "Alternatives", description: "Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed.")
                    
                    Text("**Road Safety Rules**: Teach children road safety basics, such as:")
                    VStack(alignment: .leading, spacing: 5) {
                        SafetyTipView3(icon: "👀", title: "Look Both Ways", description: "Always look both ways before crossing the street.")
                        SafetyTipView3(icon: "🚸", title: "Use Pedestrian Crossings", description: "Use pedestrian crossings and obey traffic signals.")
                        SafetyTipView3(icon: "🚶‍♀️", title: "Walk on Sidewalks", description: "Walk on sidewalks or, if unavailable, facing traffic on the road's edge.")
                        SafetyTipView3(icon: "❌🏃‍♀️", title: "Never Play or Run", description: "Never play or run into the street.")
                    }
                    
                    Text("**Stranger Danger**: Educate your child on how to handle situations with strangers:")
                    VStack(alignment: .leading, spacing: 5) {
                        SafetyTipView3(icon: "❌👨", title: "Never Accept Rides", description: "Never accept rides or gifts from strangers.")
                        SafetyTipView3(icon: "✅👨‍🦳", title: "Know Safe Adults", description: "Know safe adults they can turn to if they feel uncomfortable or in danger.")
                    }
                    
                    SafetyTipView3(icon: "📱", title: "Mobile Phones", description: "Consider giving your child a phone to contact you in emergencies. Teach them how to use it responsibly and practice emergency procedures.")
                    SafetyTipView3(icon: "🏡", title: "Safe Spots", description: "Identify safe places along the route, like trusted neighbors' homes or businesses, where your child can seek help if needed.")
                    SafetyTipView3(icon: "🎧", title: "No Headphones", description: "Discourage the use of headphones while walking to ensure they remain alert to their surroundings.")
                    SafetyTipView3(icon: "🗺", title: "Identifying Safe Routes", description: "Choose routes that avoid isolated or poorly lit areas, busy roads without sidewalks, and other hazards.")
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
                    SafetyTipView3(icon: "👀", title: "Look Before Crossing", description: "Hold an adult's hand, look left, right, and left again before crossing.")
                    SafetyTipView3(icon: "🚫", title: "Don’t Play on the Road", description: "Teach children the importance of staying away from streets.")
                    SafetyTipView3(icon: "🚶‍♀️", title: "Use Sidewalks", description: "Always walk on sidewalks or face traffic if no sidewalk is available.")
                    SafetyTipView3(icon: "🚦", title: "Understand Traffic Signals", description: "Explain the meanings of red, yellow, and green lights.")
                    SafetyTipView3(icon: "🚗", title: "Exit Cars Safely", description: "Always exit vehicles away from traffic.")
                    SafetyTipView3(icon: "🚴‍♀️", title: "Wear Helmets", description: "Ensure helmets are worn when biking or skateboarding.")
                    SafetyTipView3(icon: "💡", title: "Additional Tips", description: "Always wear seatbelts, be alert to horns, and let vehicles pass safely.")
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
                    SafetyTipView3(icon: "📞", title: "Emergency Contacts", description: "Children should know emergency contacts and memorize parents’ phone numbers.")
                    SafetyTipView3(icon: "🚪", title: "Get Permission to Leave", description: "Always ask for permission before leaving the house.")
                    SafetyTipView3(icon: "🚫", title: "Avoid Opening Doors to Strangers", description: "Teach children to verify who is at the door and not open it to unknown people.")
                    SafetyTipView3(icon: "🔥", title: "No Playing with Fire or Water", description: "Educate about fire hazards and water safety.")
                    SafetyTipView3(icon: "❌", title: "No Climbing on High Surfaces", description: "Warn against jumping on furniture or climbing on shelves.")
                    SafetyTipView3(icon: "📚", title: "Safe At-Home Learning", description: "Ensure the learning environment is child-friendly.")
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
                    SafetyTipView3(icon: "🚫", title: "Be Wary of Strangers", description: "Don’t accept offers or go with strangers. Report any suspicious behavior.")
                    SafetyTipView3(icon: "👨‍👩‍👧", title: "Always Tell Parents", description: "Encourage open communication about interactions with adults.")
                    SafetyTipView3(icon: "↔️", title: "Maintain Distance", description: "Keep a safe distance from unknown adults asking for help.")
                }
                
                Text("General Safety")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    SafetyTipView3(icon: "🆘", title: "What to Do if Lost", description: "Stay calm, stay where they are, and seek help from a trusted adult if lost.")
                    SafetyTipView3(icon: "📞", title: "Know Contact Information", description: "Memorize parents’ full names, address, and phone numbers.")
                    SafetyTipView3(icon: "✋", title: "Good Touch vs. Bad Touch", description: "Educate about appropriate and inappropriate touch and report any bad touch immediately.")
                    SafetyTipView3(icon: "💻", title: "Internet Safety", description: "Don’t share personal information online and report suspicious behavior.")
                    SafetyTipView3(icon: "🌊", title: "Safety Around Water Bodies", description: "Never swim alone and always have adult supervision.")
                    SafetyTipView3(icon: "☀️", title: "Sun Safety", description: "Wear sunscreen or appropriate clothing on sunny days.")
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
            return "7 years old"
        case 2:
            return "12 years old"
        case 3:
            return "10 years old"
        case 4:
            return "15 years old"
        default:
            return ""
        }
    }

    private func question2Options(_ index: Int) -> String {
        switch index {
        case 1:
            return "Accept gifts from strangers"
        case 2:
            return "Run away from strangers"
        case 3:
            return "Report any suspicious behavior and never accept rides from strangers"
        case 4:
            return "Introduce themselves to strangers"
        default:
            return ""
        }
    }

    private func question3Options(_ index: Int) -> String {
        switch index {
        case 1:
            return "Share personal information online"
        case 2:
            return "Meet strangers from the internet alone"
        case 3:
            return "Report any suspicious behavior"
        case 4:
            return "Don't share personal information online"
        default:
            return ""
        }
    }

    private func resultText1() -> String {
        return selectedAnswer1 == 3 ? "Correct! 10 years old is the recommended age for children to walk alone to school." : "Incorrect. The recommended age for children to walk alone to school is around 10 years old."
    }

    private func resultText2() -> String {
        return selectedAnswer2 == 3 ? "Correct! Children should report any suspicious behavior and never accept rides from strangers." : "Incorrect. Children should report any suspicious behavior and never accept rides from strangers."
    }

    private func resultText3() -> String {
        return selectedAnswer3 == 4 ? "Correct! Children should not share personal information online." : "Incorrect. Children should not share personal information online."
    }
}

