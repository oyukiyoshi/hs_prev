// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sentence _$SentenceFromJson(Map<String, dynamic> json) => Sentence(
      sentenceId: (json['sentence_id'] as num).toInt(),
      sentenceName: json['sentence_name'] as String,
      changedAt: DateTime.parse(json['changed_at'] as String),
    );

Map<String, dynamic> _$SentenceToJson(Sentence instance) => <String, dynamic>{
      'sentence_id': instance.sentenceId,
      'sentence_name': instance.sentenceName,
      'changed_at': instance.changedAt.toIso8601String(),
    };

Passage _$PassageFromJson(Map<String, dynamic> json) => Passage(
      sentenceId: (json['sentence_id'] as num).toInt(),
      lineNo: (json['line_no'] as num).toInt(),
      tagId: (json['tag_id'] as num).toInt(),
      textType: json['text_type'] as String,
      passageContent: json['passage_content'] as String,
    );

Map<String, dynamic> _$PassageToJson(Passage instance) => <String, dynamic>{
      'sentence_id': instance.sentenceId,
      'line_no': instance.lineNo,
      'tag_id': instance.tagId,
      'text_type': instance.textType,
      'passage_content': instance.passageContent,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      tagId: (json['tag_id'] as num).toInt(),
      tagColor: json['tag_color'] as String,
      tagName: json['tag_name'] as String,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'tag_id': instance.tagId,
      'tag_color': instance.tagColor,
      'tag_name': instance.tagName,
    };
