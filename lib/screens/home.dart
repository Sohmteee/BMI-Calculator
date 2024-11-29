import 'package:bmi/res/res.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int gender = 1;
  int age = 18;
  int height = 165;
  int weight = 70;
  late PageController _genderController;
  late NumericRulerScalePickerController _weightController;

  @override
  void initState() {
    super.initState();
    _genderController = PageController(
      initialPage: gender - 1,
    );

    _weightController = NumericRulerScalePickerController(
      firstValue: 5,
      lastValue: 300,
      initialValue: weight,
    )..addListener(() {
        setState(() {
          weight = _weightController.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        toolbarHeight: 60.h,
        title: Text(
          'BMI Calculator',
          style: TextStyle(fontSize: 20.sp),
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        children: [
          Row(
            children: [
              Expanded(
                child: _buildGenderCard(),
              ),
              Expanded(
                child: _buildAgeCard(),
              ),
            ],
          ),
          _buildHeight(context),
          _buildWeight(context),
          15.sH,
          ZoomTapAnimation(
            child: ElevatedButton(
              onPressed: () {
                if (height == 0) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please enter your height'),
                      ),
                    );
                  return;
                } else if (weight == 0) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please enter your weight'),
                      ),
                    );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(
                      height: height,
                      weight: weight,
                      age: age,
                      gender: gender,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text('Calculate BMI'),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildWeight(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 100.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    children: [
                      Spacer(flex: 10),
                      Icon(
                        Icons.scale_rounded,
                        color: Colors.white24,
                        size: 30.sp,
                      ),
                      10.sH,
                      Text('Weight'),
                      Spacer(flex: 5),
                      Text(
                        '$weight kg',
                        style: TextStyle(
                          color: yellowColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
                width: 150.w,
                child: NumericRulerScalePicker(
                  controller: _weightController,
                  options: RulerScalePickerOptions(
                    majorIndicatorInterval: 5,
                    showControls: false,
                    indicatorExtend: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildHeight(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 15.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 200.h,
                child: Column(
                  children: [
                    Spacer(flex: 10),
                    RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.straighten,
                        color: Colors.white24,
                        size: 30.sp,
                      ),
                    ),
                    10.sH,
                    Text('Height'),
                    Spacer(flex: 5),
                    TextButton(
                      onPressed: () {
                        void setHeight(int value) {
                          if (value >= 50 && value <= 250) {
                            setState(() {
                              height = value;
                            });
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'Please enter a valid height between 50 and 250 cm'),
                                ),
                              );
                          }
                        }

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController heightController =
                                TextEditingController(
                              text: height.toString(),
                            );
                            return AlertDialog(
                              title: Text('Enter Height'),
                              content: TextField(
                                controller: heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'Enter height in cm',
                                  suffixText: 'cm',
                                  
                                ),
                                onChanged: (value) {
                                  if (value.length == 3) {
                                    setHeight(int.tryParse(value) ?? 0);
                                  }
                                },
                                onSubmitted: (_) {
                                  setHeight(
                                      int.tryParse(heightController.text) ?? 0);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setHeight(
                                        int.tryParse(heightController.text) ??
                                            0);
                                  },
                                  child: Text('Done'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: Text(
                        'Enter manually',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200.h,
                width: 200.w,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: 100.w,
                      child: Image.asset(
                        'assets/images/${gender == 1 ? 'male' : 'female'}.png',
                        height: (((height / 250) * 200) - 10).h,
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                      width: 200.w,
                      child: SfLinearGauge(
                        orientation: LinearGaugeOrientation.vertical,
                        maximum: 250,
                        minimum: 0,
                        interval: 50,
                        isMirrored: true,
                        axisLabelStyle: TextStyle(
                          color: Colors.white,
                        ),
                        majorTickStyle: LinearTickStyle(
                          length: 10,
                          thickness: 2,
                          color: Colors.white,
                        ),
                        minorTickStyle: LinearTickStyle(
                          length: 5,
                          thickness: 1,
                          color: Colors.white,
                        ),
                        axisTrackStyle: LinearAxisTrackStyle(
                          thickness: 2,
                          color: Colors.white24,
                        ),
                        markerPointers: [
                          LinearWidgetPointer(
                            value: height.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                height = value.toInt();
                              });
                            },
                            position: LinearElementPosition.outside,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_left,
                                  color: yellowColor,
                                  size: 20.sp,
                                ),
                                Text(
                                  '${height.toInt()} cm (${(height * 0.0328084).floor()}\' ${(height * 0.393701 % 12).toStringAsFixed(0)}")',
                                  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card _buildAgeCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 15.w,
        ),
        child: Center(
          child: Column(
            children: [
              Text('Age'),
              20.sH,
              Text(
                '$age years',
                style: TextStyle(
                  color: yellowColor,
                ),
              ),
              20.sH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      setState(() {
                        if (age > 1) age--;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      setState(() {
                        if (age < 100) age++;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildGenderCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 15.w,
        ),
        child: Center(
          child: Column(
            children: [
              Text('Gender'),
              15.sH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _genderController.animateToPage(
                          0,
                          duration: 500.milliseconds,
                          curve: Curves.elasticOut,
                        );
                      });
                    },
                    splashColor: Colors.transparent,
                    splashRadius: 1,
                    icon: Icon(
                      Icons.chevron_left,
                      color: gender == 1 ? Colors.white24 : Colors.white,
                    ),
                  ),
                  Icon(
                    gender == 1 ? Icons.male : Icons.female,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    splashRadius: 1,
                    onPressed: () {
                      setState(() {
                        _genderController.animateToPage(
                          1,
                          duration: 500.milliseconds,
                          curve: Curves.elasticOut,
                        );
                      });
                    },
                    icon: Icon(
                      Icons.chevron_right,
                      color: gender != 1 ? Colors.white24 : Colors.white,
                    ),
                  ),
                ],
              ),
              15.sH,
              SizedBox(
                height: 20.h,
                width: double.infinity,
                child: Center(
                  child: PageView(
                    controller: _genderController,
                    physics: BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        gender = index + 1;
                      });
                    },
                    children: [
                      Center(
                        child: Text(
                          'Male',
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Female',
                          style: TextStyle(
                            color: yellowColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
