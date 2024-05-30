// use aiken/fuzz
// use metadata/state_transitions.{
//   state_update,
// }
// use metadata/tests/data.{sample_base_token, sample_owner, sample_date_range}
// use metadata/types/state.{State}
// use metadata/parameters.{}
// use metadata/util.{}
// use aiken/string.{concat, from_int}

// /// ----------------------------------------------------------------------------
// /// Test Case 1 - Base Example
// /// 
// /// ----------------------------------------------------------------------------

//   // Initial Conditions - Payment Terms ========================================
//   const principal_amt = 10_000_000_000  /// 10,000 ₳ ||  10,000,000,000 Lovelaves
//   const activation_time = 1699113600000 // ms

// fn update_state(
//   time: Int, 
//   state: State, 
//   payment: Int, 
//   balance: Int,
//   signer: ByteArray
// ) {

//   //
//   State { 
//     balance: balance, 
//   }
// }

// // Test ========================================================================
// // Nominal use case where transfer terms are satisfied.
// test sample_life_cycle_1_base() {
//   // Initialize Contract - With No Buyer Reservation ---------------------------
//   let contract_terms = PaymentTerms {
//       principal: 10_000_000_000,    // Initial value
//       apr: 375,                     // Interest rate % * 100  (ex. 5% == 500, 3.75% == 375)
//       frequency: 12,                // Payments per year
//       installments: 12,             // Length of transfer term
//       time: None,                   // Posix time
//       fees: 
//         FeeStructure {
//           late_fee: 125000000,                // 125 ADA
//           transfer_fee: 200000000,            // 200 ADA
//           transfer_fee_addr: sample_owner(1), //
//           referral_fee: 10000000,             // 10 ADA
//           referral_fee_addr: Some(sample_owner(2)), // 
//         },
//     }

//   // Initial Conditions - Buyer/Asset Info
//   let base_token = sample_base_token(1)
//   let buyer = sample_owner(2)

//   // Initialization
//   let valid = True
//   let state =
//     State {
//       buyer: None,
//       base_asset: base_token,
//       terms: contract_terms,
//       balance: principal_amt,
//       last_payment: None
//     }

//   // Accept terms and first payment
//   let (time, state, valid) = accept_loan(activation_time, state, buyer, valid)

//   // Paydown loan balance
//   let time = time + get_term_unit_length(state.terms.frequency) + 1
//   let (_, state, valid) = paydown_loan(time, state, valid)

//   trace concat(@"  Final Loan Balance: ", from_int(state.balance))

//   and {
//     state.balance == 0,
//     valid == True
//   }

// }

// /// ----------------------------------------------------------------------------
// /// Test Case 1 - Randomized Examples
// /// ----------------------------------------------------------------------------

// fn possible_initial_conditions() -> Fuzzer<(Int, Int, Int, Int, Int)> {

//   // Static
//   //let activation_time = 1699113600000

//   // Bounds
//   let min_mint  =     1
//   let max_mint  =   100

//   let mint_amnt <- fuzz.and_then(fuzz.int_between(min_mint, max_mint)) 
//   let num_years <- fuzz.map(fuzz.int_between(min_year, max_year)) 

//   (principal, interest_rate, payment_frequency, num_years)
// }

// test sample_life_cycle_1_random(param via possible_initial_conditions()) {

//   // Initial State -------------------------------------------------------------
//   let activation_time = 1699113600000 /// ms

//   // Initial Conditions - Buyer/Asset Info
//   let base_token = sample_base_token(1)
//   let buyer = sample_owner(2)

//   // Initialization
//   let valid = True
//   let state =
//     State {
//       mint: 0,
//     }

//   // Accept terms and first payment
//   let (time, state, valid) = accept_loan(activation_time, state, buyer, valid)

//   // Paydown loan balance
//   let time = time + get_term_unit_length(state.terms.frequency) + 1 /// TO DO, change to POSIX unit of FQ
//   let (_, state, valid) = paydown_loan(time, state, valid)

//   trace concat(@"  Final Mint Value: ", from_int(state.mint))

//   and {
//     state.balance == 0,
//     valid == True
//   }

// }

