//
//  CoursesView.swift
//  UProtect
//
//  Created by Andrea Romano on 26/05/24.
//

import SwiftUI

class Course: Identifiable, ObservableObject {
    let id: UUID
    let title: String
    let subtitle: String
    @Published var progress: CGFloat {
        didSet {
            saveProgress()
        }
    }
    
    init(id: UUID = UUID(), title: String, subtitle: String, progress: CGFloat) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.progress = progress
        loadProgress()
    }
    
    func saveProgress() {
        UserDefaults.standard.set(progress, forKey: id.uuidString)
    }
    
    func loadProgress() {
        if let savedProgress = UserDefaults.standard.value(forKey: id.uuidString) as? CGFloat {
            self.progress = savedProgress
        }
    }
}

struct CoursesView: View {
    @State private var courses: [Course] = [
        Course(title: "Course 01", subtitle: "Self defence", progress: 0/30.0),
        Course(title: "Course 02", subtitle: "Walking alone", progress: 0/30.0),
        Course(title: "Course 03", subtitle: "In the disco", progress: 0/30.0),
        Course(title: "Course 04", subtitle: "While travelling", progress: 0/30.0),
        Course(title: "Course 05", subtitle: "Prova", progress: 0/30.0)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Courses")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top])
                
                ScrollView {
                    ForEach($courses) { $course in
                        NavigationLink(destination: CourseDetailView(course: $course)) {
                            CourseRow(course: course)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 5)
                        }
                        .buttonStyle(PlainButtonStyle()) // To remove the default button style
                    }
                    Spacer()
                        .frame(height: 85)
                }
            }
            .background(CustomColor.orangeBackground)
        }
        .onAppear {
            loadCourses()
        }
    }
    func loadCourses() {
        for course in courses {
            course.loadProgress()
        }
    }
}

struct CourseRow: View {
    @ObservedObject var course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(course.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    Text(course.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 70)
                
                Spacer()
                
                
                if course.title == "Course 01" {
                    Lottiesss(loopmode: .loop)
                        .frame(width: 50, height: 50)
                        .scaleEffect(0.14)
                        .padding(.trailing, 30)
                        .padding(.bottom, 3)
                }
                else if course.title == "Course 03" {
                    Lottiess(loopmode: .loop)
                        .frame(width: 50, height: 50)
                        .scaleEffect(0.185)
                        .padding(.trailing, 30)
                        .padding(.bottom, 7)
                } else if course.title == "Course 02" {
                    Lotties(loopmode: .loop)
                        .frame(width: 50, height: 50)
                        .scaleEffect(0.165)
                        .padding(.trailing, 30)
                        .padding(.bottom, 7)
                } else {
                    LottieView(loopmode: .loop)
                        .frame(width: 50, height: 50)
                        .scaleEffect(0.28)
                        .padding(.trailing, 25)
                        .padding(.bottom, 10)
                }
            }
//            ProgressBar(progress: course.progress)
//                .padding(.top, 5)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.bottom, 10)
    }
}


import SwiftUI

struct CourseDetailView: View {
    @Binding var course: Course
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ScrollView {
                if course.title == "Course 01" {
                    Course01()
                } else if course.title == "Course 02"{
                    Course02()
                }
                else if course.title == "Course 03" {
                    Course03()
                } else if course.title == "Course 05" {
                    Corso1()
                        .ignoresSafeArea()
                }else {
                    Course04()
                }
            }
            
        }
        .background(CustomColor.orangeBackground)
        .navigationTitle(course.title)
    }
}

struct Course01: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("What Is Situational Awareness?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            Text("Situational awareness involves **perceiving** your environment, **understanding** its significance, and **predicting future events**. It's crucial for navigating daily dangers and is heavily relied upon in law enforcement, emergency response, military operations, aviation, nautical navigation, and sports. It's equally essential for everyday safety.")
            
            Text("Steps of Situational Awareness")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            VStack(alignment: .leading) {
                Text("1. Perceiving Elements:").fontWeight(.bold)
                Text("Notice sounds, smells, and visual cues in your environment. For example, at a train station, you might hear a loud bang, smell smoke, and see people fleeing.")
                
                Text("2. Attributing Meaning:").fontWeight(.bold)
                Text("Recognize that these elements, like smoke or running people, indicate potential danger. Understand their significance.")
                
                Text("3. Predicting Outcomes:").fontWeight(.bold)
                Text("Foresee possible threats and determine the best course of action, such as joining the crowd to escape danger.")
            }
            
            Text("Practicing and Developing Situational Awareness")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            Text("While humans naturally possess situational awareness due to innate survival instincts, it can be enhanced through vigilance, continuous practice, and improving cognitive abilities.")
            
            Text("Enhancing Perception")
                .font(.subheadline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text("🩺 _Regular Checkups_: Keep your senses sharp with regular medical checkups to ensure your vision, hearing, touch, smell, and taste are functioning well.")
                Text("🍏 _Healthy Lifestyle_: Maintain a healthy diet and avoid activities that strain your body, like smoking.")
                Text("🌍 _Engage with Surroundings_: Stay present and actively engage with your environment. Read distant signs, listen to nearby conversations, and be aware of subtle scents and sounds around you.")
            }
            
            Text("Attributing Meaning to Perceived Elements")
                .font(.subheadline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text("After perceiving elements, the next step is understanding their meaning by asking key questions:")
                Text("- **Who**: Who is the person? Is their body language open or nervous? Who are they with?")
                Text("- **What**: What are they doing? What actions are they taking? What are they wearing?")
                Text("- **When**: What is the time of day? Is it a busy weekday morning, or a quiet Saturday night?")
                Text("- **Where**: Where are you? What usually happens in this place?")
                Text("- **Why**: Why is the person acting this way? Why are they here at this time?")
                Text("- **How**: How did this person arrive here? How are they behaving?")
            }
            
            Text("Projecting Future Outcomes")
                .font(.subheadline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text("The final step involves processing all the information gathered and predicting future events:")
                Text("- _Context Matters_: Consider the entire context. For instance, a pregnant woman holding a pocket knife late at night may be protecting herself, not posing a threat.")
                Text("- _Behavioral Patterns_: Conversely, a young man with a face mask in a desolate area might raise alarms. Use context and other clues to predict potential threats accurately.")
            }
            
            Text("Additional Safety Tips")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                Text("😌 _Appear Confident_: Walk with your head high, maintain good posture, and appear purposeful. Predators often target those who seem timid or lost.")
                Text("💇🏻‍♀️ _Mind Your Hair_: Avoid hairstyles that can be easily grabbed, like ponytails. Wearing a cap can prevent such grabs.")
                Text("🧪 _Avoid Intoxication Alone_: If intoxicated, ensure a friend accompanies you home. Intoxicated individuals are more vulnerable targets.")
                Text("🅿️ _Park in Well-Lit Areas_: Avoid dark parking spots, which provide cover for predators. Always park in well-lit, busy areas.")
                Text("‼️ _Stay Aware of Your Surroundings_: Avoid talking on the phone or wearing earphones when walking alone. These distractions can reduce your awareness.")
            }
            
            Text("Importance of Training")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            Text("In emergencies, people rely on their **lowest level** of training. Training helps develop quick, effective solutions focusing on speed and efficiency rather than perfection. For example, in an active shooter scenario, instructing students to run to the nearest exit may not be perfect but is likely to save more lives.")
            
            Text("Cooper’s Color Code for Awareness Levels")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            VStack(alignment: .leading) {
                Text("Jeff Cooper's Color Code categorizes different levels of awareness:")
                Text("White").foregroundColor(.white).bold() + Text(": Relaxed and unaware; suitable for safe environments.")
                Text("Yellow").foregroundColor(.yellow).bold() + Text(": Relaxed but alert; the goal for most situations.")
                Text("Orange").foregroundColor(.orange).bold() + Text(": Focused on potential danger; mentally taxing and not sustainable long-term.")
                Text("Red").foregroundColor(.red).bold() + Text(": Action mode; dealing with an immediate threat.")
                Text("Black").foregroundColor(.black).bold() + Text(": Panic mode; breakdown of physical and mental abilities.")
            }
            
            Text("Practical Implementation Strategies")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(CustomColor.redBackground)
            
            VStack(alignment: .leading) {
                Text("1. Recognize Patterns")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("- Establish normal patterns of behavior in your environment to detect anomalies.")
                    Text("- Modify interaction rules to improve situational awareness, observing attire, carried objects, and making eye contact.")
                }
                
                Text("2. Environmental Analysis")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("Assess your environment for safety:")
                    Text("- _Home_: Identify safe rooms and escape paths.")
                    Text("- _Work_: Locate exits, understand the layout, and identify objects that can provide cover.")
                }
                
                Text("3. Understand Atmospherics")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("- Read the collective mood of the environment; a relaxed crowd versus an anxious or volatile one can indicate potential danger.")
                }
            }
        }
        .padding()
    }
}

struct Course02: View {
    var body: some View {
        ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("The Reality of Walking Alone")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        Text("Walking alone can be risky, depending on factors like location, gender, and time of day. Here are some general tips to help keep you safe in any situation.")
                        
                        Text("Essential Safety Tips")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("🛤️ _Plan Your Route_: Before leaving, choose well-lit streets with lots of people and open stores. Share your travel plan with someone you trust.")
                            Text("💡 _Share Your Plan_: Inform a family member or friend of your route and expected arrival time. They can check on you if they don't hear from you.")
                            Text("📱 _Carry Your Phone_: Keep your phone with you and fully charged. Consider carrying a power bank. Avoid using your phone for messages or music while walking.")
                            Text("⚠️ _Avoid Suspicious Areas and People_: Stick to well-lit, busy places. Avoid shortcuts through dark alleys or parks. Stay alert for anything that feels off.")
                            Text("🤲🏻 _Keep Your Hands Free_: You may need your hands for your phone or self-defense tools. Carry a small, light purse.")
                            Text("🚨 _Carry Non-Violent Deterrents_: A loud alarm can draw attention and deter attackers. Ensure any deterrents you carry are legal in your area.")
                            Text("🛡️ _Learn Self-Defense_: Self-defense classes boost confidence and situational awareness, preparing you mentally and physically for stressful situations.")
                        }
                        
                        Text("How to Tell If You Are Being Followed")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("- _Situational Awareness_: Stay alert and aware of your surroundings. Notice if a person or vehicle appears repeatedly.")
                            Text("- _Frequent Glances_: Use reflective surfaces like windows or your phone screen to check for followers discreetly.")
                            Text("- _Change Pace and Direction_: Alter your walking pattern. Speed up, slow down, or take several turns to see if the follower mirrors your movements.")
                        }
                        
                        Text("What to Do If You Suspect You’re Being Followed")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("- _Do Not Head Straight Home_: Avoid leading a potential follower to your residence. Go to a public, well-lit, crowded place like a café, mall, or police station.")
                            Text("- _Contact Authorities_: If you feel threatened, call the police. Inform them of your location and situation. Also, inform friends or family.")
                            Text("- _Observe and Note Details_: Remember details about the follower or their vehicle, like appearance, clothing, or license plate.")
                            Text("- _Make Noise and Seek Help_: Enter a store or crowded area and inform someone in charge. Drawing attention can deter a stalker.")
                        }
                        
                        Text("Preventive Measures")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("- _Share Your Itinerary_: Let someone you trust know your plans and expected arrival times. Use apps to share your live location with friends or family.")
                            Text("- _Vary Your Routes_: Avoid predictable routines. Change your routes and travel times frequently.")
                            Text("- _Use Technology_: Use personal safety apps with features like panic buttons that send your location and a distress message to contacts or authorities.")
                        }
                        
                        Text("Additional Tips for Different Scenarios")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("👟 On Foot:")
                                .fontWeight(.bold)
                            Text("- Walk confidently and at a steady pace.")
                            Text("- Avoid isolated areas, especially at night.")
                            Text("- Keep your phone easily accessible.")
                            
                            Text("🚗 In a Vehicle:")
                                .fontWeight(.bold)
                                .padding(.top)
                            Text("- If another car is following you, do not drive home. Go to a police station or a well-lit, busy area.")
                            Text("- Make intentional turns to confirm if the same vehicle is still behind you.")
                            Text("- Avoid stopping in secluded areas.")
                            
                            Text("🚆 Using Public Transport:")
                                .fontWeight(.bold)
                                .padding(.top)
                            Text("- Move towards the front of the bus or train where the driver or conductor can see you.")
                            Text("- If you feel unsafe, get off at a busy stop and wait for the next bus or train.")
                        }
                    }
                    .padding()
                }
            }
        }

struct Course03: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Helping Someone Who Drank Too Much")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        Text("Understanding Alcohol Poisoning: alcohol is a **toxic** substance, and excessive consumption can lead to **severe** health issues, including alcohol poisoning. This occurs when someone drinks a large amount of alcohol in a short period, leading to high blood alcohol concentration. Symptoms include slowed brain function, stomach irritation, dehydration, and more.")
                        
                        Text("Prevention Tips:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("❗️ _Set a Limit_: Decide on a drinking limit beforehand.")
                            Text("🍝 _Eat a Meal_: Eating before drinking slows alcohol absorption.")
                            Text("🥤 _Alternate Drinks_: Drink water or soft drinks between alcoholic beverages.")
                            Text("💡 _Have a Plan_: Plan your way home, keep your phone charged, or bring a power bank.")
                            Text("👥 _Stick with Friends_: Stay with friends to reduce the risk of incidents and injuries.")
                        }
                        
                        Text("Signs and Symptoms of Alcohol Poisoning:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
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
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Keep Them Awake and Sitting Up**: Try to keep the person awake and seated.")
                            Text("**2. Give Them Water**: If they can drink, provide water to keep them hydrated.")
                            Text("**3. Recovery Position**: If they pass out, lay them on their side in the recovery position and check their breathing.")
                            Text("**4. Keep Them Warm**: Ensure they stay warm.")
                            Text("**5. Monitor Symptoms**: Stay with them and monitor their condition.")
                        }
                        
                        Text("What Not to Do:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("🤝 _Never Leave Them Alone_: Do not leave the person to sleep it off.")
                            Text("❌☕️ _Avoid Coffee_: Alcohol dehydrates the body, and coffee can exacerbate this.")
                            Text("❌🤮 _Do Not Induce Vomiting_: This can cause choking.")
                            Text("❌🚿 _No Cold Showers_: Moving someone with alcohol poisoning can cause injury, and a cold shower can lower their body temperature further.")
                            Text("❌🍷 _No More Alcohol_: Do not let them drink more alcohol.").padding(.bottom)
                            Text("_**Emergency Help**_: Always call your local emergency number if you suspect someone has alcohol poisoning.")
                        }
                        
                        Text("Helping Someone Who Is Too High from Weed")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        Text("Understanding Cannabis Effects: the high from marijuana is due to THC, which **affects brain receptors**. Even if it feels overwhelming, it's important to remember that it’s temporary and not life-threatening. No deaths have been reported from cannabis overdose.")
                        
                        Text("Symptoms of Being Too High:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
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
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
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
                        
                        Text("Clubbing Safety Tips")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        Text("Do’s:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Plan Ahead**: Research the club’s dress code, policies, and cover charges. Arrive early to avoid long lines.")
                            Text("**2. Dress Comfortably**: Wear stylish yet comfortable clothes and suitable shoes for dancing.")
                            Text("**3. Bring Essentials**: Carry your ID, some cash, and your phone. A small bag or clutch is ideal.")
                            Text("**4. Stay Hydrated**: Alternate between alcoholic drinks and water.")
                            Text("**5. Stick with Friends**: Use a buddy system to stay safe and support each other.")
                        }
                        
                        Text("Don’ts:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Avoid Overdrinking**: Know your alcohol limits to prevent risks.")
                            Text("**2. Don’t Go Alone**: Always club with friends.")
                            Text("**3. Guard Your Belongings**: Keep an eye on your items and avoid bringing unnecessary valuables.")
                            Text("**4. Watch Your Drinks**: Never leave drinks unattended.")
                        }
                        
                        Text("General Advice:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("😃 _Enjoy Yourself_: Embrace the music, dancing, and social aspects.")
                            Text("✅ _Prioritize Safety_: Trust your instincts, avoid conflicts, and have a safe and reliable way to get home.")
                        }
                        
                        Text("Enjoying a Safe Night Out:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Stay in Groups**: Being in a group reduces the likelihood of being targeted.")
                            Text("**2. Arrange Transportation**: Get a ride from a trusted person or book a taxi.")
                            Text("**3. Book Licensed Taxis**: Use only licensed mini-cabs or black cabs.")
                            Text("**4. Drink Responsibly**: Keep an eye on your drink and avoid accepting vapes from strangers.")
                            Text("**5. Stay in Well-Lit Areas**: Choose well-lit, populated routes when walking home.")
                            Text("**6. Conceal Valuables**: Keep valuables hidden to avoid attracting thieves.")
                            Text("**7. Avoid Conflicts**: Stay away from fights or arguments, and seek help from bouncers or the police if needed.").padding(.bottom)
                            Text("For any suspicious activity, **report it** to your local emergency number.")
                        }
                    }
                    .padding()
                }
    }

struct Course04: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Security for Children Walking Alone to School")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        Text("Legal Age to Walk Alone: the **recommended** age for children to walk alone varies by country and region, **generally** around 10 years old. **Check local laws** and regulations for specific guidelines.")
                        
                        Text("Walking to School Alone Tips:")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
            VStack(alignment: .leading) {
                Text("👕 Bright Clothes: Equip your child with bright or reflective clothing to increase visibility, especially in low-light conditions. Reflective patches or accessories on backpacks can also be effective.")
                Text("👥 Walk Together: Initially walk the route with your child to familiarize them with it. Show them safe places to cross and potential hazards.")
Text("🧠 Alternatives: Plan a backup route in case the primary path is blocked. Ensure your child knows this route and can contact you if needed.").padding(.bottom)
                                Text("**Road Safety Rules**: Teach children road safety basics, such as:")
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("  👀 Always look both ways before crossing the street.")
                                    Text("  🚸 Use pedestrian crossings and obey traffic signals.")
                                    Text("  🚶‍♀️ Walk on sidewalks or, if unavailable, facing traffic on the road's edge.")
                                    Text("  ❌🏃‍♀️ Never play or run into the street.").padding(.bottom)
                                }
                                Text("**Stranger Danger**: Educate your child on how to handle situations with strangers:")
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("  ❌👨 Never accept rides or gifts from strangers.")
                                    Text("  ✅👨‍🦳 Know safe adults they can turn to if they feel uncomfortable or in danger.")
                                }.padding(.bottom)
                                Text("**Mobile Phones**: Consider giving your child a phone to contact you in emergencies. Teach them how to use it responsibly and practice emergency procedures.")
                                Text("**Safe Spots**: Identify safe places along the route, like trusted neighbors' homes or businesses, where your child can seek help if needed.")
                                Text("**No Headphones**: Discourage the use of headphones while walking to ensure they remain alert to their surroundings.")
                                Text("**Identifying Safe Routes**: Choose routes that avoid isolated or poorly lit areas, busy roads without sidewalks, and other hazards.")
                            }
                        
                        Text("Road Safety Rules")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Look Before Crossing**: Hold an adult's hand, look left, right, and left again before crossing.")
                            Text("**2. Don’t Play on the Road**: Teach children the importance of staying away from streets.")
                            Text("**3. Use Sidewalks**: Always walk on sidewalks or face traffic if no sidewalk is available.")
                            Text("**4. Understand Traffic Signals**: Explain the meanings of red, yellow, and green lights.")
                            Text("**5. Exit Cars Safely**: Always exit vehicles away from traffic.")
                            Text("**6. Wear Helmets**: Ensure helmets are worn when biking or skateboarding.")
                            Text("**7. Additional Tips**: Always wear seatbelts, be alert to horns, and let vehicles pass safely.")
                        }
                        
                        Text("At-Home Safety Rules")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Emergency Contacts**: Children should know emergency contacts and memorize parents’ phone numbers.")
                            Text("**2. Get Permission to Leave**: Always ask for permission before leaving the house.")
                            Text("**3. Avoid Opening Doors to Strangers**: Teach children to verify who is at the door and not open it to unknown people.")
                            Text("**4. No Playing with Fire or Water**: Educate about fire hazards and water safety.")
                            Text("**5. No Climbing on High Surfaces**: Warn against jumping on furniture or climbing on shelves.")
                            Text("**6. Safe At-Home Learning**: Ensure the learning environment is child-friendly.")
                        }
                        
                        Text("Safety Rules About Strangers")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. Be Wary of Strangers**: Don’t accept offers or go with strangers. Report any suspicious behavior.")
                            Text("**2. Always Tell Parents**: Encourage open communication about interactions with adults.")
                            Text("**3. Maintain Distance**: Keep a safe distance from unknown adults asking for help.")
                        }
                        
                        Text("General Safety")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(CustomColor.redBackground)
                        
                        VStack(alignment: .leading) {
                            Text("**1. What to Do if Lost**: Stay calm, stay where they are, and seek help from a trusted adult if lost.")
                            Text("**2. Know Contact Information**: Memorize parents’ full names, address, and phone numbers.")
                            Text("**3. Good Touch vs. Bad Touch**: Educate about appropriate and inappropriate touch and report any bad touch immediately.")
                            Text("**4. Internet Safety**: Don’t share personal information online and report suspicious behavior.")
                            Text("**5. Safety Around Water Bodies**: Never swim alone and always have adult supervision.")
                            Text("**6. Sun Safety**: Wear sunscreen or appropriate clothing on sunny days.")
                        }
                    }
                    .padding()
                }
    }

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.orange)
                
                Rectangle()
                    .frame(width: min(self.progress * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.orange)
                    .animation(.linear, value: progress)
            }
        }
        .frame(height: 10) // Set a fixed height for the progress bar
        .cornerRadius(5)
    }
}

#Preview {
    CoursesView()
}
