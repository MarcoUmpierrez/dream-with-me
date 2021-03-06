class Challenge {
  String authScheme;
  String challenge;
  int expireTime;
  int serverTime;
  Challenge(this.challenge, {this.authScheme, this.expireTime, this.serverTime});
  bool isExpired() {
    assert(this.expireTime != null);
    int expiredTime = this.expireTime*1000;
    return expiredTime < DateTime.now().millisecondsSinceEpoch;
  }
}