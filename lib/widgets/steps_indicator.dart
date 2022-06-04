import 'package:cambioseguro/shared/custom_divider.dart';
import 'package:flutter/material.dart';

class StepsIndicator extends StatelessWidget {
  const StepsIndicator({
    Key key,
    this.steps = 3,
    this.currentStep = 1,
  }) : super(key: key);

  final int steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (int i = 1; i <= steps; i++) ...[
          Icon(
            Icons.radio_button_checked,
            color: i > currentStep ? Colors.white : Color(0XFFFFC23B),
          ),
          if (i < steps && i <= currentStep)
            SizedBox(
              width: 40,
              child: Divider(
                color: currentStep > i ? Color(0XFFFFC23B) : Colors.white,
                thickness: 1,
                // width: 10,
              ),
            ),

          if(i < steps && i > currentStep)
            SizedBox(
              width: 40,
              child: CustomDivider(
                color: i > currentStep ? Colors.white : Color(0XFFFFC23B),
              ),
            ),
        ],

        // Icon(Icons.radio_button_unchecked),
        // SizedBox(
        //     width: 40,
        //     child: CustomDivider(
        //       color: Colors.white,
        //     )),
        // Icon(Icons.radio_button_unchecked)
      ],
    );
  }
}
