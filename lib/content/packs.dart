import 'pack.dart';

const List<Pack> packs = [
  everydayPack,
  naturePack,
  indoorsPack,
];

const everydayPack = Pack(
  id: 'everyday',
  name: 'Everyday Sparks',
  description: 'Gentle prompts for noticing good things nearby.',
  prompts: [
    Prompt(
      id: 'everyday_001',
      text: 'something small that made your day better.',
      category: 'joy',
    ),
    Prompt(
      id: 'everyday_002',
      text: 'a quiet moment worth remembering.',
      category: 'calm',
    ),
    Prompt(
      id: 'everyday_003',
      text: 'a little bit of light.',
      category: 'light',
    ),
  ],
);

const naturePack = Pack(
  id: 'nature',
  name: 'Nature Sparks',
  description: 'Small details from the world outside.',
  prompts: [
    Prompt(
      id: 'nature_001',
      text: 'something growing.',
      category: 'nature',
    ),
    Prompt(
      id: 'nature_002',
      text: 'a texture from nature.',
      category: 'nature',
    ),
  ],
);

const indoorsPack = Pack(
  id: 'indoors',
  name: 'Indoors Sparks',
  description: 'Small details from the world inside.',
  prompts: [
    Prompt(
      id: 'indoors_001',
      text: 'something inside that should be outside.',
      category: 'indoors',
    ),
    Prompt(
      id: 'indoors_002',
      text: 'a texture from indoors.',
      category: 'indoors',
    ),
  ],
);
