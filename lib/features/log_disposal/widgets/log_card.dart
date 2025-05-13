// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:trashtrackr/core/models/scan_result_model.dart';
// import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';
// import 'package:trashtrackr/core/utils/constants.dart';
// import 'package:trashtrackr/features/log_disposal/screens/log_details_screen.dart';
//
// import '../screens/log_details.dart';
//
// /// A widget that displays a single log entry as a card.
// class LogCard extends StatelessWidget {
//   final LogEntry result;
//
//   const LogCard({super.key, required this.result});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//
//         // TODO: NASA MALING FILE KA >:
//         // Navigate to LogDetailsScreen when the card is clicked
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LogDetailsScreen(
//               entry: result,
//               onImageUpdated: (newImageUrl) {
//                 newImageUrl = result.imageUrl ?? '';
//               },
//               onDetailsUpdated: (String notes, String quantity) {},
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6), // Vertical spacing between cards
//         width: double.infinity,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center, // Center the text vertically with the image
//           children: [
//             // Image on the left
//             ClipRRect(
//               borderRadius: BorderRadius.circular(6.03),
//               child: _buildImage(result.imageUrl ?? ''),
//             ),
//
//             const SizedBox(width: 12),
//
//             // Text content on the right
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Title text
//                   Text(
//                     result.title,
//                     style: kTitleMedium.copyWith(color: kAvocado, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 2),
//
//                   Text(
//                     '${_formatDate(result.timestamp ?? DateTime.now())} • ${_formatTime(result.timestamp ?? DateTime.now())}',
//                     style: kPoppinsBodySmall.copyWith(color: const Color(0xFF868686)),
//                   ),
//
//                   const SizedBox(height: 2),
//
//                   // Waste type row with icon and label
//                   Row(
//                     children: [
//                       Image.asset(
//                         _getWasteTypeImage(result.wasteType),
//                         width: 20,
//                         height: 20,
//                         fit: BoxFit.contain,
//                       ),
//                       const SizedBox(width: 5),
//                       Text(
//                         result.wasteType,
//                         style: kPoppinsBodySmall.copyWith(
//                           color: const Color(0xFF868686),
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds an image widget from either a network or local asset path.
//   Widget _buildImage(String imagePath) {
//     if (imagePath.startsWith('http')) {
//       // Load image from the internet
//       return Image.network(
//         imagePath,
//         width: 85,
//         height: 88,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           // Fallback if network image fails
//           return Image.asset(
//             'assets/images/placeholder.png',
//             width: 85,
//             height: 88,
//             fit: BoxFit.cover,
//           );
//         },
//       );
//     } else {
//       // Load image from local assets
//       return Image.asset(
//         imagePath,
//         width: 85,
//         height: 88,
//         fit: BoxFit.cover,
//       );
//     }
//   }
//
//   /// Formats the date into "Today", "Yesterday", or "Month day, year".
//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final entryDate = DateTime(date.year, date.month, date.day);
//
//     if (entryDate == today) {
//       return 'Today';
//     } else if (entryDate == today.subtract(const Duration(days: 1))) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('MMMM d, y').format(entryDate);
//     }
//   }
//
//   /// Formats the time to show hour and padded minutes (e.g., 13:05).
//   String _formatTime(DateTime date) {
//     return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }
//
//   /// Maps a waste type string to the appropriate image asset path.
//   String _getWasteTypeImage(String wasteType) {
//     switch (wasteType.toLowerCase()) {
//       case 'recyclable':
//         return 'assets/images/icons/recycling.png';
//       case 'biodegradable':
//         return 'assets/images/icons/leaf_brown.png';
//       case 'non-biodegradable':
//         return 'assets/images/icons/trashcan.png';
//       case 'e-waste':
//         return 'assets/images/icons/battery-blue.png';
//       default:
//         return 'assets/images/icons/plant.png'; // Fallback icon
//     }
//   }
// }