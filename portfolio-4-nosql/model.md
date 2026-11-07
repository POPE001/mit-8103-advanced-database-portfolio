# MongoDB Document Model: Student Transcript

## Read pattern

The primary read pattern is “show this student's transcript for a selected academic period.” The document uses the matriculation number as `_id` and embeds the student's programme, terms, course results, and assessment breakdowns. That lets the portal retrieve a transcript with one document read.

## Example document

```javascript
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
        }
      ]
    }
  ]
}
```

## Embedding decisions and trade-offs

- Assessment scores are embedded within their course result because they are normally displayed with that result.
- Course code and title are copied into the transcript as a historical snapshot. If the catalogue title changes, an already-issued transcript remains understandable without a cross-collection join.
- The relational PostgreSQL schema remains the normalized source for enrolments, courses, and marks. This document is a read model for transcript retrieval; updates need to keep it synchronized with the source records.
- Embedding makes student-centric transcript reads simple, but course-wide reports must scan or unwind documents. The relational model is still a better fit for cross-student registration and aggregate queries.
- The `terms` and `courses` arrays are bounded by a student's study history. If transcript documents approached MongoDB's 16 MB document limit, course results should move to a separate collection keyed by matriculation number and term.

## Indexing

MongoDB's built-in unique `_id` index supports transcript lookups by matriculation number. A multikey index on `terms.courses.courseCode` supports queries that find students with a result for a given course.
