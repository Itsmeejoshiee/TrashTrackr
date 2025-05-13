String getWasteTypeImage(String wasteType) {
  switch (wasteType.toLowerCase()) {
    case 'recyclable':
      return 'assets/images/icons/recycling.png';
    case 'biodegradable':
      return 'assets/images/icons/leaf_brown.png';
    case 'non-biodegradable':
      return 'assets/images/icons/trashcan.png';
    case 'e-waste':
      return 'assets/images/icons/battery-blue.png';
    default:
      return 'assets/images/icons/plant.png'; // Fallback icon
  }
}
