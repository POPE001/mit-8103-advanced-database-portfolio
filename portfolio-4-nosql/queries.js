const portfolioDb = db.getSiblingDB("mit8103_portfolio4");
const transcripts = portfolioDb.studentTranscripts;

print("Transcript lookup by matriculation number:");
printjson(
  transcripts.findOne(
    { _id: "MIT-2026-001" },
    { _id: 1, student: 1, programme: 1, terms: 1 }
  )
);

print("Students with an MIT8103 result in the first semester:");
printjson(
  transcripts.aggregate([
    { $match: { "terms.courses.courseCode": "MIT8103" } },
    { $unwind: "$terms" },
    {
      $match: {
        "terms.academicYear": "2026/2027",
        "terms.termName": "First Semester"
      }
    },
    { $unwind: "$terms.courses" },
    { $match: { "terms.courses.courseCode": "MIT8103" } },
    {
      $project: {
        _id: 1,
        studentName: {
          $concat: ["$student.firstName", " ", "$student.lastName"]
        },
        courseCode: "$terms.courses.courseCode",
        finalPercent: "$terms.courses.finalPercent"
      }
    },
    { $sort: { _id: 1 } }
  ]).toArray()
);

print("Average MIT8103 final percentage:");
printjson(
  transcripts.aggregate([
    { $match: { "terms.courses.courseCode": "MIT8103" } },
    { $unwind: "$terms" },
    {
      $match: {
        "terms.academicYear": "2026/2027",
        "terms.termName": "First Semester"
      }
    },
    { $unwind: "$terms.courses" },
    { $match: { "terms.courses.courseCode": "MIT8103" } },
    {
      $group: {
        _id: "$terms.courses.courseCode",
        studentsWithResults: { $sum: 1 },
        averageFinalPercent: { $avg: "$terms.courses.finalPercent" }
      }
    },
    {
      $project: {
        _id: 0,
        courseCode: "$_id",
        studentsWithResults: 1,
        averageFinalPercent: { $round: ["$averageFinalPercent", 2] }
      }
    }
  ]).toArray()
);
