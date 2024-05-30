use aiken/transaction.{
 Mint, OutputReference, ScriptContext, Spend, Transaction,
}
use metadata/types/data.{State, ContractInfo}
use metadata/types/actions.{InitialToken, MintActions, SpendActions, VendingToken, MintToken,  BurnToken, Admin, Minter}
use metadata/checks.{
  has_unique_input, valid_mint, state_initialization, state_update
}
use metadata/util.{
  get_state_update, get_contract_state
}
use aiken/transaction/value.{flatten, lovelace_of}

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
      ..
    } = transaction

    // Expect single signer
    expect [signer] = extra_signatories

    // Expect that the tx is minting
    expect Mint(script_policy_id) = purpose

    // Deconstruct the transaction into its base components:
    // Inputs, Outputs, Inline Datum, and a list of Minted Tokens
    let mint = value.from_minted_value(mint)

    trace @"Mint Preamble Complete"

    // Get the incoming script state
    let ContractInfo {state: incoming_script_state,  lovelace: amnt_input} = get_state_update(outputs, script_policy_id)
    
    when mint_validation is {

      /// Initial Token
      InitialToken { action } -> {
       when action is {
          MintToken -> {
            trace @"Mint Action: Mint Initial Token"
            {
              let isUniqueContract = has_unique_input(inputs, spent_utxo)
              let isValidInitialConditions = state_initialization(incoming_script_state)
              let initiatingTokenBeingMinted =
                valid_mint(
                  mint,
                  script_policy_id,
                  "SomeEnforcedTokenName_Initiating",
                  1,
                )

              and {
                isUniqueContract,
                isValidInitialConditions,
                initiatingTokenBeingMinted
              }
            }
          }
          BurnToken -> {
            trace @"Mint Action: Burn Initial Token"
            {
              False
            }
          }
        }
      }

      /// Vending Token
      VendingToken { action } -> {


        // Get the current script state - Note: no script state exists before Minting an initiating token
        let ContractInfo {state: script_state,  lovelace: amnt_locked} = get_contract_state(inputs, script_policy_id)


        when action is {

          MintToken -> {
            trace @"Mint Action: Mint Vending Token"

            let num_mint = 1

            let isValidStateUpdate =
              state_update(script_state, incoming_script_state, num_mint)
            let vendingTokenBeingMinted =
              valid_mint(
                mint,
                script_policy_id,
                "SomeEnforcedTokenName_Vending",
                num_mint,
              )
            and {
              isValidStateUpdate,
              vendingTokenBeingMinted
            }
          }
          
          BurnToken -> {
            trace @"Mint Action: Burn Vending Token"
            {
              True
            }
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
      mint,
      ..
    } = transaction

    // Check that the purpose of the tx is to SPEND
    expect Spend(self_utxo_reference) = purpose

    trace @"Spend Preamble Complete"

    // Selection of the logic gates for the spending behavior of the contract's UTXO 
    when spend_validation is {

      /// 
      Admin { action } -> 
        {
          trace @"Admin Spend: ..."
          True
        }

      /// 
      Minter { action } -> 
        {
          trace @"Minter Spend: ..."
          True
        }

    }
  }

}
