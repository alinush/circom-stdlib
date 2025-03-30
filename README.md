# circom-stdlib

This aims to be a re-written [circomlib](https://github.com/iden3/circomlib) with:
 - clear comments
 - better indentation
 - saner variable names

I wrote this to better understand `circom` and our [keyless](https://alinush.org/keyless) ZKP dependencies.

The goal is to eventually minimize our reliance on the bulky `circomlib` by switching to this.

## Make sure everything compiles

You can run the following command in this directory:
```
./scripts/test-compilation.sh
```

## Notes

It would, however, be bit dangerous to replace the actual `circomlib` with this: what if I made a fatal typo while editing the code?

Would be nice to be able to prove equivalency of the templates, since they are virtually the same.

In theory, this could be done by just compiling them to R1CS and checking they match the `circomlib` ones.
Unfortunately, the actual circom-generated R1CS file has more metadata than just the matrices and seems to change even when renaming variables.
Furthermore, we'd have to compile "families" of templates, since they are parameterized (e.g., `LessThan(N)(in)`).
Would take a while, but should be worth it to remove `circomlib` as a dependency.

## Git hook

To install the git hook:

```
cp git-hooks/test-compilation .git/hooks/pre-commit
```
