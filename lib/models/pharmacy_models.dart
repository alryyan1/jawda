class Deduct {
  final int id;
  final int shiftId;
  final int userId;
  final int paymentTypeId;
  final int complete;
  final double totalAmountReceived;
  final int number;
  final String? notes;
  final int isSell;
  final int? clientId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isPostpaid;
  final int postpaidComplete;
  final DateTime? postpaidDate;
  final double discount;
  final double paid;
  final int? doctorvisitId;
  final int? endurancePercentage;
  final int? userPaid;
  final double totalPrice;
  final double profit;
  final double cost;
  final double totalPriceUnpaid;
  final double totalPaid;
  final int calculateTax;
  final String itemsConcatenated;
  final List<DeductItem> deductedItems;
  final PaymentType paymentType;
  final User user;
  final dynamic
      client; // You might want to create a Client model if the structure is known
  final dynamic
      doctorvisit; // You might want to create a Doctorvisit model if the structure is known

  Deduct({
    required this.id,
    required this.shiftId,
    required this.userId,
    required this.paymentTypeId,
    required this.complete,
    required this.totalAmountReceived,
    required this.number,
    this.notes,
    required this.isSell,
    this.clientId,
    required this.createdAt,
    required this.updatedAt,
    required this.isPostpaid,
    required this.postpaidComplete,
    this.postpaidDate,
    required this.discount,
    required this.paid,
    this.doctorvisitId,
    this.endurancePercentage,
    this.userPaid,
    required this.totalPrice,
    required this.profit,
    required this.cost,
    required this.totalPriceUnpaid,
    required this.totalPaid,
    required this.calculateTax,
    required this.itemsConcatenated,
    required this.deductedItems,
    required this.paymentType,
    required this.user,
    this.client,
    this.doctorvisit,
  });

  factory Deduct.fromJson(Map<String, dynamic> json) {
    return Deduct(
      id: json['id'] as int,
      shiftId: json['shift_id'] as int,
      userId: json['user_id'] as int,
      paymentTypeId: json['payment_type_id'] as int,
      complete: json['complete'] as int,
      totalAmountReceived: (json['total_amount_received'] as num).toDouble(),
      number: json['number'] as int,
      notes: json['notes'] as String?,
      isSell: json['is_sell'] as int,
      clientId: json['client_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isPostpaid: json['is_postpaid'] as int,
      postpaidComplete: json['postpaid_complete'] as int,
      postpaidDate: json['postpaid_date'] != null
          ? DateTime.parse(json['postpaid_date'] as String)
          : null,
      discount: (json['discount'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      doctorvisitId: json['doctorvisit_id'] as int?,
      endurancePercentage: json['endurance_percentage'] as int?,
      userPaid: json['user_paid'] ,
      totalPrice: (json['total_price'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      totalPriceUnpaid: (json['total_price_unpaid'] as num).toDouble(),
      totalPaid: (json['total_paid'] as num).toDouble(),
      calculateTax: json['calculateTax'] as int,
      itemsConcatenated: json['itemsConcatenated'] as String,
      deductedItems: (json['deducted_items'] as List<dynamic>)
          .map((item) => DeductItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      paymentType:
          PaymentType.fromJson(json['payment_type'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      client: json['client'],
      doctorvisit: json['doctorvisit'],
    );
  }
}

class DeductItem {
  final int id;
  final int shiftId;
  final int userId;
  final int deductId;
  final int itemId;
  final int? clientId;
  final int strips;
  final int box;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double discount;
  final Item? item;
  final dynamic client;

  DeductItem({
    required this.id,
    required this.shiftId,
    required this.userId,
    required this.deductId,
    required this.itemId,
    this.clientId,
    required this.strips,
    required this.box,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.discount,
    required this.item,
    this.client,
  });

  factory DeductItem.fromJson(Map<String, dynamic> json) {
    return DeductItem(
      id: json['id'] as int,
      shiftId: json['shift_id'] as int,
      userId: json['user_id'] as int,
      deductId: json['deduct_id'] as int,
      itemId: json['item_id'] as int,
      clientId: json['client_id'] as int?,
      strips: json['strips'] as int,
      box: json['box'] as int,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      discount: (json['discount'] as num).toDouble(),
      item: json['item'] != null
          ? Item.fromJson(json['item'] as Map<String, dynamic>)
          : null,
      client: json['client'],
    );
  }
}

class Item {
  final int id;
  final int? sectionId;
  final String name;
  final int requireAmount;
  final double initialBalance;
  final double initialPrice;
  final int tests;
  final String expire;
  final double costPrice;
  final double sellPrice;
  final dynamic drugCategoryId;
  final dynamic pharmacyTypeId;
  final String barcode;
  final int strips;
  final String scName;
  final String marketName;
  final String? batch;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String unit;
  final String active1;
  final String active2;
  final String active3;
  final String packSize;
  final int approvedRp;
  final DepositItem? lastDepositItem;
  final dynamic section;
  final dynamic category;
  final dynamic type;
  final DepositItem? depositItem;

  Item({
    required this.id,
    this.sectionId,
    required this.name,
    required this.requireAmount,
    required this.initialBalance,
    required this.initialPrice,
    required this.tests,
    required this.expire,
    required this.costPrice,
    required this.sellPrice,
    this.drugCategoryId,
    this.pharmacyTypeId,
    required this.barcode,
    required this.strips,
    required this.scName,
    required this.marketName,
    required this.batch,
    required this.createdAt,
    required this.updatedAt,
    required this.unit,
    required this.active1,
    required this.active2,
    required this.active3,
    required this.packSize,
    required this.approvedRp,
    this.lastDepositItem,
    this.section,
    this.category,
    this.type,
    required this.depositItem,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      sectionId: json['section_id'] as int?,
      name: json['name'] as String,
      requireAmount: json['require_amount'] as int,
      initialBalance: (json['initial_balance'] as num).toDouble(),
      initialPrice: (json['initial_price'] as num).toDouble(),
      tests: json['tests'] as int,
      expire: json['expire'] as String,
      costPrice: (json['cost_price'] as num).toDouble(),
      sellPrice: (json['sell_price'] as num).toDouble(),
      drugCategoryId: json['drug_category_id'],
      pharmacyTypeId: json['pharmacy_type_id'],
      barcode: json['barcode'] as String,
      strips: json['strips'] as int,
      scName: json['sc_name'] as String,
      marketName: json['market_name'] as String,
      batch: json['batch'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      unit: json['unit'] as String,
      active1: json['active1'] as String,
      active2: json['active2'] as String,
      active3: json['active3'] as String,
      packSize: json['pack_size'] as String,
      approvedRp: json['approved_rp'] as int,
      lastDepositItem: json['lastDepositItem'] != null
          ? DepositItem.fromJson(
              json['lastDepositItem'] as Map<String, dynamic>)
          : null,
      section: json['section'],
      category: json['category'],
      type: json['type'],
      depositItem: json['deposit_item'] != null
          ? DepositItem.fromJson(json['deposit_item'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DepositItem {
  final int id;
  final int itemId;
  final int depositId;
  final int quantity;
  final double cost;
  final String? batch;
  final DateTime? expire;
  final String? notes;
  final String? barcode;
  final int returned;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double sellPrice;
  final double vatCost;
  final double vatSell;
  final int freeQuantity;
  final double finalSellPrice;
  final double finalCostPrice;

  DepositItem({
    required this.id,
    required this.itemId,
    required this.depositId,
    required this.quantity,
    required this.cost,
    this.batch,
    required this.expire,
    this.notes,
    this.barcode,
    required this.returned,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.sellPrice,
    required this.vatCost,
    required this.vatSell,
    required this.freeQuantity,
    required this.finalSellPrice,
    required this.finalCostPrice,
  });

  factory DepositItem.fromJson(Map<String, dynamic> json) {
    return DepositItem(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      depositId: json['deposit_id'] as int,
      quantity: json['quantity'] as int,
      cost: (json['cost'] as num).toDouble(),
      batch: json['batch'] as String?,
      expire: json['expire'] != null ? DateTime.parse(json['expire']) : null,
      notes: json['notes'] as String?,
      barcode: json['barcode'] as String?,
      returned: json['return'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sellPrice: (json['sell_price'] as num).toDouble(),
      vatCost: (json['vat_cost'] as num).toDouble(),
      vatSell: (json['vat_sell'] as num).toDouble(),
      freeQuantity: json['free_quantity'] as int,
      finalSellPrice: (json['finalSellPrice'] as num).toDouble(),
      finalCostPrice: (json['finalCostPrice'] as num).toDouble(),
    );
  }
}

class Deposit {
  final int id;
  final int supplierId;
  final String billNumber;
  final String billDate;
  final int complete;
  final int paid;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String paymentMethod;
  final double discount;
  final double vatSell;
  final double vatCost;
  final int isLocked;
  final int showAll;
  final Supplier supplier;
  final User user;

  Deposit({
    required this.id,
    required this.supplierId,
    required this.billNumber,
    required this.billDate,
    required this.complete,
    required this.paid,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethod,
    required this.discount,
    required this.vatSell,
    required this.vatCost,
    required this.isLocked,
    required this.showAll,
    required this.supplier,
    required this.user,
  });

  factory Deposit.fromJson(Map<String, dynamic> json) {
    return Deposit(
      id: json['id'] as int,
      supplierId: json['supplier_id'] as int,
      billNumber: json['bill_number'] as String,
      billDate: json['bill_date'] as String,
      complete: json['complete'] as int,
      paid: json['paid'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      paymentMethod: json['payment_method'] as String,
      discount: (json['discount'] as num).toDouble(),
      vatSell: (json['vat_sell'] as num).toDouble(),
      vatCost: (json['vat_cost'] as num).toDouble(),
      isLocked: json['is_locked'] as int,
      showAll: json['showAll'] as int,
      supplier: Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class Supplier {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class User {
  final int id;
  final String username;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic doctorId;
  final int isNurse;
  final String name;
  final bool isAdmin;
  final bool isAccountant;
  final bool canPayLab;
  final List<Role> roles;
  final List<dynamic> routes;
  final List<dynamic> subRoutes;
  final dynamic doctor;
  final List<dynamic> permissions;

  User({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.doctorId,
    required this.isNurse,
    required this.name,
    required this.isAdmin,
    required this.isAccountant,
    required this.canPayLab,
    required this.roles,
    required this.routes,
    required this.subRoutes,
    this.doctor,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      doctorId: json['doctor_id'],
      isNurse: json['is_nurse'] as int,
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool,
      isAccountant: json['isAccountant'] as bool,
      canPayLab: json['canPayLab'] as bool,
      roles: (json['roles'] as List<dynamic>)
          .map((item) => Role.fromJson(item as Map<String, dynamic>))
          .toList(),
      routes: json['routes'] as List<dynamic>,
      subRoutes: json['sub_routes'] as List<dynamic>,
      doctor: json['doctor'],
      permissions: json['permissions'] as List<dynamic>,
    );
  }
}

class Role {
  final int id;
  final String name;
  final String guardName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
      guardName: json['guard_name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class PaymentType {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentType({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}
