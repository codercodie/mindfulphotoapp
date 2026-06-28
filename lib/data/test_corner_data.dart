import '../models/corner.dart';

const testCorners = [
  Corner(
    id: 'cats',
    name: 'cat lovers',
    description: 'tiny paws, sleepy faces, and chaos gremlins.',
    members: 128,
    glimmers: 642,
    joinType: CornerJoinType.open,
    isJoined: true,
  ),
  Corner(
    id: 'coffee',
    name: 'coffee moments',
    description: 'cosy mugs, café corners, and morning rituals.',
    members: 84,
    glimmers: 301,
    joinType: CornerJoinType.request,
    isJoined: false,
  ),
  Corner(
    id: 'nature',
    name: 'nature finds',
    description: 'leaves, skies, flowers, moss, and quiet walks.',
    members: 211,
    glimmers: 904,
    joinType: CornerJoinType.open,
    isJoined: true,
  ),
  Corner(
    id: 'quiet',
    name: 'quiet corners',
    description: 'peaceful little spaces worth remembering.',
    members: 47,
    glimmers: 119,
    joinType: CornerJoinType.private,
    isJoined: false,
  ),
];
