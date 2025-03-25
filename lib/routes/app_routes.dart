part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const ORDER = _Paths.ORDER;
  static const JOBSLIPS = _Paths.JOBSLIPS;
  static const CREATEJOBSLIPS = _Paths.CREATEJOBSLIPS;
  static const EMBROIDERYJOBSLIPS = _Paths.EMBROIDERYJOBSLIPS;
  static const STITCHINGJOBSLIPS = _Paths.STITCHINGJOBSLIPS;
  static const THREADCUTTING = _Paths.THREADCUTTING;
  static const PRESS = _Paths.PRESS;
  static const COSTING = _Paths.COSTING;
  static const STOCK = _Paths.STOCK;
  static const CREATESTOCKLIST = _Paths.CREATESTOCKLIST;
  static const REMAININGSTOCK = _Paths.REMAININGSTOCK;
  static const DISPATCHSTOCK = _Paths.DISPATCHSTOCK;
  static const BOTTOMSCREEEN = _Paths.BOTTOMSCREEEN;
  static const CREATEPUCHASEORDERHOMESCREEN =
      _Paths.CREATEPUCHASEORDERHOMESCREEN;
  static const HOMEEMBROIDERYJOBSLIPS = _Paths.HOMEEMBROIDERYJOBSLIPS;
  static const HOMESTITCHINGJOBSLIPS = _Paths.HOMESTITCHINGJOBSLIPS;
  static const HOMETHREADCUTTING = _Paths.HOMETHREADCUTTING;
  static const HOMEPRESS = _Paths.HOMEPRESS;
  static const PURCHASEDETAILS = _Paths.PURCHASEDETAILS;
  static const STITCHINGJOBSLIPSDETAIL = _Paths.STITCHINGJOBSLIPSDETAIL;
  static const EMBROIDERYJOBSLIPSDETAIL = _Paths.EMBROIDERYJOBSLIPSDETAIL;
  static const HOMETHREADCUTTINGDETAILS = _Paths.HOMETHREADCUTTINGDETAILS;
  static const PRESSDETAILS = _Paths.PRESSDETAILS;
  static const JOBSLIPSDETAILS = _Paths.JOBSLIPSDETAILS;
  static const COSTINGLIST = _Paths.COSTINGLIST;
  static const STOCKLIST = _Paths.STOCKLIST;
  static const REMAININGSTOCKLIST = _Paths.REMAININGSTOCKLIST;
  static const DISPATCHSTOCKLIST = _Paths.DISPATCHSTOCKLIST;
  static const JOBSLIPRECEIVESCREEN = _Paths.JOBSLIPRECEIVESCREEN;
  static const EMBROIDERYRECEIVESCREEN = _Paths.EMBROIDERYRECEIVESCREEN;
  static const STITCHINGJOBRECEIVESCREEN = _Paths.STITCHINGJOBRECEIVESCREEN;
  static const THREADRECEIVESCREEN = _Paths.THREADRECEIVESCREEN;
  static const PRESSRECEIVESCREEN = _Paths.PRESSRECEIVESCREEN;
  static const PURCHASERECEIVESCREEN = _Paths.PURCHASERECEIVESCREEN;
}

abstract class _Paths {
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const ORDER = '/order';
  static const JOBSLIPS = '/jobslips';
  static const CREATEJOBSLIPS = '/createjobslips';
  static const EMBROIDERYJOBSLIPS = '/embtoideryjobslips';
  static const STITCHINGJOBSLIPS = '/stitchingjobslips';
  static const THREADCUTTING = '/threadcutting';
  static const PRESS = '/press';
  static const COSTING = '/costing';
  static const STOCK = '/stock';
  static const REMAININGSTOCK = '/remainingstock';
  static const DISPATCHSTOCK = '/dispatchstock';
  static const BOTTOMSCREEEN = '/bottomScreen';
  static const CREATEPUCHASEORDERHOMESCREEN = '/createpurchaseorderhomescreen';
  static const HOMEEMBROIDERYJOBSLIPS = '/homeembroidryjobslip';
  static const HOMESTITCHINGJOBSLIPS = '/homestitchingjobslip';
  static const HOMETHREADCUTTING = '/homethreadcutting';
  static const HOMEPRESS = '/homepress';
  static const PURCHASEDETAILS = '/purchasedetails';
  static const STITCHINGJOBSLIPSDETAIL = '/stitchingjobslipsdetails';
  static const EMBROIDERYJOBSLIPSDETAIL = '/embtoideryjobslipsdetails';
  static const HOMETHREADCUTTINGDETAILS = '/homethreadcuttingdetails';
  static const PRESSDETAILS = '/pressdetails';
  static const JOBSLIPSDETAILS = '/jobslipdetails';

  static const COSTINGLIST = '/costinglist';
  static const STOCKLIST = '/stocklist';
  static const CREATESTOCKLIST = '/createstocklist';
  static const REMAININGSTOCKLIST = '/remainingstocklist';
  static const DISPATCHSTOCKLIST = '/dispatchstocklist';
  static const JOBSLIPRECEIVESCREEN = '/JobSlipReceiveScreen';
  static const EMBROIDERYRECEIVESCREEN = '/EmbroideryReceiveScreen';
  static const STITCHINGJOBRECEIVESCREEN = '/stitchingJobReceiveScreen';
  static const THREADRECEIVESCREEN = '/ThreadReceiveScreen';
  static const PRESSRECEIVESCREEN = '/PressReceiveScreen';
  static const PURCHASERECEIVESCREEN = '/PurchaseReceiveScreen';
}
