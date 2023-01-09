// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:bhatti_pos/screens/base_screen/basescreen.dart';
import 'package:bhatti_pos/screens/customers/services/create_customer.dart';
import 'package:bhatti_pos/screens/customers/services/delete_customer.dart';
import 'package:bhatti_pos/screens/customers/services/edit_customer.dart';
import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/function.dart';
import 'package:bhatti_pos/shared/widgets/login_widgets/processing_indicator.dart';
import 'package:bhatti_pos/shared/widgets/others/custom_button.dart';
import 'package:bhatti_pos/shared/widgets/others/screen_ratio.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:bhatti_pos/state_management/provider/provider_state.dart';
import 'package:bhatti_pos/state_management/static_data/state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EditCustomer extends StatefulWidget {
  final String text;
  final int customerIndex;
  const EditCustomer({
    super.key,
    required this.text,
    required this.customerIndex,
  });

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool isCreated = false;
  Customer? customer;
  @override
  void initState() {
    super.initState();
    if (widget.customerIndex >= 0) {
      if (kDebugMode) print(widget.customerIndex);
    }
  }

  @override
  void dispose() async {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      onWillPop: () async{
        return true;
      },
      screenTitle: widget.text,
      onTap: () {
        Navigator.pop(context);
      },
      onChanged: (val) {},
      showSearch: false,
      widget: GestureDetector(
        onTap: () {
          closeKeyBoard();
        },
        child: ScreenRatio(
          child: SingleChildScrollView(
            child: Consumer<CartProvider>(
              builder: (context, value, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Space30v(),
                  // Name Field
                  _customTextField(
                    "Customer Name",
                    "profile",
                    _nameController,
                    TextInputType.name,
                    widget.customerIndex >= 0 ? 1 : null,
                  ),
                  const Space30v(),

                  // Phone Number Field
                  _customTextField(
                    "Customer Phone Number",
                    "lock",
                    _phoneNumberController,
                    TextInputType.number,
                    widget.customerIndex >= 0 ? 2 : null,
                  ),

                  const Space30v(),

                  // Address Field
                  _customTextField(
                    "Customer Area Name",
                    "location",
                    _addressController,
                    TextInputType.text,
                    widget.customerIndex >= 0 ? 3 : null,
                  ),
                  const Space30v(),
                  const Space30v(),

                  // Editing/ Creating Button
                  CustomElevatedButton(
                    onTap: () async {
                      // Clearing all filters applied on Customer Screen
                      value.clearCustomerFilter();
                      if (_areFieldsEmpty()) {
                        showToast(
                          "Some required fields are empty",
                          Colors.white,
                        );
                      } else {
                        closeKeyBoard();

                        LoginWidgets.processingIndicator(context);
                        String? data;
                        if (widget.customerIndex <
                            0 /* User is Coming from create customer */) {
                          data = await createCustomer(
                            _addressController.text,
                            _phoneNumberController.text,
                            _nameController.text,
                          );

                          _clearControllers();
                          Navigator.pop(context);
                        } else /* User is coming from edit customer */ {
                          data = await editCustomer(
                            customer!.id!,
                            _addressController.text,
                            _nameController.text,
                            _phoneNumberController.text,
                          );
                        }
                        // refreshing the user list to e didplayed
                        value.resetCustomers();

                        // clearing the controller and closing dialog
                        if (data != null) {
                          showToast(data, Colors.white);
                          LoginWidgets.closeProcessingIndicator(context);
                        }
                      }
                    },
                    color: blueColor,
                    text: widget.customerIndex < 0
                        ? widget.text
                        : "Confirm Changes",
                  ),
                  if (widget.customerIndex >= 0) const Space30v(),

                  // Deleting Button
                  if (widget.customerIndex >= 0)
                    CustomElevatedButton(
                      onTap: () async {
                        // Clearing all filters applied on Customer Screen
                        value.clearCustomerFilter();
                        closeKeyBoard();
                        LoginWidgets.processingIndicator(context);

                        // if the user is coming from edit customer only
                        String? data = await deleteCustomer(customer!.id!);
                        // refreshing the screen used to display customers on Customers screen
                        value.resetCustomers();

                        if (data != null) {
                          showToast(data, Colors.white);
                          LoginWidgets.closeProcessingIndicator(context);
                          Navigator.pop(context);
                          _clearControllers();
                        }
                      },
                      color: Colors.red,
                      text: "Delete Customer",
                    ),

                  const Space30v(),
                  const Space30v(),
                  const Space20v(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _areFieldsEmpty() {
    if (_nameController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty) {
      return false;
    }
    return true;
  }

  _clearControllers() {
    _addressController.clear();
    _phoneNumberController.clear();
    _nameController.clear();
  }

  _customTextField(
    String labelText,
    String icon,
    TextEditingController controller,
    TextInputType keyboardType,
    int? hint,
  ) {
    if (hint != null) {
      customer = CustomerList.customers[0];
      // Grabing value that contain the corresponding id to perform further,
      for (Customer instance in CustomerList.customers) {
        if (instance.id! == widget.customerIndex) {
          customer = instance;
          break;
        }
      }

      // Saving value in controller corresponding to controller datatype.
      if (hint == 1) {
        controller.text = customer!.customerName!;
      } else if (hint == 2) {
        controller.text = customer!.phone!;
      } else {
        controller.text = customer!.area!;
      }
    }
    return TextFormField(
      controller: controller,
      cursorColor: blueColor,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      cursorHeight: 22,
      onChanged: (val) {},
      decoration: InputDecoration(
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          child: SvgPicture.asset("assets/icons/$icon.svg"),
        ),
        labelText: labelText,
        floatingLabelStyle: const TextStyle(color: greyTextColor),
        labelStyle: const TextStyle(color: greyTextColor),
        enabledBorder: const OutlineInputBorder(
          borderSide: borderSide,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: borderSide,
        ),
      ),
    );
  }
}
