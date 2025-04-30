# circom-stdlib

This aims to be a re-written [circomlib](https://github.com/iden3/circomlib) with:
 - clear comments
 - better indentation
 - saner variable names

I wrote this to better understand `circom` and our [keyless](https://alinush.org/keyless) ZKP dependencies.

The goal is to eventually minimize our reliance on the bulky `circomlib` by switching to this.

## Dependencies

Install `circom` v2.2.2:

```
./scripts/install-circom.sh
```

## Tests

```
npm install
npm test
```

### Git hook

There is also a git hook that auto-tests compilation works upon a git commit.
To install it:

```
cp git-hooks/run-tests .git/hooks/pre-commit
```

## Is this a replacement for `circomlib`?

It would be a bit dangerous to replace the actual `circomlib` with this: what if I made a fatal typo while editing the code?

It would be nice to be able to prove equivalency of these templates against the ones in `circomlib`, since they are virtually the same.

In theory, this could be done by just compiling them to R1CS and checking they match the `circomlib` ones.
Unfortunately, the actual circom-generated R1CS file has more metadata than just the matrices and seems to change even when renaming variables.
Furthermore, we'd have to compile "families" of templates, since they are parameterized (e.g., `LessThan(N)(in)`).
Would take a while, but should be worth it to remove `circomlib` as a dependency.

## TODO

 - [ ] Next things to add from circomlib
    + `EscalarProduct` -> `InnerProduct` (or `DotProduct`)
 - [ ] Import `circom_tester` tests for `circomlib` and modify them to work with tags.
 - [ ] Automate compilation testing of templates w/o manually writing wrappers and instantiating templates for diff. parameters
    + [`circomkit`](https://github.com/erhant/circomkit) could help but does not handle tags yet
 - [ ] Correctness testing: i.e., given satisfying inputs and output signals to a template, the witgen logic generates satisfying intermediate signals
    + `circom` is not sufficient here; it only compiles
    + need `circomkit` or [`circom_tester`](https://github.com/iden3/circom_tester)
 - [x] **Cannot** test templates for soundness
    + Running the **"honest" witgen logic** for an unsatisfying assignment will typically simply fail.
    + This is not necesarily evidence that the unsatisfying assignment will not pass the constraints.
    + Why? It may be that **"malicious" witgen logic** could nonetheless generate intermediate signal values such that the unsatisfying assignment passes the constraints.
    + Testing for this is tricky; you want to test that: _"Given a (non-satisfying) statement $x\notin R$, it holds that $\forall w, R(x; w) = 0$_
    + The challenge, of course, is your tests will not typically be able to iterate through *all* possible (malicious) witnesses $w$
