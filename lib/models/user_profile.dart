class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String profileImagePath;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.address = 'None',
    required this.profileImagePath,
  });

  // Mock user data
  static UserProfile mockProfile() {
    return UserProfile(
      name: 'Mohammed Ali',
      email: 'aldoss@example.com',
      phone: '+62 821 560 641',
      address: 'None',
      profileImagePath: 'assets/images/profile.png',
    );
  }
}