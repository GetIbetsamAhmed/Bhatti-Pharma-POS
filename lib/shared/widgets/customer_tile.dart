import 'package:bhatti_pos/services/models/customer.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/border_widgets.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CustomerTile extends StatefulWidget {
  final int index;
  final Widget icon;
  final int animationDurationInMSec;
  final Customer customer;

  const CustomerTile({
    super.key,
    this.index = 0,
    required this.icon,
    required this.customer,
    this.animationDurationInMSec = 200,
  });

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile>
    with SingleTickerProviderStateMixin {
  bool isNumberTapped = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  launchUrlString("tel:${widget.customer.phno!}");
                },
                icon: Icons.call,
                backgroundColor: Colors.green,
              ),
              SlidableAction(
                onPressed: (context) {
                  launchUrlString("sms:${widget.customer.phno!}");
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
              borderRadius: BorderRadius.circular(01),
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
                          children: [
                            // Customer Name
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.customer.name!,
                                style:
                                    const TextStyle600FW16FS(textColor: blueColor),
                                maxLines: 01,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            const Space05v(),
                            // Customer Gmail
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                widget.customer.gmail!,
                                style: const TextStyle400FW12FS(),
                                maxLines: 01,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      child: const Icon(Icons.copy, size: 16, color: greyIconColor),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                "Name: ${widget.customer.name}\nAddress: ${widget.customer.address!}\nPhone: ${widget.customer.phno!}\nGmail: ${widget.customer.gmail!}\n",
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
                      widget.customer.address!,
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

        const Space10v(),
      ],
    );
  }
}
