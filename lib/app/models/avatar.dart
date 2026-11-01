import 'dart:convert';
import 'dart:typed_data';

// Stored at users/{uid}.avatar as either
//   { emoji: '🦊', color: 0xFFFFB74D }            or
//   { emoji, color, photo: '<base64 jpeg>' }      (photo wins when present)
// Photos are small (256px) so they fit in the user doc without Firebase Storage.
class Avatar {
  final String emoji;
  final int color;
  final String? photo;

  const Avatar({required this.emoji, required this.color, this.photo});

  static const emojis = [
    '🦊', '🐼', '🐯', '🐸', '🐵', '🦁', '🐨', '🐰', '🐶', '🐱', '🐻', '🐷', //
    '🦄', '🐙', '🦖', '🐢', '🦉', '🐝', '🚀', '⚽', '🎸', '🌈', '⭐', '🍕',
  ];

  static const colors = [
    0xFFFFB74D, 0xFFE57373, 0xFFBA68C8, 0xFF64B5F6, //
    0xFF4DB6AC, 0xFF81C784, 0xFFFFF176, 0xFFA1887F,
  ];

  // Everyone gets a distinct-looking default before choosing one.
  factory Avatar.defaultFor(String uid) {
    final hash = uid.codeUnits.fold<int>(
      0,
      (h, c) => (h * 31 + c) & 0x7fffffff,
    );
    return Avatar(
      emoji: emojis[hash % emojis.length],
      color: colors[(hash ~/ emojis.length) % colors.length],
    );
  }

  factory Avatar.fromUser(String uid, Map<String, dynamic>? user) {
    final data = user?['avatar'];
    final fallback = Avatar.defaultFor(uid);
    if (data is! Map) return fallback;
    return Avatar(
      emoji: data['emoji'] as String? ?? fallback.emoji,
      color: (data['color'] as num?)?.toInt() ?? fallback.color,
      photo: data['photo'] as String?,
    );
  }

  Avatar copyWith({
    String? emoji,
    int? color,
    String? photo,
    bool clearPhoto = false,
  }) => Avatar(
    emoji: emoji ?? this.emoji,
    color: color ?? this.color,
    photo: clearPhoto ? null : (photo ?? this.photo),
  );

  Map<String, dynamic> toMap() => {
    'emoji': emoji,
    'color': color,
    if (photo != null) 'photo': photo,
  };

  Uint8List? get photoBytes => photo == null ? null : base64Decode(photo!);
}
