# Money-rails configuration for currency handling
#
# Initalizes manual exchange rates for currency conversion.

require 'money'

# Use the built-in variable exchange bank with memory storage
Money.default_bank = Money::Bank::VariableExchange.new(Money::RatesStore::Memory.new)

# Sets conversion rates between supported currencies
Money.default_bank.add_rate("USD", "EUR", 0.92)
Money.default_bank.add_rate("USD", "GBP", 0.79)
Money.default_bank.add_rate("USD", "CAD", 1.36)

Money.default_bank.add_rate("EUR", "USD", 1.09)
Money.default_bank.add_rate("EUR", "GBP", 0.86)
Money.default_bank.add_rate("EUR", "CAD", 1.48)

Money.default_bank.add_rate("GBP", "USD", 1.27)
Money.default_bank.add_rate("GBP", "EUR", 1.16)
Money.default_bank.add_rate("GBP", "CAD", 1.72)

Money.default_bank.add_rate("CAD", "USD", 0.74)
Money.default_bank.add_rate("CAD", "EUR", 0.68)
Money.default_bank.add_rate("CAD", "GBP", 0.58)

# Sets default currency
Money.default_currency = Money::Currency.new("USD")

# Sets rounding mode for currency calculations
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
