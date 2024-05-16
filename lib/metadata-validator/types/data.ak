
use aiken/transaction/credential.{VerificationKey}
use aiken/hash.{Blake2b_224, Hash}

pub type VKeyHash =
  Hash<Blake2b_224, VerificationKey>     // Public key hash

pub type State {
  mint: Int,            // 
}
