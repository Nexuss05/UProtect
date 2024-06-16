//
//  TipsView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 16/06/24.
//
import SwiftUI

struct TipsView: View {
    
    @State var scrolled: Int = 0
    @State var tips: [Tip] = [ Tip(id: 0, categoria: "Safety", titolo: "Appear Confident", corpo: "Walk with your head high, maintain good posture, and appear purposeful."), Tip(id: 1, categoria: "Safety", titolo: "Mind Your Hair", corpo: "Avoid hairstyles that can be easily grabbed, like ponytails."), Tip(id: 2, categoria: "Safety", titolo: "Avoid Intoxication Alone", corpo: "If intoxicated, ensure a friend accompanies you home."), Tip(id: 3, categoria: "Safety", titolo: "Park in Well-Lit Areas", corpo: "Avoid dark parking spots, which provide cover for predators."), Tip(id: 4, categoria: "Safety", titolo: "Stay Aware of Your Surroundings", corpo: "Avoid talking on the phone or wearing earphones when walking alone."), Tip(id: 5, categoria: "Safety", titolo: "Regular Checkups", corpo: "Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well."), Tip(id: 6, categoria: "Safety", titolo: "Healthy Lifestyle", corpo: "Maintain a healthy diet and avoid activities that strain your body, like smoking."), Tip(id: 7, categoria: "Safety", titolo: "Engage with Surroundings", corpo: "Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you."), Tip(id: 8, categoria: "Safety", titolo: "Plan Your Route", corpo: "Before leaving, choose well-lit streets with lots of people and open stores. Share your travel plan with someone you trust."), Tip(id: 9, categoria: "Safety", titolo: "Share Your Plan", corpo: "Inform a family member or friend of your route and expected arrival time. They can check on you if they don't hear from you."),Tip(id: 10, categoria: "Safety", titolo: "Carry Your Phone", corpo: "Keep your phone with you and fully charged. Consider carrying a power bank. Avoid using your phone for messages or music while walking."), Tip(id: 11, categoria: "Safety", titolo: "Avoid Suspicious Areas and People", corpo: "Stick to well-lit, busy places. Avoid shortcuts through dark alleys or parks. Stay alert for anything that feels off."), Tip(id: 12, categoria: "Safety", titolo: "Keep Your Hands Free", corpo: "You may need your hands for your phone or self-defense tools. Carry a small, light purse."), Tip(id: 13, categoria: "Safety", titolo: "Carry Non-Violent Deterrents", corpo: "A loud alarm can draw attention and deter attackers. Ensure any deterrents you carry are legal in your area."), Tip(id: 14, categoria: "Safety", titolo: "Learn Self-Defense", corpo: "Self-defense classes boost confidence and situational awareness, preparing you mentally and physically for stressful situations."),Tip(id: 15, categoria: "Safety", titolo: "Situational Awareness", corpo: "Stay alert and aware of your surroundings. Notice if a person or vehicle appears repeatedly."), Tip(id: 16, categoria: "Safety", titolo: "Frequent Glances", corpo: "Use reflective surfaces like windows or your phone screen to check for followers discreetly."), Tip(id: 17, categoria: "Safety", titolo: "Change Pace and Direction", corpo: "Alter your walking pattern. Speed up, slow down, or take several turns to see if the follower mirrors your movements."), Tip(id: 18, categoria: "Safety", titolo: "Do Not Head Straight Home", corpo: "Avoid leading a potential follower to your residence. Go to a public, well-lit, crowded place like a café, mall, or police station."), Tip(id: 19, categoria: "Safety", titolo: "Contact Authorities", corpo: "If you feel threatened, call the police. Inform them of your location and situation. Also, inform friends or family."), Tip(id: 20, categoria: "Safety", titolo: "Observe and Note Details", corpo: "Remember details about the follower or their vehicle, like appearance, clothing, or license plate."), Tip(id: 21, categoria: "Safety", titolo: "Make Noise and Seek Help", corpo: "Enter a store or crowded area and inform someone in charge. Drawing attention can deter a stalker."), Tip(id: 22, categoria: "Safety", titolo: "Share Your Itinerary", corpo: "Let someone you trust know your plans and expected arrival times. Use apps to share your live location with friends or family."), Tip(id: 23, categoria: "Safety", titolo: "Vary Your Routes", corpo: "Avoid predictable routines. Change your routes and travel times frequently."), Tip(id: 24, categoria: "Safety", titolo: "Use Technology", corpo: "Use personal safety apps with features like panic buttons that send your location and a distress message to contacts or authorities."), Tip(id: 25, categoria: "Safety", titolo: "Walk Confidently", corpo: "Walk confidently and at a steady pace."),Tip(id: 26, categoria: "Safety", titolo: "Avoid Isolated Areas", corpo: "Avoid isolated areas, especially at night."), Tip(id: 27, categoria: "Safety", titolo: "Keep Your Phone Accessible", corpo: "Keep your phone easily accessible."), Tip(id: 28, categoria: "Safety", titolo: "If Followed by Another Car", corpo: "If another car is following you, do not drive home. Go to a police station or a well-lit, busy area."), Tip(id: 29, categoria: "Safety", titolo: "Make Intentional Turns", corpo: "Make intentional turns to confirm if the same vehicle is still behind you."), Tip(id: 30, categoria: "Safety", titolo: "Avoid Stopping in Secluded Areas", corpo: "Avoid stopping in secluded areas."), Tip(id: 31, categoria: "Safety", titolo: "Sit Near the Front", corpo: "Move towards the front of the bus or train where the driver or conductor can see you."), Tip(id: 32, categoria: "Safety", titolo: "Get Off at Busy Stops", corpo: "If you feel unsafe, get off at a busy stop and wait for the next bus or train."), Tip(id: 33, categoria: "Safety", titolo: "Set a Limit", corpo: "Decide on a drinking limit beforehand."),Tip(id: 34, categoria: "Safety", titolo: "Eat a Meal", corpo: "Eating before drinking slows alcohol absorption."), Tip(id: 35, categoria: "Safety", titolo: "Alternate Drinks", corpo: "Drink water or soft drinks between alcoholic beverages."),Tip(id: 36, categoria: "Safety", titolo: "Have a Plan", corpo: "Plan your way home, keep your phone charged, or bring a power bank."), Tip(id: 37, categoria: "Safety", titolo: "Stick with Friends", corpo: "Stay with friends to reduce the risk of incidents and injuries."), Tip(id: 38, categoria: "Safety", titolo: "Bright Clothes", corpo: "Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective."), Tip(id: 39, categoria: "Safety", titolo: "Walk Together", corpo: "Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards."), Tip(id: 40, categoria: "Safety", titolo: "Alternatives", corpo: "Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed."), Tip(id: 41, categoria: "Safety", titolo: "Look Both Ways", corpo: "Always look both ways before crossing the street."), Tip(id: 42, categoria: "Safety", titolo: "Use Pedestrian Crossings", corpo: "Use pedestrian crossings and obey traffic signals."), Tip(id: 43, categoria: "Safety", titolo: "Walk on Sidewalks", corpo: "Walk on sidewalks or, if unavailable, facing traffic on the road's edge."), Tip(id: 44, categoria: "Safety", titolo: "Never Play or Run", corpo: "Never play or run into the street."), Tip(id: 45, categoria: "Safety", titolo: "Never Accept Rides", corpo: "Never accept rides or gifts from strangers."), Tip(id: 46, categoria: "Safety", titolo: "Know Safe Adults", corpo: "Know safe adults they can turn to if they feel uncomfortable or in danger."), Tip(id: 47, categoria: "Safety", titolo: "Mobile Phones", corpo: "Consider giving your child a phone to contact you in emergencies. Teach them how to use it responsibly and practice emergency procedures."), Tip(id: 48, categoria: "Safety", titolo: "Safe Spots", corpo: "Identify safe places along the route, like trusted neighbors' homes or businesses, where your child can seek help if needed."), Tip(id: 49, categoria: "Safety", titolo: "No Headphones", corpo: "Discourage the use of headphones while walking to ensure they remain alert to their surroundings."), Tip(id: 50, categoria: "Safety", titolo: "Identifying Safe Routes", corpo: "Choose routes that avoid isolated or poorly lit areas, busy roads without sidewalks, and other hazards.") ]
    
    func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 30
        let width = screen - (2 * 32.5)
        return width
    }
    
    var body: some View {
        ZStack {
            CustomColor.orange
                .ignoresSafeArea()
            
            ZStack {
                ForEach(tips.reversed()) { tip in
                    VStack {
                        HStack {
                            Text("Tips & Tricks")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal, 45)
                        if tip.id == scrolled {
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
                             symbol: tip.id == tips.last!.id ? "timer" : "arrow.left",
                             info: tip.id == tips.last!.id ? "wait until tomorrow for more tips" : "swipe left to read more")
                        .offset(x: CGFloat((tip.id - scrolled) * 10))
                        .opacity(Double(1.0 - CGFloat(tip.id - scrolled) * 0.6))
                        .gesture(DragGesture().onChanged({ value in
                            withAnimation {
                                if tip.id == scrolled {
                                    if value.translation.width < 0 && tip.id != tips.last!.id {
                                        tips[tip.id].offset = value.translation.width
                                    }
                                }
                            }
                        }).onEnded({ value in
                            withAnimation {
                                if tip.id == scrolled {
                                    if value.translation.width < 0 {
                                        if value.translation.width < -100 && tip.id != tips.last!.id {
                                            tips[tip.id].offset = -(calculateWidth() + 60)
                                            scrolled += 1
                                        } else {
                                            tips[tip.id].offset = 0
                                        }
                                    } else {
                                        if tip.id != 0 {
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
                }
            }
        }
    }
}

#Preview {
    TipsView()
}
