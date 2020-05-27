class DedicatedBin {
  List<Question> questions;
  List<Bin> bins;

  DedicatedBin({this.questions, this.bins});

  DedicatedBin.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = new List<Question>();
      json['questions'].forEach((v) {
        questions.add(new Question.fromJson(v));
      });
    }

    if (json['bins'] != null) {
      bins = new List<Bin>();
      json['bins'].forEach((v) {
        bins.add(new Bin.fromJson(v));
      });
    }
  }
}

class Question {
  String title;
  List<Answers> answers;
  String id;

  Question({this.title, this.answers, this.id});

  Question.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['answers'] != null) {
      answers = new List<Answers>();
      json['answers'].forEach((v) {
        answers.add(new Answers.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class Answers {
  int id;
  String title;

  Answers({this.id, this.title});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}

class Bin {
  String name;
  String namePl;
  List<String> products;

  Bin({this.name, this.namePl, this.products});

  Bin.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    namePl = json['name_pl'];
    if (json['products'] != null) {
      products = json['products'].cast<String>();
    }
  }
}