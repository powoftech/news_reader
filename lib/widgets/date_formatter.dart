class DateFormatter {
  String formattedDate(DateTime publishedAt) {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ${difference.inHours % 24} hour${difference.inHours % 24 > 1 ? 's' : ''} ago";
    } else {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    }
  }
}
