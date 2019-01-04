class Challenge {
  String authScheme;
  String challenge;
  int expireTime;
  int serverTime;
  Challenge(this.challenge, {this.authScheme, this.expireTime, this.serverTime});
}