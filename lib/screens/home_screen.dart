import 'package:flutter/material.dart';
import 'package:food_wms/apptheme.dart';
import 'package:food_wms/customcontrols/approutes.dart';
import 'package:food_wms/customcontrols/commonfunction.dart';
import 'package:food_wms/customcontrols/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String title() {
    return SharedPreferencesHelper.loadString(
      SharedPreferencesHelper.KEY_ORGNAME,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: AppFunctions.footer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title(), style: Theme.of(context).textTheme.headlineLarge),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Divider(color: AppTheme.accentColor),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: <Widget>[
                  _buildMenuCard(
                    context,
                    'Receive',
                    Icons.download,
                    AppRoutes.receive,
                  ),
                  _buildMenuCard(
                    context,
                    'Delivery',
                    Icons.upload,
                    AppRoutes.delivery,
                  ),
                  _buildMenuCard(
                    context,
                    'Relocate Pallet',
                    Icons.pallet,
                    AppRoutes.relocatepallet,
                  ),
                  _buildMenuCard(
                    context,
                    'Relocate Item',
                    Icons.move_down,
                    AppRoutes.relocateitems,
                  ),
                  _buildMenuCard(
                    context,
                    'Stock Check',
                    Icons.list_alt,
                    AppRoutes.stockcheck,
                  ),
                  _buildMenuCard(
                    context,
                    'Search Item',
                    Icons.search,
                    AppRoutes.searchitem,
                  ),
                  // _buildMenuCard(
                  //   context,
                  //   'Sales Return',
                  //   Icons.arrow_outward,
                  //   AppRoutes.salesreturn,
                  // ),
                  _buildMenuCard(
                    context,
                    'Logoff',
                    Icons.logout,
                    AppRoutes.login,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    String redirect,
  ) {
    return Card(
      
      child: InkWell(
        onTap: () {
          switch (redirect) {
            case AppRoutes.searchitem:
              AppRoutes.redirectsearchitem(context);
              break;
            case AppRoutes.receive:
              AppRoutes.redirectrecieve(context);
              break;
            case AppRoutes.delivery:
              AppRoutes.redirectdelivery(context);
              break;
            case AppRoutes.relocatepallet:
              AppRoutes.redirectrelocatepallet(context);
              break;
            case AppRoutes.relocateitems:
              AppRoutes.redirectrelocateitems(context);
              break;
            case AppRoutes.stockcheck:
              AppRoutes.redirectstockcheck(context);
              break;
            case AppRoutes.salesreturn:
              AppRoutes.redirectsalesreturn(context);
              break;
            case AppRoutes.login:
              AppRoutes.redirectlogoff(context);
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 36.0),
            const SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
