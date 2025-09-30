import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/appnumericformfield.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/screens/delivery/api_service_delivery.dart';
import 'package:food_wms/screens/delivery/list_item_delivery_pallet_items.dart';

class DeliveryScreen extends StatefulWidget {
  final String deliveryNo;
  final String locator;
  final DeliveryPalletItemsListItem listitem;

  const DeliveryScreen({
    super.key,
    required this.deliveryNo,
    required this.locator,
    required this.listitem,
  });

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    quantityController.text = widget.listitem.enteredquantity;
    weightController.text = widget.listitem.enteredweight;
  }

  void _saveRecords(BuildContext context) async {
    try {
      if (quantityController.text.isNotEmpty) {
        double quantity = double.tryParse(quantityController.text) ?? 0;
        double orderedquantity =
            double.tryParse(widget.listitem.orderedquantity) ?? 0;
        if (quantity <= 0) {
          AppFunctions.showError(context, "Invalid Quantity");
        }

        if (quantity > orderedquantity) {
          AppFunctions.showError(
            context,
            "Entered Quantity cannot be greater than Ordered Quantity",
          );
          return;
        }
      }

      if (weightController.text.isNotEmpty) {
        double? weight = double.tryParse(weightController.text);
        if (weight == null) {
          AppFunctions.showError(context, "Invalid Weight");
        }
      }

      String result = await DeliveryApiService.deliveryDetailsupdate(
        widget.listitem.lineid,
        quantityController.text,
        quantityController.text,
        weightController.text,
      );

      if (result == "Success") {
        AppFunctions.showSuccessDialog(
          context,
          "Information Saved Successfully",
        );

        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
          // Close the delivery screen
          Navigator.of(context).pop();
        });
      } else {
        AppFunctions.showError(context, result);
      }
    } catch (e) {
      AppFunctions.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Pickup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveRecords(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.listitem.itemcode} - ${widget.listitem.itemdescription}}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery No : ${widget.deliveryNo}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'Line Id : ${widget.listitem.lineid}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Locator : ${widget.locator}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'Pallet : ${widget.listitem.pallet}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expiry : ${widget.listitem.expirydate}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'Lot No : ${widget.listitem.lotno}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Primary UOM : ${widget.listitem.primaryuom}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'Ordered UOM : ${widget.listitem.orderedquantityuom}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ordered Quantity : ${widget.listitem.orderedquantity}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Divider(thickness: 1.0, color: AppTheme.accentColor),
            ),

            AppNumericFormField(
              labelText: 'Quantity',
              controller: quantityController,
              validator: (value) {
                return AppFunctions.validatePositiveNumber(value, 'Quantity');
              },
            ),

            AppNumericFormField(
              controller: weightController,
              labelText: 'Weight',
              validator: (value) {
                return AppFunctions.validatePositiveNumber(value, 'Weight');
              },
            ),
            // AppTextFormField(
            //   labelText: 'Remarks',
            //   initialValue: '',
            //   onChanged: (returnvalue) {
            //     remarksController.text = returnvalue;
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
