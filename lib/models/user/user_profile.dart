//
// class UserProfile {
//   String? phone;
//   Profile? profile;
//   String? bakongName;
//   String? bakongAccountId;
//   UserProfile(
//       {this.phone, this.profile, this.bakongName, this.bakongAccountId});
//
//   factory UserProfile.fromJson(Map<String, dynamic> json) {
//     return UserProfile(
//       phone: json['phone'],
//       bakongName: json['bakongName'],
//       bakongAccountId: json['bakongAccountId'],
//       profile: Profile.fromJson(json['profile']),
//     );
//   }
//
//   String phoneFormat(){
//     var format=phone;
//     if(phone?.startsWith('855')==true){
//       format=phone!.substring(3,phone!.length);
//     }
//     return format??'';
//   }
// }
//
// class Profile {
//   int? status;
//   String? reason;
//   String? email;
//   String? fname;
//   String? lname;
//   int? birthdate;
//   String? gender;
//   String? country;
//   String? province;
//   String? city;
//   String? avatar;
//   String? address;
//
//   String? getName() {
//     return '$fname $lname';
//   }
//
//   Profile(
//       {this.status,
//         this.reason,
//         this.email,
//         this.fname,
//         this.lname,
//         this.birthdate,
//         this.gender,
//         this.country,
//         this.province,
//         this.city,
//         this.avatar,
//         this.address});
//
//   Profile.fromJson(Map<String, dynamic> json) {
//     if (json != null) {
//       status = json['status'];
//       reason = json['reason'];
//       email = json['email'];
//       fname = json['fname'];
//       lname = json['lname'];
//       birthdate = json['birthdate'];
//       gender = json['gender'];
//       country = json['country'];
//       province = json['province'];
//       city = json['city'];
//       avatar = json['avatar'];
//       address = json['address'];
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['status'] = status;
//     data['reason'] = reason;
//     data['email'] = email;
//     data['fname'] = fname;
//     data['lname'] = lname;
//     data['birthdate'] = birthdate;
//     data['gender'] = gender;
//     data['country'] = country;
//     data['province'] = province;
//     data['city'] = city;
//     data['avatar'] = avatar;
//     data['address'] = address;
//     return data;
//   }
//
//   bool get hasKyc => status != null;
//
//   bool get isVerificating => status == 0;
//
//   bool get isVerificated => status == 1;
//
//   bool get hasVerificationErrors => status == 2;
// }