// import 'package:flutter/material.dart';
// import '../models/companion_model.dart';
// import '../data/companion_data.dart';
// import '../widgets/companion_widgets.dart';
//
// class CompanionProfileScreen extends StatefulWidget {
//   const CompanionProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _CompanionProfileScreenState createState() => _CompanionProfileScreenState();
// }
//
// class _CompanionProfileScreenState extends State<CompanionProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late CompanionData companionData;
//
//   @override
//   void initState() {
//     super.initState();
//     companionData = CompanionDataProvider.getMockCompanionData();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _showEditProfileDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: const Color(0xFF1C1C1E),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Choose Avatar',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     foreground: Paint()
//                       ..shader = ui.Gradient.linear(
//                         const Offset(0, 0),
//                         const Offset(100, 0),
//                         [Colors.purple, Colors.pink],
//                       ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   height: 300,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                     ),
//                     itemCount: CompanionDataProvider.avatarOptions.length,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             // Update this to use proper state management in production
//                             companionData = CompanionData(
//                               name: companionData.name,
//                               type: companionData.type,
//                               status: companionData.status,
//                               imageIcon:
//                                   CompanionDataProvider.avatarOptions[index],
//                               traits: companionData.traits,
//                             );
//                           });
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: const LinearGradient(
//                               colors: [Colors.purple, Colors.pink],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.purple.withOpacity(0.3),
//                                 blurRadius: 8,
//                                 spreadRadius: 2,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF1C1C1E),
//                               ),
//                               child: Icon(
//                                 CompanionDataProvider.avatarOptions[index],
//                                 size: 40,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(
//                       color: Colors.purple,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildProfileImage() {
//     return Stack(
//       alignment: Alignment.bottomRight,
//       children: [
//         Container(
//           width: 150,
//           height: 150,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: const LinearGradient(
//               colors: [Colors.purple, Colors.pink],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.purple.withOpacity(0.3),
//                 blurRadius: 16,
//                 spreadRadius: 4,
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(3.0),
//             child: Container(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color(0xFF1C1C1E),
//               ),
//               child: Icon(
//                 companionData.imageIcon,
//                 size: 80,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//         GestureDetector(
//           onTap: _showEditProfileDialog,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.purple,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.purple.withOpacity(0.3),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: const Icon(
//               Icons.edit,
//               size: 20,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF121212),
//       ),
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 const Color(0xFF121212),
//                 const Color(0xFF1C1C1E).withOpacity(0.95),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 children: [
//                   CompanionHeader(
//                     name: companionData.name,
//                     type: companionData.type,
//                   ),
//                   const SizedBox(height: 24),
//                   _buildProfileImage(),
//                   const SizedBox(height: 24),
//                   CompanionStatusCard(status: companionData.status),
//                   const SizedBox(height: 32),
//                   _buildTraits(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTraits() {
//     return Column(
//       children: companionData.traits.map((trait) {
//         return TraitBar(
//           trait: trait,
//           animation: _controller,
//         );
//       }).toList(),
//     );
//   }
// }
