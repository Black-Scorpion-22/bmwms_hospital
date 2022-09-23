
import 'StringsConst.dart';

class ApiUrl {
  static const String LOGIN = StringsConst.BASEURL + "loginfromapp";

  static const String GET_PRE_TREATMENT = StringsConst.BASEURL + "getPrtetreatment/";

  static const String PRE_TREATMENT_SUBMISSION = StringsConst.BASEURL + "pretreatmentsubmission";

  static const String GET_HANDOVER_ITEMS = StringsConst.BASEURL + "handoverstickergenerate/";

  static const String GENERATE_TOKEN = StringsConst.BASEURL + "qrcodeforhandover/";

  static const String GET_STAFFS = StringsConst.BASEURL + "gethospitalstaff/";

  static const String GET_ALL_STAFFS = StringsConst.BASEURL + "gethospitalstaffAll/";

  static const String GET_STAFF_DETAILS = StringsConst.BASEURL + "getStaffdetailsByuId/";

  static const String POST_TRAINING_SESS = StringsConst.BASEURL + "trainingsessionset";

  static const String UPDATE_STAFF_DETAILS = StringsConst.BASEURL + "updatestaffstatus";


}