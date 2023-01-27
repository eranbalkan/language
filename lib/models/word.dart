// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'word.g.dart';

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String sourceText;

  @HiveField(2)
  final String sourceLanguage;

  @HiveField(3)
  final String targetText;

  @HiveField(4)
  final String targetLanguage;

  @HiveField(5)
  String? notes;
  Word({
    required this.id,
    required this.sourceText,
    required this.sourceLanguage,
    required this.targetText,
    required this.targetLanguage,
    this.notes,
  });

  Word copyWith({
    int? id,
    String? sourceText,
    String? sourceLanguage,
    String? targetText,
    String? targetLanguage,
    String? notes,
  }) {
    return Word(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetText: targetText ?? this.targetText,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sourceText': sourceText,
      'sourceLanguage': sourceLanguage,
      'targetText': targetText,
      'targetLanguage': targetLanguage,
      'notes': notes,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] as int,
      sourceText: map['sourceText'] as String,
      sourceLanguage: map['sourceLanguage'] as String,
      targetText: map['targetText'] as String,
      targetLanguage: map['targetLanguage'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) => Word.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Word(id: $id, sourceText: $sourceText, sourceLanguage: $sourceLanguage, targetText: $targetText, targetLanguage: $targetLanguage, notes: $notes)';
  }

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sourceText == sourceText &&
        other.sourceLanguage == sourceLanguage &&
        other.targetText == targetText &&
        other.targetLanguage == targetLanguage &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^ sourceText.hashCode ^ sourceLanguage.hashCode ^ targetText.hashCode ^ targetLanguage.hashCode ^ notes.hashCode;
  }
}
