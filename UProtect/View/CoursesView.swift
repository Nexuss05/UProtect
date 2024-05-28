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
            Course(title: "Course 04", subtitle: "While travelling", progress: 0/30.0)
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
            .background(Color(UIColor.systemGroupedBackground))
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
                .padding(.bottom, 60)
                
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
            ProgressBar(progress: course.progress)
                .padding(.top, 5)
                
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
            Text("Attento a Yuri")
                .font(.largeTitle)
                .bold()
                .padding(.top, 100)
            
            Spacer()
            
            Button(action: {
                course.progress = 1.0
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Complete")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 50)
            
        }
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
