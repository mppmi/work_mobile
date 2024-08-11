 // To parse this JSON data, do
//
//     final customersLoginPostRequset = customersLoginPostRequsetFromJson(jsonString);

import 'dart:convert';

CustomersLoginPostRequset customersLoginPostRequsetFromJson(String str) => CustomersLoginPostRequset.fromJson(json.decode(str));

String customersLoginPostRequsetToJson(CustomersLoginPostRequset data) => json.encode(data.toJson());

class CustomersLoginPostRequset {
    String phone;
    String password;

    CustomersLoginPostRequset({
        required this.phone,
        required this.password,
    });

    factory CustomersLoginPostRequset.fromJson(Map<String, dynamic> json) => CustomersLoginPostRequset(
        phone: json["phone"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "password": password,
    };
}
