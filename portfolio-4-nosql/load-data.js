const portfolioDb = db.getSiblingDB("mit8103_portfolio4");
const transcripts = portfolioDb.studentTranscripts;

transcripts.drop();

transcripts.insertMany([
  {
    _id: "MIT-2026-001",
    studentId: 1001,
    student: {
      firstName: "Ada",
      lastName: "Okafor",
      email: "ada.okafor@example.edu"
    },
    programme: {
      code: "MIT",
      name: "Master of Information Technology"
    },
    terms: [
      {
        academicYear: "2026/2027",
        termName: "First Semester",
        courses: [
          {
            courseCode: "MIT8103",
            courseTitle: "Advanced Database Systems",
            sectionCode: "A",
            status: "completed",
            assessments: [
              { no: 1, title: "Coursework", scorePercent: 78, weightPercent: 40 },
              { no: 2, title: "Final Examination", scorePercent: 82, weightPercent: 60 }
            ],
            finalPercent: 80.4
          },
          {
            courseCode: "CSC8101",
            courseTitle: "Database Design",
            sectionCode: "A",
            status: "completed",
            assessments: [
              { no: 1, title: "Coursework", scorePercent: 74, weightPercent: 40 },
              { no: 2, title: "Final Examination", scorePercent: 79, weightPercent: 60 }
            ],
            finalPercent: 77.0
          }
        ]
      }
    ]
  },
  {
    _id: "MIT-2026-002",
    studentId: 1002,
    student: {
      firstName: "Tunde",
      lastName: "Bello",
      email: "tunde.bello@example.edu"
    },
    programme: {
      code: "MIT",
      name: "Master of Information Technology"
    },
    terms: [
      {
        academicYear: "2026/2027",
        termName: "First Semester",
        courses: [
          {
            courseCode: "MIT8103",
            courseTitle: "Advanced Database Systems",
            sectionCode: "A",
            status: "completed",
            assessments: [
              { no: 1, title: "Coursework", scorePercent: 65, weightPercent: 40 },
              { no: 2, title: "Final Examination", scorePercent: 74, weightPercent: 60 }
            ],
            finalPercent: 70.4
          }
        ]
      }
    ]
  }
]);

transcripts.createIndex({ "terms.courses.courseCode": 1 });

print("Inserted transcript documents:");
print(transcripts.countDocuments());
print("Indexes:");
printjson(transcripts.getIndexes().map(index => index.name));
