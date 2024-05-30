use aiken/list
use aiken/transaction.{Input, OutputReference}
use aiken/transaction/value.{AssetName, PolicyId, Value}
use aiken/dict
use metadata/types/data.{State, ContractInfo}

pub fn has_unique_input(inputs: List<Input>, spent_utxo: OutputReference) {
  // Ensures the script is parameterized by a unique UTXO input being spent
  list.any(inputs, fn(input) { input.output_reference == spent_utxo })
}

pub fn valid_mint(
  mint: Value,
  token_policy: PolicyId,
  token_name: ByteArray,
  quantity: Int,
) -> Bool {
  expect [(mint_token_name, mint_amount)] =
    mint
      |> value.tokens(token_policy)
      |> dict.to_list()

  mint_amount == quantity && mint_token_name == token_name
}




pub fn state_initialization(
  state: State,
) -> Bool {
  True
}


pub fn state_update(
  script_state: State,
  new_script_state: State,
  mint_amnt: int,
) -> Bool {
  True
}


