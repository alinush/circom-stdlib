/**
 * Author: Alin Tomescu
 */
pragma circom 2.2.2; 
 
 /**
  * Outputs a truth bit indicating whether the input number `in` is zero or not.
  *
  * Input signals:
  *   in    scalar      the input number
  *
  * Output signals:
  *   out   {binary}    the truth bit indicating if `in` is zero
  *
  * Notes:
  *   When `in` is 0, the `in * out === 0` constraint is trivially satisfied.
  *   The `1 - in * inv === out` constraint can only be satified by assigning 1
  *   to `out`. Therefore, when `in = 0`, we must have `out = 1`, as desired.
  *
  *   When `in` is non-zero, the `in * out === 0` constraint can only be
  *   satisfied by assigning 0 to `out`. But, we must also satisfy 
  *   `1 - in * inv === out`. This can be done by assigning `1/in` to `inv` 
  *   (via witness generation).
  *
  *   You'll note the beauty of the `1 - in * inv === out` constraint, if you
  *   pay attention: `in * inv` is either 1 (when `in` is non-zero) or 0 (when
  *   `in` is zero).
  */
template IsZero() {
    signal input in;

    // The inverse of `in`, when in != 0.
    // AFAICT, what we assign to inv when in = 0 does not even matter.
    signal inv <-- in != 0 ? 1/in : 0;

    signal output {binary} out <== 1 - in * inv;
    
    in * out === 0;
}