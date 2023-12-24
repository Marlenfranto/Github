class BranchModel {
  String? name;
  Commit? commit;
  bool? protected;

  BranchModel({this.name, this.commit, this.protected});

  BranchModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    commit =
    json['commit'] != null ? new Commit.fromJson(json['commit']) : null;
    protected = json['protected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.commit != null) {
      data['commit'] = this.commit!.toJson();
    }
    data['protected'] = this.protected;
    return data;
  }
}

class Commit {
  String? sha;
  String? url;

  Commit({this.sha, this.url});

  Commit.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sha'] = this.sha;
    data['url'] = this.url;
    return data;
  }
}
