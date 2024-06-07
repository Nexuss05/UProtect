//
//  CoursesStructs3.swift
//  UProtect
//
//  Created by Andrea Romano on 07/06/24.
//

import Foundation
import SwiftUI

struct Course301: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Helping Someone Who Drank Too Much")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("""
                Understanding Alcohol Poisoning: alcohol is a **toxic** substance, and excessive consumption can lead to **severe** health issues, including alcohol poisoning. This occurs when someone drinks a large amount of alcohol in a short period, leading to high blood alcohol concentration. Symptoms include slowed brain function, stomach irritation, dehydration, and more.
                """)
                
                Text("Prevention Tips:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    SafetyTipView2(icon: "❗️", title: "Set a Limit", description: "Decide on a drinking limit beforehand.")
                                        SafetyTipView2(icon: "🍝", title: "Eat a Meal", description: "Eating before drinking slows alcohol absorption.")
                                        SafetyTipView2(icon: "🥤", title: "Alternate Drinks", description: "Drink water or soft drinks between alcoholic beverages.")
                                        SafetyTipView2(icon: "💡", title: "Have a Plan", description: "Plan your way home, keep your phone charged, or bring a power bank.")
                                        SafetyTipView2(icon: "👥", title: "Stick with Friends", description: "Stay with friends to reduce the risk of incidents and injuries.")
                }
                .padding()
            }
            .padding()
        }
    }
}

struct Course302: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Signs and Symptoms of Alcohol Poisoning:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("- Confusion")
                    Text("- Slurred speech")
                    Text("- Loss of coordination")
                    Text("- Vomiting")
                    Text("- Slow or irregular breathing")
                    Text("- Blue-tinged skin")
                    Text("- Conscious but unresponsive")
                    Text("- Passing out or unconsciousness")
                }
                
                Text("Steps to Help Someone:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("**1. Keep Them Awake and Sitting Up**: Try to keep the person awake and seated.")
                    Text("**2. Give Them Water**: If they can drink, provide water to keep them hydrated.")
                    Text("**3. Recovery Position**: If they pass out, lay them on their side in the recovery position and check their breathing.")
                    Text("**4. Keep Them Warm**: Ensure they stay warm.")
                    Text("**5. Monitor Symptoms**: Stay with them and monitor their condition.")
                }
                
                Text("What Not to Do:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    SafetyTipView2(icon: "🤝", title: "Never Leave Them Alone", description: "Do not leave the person to sleep it off.")
                    SafetyTipView2(icon: "❌☕️", title: "Avoid Coffee", description: "Alcohol dehydrates the body, and coffee can exacerbate this.")
                    SafetyTipView2(icon: "❌🤮", title: "Do Not Induce Vomiting", description: "This can cause choking.")
                   SafetyTipView2(icon: "❌🚿", title: "No Cold Showers", description: "Moving someone with alcohol poisoning can cause injury, and a cold shower can lower their body temperature further.")
                SafetyTipView2(icon: "❌🍷", title: "No More Alcohol", description: "Do not let them drink more alcohol.")
                    Text("_**Emergency Help**_: Always call your local emergency number if you suspect someone has alcohol poisoning.")
                }
                .padding()
            }
            .padding()
        }
    }
}

struct Course303: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Helping Someone Who Is Too High from Weed")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("""
                Understanding Cannabis Effects: the high from marijuana is due to THC, which **affects brain receptors**. Even if it feels overwhelming, it's important to remember that it’s temporary and not life-threatening. No deaths have been reported from cannabis overdose.
                """)
                
                Text("Symptoms of Being Too High:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("- Anxiety")
                    Text("- Nausea")
                    Text("- Dizziness")
                    Text("- Panic")
                    Text("- Paranoia")
                    Text("- Confusion")
                    Text("- Excessive perspiration")
                }
                
                Text("Steps to Help Someone:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("**1. Stay Calm**: Most symptoms will pass within minutes to hours.")
                    Text("**2. Hydrate**: Offer water or juice, avoiding caffeinated or alcoholic beverages.")
                    Text("**3. Know Your Limits**: Be aware of personal limits to prevent future overconsumption.")
                    Text("**4. Black Pepper**: Chewing or smelling black pepper can help reduce anxiety, though this is anecdotal.")
                    Text("**5. Calm Environment**: Find a quiet space for the person to rest and take deep breaths.")
                    Text("**6. Go for a Walk**: Fresh air and a change of scenery can help, but stay close to known surroundings.")
                    Text("**7. Shower or Bath**: A warm shower or bath can help relax the body and mind.")
                    Text("**8. Distract with Activities**: Engage in relaxing activities like watching a cartoon, listening to music, playing a video game, or talking with a friend.")
                    Text("**9. Edibles**: Effects from edibles last longer. Stay calm, hydrated, and distracted.")
                    Text("**10. Emergency Help**: If symptoms are severe, call the local emergency number for assistance.")
                }
                .padding()
            }
            .padding()
        }
    }
}

struct Course304: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Clubbing Safety Tips")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                Text("Do’s:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("**1. Plan Ahead**: Research the club’s dress code, policies, and cover charges. Arrive early to avoid long lines.")
                    Text("**2. Dress Comfortably**: Wear stylish yet comfortable clothes and suitable shoes for dancing.")
                    Text("**3. Bring Essentials**: Carry your ID, some cash, and your phone. A small bag or clutch is ideal.")
                    Text("**4. Stay Hydrated**: Alternate between alcoholic drinks and water.")
                    Text("**5. Stick with Friends**: Use a buddy system to stay safe and support each other.")
                }
                
                Text("Don’ts:")
                    .font(.headline)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("**1. Avoid Overdrinking**: Know your alcohol limits to prevent risks.")
                    Text("**2. Don’t Go Alone**: Always club with friends.")
                    Text("**3. Guard Your Belongings**: Keep an eye on your items and avoid bringing unnecessary valuables.")
                    Text("**4. Watch Your Drinks**: Never leave drinks unattended.")
                }
                
                Text("General Advice:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    SafetyTipView2(icon: "😃", title: "Enjoy Yourself", description: "Embrace the music, dancing, and social aspects.")
                    SafetyTipView2(icon: "✅", title: "Prioritize Safety", description: "Trust your instincts, avoid conflicts, and have a safe and reliable way to get home.")
                }
                
                Text("Enjoying a Safe Night Out:")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.redBackground)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("**1. Stay in Groups**: Being in a group reduces the likelihood of being targeted.")
                    Text("**2. Arrange Transportation**: Get a ride from a trusted person or book a taxi.")
                    Text("**3. Book Licensed Taxis**: Use only licensed mini-cabs or black cabs.")
                    Text("**4. Drink Responsibly**: Keep an eye on your drink and avoid accepting vapes from strangers.")
                    Text("**5. Stay in Well-Lit Areas**: Choose well-lit, populated routes when walking home.")
                    Text("**6. Conceal Valuables**: Keep valuables hidden to avoid attracting thieves.")
                    Text("**7. Avoid Conflicts**: Stay away from fights or arguments, and seek help from bouncers or the police if needed.")
                    Text("_For any suspicious activity, **report it** to your local emergency number._")
                }
                .padding()
            }
            .padding()
        }
    }
}

struct SafetyTipView2: View {
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


struct Course305: View {
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
                    Text("Question 1: What should you do to help someone who drank too much?")
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
                    Text("Question 2: What are the signs and symptoms of alcohol poisoning?")
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
                    Text("Question 3: What steps should you take to help someone who is too high from weed?")
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
    
    // Question 1 Options
    private func question1Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Induce vomiting"
        case 2: return "B. Leave them alone to sleep it off"
        case 3: return "C. Keep them awake and sitting up"
        case 4: return "D. Give them more alcohol"
        default: return ""
        }
    }
    
    // Question 2 Options
    private func question2Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Confusion"
        case 2: return "B. Dizziness"
        case 3: return "C. Passing out or unconsciousness"
        case 4: return "D. Excessive perspiration"
        default: return ""
        }
    }
    
    // Question 3 Options
    private func question3Options(_ index: Int) -> String {
        switch index {
        case 1: return "A. Encourage them to use more weed"
        case 2: return "B. Call emergency services immediately"
        case 3: return "C. Leave them alone until they feel better"
        case 4: return "D. Stay calm, hydrate, and distract"
        default: return ""
        }
    }
    
    // Result Texts
    private func resultText1() -> String {
        if selectedAnswer1 == 3 {
            return "Correct! Keeping them awake and sitting up is recommended."
        } else {
            return "Incorrect. Keeping them awake and sitting up is recommended."
        }
    }
    
    private func resultText2() -> String {
        if selectedAnswer2 == 1 {
            return "Correct! Confusion is one of the signs of alcohol poisoning."
        } else {
            return "Incorrect. Confusion is one of the signs of alcohol poisoning."
        }
    }
    
    private func resultText3() -> String {
        if selectedAnswer3 == 4 {
            return "Correct! Staying calm, hydrating, and distracting can help someone who is too high from weed."
        } else {
            return "Incorrect. Staying calm, hydrating, and distracting can help someone who is too high from weed."
        }
    }
}
