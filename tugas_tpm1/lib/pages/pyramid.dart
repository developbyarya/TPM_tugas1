import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_tpm1/components/Input.dart';
import 'package:tugas_tpm1/components/button.dart';
import 'package:tugas_tpm1/components/card.dart';
import 'package:tugas_tpm1/utils/colors.dart' as UserColors;
import 'package:tugas_tpm1/utils/pyramid.dart';

class PyramidScreen extends StatefulWidget {
  PyramidScreen({super.key});
  final Pyramid pyramid = Pyramid(height: 0, base: 0, apotemous: 0);

  @override
  State<PyramidScreen> createState() => _PyramidScreenState();
}

class _PyramidScreenState extends State<PyramidScreen> {
  bool showResult = false;
  TextEditingController alasController = TextEditingController();
  TextEditingController tinggiController = TextEditingController();
  TextEditingController apotemousController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    alasController.dispose();
    tinggiController.dispose();
    apotemousController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Pyramid Formula',
          style: TextStyle(
            fontFamily: GoogleFonts.inter().fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w900,            
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      'Parameter Piramid',
                      style: TextStyle(
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: UserColors.Colors.textGrey,
                      ),
                    ),
                    Input(label: 'Sisi Alas (a)', controller: alasController),
                    Input(
                      label: 'Tinggi Piramid (t)',
                      controller: tinggiController,
                    ),
                    Input(
                      label: 'Tinggi Sisi Miring / Apotema (s)',
                      controller: apotemousController,
                    ),
                    Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: Button(
                            type: ButtonType.primary,
                            text: 'Hitung',
                            leadingIcon: Icon(Icons.calculate),
                            onPressed: () {
                              handleCalculate();
                            },
                          ),
                        ),
                        Expanded(
                          child: Button(
                            type: ButtonType.secondary,
                            text: 'Reset',
                            onPressed: () {
                              reset();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              showResult
                  ? Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('icons/Vector.svg', width: 20, height: 20,),
                              SizedBox(width: 8),
                              Text('Hasil Perhitungan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: UserColors.Colors.textBlack),),
                            ],
                          ),
                          resultCard(
                            'Luas Alas',
                            'a² = ${widget.pyramid.base}² = ${widget.pyramid.luasAlas} cm²',
                            '${widget.pyramid.luasAlas} cm²',
                            UserColors.Colors.primaryLight,
                            UserColors.Colors.primary,
                          ),
                          resultCard(
                            'Luas Selimut',
                            '2 × a × s = 2 × ${widget.pyramid.base} × ${widget.pyramid.apotemous} = ${widget.pyramid.lateralSurfaceArea} cm²',
                            '${widget.pyramid.lateralSurfaceArea} cm²',
                            UserColors.Colors.overlayOrange,
                            UserColors.Colors.orange,
                          ),
                          resultCard(
                            'Luas Permukaan Total',
                            'alas + selimut = ${widget.pyramid.luasAlas} + ${widget.pyramid.lateralSurfaceArea} = ${widget.pyramid.surfaceArea} cm²',
                            '${widget.pyramid.surfaceArea} cm²',
                            UserColors.Colors.overlayGreen,
                            UserColors.Colors.success,
                          ),
                          resultCard(
                            'Volume',
                            'V = ${widget.pyramid.luasAlas} × ${widget.pyramid.height} / 3 = ${widget.pyramid.volume} cm³',
                            '${widget.pyramid.volume} cm³',
                            UserColors.Colors.overlayPurple,
                            UserColors.Colors.purple,
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultCard(
    String formulaLabel,
    String formula,
    String result,
    Color bgColor,
    Color textColor,
  ) {
    return CustomCard(
      bgColor: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formulaLabel,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: UserColors.Colors.textGrey,
            ),
          ),
          Text(
            formula,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 0.5,
              color: textColor,
            ),
          ),
          Text(
            result,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  void handleCalculate() {
    double alas = double.parse(alasController.text);
    double tinggi = double.parse(tinggiController.text);
    double apotemous = double.parse(apotemousController.text);

    widget.pyramid.setHeight(tinggi);
    widget.pyramid.setBase(alas);
    widget.pyramid.setApotemous(apotemous);

    setState(() {
      showResult = true;
    });
  }

  void reset() {
    alasController.clear();
    tinggiController.clear();
    apotemousController.clear();
    widget.pyramid.setHeight(0);
    widget.pyramid.setBase(0);
    widget.pyramid.setApotemous(0);
    setState(() {
      showResult = false;
    });
  }
}
