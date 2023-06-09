import "package:flutter/material.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";
import "package:provider/provider.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:pocket_pal/const/font_style.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

import "package:pocket_pal/widgets/pocket_pal_button.dart";
import "package:pocket_pal/widgets/pocket_pal_formfield.dart";

import "package:pocket_pal/screens/auth/widgets/auth_title.dart";
import "package:pocket_pal/screens/auth/widgets/dialog_box.dart";

import "package:pocket_pal/services/authentication_service.dart";
import "package:pocket_pal/const/color_palette.dart";
import "package:pocket_pal/utils/password_checker_util.dart";
import "package:pocket_pal/providers/settings_provider.dart";

class ForgotPasswordPage extends StatefulWidget { 
  const ForgotPasswordPage({ Key ? key }) : super(key : key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}


class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  bool _isButtonEnable = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController( text : "");

  @override
  void initState(){
    super.initState();
    _email.addListener(_textEditingControllerListener);
    return;
  }
  @override
  void dispose(){
    super.dispose();
    _email.removeListener(_textEditingControllerListener);
    _email.dispose();
    return;
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar : AppBar(),

      body : AnimationLimiter(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 20.h
            ),
            
            child: Form(
              key : _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children : AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget){
                    return SlideAnimation(
                      duration : const Duration(milliseconds: 375),
                      verticalOffset: 40.0,

                      child : FadeInAnimation(
                        duration : const Duration(milliseconds: 480),
                        child : widget
                      )
                    );
                  },

                  children: _appBuilder()
                )
              ),
            ),
          ),
        ),
      )
    );
  }

  List<Widget> _appBuilder(){
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);    
    return [
      SvgPicture.asset(
        "assets/svg/forgot_password.svg",
        width : 280.w,
        height : 280.h
      ),

      SizedBox(height : 20.h),

      MyAuthTitleWidget(
        authTitleTitle: "Forgot Password?", 
        authTitleMessage: "Enter your email below to receive instructions in retrieving your account.",
        authTitleTitleSize: 30.sp,
        authTitleTitleMessageSize: 14.sp,
      ),

      SizedBox( height : 10.h),
      SizedBox(
        height : 50.h,
        child: PocketPalFormField(
          formController: _email,
          formHintText: "Email Address",
          formValidator: (value){
            if (value == null || value.isEmpty){
              return "Please enter an Email Address";
            } else if (!isEmailAddress(value)) {
              return "Please enter a valid Email Address";
            } else {
              return null;
            }
          },
      
        ),
      ),

      SizedBox( height : 14.h),
      PocketPalButton(
        buttonOnTap: (!_isButtonEnable)? null : (){
          if (_formKey.currentState!.validate()){
            _formKey.currentState!.save();

            if (settingsProvider.getBoolPreference("isFirstInstall")){
              settingsProvider.setBoolPreference("isFirstInstall", false);
            }
            _forgotPasswordPageResetPassword();
            Navigator.of(context).pop();
          }
        }, 
        buttonWidth: double.infinity, 
        buttonHeight: 50.h, 
        buttonColor: (!_isButtonEnable) ?
          ColorPalette.black :
          ColorPalette.crimsonRed, 
        buttonChild: bodyText(
          "Submit",
          bodySize : 16.sp,
          bodyWeight : FontWeight.w600,
          bodyColor : ColorPalette.white
          
        )
      )
    ];
  }

  void _textEditingControllerListener() => setState((){
    _isButtonEnable = _email.text.isNotEmpty;
  });

  Future<void> _forgotPasswordPageResetPassword() async{
    
    try {
      await PocketPalAuthentication()
              .authenticationResetPassword(
                _email.text.trim()
              );
    } on FirebaseAuthException catch (e){
      print("Error Occurred: $e");
      showDialog(
        context : context,
        builder: (context) {
          return const MyDialogBoxWidget(
            dialogBoxTitle: "User Not Found",
            dialogBoxDescription: "User doesn't Exists. Please check your email and try again."
          );
        },
      );
    }
    return;
  }

}