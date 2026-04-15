import 'package:flutter/material.dart';

class NoteModel {
  final String title;
  final String subtitle;
  final String time;

  NoteModel({required this.title, required this.subtitle, required this.time});
}

Widget horizontalNotes(List<NoteModel> notes) {
  return SizedBox(
    height: 155,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: notes.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final note = notes[index];
        return Container(
          width: 250,
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  textAlign: TextAlign.start,
                  note.subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                note.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
