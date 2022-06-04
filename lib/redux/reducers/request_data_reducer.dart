import 'package:cambioseguro/models/models.dart';
import 'package:cambioseguro/redux/actions/actions.dart';
import 'package:redux/redux.dart';

final requestDataReducer = combineReducers<RequestData>([
  TypedReducer<RequestData, UpdateRequestDataRequestAction>(_updateData),
  TypedReducer<RequestData, LoadRateResponseAction>(_updateRate),
  TypedReducer<RequestData, ClientPreferentialRateResponseAction>(
      _updatePreferential),
  TypedReducer<RequestData, ClientPreferentialRateDeleteRequestAction>(
      _cleanPreferential),
  TypedReducer<RequestData, CleanferentialRateResponseAction>(
      _cleanPreferential),
  TypedReducer<RequestData, RequestCouponValidateResponse>(_updateCoupon),
  TypedReducer<RequestData, DeleteCouponRequestAction>(_cleanCoupon),
  TypedReducer<RequestData, LoadconfigResponseAction>(_updateConfig),
]);

RequestData _updateData(_, UpdateRequestDataRequestAction action) {
  return action.requestData;
}

RequestData _updateRate(
    RequestData requestData, LoadRateResponseAction action) {
  return requestData.copyWith(rate: action.rate);
}

RequestData _updatePreferential(
    RequestData requestData, ClientPreferentialRateResponseAction action) {
  return requestData.copyWith(
      preferentialRate: action.preferentialRate,
      penAmount: action.preferentialRate.amountPayable,
      amountPaid: action.preferentialRate.total,
      requestType: action.preferentialRate.requestType);
}

RequestData _cleanPreferential(RequestData requestData, action) {
  return requestData.copyWith(preferentialRate: null);
}

RequestData _updateCoupon(
    RequestData requestData, RequestCouponValidateResponse action) {
  return requestData.copyWith(currentCoupon: action.coupon);
}

RequestData _cleanCoupon(
    RequestData requestData, DeleteCouponRequestAction action) {
  return requestData.copyWith(currentCoupon: null);
}

RequestData _updateConfig(
    RequestData requestData, LoadconfigResponseAction action) {
  return requestData.copyWith(
      config: action.config, penAmount: action.config.requestAmountMinS);
}
