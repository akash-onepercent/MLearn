class Category {

  String title;
  int lessonCount;
  double rating;
  String imagePath;

  Category({
    this.title = '',
    this.imagePath = '',
    this.lessonCount = 0,
    this.rating = 0.0,
  });

  static List<Category> mathList = <Category>[
    Category(
      imagePath: 'assets/images/probability.png',
      title: 'Probability and Statistics',
      lessonCount: 3,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/images/vectorsmatrices.png',
      title: 'Vectors and Matrices',
      lessonCount: 2,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/images/calculus.png',
      title: 'Calculus',
      lessonCount: 5,
      rating: 4.9,
    ),
  ];

  static List<Category> mlList = <Category>[
    Category(
      imagePath: 'assets/images/supervised.png',
      title: 'Supervised Learning',
      lessonCount: 2,
      rating: 4.9,
    ),
    Category(
      imagePath: 'assets/images/unsupervised.png',
      title: 'Unsupervised Learning',
      lessonCount: 2,
      rating: 4.8,
    ),
    Category(
      imagePath: 'assets/images/reinforcement.png',
      title: 'Reinforcement Learning',
      lessonCount: 1,
      rating: 4.8,
    ),
  ];

  static List<Category> dlList = <Category>[
    Category(
      imagePath: 'assets/images/interFace1.png',
      title: 'CNNs',
      lessonCount: 18,
      rating: 4.3,
    ),
    Category(
      imagePath: 'assets/images/interFace2.png',
      title: 'RNNs',
      lessonCount: 22,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/images/interFace3.png',
      title: 'LSTMs',
      lessonCount: 22,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/images/interFace4.png',
      title: 'Autoencoders',
      lessonCount: 22,
      rating: 4.6,
    ),
    Category(
      imagePath: 'assets/images/interFace1.png',
      title: 'Transformers',
      lessonCount: 22,
      rating: 4.6,
    ),
  ];
}
