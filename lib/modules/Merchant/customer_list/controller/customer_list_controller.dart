import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CustomerListController extends GetxController {

  RxBool isRemoveOn = false.obs;

  RxBool isDataLoading = true.obs;


}


class ContactList {

  String fullName;
  String mobileNumber;
  String address;

  ContactList({
    required this.fullName,
    required this.mobileNumber,
    required this.address,
});

}

List<ContactList> contactLists = <ContactList>[];