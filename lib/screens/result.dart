import 'dart:math';

import 'package:bmi/res/res.dart';
import 'package:gauge_indicator/gauge_indicator.dart' as gauge;

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.age,
    required this.gender,
  });

  final int height;
  final int weight;
  final int age;
  final int gender; // 'male' or 'female'

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double bmi = 0;

  @override
  void initState() {
    super.initState();
    bmi = double.parse(
        (widget.weight / pow(widget.height / 100, 2)).toStringAsFixed(1));
    debugPrint('BMI: $bmi');
    // bmi = 16;
  }

  String getBmiCategory() {
    if (bmi < 18.5) {
      return 'underweight';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'normal';
    } else if (bmi >= 25 && bmi <= 34.9) {
      return 'overweight';
    } else {
      return 'obese';
    }
  }

  String getBmiDescription() {
    if (bmi < 18.5) {
      return 'You are under the normal weight range. Consider consulting with a healthcare provider for advice.';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'You are within the normal weight range. Keep up the good work!';
    } else if (bmi >= 25 && bmi <= 34.9) {
      return 'You are above the normal weight range. Consider a balanced diet and regular exercise.';
    } else {
      return 'You are significantly above the normal weight range. It is advisable to consult with a healthcare provider.';
    }
  }

  String getHealthyWeightRange() {
    double minWeight = 18.5 * pow(widget.height / 100, 2);
    double maxWeight = 24.9 * pow(widget.height / 100, 2);
    return '${minWeight.toStringAsFixed(1)} kg - ${maxWeight.toStringAsFixed(1)} kg';
  }

  double getBmiPrime() {
    return bmi / 25;
  }

  double getPonderalIndex() {
    return widget.weight / pow(widget.height / 100, 3);
  }

  String getAgeGenderAdjustedDescription() {
    String description = getBmiDescription();
    if (widget.gender == 2) {
      description +=
          ' Women generally have more body fat than men at the same BMI.';
    }

    if (widget.age < 18) {
      description +=
          '\n\nNote: BMI calculations for children and teenagers are different from adults.';
    } else if (widget.age > 65) {
      description += '\n\nNote: BMI may not be as accurate for older adults.';
    }

    return description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        title: Text(
          'Your result',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  gauge.AnimatedRadialGauge(
                    duration: 3.seconds,
                    curve: Curves.elasticOut,
                    radius: 100,
                    value: bmi,
                    axis: gauge.GaugeAxis(
                      min: 0,
                      max: 50,
                      degrees: 240,
                      style: gauge.GaugeAxisStyle(
                        thickness: 15.sp,
                        background: Colors.transparent,
                        segmentSpacing: 4,
                      ),
                      pointer: gauge.GaugePointer.triangle(
                        width: 12.w,
                        height: 50.h,
                        borderRadius: 4.r,
                        color: lightOrangeColor,
                        shadow: Shadow(
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 5,
                        ),
                      ),
                      progressBar: gauge.GaugeProgressBar.rounded(
                        color: Colors.transparent,
                      ),
                      segments: [
                        gauge.GaugeSegment(
                          from: 0,
                          to: 18.4,
                          border: bmi < 18.4
                              ? gauge.GaugeBorder(
                                  color: Colors.white,
                                  width: 2,
                                )
                              : null,
                          color: yellowColor,
                          cornerRadius: Radius.circular(4.r),
                        ),
                        gauge.GaugeSegment(
                          from: 18.5,
                          to: 24.9,
                          border: bmi >= 18.5 && bmi <= 24.9
                              ? gauge.GaugeBorder(
                                  color: Colors.white,
                                  width: 2,
                                )
                              : null,
                          color: greenColor,
                          cornerRadius: Radius.circular(4.r),
                        ),
                        gauge.GaugeSegment(
                          from: 25,
                          to: 34.9,
                          border: bmi >= 25 && bmi <= 34.9
                              ? gauge.GaugeBorder(
                                  color: Colors.white,
                                  width: 2,
                                )
                              : null,
                          color: orangeColor,
                          cornerRadius: Radius.circular(4.r),
                        ),
                        gauge.GaugeSegment(
                          from: 35,
                          to: 50,
                          border: bmi >= 35 && bmi <= 50
                              ? gauge.GaugeBorder(
                                  color: Colors.white,
                                  width: 2,
                                )
                              : null,
                          color: redColor,
                          cornerRadius: Radius.circular(4.r),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          bmi.toString(),
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: bmi < 18.5
                                ? yellowColor
                                : bmi >= 18.5 && bmi <= 24.9
                                    ? greenColor
                                    : bmi >= 25 && bmi <= 34.9
                                        ? orangeColor
                                        : redColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'kg/m²',
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            50.sH,
            RichText(
              text: TextSpan(
                text: 'Your BMI is ',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'Circular',
                  color: Colors.white,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: getBmiCategory(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Circular',
                      fontWeight: FontWeight.bold,
                      color: bmi < 18.5
                          ? yellowColor
                          : bmi >= 18.5 && bmi <= 24.9
                              ? greenColor
                              : bmi >= 25 && bmi <= 34.9
                                  ? orangeColor
                                  : redColor,
                    ),
                  ),
                ],
              ),
            ),
            10.sH,
            Text(
              getAgeGenderAdjustedDescription(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            40.sH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Healthy BMI range:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  '18.5 - 24.9',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Divider(
              color: secondaryColor,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Healthy weight range:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  getHealthyWeightRange(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
            Divider(
              color: secondaryColor,
              thickness: 1,
            ),
            20.sH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'BMI Prime',
                      style: TextStyle(
                        color: yellowColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.sH,
                    Text(
                      getBmiPrime().toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Ponderal Index',
                      style: TextStyle(
                        color: yellowColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    10.sH,
                    Text(
                      '${getPonderalIndex().toStringAsFixed(1)} kg/m³',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ZoomTapAnimation(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            10.sH,
          ],
        ),
      ),
    );
  }
}
