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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    if (this.bins != null) {
      data['bins'] = this.bins.map((v) => v.toJson()).toList();
    }
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['name_pl'] = this.namePl;
    data['products'] = this.products;
    return data;
  }
}