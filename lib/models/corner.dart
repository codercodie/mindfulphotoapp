enum CornerJoinType {
  open,
  request,
  private,
}

class Corner {
  final String id;
  final String name;
  final String description;
  final int members;
  final int glimmers;
  final CornerJoinType joinType;
  final bool isJoined;

  const Corner({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
    required this.glimmers,
    required this.joinType,
    this.isJoined = false,
  });

  Corner copyWith({
    String? id,
    String? name,
    String? description,
    int? members,
    int? glimmers,
    CornerJoinType? joinType,
    bool? isJoined,
  }) {
    return Corner(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      members: members ?? this.members,
      glimmers: glimmers ?? this.glimmers,
      joinType: joinType ?? this.joinType,
      isJoined: isJoined ?? this.isJoined,
    );
  }
}