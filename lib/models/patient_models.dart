import 'package:jawda/models/doctor.dart';
import 'package:jawda/models/user.dart';


class RequestedToothService {
  final int id;
  final int requestedServiceId;
  final int toothId;
  final int doctorvisitId;

  RequestedToothService({
    required this.id,
    required this.requestedServiceId,
    required this.toothId,
    required this.doctorvisitId,
  });

    factory RequestedToothService.fromJson(Map<String, dynamic> json) {
    return RequestedToothService(
        id: json['id'] as int,
        requestedServiceId: json['requested_service_id'] as int,
        toothId: json['tooth_id'] as int,
        doctorvisitId: json['doctorvisit_id'] as int,
    );
  }
}

class DoctorVisit {
  final int id;
  final bool hasCbc;
  final int patientId;
  final int doctorShiftId;
  final String createdAt;
  final String updatedAt;
  final int isNew;
  final int number;
  final num totalPaidServices;
  final num totalServices;
  final num totalDiscounted;
  final Patient patient;
  final List<RequestedService> services;
  final num onlyLab;
  final PatientFile? file;
  final num totalservicebank;
  final DoctorShift doctorShift;
  final num totalRemainig;
  final List<RequestedToothService> requestedToothServices;

  DoctorVisit({
    required this.id,
    required this.hasCbc,
    required this.patientId,
    required this.doctorShiftId,
    required this.createdAt,
    required this.updatedAt,
    required this.isNew,
    required this.number,
    required this.totalPaidServices,
    required this.totalServices,
    required this.totalDiscounted,
    required this.patient,
    required this.services,
    required this.onlyLab,
    this.file,
    required this.totalservicebank,
    required this.doctorShift,
    required this.totalRemainig,
    required this.requestedToothServices,
  });
      factory DoctorVisit.fromJson(Map<String, dynamic> json) {
    return DoctorVisit(
    id: json['id'] as int,
    hasCbc: json['hasCbc'] as bool,
    patientId: json['patient_id'] as int,
    doctorShiftId: json['doctor_shift_id'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    isNew: json['is_new'] as int,
    number: json['number'] as int,
    totalPaidServices: json['total_paid_services'] as num,
    totalServices: json['total_services'] as num,
    totalDiscounted: json['total_discounted'] as num,
    patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
    services: (json['services'] as List).map((e) => RequestedService.fromJson(e as Map<String, dynamic>)).toList(),
    onlyLab: json['only_lab'] as num,
    file: json['file'] == null ? null : PatientFile.fromJson(json['file'] as Map<String, dynamic>),
    totalservicebank: json['totalservicebank'] as num,
    doctorShift: DoctorShift.fromJson(json['doctor_shift'] as Map<String, dynamic>),
    totalRemainig: json['totalRemainig'] as num,
    requestedToothServices: (json['requested_tooth_services'] as List).map((e) => RequestedToothService.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class PatientFile {
  final int id;
  final List<DoctorVisit> patients;

  PatientFile({
    required this.id,
    required this.patients,
  });
    factory PatientFile.fromJson(Map<String, dynamic> json) {
    return PatientFile(
      id: json['id'] as int,
      patients: (json['patients'] as List).map((e) => DoctorVisit.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class Patient {
  final int id;
  final String name;
  final int shiftId;
  final int userId;
  final int doctorId;
  final String phone;
  final String gender;
  final dynamic ageDay;
  final dynamic ageMonth;
  final num ageYear;
  final dynamic companyId;
  final dynamic subcompanyId;
  final dynamic companyRelationId;
  final dynamic paperFees;
  final dynamic guarantor;
  final dynamic expireDate;
  final dynamic insuranceNo;
  final num isLabPaid;
  final num labPaid;
  final num resultIsLocked;
  final num sampleCollected;
  final String sampleCollectTime;
  final String resultPrintDate;
  final dynamic samplePrintDate;
  final num visitNumber;
  final num resultAuth;
  final String authDate;
  final String createdAt;
  final String updatedAt;
  final String presentComplains;
  final String historyOfPresentIllness;
  final String procedures;
  final String provisionalDiagnosis;
  final String bp;
  final num temp;
  final num weight;
  final num height;
  final dynamic juandice;
  final dynamic pallor;
  final dynamic clubbing;
  final dynamic cyanosis;
  final dynamic edemaFeet;
  final dynamic dehydration;
  final dynamic lymphadenopathy;
  final dynamic peripheralPulses;
  final dynamic feetUlcer;
  final dynamic countryId;
  final dynamic govId;
  final dynamic prescriptionNotes;
  final dynamic address;
  final dynamic heartRate;
  final dynamic spo2;
  final num discount;
  final String drugHistory;
  final String familyHistory;
  final String rbs;
  final num doctorFinish;
  final String carePlan;
  final num doctorLabRequestConfirm;
  final num doctorLabUrgentConfirm;
  final num paid;
  final bool hasCbc;
  final num visitCount;
  final num totalLabValueUnpaid;
  final num totalLabValueWillPay;
  final num discountAmount;
  final List<Labrequest> labrequests;
  final Doctor doctor;
  final dynamic company;
  final dynamic subcompany;
  final dynamic relation;
  final User user;
  final List<dynamic> prescriptions;
  final dynamic country;
  final dynamic sickleave;
  final String generalExaminationNotes;
    final String past_medical_history;
    final String social_history;
    final String allergies;
    final String general;
    final String skin;
    final String head;
    final String eyes;
    final String ear;
    final String nose;
    final String mouth;
    final String throat;
    final String neck;
    final String respiratory_system;
    final String cardio_system;
    final String git_system;
    final String genitourinary_system;
    final String nervous_system;
    final String musculoskeletal_system;
    final String neuropsychiatric_system;
    final String endocrine_system;
    final String peripheral_vascular_system;
    final String referred;
    final String nurse_note;
    final String patient_medical_history;
    final num totalLabBank;
    final num lastShift;

  Patient({
    required this.id,
    required this.name,
    required this.shiftId,
    required this.userId,
    required this.doctorId,
    required this.phone,
    required this.gender,
    required this.ageDay,
    required this.ageMonth,
    required this.ageYear,
    required this.companyId,
    required this.subcompanyId,
    required this.companyRelationId,
    required this.paperFees,
    required this.guarantor,
    required this.expireDate,
    required this.insuranceNo,
    required this.isLabPaid,
    required this.labPaid,
    required this.resultIsLocked,
    required this.sampleCollected,
    required this.sampleCollectTime,
    required this.resultPrintDate,
    required this.samplePrintDate,
    required this.visitNumber,
    required this.resultAuth,
    required this.authDate,
    required this.createdAt,
    required this.updatedAt,
    required this.presentComplains,
    required this.historyOfPresentIllness,
    required this.procedures,
    required this.provisionalDiagnosis,
    required this.bp,
    required this.temp,
    required this.weight,
    required this.height,
    required this.juandice,
    required this.pallor,
    required this.clubbing,
    required this.cyanosis,
    required this.edemaFeet,
    required this.dehydration,
    required this.lymphadenopathy,
    required this.peripheralPulses,
    required this.feetUlcer,
    required this.countryId,
    required this.govId,
    required this.prescriptionNotes,
    required this.address,
    required this.heartRate,
    required this.spo2,
    required this.discount,
    required this.drugHistory,
    required this.familyHistory,
    required this.rbs,
    required this.doctorFinish,
    required this.carePlan,
    required this.doctorLabRequestConfirm,
    required this.doctorLabUrgentConfirm,
    required this.paid,
    required this.hasCbc,
    required this.visitCount,
    required this.totalLabValueUnpaid,
    required this.totalLabValueWillPay,
    required this.discountAmount,
    required this.labrequests,
    required this.doctor,
    required this.company,
    required this.subcompany,
    required this.relation,
    required this.user,
    required this.prescriptions,
    required this.country,
    required this.sickleave,
        required this.generalExaminationNotes,
        required this.past_medical_history,
        required this.social_history,
        required this.allergies,
        required this.general,
        required this.skin,
        required this.head,
        required this.eyes,
        required this.ear,
        required this.nose,
        required this.mouth,
        required this.throat,
        required this.neck,
        required this.respiratory_system,
        required this.cardio_system,
        required this.git_system,
        required this.genitourinary_system,
        required this.nervous_system,
        required this.musculoskeletal_system,
        required this.neuropsychiatric_system,
        required this.endocrine_system,
        required this.peripheral_vascular_system,
        required this.referred,
        required this.nurse_note,
        required this.patient_medical_history,
        required this.totalLabBank,
        required this.lastShift,
  });
        factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
    id: json['id'] as int,
    name: json['name'] as String,
    shiftId: json['shift_id'] as int,
    userId: json['user_id'] as int,
    doctorId: json['doctor_id'] as int,
    phone: json['phone'] as String,
    gender: json['gender'] as String,
    ageDay: json['age_day'],
    ageMonth: json['age_month'],
    ageYear: json['age_year'] as num,
    companyId: json['company_id'],
    subcompanyId: json['subcompany_id'],
    companyRelationId: json['company_relation_id'],
    paperFees: json['paper_fees'],
    guarantor: json['guarantor'],
    expireDate: json['expire_date'],
    insuranceNo: json['insurance_no'],
    isLabPaid: json['is_lab_paid'] as num,
    labPaid: json['lab_paid'] as num,
    resultIsLocked: json['result_is_locked'] as num,
    sampleCollected: json['sample_collected'] as num,
    sampleCollectTime: json['sample_collect_time'] as String,
    resultPrintDate: json['result_print_date'] as String,
    samplePrintDate: json['sample_print_date'],
    visitNumber: json['visit_number'] as num,
    resultAuth: json['result_auth'] as num,
    authDate: json['auth_date'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    presentComplains: json['present_complains'] as String,
    historyOfPresentIllness: json['history_of_present_illness'] as String,
    procedures: json['procedures'] as String,
    provisionalDiagnosis: json['provisional_diagnosis'] as String,
    bp: json['bp'] as String,
    temp: json['temp'] as num,
    weight: json['weight'] as num,
    height: json['height'] as num,
    juandice: json['juandice'],
    pallor: json['pallor'],
    clubbing: json['clubbing'],
    cyanosis: json['cyanosis'],
    edemaFeet: json['edema_feet'],
    dehydration: json['dehydration'],
    lymphadenopathy: json['lymphadenopathy'],
    peripheralPulses: json['peripheral_pulses'],
    feetUlcer: json['feet_ulcer'],
    countryId: json['country_id'],
    govId: json['gov_id'],
    prescriptionNotes: json['prescription_notes'],
    address: json['address'],
    heartRate: json['heart_rate'],
    spo2: json['spo2'],
    discount: json['discount'] as num,
    drugHistory: json['drug_history'] as String,
    familyHistory: json['family_history'] as String,
    rbs: json['rbs'] as String,
    doctorFinish: json['doctor_finish'] as num,
    carePlan: json['care_plan'] as String,
    doctorLabRequestConfirm: json['doctor_lab_request_confirm'] as num,
    doctorLabUrgentConfirm: json['doctor_lab_urgent_confirm'] as num,
    paid: json['paid'] as num,
    hasCbc: json['hasCbc'] as bool,
    visitCount: json['visit_count'] as num,
    totalLabValueUnpaid: json['total_lab_value_unpaid'] as num,
    totalLabValueWillPay: json['total_lab_value_will_pay'] as num,
    discountAmount: json['discountAmount'] as num,
    labrequests: (json['labrequests'] as List).map((e) => Labrequest.fromJson(e as Map<String, dynamic>)).toList(),
    doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
    company: json['company'],
    subcompany: json['subcompany'],
    relation: json['relation'],
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    prescriptions: json['prescriptions'] as List<dynamic>,
    country: json['country'],
    sickleave: json['sickleave'],
      generalExaminationNotes: json['general_examination_notes'] as String,
    past_medical_history: json['past_medical_history'] as String,
    social_history: json['social_history'] as String,
    allergies: json['allergies'] as String,
    general: json['general'] as String,
    skin: json['skin'] as String,
    head: json['head'] as String,
    eyes: json['eyes'] as String,
    ear: json['ear'] as String,
    nose: json['nose'] as String,
    mouth: json['mouth'] as String,
    throat: json['throat'] as String,
    neck: json['neck'] as String,
    respiratory_system: json['respiratory_system'] as String,
    cardio_system: json['cardio_system'] as String,
    git_system: json['git_system'] as String,
    genitourinary_system: json['genitourinary_system'] as String,
    nervous_system: json['nervous_system'] as String,
    musculoskeletal_system: json['musculoskeletal_system'] as String,
    neuropsychiatric_system: json['neuropsychiatric_system'] as String,
    endocrine_system: json['endocrine_system'] as String,
    peripheral_vascular_system: json['peripheral_vascular_system'] as String,
    referred: json['referred'] as String,
    nurse_note: json['nurse_note'] as String,
    patient_medical_history: json['patient_medical_history'] as String,
    totalLabBank: json['totalLabBank'] as num,
    lastShift: json['lastShift'] as num,
    );
  }
}

class Labrequest {
  final int id;
  final int mainTestId;
  final int pid;
  final int hidden;
  final int isLab2lab;
  final int valid;
  final int noSample;
  final num price;
  final num amountPaid;
  final num discountPer;
  final num isBankak;
  final dynamic comment;
  final User userRequested;
  final num userDeposited;
  final num approve;
  final num endurance;
  final String name;
  final List<RequestedResult> requestedResults;
  final MainTest mainTest;
  final List<dynamic> unfinishedResultsCount;
  final List<dynamic> requestedOrganisms;
  final String createdAt;
  final String updatedAt;
  final bool isPaid;

  Labrequest({
    required this.id,
    required this.mainTestId,
    required this.pid,
    required this.hidden,
    required this.isLab2lab,
    required this.valid,
    required this.noSample,
    required this.price,
    required this.amountPaid,
    required this.discountPer,
    required this.isBankak,
    required this.comment,
    required this.userRequested,
    required this.userDeposited,
    required this.approve,
    required this.endurance,
    required this.name,
    required this.requestedResults,
    required this.mainTest,
    required this.unfinishedResultsCount,
    required this.requestedOrganisms,
    required this.createdAt,
    required this.updatedAt,
    required this.isPaid,
  });
      factory Labrequest.fromJson(Map<String, dynamic> json) {
    return Labrequest(
    id: json['id'] as int,
    mainTestId: json['main_test_id'] as int,
    pid: json['pid'] as int,
    hidden: json['hidden'] as int,
    isLab2lab: json['is_lab2lab'] as int,
    valid: json['valid'] as int,
    noSample: json['no_sample'] as int,
    price: json['price'] as num,
    amountPaid: json['amount_paid'] as num,
    discountPer: json['discount_per'] as num,
    isBankak: json['is_bankak'] as num,
    comment: json['comment'],
    userRequested: User.fromJson(json['user_requested'] as Map<String, dynamic>),
    userDeposited: json['user_deposited'] as num,
    approve: json['approve'] as num,
    endurance: json['endurance'] as num,
    name: json['name'] as String,
    requestedResults: (json['requested_results'] as List).map((e) => RequestedResult.fromJson(e as Map<String, dynamic>)).toList(),
    mainTest: MainTest.fromJson(json['main_test'] as Map<String, dynamic>),
    unfinishedResultsCount: json['unfinished_results_count'] as List<dynamic>,
    requestedOrganisms: json['requested_organisms'] as List<dynamic>,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    isPaid: json['is_paid'] as bool,
    );
  }
}

class Role {
  final int id;
  final String name;
  final String guardName;
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });
      factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
    id: json['id'] as int,
    name: json['name'] as String,
    guardName: json['guard_name'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    pivot: Pivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );
  }
}

class Pivot {
  final String modelType;
  final num modelId;
  final num roleId;

  Pivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });
    factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
    modelType: json['model_type'] as String,
    modelId: json['model_id'] as num,
    roleId: json['role_id'] as num,
    );
  }
}



class RequestedResult {
  final int id;
  final int labRequestId;
  final int patientId;
  final int mainTestId;
  final int childTestId;
  final String result;
  final String normalRange;
  final String createdAt;
  final String updatedAt;
  final ChildTest childTest;

  RequestedResult({
    required this.id,
    required this.labRequestId,
    required this.patientId,
    required this.mainTestId,
    required this.childTestId,
    required this.result,
    required this.normalRange,
    required this.createdAt,
    required this.updatedAt,
    required this.childTest,
  });
          factory RequestedResult.fromJson(Map<String, dynamic> json) {
    return RequestedResult(
    id: json['id'] as int,
    labRequestId: json['lab_request_id'] as int,
    patientId: json['patient_id'] as int,
    mainTestId: json['main_test_id'] as int,
    childTestId: json['child_test_id'] as int,
    result: json['result'] as String,
    normalRange: json['normal_range'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    childTest: ChildTest.fromJson(json['child_test'] as Map<String, dynamic>),
    );
  }
}

class ChildTest {
  final int id;
  final String childTestName;
  final num? low;
  final num? upper;
  final int mainTestId;
  final String defval;
  final int unitId;
  final String normalRange;
  final String max;
  final String lowest;
  final dynamic testOrder;
  final num? childGroupId;
  final Unit unit;
  final ChildGroup? childGroup;

  ChildTest({
    required this.id,
    required this.childTestName,
    this.low,
    this.upper,
    required this.mainTestId,
    required this.defval,
    required this.unitId,
    required this.normalRange,
    required this.max,
    required this.lowest,
    required this.testOrder,
    this.childGroupId,
    required this.unit,
    this.childGroup,
  });
            factory ChildTest.fromJson(Map<String, dynamic> json) {
    return ChildTest(
    id: json['id'] as int,
    childTestName: json['child_test_name'] as String,
    low: json['low'] as num?,
    upper: json['upper'] as num?,
    mainTestId: json['main_test_id'] as int,
    defval: json['defval'] as String,
    unitId: json['unit_id'] as int,
    normalRange: json['normalRange'] as String,
    max: json['max'] as String,
    lowest: json['lowest'] as String,
    testOrder: json['test_order'],
    childGroupId: json['child_group_id'] as num?,
    unit: Unit.fromJson(json['unit'] as Map<String, dynamic>),
    childGroup: json['child_group'] == null ? null :ChildGroup.fromJson(json['child_group'] as Map<String, dynamic>),
    );
  }
}

class Unit {
  final int id;
  final String name;

  Unit({
    required this.id,
    required this.name,
  });
        factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
    id: json['id'] as int,
    name: json['name'] as String,
    );
  }
}

class ChildGroup {
  final int id;
  final String name;

  ChildGroup({
    required this.id,
    required this.name,
  });
           factory ChildGroup.fromJson(Map<String, dynamic> json) {
    return ChildGroup(
    id: json['id'] as int,
    name: json['name'] as String,
    );
  }
}

class MainTest {
  final int id;
  final String mainTestName;
  final int packId;
  final int pageBreak;
  final int containerId;
  final num price;
  final int firstChildId;
  final Container container;

  MainTest({
    required this.id,
    required this.mainTestName,
    required this.packId,
    required this.pageBreak,
    required this.containerId,
    required this.price,
    required this.firstChildId,
    required this.container,
  });
           factory MainTest.fromJson(Map<String, dynamic> json) {
    return MainTest(
    id: json['id'] as int,
    mainTestName: json['main_test_name'] as String,
    packId: json['pack_id'] as int,
    pageBreak: json['pageBreak'] as int,
    containerId: json['container_id'] as int,
    price: json['price'] == null ? 0 : json['price'] as num,
    firstChildId: json['firstChildId'] as int,
    container: Container.fromJson(json['container'] as Map<String, dynamic>),
    );
  }
}

class Container {
  final int id;
  final String containerName;

  Container({
    required this.id,
    required this.containerName,
  });
             factory Container.fromJson(Map<String, dynamic> json) {
    return Container(
    id: json['id'] as int,
    containerName: json['container_name'] as String,
    );
  }
}


class DoctorService {
  final int id;
  final int doctorId;
  final int serviceId;
  final num percentage;
  final num fixed;
  final Service service;

  DoctorService({
    required this.id,
    required this.doctorId,
    required this.serviceId,
    required this.percentage,
    required this.fixed,
    required this.service,
  });
         factory DoctorService.fromJson(Map<String, dynamic> json) {
    return DoctorService(
    id: json['id'] as int,
    doctorId: json['doctor_id'] as int,
    serviceId: json['service_id'] as int,
    percentage: json['percentage'] as num,
    fixed: json['fixed'] as num,
    service: Service.fromJson(json['service'] as Map<String, dynamic>),
    );
  }
}

class Service {
  final int id;
  final String name;
  final int serviceGroupId;
  final num price;
  final num activate;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> serviceCosts;
  final bool variable;

  Service({
    required this.id,
    required this.name,
    required this.serviceGroupId,
    required this.price,
    required this.activate,
    required this.createdAt,
    required this.updatedAt,
    required this.serviceCosts,
    required this.variable,
  });
           factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
    id: json['id'] as int,
    name: json['name'] as String,
    serviceGroupId: json['service_group_id'] as int,
    price: json['price'] as num,
    activate: json['activate'] as num,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    serviceCosts: json['service_costs'] as List<dynamic>,
    variable: json['variable'] as bool,
    );
  }
}


class RootObject {
  final int id;
  final int patientId;
  final int doctorShiftId;
  final String createdAt;
  final String updatedAt;
  final int isNew;
  final int number;
  final num onlyLab;
  final int shiftId;
  final num totalPaidServices;
  final num totalServices;
  final num totalDiscounted;
  final Patient patient;
  final List<dynamic> services;

  RootObject({
    required this.id,
    required this.patientId,
    required this.doctorShiftId,
    required this.createdAt,
    required this.updatedAt,
    required this.isNew,
    required this.number,
    required this.onlyLab,
    required this.shiftId,
    required this.totalPaidServices,
    required this.totalServices,
    required this.totalDiscounted,
    required this.patient,
    required this.services,
  });
    factory RootObject.fromJson(Map<String, dynamic> json) {
    return RootObject(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      doctorShiftId: json['doctor_shift_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isNew: json['is_new'] as int,
      number: json['number'] as int,
      onlyLab: json['only_lab'] as num,
      shiftId: json['shift_id'] as int,
      totalPaidServices: json['total_paid_services'] as num,
      totalServices: json['total_services'] as num,
      totalDiscounted: json['total_discounted'] as num,
      patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
      services: json['services'] as List<dynamic>,
    );
  }
}

class Filepatient {
  final int id;
  final int fileId;
  final int patientId;

  Filepatient({
    required this.id,
    required this.fileId,
    required this.patientId,
  });
       factory Filepatient.fromJson(Map<String, dynamic> json) {
    return Filepatient(
      id: json['id'] as int,
      fileId: json['file_id'] as int,
      patientId: json['patient_id'] as int,
    );
  }
}


class Servicegroup {
  final int id;
  final String name;
  final List<Service> services;

  Servicegroup({
    required this.id,
    required this.name,
    required this.services,
  });
      factory Servicegroup.fromJson(Map<String, dynamic> json) {
    return Servicegroup(
    id: json['id'] as int,
    name: json['name'] as String,
    services: (json['services'] as List).map((e) => Service.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class ServiceCost {
  final int id;
  final int subServiceCostId;
  final int serviceId;
  final num percentage;
  final num fixed;
  final String costType;
  final List<Costorder> costOrders;
  final Subservicecost subServiceCost;

  ServiceCost({
    required this.id,
    required this.subServiceCostId,
    required this.serviceId,
    required this.percentage,
    required this.fixed,
    required this.costType,
    required this.costOrders,
    required this.subServiceCost,
  });
       factory ServiceCost.fromJson(Map<String, dynamic> json) {
    return ServiceCost(
    id: json['id'] as int,
    subServiceCostId: json['sub_service_cost_id'] as int,
    serviceId: json['service_id'] as int,
    percentage: json['percentage'] as num,
    fixed: json['fixed'] as num,
    costType: json['cost_type'] as String,
    costOrders: (json['cost_orders'] as List).map((e) => Costorder.fromJson(e as Map<String, dynamic>)).toList(),
    subServiceCost: Subservicecost.fromJson(json['sub_service_cost'] as Map<String, dynamic>),
    );
  }
}

class Subservicecost {
  final int id;
  final String name;

  Subservicecost({
    required this.id,
    required this.name,
  });
         factory Subservicecost.fromJson(Map<String, dynamic> json) {
    return Subservicecost(
    id: json['id'] as int,
    name: json['name'] as String,
    );
  }
}

class Costorder {
  final int id;
  final int requestedServiceId;
  final int serviceCostId;
  final int subServiceCostId;
  final String createdAt;
  final String updatedAt;

  Costorder({
    required this.id,
    required this.requestedServiceId,
    required this.serviceCostId,
    required this.subServiceCostId,
    required this.createdAt,
    required this.updatedAt,
  });
    factory Costorder.fromJson(Map<String, dynamic> json) {
    return Costorder(
    id: json['id'] as int,
    requestedServiceId: json['requested_service_id'] as int,
    serviceCostId: json['service_cost_id'] as int,
    subServiceCostId: json['sub_service_cost_id'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    );
  }
}

class Maintest {
  final int id;
  final String mainTestName;
  final int packId;
  final int pageBreak;
  final int containerId;
  final num price;
  final int firstChildId;
  final Container container;
  final ChildTest oneChild;

  Maintest({
    required this.id,
    required this.mainTestName,
    required this.packId,
    required this.pageBreak,
    required this.containerId,
    required this.price,
    required this.firstChildId,
    required this.container,
    required this.oneChild,
  });
       factory Maintest.fromJson(Map<String, dynamic> json) {
    return Maintest(
    id: json['id'] as int,
    mainTestName: json['main_test_name'] as String,
    packId: json['pack_id'] as int,
    pageBreak: json['pageBreak'] as int,
    containerId: json['container_id'] as int,
    price: json['price'] as num,
    firstChildId: json['firstChildId'] as int,
    container: Container.fromJson(json['container'] as Map<String, dynamic>),
    oneChild: ChildTest.fromJson(json['one_child'] as Map<String, dynamic>),
    );
  }
}


class Requestedresult {
  final int id;
  final int labRequestId;
  final int patientId;
  final int mainTestId;
  final int childTestId;
  final String result;
  final String normalRange;
  final String createdAt;
  final String updatedAt;
  final Childtest childTest;

  Requestedresult({
    required this.id,
    required this.labRequestId,
    required this.patientId,
    required this.mainTestId,
    required this.childTestId,
    required this.result,
    required this.normalRange,
    required this.createdAt,
    required this.updatedAt,
    required this.childTest,
  });
     factory Requestedresult.fromJson(Map<String, dynamic> json) {
    return Requestedresult(
    id: json['id'] as int,
    labRequestId: json['lab_request_id'] as int,
    patientId: json['patient_id'] as int,
    mainTestId: json['main_test_id'] as int,
    childTestId: json['child_test_id'] as int,
    result: json['result'] as String,
    normalRange: json['normal_range'] as String,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    childTest: Childtest.fromJson(json['child_test'] as Map<String, dynamic>),
    );
  }
}

class Childtest {
  final int id;
  final String childTestName;
  final num? low;
  final num? upper;
  final int mainTestId;
  final String defval;
  final int unitId;
  final String normalRange;
  final String max;
  final String lowest;
  final dynamic testOrder;
  final dynamic childGroupId;
  final Unit unit;
  final dynamic childGroup;

  Childtest({
    required this.id,
    required this.childTestName,
    this.low,
    this.upper,
    required this.mainTestId,
    required this.defval,
    required this.unitId,
    required this.normalRange,
    required this.max,
    required this.lowest,
    required this.testOrder,
    required this.childGroupId,
    required this.unit,
    required this.childGroup,
  });
       factory Childtest.fromJson(Map<String, dynamic> json) {
    return Childtest(
    id: json['id'] as int,
    childTestName: json['child_test_name'] as String,
    low: json['low'] as num?,
    upper: json['upper'] as num?,
    mainTestId: json['main_test_id'] as int,
    defval: json['defval'] as String,
    unitId: json['unit_id'] as int,
    normalRange: json['normalRange'] as String,
    max: json['max'] as String,
    lowest: json['lowest'] as String,
    testOrder: json['test_order'],
    childGroupId: json['child_group_id'],
    unit: Unit.fromJson(json['unit'] as Map<String, dynamic>),
    childGroup: json['child_group'],
    );
  }
}














class Settings {
  final int id;
  final num isHeader;
  final num isFooter;
  final num isLogo;
  final String headerBase64;
  final String footerBase64;
  final dynamic headerContent;
  final dynamic footerContent;
  final dynamic logoBase64;
  final dynamic labName;
  final String hospitalName;
  final dynamic printDirect;
  final dynamic inventoryNotificationNumber;
  final String createdAt;
  final String updatedAt;
  final num disableDoctorServiceCheck;
  final String currency;
  final String phone;
  final num gov;
  final num country;
  final num barcode;
  final num showWaterMark;
  final String vatin;
  final String cr;
  final String email;
  final String instanceId;
  final String token;
  final num sendResultAfterAuth;
  final num sendResultAfterResult;
  final bool editResultAfterAuth;

  Settings({
    required this.id,
    required this.isHeader,
    required this.isFooter,
    required this.isLogo,
    required this.headerBase64,
    required this.footerBase64,
    required this.headerContent,
    required this.footerContent,
    required this.logoBase64,
    required this.labName,
    required this.hospitalName,
    required this.printDirect,
    required this.inventoryNotificationNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.disableDoctorServiceCheck,
    required this.currency,
    required this.phone,
    required this.gov,
    required this.country,
    required this.barcode,
    required this.showWaterMark,
    required this.vatin,
    required this.cr,
    required this.email,
    required this.instanceId,
    required this.token,
    required this.sendResultAfterAuth,
    required this.sendResultAfterResult,
    required this.editResultAfterAuth,
  });
       factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
    id: json['id'] as int,
    isHeader: json['is_header'] as num,
    isFooter: json['is_footer'] as num,
    isLogo: json['is_logo'] as num,
    headerBase64: json['header_base64'] as String,
    footerBase64: json['footer_base64'] as String,
    headerContent: json['header_content'],
    footerContent: json['footer_content'],
    logoBase64: json['logo_base64'],
    labName: json['lab_name'],
    hospitalName: json['hospital_name'] as String,
    printDirect: json['print_direct'],
    inventoryNotificationNumber: json['inventory_notification_number'],
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    disableDoctorServiceCheck: json['disable_doctor_service_check'] as num,
    currency: json['currency'] as String,
    phone: json['phone'] as String,
    gov: json['gov'] as num,
    country: json['country'] as num,
    barcode: json['barcode'] as num,
    showWaterMark: json['show_water_mark'] as num,
    vatin: json['vatin'] as String,
    cr: json['cr'] as String,
    email: json['email'] as String,
    instanceId: json['instance_id'] as String,
    token: json['token'] as String,
    sendResultAfterAuth: json['send_result_after_auth'] as num,
    sendResultAfterResult: json['send_result_after_result'] as num,
    editResultAfterAuth: json['edit_result_after_auth'] as bool,
    );
  }
}



class DoctorShift {
  final int id;
  final int userId;
  final int shiftId;
  final int doctorId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final int visitsCount; // Added visitsCount

  final Doctor doctor; // Changed from `dynamic` to Doctor type
  final dynamic cost; // Kept as dynamic as type is unknown 
  final List<DoctorVisit>? visits;

  DoctorShift({
    required this.id,
    required this.userId,
    required this.shiftId,
    required this.doctorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.visitsCount,
    required this.doctor,
    required this.cost,
    this.visits,
  });
  
   factory DoctorShift.fromJson(Map<String, dynamic> json) {
    return DoctorShift(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        shiftId: json['shift_id'] as int,
        doctorId: json['doctor_id'] as int,
        status: json['status'] as int,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        visitsCount: json['visitsCount'] as int,
        doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
        cost: json['cost'],
        visits: (json['visits'] as List?)?.map((e) => DoctorVisit.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class LastShift {
  final int id;
  final int userId;
  final int shiftId;
  final int doctorId;
  final int status;
  final String createdAt;
  final String updatedAt;
  final int visitsCount;

  LastShift({
    required this.id,
    required this.userId,
    required this.shiftId,
    required this.doctorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.visitsCount,
  });
   factory LastShift.fromJson(Map<String, dynamic> json) {
    return LastShift(
    id: json['id'] as int,
    userId: json['user_id'] as int,
    shiftId: json['shift_id'] as int,
    doctorId: json['doctor_id'] as int,
    status: json['status'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
     visitsCount: json['visitsCount'] as int,
    );
  }
}


class Specialist {
  int id;
  String name;
  String created_at;
  String updated_at;

  Specialist({
    required this.id,
    required this.name,
    required this.created_at,
    required this.updated_at,
  });
    factory Specialist.fromJson(Map<String, dynamic> json) {
    return Specialist(
    id: json['id'] as int,
    name: json['name'] as String,
    created_at: json['created_at'] as String,
    updated_at: json['updated_at'] as String,
    );
  }
}





class RequestedService {
  final int id;
  final int doctorvisitsId;
  final int serviceId;
  final int userId;
  final User userDeposited;
  final int doctorId;
  final num price;
  final String amountPaid;
  final num endurance;
  final num isPaid;
  final num discount;
  final num bank;
  final int count;
  final String createdAt;
  final String updatedAt;
  final String doctorNote;
  final String nurseNote;
  final int done;
  final int approval;
  final String amountPaidStr;
  final Service service;
  final User userRequested;
  final List<dynamic> requestedServiceCosts; // Define a proper type if known
  final List<Deposit> deposits; // Add Deposit class if you have it

  RequestedService({
    required this.id,
    required this.doctorvisitsId,
    required this.serviceId,
    required this.userId,
    required this.userDeposited,
    required this.doctorId,
    required this.price,
    required this.amountPaid,
    required this.endurance,
    required this.isPaid,
    required this.discount,
    required this.bank,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.doctorNote,
    required this.nurseNote,
    required this.done,
    required this.approval,
    required this.amountPaidStr,
    required this.service,
    required this.userRequested,
    required this.requestedServiceCosts,
    required this.deposits,
  });

  factory RequestedService.fromJson(Map<String, dynamic> json) {
    return RequestedService(
      id: json['id'] as int,
      doctorvisitsId: json['doctorvisits_id'] as int,
      serviceId: json['service_id'] as int,
      userId: json['user_id'] as int,
      userDeposited: User.fromJson(json['user_deposited'] as Map<String, dynamic>),  // Assuming you have User class
      doctorId: json['doctor_id'] as int,
      price: (json['price'] as num).toDouble(),
      amountPaid: json['amount_paid'] as String,
      endurance: json['endurance'] as num,
      isPaid: json['is_paid'] as num,
      discount: json['discount'] as num,
      bank: json['bank'] as num,
      count: json['count'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      doctorNote: json['doctor_note'] as String,
      nurseNote: json['nurse_note'] as String,
      done: json['done'] as int,
      approval: json['approval'] as int,
      amountPaidStr: json['amountPaid'] as String,
      service: Service.fromJson(json['service'] as Map<String, dynamic>),      // Assuming you have Service class
      userRequested: User.fromJson(json['user_requested'] as Map<String, dynamic>),   // Assuming you have User class
      requestedServiceCosts: json['requested_service_costs'] as List<dynamic>,
      deposits: (json['deposits'] as List<dynamic>).map((e) => Deposit.fromJson(e as Map<String, dynamic>)).toList(),  // Define a proper type if known
    );
  }
}

// you will need to create deposit class 
class Deposit {
  final int id;
  final int requestedServiceId;
  final num amount;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final num isBank;
  final num isClaimed;
  final int shiftId;

  final User user;

  Deposit({
    required this.id,
    required this.requestedServiceId,
    required this.amount,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isBank,
    required this.isClaimed,
    required this.shiftId,
    required this.user
  });
        factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
    id: json['id'] as int,
    requestedServiceId: json['requested_service_id'] as int,
    amount: json['amount'] as num,
    userId: json['user_id'] as int,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
    isBank: json['is_bank'] as num,
    isClaimed: json['is_claimed'] as num,
    shiftId: json['shift_id'] as int,
    user: User.fromJson(json['user'] as Map<String,dynamic>),
    );
  }
}