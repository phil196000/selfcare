import 'package:adobe_xd/pinned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Pinned.fromSize(
            bounds: Rect.fromLTWH(33.0, 522.0, 307.5, 236.7),
            size: Size(340.5, 758.7),
            pinLeft: true,
            pinRight: true,
            pinBottom: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 123.0, 76.0, 113.7),
                  size: Size(307.5, 236.7),
                  pinLeft: true,
                  pinBottom: true,
                  fixedWidth: true,
                  fixedHeight: true,
                  child: SvgPicture.string(
                    '<svg viewBox="33.0 645.0 76.0 113.7" ><path transform="translate(33.0, 682.7)" d="M 38 -37.69536590576172 C 58.98681640625 -37.69536590576172 76 17.01318168640137 76 38 C 76 58.98681640625 58.98681640625 76 38 76 C 17.01318168640137 76 0 58.98681640625 0 38 C 0 17.01318168640137 17.01318168640137 -37.69536590576172 38 -37.69536590576172 Z" fill="#ff0c0c" fill-opacity="0.11" stroke="none" stroke-width="1" stroke-opacity="0.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(231.5, 83.0, 76.0, 113.7),
                  size: Size(307.5, 236.7),
                  pinRight: true,
                  fixedWidth: true,
                  fixedHeight: true,
                  child: SvgPicture.string(
                    '<svg viewBox="264.5 605.0 76.0 113.7" ><path transform="translate(264.5, 642.7)" d="M 38 -37.69536590576172 C 58.98681640625 -37.69536590576172 76 17.01318168640137 76 38 C 76 58.98681640625 58.98681640625 76 38 76 C 17.01318168640137 76 0 58.98681640625 0 38 C 0 17.01318168640137 17.01318168640137 -37.69536590576172 38 -37.69536590576172 Z" fill="#ff0c0c" fill-opacity="0.11" stroke="none" stroke-width="1" stroke-opacity="0.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(35.0, 0.0, 214.0, 214.0),
                  size: Size(307.5, 236.7),
                  pinLeft: true,
                  pinTop: true,
                  pinBottom: true,
                  fixedWidth: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0x1cff0c0c),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(0.0, 0.0, 225.5, 270.8),
            size: Size(340.5, 758.7),
            pinLeft: true,
            pinTop: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 214.0, 214.0),
                  size: Size(225.5, 270.8),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  fixedHeight: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0x1eff0c0c),
                    ),
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(149.5, 77.0, 76.0, 113.7),
                  size: Size(225.5, 270.8),
                  pinRight: true,
                  fixedWidth: true,
                  fixedHeight: true,
                  child: SvgPicture.string(
                    '<svg viewBox="149.5 77.0 76.0 113.7" ><path transform="translate(149.5, 114.7)" d="M 38 -37.69536590576172 C 58.98681640625 -37.69536590576172 76 17.01318168640137 76 38 C 76 58.98681640625 58.98681640625 76 38 76 C 17.01318168640137 76 0 58.98681640625 0 38 C 0 17.01318168640137 17.01318168640137 -37.69536590576172 38 -37.69536590576172 Z" fill="#ff0c0c" fill-opacity="0.12" stroke="none" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 157.2, 76.0, 113.7),
                  size: Size(225.5, 270.8),
                  pinLeft: true,
                  pinBottom: true,
                  fixedWidth: true,
                  fixedHeight: true,
                  child: SvgPicture.string(
                    '<svg viewBox="0.0 157.2 76.0 113.7" ><path transform="translate(0.0, 194.85)" d="M 38 -37.69536590576172 C 58.98681640625 -37.69536590576172 76 17.01318168640137 76 38 C 76 58.98681640625 58.98681640625 76 38 76 C 17.01318168640137 76 0 58.98681640625 0 38 C 0 17.01318168640137 17.01318168640137 -37.69536590576172 38 -37.69536590576172 Z" fill="#ff0c0c" fill-opacity="0.12" stroke="none" stroke-width="1" stroke-opacity="0.53" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
