import 'package:cambioseguro/helpers/ui_helpers.dart';
import 'package:cambioseguro/models/bank_account.dart';
import 'package:flutter/material.dart';

class BankAccountItem extends StatelessWidget {
  const BankAccountItem({
    Key key,
    @required this.bankAccount,
    @required this.onDelete,
    @required this.onEdit,
  }) : super(key: key);

  final BankAccount bankAccount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all(8),
      color: Color(0xFFF4F4F4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (bankAccount.busy) LinearProgressIndicator(),
                  Text(
                    "${bankAccount.nameBank}",
                    style: TextStyle(fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${bankAccount.alias}",
                    style: TextStyle(fontWeight: FontWeight.w800),
                    overflow: TextOverflow.ellipsis,
                  ),
                  UIHelper.verticalSpaceMiniSmall,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Cuenta"),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          "${bankAccount.bankAccountNumber}",
                          style: TextStyle(fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceMiniSmall,
                  Row(
                    children: <Widget>[
                      Text("Moneda"),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                        child: Text(
                          "${bankAccount.currencyType}",
                          style: TextStyle(fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!bankAccount.busy)
            Container(
              width: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).primaryColor),
                    onPressed: onDelete,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
