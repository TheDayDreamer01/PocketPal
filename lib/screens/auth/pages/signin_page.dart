import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";

import "package:pocket_pal/const/font_style.dart";
import "package:pocket_pal/const/color_palette.dart";

import "package:pocket_pal/providers/user_provider.dart";
import "package:pocket_pal/providers/settings_provider.dart";

import "package:pocket_pal/screens/auth/pages/forgot_password_page.dart";
import "package:pocket_pal/screens/auth/widgets/dialog_box.dart";
import "package:pocket_pal/screens/auth/widgets/bottom_hyperlink.dart";
import "package:pocket_pal/screens/auth/widgets/auth_title.dart";

import "package:pocket_pal/widgets/pocket_pal_button.dart";
import "package:pocket_pal/widgets/pocket_pal_formfield.dart";

import "package:pocket_pal/utils/pal_user_util.dart";
import "package:pocket_pal/utils/password_checker_util.dart";

import "package:pocket_pal/services/authentication_service.dart";


class SignInPage extends StatefulWidget {

  final void Function() ? changeStateIsFirstInstall;

  const SignInPage({ 
    Key ? key,
    required this.changeStateIsFirstInstall 
  }) : super(key : key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage>{

  bool _isButtonEnable = false;
  bool _isObsecure = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController(text : "");
  final TextEditingController _password = TextEditingController(text : "");

  @override
  void initState(){
    super.initState();
    _email.addListener(_textEditingControllerListener);
    _password.addListener(_textEditingControllerListener);
    return;
  }

  @override
  void dispose(){
    super.dispose();

    _email.removeListener(_textEditingControllerListener);
    _password.removeListener(_textEditingControllerListener);

    _email.dispose();
    _password.dispose();
    return;
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body : AnimationLimiter(
        child: Center(
          child : SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),

            child : Form(
              key : _formKey, 
              child : Column(
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
              )
            )
          )
        ),
      )
    );
  }
  
  List<Widget> _appBuilder(){
    final SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context); 
    
    return [
      MyAuthTitleWidget(
        authTitleTitle: "Let's Get Going!",
        authTitleMessage: "Sign in to access your saved items and\npersonalized recommendations.",
        authTitleTitleSize: 30.sp,
        authTitleTitleMessageSize: 14.sp,
      ),

      SizedBox( height : 32.h),
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

      SizedBox( height : 10.h ),
      SizedBox(
        height : 50.h,
        child: PocketPalFormField(
          formController: _password,
          formIsObsecure: _isObsecure,
          formHintText: "Password",
          formSuffixIcon: IconButton(
            icon : Icon(
              (_isObsecure) ? 
                FeatherIcons.eye : 
                FeatherIcons.eyeOff
            ),
            onPressed: () => setState(() => _isObsecure = !_isObsecure),
          ),
          formValidator: (value){
            if (value == null || value.isEmpty){
              return "Please enter your password";
            } else if (value.length < 8){
              return "Password must be at least 8 characters long";
            } else {
              return null;
            }
          },
        ),
      ),
      SizedBox( height : 6.h ),
      GestureDetector(
        onTap : _navigateToForgotPassword, 
        child: bodyText(
          "Forgot Password?",
          bodyAlignment: TextAlign.end,
          bodySize : 14.sp,
        ),
      ),

      SizedBox( height : 40.h),
      PocketPalButton(
        buttonOnTap: (!_isButtonEnable) ? null : (){
          if (_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            
            _signInPageEmailAndPasswordAuth();
            if (settingsProvider.getBoolPreference("isFirstInstall")){
              settingsProvider.setBoolPreference("isFirstInstall", false);
            }
          }
        }, 
        buttonWidth: double.infinity, 
        buttonHeight: 50.h, 
        buttonColor: (!_isButtonEnable) ? 
          ColorPalette.black :
          ColorPalette.crimsonRed,
        buttonChild: bodyText(
          "Sign In",
          bodySize : 16.sp,
          bodyWeight : FontWeight.w600,
          bodyColor : ColorPalette.white, 
        )
      ),

      SizedBox( height : 20.h ),
      _signInDivider(),

      SizedBox( height : 20.h ),
      PocketPalButton(
        buttonOnTap: (){
          _signInPageGoogleAuth();
          if (settingsProvider.getBoolPreference("isFirstInstall")){
            settingsProvider.setBoolPreference("isFirstInstall", false);
          }
        }, 
        buttonWidth: double.infinity, 
        buttonHeight: 50.h, 
        buttonColor: ColorPalette.lightGrey, 
        buttonChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children :[
            SvgPicture.asset(
              "assets/icon/Google.svg"
            ),

            SizedBox( width : 10.w),
            bodyText(
              "Continue with Google",
              bodySize : 14.sp,
              bodyWeight: FontWeight.w600,
              bodyColor : ColorPalette.black,
            )
          ]
        )
      ),

      SizedBox(height : 18.h),
      MyBottomHyperlinkWidget(
        hyperlinkOnTap: widget.changeStateIsFirstInstall, 
        hyperlinkText: "Don't have an account? ", 
        hyperlinkLink: "Sign Up"
      )
    ];
  }

  Widget _signInDivider(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children : [
        Expanded(
          child : Divider(
            color : ColorPalette.grey
          ),
        ),
    
        SizedBox( width : 10.w),
        bodyText(
          "or signin with",
          bodyColor : ColorPalette.grey,
          bodySize : 12.sp,
        ),  
    
        SizedBox( width : 10.w ),
        Expanded(
          child : Divider(
            color : ColorPalette.grey
          ),
        ),
      ]
    );
  }

  void _textEditingControllerListener(){
    setState((){
      _isButtonEnable = (_email.text.isNotEmpty && 
                        _password.text.isNotEmpty);
    });
    return;
  }

  Future<void> _signInPageGoogleAuth() async {

    final userProvider = Provider.of<UserProvider>(context, listen : false);

    List<String> data = await PocketPalAuthentication()
                  .authenticationGoogle();

    // Add Checker if collection not exists run this code below
    await userProvider.addUserCredential(
      PalUser(
        palUserName : data[0],
        palUserEmail : data[1]  
      ).toMap()
    );
    return;
  }

  Future<void> _signInPageEmailAndPasswordAuth() async {

    try {
      await PocketPalAuthentication()
              .authenticationSignInEmailAndPassword(
                _email.text.trim(),
                _password.text.trim()
              );
    } on FirebaseAuthException catch (e){
      showDialog(
        context : context,
        builder :(context) {
          return MyDialogBoxWidget(
            dialogBoxTitle: (e.code == "user-not-found") ? 
              "User Not Found" : 
                (e.code == "wrong-password") ?
                  "Wrong Password" : 
                  "System Error",
            dialogBoxDescription: (e.code == "user-not-found") ? 
              "User doesn't Exists. Please check your email and try again." : 
                (e.code == "wrong-password") ?
                  "Invalid password. Please check your password and try again." : 
                  "Please enter a valid Email Address and Password.",
          );
        },
      );
    }
    return;
  }

  void _navigateToForgotPassword(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder : (context) => const ForgotPasswordPage()
      )
    );
    _email.clear();
    _password.clear();
    return;
  }
}