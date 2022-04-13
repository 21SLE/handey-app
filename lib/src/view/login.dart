import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/signup.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/colors.dart';
import 'package:handey_app/src/view/utils/popup_custom.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ScreenSize size;

  TextEditingController emailTEC;
  TextEditingController pwTEC;
  FocusNode emailFNode;
  FocusNode pwFNode;

  @override
  void initState() {
    super.initState();
    emailTEC = TextEditingController();
    pwTEC = TextEditingController();
    emailFNode = FocusNode();
    pwFNode = FocusNode();

  }

  @override
  void dispose() {
    emailTEC.dispose();
    pwTEC.dispose();
    emailFNode.dispose();
    pwFNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            loginBackGroundImg(),
            loginForm()
          ],
        )
      ),
    );
  }

  Widget loginBackGroundImg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/loginscreen.png'),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Padding(
      padding: EdgeInsets.all(size.getSize(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Space(height: 30),
          buildHandeyText(),
          Space(height: 15),
          userEmailTextFormField(),
          Space(height: 5),
          userPwTextFormField(),
          Space(height: 25),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginButton(),
              Space(width: 15),
              signUpButton()
            ],
          ),

        ],
      ),
    );
  }

  Text buildHandeyText() {
    return Text(
      'HANDEY',
      style: rTxtStyle.copyWith(fontSize: size.getSize(50), fontWeight: FontWeight.w700, color: cheeseYellow),
    );
  }

  Widget userEmailTextFormField() {
    return Container(
      width: size.getSize(240.0),
      height: size.getSize(54.0),
      child: TextFormField(
        controller: emailTEC,
        focusNode: emailFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        decoration: InputDecoration(
          hintText: '이메일을 입력하세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
      ),

    );
  }

  Widget userPwTextFormField() {
    return Container(
      width: size.getSize(240.0),
      height: size.getSize(54.0),
      child: TextFormField(
        controller: pwTEC,
        focusNode: pwFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: '비밀번호를 입력하세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
      ),
    );
  }

  Widget loginButton() {
    return GestureDetector(
      onTap: () {
        onTapLoginButton(context);
      },
      child: Container(
        width: size.getSize(90.0),
        height: size.getSize(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: regularYellow,
            // color: cheeseYellow,
            borderRadius: BorderRadius.circular(size.getSize(6.0))),

        child: Text(
          '로그인', style: rTxtStyle.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      onTap: () {
        onTapSignUpButton(context);
      },
      child: Container(
        width: size.getSize(90.0),
        height: size.getSize(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: regularYellow, width: 2.0),
            // border: Border.all(color: cheeseYellow, width: 2.0),
            borderRadius: BorderRadius.circular(size.getSize(6.0))),
        child: Text(
            '회원가입' , style: rTxtStyle.copyWith(color: regularYellow),
        ),
      ),
    );
  }

  onTapLoginButton(context) async {
    if (areEmailAndPwNotEmpty()) {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      print(emailTEC.text);
      print(pwTEC.text);
      bool emailChecked = await userProvider.checkEmailDuplication(emailTEC.text);
      if (emailChecked) {
        bool loginSucceeded = await userProvider.signIn(email: emailTEC.text, password: pwTEC.text);
        userProvider.userNotifyListeners();
        if (loginSucceeded) {
          ///로그인 성공
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (BuildContext context) => NavigationBar()));
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NavigationBar()));
        } else {
          ///로그인 실패 : 비밀번호 불일치
          await showCustomPopUp(
              context: context, title: '비밀번호를\n다시 확인해주세요.', confirmText: '확인');
        }
      } else {
        ///로그인 실패 : 등록된 이메일 없음
        await showCustomPopUp(
            context: context,
            title: '등록된 회원정보가\n없습니다.',
            confirmText: '확인');

      }
    }
  }

  onTapSignUpButton(context) async {
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) => SignUp()));
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SignUp()));
  }

  bool areEmailAndPwNotEmpty() {
    if(emailTEC.text.isNotEmpty && pwTEC.text.isNotEmpty)
      return true;
    else
      return false;
  }
}
