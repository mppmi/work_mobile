// To parse this JSON data, do
//
//     final customersRegisterPostRequset = customersRegisterPostRequsetFromJson(jsonString);

import 'dart:convert';

CustomersRegisterPostRequset customersRegisterPostRequsetFromJson(String str) => CustomersRegisterPostRequset.fromJson(json.decode(str));

String customersRegisterPostRequsetToJson(CustomersRegisterPostRequset data) => json.encode(data.toJson());

class CustomersRegisterPostRequset {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomersRegisterPostRequset({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomersRegisterPostRequset.fromJson(Map<String, dynamic> json) => CustomersRegisterPostRequset(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
