class UserModel {
  String uid;
  String name;
  String email;
  String phoneNo;
  String imageUrl;
  String cnic;
  String type;
  bool isApproved;
  

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.imageUrl,
    required this.cnic,
    required this.type,
    this.isApproved = false,
   
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNo,
    String? type,
    String? imageUrl,
    String? cnic,
    bool? isApprovde,
   
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      cnic: cnic ?? this.cnic,
      isApproved: isApprovde ?? this.isApproved,
      
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'type': type,
      'imageUrl': imageUrl,
      'cnic': cnic,
      'isApproved': isApproved,
      
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    print('uid---------------------- ${map['uid']}');
    print('name---------------------- ${map['name']}');
    print('email---------------------- ${map['email']}');
    print('phoneNo---------------------- ${map['phoneNo']}');
    print('imageUrl---------------------- ${map['imageUrl']}');
    print('cnic---------------------- ${map['cnic']}');
    print('isApproved---------------------- ${map['isApproved']}');
    print('type---------------------- ${map['type']}');
    

    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      type: map['type'],
      imageUrl: map['imageUrl'] ?? '',
      cnic: map['cnic'] ?? '',
      isApproved: map['isApproved'] ?? false,
      
    );
  }
}
