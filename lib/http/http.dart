// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mahavar_eurotech/constants.dart';
import 'package:mahavar_eurotech/models/add_machine.dart';
import 'package:mahavar_eurotech/models/get_all_address.dart';
import 'package:mahavar_eurotech/models/get_all_machines.dart';
import 'package:mahavar_eurotech/models/get_all_products.dart';
import 'package:http/http.dart' as http;
import 'package:mahavar_eurotech/models/get_brand.dart';
import 'package:mahavar_eurotech/models/get_notification.dart';
import 'package:mahavar_eurotech/models/get_product_desc.dart';
import 'package:mahavar_eurotech/models/get_single_address.dart';
import 'package:mahavar_eurotech/models/submit_service_request.dart';
import 'package:mahavar_eurotech/models/user_request.dart';
import 'package:mahavar_eurotech/screens/Address/choose_address.dart';
import 'package:mahavar_eurotech/screens/Bottom%20nav%20bar/bottom_nav_bar.dart';
import 'package:mahavar_eurotech/screens/Login/pin_page.dart';
import 'package:mahavar_eurotech/screens/Machine/machine_page.dart';
import 'package:mahavar_eurotech/screens/Products%20page/product_details_page.dart';
import 'package:mahavar_eurotech/screens/Service%20Request/my_request.dart';
import 'package:mahavar_eurotech/screens/Signup/signup.dart';
import 'package:mahavar_eurotech/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:mahavar_eurotech/models/request_details.dart';

class HttpApiCall {
  Future<String> retrieveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user id $userId");
    return userId = prefs.getString('user_id') ?? '';
  }

  Future<AllProducts?> getAllProducts() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_all_products.php'));
    request.fields.addAll({'API_KEY': apikey});

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return AllProductsFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<ProductDescription?> getProductDesc(String productId) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_single_product.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "product_id": productId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return ProductDescriptionFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<GetBrand?> getBrandData() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_all_parameters.php'));
    request.fields.addAll({
      'API_KEY': apikey,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetBrandFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<UserMachines?> getUserMachines() async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_user_machines.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return UserMachinesFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> addUserMachine(BuildContext context, MachineData data) async {
    String userId = await retrieveUserId();

    final temp = {
      'API_KEY': apikey,
      "user_id": userId,
      "brand_id": data.brandId!,
      "model_id": data.modelId!,
      "serial_no": data.serialNumber!,
      "label": data.label!,
    };
    print(temp);
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/add_machine.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
      "brand_id": data.brandId!,
      "model_id": data.modelId!,
      "serial_no": data.serialNumber!,
      "label": data.label!,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      toastification.show(
        context: context,
        title: Text(d['message']),
        alignment: const Alignment(0.5, 0.9),
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
      );
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MachinePage(),
          ),
          (route) => false,
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  Future<Map<String, dynamic>> getDropdownData() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_all_parameters.php'));
    request.fields.addAll({
      'API_KEY': apikey,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return json.decode(responsedata.body) as Map<String, dynamic>;
    } else {
      print(response.reasonPhrase);
      return {};
    }
  }

  Future<Map<String, dynamic>> getModelsById(Map<String, dynamic> data) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_models_by_id.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'brand_id': data['brand_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return json.decode(responsedata.body) as Map<String, dynamic>;
    } else {
      print(response.reasonPhrase);
      return {};
    }
  }

  Future<GetAllAddress?> getUserAddress() async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_all_service_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetAllAddressFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<GetSingleAddress?> getSingleAddress(Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/view_single_service_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
      "address_id": data['address_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetSingleAddressFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<GetNotification?> getNotification() async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_customer_notifications.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return GetNotificationFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> deleteNotification(
      BuildContext context, List<dynamic> notificationId) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/delete_customer_notifications.php'));

    request.fields['API_KEY'] = apikey;
    request.fields['user_id'] = userId;

    for (int i = 0; i < notificationId.length; i++) {
      request.fields['notification_id_array[$i]'] =
          notificationId[i].toString();
    }

    print(notificationId);
    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      print(d);
      showToast(context, d['message'], 3);
      if (d['error'] == false || d['error'] == true) {
        Navigator.pop(context);
      }
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> deleteAddress(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/delete_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "address_id": data['address_id'],
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      print(d);
      showToast(context, d['message'], 3);
      if (d['error'] == false) {
        Navigator.pop(context);
      }
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> addServiceAddress(
    BuildContext context,
    Map<String, dynamic> data,
    String machineId,
  ) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/add_service_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "area": data['area'],
      'user_id': userId,
      'pincode': data['pincode'],
      'address_line_1': data['address_line_1'],
      'landmark': data['landmark'],
      'address_type': data['address_type'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      print(d['message']);
      toastification.show(
        context: context,
        title: Text(d['message']),
        alignment: const Alignment(0.5, 0.9),
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
      );
      if (d['error'] == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ChooseAddressPage(
              machineId: machineId,
            ),
          ),
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  Future<void> editServiceAddress(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/edit_service_address.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'user_id': userId,
      'address_id': data['address_id'],
      "area": data['area'],
      'pincode': data['pincode'],
      'address_line_1': data['address_line_1'],
      'landmark': data['landmark'],
      'address_type': data['address_type'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      print(d['message']);
      toastification.show(
        context: context,
        title: Text(d['message']),
        alignment: const Alignment(0.5, 0.9),
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
      );
      if (d['error'] == false) {
        Navigator.pop(context);
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  Future<void> updateMobileNumber(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/update_mobile_verify_otp.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'user_id': userId,
      "mobile": data['mobile'],
      'otp': data['otp'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d["isRegistered"] == true) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("mobile_no", d['mobile_no']);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      } else {
        print('error');
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<RequestDetails?> getRequestDetails(Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_service_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
      'service_id': data['service_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return RequestDetailsFromJson(responsedata.body);
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> sendOTP(BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/sendOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "mobile": data['mobile'],
      "page_type": data['page_type'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (!d['error']) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PinPage(data: data),
          ),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> verifyOTP(
      BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/verifyOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "mobile": data['mobile'],
      'otp': data['otp'],
      'player_id': data['player_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      print(d['message']);
      showToast(context, d['message'], 3);

      if (d['isRegistered'] == false) {
        print(responsedata.body);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignUp(),
          ),
        );
      } else {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("loginInned", true);
        await prefs.setString("mobile_no", d['mobile_no']);
        await prefs.setString("full_name", d["full_name"]);
        // await prefs.setString("last_name", d["last_name"]);
        await prefs.setString("email", d["email"]);
        await prefs.setString("profile_image", d["profile_image"]);
        await prefs.setString("user_id", d['user_id'].toString());

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
          (route) => false,
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> registerUser(
      BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/register_user.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'mobile_no': data['mobile_no'],
      "full_name": data['full_name'],
      // "lastname": data['lastname'],
      'user_email': data['user_email'],
      'player_id': data['player_id'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body);

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['isRegistered'] == true) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("loginInned", true);
        await prefs.setString("mobile_no", d['mobile_no']);
        await prefs.setString("full_name", d["full_name"]);
        // await prefs.setString("last_name", d["last_name"]);
        await prefs.setString("email", d["email"]);
        await prefs.setString("profile_image", d["profile_image"]);
        await prefs.setString("user_id", d['user_id'].toString());
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> resendOTP(
      BuildContext context, Map<String, dynamic> data) async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/resendOTP.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "mobile": data['mobile'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> addServiceRequest(
      BuildContext context, ServiceRequest data) async {
    String userId = await retrieveUserId();

    final temp = {
      'API_KEY': apikey,
      "user_id": userId,
      "full_name": data.fullName,
      'customer_mobile_no': data.mobileNo,
      "machine_id": data.machineId,
      "address_id": data.addressId,
      "issue_id": data.selectedIssueID,
      "comments": data.comments,
      "service_date": data.scheduleServiceDate,
      "service_image": data.imageBase64,
      'service_time': data.time,
    };
    print(temp);
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/add_service_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
      "full_name": data.fullName!,
      'customer_mobile_no': data.mobileNo!,
      "machine_id": data.machineId!,
      "address_id": data.addressId!,
      "issue_id": data.selectedIssueID!,
      "comments": data.comments ?? '',
      "service_date": data.scheduleServiceDate!,
      "service_image": data.imageBase64 ?? '',
      'service_time': data.time ?? ''
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (!d['error']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyRequest(),
          ),
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  Future<UserRequest?> getUserRequest() async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/get_user_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return UserRequestFromJson(responsedata.body);
    } else {
      print(response.reasonPhrase);
    }
    return null;
  }

  Future<void> editServiceRequest(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/edit_service_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "user_id": userId,
      "full_name": data['full_name'],
      'mobile_no': data['mobile_no'],
      "service_id": data['service_id'],
      "issue_id": data['issue_id'],
      "comments": data['comments'],
      "service_date": data['service_date'],
      "service_image": data['service_image'],
      'service_time': data['service_time'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (!d['error']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MyRequest(),
          ),
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }

  Future<void> cancelServiceRequest(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/cancel_service_request.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      "service_id": data['service_id'],
      "user_id": userId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      print(d);
      showToast(context, d['message'], 3);
      if (d['error'] == false) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MyRequest(),
            ),
            (route) => false);
      }
      print(d['message']);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> changeServiceDate(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/change_service_date.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'user_id': userId,
      'service_id': data['service_id'],
      'service_date': data['service_date'],
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const BottomNavBar()),
            (route) => false);
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<void> sendEnquiry(BuildContext context, String productId) async {
    String userId = await retrieveUserId();

    var request =
        http.MultipartRequest('POST', Uri.parse('$mainUrl/send_enquiry.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'user_id': userId,
      'product_id': productId,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              productID: productId,
            ),
          ),
        );
      }
    } else {
      print("in else");
      print(response.reasonPhrase);
    }
  }

  Future<void> updateMapLocation(
      BuildContext context, Map<String, dynamic> data) async {
    String userId = await retrieveUserId();
    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/updateMapLocation.php'));
    request.fields.addAll(
      {
        'API_KEY': apikey,
        'user_id': userId,
        'address_id': data['address_id'],
        "latitude": data['latitude'],
        'longitude': data['longitude'],
      },
    );

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;

      showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.pop(context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> updateProfileDetails(
      BuildContext context, String fullName, String email) async {
    String userId = await retrieveUserId();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$mainUrl/update_customer_details.php'));
    request.fields.addAll({
      'API_KEY': apikey,
      'user_id': userId,
      'full_name': fullName,
      // 'last_name': lastName,
      'email': email,
    });

    http.StreamedResponse response = await request.send();
    var responsedata = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final d = json.decode(responsedata.body) as Map<String, dynamic>;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("full_name", fullName);
      // await prefs.setString("last_name", lastName);
      await prefs.setString("email", email);
      toastification.show(
        context: context,
        title: Text(d['message']),
        alignment: const Alignment(0.5, 0.9),
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 2),
      );
      // showToast(context, d['message'], 3);
      print(d['message']);
      if (d['error'] == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const BottomNavBar(),
          ),
        );
      }
    } else {
      print("error");
      print(response.reasonPhrase);
    }
  }
}
 // Future<void> addMachine(BuildContext context, MachineData data) async {
  //   final temp = {
  //     'API_KEY': apikey,
  //     "user_id": userId,
  //     "brand_id": data.brandId!,
  //     "model_id": data.modelId!,
  //     "serial_no": data.serialNumber!,
  //     "label": data.brandId!,
  //   };
  //   print(temp);
  //   var request =
  //       http.MultipartRequest('POST', Uri.parse('$mainUrl/add_machine.php'));
  //   request.fields.addAll({
  //     'API_KEY': apikey,
  //     "user_id": userId,
  //     "brand_id": data.brandId!,
  //     "model_id": data.modelId!,
  //     "serial_no": data.serialNumber!,
  //     "label": data.brandId!,
  //   });

  //   http.StreamedResponse response = await request.send();
  //   var responsedata = await http.Response.fromStream(response);

  //   if (response.statusCode == 200) {
  //     final d = json.decode(responsedata.body) as Map<String, dynamic>;

  //     showToast(context, d['message'], 3);

  //     print(d['message']);
  //     if (d['error']) {
  //       Navigator.pop(context);
  //     }
  //   } else {
  //     print("error");
  //     print(response.reasonPhrase);
  //   }
  // }