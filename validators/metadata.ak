
// --- Amortized Asset Transfer Smart Contract ---------------------------------
validator(
  spent_utxo: OutputReference,
) {
  // --- Mint Validation Logic  ------------------------------------------------
  fn mint(mint_validation: MintActions, context: ScriptContext) -> Bool {
    // Get information about the transaction
    let ScriptContext { transaction, purpose } = context
    let Transaction {
      inputs,
      outputs,
      extra_signatories,
      mint,
      validity_range,
      ..
    } = transaction

    // Expect single signer
    expect [signer] = extra_signatories

    // Expect that the tx is minting
    expect Mint(script_policy_id) = purpose


    trace @"Mint Pre-Amble Complete"
    
    when mint_validation is {
      DispensingToken { action } ->
        when action is {
          MintToken -> {
            trace @"Mint Action: Mint Collateral Token"
            {
              True
            }
          }
          BurnToken -> {
            trace @"Mint Action: Burn Collateral Token"
            {
              True
            }
          }
        }
    }
  }

  // --- Spend Validation Logic  -----------------------------------------------
  fn spend(
    _datum: Data,
    spend_validation: SpendActions,
    context: ScriptContext,
  ) -> Bool {
    // Short Description: 
    //    .....

    // Get the purpose of the tx and deconstruct its primary components
    let ScriptContext { transaction, purpose } = context
    let Transaction {
      inputs,
      outputs,
      extra_signatories,
      mint,
      validity_range,
      ..
    } = transaction

    // Check that the purpose of the tx is to SPEND
    expect Spend(self_utxo_reference) = purpose

    trace @"Spend Pre-Amble Complete"

    // Selection of the logic gates for the spending behavior of the contract's UTXO 
    when spend_validation is {
      Admin { action } -> 
        trace @"Admin Spend: ..."
        {
          True
        }

      Minter { action } -> 
        trace @"Minter Spend: ..."
        {
          True
        }

    }
  }

}
