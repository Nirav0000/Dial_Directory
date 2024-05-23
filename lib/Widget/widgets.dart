import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constent/Colors.dart';



class Wid_Con {
  static iconButton(
      {required VoidCallback onPressed,
        required Icon BIcon,
        Color? Button_color,
        double? Iconsize,
        double? splashRadius}) {
    return IconButton(
      onPressed: onPressed,
      icon: BIcon,
      color: Button_color,
      iconSize: Iconsize,
      splashRadius: splashRadius,
    );
  }

  static textfield(
      {String? titelText,
        var suffixIcon,
        var prefixIcon,
        var controller,
        bool? obscureText,
        bool? filled,
        Color? filledColor,
        double? paddingtop,
        double? contenthorizontal,
        double? contentvertical,
        double? paddingbottom,
        double? paddingleft,
        double? paddingright,
        var focusedBorder,
        errorBorder,
        key,
        errorText,
        String? labelText,
        var validator,
        var inputFormatters,
        String? hintText,
        var keyboardType,
        // ignore: use_function_type_syntax_for_parameters
        Function(String)? onChanged,
        var maxLines,double? width,double? height,
        Color? titelcolor,
        var borderSide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom:paddingbottom?? 5, left: paddingleft??5,top: paddingtop??0,right: paddingright??0),
          child: Text(titelText ?? '',
            style: Text_Style(
                color: black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Medium'
            ),),
        ),
        SizedBox(
          height:height??60,
          width: width,
          child: TextFormField(
            validator: validator,
            obscureText: obscureText??false,

            style: TextStyle(fontWeight: FontWeight.w500,color: black),
            key: key,
            inputFormatters: inputFormatters,
            maxLines:maxLines??1,
            keyboardType: keyboardType??TextInputType.text,
            controller: controller,
            onChanged: onChanged,
            cursorColor: themeColor,
            decoration: InputDecoration(
                labelText: labelText,
                contentPadding:EdgeInsets.symmetric(horizontal: contenthorizontal??15,vertical: contentvertical??5),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                filled: filled??false,
                fillColor: filledColor??grey,
                hintText: hintText??'',
                hintStyle: TextStyle(
                    color: grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Medium'
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: themeColor,width: 2)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide( color: themeColor,width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  gapPadding: 50,
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide( color: red,width: 1),
                ),
                errorText: errorText,

                floatingLabelStyle: TextStyle(
                    color: themeColor,
                    fontFamily: 'Medium'
                ),
                labelStyle: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Medium'
                ),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(50),
                )),
          ),
        ),
      ],
    );
  }

  static button({String? ButtonName,
    Color? titelcolor,
    Color? Bordercolor,
    required VoidCallback onPressed,
    double? ButtonRadius,
    double? fontSize,
    Color? ButtonColor,
    double? width,
    double? height,
    var child,
    double? elevation,
    double? borderWidth
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ButtonRadius??10.0),

      ),
      child: ElevatedButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color?>(Colors.grey.withOpacity(0.5)),
            elevation: MaterialStateProperty.all<double?>(elevation),
            minimumSize:
            MaterialStateProperty.all<Size?>( Size(width??double.infinity,height?? 50)),
            // fixedSize: ,

            backgroundColor: MaterialStateProperty.all<Color?>(ButtonColor??transparent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(

                  side: BorderSide(color:Bordercolor??black,width: borderWidth??2),
                  borderRadius: BorderRadius.circular(ButtonRadius??10.0),
                ))),
        onPressed: onPressed,
        child:child ?? Text(
          ButtonName??'',
          style: TextStyle(
              color:titelcolor?? white,
              fontSize:fontSize??20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Light'
          ),
        ),
      ),
    );
  }


  static App_Bar({
    String? titel,
    var leading,
    var Status,
    bool? centerTitle,
    var titelwidget,
    List<Widget>? actions,
    var arrowNearText
  }) {
    return AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        centerTitle: centerTitle,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Status??
                Container(),
            titelwidget??Container(),
            titel!=null?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text( titel??'',
                    style: TextStyle(fontFamily: 'Medium',
                        color: white,
                        fontSize: 18, fontWeight: FontWeight.w500)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(arrowNearText,size: 20,),
                ),
              ],
            ):Container(),
          ],
        ),
        leading: leading,
        actions: actions
    );
  }

  static Text_Style({var fontWeight,Color? color,double? fontSize,String? fontFamily}){
    return TextStyle(
    fontWeight: fontWeight??FontWeight.w500,
      color: color??black,
      fontSize: fontSize??16,
      fontFamily: fontFamily??'Medium'
    );
}

  static NavigationTo(var NavigatClass){
    return Get.to(NavigatClass,
    duration: Duration(milliseconds: 700),
    transition: Transition.native,);
}

static NavigationOff(var NavigatClass){
    return Get.off(NavigatClass,
    duration: Duration(milliseconds: 700),
    transition: Transition.native,);
}

static NavigationOffAll(var NavigatClass){
    return Get.offAll(NavigatClass,
    duration: Duration(milliseconds: 700),
    transition: Transition.native,);
}

}
