String getSlotName(int hour) {
  if (hour >= 5 && hour < 9) return 'Morning Medications';
  if (hour >= 9 && hour < 12) return 'Mid-Morning Medications';
  if (hour >= 12 && hour < 14) return 'Afternoon Medications';
  if (hour >= 14 && hour < 17) return 'Late Afternoon Medications';
  if (hour >= 17 && hour < 21) return 'Evening Medications';
  return 'Night Medications';
}
