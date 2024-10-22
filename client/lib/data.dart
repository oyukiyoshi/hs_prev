import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Sentence {
  const Sentence({
    required this.sentenceId,
    required this.sentenceName,
    required this.changedAt,
  });

  final int sentenceId;
  final String sentenceName;
  final DateTime changedAt;

  factory Sentence.fromJson(Map<String, Object?> json) => _$SentenceFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Passage {
  const Passage({
    required this.sentenceId,
    required this.lineNo,
    required this.tagId,
    required this.textType,
    required this.passageContent,
  });
  
  final int sentenceId;
  final int lineNo;
  final int tagId;
  final String textType;
  final String passageContent;

  Map<String, Object?> toJson() => _$PassageToJson(this);
  factory Passage.fromJson(Map<String, Object?> json) => _$PassageFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Tag {
  const Tag({
    required this.tagId,
    required this.tagColor,
    required this.tagName,
  });

  final int tagId;
  final String tagColor;
  final String tagName;

  Map<String, Object?> toJson() => _$TagToJson(this);
  factory Tag.fromJson(Map<String, Object?> json) => _$TagFromJson(json);
}