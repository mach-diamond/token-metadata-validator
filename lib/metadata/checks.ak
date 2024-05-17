use aiken/list
use aiken/transaction.{Input, OutputReference}

pub fn has_unique_input(inputs: List<Input>, spent_utxo: OutputReference) {
  // Ensures the script is parameterized by a unique UTXO input being spent
  list.any(inputs, fn(input) { input.output_reference == spent_utxo })
}
