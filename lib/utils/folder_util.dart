class Folder {
  String folderId;
  String folderName;

  late DateTime folderDate;

  late int folderNumberOfMembers;
  late int folderNumberOfEnvelopes;

  bool folderIsShared;

  Folder({
    this.folderId = "",
    required this.folderName,
    this.folderIsShared = false
  }){
    folderDate = DateTime.now();
  
    folderNumberOfEnvelopes = 0;
    folderNumberOfMembers = 0;
  }

  Map<String, dynamic> toMap(){
    return {
      "folderId" : folderId,
      "folderName" : folderName,
      "folderDate" : folderDate,
      "folderNumberOfMembers" : folderNumberOfMembers,
      "folderNumberOfEnvelopes" : folderNumberOfEnvelopes,
      "folderIsShared" : folderIsShared,
    };
  }

  factory Folder.fromMap(Map<String, dynamic> map){
    return Folder(
      folderId: map["folderId"],
      folderName: map["folderName"], 
      folderIsShared: map["folderIsShared"]
    );
  }

}