# NoSQL Run Results

The document load and queries were run in a temporary MongoDB container.

## Environment

MongoDB 7.0.45; database `mit8103_portfolio4`; collection `studentTranscripts`.

## Results

`load-data.js` inserted two transcript documents and created the `_id_` and `terms.courses.courseCode_1` indexes. The captured load output is in [load-output.txt](load-output.txt).

- Transcript lookup for `MIT-2026-001` returned Ada Okafor's programme and two embedded course results (80.4 and 77.0).
- The course query returned Ada Okafor (80.4) and Tunde Bello (70.4) for `MIT8103` in the first semester.
- The aggregation returned an average final percentage of 75.4 across two students.

The full MongoDB shell output is in [query-results.txt](query-results.txt).

## Notes

The sample documents are synthetic transcript snapshots based on the same university portal case study. The PostgreSQL schema remains the normalized source model. The MongoDB container was stopped after the run; its data was disposable.
