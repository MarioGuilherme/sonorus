class TokenViewModel {
  final String accessToken;
  final String refreshToken;

  TokenViewModel({ required this.accessToken, required this.refreshToken });

  factory TokenViewModel.fromMap(Map<String, dynamic> map) => TokenViewModel(
    accessToken: map["accessToken"] as String,
    refreshToken: map["refreshToken"] as String
  );
}