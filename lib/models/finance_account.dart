class FinanceAccount {
  final int id;
  final String name;
  final String debit;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String code;
  final double balance;
  final double childrenBalance;
  final double grandChildrenBalance;
  final double totalBalance;
  final List<Credit> credits;
  final List<Debit> debits; // Use dynamic if the structure isn't known
  final List<FinanceAccount> children;

  FinanceAccount({
    required this.id,
    required this.name,
    required this.debit,
    this.description,
    this.createdAt,
    this.updatedAt,
    required this.code,
    required this.balance,
    required this.childrenBalance,
    required this.grandChildrenBalance,
    required this.totalBalance,
    required this.credits,
    required this.debits,
    required this.children,
  });

  factory FinanceAccount.fromJson(Map<String, dynamic> json) {
    return FinanceAccount(
      id: json['id'] as int,
      name: json['name'] as String,
      debit: json['debit'] as String,
      description: json['description'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      code: json['code'] as String,
      balance: (json['balance'] as num).toDouble(),
      childrenBalance: (json['childrenBalance'] as num).toDouble(),
      grandChildrenBalance: (json['grandChildrenBalance'] as num).toDouble(),
      totalBalance: (json['totalBalance'] as num).toDouble(),
      credits: (json['credits'] as List<dynamic>).map((item) => Credit.fromJson(item)).toList(),
      debits: (json['debits'] as List<dynamic>).map((e) => Debit.fromJson(e)).toList(),
      children: (json['children'] as List<dynamic>).map((item) => FinanceAccount.fromJson(item)).toList(),
    );
  }
}

class Credit {
  final int id;
  final int financeAccountId;
  final int financeEntryId;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FinanceEntry? entry;
  final FinanceAccount? account;

  Credit({
    required this.id,
    required this.financeAccountId,
    required this.financeEntryId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.entry,
    required this.account,
  });

  factory Credit.fromJson(Map<String, dynamic> json) {
    return Credit(
      id: json['id'] as int,
      financeAccountId: json['finance_account_id'] as int,
      financeEntryId: json['finance_entry_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      account: json['account'] !=null ? FinanceAccount.fromJson(json['account'] as Map<String, dynamic> ) :null,
      entry: json['entry']!=null ? FinanceEntry.fromJson(json['entry'] as Map<String, dynamic> ):null,

    );
  }
}
class Debit {
  final int id;
  final int financeAccountId;
  final int financeEntryId;
  final double amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FinanceEntry? entry;
  final FinanceAccount? account;

  Debit({
    required this.id,
    required this.financeAccountId,
    required this.financeEntryId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.entry,
        required this.account,
    
  });

  factory Debit.fromJson(Map<String, dynamic> json) {
    return Debit(
      id: json['id'] as int,
      financeAccountId: json['finance_account_id'] as int,
      financeEntryId: json['finance_entry_id'] as int,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      entry: json['entry']!=null ? FinanceEntry.fromJson(json['entry'] as Map<String, dynamic> ):null,
      account: json['account'] != null ? FinanceAccount.fromJson(json['account'] as Map<String, dynamic>) :null,
    );
  }
}

class FinanceEntry {
  DateTime createdAt;
  DateTime updatedAt;
  String description;
  final List<Debit> debit;
  final List<Credit> credit;
  int id;
  FinanceEntry({
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.id,
    required this.debit,
    required this.credit,
  });
  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String,
       debit: (json['debit'] as List<dynamic>).map((item) => Debit.fromJson(item)).toList(),
      credit: (json['credit'] as List<dynamic>).map((item) => Credit.fromJson(item)).toList(),
      id: json['id'] as int,
    );
  }
}