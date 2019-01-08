class ChallengeParams {
  static const String Challenge = 'challenge';
  static const String AuthScheme = 'auth_scheme';
  static const String ExpireTime = 'expire_time';
  static const String ServerTime = 'server_time';
}

class AuthParams {
  static const String AuthChallenge = 'auth_challenge';
  static const String AuthResponse = 'auth_response';
  static const String UserName = 'username';
  static const String AuthMethod = 'auth_method';
}

class LoginParams {  
  static const String UserId = 'userid';
  static const String FullName = 'fullname';
  static const String DefaultPicURL = 'defaultpicurl';
  static const String GetPickWS = 'getpickws';
  static const String GetPickWURLS = 'getpickwurls';
  
}

class UserTagsParams {  
  static const String Tags = 'tags';
  static const String Display = 'display';
  static const String SecurityLevel = 'security_level';
  static const String Name = 'name';
  static const String Uses = 'uses';
}

class ReadPageParams {
  static const String Entries = 'entries';
  static const String JournalName = 'journalname';
  static const String LogTime = 'logtime';
  static const String DItemId = 'ditemid';
  static const String PosterName = 'postername';
  static const String Security = 'security';
  static const String PosterType = 'postertype';
  static const String EventRaw = 'event_raw';
  static const String SubjectRaw = 'subject_raw';
  static const String JournalType = 'journaltype';
}

class PostEventParams {
  static const String Subject = 'subject';
  static const String Event = 'event';
  static const String Lineendings = 'lineendings';
  static const String Security = 'security';
  static const String AllowMask = 'allowmask';
  static const String Year = 'year';
  static const String Mon = 'mon';
  static const String Day = 'day';
  static const String Hour = 'hour';
  static const String Min = 'min';
  static const String Props = 'props';
  static const String TagList = 'taglist';
  static const String ItemId = 'itemid';
  static const String Anum = 'anum';
  static const String Url = 'url';
}