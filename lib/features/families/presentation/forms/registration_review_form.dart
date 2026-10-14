import '../registration_responsive.dart';
import 'package:flutter/material.dart';

class RegistrationReviewForm extends StatelessWidget {
  const RegistrationReviewForm({
    super.key,
    required this.fullName,
    required this.fin,
    required this.seriaNumber,
    required this.phone,
    required this.familyStatus,
    required this.personalNote,
    required this.region,
    required this.address,
    required this.coordinates,
    required this.members,
    required this.totalIncome,
    required this.totalExpense,
    required this.documentTitles,
    required this.socialWorkerNote,
    required this.onEditStep,
  });

  // ADDIM 1
  final String fullName;
  final String fin;
  final String seriaNumber;
  final String phone;
  final String familyStatus;
  final String personalNote;

  // ADDIM 2
  final String region;
  final String address;
  final String? coordinates;

  // ADDIM 3
  final List<String> members;

  // ADDIM 4 və 5
  final int totalIncome;
  final int totalExpense;

  // ADDIM 6
  final List<String> documentTitles;
  final String socialWorkerNote;

  final ValueChanged<int> onEditStep;

  static const _gold = Color(0xFFF4B033);
  static const _blue = Color(0xFF123FBD);
  static const _gray = Color(0xFF737373);
  static const _red = Color(0xFFD9232B);
  static const _dark = Color(0xFF202020);

  String _money(int amount) => '${amount.toStringAsFixed(2)} AZN';

  String _display(String value) =>
      value.trim().isEmpty ? 'Daxil edilməyib' : value.trim();

  @override
  Widget build(BuildContext context) {
    final difference = totalIncome - totalExpense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Yekun məlumatlandırma
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.regW(context),
            vertical: 16.regH(context),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D1),
            border: Border.all(color: const Color(0xFFFFCB6C)),
            borderRadius: BorderRadius.circular(14.regR(context)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: _gold,
                size: 23.regR(context),
              ),
              SizedBox(width: 10.regW(context)),
              Expanded(
                child: Text(
                  'Bütün məlumatları diqqətlə yoxlayıb rəsmi təsdiqləyin.',
                  style: TextStyle(
                    fontSize: 13.regSp(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 18.regH(context)),

        // ADDIM 1 — Şəxsi məlumatlar
        _section(
          context: context,
          icon: Icons.person_rounded,
          title: 'Şəxsi məlumatlar',
          step: 1,
          children: [
            _line(context, 'Ad, Soyad:', _display(fullName)),
            _line(context, 'FİN kod:', _display(fin)),
            _line(
              context,
              'Şəxsiyyət vəsiqəsinin seriya/nömrəsi:',
              _display(seriaNumber),
            ),
            _line(context, 'Telefon:', _display(phone)),
            _line(context, 'Ailədə status:', _display(familyStatus)),
            if (personalNote.trim().isNotEmpty)
              _line(context, 'Müraciət qeydi:', personalNote.trim()),
          ],
        ),

        // ADDIM 2 — Ünvan
        _section(
          context: context,
          icon: Icons.location_on_rounded,
          title: 'Ünvan və yerləşmə',
          step: 2,
          children: [
            _line(context, 'Rayon:', _display(region)),
            _line(context, 'Ünvan:', _display(address)),
            if (coordinates != null && coordinates!.trim().isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 6.regH(context)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.place_rounded,
                      color: _blue,
                      size: 17.regR(context),
                    ),
                    SizedBox(width: 5.regW(context)),
                    Flexible(
                      child: Text(
                        coordinates!,
                        style: TextStyle(
                          color: _blue,
                          fontSize: 12.regSp(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        // ADDIM 3 — Ailə üzvləri
        _section(
          context: context,
          icon: Icons.groups_rounded,
          title: 'Ailə üzvləri (${members.length} nəfər)',
          step: 3,
          children: members.isEmpty
              ? [
                  Text(
                    'Ailə üzvü əlavə edilməyib.',
                    style: TextStyle(color: _gray, fontSize: 13.regSp(context)),
                  ),
                ]
              : [
                  for (var i = 0; i < members.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: 7.regH(context)),
                      child: Text(
                        '${i + 1}. ${members[i]}',
                        style: TextStyle(
                          fontSize: 13.regSp(context),
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
        ),

        // ADDIM 4 və 5 — Maliyyə
        _section(
          context: context,
          icon: Icons.account_balance_wallet_rounded,
          title: 'Gəlir və Xərc Balansı',
          step: 4,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _moneyColumn(
                  context,
                  'Ümumi Gəlir',
                  _money(totalIncome),
                  _dark,
                ),
                _moneyColumn(context, 'Ümumi Xərc', _money(totalExpense), _red),
                _moneyColumn(
                  context,
                  'Fərq',
                  '${difference >= 0 ? '+' : ''}${_money(difference)}',
                  difference >= 0 ? _blue : _red,
                ),
              ],
            ),
            SizedBox(height: 6.regH(context)),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => onEditStep(5),
                child: Text(
                  'Xərcləri düzəliş et',
                  style: TextStyle(
                    color: _blue,
                    fontSize: 12.regSp(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        // ADDIM 6 — Sənədlər
        _section(
          context: context,
          icon: Icons.attach_file_rounded,
          title: 'Sənədlər və qeydlər',
          step: 6,
          children: [
            if (documentTitles.isEmpty)
              Text(
                'Sənəd əlavə edilməyib.',
                style: TextStyle(color: _gray, fontSize: 13.regSp(context)),
              )
            else ...[
              Text(
                '${documentTitles.length} ədəd PDF sənəd əlavə edilib:',
                style: TextStyle(color: _gray, fontSize: 13.regSp(context)),
              ),
              SizedBox(height: 8.regH(context)),
              for (final title in documentTitles)
                Padding(
                  padding: EdgeInsets.only(bottom: 7.regH(context)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: _red,
                        size: 17.regR(context),
                      ),
                      SizedBox(width: 7.regW(context)),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.regSp(context),
                            color: _dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            if (socialWorkerNote.trim().isNotEmpty) ...[
              SizedBox(height: 8.regH(context)),
              _line(context, 'Sosial işçinin qeydi:', socialWorkerNote.trim()),
            ],
          ],
        ),

        SizedBox(height: 18.regH(context)),
      ],
    );
  }

  Widget _line(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.regH(context)),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(color: _gray),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: _dark),
            ),
          ],
        ),
        style: TextStyle(fontSize: 13.regSp(context), height: 1.4),
      ),
    );
  }

  Widget _moneyColumn(
    BuildContext context,
    String label,
    String amount,
    Color color,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 5.regW(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: context.registrationIsTablet ? 15 : 11.regSp(context),
                color: _gray,
              ),
            ),
            SizedBox(height: 4.regH(context)),
            Text(
              amount,
              style: TextStyle(
                fontSize: 12.regSp(context),
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required BuildContext context,
    required IconData icon,
    required String title,
    required int step,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.regH(context)),
      padding: EdgeInsets.all(16.regR(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19.regR(context)),
        border: Border.all(color: const Color(0xFFE4E4E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.regR(context), color: _gold),
              SizedBox(width: 7.regW(context)),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.regSp(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onEditStep(step),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  'Düzəliş et',
                  style: TextStyle(
                    fontSize: 12.regSp(context),
                    color: _blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 18.regH(context), color: const Color(0xFFEAEAEA)),
          ...children,
        ],
      ),
    );
  }
}
