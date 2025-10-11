class CurrencyHelper {
  // Taux de change USD vers FC
  static const double USD_TO_FC_RATE = 2450.0;
  
  /// Convertit un montant de FC vers USD
  static double fcToUsd(double amountInFC) {
    return amountInFC / USD_TO_FC_RATE;
  }
  
  /// Convertit un montant de USD vers FC
  static double usdToFc(double amountInUSD) {
    return amountInUSD * USD_TO_FC_RATE;
  }
  
  /// Formate un montant selon la devise spécifiée
  static String formatAmount(double amount, String currency) {
    if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(2)}';
    } else {
      return '${amount.toStringAsFixed(0)} FC';
    }
  }
  
  /// Convertit et formate un montant depuis FC vers la devise souhaitée
  static String convertAndFormat(double amountInFC, String targetCurrency) {
    if (targetCurrency == 'USD') {
      final usdAmount = fcToUsd(amountInFC);
      return formatAmount(usdAmount, 'USD');
    } else {
      return formatAmount(amountInFC, 'FC');
    }
  }
  
  /// Affiche le taux de change
  static String getExchangeRateText() {
    return '1 USD = ${USD_TO_FC_RATE.toStringAsFixed(0)} FC';
  }
}
