import 'package:caller_app/Widget/widgets.dart';
import 'package:direct_dialer/direct_dialer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Constent/Colors.dart';
import 'EditScreen.dart';
import 'QR_detail/Scanner_qr.dart';

class KeyPadSheet extends StatefulWidget {
  const KeyPadSheet({super.key, this.dialer, this.getContact});
  final DirectDialer? dialer;
  final  getContact;

  @override
  State<KeyPadSheet> createState() => _KeyPadSheetState();
}

class _KeyPadSheetState extends State<KeyPadSheet> {

  TextEditingController ContectController = TextEditingController();
  TextSelection? _selection;
  DirectDialer? dialer;

  Future<void> setupDialer() async => dialer = await DirectDialer.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupDialer();
    if(widget.getContact!=null){
      ContectController.text = widget.getContact.toString();
    }
    ContectController = ContectController..addListener(_onSelectionChanged);
    _selection = ContectController.selection;
  }
  void dispose() {
    // remove listener
    ContectController.removeListener(_onSelectionChanged);
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      // update selection on change (updating position too)
      _selection = ContectController.selection;
    });
    print('Cursor position: ${_selection?.base.offset}'); // print position
  }

  void _input(String text) {

    int? position = _selection?.base.offset; // gets position of cursor
    var value = ContectController.text; // text in our textfield

    if (value.isNotEmpty) {
      var suffix = value.substring(position!, value.length); // 1) suffix: the string
      // from the position of the cursor to the end of the text in the controller

      value = value.substring(0, position) + text + suffix; // 2) value.substring gets
      // a new string from start of the string in our textfield, appends the new input to our
      // new string and appends the suffix to it.

      ContectController.text = value; // 3) set our controller text to the gotten value
      ContectController.selection =
          TextSelection.fromPosition(TextPosition(offset: position + 1)); // 4) update selection
      // to update our position.
    } else {
      value = ContectController.text + text; // 5) appends controller text and new input
      // and assigns to value
      ContectController.text = value; // 6) set our controller text to the gotten value
      ContectController.selection =
          TextSelection.fromPosition(const TextPosition(offset: 1)); // 7) since this is the first input
      // set position of cursor to 1, so the cursor is placed at the end
    }
  }

  void _backspace() {
    int? position = _selection?.base.offset; // cursor position
    final value = ContectController.text; // string in out textfield

    // 1) only erase when string in textfield is not empty and when position is not zero (at the start)
    if (value.isNotEmpty && position != 0) {
      var suffix = value.substring(position!, value.length); // 2) get string after cursor position
      ContectController.text = value.substring(0, position - 1) + suffix; // 3) get string before the cursor and append to
      // suffix after removing the last char before the cursor
      ContectController.selection =
          TextSelection.fromPosition(TextPosition(offset: position - 1)); // 4) update the cursor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: ContectController.text.isNotEmpty?665:600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 50,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  color: grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50)),
            ),
            ContectController.text.isNotEmpty?
            InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: (){
Wid_Con.NavigationTo(EditScreen(NewNumber: ContectController.text,));
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: themeDarkColor)
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add_circled,color: themeDarkColor, size: 25,),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text('Create contact',style: TextStyle(
                            color: themeDarkColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ):Container(),
            TextFormField(

              keyboardType: TextInputType.none,
              controller: ContectController,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                borderSide: BorderSide.none
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Divider(),
            ),
            GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.60,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('1');
                      });
                    },
                    ButtonName: '1',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {setState(() {
                      _input('2');
                    });},
                    ButtonName: '2',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('3');
                      });
                    },
                    ButtonName: '3',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('4');
                      });
                    },
                    ButtonName: '4',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('5');
                      });
                    },
                    ButtonName: '5',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('6');
                      });
                    },
                    ButtonName: '6',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('7');
                      });
                    },
                    ButtonName: '7',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('8');
                      });
                    },
                    ButtonName: '8',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('9');
                      });
                    },
                    ButtonName: '9',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {setState(() {
                      _input('*');
                    });},
                    ButtonName: '*',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('0');
                      });
                    },
                    ButtonName: '0',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
                Wid_Con.keyPadButton(
                    onPressed: () {
                      setState(() {
                        _input('#');
                      });
                    },
                    ButtonName: '#',
                    ButtonRadius: 100,
                    height: 80,
                    width: 80,
                    fontSize: 30),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20,top: 20),
                          child: Wid_Con.keyPadButton(
                              onLongPress: () {
                                setState(() {
                                  ContectController.clear();
                                });
                              },
                              onPressed: () {
                                Wid_Con.NavigationTo(Scanner_qr());
                              },
                              child: Icon(CupertinoIcons.qrcode_viewfinder,size: 35,color: themeDarkColor,),
                              ButtonRadius: 100,
                              height: 70,
                              width: 50,
                              fontSize: 30),
                        ))),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child:Align(
                    alignment: Alignment.center,
                    child:
                Wid_Con.keyPadButton(
                    onPressed: () async {
                      if(ContectController.text.isNotEmpty){
                        await dialer?.dial(ContectController.text);
                      }

                    },
                    ButtonColor: bottomBG,
                    child: Image(
                      image: AssetImage('assets/images/CallButton.png'),
                      height: 25,
                    ),
                    ButtonRadius: 100,
                    height: 75,
                    width: 50,
                    fontSize: 30),
                  ),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20,top: 20),
                          child: Wid_Con.keyPadButton(
                            onLongPress: () {
                              setState(() {
                                ContectController.clear();
                              });
                            },
                              onPressed: () {
                                setState(() {
                                  _backspace();
                                });
                              },
                              child: Image(
                                image:
                                    AssetImage('assets/images/backspace.png'),
                                height: 25,
                              ),
                              ButtonRadius: 100,
                              height: 70,
                              width: 50,
                              fontSize: 30),
                        )))
              ],
            )
          ],
        ));
  }
}
