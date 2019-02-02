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
  static const String Ver = 'ver';
  
}
class UserTagsParams {  
  static const String Tags = 'tags';
  static const String Display = 'display';
  static const String SecurityLevel = 'security_level';
  static const String Name = 'name';
  static const String Uses = 'uses';
  static const String Ver = 'ver';
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
  static const String Ver = 'ver';
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

class EventParams {
  static const String Ver = 'ver';
  static const String SelectType = 'selecttype';
  static const String HowMany = 'howmany';
  static const String NoProps = 'noprops';
  static const String LineEndings = 'lineendings';
  static const String Truncate = 'truncate';
  static const String UseJournal = 'usejournal';
  static const String Events = 'events';
  static const String Event = 'event';
  static const String URL = 'url';
  static const String EventTime = 'eventtime';
  static const String Subject = 'subject';
  static const String LogTime = 'logtime';
  static const String ItemId = 'itemid';
  static const String Anum = 'anum';
  static const String Props = 'props';
  static const String PictureKeyword = 'picture_keyword';
  static const String Interface = 'interface';
  static const String TagList = 'taglist';
  static const String OptScreening = 'opt_screening';
  static const String Poster = 'poster';
  static const String CommentAlter = 'commentalter';
  static const String Year = 'year';
  static const String Month = 'month';
  static const String Day = 'day';
}

class FaultParams {
  static const String FaultString = 'faultString';
  static const String FaultCode = 'faultCode';  
}

class GetDayCountsParams {
  static const String Ver = 'ver';
  static const String Usejournal = 'usejournal';
  static const String DayCounts = 'daycounts';
  static const String Date = 'date';
  static const String Count = 'count';
}

class CommentParams {
  static const String Journal = 'journal';
  static const String DItemId = 'ditemid';
  static const String ItemId = 'itemid';
  static const String Extra = 'extra';
}

class SessionGenerateParams {
  static const String Ver = 'ver';
  static const String Expiration = 'expiration';
  static const String IPFixed = 'ipfixed';
  static const String LJSession = 'ljsession';
}