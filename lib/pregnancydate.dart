import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PregnancyDatePage extends StatefulWidget {
  @override
  _PregnancyDatePageState createState() => _PregnancyDatePageState();
}

class _PregnancyDatePageState extends State<PregnancyDatePage> {
  DateTime? _startDate;
  int _currentWeek = 1;
  final TextEditingController _dateController = TextEditingController();
  final List<Map<String, dynamic>> _pregnancyWeeks = [];

  @override
  void initState() {
    super.initState();
    _initializeWeekData();
  }

  void _initializeWeekData() {

    _pregnancyWeeks.addAll([
      {
        'week': 1,
        'title': 'Conception & Early Development',
        'description': 'Your baby is currently a tiny ball of cells called a blastocyst. Focus on prenatal vitamins and healthy eating.',
        'baby_size': 'Poppy seed',
        'care': ['Start prenatal vitamins', 'Avoid alcohol/smoking', 'Schedule first doctor visit'],
        'medications': ['Folic acid (400mcg daily)', 'Prenatal multivitamin']
      },
      {
        'week': 2,
        'title': 'Ovulation & Fertilization',
        'description': 'Ovulation typically occurs this week. Fertilization may happen if egg meets sperm.',
        'baby_size': 'Still microscopic',
        'care': ['Track ovulation', 'Maintain a healthy lifestyle', 'Reduce caffeine intake'],
        'medications': ['Continue folic acid']
      },
      {
        'week': 3,
        'title': 'Implantation',
        'description': 'The fertilized egg implants in the uterine wall. Hormonal changes begin.',
        'baby_size': 'Microscopic embryo',
        'care': ['Rest as needed', 'Avoid stress', 'Hydrate well'],
        'medications': ['Folic acid', 'Prenatal vitamins']
      },
      {
        'week': 4,
        'title': 'Neural Tube Formation',
        'description': 'Baby\'s neural tube (brain/spine) begins forming. Morning sickness may start.',
        'baby_size': 'Sesame seed',
        'care': ['Increase water intake', 'Eat small frequent meals', 'Rest when tired'],
        'medications': ['Continue folic acid', 'Consult doctor for nausea meds if needed']
      },
      {
        'week': 5,
        'title': 'Heart Begins to Beat',
        'description': 'Baby\'s heart starts beating and circulatory system begins forming.',
        'baby_size': 'Apple seed',
        'care': ['Avoid high mercury fish', 'Get mild exercise', 'See doctor for first prenatal checkup'],
        'medications': ['Prenatal vitamins', 'Doctor-approved medications']
      },
      {
        'week': 6,
        'title': 'Facial Features Forming',
        'description': 'Eyes, ears, and nose begin to form. Hormones can cause mood swings.',
        'baby_size': 'Sweet pea',
        'care': ['Get plenty of rest', 'Eat iron-rich foods', 'Avoid raw/undercooked food'],
        'medications': ['Continue prenatal supplements']
      },
      {
        'week': 7,
        'title': 'Arm & Leg Buds Appear',
        'description': 'Limb buds develop into arms and legs. Morning sickness may be strong.',
        'baby_size': 'Blueberry',
        'care': ['Use ginger or crackers for nausea', 'Avoid long standing periods', 'Take naps if needed'],
        'medications': ['Nausea medications if prescribed']
      },
      {
        'week': 8,
        'title': 'Baby Starts Moving',
        'description': 'Tiny movements begin, though you can’t feel them yet.',
        'baby_size': 'Raspberry',
        'care': ['Stay hydrated', 'Avoid environmental toxins', 'Wear comfortable clothes'],
        'medications': ['Vitamin B6 for nausea (consult doctor)']
      },
      {
        'week': 9,
        'title': 'Development of Organs',
        'description': 'Most essential organs are developing. Hormonal shifts can be intense.',
        'baby_size': 'Cherry',
        'care': ['Limit caffeine', 'Gentle exercise', 'Attend prenatal checkup'],
        'medications': ['Prenatal multivitamin']
      },
      {
        'week': 10,
        'title': 'Fingers & Toes Form',
        'description': 'Fingers and toes become more defined. Baby is now a fetus.',
        'baby_size': 'Strawberry',
        'care': ['Begin planning for screening tests', 'Continue healthy eating', 'Rest frequently'],
        'medications': ['Calcium supplements if needed']
      },
      {
        'week': 11,
        'title': 'Baby’s Head Develops Rapidly',
        'description': 'Baby’s head is nearly half its body size. Nausea may start easing.',
        'baby_size': 'Fig',
        'care': ['Stay hydrated', 'Eat fiber to avoid constipation', 'Gentle prenatal yoga'],
        'medications': ['Continue prenatal vitamins']
      },
      {
        'week': 12,
        'title': 'First Trimester Complete',
        'description': 'Baby’s major organs are in place. You may start feeling a bit more energetic.',
        'baby_size': 'Lime',
        'care': ['Book NT scan', 'Eat protein-rich food', 'Avoid smoking/alcohol'],
        'medications': ['Iron and folate supplementation']
      },
      {
        'week': 13,
        'title': 'Second Trimester Begins',
        'description': 'Risks of miscarriage decrease. Baby’s fingerprints start forming.',
        'baby_size': 'Peach',
        'care': ['Hydrate regularly', 'Begin light walking routine', 'Use stretch mark lotion'],
        'medications': ['Calcium with Vitamin D']
      },
      {
        'week': 14,
        'title': 'Baby Starts Swallowing',
        'description': 'Baby practices swallowing amniotic fluid.',
        'baby_size': 'Lemon',
        'care': ['Maintain good posture', 'Eat small meals', 'Wear comfortable bras'],
        'medications': ['Doctor-approved supplements']
      },
      {
        'week': 15,
        'title': 'Legs Growing Longer',
        'description': 'Baby’s legs outgrow arms. Skeletal system continues developing.',
        'baby_size': 'Apple',
        'care': ['Take prenatal yoga', 'Monitor weight gain', 'Healthy snacking'],
        'medications': ['Iron supplements']
      },
      {
        'week': 16,
        'title': 'Baby Can Make Faces',
        'description': 'Baby begins to move facial muscles. You might feel first flutters.',
        'baby_size': 'Avocado',
        'care': ['Attend mid-pregnancy ultrasound', 'Eat fiber-rich foods', 'Practice Kegel exercises'],
        'medications': ['Continue routine medications']
      },
      {
        'week': 17,
        'title': 'Fat Accumulation Begins',
        'description': 'Baby begins forming fat under skin. You may notice increased appetite.',
        'baby_size': 'Onion',
        'care': ['Avoid fried foods', 'Track baby movements', 'Take short walks'],
        'medications': ['Iron, calcium, and folic acid']
      },
      {
        'week': 18,
        'title': 'Nervous System Maturing',
        'description': 'Nerves are forming protective myelin sheath.',
        'baby_size': 'Bell pepper',
        'care': ['Start sleeping on your side', 'Attend anomaly scan', 'Stay hydrated'],
        'medications': ['Continue doctor-prescribed medications']
      },
      {
        'week': 19,
        'title': 'Vernix Forms on Skin',
        'description': 'A protective coating forms on baby’s skin.',
        'baby_size': 'Mango',
        'care': ['Moisturize your skin', 'Watch posture', 'Stay active'],
        'medications': ['Supplements for skin health (with doctor approval)']
      },
      {
        'week': 20,
        'title': 'Halfway There!',
        'description': 'You’re halfway through pregnancy. Gender may be visible via scan.',
        'baby_size': 'Banana',
        'care': ['Attend detailed anomaly scan', 'Stay calm and relaxed', 'Practice breathing techniques'],
        'medications': ['Continue regular supplements']
      },
      {
        'week': 21,
        'title': 'Taste Buds Develop',
        'description': 'Baby is now able to taste the amniotic fluid. Movements become more coordinated.',
        'baby_size': 'Carrot',
        'care': ['Eat a variety of healthy foods', 'Stay hydrated', 'Rest with legs elevated'],
        'medications': ['Continue prenatal vitamins', 'Doctor-approved supplements']
      },
      {
        'week': 22,
        'title': 'Facial Features Fully Formed',
        'description': 'Baby’s face is fully formed. Eyelids and eyebrows are distinct.',
        'baby_size': 'Spaghetti squash',
        'care': ['Practice good posture', 'Monitor baby’s kicks', 'Attend regular check-ups'],
        'medications': ['Iron and calcium supplements']
      },
      {
        'week': 23,
        'title': 'Lung Development Begins',
        'description': 'Baby’s lungs start producing surfactant for breathing.',
        'baby_size': 'Grapefruit',
        'care': ['Start birth plan preparation', 'Stay active with light exercises', 'Avoid long standing'],
        'medications': ['Magnesium (if prescribed)', 'Continue prenatal care']
      },
      {
        'week': 24,
        'title': 'Viability Outside the Womb Increases',
        'description': 'Baby now has a chance of survival outside the womb with medical help.',
        'baby_size': 'Corn',
        'care': ['Monitor blood pressure', 'Control salt intake', 'Attend glucose screening'],
        'medications': ['Doctor-prescribed supplements']
      },
      {
        'week': 25,
        'title': 'Baby Responds to Sound',
        'description': 'Baby starts responding to noises and your voice.',
        'baby_size': 'Cauliflower',
        'care': ['Play soothing music', 'Bond with baby by talking', 'Eat iron-rich foods'],
        'medications': ['Iron and folate']
      },
      {
        'week': 26,
        'title': 'Eyes Start to Open',
        'description': 'Baby begins to open eyelids and blink.',
        'baby_size': 'Zucchini',
        'care': ['Avoid processed foods', 'Use maternity support belt if needed', 'Stay hydrated'],
        'medications': ['Continue prescribed vitamins']
      },
      {
        'week': 27,
        'title': 'Third Trimester Starts',
        'description': 'You’re in the third trimester now. Baby is gaining fat and growing rapidly.',
        'baby_size': 'Cucumber',
        'care': ['Plan maternity leave', 'Monitor fetal movement', 'Discuss delivery options'],
        'medications': ['Calcium and iron combo supplements']
      },
      {
        'week': 28,
        'title': 'Eyes Detect Light',
        'description': 'Baby can now see light filtering through your belly.',
        'baby_size': 'Eggplant',
        'care': ['Begin kick counting', 'Avoid strenuous activity', 'Elevate feet often'],
        'medications': ['Continue regular medications']
      },
      {
        'week': 29,
        'title': 'Bones Fully Developed',
        'description': 'Baby’s bones are developed but still soft and flexible.',
        'baby_size': 'Butternut squash',
        'care': ['Eat calcium-rich food', 'Wear supportive shoes', 'Practice relaxation techniques'],
        'medications': ['Calcium and vitamin D']
      },
      {
        'week': 30,
        'title': 'Brain Growth Accelerates',
        'description': 'Rapid brain development. You may feel more fatigued.',
        'baby_size': 'Cabbage',
        'care': ['Nap during the day', 'Attend childbirth classes', 'Avoid sugar-rich food'],
        'medications': ['Continue prenatal routine']
      },
      {
        'week': 31,
        'title': 'Baby’s Movements Are Stronger',
        'description': 'Kicks and punches are stronger. Lungs continue maturing.',
        'baby_size': 'Coconut',
        'care': ['Stay hydrated', 'Avoid lying flat on your back', 'Gentle stretching'],
        'medications': ['Magnesium (if prescribed)', 'Iron']
      },
      {
        'week': 32,
        'title': 'Fingernails and Toenails Grow',
        'description': 'Baby’s nails are growing. Head may be facing down.',
        'baby_size': 'Jicama',
        'care': ['Practice squatting', 'Attend regular check-ups', 'Monitor fetal position'],
        'medications': ['Continue routine medications']
      },
      {
        'week': 33,
        'title': 'Immune System Develops',
        'description': 'Baby’s immune system is getting stronger. Amniotic fluid peaks.',
        'baby_size': 'Pineapple',
        'care': ['Rest and relax more', 'Practice pelvic floor exercises', 'Drink water frequently'],
        'medications': ['Continue prenatal supplements']
      },
      {
        'week': 34,
        'title': 'Baby’s Skin Becomes Smooth',
        'description': 'Fat layers smooth out the skin. Baby practices breathing.',
        'baby_size': 'Cantaloupe',
        'care': ['Prepare for breastfeeding', 'Limit sodium intake', 'Get plenty of sleep'],
        'medications': ['Doctor-prescribed vitamins']
      },
      {
        'week': 35,
        'title': 'Baby Gains More Weight',
        'description': 'Baby continues putting on weight for delivery.',
        'baby_size': 'Honeydew melon',
        'care': ['Pack hospital bag', 'Watch for swelling', 'Keep feet elevated'],
        'medications': ['Continue prenatal regimen']
      },
      {
        'week': 36,
        'title': 'Lightening May Occur',
        'description': 'Baby may drop into the pelvis. You may breathe easier but feel pelvic pressure.',
        'baby_size': 'Romaine lettuce',
        'care': ['Practice relaxation', 'Walk daily', 'Stay in touch with doctor'],
        'medications': ['Iron, calcium, folate']
      },
      {
        'week': 37,
        'title': 'Considered Early Term',
        'description': 'Baby is considered full-term soon. You might notice Braxton Hicks contractions.',
        'baby_size': 'Swiss chard',
        'care': ['Attend final appointments', 'Discuss birth plan', 'Avoid heavy lifting'],
        'medications': ['Continue medications as directed']
      },
      {
        'week': 38,
        'title': 'Final Touches',
        'description': 'Lungs and brain finish maturing. Baby’s grip is strong.',
        'baby_size': 'Leek',
        'care': ['Rest as much as possible', 'Practice labor positions', 'Finalize pediatrician choice'],
        'medications': ['Postpartum supplements (get ready)']
      },
      {
        'week': 39,
        'title': 'Full Term',
        'description': 'Baby is fully developed. Labor can start anytime now.',
        'baby_size': 'Watermelon',
        'care': ['Time contractions', 'Keep essentials ready', 'Stay calm and focused'],
        'medications': ['Pain management options (with doctor)', 'Continue prenatal meds']
      },
      {
        'week': 40,
        'title': 'Full Term - Ready for Birth!',
        'description': 'Your baby is fully developed and ready to meet the world! Watch for labor signs.',
        'baby_size': 'Pumpkin (about 7-8 lbs)',
        'care': ['Monitor contractions', 'Practice breathing exercises', 'Final hospital bag check'],
        'medications': ['Doctor-approved pain relief options', 'Postpartum vitamins ready']
      }
    ]);

  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFE75480),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
        _currentWeek = _calculateCurrentWeek(picked);
      });
    }
  }

  int _calculateCurrentWeek(DateTime startDate) {
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;
    return (difference / 7).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF6F6),
      appBar: AppBar(
        title: Text(
          'Pregnancy Tracker',
          style: GoogleFonts.poppins(
            color: Color(0xFFE75480),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFE75480)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Pregnancy Date Input Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Track Your Pregnancy Journey',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE75480),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date of Pregnancy',
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFE75480)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xFFE75480)),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'OR',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Current Pregnancy Week',
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: Icon(FontAwesomeIcons.baby, color: Color(0xFFE75480)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _currentWeek = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            if (_currentWeek > 0) ...[
              // Pregnancy Progress Gauge
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Pregnancy Progress',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 150,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 40,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                startValue: 0,
                                endValue: _currentWeek.toDouble(),
                                color: Color(0xFFE75480),
                              ),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: _currentWeek.toDouble(),
                                enableAnimation: true,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  'Week $_currentWeek',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE75480),
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${((_currentWeek / 40) * 100).toStringAsFixed(1)}% completed',
                      style: GoogleFonts.poppins(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Weekly Information
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.solidCalendar, color: Color(0xFFE75480)),
                        SizedBox(width: 10),
                        Text(
                          'Week $_currentWeek',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      _pregnancyWeeks.firstWhere(
                            (week) => week['week'] == _currentWeek,
                        orElse: () => _pregnancyWeeks.last,
                      )['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Baby size: ${_pregnancyWeeks.firstWhere((week) => week['week'] == _currentWeek, orElse: () => _pregnancyWeeks.last)['baby_size']}',
                      style: GoogleFonts.poppins(
                        color: Color(0xFFE75480),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      _pregnancyWeeks.firstWhere(
                            (week) => week['week'] == _currentWeek,
                        orElse: () => _pregnancyWeeks.last,
                      )['description'],
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Care Tips:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: (_pregnancyWeeks.firstWhere(
                            (week) => week['week'] == _currentWeek,
                        orElse: () => _pregnancyWeeks.last,
                      )['care'] as List<String>).map((tip) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.fiber_manual_record, size: 12, color: Color(0xFFE75480)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Recommended Medications:',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (_pregnancyWeeks.firstWhere(
                            (week) => week['week'] == _currentWeek,
                        orElse: () => _pregnancyWeeks.last,
                      )['medications'] as List<String>).map((med) => Chip(
                        label: Text(med),
                        backgroundColor: Color(0xFFFFE6EF),
                        labelStyle: GoogleFonts.poppins(
                          color: Color(0xFFE75480),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}