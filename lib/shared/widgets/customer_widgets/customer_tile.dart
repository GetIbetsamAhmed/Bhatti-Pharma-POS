import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/others/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomerTile extends StatefulWidget {
  final int index;
  final Widget icon;
  final int animationDurationInMSec;
  final Customer customer;
  final bool canCopy;
  final Function() onTap;

  const CustomerTile({
    super.key,
    this.index = 0,
    required this.icon,
    required this.customer,
    this.animationDurationInMSec = 200,
    this.canCopy = true,
    required this.onTap,
  });

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile>
    with SingleTickerProviderStateMixin {
  bool isNumberTapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    launchUrlString("tel:${widget.customer.phone!}");
                  },
                  icon: Icons.call,
                  backgroundColor: Colors.green,
                ),
                SlidableAction(
                  onPressed: (context) {
                    launchUrlString("sms:${widget.customer.phone!}");
                  },
                  icon: Icons.sms,
                  backgroundColor: blueColor,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              // margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: borderRadius05,
                color: bgColor,
                border: border,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Icon
                      Row(
                        children: [
                          widget.icon,
                          const Space10h(),

                          // Name and email tile
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Customer Name
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.68,
                                child: Text(
                                  widget.customer.customerName!,
                                  style: const TextStyle600FW16FS(
                                      textColor: blueColor),
                                  maxLines: 02,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                ),
                              ),

                              const Space05v(),
                              // Customer Phone
                              Text(
                                "Phone: ${widget.customer.phone!}",
                                style: const TextStyle400FW12FS(
                                  textColor: greyTextColor,
                                ),
                                maxLines: 01,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (widget.canCopy)
                        InkWell(
                          child: const Icon(Icons.copy,
                              size: 16, color: greyIconColor),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text:
                                    "Customer Name: ${widget.customer.customerName}\nAddress: ${widget.customer.area!}\nPhone: ${widget.customer.phone!}",
                              ),
                            );
                            showToast(
                              "Copied to clipboard",
                              Colors.white,
                            );
                          },
                        ),
                    ],
                  ),
                  const Divider(
                    color: borderColor,
                    thickness: 01,
                  ),
                  const Space05v(),
                  // Address
                  Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.customer.area!,
                        style: const TextStyle400FW12FS(),
                        maxLines: 03,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const Space10v(),
        ],
      ),
    );
  }
}
