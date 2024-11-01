class Animal {
  String name;

  Animal(this.name);
  void move() {}
  static void stay() {}
}

final dog = Animal('dog');
void _a() {
  dog.move();
  Animal.stay();
  Animal abc = Animal('cat');
  abc.move();
}
