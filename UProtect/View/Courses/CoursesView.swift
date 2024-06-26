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
    let identifier: String
    let subtitle: String
    @Published var progress: CGFloat {
        didSet {
            saveProgress()
        }
    }
    
    init(id: UUID = UUID(), identifier: String, title: String, subtitle: String, progress: CGFloat) {
        self.id = id
        self.title = title
        self.identifier = identifier
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
        Course(identifier: "course_01", title: NSLocalizedString("Course 01", comment: "Title of the first course"),
               subtitle: NSLocalizedString("Self defence", comment: "Subtitle for course 01"),
               progress: 0/30.0),
        Course(identifier: "course_02", title: NSLocalizedString("Course 02", comment: "Title of the second course"),
               subtitle: NSLocalizedString("Walking alone", comment: "Subtitle for course 02"),
               progress: 0/30.0),
        Course(identifier: "course_03", title: NSLocalizedString("Course 03", comment: "Title of the third course"),
               subtitle: NSLocalizedString("In the disco", comment: "Subtitle for course 03"),
               progress: 0/30.0),
        Course(identifier: "course_04", title: NSLocalizedString("Course 04", comment: "Title of the fourth course"),
               subtitle: NSLocalizedString("Children security", comment: "Subtitle for course 04"),
               progress: 0/30.0)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Courses")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top])
                
                DailyTipView()
                    .padding(.horizontal, 25)
                    .padding(.vertical, 5)
                
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
                
                switch course.identifier {
                                case "course_01":
                                    Image("defence")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                case "course_02":
                                    Image("Walk")
                                        .resizable()
                                        .frame(width: 160, height: 120)
                                        .scaleEffect(0.98)
                                        .padding(.trailing, -10)
                                case "course_03":
                                    Image("Disco")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaleEffect(1.45)
                                case "course_04":
                                    Image("Children")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                default:
                                    EmptyView()
                                }
                            }
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
                if course.identifier == "course_01" {
                    Corso1(course: $course)
                } else if course.identifier == "course_02"{
                    Corso2(course: $course)
                }
                else if course.identifier == "course_03" {
                    Corso3(course: $course)
                } else if course.identifier == "course_04" {
                    Corso4(course: $course)
                }
            }
            
        }
        .background(CustomColor.orangeBackground)
        .navigationTitle(course.title)
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
