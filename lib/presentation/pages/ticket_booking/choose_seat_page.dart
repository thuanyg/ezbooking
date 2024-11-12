import 'package:flutter/material.dart';

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({super.key});
  static const routeName = "SeatSelectionPage";

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  List<List<int>> seatLayout = List.generate(
    7,
        (i) => List.generate(14, (j) => 0), // 0: Available, 1: Selected, 2: Chosen
  );

  // Randomly set some seats as chosen (for demonstration)
  @override
  void initState() {
    super.initState();
    // Set some seats as chosen (2)
    seatLayout[2][1] = 2;
    seatLayout[4][5] = 2;
    seatLayout[5][12] = 2;
    seatLayout[3][8] = 2;
    seatLayout[6][3] = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Choose Seat',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.local_activity_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summer Splash A Seasonal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Celebration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '18 Jun 2024 | 09:00 AM',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
            ),
            child: const Text(
              'Screen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    seatLayout.length,
                        (i) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        seatLayout[i].length,
                            (j) => GestureDetector(
                          onTap: () {
                            if (seatLayout[i][j] != 2) {
                              setState(() {
                                seatLayout[i][j] = seatLayout[i][j] == 0 ? 1 : 0;
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: seatLayout[i][j] == 0
                                  ? Colors.grey[300]
                                  : seatLayout[i][j] == 1
                                  ? Colors.orange
                                  : Colors.teal,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('Available', Colors.grey[300]!),
                    const SizedBox(width: 16),
                    _buildLegendItem('Selected', Colors.orange),
                    const SizedBox(width: 16),
                    _buildLegendItem('Chosen', Colors.teal),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue to payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}