//
//  TipsView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 16/06/24.
//
import SwiftUI

struct TipsView: View {
    
    @ObservedObject var timerManager: TimerManager
    @State var scrolled: Int = 0
    @State var tips: [Tip] = [
        Tip(id: 0, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Carry Non-Violent Deterrents", comment: ""), corpo: NSLocalizedString("A loud alarm can draw attention and deter attackers. Ensure any deterrents you carry are legal in your area.", comment: "")),
        Tip(id: 1, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("If Followed by Another Car", comment: ""), corpo: NSLocalizedString("If another car is following you, do not drive home. Go to a police station or a well-lit, busy area.", comment: "")),
        Tip(id: 2, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Avoid Intoxication Alone", comment: ""), corpo: NSLocalizedString("If intoxicated, ensure a friend accompanies you home.", comment: "")),
        Tip(id: 3, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Engage with Surroundings", comment: ""), corpo: NSLocalizedString("Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you.", comment: "")),
        Tip(id: 4, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Keep Your Phone Accessible", comment: ""), corpo: NSLocalizedString("Try to always have your phone in handy in case of need, always keep an eye on the battery level.", comment: "")),
        Tip(id: 5, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Walk on Sidewalks", comment: ""), corpo: NSLocalizedString("Walk on sidewalks or, if unavailable, facing traffic on the road's edge, so that you can always see the incoming cars.", comment: "")),
        Tip(id: 6, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Contact Authorities", comment: ""), corpo: NSLocalizedString("If you feel threatened, call the police. Inform them of your location and situation. Also, inform friends or family in case of need with our application.", comment: "")),
        Tip(id: 7, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Avoid Suspicious Things", comment: ""), corpo: NSLocalizedString("Stick to well-lit, busy places. Avoid shortcuts through dark alleys or parks. Stay alert for anything that feels off.", comment: "")),
        Tip(id: 8, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Observe and Note Details", comment: ""), corpo: NSLocalizedString("Remember details about the follower or their vehicle, like appearance, clothing, or license plate.", comment: "")),
        Tip(id: 9, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Appear Confident", comment: ""), corpo: NSLocalizedString("Walk with your head high, maintain good posture, and appear purposeful.", comment: "")),
        Tip(id: 10, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Walk Together", comment: ""), corpo: NSLocalizedString("Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards.", comment: "")),
        Tip(id: 11, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Walk Confidently", comment: ""), corpo: NSLocalizedString("Walk confidently trying not to look disoriented or unfamiliar with the surroundings, walk at a steady pace but without running.", comment: "")),
        Tip(id: 12, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Bright Clothes", comment: ""), corpo: NSLocalizedString("Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective.", comment: "")),
        Tip(id: 13, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Alternatives", comment: ""), corpo: NSLocalizedString("Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed.", comment: "")),
        Tip(id: 14, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Mobile Phones", comment: ""), corpo: NSLocalizedString("Consider giving your child a phone to contact you in emergencies with our app installed. Teach them how to use it responsibly and practice emergency procedures.", comment: "")),
        Tip(id: 15, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Use Crosswalks", comment: ""), corpo: NSLocalizedString("Use pedestrian crossings and obey traffic signals, this will help you decrease the possibilities of an accident.", comment: "")),
        Tip(id: 16, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Know Safe Adults", comment: ""), corpo: NSLocalizedString("Know safe adults they can turn to if they feel uncomfortable or in danger, they can be family friends or school workers.", comment: "")),
        Tip(id: 17, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("No Headphones", comment: ""), corpo: NSLocalizedString("Discourage the use of headphones while walking to ensure they remain alert to their surroundings.", comment: "")),
        Tip(id: 18, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Walk on Sidewalks", comment: ""), corpo: NSLocalizedString("Walk on sidewalks or, if unavailable, facing traffic on the road's edge, so that you can always see the incoming cars.", comment: "")),
        Tip(id: 19, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Set a Limit", comment: ""), corpo: NSLocalizedString("Decide on a drinking limit beforehand with a friend of yours.", comment: "")),
        Tip(id: 20, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Eat a Meal", comment: ""), corpo: NSLocalizedString("Eating before drinking slows alcohol absorption, this will help you not feel overwhelmed by alcohol.", comment: "")),
        Tip(id: 21, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Make a Plan", comment: ""), corpo: NSLocalizedString("Plan your way home, keep your phone charged, or bring a power bank with you.", comment: "")),
        Tip(id: 22, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Stick with Friends", comment: ""), corpo: NSLocalizedString("Stay with friends to reduce the risk of incidents and injuries.", comment: "")),
        Tip(id: 23, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Alternate Drinks", comment: ""), corpo: NSLocalizedString("Drink water or soft drinks between alcoholic beverages, this will help you diluting the alcohol.", comment: "")),
        Tip(id: 24, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Safe Transport", comment: ""), corpo: NSLocalizedString("Pre-book a taxi or use a trusted rideshare service to ensure you have a safe way to get home after a night out.", comment: "")),
        Tip(id: 25, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Drink Responsibly", comment: ""), corpo: NSLocalizedString("Pace yourself and know your limits when drinking to avoid putting yourself in vulnerable situations.", comment: "")),
        Tip(id: 26, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Stay Aware", comment: ""), corpo: NSLocalizedString("Avoid talking on the phone or wearing earphones when walking alone.", comment: "")),
        Tip(id: 27, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Sit Near the Front", comment: ""), corpo: NSLocalizedString("Move towards the front of the bus or train where the driver or conductor can see you.", comment: "")),
        Tip(id: 28, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Regular Checkups", comment: ""), corpo: NSLocalizedString("Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well.", comment: "")),
        Tip(id: 29, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Healthy Lifestyle", comment: ""), corpo: NSLocalizedString("Maintain a healthy diet and avoid activities that strain your body, like smoking.", comment: "")),
        Tip(id: 30, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Reflective Gear", comment: ""), corpo: NSLocalizedString("Make sure your child wears reflective gear to increase their visibility during night time or in low-light conditions.", comment: "")),
        Tip(id: 31, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Emergency Plan", comment: ""), corpo: NSLocalizedString("Create an emergency plan with your child, including who to contact and where to go in case of an emergency.", comment: "")),
        Tip(id: 32, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Buddy System", comment: ""), corpo: NSLocalizedString("Use the buddy system when going out to ensure you always have someone looking out for you.", comment: "")),
        Tip(id: 33, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Stranger Danger", comment: ""), corpo: NSLocalizedString("Teach your child about stranger danger and what to do if approached by someone they do not know.", comment: "")),
        Tip(id: 34, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Personal Alarm", comment: ""), corpo: NSLocalizedString("Carry a personal alarm that you can use to attract attention if you feel threatened.", comment: "")),
        Tip(id: 35, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Know Your Surroundings", comment: ""), corpo: NSLocalizedString("Familiarize yourself with the area you are walking in, including knowing where safe places are in case you need help.", comment: "")),
        Tip(id: 36, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Stay in Touch", comment: ""), corpo: NSLocalizedString("Regularly update someone you trust about your whereabouts and travel plans, especially when traveling alone.", comment: "")),
        Tip(id: 37, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Know Emergency Numbers", comment: ""), corpo: NSLocalizedString("Always know the local emergency numbers and keep them handy in case of an emergency.", comment: "")),
        Tip(id: 38, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Trust Your Instincts", comment: ""), corpo: NSLocalizedString("If something feels off or unsafe, trust your instincts and remove yourself from the situation as quickly as possible.", comment: "")),
        Tip(id: 39, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Self-Defense Training", comment: ""), corpo: NSLocalizedString("Consider taking a self-defense class to learn techniques that can help you protect yourself in dangerous situations.", comment: "")),
        Tip(id: 40, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Use Technology", comment: ""), corpo: NSLocalizedString("Utilize safety apps and features on your phone, such as location sharing and emergency alerts.", comment: "")),
        Tip(id: 41, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Avoid Distractions", comment: ""), corpo: NSLocalizedString("Stay focused and avoid distractions such as using your phone or listening to music when walking alone.", comment: "")),
        Tip(id: 42, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Teach Road Safety", comment: ""), corpo: NSLocalizedString("Educate your child on road safety rules, including how to cross streets safely and understanding traffic signals.", comment: "")),
        Tip(id: 43, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Keep Valuables Safe", comment: ""), corpo: NSLocalizedString("Keep your valuables secure and avoid displaying expensive items when out at night.", comment: "")),
        Tip(id: 44, categoria: NSLocalizedString("Self Defense", comment: ""), titolo: NSLocalizedString("Use Technology", comment: ""), corpo: NSLocalizedString("Utilize safety apps and features on your phone, such as location sharing and emergency alerts.", comment: "")),
        Tip(id: 45, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("Teach Road Safety", comment: ""), corpo: NSLocalizedString("Educate your child on road safety rules, including how to cross streets safely and understanding traffic signals.", comment: "")),
        Tip(id: 46, categoria: NSLocalizedString("Children Safety", comment: ""), titolo: NSLocalizedString("No Headphones", comment: ""), corpo: NSLocalizedString("Discourage the use of headphones while walking to ensure they remain alert to their surroundings.", comment: "")),
        Tip(id: 47, categoria: NSLocalizedString("Walking Alone", comment: ""), titolo: NSLocalizedString("Plan Your Route", comment: ""), corpo: NSLocalizedString("Before leaving, choose well-lit streets with lots of people and open stores. Share your travel plan with someone you trust.", comment: "")),
        Tip(id: 48, categoria: NSLocalizedString("Night Out", comment: ""), titolo: NSLocalizedString("Stick with Friends", comment: ""), corpo: NSLocalizedString("Stay with friends to reduce the risk of incidents and injuries.", comment: ""))
    ]

    
    func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 30
        let width = screen - (2 * 32.5)
        return width
    }
    
    @State var first: Int = 0
    @State var last: Int = 3
    
    func update() {
        let day = Calendar.current.component(.day, from: Date())
        
        if day <= (tips.count - 1) / 3 {
            first = (day - 1) * 3
            last = day * 3
            
            if last > tips.count {
                first = 0
                last = 3
            }
            
        } else {
            first += (day/2) * 3
            last += (day/2) * 3
            if last > tips.count {
                first = 0
                last = 3
            }
        }
        
        UserDefaults.standard.set(first, forKey: "first")
        UserDefaults.standard.set(last, forKey: "last")
    }
    
    func loadState() {
        if let savedFirst = UserDefaults.standard.value(forKey: "first") as? Int,
           let savedLast = UserDefaults.standard.value(forKey: "last") as? Int {
            first = savedFirst
            last = savedLast
        } else {
            update()
        }
    }
    
    var body: some View {
        ZStack {
            if timerManager.isActivated{
                LinearGradient(
                    gradient: Gradient(colors: [CustomColor.redBackground, CustomColor.redBackground, CustomColor.redBackground, .white]),
                    startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    .ignoresSafeArea()
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.orange, Color.orange, .white]),
                    startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    .ignoresSafeArea()
            }
            
            ZStack {
                ForEach(tips[first..<last].reversed()) { tip in
                    VStack {
                        HStack {
                            Text("Tips & Tricks")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal, 45)
                        if tip.id == first + scrolled {
                            HStack {
                                Text(tip.categoria)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal, 45)
                        }
                        Spacer()
                    }.padding(.top, 50)
                    VStack {
                        Card(titolo: tip.titolo,
                             testo: tip.corpo,
                             symbol: tip.id == tips.prefix(last).last!.id ? "timer" : "arrow.left",
                             info: tip.id == tips.prefix(last).last!.id ? NSLocalizedString("wait until tomorrow for more tips", comment: "") : NSLocalizedString("swipe left to read more", comment: ""))
                        .offset(x: CGFloat((tip.id - (first + scrolled)) * 10))
                        .opacity(Double(1.0 - CGFloat(tip.id - (first + scrolled)) * 0.6))
                        .gesture(DragGesture().onChanged({ value in
                            withAnimation {
                                if tip.id == first + scrolled {
                                    if value.translation.width < 0 && tip.id != tips.prefix(last).last!.id {
                                        tips[tip.id].offset = value.translation.width
                                    }
                                }
                            }
                        }).onEnded({ value in
                            withAnimation {
                                if tip.id == first + scrolled {
                                    if value.translation.width < 0 {
                                        if value.translation.width < -100 && tip.id != tips.prefix(last).last!.id {
                                            tips[tip.id].offset = -(calculateWidth() + 60)
                                            scrolled += 1
                                        } else {
                                            tips[tip.id].offset = 0
                                        }
                                    } else {
                                        if tip.id != last && tip.id != first{
                                            tips[tip.id - 1].offset = 0
                                            scrolled -= 1
                                        } else {
                                            tips[tip.id].offset = 0
                                        }
                                    }
                                }
                            }
                        }))
                    }.offset(x: tip.offset)
                        .padding(.top, 60)
                }
            }
        }.onAppear{
            loadState()
        }
    }
}

struct ContentView_Previews838: PreviewProvider {
    static var previews: some View {
        TipsView(timerManager: TimerManager())
    }
}
